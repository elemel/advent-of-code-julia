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
    grid = Dict()

    while !Intcode.is_halted(computer)
		push!(computer.input_queue, get(grid, position, 0))
	    Intcode.run!(computer)
	    grid[position] = popfirst!(computer.output_queue)
	    direction = turn(direction, Bool(popfirst!(computer.output_queue)))
	    position = position .+ direction
	end

    println(length(grid))
end

main()
