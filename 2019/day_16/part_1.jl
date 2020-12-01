const BASE_PATTERN = [0, 1, 0, -1]

function generate_pattern!(pattern, output_position)
    i = 1
    j = 2

    for k in axes(pattern, 1)
        if j > output_position
            i = mod(i + 1, axes(BASE_PATTERN, 1))
            j = 1
        end

        pattern[k] = BASE_PATTERN[i]

        j += 1
    end
end

function main()
    input = chomp(read(stdin, String))
    input_array = parse.(Int, collect(input))
    pattern = zeros(Int, length(input_array))
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
