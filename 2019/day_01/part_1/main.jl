function fuel(mass)
	return mass ÷ 3 - 2
end

function main()
	masses = parse.(Int, readlines(stdin))
	println(sum(fuel, masses))
end

main()
