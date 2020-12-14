using DataStructures

function main()
    input = readlines(stdin)
    memory = DefaultDict{Int64, Int64}(Int64(0))

    and_mask = ~Int64(0)
    or_mask = Int64(0)

    for line in input
        if startswith(line, "mask")
            mask_str = line[8:end]
            and_mask = parse.(Int64, replace(mask_str, "X" => "1"), base=2)
            or_mask = parse.(Int64, replace(mask_str, "X" => "0"), base=2)
        else
            address, value = parse.(Int64, split(line[5:end], "] = "))
            memory[address] = value & and_mask | or_mask
        end
    end

    answer = sum(values(memory))
    println(answer)
end

main()
