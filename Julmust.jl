# Essential Julia utilities for Advent of Code
module Julmust

export
    get_grid_cell,
    GRID_DIRECTIONS,
    grid_raycast,
    in_grid_bounds,
    sort_by,
    sort_by!

function sort_by(func, values)
    sort(values, by=f)
end

function sort_by!(func, values)
    sort!(values, by=func)
end

# (dy, dx)
const GRID_DIRECTIONS = [
    (-1, -1), (-1, 0), (-1, 1),
    (0, -1), (0, 1),
    (1, -1), (1, 0), (1, 1),
]

function in_grid_bounds(grid, y, x)
    return y in 1:length(grid) && x in 1:length(grid[y])
end

function get_grid_cell(grid, y, x, default)
     return in_grid_bounds(grid, y, x) ? grid[y][x] : default
 end

function grid_raycast(grid, y, x, dy, dx, default)
    while true
        y += dy
        x += dx

        if !in_grid_bounds(grid, y, x)
            return default
        end

        if grid[y][x] != default
            return grid[y][x]
        end
    end
end

end # module Julmust
