# See: https://math.stackexchange.com/a/3864593
function combine_phased_rotations(a_period, a_phase, b_period, b_phase)
    d, s, t = gcdx(a_period, b_period)
    phase_difference = a_phase - b_phase
    pd_mult, pd_remainder = fldmod(phase_difference, d)
    @assert pd_remainder == 0
    combined_period = fld(a_period, d) * b_period
    combined_phase = mod(a_phase - s * pd_mult * a_period, combined_period)
    return combined_period, combined_phase
end

function main()
    input = readlines(stdin)
    constraints = [
        (i - 1, parse(Int128, s))
        for (i, s) in enumerate(split(input[2], ","))
            if s != "x"]
    period, phase = 1, 0

    for (offset, bus_id) in constraints
        period, phase = combine_phased_rotations(period, phase, bus_id, offset)
    end

    answer = period - phase
    println(answer)
end

main()
