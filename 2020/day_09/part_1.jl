const PREAMBLE_SIZE = 25

function main()
    input = readlines(stdin)
    numbers = parse.(Int, input)
    answer = first(
        numbers[i]
        for i in PREAMBLE_SIZE + 1 : length(numbers)
            if !any(numbers[j] != numbers[k] &&
                sum(numbers[j] + numbers[k]) == numbers[i]
                for j in i - PREAMBLE_SIZE : i - 1
                    for k in i - PREAMBLE_SIZE : i - 1))
    println(answer)
end

main()
