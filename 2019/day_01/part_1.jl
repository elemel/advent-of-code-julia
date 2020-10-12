function main()
    masses = parse.(Int, readlines(stdin))
    println(sum(mass -> fld(mass, 3) - 2, masses))
end

main()
