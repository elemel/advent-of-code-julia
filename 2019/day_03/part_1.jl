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
    visited_set = Set()

    x = 0
    y = 0

    for ray in path
        (dx, dy), length = ray

        for _ = 1:length
            x = x + dx
            y = y + dy

            push!(visited_set, (x, y))
        end
    end

    visited_set
end

function main()
    paths = parse_path.(readlines(stdin))
    visited_sets = render_path.(paths)
    intersections = intersect(visited_sets...)
    println(minimum(abs(x) + abs(y) for (x, y) in intersections))
end

main()
