function is_number_in_range(s, r)
    occursin(r"^[1-9][0-9]+$", s) && in(parse(Int, s), r)
end

function is_valid_height(s)
    if endswith(s, "cm")
        return is_number_in_range(s[1 : end - 2], 150:193)
    elseif endswith(s, "in")
        return is_number_in_range(s[1 : end - 2], 59:76)
    else
        return false
    end
end

const REQUIRED_FIELDS = Dict(
    "byr" => s -> is_number_in_range(s, 1920:2002),
    "iyr" => s -> is_number_in_range(s, 2010:2020),
    "eyr" => s -> is_number_in_range(s, 2020:2030),
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
