include("../Intcode.jl")

using .Intcode

function main()
    program = compile(read(stdin, String))
    computer = Computer(program)

    computer.memory[1] = 12
    computer.memory[2] = 2

    run!(computer)
    @assert is_halted(computer)

    println(computer.memory[0])
end

main()
