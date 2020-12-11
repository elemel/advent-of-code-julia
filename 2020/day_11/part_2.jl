const DIRECTIONS = [
    (-1, -1), (0, -1), (1, -1),
    (-1, 0), (1, 0),
    (-1, 1), (0, 1), (1, 1),
]

function in_grid_bounds(grid, x, y)
    return y in 1:length(grid) && x in 1:length(grid[y])
end

function raycast(grid, x, y, dx, dy, default)
    while true
        x += dx
        y += dy

        if !in_grid_bounds(grid, x, y)
            return default
        end

        if grid[y][x] != default
            return grid[y][x]
        end
    end
end

function count_visible(grid, x, y, value)
    return sum(
        raycast(grid, x, y, dx, dy, '.') == value
        for (dx, dy) in DIRECTIONS)
end

function step_cell(grid, x, y)
    if grid[y][x] == 'L' && count_visible(grid, x, y, '#') == 0
        return '#'
    elseif grid[y][x] == '#' && count_visible(grid, x, y, '#') >= 5
        return 'L'
    else
        return grid[y][x]
    end
end

function main()
    input = readlines(stdin)
    grid = collect.(input)

    width = length(grid[1])
    height = length(grid)

    while true
        new_grid = [[step_cell(grid, x, y) for x in 1:width] for y in 1:height]

        if new_grid == grid
            break
        end

        grid = new_grid
    end

    answer = sum(grid[y][x] == '#' for y in 1:height, x in 1:width)
    println(answer)
end

main()
