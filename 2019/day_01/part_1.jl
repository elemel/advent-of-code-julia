function main()
    module_masses = parse.(Int, readlines(stdin))
    total_fuel_mass = sum(mass -> fld(mass, 3) - 2, module_masses)
    println(total_fuel_mass)
end

main()
