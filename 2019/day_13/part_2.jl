include("../Intcode.jl")

using .Intcode

module TileIds

const EMPTY = 0
const WALL = 1
const BLOCK = 2
const HORIZONTAL_PADDLE = 3
const BALL = 4

end # module TileIds

function main()
    program = compile(read(stdin, String))
    computer = Computer(program, memory_size=4096)

    # Play for free
    computer.memory[0] = 2

    score = 0

    while !is_halted(computer)
        run!(computer)

        horizontal_paddle_x = 0
        ball_x = 0

        while !isempty(computer.output_queue)
            x = popfirst!(computer.output_queue)
            y = popfirst!(computer.output_queue)

            tile_id = popfirst!(computer.output_queue)

            if x == -1 && y == 0
                score = tile_id
            else
                if tile_id == TileIds.HORIZONTAL_PADDLE
                    horizontal_paddle_x = x
                elseif tile_id == TileIds.BALL
                    ball_x = x
                end
            end
        end

        joystick_position = sign(ball_x - horizontal_paddle_x)
        push!(computer.input_queue, joystick_position)
    end

    println(score)
end

main()
