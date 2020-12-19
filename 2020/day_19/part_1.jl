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

function main()
    input = readlines(stdin)
    rules_str, messages_str = split(join(input, "\n"), "\n\n")
    rules = Dict(split(s, ": ") for s in split(rules_str, "\n"))
    re = Regex("^" * to_regex_pattern("0", rules) * "\$")
    messages = split(messages_str)
    answer = sum(occursin(re, message) for message in messages)
    println(answer)
end

main()
