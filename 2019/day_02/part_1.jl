include("../Intcode.jl")

function main()
    program = parse.(Int, split(read(stdin, String), ","))
    machine = Intcode.Machine(program)

    machine.memory[1] = 12
    machine.memory[2] = 2

    Intcode.run!(machine)
    @assert Intcode.is_halted(machine)

    println(machine.memory[0])
end

main()