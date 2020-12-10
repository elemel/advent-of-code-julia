function main()
    input = readlines(stdin)
    adapter_joltages = BitSet(parse.(Int64, input))
    a, b, c = 0, 0, 1

    for d in 1:maximum(adapter_joltages)
        a, b, c = b, c, d in adapter_joltages ? a + b + c : 0
    end

    answer = c
    println(answer)
end

main()
