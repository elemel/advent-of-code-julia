function main()
    input = readlines(stdin)
    starting_numbers = parse.(Int, split(input[1], ","))
    memory = Dict{Int, Int}()
    previous_number = 0

    for turn in 1:30000000
        if turn <= length(starting_numbers)
            number = starting_numbers[turn]
        elseif !haskey(memory, previous_number)
            number = 0
        else
            number = turn - 1 - memory[previous_number]
        end

        memory[previous_number] = turn - 1
        previous_number = number
    end

    answer = previous_number
    println(answer)
end

main()
