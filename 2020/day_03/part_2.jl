function main()
    input = readlines(stdin)
    width, height = length(input[1]), length(input)
    answer = 1

    for (dx, dy) in [(1, 1), (3, 1), (5, 1), (7, 1), (1, 2)]
        x, y = 1, 1
        tree_count = 0

        while y <= height
            if input[y][x] == '#'
                tree_count += 1
            end

            x = mod(x + dx, 1:width)
            y += dy
        end

        answer *= tree_count
    end

    println(answer)
end

main()
