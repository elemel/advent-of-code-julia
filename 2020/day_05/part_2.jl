function decode_seat_id(s)
    bin_str = join(c in "BR" ? "1" : "0" for c in s)
    return parse(Int, bin_str, base=2)
end

function main()
    input = readlines(stdin)
    seat_ids = decode_seat_id.(input)
    answer = only(setdiff(minimum(seat_ids):maximum(seat_ids), seat_ids))
    println(answer)
end

main()
