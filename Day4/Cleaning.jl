# Answer to Puzzle1 is DominatingSections()
# Answer to Puzzle2 is OverlappingSections()

# We iterate over all lines, splitting each line to its corresponding
# ranges of sections and get them wrapped up in a nice struct.
# We then calculate if they dominate by comparisons of their
# start and endpoints. 
function DominatingSections()
    NoOfDominatingSections = 0

    for line in eachline("./Day4/input.txt")
        ranges = split(line, ",")

        # We outsourced this work to a wrapper struct and function
        # to hide some ugly logic calculation
        a = Section(ranges[1])
        b = Section(ranges[2])
        if AreContained(a,b)
            NoOfDominatingSections += 1
        end
    end
    println(NoOfDominatingSections)
end

# We iterate over all lines, splitting each line to its corresponding
# ranges of sections and get them wrapped up in a nice struct.
# We then calculate if they overlap by comparisons of their
# start and endpoints. 
function OverlappingSections()
    NoOfDominatingSections = 0

    for line in eachline("./Day4/input.txt")
        ranges = split(line, ",")

        # We outsourced this work to a wrapper struct and function
        # to hide some ugly logic calculation
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

# range of sections a is fully contained in a range of sections b
# if a's starting point is after b's starting point
# and its end point is before b's end point, see the below:
# ..............[--a--]....................................
#.............[----b-----].................................
function AreContained(a::Section, b::Section)
    AInB = a.startArea ≤ b.startArea && b.endArea ≤ a.endArea
    BInA = b.startArea ≤ a.startArea && a.endArea ≤ b.endArea
    return AInB || BInA
end

# range of sections a is overlapping with a range of sections b
# if a's starting point is after b's starting point but
# before b's end point, see the below:
# ..............[-----a-----]...............................
#...........[----b----]......................................
# The mirrored case is if b's starting point lies in the range of a.
function AreOverlapping(a::Section, b::Section)
    ABeforeB = a.startArea ≤ b.startArea ≤ a.endArea
    BBeforeA = b.startArea ≤ a.startArea ≤ b.endArea
    return ABeforeB || BBeforeA
end


