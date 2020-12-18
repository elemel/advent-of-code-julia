function apply_op!(vals, ops)
    op = pop!(ops)

    if op == '+'
        push!(vals, pop!(vals) + pop!(vals))
    elseif op == '*'
        push!(vals, pop!(vals) * pop!(vals))
    end
end

# See: https://www.geeksforgeeks.org/expression-evaluation/
function evaluate_line(line)
    vals = []
    ops = []

    for char in line
        if char == '('
            push!(ops, char)
            result = 0
        elseif isdigit(char)
            push!(vals, parse(Int, char))
        elseif char == ')'
            while ops[end] != '('
                apply_op!(vals, ops)
            end

            pop!(ops)
        elseif char in ['+', '*']
            while !isempty(ops) && ops[end] != '('
                apply_op!(vals, ops)
            end

            push!(ops, char)
        end
    end

    while !isempty(ops)
        apply_op!(vals, ops)
    end

    return only(vals)
end

function main()
    input = readlines(stdin)
    answer = sum(evaluate_line(line) for line in input)
    println(answer)
end

main()
