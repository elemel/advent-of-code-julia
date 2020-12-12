function turn(value, x, y, dx, dy)
    for _ in 1:mod(div(value, 90), 4)
        dx, dy = -dy, dx
    end

    return x, y, dx, dy
end

const ACTIONS = Dict(
    'N' => (value, x, y, dx, dy) -> (x, y - value, dx, dy),
    'S' => (value, x, y, dx, dy) -> (x, y + value, dx, dy),
    'E' => (value, x, y, dx, dy) -> (x + value, y, dx, dy),
    'W' => (value, x, y, dx, dy) -> (x - value, y, dx, dy),
    'L' => (value, x, y, dx, dy) -> turn(-value, x, y, dx, dy),
    'R' => (value, x, y, dx, dy) -> turn(value, x, y, dx, dy),
    'F' => (value, x, y, dx, dy) -> (x + dx * value, y + dy * value, dx, dy))

function main()
    input = readlines(stdin)
    instructions = [(line[1], parse(Int, line[2:end])) for line in input]

    x, y = 0, 0
    dx, dy = 1, 0

    for (action, value) in instructions
        x, y, dx, dy = ACTIONS[action](value, x, y, dx, dy)
    end

    answer = abs(x) + abs(y)
    println(answer)
end

main()
