
function parseInput()
    visitedSpaces = Set{Pair{Integer,Integer}}()
    push!(visitedSpaces,Pair(0,0))
    ropes = Vector{Pair{Integer,Integer}}()
    for i in 1:10
        push!(ropes,Pair(0,0))
    end

    for line in eachline("./Day9/input.txt")
        words = split(line," ")
        if words[1] == "U"
            ropes,visitedSpaces = moveHeadPos(ropes,visitedSpaces,0,parse(Int,words[2]))
        elseif words[1] == "D"
            ropes,visitedSpaces = moveHeadNeg(ropes,visitedSpaces,0,parse(Int,words[2]))
        elseif words[1] == "R"
            ropes,visitedSpaces = moveHeadPos(ropes,visitedSpaces,parse(Int,words[2]),0)
        elseif words[1] == "L"
            ropes,visitedSpaces = moveHeadNeg(ropes,visitedSpaces,parse(Int,words[2]),0)
        end
    end
    println(length(visitedSpaces))
    #println(visitedSpaces)
end

function moveHeadPos(ropes::Vector{Pair{Integer,Integer}}, visitedSpaces::Set{Pair{Integer,Integer}}, headChangeX::Integer, headChangeY::Integer)
    for i in 1:headChangeX
        ropes[1] = Pair(ropes[1].first + 1, ropes[1].second)
        ropes,visitedSpaces = TailFollow(ropes,visitedSpaces)
    end
    for i in 1:headChangeY
        ropes[1] = Pair(ropes[1].first, ropes[1].second +1)
        ropes,visitedSpaces = TailFollow(ropes,visitedSpaces)
    end
    return ropes,visitedSpaces
end 

function moveHeadNeg(ropes::Vector{Pair{Integer,Integer}}, visitedSpaces::Set{Pair{Integer,Integer}}, headChangeX::Integer, headChangeY::Integer)
    for i in 1:headChangeX
        ropes[1] = Pair(ropes[1].first - 1, ropes[1].second)
        ropes,visitedSpaces = TailFollow(ropes,visitedSpaces)
    end
    for i in 1:headChangeY
        ropes[1] = Pair(ropes[1].first, ropes[1].second -1 )
        ropes,visitedSpaces = TailFollow(ropes,visitedSpaces)
    end
    return ropes,visitedSpaces
end 

function TailFollow(ropes::Vector{Pair{Integer,Integer}}, visitedSpaces::Set{Pair{Integer,Integer}})
    #println("Currently having the tail at ", tailX, " ", tailY)
    #println("And the head at ", headX, " ", headY)
    for i in 1:9
        headX = ropes[i].first
        headY = ropes[i].second
        tailX = ropes[i+1].first
        tailY = ropes[i+1].second
        if abs(tailX - headX) > 1
            if headX > tailX
                tailX += 1
            else
                tailX += -1
            end

            if headY ≠ tailY
                if headY > tailY
                    tailY += 1
                else
                    tailY += -1
                end
            end
        elseif abs(tailY - headY) > 1
            if headY > tailY
                tailY += 1
            else
                tailY += -1
            end

            if headX ≠ tailX
                if headX > tailX
                    tailX += 1
                else
                    tailX += -1
                end
            end
        end
        ropes[i] = Pair(headX,headY)
        ropes[i+1] = Pair(tailX,tailY)
    end
    push!(visitedSpaces, ropes[10])
    return ropes,visitedSpaces
end