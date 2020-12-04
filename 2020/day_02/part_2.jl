function parse_entry(s)
    m = match(r"^([0-9]+)-([0-9]+) ([a-z]): ([a-z]+)$", s)
    [parse(Int, m[1]), parse(Int, m[2])], m[3][1], m[4]
end

function is_valid_entry(entry)
    positions, letter, password = entry
    sum(password[p] == letter for p in positions) == 1
end

function main()
    input = readlines(stdin)
    entries = parse_entry.(input)
    answer = sum(is_valid_entry, entries)
    println(answer)
end

main()
