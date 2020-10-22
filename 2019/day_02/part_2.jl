include("../Intcode.jl")

using .Intcode

function run_gravity_assist(program, noun, verb)
    computer = Computer(program)

    computer.memory[1] = noun
    computer.memory[2] = verb

    run!(computer)
    @assert is_halted(computer)

    computer.memory[0]
end

function main()
    program = compile(read(stdin, String))

    noun, verb = first(
        (noun, verb)
        for noun in 0:99
            for verb in 0:99
                if run_gravity_assist(program, noun, verb) == 19690720)

    println(100 * noun + verb)
end

main()
