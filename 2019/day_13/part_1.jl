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

    run!(computer)
    @assert is_halted(computer)

    block_tile_count = 0

    while !isempty(computer.output_queue)
        x = popfirst!(computer.output_queue)
        y = popfirst!(computer.output_queue)

        tile_id = popfirst!(computer.output_queue)

        if tile_id == TileIds.BLOCK
            block_tile_count += 1
        end
    end

    println(block_tile_count)
end

main()
