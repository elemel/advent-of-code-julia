function decode_seat_id(s)
    s = join(c in "BR" ? "1" : "0" for c in s)
    parse(Int, s, base=2)
end

function main()
    input = readlines(stdin)
    answer = maximum(decode_seat_id(line) for line in input)
    println(answer)
end

main()
