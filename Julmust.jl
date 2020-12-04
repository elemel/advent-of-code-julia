module Julmust

export is_digits, is_hex_digit, is_hex_digits, sort_by, sort_by!

function sort_by(func, values)
    sort(values, by=f)
end

function sort_by!(func, values)
    sort!(values, by=func)
end

function is_digits(s)
    all(isdigit(c) for c in s)
end

function is_hex_digit(c)
    isdigit(c) || c >= 'a' && c <= 'f'
end

function is_hex_digits(s)
    all(is_hex_digit(c) for c in s)
end

end # module Julmust
