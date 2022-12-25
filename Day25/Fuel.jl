
function toDecimal(s::String)
    s = reverse(s)
    currValue = 0
    for i in eachindex(s)
        placeValue = 5^(i - 1)
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
function toSNAFU(i::Integer)
    places = Vector{Integer}()
    while i != 0
        push!(places, mod(i, 5))
        i = div(i, 5)
    end

    #println(places)

    s = ""

    for j in eachindex(places)
        if places[j] == 3
            s = "=" * s
            if j == lastindex(places)
                s = "1" * s
            else
                places[j+1] += 1
            end
        elseif places[j] == 4
            s = "-" * s
            if j == lastindex(places)
                s = 1 * s
            else
                places[j+1] += 1
            end
        elseif places[j] == 5
            s = "0" * s
            if j == lastindex(places)
                s = 1 * s
            else
                places[j+1] += 1
            end
        elseif places[j] == 0
            s = "0" * s
        elseif places[j] == 1
            s = "1" * s
        elseif places[j] == 2
            s = "2" * s
        end
    end

    return s
end

function getFuelRequirement()
    fuelRequirement = 0

    for line in eachline("./Day25/input.txt")
        fuelRequirement += toDecimal(line)
    end

    println(toSNAFU(fuelRequirement))
end