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

    chemical_to_demand = DefaultDict(0, "FUEL" => 1)
    produce!(chemical_to_demand, output_chemical_to_reaction)
    println(chemical_to_demand["ORE"])
end

main()
