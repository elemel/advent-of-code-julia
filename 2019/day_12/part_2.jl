function period(axis_positions, axis_velocities)
    axis_positions = copy(axis_positions)
    axis_velocities = copy(axis_velocities)

    state_to_step = Dict{Array{Int}, Int}()

    for step_count in 0:typemax(Int)
        state_key = vcat(axis_positions, axis_velocities)

        if haskey(state_to_step, state_key)
            return state_to_step[state_key], step_count
        end

        state_to_step[state_key] = step_count

        axis_velocities .+= [
            sum(sign(b - a) for b in axis_positions)
            for a in axis_positions
        ]

        axis_positions .+= axis_velocities
    end
end

function main()
    positions = map(readlines(stdin)) do position_str
        map(split(position_str[2 : end - 1], ", ")) do component_str
            parse(Int, component_str[3:end])
        end
    end

    velocities = [zeros(size(p)) for p in positions]

    step_counts = map(1:3) do axis
        axis_positions = [p[axis] for p in positions]
        axis_velocities = [v[axis] for v in velocities]

        step_1, step_2 = period(axis_positions, axis_velocities)
        @assert step_1 == 0
        step_2
    end

    println(reduce(lcm, step_counts))
end

main()
