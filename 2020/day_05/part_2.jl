function decode_seat_id(s)
    for kv in Dict("F" => "0", "B" => "1", "L" => "0", "R" => "1")
        s = replace(s, kv)
    end

    parse(Int, s, base=2)
end

function main()
    input = readlines(stdin)
    seat_ids = Set([decode_seat_id(line) for line in input])
    answer = first(
        id for id in minimum(seat_ids):maximum(seat_ids)
        if !(id in seat_ids) && id - 1 in seat_ids && id + 1 in seat_ids)
    println(answer)
end

main()
