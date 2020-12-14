using DataStructures

function main()
    input = readlines(stdin)
    memory = DefaultDict{Int64, Int64}(Int64(0))

    unchanged_mask = Int64(0)
    one_mask = Int64(0)
    floating_mask = Int64(0)

    for line in input
        if startswith(line, "mask")
            mask_str = line[8:end]
            unchanged_mask = ~parse.(
                Int64, replace(mask_str, "X" => "1"), base=2)
            one_mask = parse.(Int64, replace(mask_str, "X" => "0"), base=2)
            floating_mask = parse.(
                Int64,
                replace(replace(mask_str, "1" => "0"), "X" => "1"),
                base=2)
        else
            address, value = parse.(Int64, split(line[5:end], "] = "))
            floating_address = Int64(0)

            while true
                actual_adress = (
                    address & unchanged_mask | one_mask | floating_address)
                memory[actual_adress] = value

                for bit in 0:35
                    if floating_mask & (1 << bit) != Int64(0)
                        if floating_address & (1 << bit) == Int64(0)
                            floating_address |= 1 << bit
                            break
                        else
                            floating_address &= ~(1 << bit)
                        end
                    end
                end

                if floating_address == Int64(0)
                    break
                end
            end
        end
    end

    answer = sum(values(memory))
    println(answer)
end

main()
