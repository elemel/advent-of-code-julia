function main()
    input = chomp(read(stdin, String))
    input_array = parse.(Int, collect(input))
    signal = repeat(input_array, 1000)
    output_array = zeros(Int, length(input_array))

    for phase in 1:100
        for output_position in axes(output_array, 1)
            generate_pattern!(pattern, output_position)

            output_array[output_position] = mod(
                abs(sum(input_array .* pattern)),
                10)
        end

        input_array, output_array = output_array, input_array
    end

    println(join(string.(input_array[1:8])))
end

main()
