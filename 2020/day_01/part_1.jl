function main()
    entries = parse.(Int, readlines(stdin))

    for entry_1 in entries
        for entry_2 in entries
            if entry_1 + entry_2 == 2020
                println(entry_1 * entry_2)
                return
            end
        end
    end
end

main()
