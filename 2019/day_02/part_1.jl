include("../Intcode.jl")

function main()
    program = parse.(Int, split(strip(read(stdin, String)), ","))
    computer = Intcode.Computer(program)

    computer.memory[1] = 12
    computer.memory[2] = 2

    Intcode.run!(computer)
    @assert Intcode.is_halted(computer)

    println(computer.memory[0])
end

main()
