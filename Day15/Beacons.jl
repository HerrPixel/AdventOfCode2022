struct sensor
    xCoords::Integer
    yCoords::Integer
    xBeacon::Integer
    yBeacon::Integer
    range::Integer

    function sensor(xCoords::Integer,yCoords::Integer,xBeacon::Integer,yBeacon::Integer,range::Integer)
        return new(xCoords,yCoords,xBeacon,yBeacon,range)
    end
end

function calculateDistressBeacon()

    function testBounds(point::Pair{<:Integer,<:Integer})
        if point.first ≤ 4000000 && point.second ≤ 4000000 && point.first ≥ 0 && point.second ≥ 0     
            found = true
            for t in sensors
                if distance(point,Pair(t.xCoords,t.yCoords)) ≤ t.range
                    found = false
                end
            end
        end
        return found
    end



    sensors = parseInput()

    point = Pair(0,0)
    found = false
    for s in sensors
        point = Pair(s.xCoords,s.yCoords + s.range + 1)
        for i in 0:s.range
            found = testBounds(point)
            if found
                println(point.first * 4000000 + point.second)
                return
            end
            point = Pair(point.first + 1,point.second - 1)
        end

        point = Pair(s.xCoords + s.range + 1,s.yCoords)
        for i in 0:s.range
            found = testBounds(point)
            if found
                println(point.first * 4000000 + point.second)
                return
            end
            point = Pair(point.first - 1,point.second - 1)
        end

        point = Pair(s.xCoords,s.yCoords - s.range - 1)
        for i in 0:s.range
            found = testBounds(point)
            if found
                println(point.first * 4000000 + point.second)
                return
            end
            point = Pair(point.first - 1,point.second + 1)
        end

        point = Pair(s.xCoords - s.range -1,s.yCoords)
        for i in 0:s.range
            found = testBounds(point)
            if found
                println(point.first * 4000000 + point.second)
                return
            end
            point = Pair(point.first + 1,point.second + 1)
        end
    end

end

function calculateEmptyspots(yLevel::Integer)
    spaces = Set{Pair{Integer,Integer}}()

    sensors = parseInput()
    for s in sensors
        start = Pair(s.xCoords,s.yCoords)
        RightGoal = Pair(s.xCoords,yLevel)
        LeftGoal = Pair(s.xCoords,yLevel)
        while distance(start,RightGoal) ≤ s.range
            if RightGoal ≠ Pair(s.xBeacon,s.yBeacon) && RightGoal ∉ spaces
                push!(spaces,RightGoal)
            end
            if LeftGoal ≠ Pair(s.xBeacon,s.yBeacon) && LeftGoal ∉ spaces
                push!(spaces,LeftGoal)
            end
            RightGoal = Pair(RightGoal.first + 1,RightGoal.second)
            LeftGoal = Pair(LeftGoal.first -1, LeftGoal.second)
        end
    end

    println(length(spaces))
end

function parseInput()

    sensors = Vector{sensor}()

    for line in eachline("./Day15/input.txt")
        words = split(line," ")
        xCoords = parse(Int,words[3][3:end-1])
        yCoords = parse(Int,words[4][3:end-1])
        xBeacon = parse(Int,words[9][3:end-1])
        yBeacon = parse(Int,words[10][3:end])
        range = abs(xBeacon - xCoords) + abs(yBeacon - yCoords)
        push!(sensors,sensor(xCoords,yCoords,xBeacon,yBeacon,range))
    end
    return sensors
end

function distance(xCoords,yCoords,xGoal,yGoal)
    return abs(xGoal - xCoords) + abs(yGoal - yCoords)
end

function distance(start::Pair{<:Integer,<:Integer},goal::Pair{<:Integer,<:Integer})
    return abs(start.first - goal.first) + abs(start.second - goal.second)
end