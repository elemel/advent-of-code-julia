function fuel(mass)
	result = mass ÷ 3 - 2
	result <= 0 ? 0 : result + fuel(result)
end

function main()
	masses = parse.(Int, readlines(stdin))
	println(sum(fuel, masses))
end

main()
