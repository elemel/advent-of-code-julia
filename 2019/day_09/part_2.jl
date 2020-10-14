include("../Intcode.jl")

function main()
    program = parse.(Int, split(strip(read(stdin, String)), ","))

    computer = Intcode.Computer(program, memory_size=2048, input_values=[2])
    Intcode.run!(computer)
    @assert Intcode.is_halted(computer)
    @assert length(computer.output_queue) == 1
    println(popfirst!(computer.output_queue))
end

main()
