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

    monitoring_station_index = argmax(
        [length(unique(direction(a, b) for b in asteroids if b != a))
        for a in asteroids])

    asteroids[monitoring_station_index], asteroids[end] =
        asteroids[end], asteroids[monitoring_station_index]

    monitoring_station = pop!(asteroids)

    direction_to_stack = group(
        asteroid -> direction(monitoring_station, asteroid),
        asteroids)

    sorted_stacks = sort([
        (clockwise(direction), stack)
        for (direction, stack) in pairs(direction_to_stack)])

    queue = Deque{Any}()

    for (_, stack) in sorted_stacks
        sort!(
            stack;
            by=(asteroid -> squared_distance(monitoring_station, asteroid)),
            rev=true)

        push!(queue, stack)
    end

    for _ = 1:199
        stack = popfirst!(queue)
        pop!(stack)

        if !isempty(stack)
            push!(queue, stack)
        end
    end

    bet_x, bet_y = pop!(popfirst!(queue))
    println(bet_x * 100 + bet_y)
end

main()
