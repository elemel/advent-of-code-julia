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

function required_inside(color, rules)
    if isempty(rules[color])
        return 0
    end

    return sum(
        child_count * (1 + required_inside(child_color, rules))
        for (child_color, child_count) in rules[color])
end

function main()
    input = readlines(stdin)
    rules = Dict(parse_rule.(input))
    answer = required_inside("shiny gold", rules)
    println(answer)
end

main()
