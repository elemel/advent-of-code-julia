const DIRECTIONS = [
    (-1, -1), (0, -1), (1, -1),
    (-1, 0), (1, 0),
    (-1, 1), (0, 1), (1, 1),
]

function get_cell(grid, x, y, default)
    return y in 1:length(grid) && x in 1:length(grid[y]) ? grid[y][x] : default
end

function count_adjacent(grid, x, y, value)
    return sum(
        get_cell(grid, x + dx, y + dy, '.') == value
        for (dx, dy) in DIRECTIONS)
end

function step_cell(grid, x, y)
    if grid[y][x] == 'L' && count_adjacent(grid, x, y, '#') == 0
        return '#'
    elseif grid[y][x] == '#' && count_adjacent(grid, x, y, '#') >= 4
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
