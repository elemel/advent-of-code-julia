function decode_seat_id(s)
    bin_str = join(c in "BR" ? "1" : "0" for c in s)
    return parse(Int, bin_str, base=2)
end

function main()
    input = readlines(stdin)
    answer = maximum(decode_seat_id.(input))
    println(answer)
end

main()
