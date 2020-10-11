include("../../Intcode.jl")

function main()
    program = parse.(Int, split(read(stdin, String), ","))

    for noun = 0:99
        for verb = 0:99
            process = Intcode.Process(program)

            process.memory[1] = noun
            process.memory[2] = verb

            Intcode.run(process)

            if process.memory[0] == 19690720
                println(100 * noun + verb)
                return
            end
        end
    end
end

main()
