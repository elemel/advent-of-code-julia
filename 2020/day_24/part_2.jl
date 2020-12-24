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

function update_tile(pos, black_tiles)
    black_neighbor_count = sum(
        pos .+ direction in black_tiles
        for direction in values(DIRECTIONS))

    if pos in black_tiles
        return !(black_neighbor_count == 0 || black_neighbor_count > 2)
    else
        return black_neighbor_count == 2
    end
end

function update_grid(black_tiles)
    extended_tiles = Set(black_tiles)

    for pos in black_tiles
        for direction in values(DIRECTIONS)
            neighbor_pos = pos .+ direction
            push!(extended_tiles, neighbor_pos)
        end
    end

    return Set(pos for pos in extended_tiles if update_tile(pos, black_tiles))
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

    for day in 1:100
        black_tiles = update_grid(black_tiles)
    end

    answer = length(black_tiles)
    println(answer)
end

main()
