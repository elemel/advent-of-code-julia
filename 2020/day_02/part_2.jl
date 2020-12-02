function parse_entry(entry_str)
    policy_str, password = split(entry_str, ": ")
    positions_str, letter_str = split(policy_str, " ")
    position_1, position_2 = parse.(Int, split(positions_str, "-"))
    return ((position_1, position_2), letter_str[1]), strip(password)
end

function is_valid_entry(policy, password)
    positions, letter = policy
    return sum(password[pos] == letter for pos in positions) == 1
end

function main()
    entries = parse_entry.(readlines(stdin))
    println(sum(
        is_valid_entry(policy, password) for (policy, password) in entries))
end

main()
