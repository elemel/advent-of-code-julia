function main()
    input = readlines(stdin)
    min_timestamp = parse(Int, input[1])
    bus_ids = parse.(Int, (s for s in split(input[2], ",") if s != "x"))
    answer = first((timestamp - min_timestamp) * bus_id for timestamp in min_timestamp:typemax(Int) for bus_id in bus_ids if mod(timestamp, bus_id) == 0)
    println(answer)
end

main()
