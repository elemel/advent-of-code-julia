include("../Intcode.jl")

function main()
    program = parse.(Int, split(read(stdin, String), ","))
    computer = Intcode.Computer(program, input_values=[5])

    Intcode.run!(computer)
    @assert Intcode.is_halted(computer)
    println(pop!(computer.output_queue))
end

main()
