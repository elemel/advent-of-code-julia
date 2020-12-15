function main()
    input = readlines(stdin)
    starting_numbers = parse.(Int, split(input[1], ","))
    memory = Dict{Int, Int}()
    answer = 0

    for turn in 1:2020
        if turn <= length(starting_numbers)
            number = starting_numbers[turn]
        elseif !haskey(memory, answer)
            number = 0
        else
            number = turn - 1 - memory[answer]
        end

        memory[answer] = turn - 1
        answer = number
    end

    println(answer)
end

main()
