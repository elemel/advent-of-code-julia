using DataStructures

function main()
    child_to_parent = Dict()
    parent_to_children = DefaultDict(Set)

    for line in readlines(stdin)
        parent_name, child_name = strip.(split(line, ")"))
        child_to_parent[child_name] = parent_name
        push!(parent_to_children[parent_name], child_name)
    end

    queue = Deque{Any}()
    push!(queue, (child_to_parent["YOU"], 0))

    visited_set = Set(["YOU"])

    while !isempty(queue)
        object_name, transfer_count = popfirst!(queue)

        if in(object_name, visited_set)
            continue
        end

        push!(visited_set, object_name)

        for child_name in parent_to_children[object_name]
            if child_name == "SAN"
                println(transfer_count)
                return
            end

            push!(queue, (child_name, transfer_count + 1))
        end

        if haskey(child_to_parent, object_name)
            push!(queue, (child_to_parent[object_name], transfer_count + 1))
        end
    end
end

main()
