
# Solution to puzzle1 is getFuelRequirement()
# Solution to puzzle2 is [redacted]

# We convert every number to decimal, sum them up and then convert them back
function getFuelRequirement()
    fuelRequirement = 0

    for line in eachline("./Day25/input.txt")
        fuelRequirement += toDecimal(line)
    end

    println(toSNAFU(fuelRequirement))
end

# going from the least significant digit to the most significant,
# we add each corresponding digit with its value to a counter and 
# we then have the decimal value if we sum it all up
function toDecimal(s::String)

    # going from least significant to most significant,
    # we have to reverse the string
    s = reverse(s)
    currValue = 0

    for i in eachindex(s)
        # the value of the current position
        # since julia is 1-indexed, we need i-1 in the exponent
        placeValue = 5^(i - 1)

        # "-" and "=" need special treatment,
        # the other digits we can just parse
        if s[i] == '-'
            currValue += -1 * placeValue
        elseif s[i] == '='
            currValue += -2 * placeValue
        else
            currValue += parse(Int, s[i]) * placeValue
        end
    end
    return currValue
end

# we first convert our number to base 5 and 
# then shift the values to balanced quinary starting from least significant
function toSNAFU(i::Integer)
    places = Vector{Integer}()
    s = ""

    # converting to base 5 and storing digits in a Vector
    while i != 0
        push!(places, mod(i, 5))
        i = div(i, 5)
    end
    # this is for a potential overflow of the most significant digit
    push!(places, 0)

    for j in eachindex(places)

        # 3,4 and 5 need special treatment, the rest we can just convert
        if places[j] == 3
            s = "=" * s
            places[j+1] += 1
        elseif places[j] == 4
            s = "-" * s
            places[j+1] += 1

            # this is for an overflow of a digit
        elseif places[j] == 5
            s = "0" * s
            places[j+1] += 1
        else
            s = string(places[j]) * s
        end
    end

    # if no overflow in the most significant digit happened, we remove this helper
    s = lstrip(s, '0')

    return s
end