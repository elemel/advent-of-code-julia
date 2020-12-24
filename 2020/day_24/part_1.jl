# Cube coordinates
# x, y, z
# See: https://www.redblobgames.com/grids/hexagons/
const DIRECTIONS = Dict(
    "e" => (1, -1, 0),
    "se" => (0, -1, 1),
    "sw" => (-1, 0, 1),
    "w" => (-1, 1, 0),
    "nw" => (0, 1, -1),
    "ne" => (1, 0, -1))

function split_path(s)
    return split(replace(replace(s, "e" => "e "), "w" => "w "))
end

function path_to_position(path)
    result = 0, 0, 0

    for move in path
        result = result .+ DIRECTIONS[move]
    end

    return result
end

function main()
    input = readlines(stdin)
    paths = split_path.(input)
    black_tiles = Set()

    for path in paths
        pos = path_to_position(path)

        if pos in black_tiles
            pop!(black_tiles, pos)
        else
            push!(black_tiles, pos)
        end
    end

    answer = length(black_tiles)
    println(answer)
end

main()
