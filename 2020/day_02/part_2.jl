function parse_entry(str)
    m = match(r"^([0-9]+)-([0-9]+) ([a-z]): ([a-z]+)$", str)
    return parse(Int, m[1]), parse(Int, m[2]), m[3][1], m[4]
end

function is_valid_entry(entry)
    i, j, letter, password = entry
    return sum(password[k] == letter for k in [i, j]) == 1
end

function main()
    input = readlines(stdin)
    entries = parse_entry.(input)
    answer = sum(is_valid_entry, entries)
    println(answer)
end

main()
