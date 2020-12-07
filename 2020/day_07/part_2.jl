function parse_rule(s)
    color, tail = split(s, " bags contain ")
    children = Dict()

    if tail != "no other bags."
        stripped_tail = tail[1 : end - 1]

        for child_str in split(stripped_tail, ", ")
            count_str, child_tail = split(child_str, " ", limit=2)
            child_color, _ = rsplit(child_tail, " ", limit=2)
            children[child_color] = parse(Int, count_str)
        end
    end

    color, children
end

function required_inside(color, rules)
    result = 0

    for (child_color, child_count) in rules[color]
        result += child_count * (1 + required_inside(child_color, rules))
    end

    result
end

function main()
    input = readlines(stdin)
    rules = Dict(parse_rule.(input))
    answer = required_inside("shiny gold", rules)
    println(answer)
end

main()
