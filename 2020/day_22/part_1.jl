function main()
    input = readlines(stdin)
    deck_strs = split(join(input, "\n"), "\n\n")
    decks = [
        parse.(Int, split(deck_str, "\n")[2:end])
        for deck_str in deck_strs]

    for rnd in 1:typemax(Int)
        top_cards = [popfirst!(deck) for deck in decks]
        max_card, winner = findmax(top_cards)
        loser = winner == 1 ? 2 : 1

        push!(decks[winner], top_cards[winner])
        push!(decks[winner], top_cards[loser])

        if any(isempty(deck) for deck in decks)
            break
        end
    end

    answer = sum(
        i * card
        for deck in decks
            for (i, card) in enumerate(reverse(deck)))
    println(answer)
end

main()
