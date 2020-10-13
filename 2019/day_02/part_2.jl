include("../Intcode.jl")

function main()
    program = parse.(Int, split(read(stdin, String), ","))

    for noun = 0:99
        for verb = 0:99
            computer = Intcode.Computer(program)

            computer.memory[1] = noun
            computer.memory[2] = verb

            Intcode.run!(computer)
            @assert Intcode.is_halted(computer)

            if computer.memory[0] == 19690720
                println(100 * noun + verb)
                return
            end
        end
    end
end

main()
