function decode_seat_id(s)
    s = join(c in "BR" ? "1" : "0" for c in s)
    parse(Int, s, base=2)
end

function main()
    input = readlines(stdin)
    seat_ids = decode_seat_id.(input)
    answer = first(setdiff(minimum(seat_ids):maximum(seat_ids), seat_ids))
    println(answer)
end

main()
