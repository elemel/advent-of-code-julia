function main()
    input = readlines(stdin)
    adapter_joltages = collect(BitSet(parse.(Int, input)))
    diff_counts = [0, 0, 0]

    for (i, o) in zip(
        [0; adapter_joltages],
        [adapter_joltages; adapter_joltages[end] + 3])

        diff_counts[o - i] += 1
    end

    answer = diff_counts[1] * diff_counts[3]
    println(answer)
end

main()
