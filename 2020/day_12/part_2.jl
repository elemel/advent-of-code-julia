function turn(ang, x, y, dx, dy)
    for _ in 1:mod(div(ang, 90), 4)
        dx, dy = -dy, dx
    end

    return x, y, dx, dy
end

const ACTIONS = Dict(
    'N' => (value, x, y, dx, dy) -> (x, y, dx, dy - value),
    'S' => (value, x, y, dx, dy) -> (x, y, dx, dy + value,),
    'E' => (value, x, y, dx, dy) -> (x, y, dx + value, dy),
    'W' => (value, x, y, dx, dy) -> (x, y, dx - value, dy),
    'L' => (value, x, y, dx, dy) -> turn(-value, x, y, dx, dy),
    'R' => (value, x, y, dx, dy) -> turn(value, x, y, dx, dy),
    'F' => (value, x, y, dx, dy) -> (x + dx * value, y + dy * value, dx, dy))

function main()
    input = readlines(stdin)
    instructions = [(line[1], parse(Int, line[2:end])) for line in input]

    x, y = 0, 0
    dx, dy = 10, -1

    for (action, value) in instructions
        x, y, dx, dy = ACTIONS[action](value, x, y, dx, dy)
    end

    answer = abs(x) + abs(y)
    println(answer)
end

main()
