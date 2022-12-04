function DominatingSections()
    NoOfDominatingSections = 0

    for line in eachline("./Day4/input.txt")
        ranges = split(line, ",")
        range1 = split(ranges[1],"-")
        range2 = split(ranges[2],"-")

        IntRange1 = [parse(Int64,x) for x in range1]
        IntRange2 = [parse(Int64,x) for x in range2]
        if (IntRange1[1] ≤ IntRange2[1] && IntRange1[2] ≥ IntRange2[2]) || (IntRange2[1] ≤ IntRange1[1] && IntRange2[2] ≥ IntRange1[2])
            #println(IntRange1, " are dominating ", IntRange2)
            NoOfDominatingSections += 1
        end
    end
    println(NoOfDominatingSections)
end


function DominatingSections2()
    NoOfDominatingSections = 0

    for line in eachline("./Day4/input.txt")
        ranges = split(line, ",")
        range1 = split(ranges[1],"-")
        range2 = split(ranges[2],"-")

        IntRange1 = [parse(Int64,x) for x in range1]
        IntRange2 = [parse(Int64,x) for x in range2]
        if (IntRange1[1] ≤ IntRange2[1] && IntRange1[2] ≥ IntRange2[2]) || (IntRange2[1] ≤ IntRange1[1] && IntRange2[2] ≥ IntRange1[2])
            #println(IntRange1, " are dominating ", IntRange2)
            NoOfDominatingSections += 1
        elseif (IntRange1[1] ≤ IntRange2[1] ≤ IntRange1[2] ≤ IntRange2[2])
            NoOfDominatingSections += 1
        elseif (IntRange2[1] ≤ IntRange1[1] ≤ IntRange2[2] ≤ IntRange1[2])
            NoOfDominatingSections += 1
        end
    end
    println(NoOfDominatingSections)
end
