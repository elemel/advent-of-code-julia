function parse_entry(entry_str)
    policy_str, password = strip.(split(entry_str, ":"))
    range_str, letter_str = split(policy_str)
    min_count, max_count = parse.(Int, split(range_str, "-"))
    policy = (min_count, max_count), letter_str[1]
    return policy, password
end

function is_valid_entry(policy, password)
    (min_count, max_count), letter = policy
    letter_count = sum(char == letter for char in password)
    return min_count <= letter_count && letter_count <= max_count
end

function main()
    entries = parse_entry.(readlines(stdin))
    println(sum(
        is_valid_entry(policy, password) for (policy, password) in entries))
end

main()
