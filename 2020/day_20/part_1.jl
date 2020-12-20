function parse_tile(s)
    lines = split(s, "\n")

    _, id_str = split(lines[1][1 : end - 1])
    id = parse(Int, id_str)

    return id, collect.(lines[2:end])
end

# See: https://stackoverflow.com/a/53251028
function rotate_image(image)
    return [
        [image[y][x] for y in 1:length(image)]
        for x in reverse(1:length(image[1]))]
end

function flip_image(image)
    return reverse(image)
end

function image_orientations(image)
    result = []

    for i = 1:2
        for i = 1:4
            push!(result, image)
            image = rotate_image(image)
        end

        image = flip_image(image)
    end

    return result
end

function horizontal_match(left, right)
    return all(left[y][end] == right[y][1] for y in 1:length(left))
end

function vertical_match(top, bottom)
    return all(top[end][x] == bottom[1][x] for x in 1:length(top[1]))
end

function solve(images, grid)
    if isempty(images)
        return true
    end

    side = length(grid)
    grid_index = side * side - length(images) + 1

    y = fld(grid_index - 1, side) + 1
    x = mod(grid_index - 1, side) + 1

    for i in 1:length(images)
        images[i], images[end] = images[end], images[i]
        image = pop!(images)

        for orientation in image_orientations(image)
            if y > 1 && !vertical_match(grid[y - 1][x], orientation)
                continue
            end

            if x > 1 && !horizontal_match(grid[y][x - 1], orientation)
                continue
            end

            grid[y][x] = orientation

            if solve(images, grid)
                return true
            end
        end

        # Backtrack
        grid[y][x] = nothing
        push!(images, image)
        images[i], images[end] = images[end], images[i]
    end

    return false
end

function main()
    input = readlines(stdin)
    tile_id_to_image = Dict(parse_tile.(split(join(input, "\n"), "\n\n")))
    orientation_to_tile_id = Dict(
        orientation => id
        for (id, image) in tile_id_to_image
            for orientation in image_orientations(image))

    if length(tile_id_to_image) == 9
        side = 3
    elseif length(tile_id_to_image) == 144
        side = 12
    else
        throw("Bad side")
    end

    images = collect(values(tile_id_to_image))
    grid = [Any[nothing for x in 1:side] for y in 1:side]
    solve(images, grid)
    answer = prod(
        orientation_to_tile_id[grid[y][x]]
        for (y, x) in [(1, 1), (1, side), (side, 1), (side, side)])
    println(answer)
end

main()
