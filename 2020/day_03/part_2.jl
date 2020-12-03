function main()
    map_rows = readlines(stdin)

    width = length(map_rows[1])
    height = length(map_rows)

    tree_count_product = 1

    for (dx, dy) in [(1, 1), (3, 1), (5, 1), (7, 1), (1, 2)]
        x = 1
        y = 1

        tree_count = 0

        while y <= height
            if map_rows[y][x] == '#'
                tree_count = tree_count + 1
            end

            x = mod(x + dx, 1:width)
            y += dy
        end

        tree_count_product *= tree_count
    end

    println(tree_count_product)
end

main()
