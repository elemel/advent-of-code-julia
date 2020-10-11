using OffsetArrays

module Opcodes

const ADD = 1
const MULTIPLY = 2
const HALT = 99

end # module Opcodes

mutable struct Process
    memory::OffsetArray{Int}
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
end

function multiply(process)
    a = process.memory[process.ip + 1]
    b = process.memory[process.ip + 2]
    c = process.memory[process.ip + 3]

    process.memory[c] = process.memory[a] * process.memory[b]
    process.ip += 4
end

end # module Operations

const OPCODE_TO_OPERATION = Dict(
    Opcodes.ADD => Operations.add,
    Opcodes.MULTIPLY => Operations.multiply,
)

function run(process)
    while !halted(process)
        opcode = process.memory[process.ip]
        operation = OPCODE_TO_OPERATION[opcode]
        operation(process)
    end
end

function main()
    program = parse.(Int, split(read(stdin, String), ","))

    for noun = 0:99
        for verb = 0:99
            process = Process(program)

            process.memory[1] = noun
            process.memory[2] = verb

            run(process)

            if process.memory[0] == 19690720
                println(100 * noun + verb)
                return
            end
        end
    end
end

main()
