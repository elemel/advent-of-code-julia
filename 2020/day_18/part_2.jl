using Tokenize

function evaluate_line(line)
    vals = []
    ops = []

    for token in untokenize.(tokenize(line))
        if token == "("
            push!(ops, token)
            result = 0
        elseif !isempty(token) && all(isdigit(c) for c in token)
            push!(vals, parse(Int, token))
        elseif token == ")"
            while ops[end] != "("
                op = pop!(ops)

                if op == "+"
                    push!(vals, pop!(vals) + pop!(vals))
                elseif op == "*"
                    push!(vals, pop!(vals) * pop!(vals))
                else
                    throw("Bad op")
                end
            end

            pop!(ops)
        elseif token in ["+", "*"]
            while !isempty(ops) && token == "*" && ops[end] == "+"
                op = pop!(ops)

                if op == "+"
                    push!(vals, pop!(vals) + pop!(vals))
                elseif op == "*"
                    push!(vals, pop!(vals) * pop!(vals))
                else
                    throw("Bad op")
                end
            end

            push!(ops, token)
        end
    end

    while !isempty(ops)
        op = pop!(ops)

        if op == "+"
            push!(vals, pop!(vals) + pop!(vals))
        elseif op == "*"
            push!(vals, pop!(vals) * pop!(vals))
        else
            throw("Bad op")
        end
    end

    return only(vals)
end

function main()
    input = readlines(stdin)
    answer = sum(evaluate_line(line) for line in input)
    println(answer)
end

main()
