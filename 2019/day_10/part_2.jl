include("../../Julmust.jl")

using DataStructures
using LinearAlgebra

using .Julmust

Vec2 = Tuple{Int, Int}

function direction(a, b)
    offset = b .- a
    divisor = gcd(offset...)
    divisor == 0 ? offset : fld.(offset, divisor)
end

function squared_distance(a, b)
    offset = b .- a
    dot(offset, offset)
end

function clockwise(direction)
    x, y = direction

    if x >= 0 && y < 0
        1, abs(x // y)
    elseif y >= 0 && x > 0
        2, abs(y // x)
    elseif x <= 0 && y > 0
        3, abs(x // y)
    elseif y <= 0 && x < 0
        4, abs(y // x)
    else
        0, 0 // 1
    end
end

function main()
    lines = readlines(stdin)

    asteroids = [
        (x - 1, y - 1)
        for (y, line) in enumerate(lines)
            for (x, char) in enumerate(line)
                if char == '#']

    _, monitoring_station, aligned_targets = maximum(
        map(asteroids) do monitoring_station
            aligned_targets = DefaultDict{Vec2, Vector{Vec2}}(Vector{Vec2})

            for asteroid in asteroids
                key = direction(monitoring_station, asteroid)
                push!(aligned_targets[key], asteroid)
            end

            delete!(aligned_targets, (0, 0))
            length(aligned_targets), monitoring_station, aligned_targets
        end)

    clockwise_groups = sort([
        (clockwise(direction), targets)
        for (direction, targets) in pairs(aligned_targets)])

    queue = Deque{Vector{Vec2}}()

    for (_, targets) in clockwise_groups
        sort_by!(targets) do target
            -squared_distance(monitoring_station, target)
        end

        push!(queue, targets)
    end

    for _ = 1:199
        stack = popfirst!(queue)
        pop!(stack)

        if !isempty(stack)
            push!(queue, stack)
        end
    end

    bet_x, bet_y = last(first(queue))
    println(bet_x * 100 + bet_y)
end

main()
