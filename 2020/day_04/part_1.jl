const REQUIRED_FIELDS = Set(split("""
    byr
    iyr
    eyr
    hgt
    hcl
    ecl
    pid
    """))

function parse_passport(str)
    Dict(split(key_value_str, ":") for key_value_str in split(str))
end

function is_valid_passport(passport)
    all(haskey(passport, key) for key in REQUIRED_FIELDS)
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
