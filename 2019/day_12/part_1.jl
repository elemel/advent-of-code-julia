using StaticArrays

function parse_position(position_str)
    MVector{3, Int}(
        parse(Int, component_str[3:end])
        for component_str in split(position_str[2 : end - 1], ", "))
end

function main()
    positions = Array{MVector{3,Int}}(map(parse_position, readlines(stdin)))
    velocities = [zeros(MVector{3, Int}) for _ in positions]

    for _ = 1:1000
        velocities .+= [
            sum(sign.(b - a) for b in positions)
            for a in positions
        ]

        positions .+= velocities
    end

    potential_energies = [sum(abs.(p)) for p in positions]
    kinetic_energiees = [sum(abs.(v)) for v in velocities]

    println(sum(potential_energies .* kinetic_energiees))
end

main()
