using(Combinatorics)

include("../Intcode.jl")

function run_amplifiers(program, phases)
    computers = [
        Intcode.Computer(program; input_values=[phase])
        for phase in phases
    ]

    for i in 1:(length(computers) - 1)
        computers[i].output_queue = computers[i + 1].input_queue
    end

    push!(first(computers).input_queue, 0)

    for computer in computers
        Intcode.run!(computer)
        @assert Intcode.is_halted(computer)
    end

    popfirst!(last(computers).output_queue)
end

function main()
    program = parse.(Int, split(strip(read(stdin, String)), ","))

    println(maximum(
        run_amplifiers(program, phases)
        for phases in permutations([0, 1, 2, 3, 4])))
end

main()
