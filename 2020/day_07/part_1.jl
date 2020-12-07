function parse_content(s)
    count_str, color = match(r"^(\d+) (.+) bags?$", s).captures
    return color, parse(Int, count_str)
end

function parse_contents(s)
    if s == "no other bags"
        return Dict()
    end

    return Dict(parse_content.(split(s, ", ")))
end

function parse_rule(s)
    color, contents_str = split(s[1 : end - 1], " bags contain ")
    return color, parse_contents(contents_str)
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
