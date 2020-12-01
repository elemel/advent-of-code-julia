function main()
    entries = parse.(Int, readlines(stdin))

    for i = 1:length(entries)
        for j = (i + 1):length(entries)
            for k = (j + 1):length(entries)
                if entries[i] + entries[j] + entries[k] == 2020
                    println(entries[i] * entries[j] * entries[k])
                    return
                end
            end
        end
    end
end

main()
