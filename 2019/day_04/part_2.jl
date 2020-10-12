using IterTools
 
function is_valid_password(password)
    groups = groupby(identity, password)

    if !in(2, length.(groups))
        return false
    end

    chars = split(password, "")

    if chars != sort(chars)
        return false
    end

    true
end

function main()
    first_password, last_password =
        parse.(Int, split(strip(read(stdin, String)), "-"))

    println(count(
        password -> is_valid_password(string(password)),
        first_password:last_password))
end

main()
