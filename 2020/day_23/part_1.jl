function remove_cup(cup, previous_cups, next_cups)
    previous_cup = previous_cups[cup]
    next_cup = next_cups[cup]

    @assert previous_cup != 0 && next_cup != 0

    next_cups[previous_cup] = next_cup
    previous_cups[cup] = 0
    next_cups[cup] = 0
    previous_cups[next_cup] = previous_cup

    return cup
end

function insert_cup_after(cup, previous_cup, previous_cups, next_cups)
    @assert previous_cups[cup] == 0 && next_cups[cup] == 0
    next_cup = next_cups[previous_cup]

    next_cups[previous_cup] = cup
    previous_cups[cup] = previous_cup
    next_cups[cup] = next_cup
    previous_cups[next_cup] = cup
end

function get_cups(first_cup, cup_count, next_cups)
    cup = first_cup
    cups = []

    while length(cups) < cup_count
        push!(cups, cup)
        cup = next_cups[cup]
    end

    return cups
end

function main()
    input = readlines(stdin)
    cups = parse.(Int, collect(input[1]))
    max_cup = maximum(cups)

    previous_cups = zeros(Int, max_cup)
    next_cups = zeros(Int, max_cup)

    for (i, cup) in enumerate(cups)
        previous_cups[cup] = cups[mod(i - 1, 1:max_cup)]
        next_cups[cup] = cups[mod(i + 1, 1:max_cup)]
    end

    current_cup = cups[1]

    for move in 1:100
        a = remove_cup(next_cups[current_cup], previous_cups, next_cups)
        b = remove_cup(next_cups[current_cup], previous_cups, next_cups)
        c = remove_cup(next_cups[current_cup], previous_cups, next_cups)

        destination_cup = mod(current_cup - 1, 1:max_cup)

        while destination_cup in (a, b, c)
            destination_cup = mod(destination_cup - 1, 1:max_cup)
        end

        insert_cup_after(c, destination_cup, previous_cups, next_cups)
        insert_cup_after(b, destination_cup, previous_cups, next_cups)
        insert_cup_after(a, destination_cup, previous_cups, next_cups)

        current_cup = next_cups[current_cup]
    end

    answer = join(string.(get_cups(next_cups[1], 8, next_cups)))
    println(answer)
end

main()
