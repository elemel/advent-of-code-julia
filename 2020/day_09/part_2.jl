const PREAMBLE_SIZE = 25

function main()
    input = readlines(stdin)
    numbers = parse.(Int, input)
    invalid_number = first(
        numbers[i]
        for i in PREAMBLE_SIZE + 1 : length(numbers)
            if !any(numbers[j] != numbers[k] &&
                sum(numbers[j] + numbers[k]) == numbers[i]
                for j in i - PREAMBLE_SIZE : i - 1
                    for k in i - PREAMBLE_SIZE : i - 1))
    sums = cumsum(numbers)
    answer = first(
        minimum(numbers[m] for m in j:k) + maximum(numbers[n] for n in j:k)
        for i in 3:length(numbers)
            for j in 1 : i - 2
                for k in j + 1:i - 1
                    if sums[k] - sums[j] + numbers[j] == invalid_number)
    println(answer)
end

main()
