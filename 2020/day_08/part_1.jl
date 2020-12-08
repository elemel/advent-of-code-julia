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

    while true
        if ip in visited
            answer = accumulator
            break
        end

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

    println(answer)
end

main()
