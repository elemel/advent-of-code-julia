include("../../Julmust.jl")

using .Julmust

function is_valid_height(s)
    if length(s) < 3
        return false
    end

    number_str = s[1 : end - 2]
    unit = s[end - 1 : end]

    if !is_digits(number_str)
        return false
    end

    number = parse(Int, number_str)

    if unit == "cm"
        return number >= 150 && number <= 193
    elseif unit == "in"
        return number >= 59 && number <= 76
    else
        return false
    end
end

const REQUIRED_FIELDS = Dict(
    "byr" => s -> is_digits(s) && s >= "1920" && s <= "2002",
    "iyr" => s -> is_digits(s) && s >= "2010" && s <= "2020",
    "eyr" => s -> is_digits(s) && s >= "2020" && s <= "2030",
    "hgt" => is_valid_height,
    "hcl" => s -> occursin(r"^#[0-9a-f]{6}$", s),
    "ecl" => s -> occursin(r"^amb|blu|brn|gry|grn|hzl|oth$", s),
    "pid" => s -> occursin(r"^[0-9]{9}$", s),
)

function parse_passport(str)
    Dict(split(key_value_str, ":") for key_value_str in split(str))
end

function is_valid_passport(passport)
    all(
        haskey(passport, key) && pred(passport[key])
        for (key, pred) in REQUIRED_FIELDS)
end

function main()
    input = readlines(stdin)
    passport_strs = split(join(input, "\n"), "\n\n")
    passports = parse_passport.(passport_strs)
    valid_passports = filter(is_valid_passport, passports)
    answer = length(valid_passports)
    println(answer)
end

main()
