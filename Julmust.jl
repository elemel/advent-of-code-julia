module Julmust

export sortby, sortby!

function sortby(by, v)
    sort(v, by=by)
end

function sortby!(by, v)
    sort!(v, by=by)
end

end # module Julmust
