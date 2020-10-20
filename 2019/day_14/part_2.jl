using DataStructures

struct ChemicalQuantity
    quantity::Int
    chemical::String
end

struct Reaction
    inputs::Array{ChemicalQuantity}
    output::ChemicalQuantity
end

function parse_chemical_quantity(str)
    quantity_str, chemical = split(str)
    quantity = parse(Int, quantity_str)
    ChemicalQuantity(quantity, chemical)
end

function parse_reaction(str)
    inputs_str, output_str = split(str, " => ")

    inputs = map(parse_chemical_quantity, split(inputs_str, ", "))
    output = parse_chemical_quantity(output_str)

    Reaction(inputs, output)
end

function produce!(chemical_to_demand, output_chemical_to_reaction)
    queue = Deque{String}()

    for chemical in keys(chemical_to_demand)
        push!(queue, chemical)
    end

    while !isempty(queue)
        output_chemical = popfirst!(queue)

        if !haskey(output_chemical_to_reaction, output_chemical)
            continue
        end

        if chemical_to_demand[output_chemical] <= 0
            continue
        end

        reaction = output_chemical_to_reaction[output_chemical]
        output_quantity = reaction.output.quantity

        reaction_count = cld(
            chemical_to_demand[output_chemical], output_quantity)

        for input in reaction.inputs
            chemical_to_demand[input.chemical] +=
                reaction_count * input.quantity

            push!(queue, input.chemical)
        end

        chemical_to_demand[output_chemical] -= reaction_count * output_quantity
    end
end

function main()
    reactions = map(parse_reaction, readlines(stdin))

    output_chemical_to_reaction = Dict(
        reaction.output.chemical => reaction
        for reaction in reactions)

    ore_supply = 1000000000000

    lower_bound_inclusive = 0
    upper_bound_exclusive = 1

    # Find upper bound
    while true
        chemical_to_demand = DefaultDict(0, "FUEL" => upper_bound_exclusive)
        produce!(chemical_to_demand, output_chemical_to_reaction)

        if chemical_to_demand["ORE"] > ore_supply
            break
        end

        upper_bound_exclusive *= 2
    end

    # Binary search
    while lower_bound_inclusive < upper_bound_exclusive - 1
        fuel_demand = fld(lower_bound_inclusive + upper_bound_exclusive, 2)
        @assert lower_bound_inclusive < fuel_demand < upper_bound_exclusive

        chemical_to_demand = DefaultDict(0, "FUEL" => fuel_demand)
        produce!(chemical_to_demand, output_chemical_to_reaction)

        if chemical_to_demand["ORE"] <= ore_supply
            lower_bound_inclusive = fuel_demand
        else
            upper_bound_exclusive = fuel_demand
        end
    end

    println(lower_bound_inclusive)
end

main()
