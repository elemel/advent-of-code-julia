using Combinatorics

function main()
    input = readlines(stdin)
    entries = parse.(Int, input)
    answer = prod(first(c for c in combinations(entries, 3) if sum(c) == 2020))
    println(answer)
end

main()
