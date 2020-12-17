function update_cell(x, y, z, w, grid)
    active_count = sum(
        (x2, y2, z2, w2) in grid
        for x2 in x - 1 : x + 1
            for y2 in y - 1 : y + 1
                for z2 in z - 1 : z + 1
                    for w2 in w - 1 : w + 1)

    return (x, y, z, w) in grid ? (active_count in 3:4) : active_count == 3
end

function update_grid(grid)
    min_x = minimum(x for (x, y, z, w) in grid) - 1
    min_y = minimum(y for (x, y, z, w) in grid) - 1
    min_z = minimum(z for (x, y, z, w) in grid) - 1
    min_w = minimum(w for (x, y, z, w) in grid) - 1

    max_x = maximum(x for (x, y, z, w) in grid) + 1
    max_y = maximum(y for (x, y, z, w) in grid) + 1
    max_z = maximum(z for (x, y, z, w) in grid) + 1
    max_w = maximum(w for (x, y, z, w) in grid) + 1

    return Set(
        (x, y, z, w)
        for x in min_x:max_x
            for y in min_y:max_y
                for z in min_z:max_z
                    for w in min_w:max_w
                        if update_cell(x, y, z, w, grid))
end

function main()
    input = readlines(stdin)
    grid = Set(
        (x, y, 0, 0)
        for (y, line) in enumerate(input)
            for (x, char) in enumerate(line) if char == '#')

    for cycle in 1:6
        grid = update_grid(grid)
    end

    answer = length(grid)
    println(answer)
end

main()
