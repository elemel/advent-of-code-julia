function to_regex_pattern(key, rules)
    rule_str = rules[key]

    if length(rule_str) == 3 && rule_str[1] == '"' && rule_str[3] == '"'
        return rule_str[2]
    end

    return "(" * join((
        join(to_regex_pattern(atom_str, rules)
            for atom_str in split(branch_str))
            for branch_str in split(rule_str, " | ")),
        "|") * ")"
end

function occursin_rule_0(re, message)
    m = match(re, message)

    if m == nothing
        return false
    end

    return length(m["rule_42"]) > length(m["rule_31"])
end

function main()
    input = readlines(stdin)
    rules_str, messages_str = split(join(input, "\n"), "\n\n")
    rules = Dict(split(s, ": ") for s in split(rules_str, "\n"))
    re = Regex(
        "^(?<rule_42>(" *
        to_regex_pattern("42", rules) *
        ")+)(?<rule_31>("  *
        to_regex_pattern("31", rules) *
        ")+)\$")
    messages = split(messages_str)
    answer = sum(occursin_rule_0(re, message) for message in messages)
    println(answer)
end

main()
