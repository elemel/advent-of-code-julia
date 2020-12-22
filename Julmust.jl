# Essential Julia utilities for Advent of Code
module Julmust

using DataStructures

export
    get_grid_cell,
    GRID_DIRECTIONS,
    grid_raycast,
    in_grid_bounds,
    max_bipartite_matching,
    sort_by,
    sort_by!,
    to_deque,
    to_tokenizer_regex,
    tokenize

function sort_by(func, values)
    sort(values, by=f)
end

function sort_by!(func, values)
    sort!(values, by=func)
end

# (dy, dx)
const GRID_DIRECTIONS = [
    (-1, -1), (-1, 0), (-1, 1),
    (0, -1), (0, 1),
    (1, -1), (1, 0), (1, 1),
]

function in_grid_bounds(grid, y, x)
    return y in 1:length(grid) && x in 1:length(grid[y])
end

function get_grid_cell(grid, y, x, default)
     return in_grid_bounds(grid, y, x) ? grid[y][x] : default
 end

function grid_raycast(grid, y, x, dy, dx, default)
    while true
        y += dy
        x += dx

        if !in_grid_bounds(grid, y, x)
            return default
        end

        if grid[y][x] != default
            return grid[y][x]
        end
    end
end

function to_token_pattern(s::String)
    return replace(s, r"(\W)" => s"\\\1")
end

function to_token_pattern(re::Regex)
    return re.pattern
end

function to_tokenizer_regex(named_matchers)
    named_patterns = [
        (name, to_token_pattern(matcher))
        for (name, matcher) in named_matchers]
    combined_pattern = join((
        "(?<$name>$pattern)"
        for (name, pattern) in named_patterns),
        "|")
    return Regex(combined_pattern)
end

function tokenize(s, re)
    capture_names = Base.PCRE.capture_names(re.regex)
    named_tokens = []

    while true
        m = match(re, s)

        if m == nothing
            break
        end

        for (i, name) in capture_names
            token = m[i]

            if token != nothing
                prefix = ""

                if m.offsets[i] > 1
                    prefix = s[1 : m.offsets[i] - 1]
                    push!(named_tokens, (nothing, prefix))
                end

                push!(named_tokens, (name, token))
                s = s[length(prefix) + length(token) + 1 : end]
                continue
            end
        end
    end

    if !isempty(s)
        push!(named_tokens, (nothing, s))
    end

    return named_tokens
end

function max_bipartite_matching_search(key_to_candidates, candidate_to_key)
    if isempty(key_to_candidates)
        return true
    end

    key, candidates = pop!(key_to_candidates)

    for candidate in candidates
        if haskey(candidate_to_key, candidate)
            continue
        end

        candidate_to_key[candidate] = key

        if max_bipartite_matching_search(key_to_candidates, candidate_to_key)
            return true
        end

        # Backtrack
        delete!(candidate_to_key, candidate)
    end

    # Backtrack
    push!(key_to_candidates, key => candidates)
    return false
end

function max_bipartite_matching(key_to_candidates)
    candidate_to_key = Dict()
    max_bipartite_matching_search(key_to_candidates, candidate_to_key)
    return Dict(key => candidate for (candidate, key) in candidate_to_key)
end

function to_deque(iterable)
    deque = Deque{eltype(iterable)}()

    for element in iterable
        push!(deque, element)
    end

    return deque
end

end # module Julmust
