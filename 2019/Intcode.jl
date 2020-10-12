module Intcode

using DataStructures
using OffsetArrays

abstract type ControlError <: Exception end

struct BlockError <: ControlError end
struct HaltError <: ControlError end

struct ParameterModeError <: Exception end

module Opcodes

const ADD = 1
const MULTIPLY = 2
const INPUT = 3
const OUTPUT = 4
const JUMP_IF_TRUE = 5
const JUMP_IF_FALSE = 6
const LESS_THAN = 7
const EQUALS = 8
const HALT = 99

end # module Opcodes

module ParameterModes

const POSITION = 0
const IMMEDIATE = 1

end # module ParameterModes

mutable struct Machine
    instruction_pointer::Int

    # Zero-based indexing
    memory::OffsetArray{Int}

    input_queue::Deque{Int}
    output_queue::Deque{Int}

    function Machine(
        program=[];
        instruction_pointer=0,
        input_values=[],
        output_values=[])

        machine = new()
        machine.instruction_pointer = instruction_pointer
        machine.memory = OffsetArray(Array{Int}(program), -1)

        machine.input_queue = Deque{Int}()
        machine.output_queue = Deque{Int}()

        foreach(value -> push!(machine.input_queue, value), input_values)
        foreach(value -> push!(machine.output_queue, value), output_values)

        machine
    end
end

function is_halted(machine::Machine)::Bool
    machine.memory[machine.instruction_pointer] == Opcodes.HALT
end

function is_blocked(machine::Machine)::Bool
    machine.memory[machine.instruction_pointer] == Opcodes.INPUT &&
        isempty(machine.input_queue)
end

function load(machine::Machine, parameter::Int)::Int
    modes = machine.memory[machine.instruction_pointer]
    divisor = 10 ^ (parameter + 1)
    mode = mod(fld(modes, divisor), 10)

    if mode == ParameterModes.POSITION
        address = machine.memory[machine.instruction_pointer + parameter]
        machine.memory[address]
    elseif mode == ParameterModes.IMMEDIATE
        machine.memory[machine.instruction_pointer + parameter]
    else
        throw(ParameterModeError())
    end
end

function store!(machine::Machine, parameter::Int, value::Int)::Nothing
    modes = machine.memory[machine.instruction_pointer]
    divisor = 10 ^ (parameter + 1)
    mode = mod(fld(modes, divisor), 10)

    if mode == ParameterModes.POSITION
        address = machine.memory[machine.instruction_pointer + parameter]
        machine.memory[address] = value
    else
        throw(ParameterModeError())
    end

    nothing
end

module Operations

import ..BlockError
import ..HaltError
import ..Machine

import ..load
import ..store!

function add!(machine::Machine)::Nothing
    left = load(machine, 1)
    right = load(machine, 2)

    result = left + right
    store!(machine, 3, result)

    machine.instruction_pointer += 4
    nothing
end

function equals!(machine::Machine)::Nothing
    left = load(machine, 1)
    right = load(machine, 2)

    result = Int(left == right)
    store!(machine, 3, result)

    machine.instruction_pointer += 4
    nothing
end

function halt(machine::Machine)::Nothing
    throw(HaltError())
end

function input!(machine::Machine)::Nothing
    if isempty(machine.input_queue)
        throw(BlockError())
    end

    value = popfirst!(machine.input_queue)
    store!(machine, 1, value)

    machine.instruction_pointer += 2
    nothing
end

function jump_if_false!(machine::Machine)::Nothing
    condition = load(machine, 1)
    target = load(machine, 2)

    if condition == 0
        machine.instruction_pointer = target
    else
        machine.instruction_pointer += 3
    end

    nothing
end

function jump_if_true!(machine::Machine)::Nothing
    condition = load(machine, 1)
    target = load(machine, 2)

    if condition != 0
        machine.instruction_pointer = target
    else
        machine.instruction_pointer += 3
    end

    nothing
end

function less_than!(machine::Machine)::Nothing
    left = load(machine, 1)
    right = load(machine, 2)

    result = Int(left < right)
    store!(machine, 3, result)

    machine.instruction_pointer += 4
    nothing
end

function multiply!(machine::Machine)::Nothing
    left = load(machine, 1)
    right = load(machine, 2)

    result = left * right
    store!(machine, 3, result)

    machine.instruction_pointer += 4
    nothing
end

function output!(machine::Machine)::Nothing
    value = load(machine, 1)
    push!(machine.output_queue, value)

    machine.instruction_pointer += 2
    nothing
end

end # module Operations

const OPCODE_TO_OPERATION = Dict(
    Opcodes.ADD => Operations.add!,
    Opcodes.EQUALS => Operations.equals!,
    Opcodes.HALT => Operations.halt,
    Opcodes.INPUT => Operations.input!,
    Opcodes.JUMP_IF_FALSE => Operations.jump_if_false!,
    Opcodes.JUMP_IF_TRUE => Operations.jump_if_true!,
    Opcodes.LESS_THAN => Operations.less_than!,
    Opcodes.MULTIPLY => Operations.multiply!,
    Opcodes.OUTPUT => Operations.output!,
)

function step!(machine::Machine)::Nothing
    opcode = mod(machine.memory[machine.instruction_pointer], 100)
    operation = OPCODE_TO_OPERATION[opcode]
    operation(machine)
    nothing
end

function try_step!(machine::Machine)::Bool
    try
        step!(machine)
        true
    catch e
        if !isa(e, ControlError)
            throw(e)
        end

        false
    end
end

function run!(machine::Machine)::Int
    operation_count = 0

    try
        while true
            step!(machine)
            operation_count += 1
        end
    catch e
        if !isa(e, ControlError)
            throw(e)
        end

        operation_count
    end
end

end # module Intcode
