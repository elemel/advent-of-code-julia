function solve(entries)
    for i = 1:length(entries)
        for j = (i + 1):length(entries)
            if entries[i] + entries[j] == 2020
                return entries[i] * entries[j]
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
