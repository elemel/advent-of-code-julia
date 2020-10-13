using DataStructures

function get_total_orbit_count(object_name, orbit_count, parent_to_children)
    children = parent_to_children[object_name]

    if isempty(children)
        return orbit_count
    end

    orbit_count + sum(
        get_total_orbit_count(child_name, orbit_count + 1, parent_to_children)
        for child_name in children)
end

function main()
    parent_to_children = DefaultDict(Set)

    for line in readlines(stdin)
        parent_name, child_name = strip.(split(line, ")"))
        push!(parent_to_children[parent_name], child_name)
    end

    println(get_total_orbit_count("COM", 0, parent_to_children))
end

main()
