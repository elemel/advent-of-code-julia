function direction(a, b)
    offset = b .- a
    fld.(offset, gcd(offset...))
end

function main()
    lines = readlines(stdin)

    asteroids = [
        (x - 1, y - 1)
        for (y, line) in enumerate(lines)
            for (x, char) in enumerate(line)
                if char == '#']

    print(maximum(
        length(unique(
            direction(monitoring_station, asteroid)
            for asteroid in asteroids
                if asteroid != monitoring_station))
        for monitoring_station in asteroids))
end

main()
