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
const ADJUST_RELATIVE_BASE = 9
const HALT = 99

end # module Opcodes

module ParameterModes

const POSITION = 0
const IMMEDIATE = 1
const RELATIVE = 2

end # module ParameterModes

mutable struct Computer
    # Zero-based indexing
    memory::OffsetArray{Int}

    instruction_pointer::Int
    relative_base::Int

    input_queue::Deque{Int}
    output_queue::Deque{Int}

    function Computer(
        program=[];
        memory_size=0,

        instruction_pointer=0,
        relative_base=0,

        input_values=[],
        output_values=[])

        computer = new()

        computer.instruction_pointer = instruction_pointer
        computer.relative_base = relative_base

        computer.memory = OffsetArray(Array{Int}(program), -1)

        if memory_size > length(computer.memory)
            append!(
                computer.memory, zeros(memory_size - length(computer.memory)))
        end

        computer.input_queue = Deque{Int}()
        computer.output_queue = Deque{Int}()

        foreach(value -> push!(computer.input_queue, value), input_values)
        foreach(value -> push!(computer.output_queue, value), output_values)

        computer
    end
end

function is_halted(computer::Computer)::Bool
    computer.memory[computer.instruction_pointer] == Opcodes.HALT
end

function is_blocked(computer::Computer)::Bool
    computer.memory[computer.instruction_pointer] == Opcodes.INPUT &&
        isempty(computer.input_queue)
end

function load(computer::Computer, parameter::Int)::Int
    modes = computer.memory[computer.instruction_pointer]
    divisor = 10 ^ (parameter + 1)
    mode = mod(fld(modes, divisor), 10)

    if mode == ParameterModes.POSITION
        address = computer.memory[computer.instruction_pointer + parameter]
        computer.memory[address]
    elseif mode == ParameterModes.IMMEDIATE
        computer.memory[computer.instruction_pointer + parameter]
    elseif mode == ParameterModes.RELATIVE
        address = (
            computer.memory[computer.instruction_pointer + parameter] +
            computer.relative_base)

        computer.memory[address]
    else
        throw(ParameterModeError())
    end
end

function store!(computer::Computer, parameter::Int, value::Int)::Nothing
    modes = computer.memory[computer.instruction_pointer]
    divisor = 10 ^ (parameter + 1)
    mode = mod(fld(modes, divisor), 10)

    if mode == ParameterModes.POSITION
        address = computer.memory[computer.instruction_pointer + parameter]
        computer.memory[address] = value
    elseif mode == ParameterModes.RELATIVE
        address = (
            computer.memory[computer.instruction_pointer + parameter] +
            computer.relative_base)

        computer.memory[address] = value
    else
        throw(ParameterModeError())
    end

    nothing
end

module Operations

import ..BlockError
import ..HaltError
import ..Computer

import ..load
import ..store!

function add!(computer::Computer)::Nothing
    left = load(computer, 1)
    right = load(computer, 2)

    result = left + right
    store!(computer, 3, result)

    computer.instruction_pointer += 4
    nothing
end

function adjust_relative_base!(computer::Computer)::Nothing
    computer.relative_base += load(computer, 1)
    computer.instruction_pointer += 2
    nothing
end

function equals!(computer::Computer)::Nothing
    left = load(computer, 1)
    right = load(computer, 2)

    result = Int(left == right)
    store!(computer, 3, result)

    computer.instruction_pointer += 4
    nothing
end

function halt(computer::Computer)::Nothing
    throw(HaltError())
end

function input!(computer::Computer)::Nothing
    if isempty(computer.input_queue)
        throw(BlockError())
    end

    value = popfirst!(computer.input_queue)
    store!(computer, 1, value)

    computer.instruction_pointer += 2
    nothing
end

function jump_if_false!(computer::Computer)::Nothing
    condition = load(computer, 1)
    target = load(computer, 2)

    if condition == 0
        computer.instruction_pointer = target
    else
        computer.instruction_pointer += 3
    end

    nothing
end

function jump_if_true!(computer::Computer)::Nothing
    condition = load(computer, 1)
    target = load(computer, 2)

    if condition != 0
        computer.instruction_pointer = target
    else
        computer.instruction_pointer += 3
    end

    nothing
end

function less_than!(computer::Computer)::Nothing
    left = load(computer, 1)
    right = load(computer, 2)

    result = Int(left < right)
    store!(computer, 3, result)

    computer.instruction_pointer += 4
    nothing
end

function multiply!(computer::Computer)::Nothing
    left = load(computer, 1)
    right = load(computer, 2)

    result = left * right
    store!(computer, 3, result)

    computer.instruction_pointer += 4
    nothing
end

function output!(computer::Computer)::Nothing
    value = load(computer, 1)
    push!(computer.output_queue, value)

    computer.instruction_pointer += 2
    nothing
end

end # module Operations

const OPCODE_TO_OPERATION = Dict(
    Opcodes.ADD => Operations.add!,
    Opcodes.ADJUST_RELATIVE_BASE => Operations.adjust_relative_base!,
    Opcodes.EQUALS => Operations.equals!,
    Opcodes.HALT => Operations.halt,
    Opcodes.INPUT => Operations.input!,
    Opcodes.JUMP_IF_FALSE => Operations.jump_if_false!,
    Opcodes.JUMP_IF_TRUE => Operations.jump_if_true!,
    Opcodes.LESS_THAN => Operations.less_than!,
    Opcodes.MULTIPLY => Operations.multiply!,
    Opcodes.OUTPUT => Operations.output!,
)

function step!(computer::Computer)::Nothing
    opcode = mod(computer.memory[computer.instruction_pointer], 100)
    operation = OPCODE_TO_OPERATION[opcode]
    operation(computer)
    nothing
end

function try_step!(computer::Computer)::Bool
    try
        step!(computer)
        true
    catch e
        if !isa(e, ControlError)
            throw(e)
        end

        false
    end
end

function run!(computer::Computer)::Int
    operation_count = 0

    try
        while true
            step!(computer)
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
