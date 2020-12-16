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

function main()
    input = readlines(stdin)
    rules_str, my_ticket_str, nearby_tickets_str = split(
        join(input, "\n"), "\n\n")

    rules = parse_rule.(split(rules_str, "\n"))
    my_ticket = parse_ticket(split(my_ticket_str, "\n")[2])
    nearby_tickets = parse_ticket.(split(nearby_tickets_str, "\n")[2:end])

    valid_tickets = [
        ticket
        for ticket in nearby_tickets
            if all(any(value in rng
                for (name, ranges) in rules
                    for rng in ranges)
                        for value in ticket)]

    rule_index_matches = [
        (name, [
            i
            for i in 1:length(my_ticket)
                if sum(any(ticket[i] in rng
                    for rng in ranges)
                    for ticket in valid_tickets) == length(valid_tickets)])
            for (name, ranges) in rules]

    sort!(rule_index_matches, by=element -> length(element[2]))

    departure_values_product = 1
    seen = Set{Int}()

    for (name, indices) in rule_index_matches
        for index in indices
            if !(index in seen)
                push!(seen, index)

                if startswith(name, "departure ")
                    departure_values_product *= my_ticket[index]
                end
            end
        end
    end

    answer = departure_values_product
    println(answer)
end

main()
