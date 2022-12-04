function DominatingSections()
    NoOfDominatingSections = 0

    for line in eachline("./Day4/input.txt")
        ranges = split(line, ",")
        a = Section(ranges[1])
        b = Section(ranges[2])
        if AreContained(a,b)
            NoOfDominatingSections += 1
        end
    end
    println(NoOfDominatingSections)
end


function OverlappingSections()
    NoOfDominatingSections = 0

    for line in eachline("./Day4/input.txt")
        ranges = split(line, ",")
        a = Section(ranges[1])
        b = Section(ranges[2])
        if AreOverlapping(a,b)
            NoOfDominatingSections += 1
        end
    end
    println(NoOfDominatingSections)
end

struct Section
    startArea::Integer
    endArea::Integer

    function Section(RangeString::AbstractString)
        SplittedString = split(RangeString,"-")
        return new(parse(Int64,SplittedString[1]), parse(Int64,SplittedString[2]))
    end
end

function AreContained(a::Section, b::Section)
    AInB = a.startArea ≤ b.startArea && b.endArea ≤ a.endArea
    BInA = b.startArea ≤ a.startArea && a.endArea ≤ b.endArea
    return AInB || BInA
end

function AreOverlapping(a::Section, b::Section)
    ABeforeB = a.startArea ≤ b.startArea ≤ a.endArea
    BBeforeA = b.startArea ≤ a.startArea ≤ b.endArea
    return ABeforeB || BBeforeA
end


