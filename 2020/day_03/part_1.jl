function main()
    input = readlines(stdin)
    width, height = length(input[1]), length(input)
    x, y = 1, 1
    answer = 0

    while y <= height
        if input[y][x] == '#'
            answer += 1
        end

        x = mod(x + 3, 1:width)
        y += 1
    end

    println(answer)
end

main()
