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

function assemble_image_from_grid(grid)
    grid_side = length(grid)
    tile_side = length(grid[1][1]) - 2
    image_side = grid_side * tile_side

    image = [[' ' for x in 1 : image_side] for y in 1 : image_side]

    for (grid_y, grid_row) in enumerate(grid)
        for (grid_x, tile_image) in enumerate(grid_row)
            for (tile_y, tile_row) in enumerate(tile_image[2 : end - 1])
                for (tile_x, char) in enumerate(tile_row[2 : end - 1])
                    image_y = (grid_y - 1) * tile_side + tile_y
                    image_x = (grid_x - 1) * tile_side + tile_x

                    image[image_y][image_x] = char
                end
            end
        end
    end

    return image
end

const SEA_MONSTER_IMAGE = [
    "                  # ",
    "#    ##    ##    ###",
    " #  #  #  #  #  #   "]

function search_for_sea_monsters(canvas)
    canvas_height = length(canvas)
    canvas_width = length(canvas[1])

    sea_monster_height = length(SEA_MONSTER_IMAGE)
    sea_monster_width = length(SEA_MONSTER_IMAGE[1])

    sea_monster_count = 0

    for cy = 1 : canvas_height - sea_monster_height + 1
        for cx = 1 : canvas_width - sea_monster_width + 1
            if all(canvas[cy + smy - 1][cx + smx - 1] == '#'
                for smy in 1 : sea_monster_height
                    for smx in 1 : sea_monster_width
                        if SEA_MONSTER_IMAGE[smy][smx] == '#')

                sea_monster_count += 1

                for smy in 1 : sea_monster_height
                    for smx in 1 : sea_monster_width
                        if SEA_MONSTER_IMAGE[smy][smx] == '#'
                            canvas[cy + smy - 1][cx + smx - 1] = 'O'
                        end
                    end
                end
            end
        end
    end

    return sea_monster_count
end

function main()
    input = readlines(stdin)
    tile_id_to_image = Dict(parse_tile.(split(join(input, "\n"), "\n\n")))

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

    assembled_image = assemble_image_from_grid(grid)
    answer = 0

    for orientation in image_orientations(assembled_image)
        canvas = collect.(orientation)
        sea_monster_count = search_for_sea_monsters(canvas)

        if sea_monster_count > 0
            answer = sum(char == '#' for row in canvas for char in row)
            break
        end
    end

    println(answer)
end

main()
