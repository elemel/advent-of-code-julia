include("../Intcode.jl")

function main()
    program = parse.(Int, split(read(stdin, String), ","))
    machine = Intcode.Machine(program, input_values=[5])

    Intcode.run!(machine)
    @assert Intcode.is_halted(machine)
    println(pop!(machine.output_queue))
end

main()
