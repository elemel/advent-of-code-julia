include("../../Julmust.jl")

using .Julmust

function count_visible(grid, y, x, value)
    return sum(
        grid_raycast(grid, y, x, dy, dx, '.') == value
        for (dy, dx) in GRID_DIRECTIONS)
end

function apply_rules(grid, y, x)
    if grid[y][x] == 'L' && count_visible(grid, y, x, '#') == 0
        return '#'
    elseif grid[y][x] == '#' && count_visible(grid, y, x, '#') >= 5
        return 'L'
    else
        return grid[y][x]
    end
end

function main()
    input = readlines(stdin)
    grid = collect.(input)

    while true
        new_grid = [
            [apply_rules(grid, y, x) for x in 1:length(row)]
            for (y, row) in enumerate(grid)]

        if new_grid == grid
            break
        end

        grid = new_grid
    end

    answer = sum(value == '#' for row in grid for value in row)
    println(answer)
end

main()
