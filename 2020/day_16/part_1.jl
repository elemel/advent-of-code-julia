function parse_range(s)
    a, b = parse.(Int, split(s, "-"))
    return a:b
end

function parse_rule(s)
    key, value_str = split(s, ": ")
    range_1, range_2 = parse_range.(split(value_str, " or "))
    return key, (range_1, range_2)
end

function parse_ticket(s)
    return parse.(Int, split(s, ","))
end

function in_rule(value, rule)
    name, ranges = rule
    return any(value in rng for rng in ranges)
end

function is_valid_value(value, rules)
    return any(in_rule(value, rule) for rule in rules)
end

function main()
    input = readlines(stdin)
    rules_str, my_ticket_str, nearby_tickets_str = split(
        join(input, "\n"), "\n\n")

    rules = parse_rule.(split(rules_str, "\n"))
    my_ticket = parse_ticket(split(my_ticket_str, "\n")[2])
    nearby_tickets = parse_ticket.(split(nearby_tickets_str, "\n")[2:end])

    answer = sum(
        value
        for ticket in nearby_tickets
            for value in ticket
                if !is_valid_value(value, rules))
    println(answer)
end

main()
