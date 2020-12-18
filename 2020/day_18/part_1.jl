include("../../Julmust.jl")

using .Julmust

function evaluate_line(line)
    re = to_tokenizer_regex([
        "op" => r"[(+*)]",
        "num" => r"[0-9]+"])

    vals = []
    ops = []

    for (name, token) in tokenize(line, re)
        if token == "("
            push!(ops, token)
            result = 0
        elseif name == "num"
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
            while !isempty(ops) && ops[end] != "("
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
