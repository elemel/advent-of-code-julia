module Intcode

using OffsetArrays

module Opcodes

const ADD = 1
const MULTIPLY = 2
const HALT = 99

end # module Opcodes

mutable struct Process
    # Zero-based indexing
    memory::OffsetArray{Int}

    # Instruction pointer
    ip::Int

    function Process(program::Array{Int}; ip::Int=0)
        axis = 0:(length(program) - 1)
        memory = OffsetArray(copy(program), 0:(length(program) - 1))
        new(memory, ip)
    end
end

function halted(process)
    process.memory[process.ip] == Opcodes.HALT
end

module Operations

function add(process)
    a = process.memory[process.ip + 1]
    b = process.memory[process.ip + 2]
    c = process.memory[process.ip + 3]

    process.memory[c] = process.memory[a] + process.memory[b]
    process.ip += 4
    nothing
end

function multiply(process)
    a = process.memory[process.ip + 1]
    b = process.memory[process.ip + 2]
    c = process.memory[process.ip + 3]

    process.memory[c] = process.memory[a] * process.memory[b]
    process.ip += 4
    nothing
end

end # module Operations

const OPCODE_TO_OPERATION = Dict(
    Opcodes.ADD => Operations.add,
    Opcodes.MULTIPLY => Operations.multiply,
)

function step(process)
    if halted(process)
        return false
    end

    opcode = process.memory[process.ip]
    operation = OPCODE_TO_OPERATION[opcode]
    operation(process)
    true
end

function run(process)
    while step(process)
    end
end

end # module Intcode
