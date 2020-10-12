include("../Intcode.jl")

function main()
    program = parse.(Int, split(read(stdin, String), ","))

    for noun = 0:99
        for verb = 0:99
            machine = Intcode.Machine(program)

            machine.memory[1] = noun
            machine.memory[2] = verb

            Intcode.run!(machine)
            @assert Intcode.is_halted(machine)

            if machine.memory[0] == 19690720
                println(100 * noun + verb)
                return
            end
        end
    end
end

main()
