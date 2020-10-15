include("../Intcode.jl")

function turn(direction, right)
    x, y = direction
    right ? (-y, x) : (y, -x)
end

function main()
    program = parse.(Int, split(strip(read(stdin, String)), ","))
    computer = Intcode.Computer(program; memory_size=2048)

    position = (0, 0)
    direction = (0, -1)
    grid = Dict((0, 0) => 1)

    while !Intcode.is_halted(computer)
        push!(computer.input_queue, get(grid, position, 0))
        Intcode.run!(computer)
        grid[position] = popfirst!(computer.output_queue)
        direction = turn(direction, Bool(popfirst!(computer.output_queue)))
        position = position .+ direction
    end

    min_x = minimum(x for (x, y) in keys(grid))
    min_y = minimum(y for (x, y) in keys(grid))

    max_x = maximum(x for (x, y) in keys(grid))
    max_y = maximum(y for (x, y) in keys(grid))

    for y = min_y:max_y
        println(
            join((Bool(get(grid, (x, y), 0)) ? '#' : '.')
                for x in min_x:max_x))
    end
end

main()
