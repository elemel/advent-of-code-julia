using DataStructures

include("../Intcode.jl")

using .Intcode

module MovementCommands

NORTH = 1
SOUTH = 2
WEST = 3
EAST = 4

end # module MovementCommands

const DIRECTION_TO_MOVEMENT_COMMAND = Dict(
    (0, -1) => MovementCommands.NORTH,
    (0, 1) => MovementCommands.SOUTH,
    (-1, 0) => MovementCommands.WEST,
    (1, 0) => MovementCommands.EAST)

module StatusCodes

WALL = 0
OPEN = 1
OXYGEN_SYSTEM = 2

end # module StatusCodes

function search(position, computer, position_to_reply)
    for (direction, movement_command) in pairs(DIRECTION_TO_MOVEMENT_COMMAND)
        new_position = position .+ direction

        if haskey(position_to_reply, new_position)
            continue
        end

        push!(computer.input_queue, movement_command)
        run!(computer)
        status_code = popfirst!(computer.output_queue)

        position_to_reply[new_position] = status_code

        if status_code == StatusCodes.WALL
            continue
        end

        search(new_position, computer, position_to_reply)

        # Backtrack

        back_direction = -1 .* direction
        back_movement_command = DIRECTION_TO_MOVEMENT_COMMAND[back_direction]

        push!(computer.input_queue, back_movement_command)
        run!(computer)
        back_status_code = popfirst!(computer.output_queue)

        @assert back_status_code == position_to_reply[position]
    end
end

function main()
    program = compile(read(stdin, String))
    computer = Computer(program)

    position_to_reply = Dict((0, 0) => StatusCodes.OPEN)
    search((0, 0), computer, position_to_reply)

    position_to_distance = Dict((0, 0) => 0)

    queue = Deque{Tuple{Int, Int}}()
    push!(queue, (0, 0))

    while !isempty(queue)
        position = popfirst!(queue)
        distance = position_to_distance[position]

        for direction in keys(DIRECTION_TO_MOVEMENT_COMMAND)
            new_position = position .+ direction

            if position_to_reply[new_position] == StatusCodes.WALL
                continue
            end

            if haskey(position_to_distance, new_position)
                continue
            end

            position_to_distance[new_position] = distance + 1
            push!(queue, new_position)
        end
    end

    oxygen_system_position = first(
        position
        for (position, reply) in pairs(position_to_reply)
            if reply == StatusCodes.OXYGEN_SYSTEM)

    println(position_to_distance[oxygen_system_position])
end

main()
