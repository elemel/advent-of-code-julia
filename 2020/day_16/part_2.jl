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

function is_valid_ticket(ticket, rules)
    return all(is_valid_value(value, rules) for value in ticket)
end

function index_candidates(rule, tickets)
    return [
        index
        for index in 1:length(tickets[1])
            if all(in_rule(ticket[index], rule)
                for ticket in tickets)]
end

function greedy_matching(candidates)
    sorted_candidates = collect(candidates)
    sort!(sorted_candidates, by=(kv -> length(kv[2])))

    result = Dict()
    matched_values = Set()

    for (key, vals) in sorted_candidates
        for val in vals
            if !(val in matched_values)
                push!(matched_values, val)
                result[key] = val
            end
        end
    end

    return result
end

function main()
    input = readlines(stdin)
    rules_str, my_ticket_str, nearby_tickets_str = split(
        join(input, "\n"), "\n\n")

    rules = parse_rule.(split(rules_str, "\n"))
    my_ticket = parse_ticket(split(my_ticket_str, "\n")[2])
    nearby_tickets = parse_ticket.(split(nearby_tickets_str, "\n")[2:end])

    valid_tickets = [
        ticket for ticket in nearby_tickets if is_valid_ticket(ticket, rules)]

    name_to_index_candidates = Dict(
        rule[1] => index_candidates(rule, valid_tickets) for rule in rules)
    name_to_index = greedy_matching(name_to_index_candidates)

    answer = prod(
        my_ticket[index]
        for (name, index) in name_to_index
            if startswith(name, "departure "))
    println(answer)
end

main()
