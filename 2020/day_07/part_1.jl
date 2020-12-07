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

function can_eventually_contain(color, descendant_color, rules)
    if haskey(rules[color], descendant_color)
        return true
    end

    return any(
        can_eventually_contain(child_color, descendant_color, rules)
        for child_color in keys(rules[color]))
end

function main()
    input = readlines(stdin)
    rules = Dict(parse_rule.(input))
    answer = sum(
        can_eventually_contain(color, "shiny gold", rules)
        for color in keys(rules))
    println(answer)
end

main()
