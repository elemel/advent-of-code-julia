function parse_instruction(s)
    operation, argument_str = split(s)
    return operation, parse(Int, argument_str)
end

function main()
    input = readlines(stdin)
    instructions = parse_instruction.(input)
    answer = 0

    ip = 1
    accumulator = 0
    visited = Set()

    while !(ip in visited)
        push!(visited, ip)
        operation, argument = instructions[ip]

        if operation == "acc"
            accumulator += argument
            ip += 1
        elseif operation == "jmp"
            ip += argument
        else
            ip += 1
        end
    end

    answer = accumulator
    println(answer)
end

main()
