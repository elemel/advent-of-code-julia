function main()
    map_rows = readlines(stdin)

    width = length(map_rows[1])
    height = length(map_rows)

    x = 1
    y = 1

    dx = 3
    dy = 1

    tree_count = 0

    while y <= height
        if map_rows[y][x] == '#'
            tree_count = tree_count + 1
        end

        x = mod(x + dx, 1:width)
        y += dy
    end

    println(tree_count)
end

main()
