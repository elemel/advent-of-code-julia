function main()
    input = readlines(stdin)
    groups = split.(split(join(input, "\n"), "\n\n"))
    answer = sum(length(union(g...)) for g in groups)
    println(answer)
end

main()
