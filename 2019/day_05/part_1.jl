include("../Intcode.jl")

function main()
    program = parse.(Int, split(read(stdin, String), ","))
    computer = Intcode.Computer(program, input_values=[1])

    Intcode.run!(computer)
    @assert Intcode.is_halted(computer)

    while length(computer.output_queue) >= 2
        output = popfirst!(computer.output_queue)
        @assert output == 0
    end

    println(pop!(computer.output_queue))
end

main()
