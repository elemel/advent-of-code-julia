function transform_subject_number(subject_number, loop_size)
    result = 1

    for i in 1:loop_size
        result *= subject_number
        result = mod(result, 20201227)
    end

    return result
end

function public_key_to_loop_size(public_key)
    result = 1

    for loop_size in 1:typemax(Int)
        result *= 7
        result = mod(result, 20201227)

        if result == public_key
            return loop_size
        end
    end
end

function main()
    input = readlines(stdin)
    card_public_key, door_public_key = parse.(Int, input)

    card_loop_size = public_key_to_loop_size(card_public_key)
    door_loop_size = public_key_to_loop_size(door_public_key)

    card_encryption_key = transform_subject_number(
        door_public_key, card_loop_size)
    door_encryption_key = transform_subject_number(
        card_public_key, door_loop_size)

    @assert card_encryption_key == door_encryption_key
    answer = card_encryption_key
    println(answer)
end

main()
