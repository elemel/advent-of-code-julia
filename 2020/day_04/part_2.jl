const EYE_COLORS = Set(split("amb blu brn gry grn hzl oth"))

function is_number_in_range(str, r)
    return occursin(r"^[1-9][0-9]+$", str) && parse(Int, str) in r
end

function is_valid_height(str)
    if endswith(str, "cm")
        return is_number_in_range(str[1 : end - 2], 150:193)
    elseif endswith(str, "in")
        return is_number_in_range(str[1 : end - 2], 59:76)
    else
        return false
    end
end

const REQUIRED_FIELDS = Dict(
    "byr" => value -> is_number_in_range(value, 1920:2002),
    "iyr" => value -> is_number_in_range(value, 2010:2020),
    "eyr" => value -> is_number_in_range(value, 2020:2030),
    "hgt" => is_valid_height,
    "hcl" => value -> occursin(r"^#[0-9a-f]{6}$", value),
    "ecl" => value -> value in EYE_COLORS,
    "pid" => value -> occursin(r"^[0-9]{9}$", value))

function parse_passport(str)
    return Dict(split(key_value_str, ":") for key_value_str in split(str))
end

function is_valid_passport(passport)
    return all(
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
