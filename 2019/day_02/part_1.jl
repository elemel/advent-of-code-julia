include("../Intcode.jl")

function main()
    program = parse.(Int, split(read(stdin, String), ","))
    process = Intcode.Process(program)

    process.memory[1] = 12
    process.memory[2] = 2

    Intcode.run(process)
    println(process.memory[0])
end

main()
