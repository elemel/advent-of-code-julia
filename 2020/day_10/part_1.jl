function main()
    input = readlines(stdin)
    adapter_joltages = BitSet(parse.(Int, input))
    input_joltages = union(BitSet([0]), adapter_joltages)
    output_joltages = union(
        adapter_joltages, BitSet([maximum(adapter_joltages) + 3]))
    diff_counts = [0, 0, 0]

    for o in output_joltages
        for d in 1:3
            if o - d in input_joltages
                diff_counts[d] += 1
                break
            end
        end
    end

    answer = diff_counts[1] * diff_counts[3]
    println(answer)
end

main()
