function fuel(mass)
	result = mass ÷ 3 - 2

	if result <= 0
		return 0
	end

	return result + fuel(result)
end

function main()
	masses = parse.(Int, readlines(stdin))
	println(sum(fuel, masses))
end

main()
