DIRECTIONS = Dict(
    'D' => (0, 1),
    'L' => (-1, 0),
    'R' => (1, 0),
    'U' => (0, -1),
)

function parse_ray(ray_str)
    DIRECTIONS[ray_str[1]], parse(Int, ray_str[2:end])
end

function parse_path(path_str)
    [parse_ray(ray_str) for ray_str in split(path_str, ",")]
end

function render_path(path)
    distances = Dict()

    x = 0
    y = 0

    distance = 0

    for ray in path
        (dx, dy), length = ray

        for _ = 1:length
            x = x + dx
            y = y + dy

            distance = distance + 1

            if !haskey(distances, (x, y))
                distances[x, y] = distance
            end
        end
    end

    distances
end

function main()
    paths = parse_path.(readlines(stdin))
    distance_dicts = render_path.(paths)
    visited_sets = Set.(keys.(distance_dicts))
    intersections = intersect(visited_sets...)

    combined_intersection_distances = [
        sum(distances[intersection] for distances in distance_dicts)
        for intersection in intersections
    ]

    println(min(combined_intersection_distances...))
end

main()
