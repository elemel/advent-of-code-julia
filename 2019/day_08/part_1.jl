function main()
    pixels = [parse(Int8, char) for char in strip(read(stdin, String))]

    width = 25
    height = 6
    depth = fld(length(pixels), width * height)

    @assert width * height * depth == length(pixels)
    image = reshape(pixels, (width, height, depth))

    zero_counts = [
        sum(pixel -> pixel == 0, image[:, :, z])
        for z in axes(image, 3)
    ]

    z = argmin(zero_counts)

    one_count = sum(pixel -> pixel == 1, image[:, :, z])
    two_count = sum(pixel -> pixel == 2, image[:, :, z])

    println(one_count * two_count)
end

main()
