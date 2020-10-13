function render_pixel(image, x, y)
    color = first(filter(pixel -> pixel != 2, image[x, y, :]))
    ".#"[color + 1]
end

function render_row(image, y)
    join(render_pixel(image, x, y) for x in axes(image, 1))
end

function render_image(image)
    join((render_row(image, y) for y in axes(image, 2)), "\n")
end

function main()
    pixels = [parse(Int8, char) for char in strip(read(stdin, String))]

    width = 25
    height = 6
    depth = fld(length(pixels), width * height)

    @assert width * height * depth == length(pixels)
    image = reshape(pixels, (width, height, depth))

    print(render_image(image))
end

main()
