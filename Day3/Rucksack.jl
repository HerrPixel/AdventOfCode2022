# Answer to Puzzle 1 is GetPriorityOfWrongItems()
# Answer to Puzzle 2 is GetPriorityOfBadges()


# We iterate over all lines, split each line in two and check if any char
# of the first half occurs in the second one. If it does, we add its priority
# and go to the next line.
function GetPriorityOfWrongItems()
    totalPriority = 0

    for line in eachline("./Day3/input.txt")
        middle = Int(length(line)/2)
        firstCompartment = first(line, middle)
        secondCompartment = last(line, middle)
        for c in firstCompartment
            if occursin(c,secondCompartment)
                totalPriority += _Priority(c)
                break # <- Important, otherwise we would add multiple occurences of the wrong item
            end
        end
    end
    println(totalPriority)
end

# We take groups of 3 lines, i.e. one group
# and check if any char of the first member occurs in both the other two members.
# If it does, we add its priority and get to the next group.
function GetPriorityOfBadges()
    totalPriority = 0

    # We need this so we can correctly call isempty() and Iterators.take advances the iterator
    lines = Iterators.Stateful(eachline("./Day3/input.txt"))

    while !isempty(lines)
        group = collect(Iterators.take(lines,3))
        for c in group[1]
            if occursin(c, group[2]) && occursin(c, group[3])
                totalPriority += _Priority(c)
                break # <- Important, otherwise we would add multiple occurences of the badge
            end
        end
    end
    println(totalPriority)
end

# Correctly set prioritys according to specification
function _Priority(c::Char)
    if isuppercase(c)
        return Int(c) - 38
    end
    return Int(c) - 96
end