function recursive_combat(decks, next_game)
    game = next_game[1]
    next_game[1] += 1

    # println("=== Game $game===")
    # println()

    seen = Set()

    for rnd in 1:typemax(Int)
        # println("-- Round $rnd (Game $game) -- ")

        # for (player, deck) in enumerate(decks)
        #     println("Player $player's deck: " * join(string.(deck), ", "))
        # end

        if decks in seen
            return 1, decks[1]
        end

        push!(seen, collect.(decks))

        top_cards = [popfirst!(deck) for deck in decks]

        for (player, card) in enumerate(top_cards)
            # println("Player $player plays: $card")
        end

        if all(
            length(deck) >= top_card
            for (deck, top_card) in zip(decks, top_cards))

            # println("Playing a sub-game to determine the winner...")
            # println()

            new_decks = [
                deck[1:top_card]
                for (deck, top_card) in zip(decks, top_cards)]
            winner, winning_deck = recursive_combat(new_decks, next_game)

            # println("...anyway, back to game $game.")
        else
            max_card, winner = findmax(top_cards)
        end

        # println("Player $winner wins round $rnd of game $(game)!")
        # println()

        loser = winner == 1 ? 2 : 1
        push!(decks[winner], top_cards[winner])
        push!(decks[winner], top_cards[loser])

        if any(isempty(deck) for deck in decks)
            winner = first(
                player
                for (player, deck) in enumerate(decks)
                    if !isempty(deck))

            # println("The winner of game $game is player $(winner)!")
            # println()
            return winner, decks[winner]
        end
    end
end

function main()
    input = readlines(stdin)
    deck_strs = split(join(input, "\n"), "\n\n")
    decks = [
        parse.(Int, split(deck_str, "\n")[2:end])
        for deck_str in deck_strs]

    next_game = [1]
    winner, winning_deck = recursive_combat(decks, next_game)
    answer = sum(
        i * card
        for (i, card) in enumerate(reverse(winning_deck)))
    println(answer)
end

main()
