function parse_food(s)
    ingredients_str, allergens_str = split(s[1 : end - 1], " (contains ")
    return split(ingredients_str), split(allergens_str, ", ")

end

function main()
    input = readlines(stdin)
    foods = parse_food.(input)

    all_ingredients = Set(
        ingredient
        for (ingredients, allergens) in foods
            for ingredient in ingredients)
    all_allergens = Set(
        allergen
        for (ingredients, allergens) in foods
            for allergen in allergens)

    allergen_to_candidate_ingredients = Dict(
        allergen => Set(all_ingredients)
        for allergen in all_allergens)

    for (ingredients, allergens) in foods
        for allergen in allergens
            allergen_to_candidate_ingredients[allergen] = intersect(
                allergen_to_candidate_ingredients[allergen],
                ingredients)
        end
    end

    answer = sum(!any(
        ingredient in candidate_ingredients
        for candidate_ingredients in values(allergen_to_candidate_ingredients))
        for (ingredients, allergens) in foods
            for ingredient in ingredients)
    println(answer)
end

main()
