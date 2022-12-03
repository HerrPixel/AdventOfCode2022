

function GetPriorityOfRucksackDifference()
    totalPriority = 0

    for line in eachline("./Day3/input.txt")
        firstCompartment = first(line, Int(length(line)/2))
        secondCompartment = last(line, Int(length(line)/2))
        NoDuplicate = true
        println("We have ", firstCompartment, " and ", secondCompartment)
        for c in firstCompartment
            if occursin(c,secondCompartment) && NoDuplicate
                println(c, " did occur in it")
                if isuppercase(c)
                    totalPriority += Int(c) - 38
                    NoDuplicate = false;
                else
                    totalPriority += Int(c) - 96
                    NoDuplicate = false;
                end
            end
        end
    end
    println(totalPriority)
end

function GetPriorityOfBadges()
    totalPriority = 0

    lines = Iterators.Stateful(eachline("./Day3/input.txt"))

    while !isempty(lines)
        group = collect(Iterators.take(lines,3))
        println(group)
        NoDuplicate = true
        for c in group[1]
            if occursin(c, group[2]) && occursin(c, group[3]) && NoDuplicate
                println(c, " occurs in both")
                if isuppercase(c)
                    totalPriority += Int(c) - 38
                    NoDuplicate = false 
                else
                    totalPriority += Int(c) - 96
                    NoDuplicate = false
                end
            end
        end
    end
    println(totalPriority)
end