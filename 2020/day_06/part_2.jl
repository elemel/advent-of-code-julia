function main()
    input = readlines(stdin)
    groups = split.(split(join(input, "\n"), "\n\n"))
    answer = sum(length(intersect(g...)) for g in groups)
    println(answer)
end

main()
