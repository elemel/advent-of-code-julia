include("../Intcode.jl")

function main()
    program = parse.(Int, split(read(stdin, String), ","))
    machine = Intcode.Machine(program, input_values=[1])

    Intcode.run!(machine)
    @assert Intcode.is_halted(machine)

    while length(machine.output_queue) >= 2
        output = popfirst!(machine.output_queue)
        @assert output == 0
    end

    println(pop!(machine.output_queue))
end

main()
