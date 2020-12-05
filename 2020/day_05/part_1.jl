function decode_seat_id(s)
    for kv in Dict("F" => "0", "B" => "1", "L" => "0", "R" => "1")
        s = replace(s, kv)
    end

    parse(Int, s, base=2)
end

function main()
    input = readlines(stdin)
    answer = maximum(decode_seat_id(line) for line in input)
    println(answer)
end

main()
