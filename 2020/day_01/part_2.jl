function solve(entries)
    for i = 1:length(entries)
        for j = (i + 1):length(entries)
            for k = (j + 1):length(entries)
                if entries[i] + entries[j] + entries[k] == 2020
                    return entries[i] * entries[j] * entries[k]
                end
            end
        end
    end
end

function main()
    input = readlines(stdin)
    entries = parse.(Int, input)
    answer = solve(entries)
    println(answer)
end

main()
