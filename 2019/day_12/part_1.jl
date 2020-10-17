function gravity(positions)
    [
        sum(sign.(coordinates .- coordinates[j]))
        for coordinates in eachrow(positions), j in axes(positions, 2)
    ]
end

function main()
    values = Int[]

    for line in readlines(stdin)
        line = strip(line)[2:(end - 1)]

        for part in split(line, ", ")
            _, value_str = split(part, "=")
            value = parse(Int, value_str)
            push!(values, value)
        end
    end

    positions = reshape(values, (3, 4))
    velocities = zeros(Int, size(positions))

    for _ = 1:1000
        velocities .+= gravity(positions)
        positions .+= velocities
    end

    potential_energies = [sum(abs.(p)) for p in eachcol(positions)]
    kinetic_energiees = [sum(abs.(v)) for v in eachcol(velocities)]

    println(sum(potential_energies .* kinetic_energiees))
end

main()
