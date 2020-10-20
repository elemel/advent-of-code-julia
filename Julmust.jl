module Julmust

export sortby, sortby!

function sortby(func, values)
    sort(values, by=f)
end

function sortby!(func, values)
    sort!(values, by=func)
end

end # module Julmust
