function parse_instruction(s)
    operation, argument_str = split(s)
    return operation, parse(Int, argument_str)
end

function run_program(instructions)
    ip = 1
    accumulator = 0
    visited = Set()

    while ip <= length(instructions)
        if ip in visited
            return false, 0
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

    return true, accumulator
end

function main()
    input = readlines(stdin)
    instructions = parse_instruction.(input)
    answer = 0

    for address in 1:length(instructions)
        operation, argument = instructions[address]

        if operation == "jmp" || operation == "nop"
            changed_instructions = collect(instructions)

            if operation == "jmp"
                changed_instructions[address] = "nop", argument
            else
                changed_instructions[address] = "jmp", argument
            end

            completed, answer = run_program(changed_instructions)

            if completed
                break
            end
        end
    end

    println(answer)
end

main()
