function main()
    module_masses = parse.(Int, readlines(stdin))
    total_fuel_mass = 0

    while !isempty(module_masses)
    	module_mass = pop!(module_masses)
    	fuel_mass = fld(module_mass, 3) - 2

    	if fuel_mass > 0
    		total_fuel_mass += fuel_mass
    		push!(module_masses, fuel_mass)
    	end
    end

    println(total_fuel_mass)
end

main()
