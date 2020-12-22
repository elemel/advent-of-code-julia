include("../../Julmust.jl")

using .Julmust

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

    allergen_to_ingredient = max_bipartite_matching(
        allergen_to_candidate_ingredients)
    canonical_dangerous_ingredients = [
        ingredient
        for (allergen, ingredient) in sort(collect(allergen_to_ingredient))]
    answer = join(canonical_dangerous_ingredients, ",")
    println(answer)
end

main()
