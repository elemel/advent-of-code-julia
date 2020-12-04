module Julmust

export sort_by, sort_by!

function sort_by(func, values)
    sort(values, by=f)
end

function sort_by!(func, values)
    sort!(values, by=func)
end

end # module Julmust
