function update_cell(x, y, z, grid)
    active_count = sum(
        (x2, y2, z2) in grid
        for x2 in x - 1 : x + 1
            for y2 in y - 1 : y + 1
                for z2 in z - 1 : z + 1)
    active_range = (x, y, z) in grid ? (3:4) : (3:3)
    return active_count in active_range
end

function update_grid(grid)
    min_x = minimum(x for (x, y, z) in grid)
    min_y = minimum(y for (x, y, z) in grid)
    min_z = minimum(z for (x, y, z) in grid)

    max_x = maximum(x for (x, y, z) in grid)
    max_y = maximum(y for (x, y, z) in grid)
    max_z = maximum(z for (x, y, z) in grid)

    return Set(
        (x, y, z)
        for x in min_x - 1 : max_x + 1
            for y in min_y - 1 : max_y + 1
                for z in min_z - 1 : max_z + 1
                    if update_cell(x, y, z, grid))
end

function main()
    input = readlines(stdin)
    grid = Set(
        (x, y, 0)
        for (y, line) in enumerate(input)
            for (x, char) in enumerate(line)
                if char == '#')

    for cycle in 1:6
        grid = update_grid(grid)
    end

    answer = length(grid)
    println(answer)
end

main()
