using(Combinatorics)

include("../Intcode.jl")

function run_amplifiers(program, phases)
    computers = [
        Intcode.Computer(program; input_values=[phase])
        for phase in phases
    ]

    # Feedback loop
    for i = 1:length(computers)
        j = mod(i + 1, 1:length(computers))
        computers[i].output_queue = computers[j].input_queue
    end

    push!(first(computers).input_queue, 0)

    while any(!Intcode.is_halted(computer) for computer in computers)
        for computer in computers
            Intcode.run!(computer)
        end
    end

    @assert all(Intcode.is_halted(computer) for computer in computers)
    popfirst!(last(computers).output_queue)
end

function main()
    program = parse.(Int, split(strip(read(stdin, String)), ","))

    println(maximum(
        run_amplifiers(program, phases)
        for phases in permutations([5, 6, 7, 8, 9])))
end

main()
