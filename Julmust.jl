module Julmust

export groupby, sortby, sortby!

function groupby(func, values)
    groups = Dict()

    for value in values
        key  = func(value)

        if !haskey(groups, key)
            groups[key] = []
        end

        push!(groups[key], value)
    end

    groups
end

function sortby(func, values)
    sort(values, by=f)
end

function sortby!(func, values)
    sort!(values, by=func)
end

end # module Julmust
