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

function change_instruction(instruction)
    operation, argument = instruction

    if operation == "jmp"
        return "nop", argument
    elseif operation == "nop"
        return "jmp", argument
    else
        return instruction
    end
end

function main()
    input = readlines(stdin)
    instructions = parse_instruction.(input)
    answer = 0

    for address in 1:length(instructions)
        changed_instruction = change_instruction(instructions[address])

        if changed_instruction != instructions[address]
            changed_instructions = collect(instructions)
            changed_instructions[address] = changed_instruction
            terminated_normally, answer = run_program(changed_instructions)

            if terminated_normally
                break
            end
        end
    end

    println(answer)
end

main()
