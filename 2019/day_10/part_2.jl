using DataStructures
using LinearAlgebra
using SplitApplyCombine

function direction(a, b)
    offset = b .- a
    fld.(offset, gcd(offset...))
end

function squared_distance(a, b)
    offset = b .- a
    dot(offset, offset)
end

function clockwise(direction)
    x, y = direction

    if x >= 0 && y < 0
        0, abs(x // y)
    elseif y >= 0 && x > 0
        1, abs(y // x)
    elseif x <= 0 && y > 0
        2, abs(x // y)
    elseif y <= 0 && x < 0
        3, abs(y // x)
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

    _, monitoring_station, direction_to_stack = maximum(
        map(asteroids) do monitoring_station
            stack = sort(asteroids; by=(
                asteroid -> -squared_distance(monitoring_station, asteroid)))

            pop!(stack)

            direction_to_stack = group(
                asteroid -> direction(monitoring_station, asteroid),
                stack)

            length(direction_to_stack), monitoring_station, direction_to_stack
        end)

    sorted_stacks = sort([
        (clockwise(direction), stack)
        for (direction, stack) in pairs(direction_to_stack)])

    queue = Deque{Any}()

    for (_, stack) in sorted_stacks
        push!(queue, stack)
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
