using IterTools
 
function is_valid_password(password)
    groups = groupby(identity, string(password))

    if !any(length(group) == 2 for group in groups)
        return false
    end

    chars = split(string(password), "")

    if chars != sort(chars)
        return false
    end

    true
end

function main()
    first_password, last_password =
        parse.(Int, split(strip(read(stdin, String)), "-"))

    println(count(is_valid_password, first_password:last_password))
end

main()
