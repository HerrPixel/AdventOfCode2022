

function simulateRocks()

    line = first(eachline("./Day17/input.txt"))
    streamLength = length(line)

    highPoint = 4
    currJet = 1
    hasStopped = false
    currY = 4
    cave = falses(7,14000) #2022*5
    
    
    for i in 0:2021
        #println("Trying Piece ", mod(i,5), " with Bounds= ", Bounds)
        Bounds = getPieceCoordinates(mod(i,5),highPoint)
        #println("Trying Piece ", mod(i,5), " with Bounds= ", Bounds)
        #println(Bounds)
        while !hasStopped

            movement = line[mod(currJet - 1,streamLength) + 1]
            if movement == '<'
                Bounds = moveHorizontal(Bounds,-1,cave)
            else
                Bounds = moveHorizontal(Bounds,1,cave)
            end
            currJet += 1

            #printCave(cave,Bounds)

            result = moveVertical(Bounds,-1,cave)
            #println(result, " is this the same as ", Bounds)
            if result == [[-1]]
                hasStopped = true
                highPoint = max(highestPoint(mod(i,5),currY) + 4,highPoint)
                #println(highPoint)
                for p in Bounds
                    cave[p[1],p[2]] = true
                end
                #println(highestPoint(mod(i,5),currY))
            else
                currY += -1
            end

            #println(" ")
            #printCave(cave,Bounds)
        end
        currY = highPoint
        hasStopped = false
    end

    println(highPoint - 4)
    #printCave(cave)
end

function simulateRocks2()

    
    line = first(eachline("./Day17/input.txt"))
    streamLength = length(line)

    highPoint = 4
    currJet = 1
    hasStopped = false
    currY = 4

    states = Set()
    stateNumber = Dict()
    cave = falses(7,50000) #2022*5
    
    foundDuplicate = false
    remaining = 0
    height = Int128(0)

    heightbeforeEnd = 0


    i = 0
    while !foundDuplicate
        #println("Trying Piece ", mod(i,5), " with Bounds= ", Bounds)
        Bounds = getPieceCoordinates(mod(i,5),highPoint)
        #println("Trying Piece ", mod(i,5), " with Bounds= ", Bounds)
        #println(Bounds)
        while !hasStopped

            movement = line[mod(currJet - 1,streamLength) + 1]
            if movement == '<'
                Bounds = moveHorizontal(Bounds,-1,cave)
            else
                Bounds = moveHorizontal(Bounds,1,cave)
            end
            currJet += 1

            #printCave(cave,Bounds)

            result = moveVertical(Bounds,-1,cave)
            #println(result, " is this the same as ", Bounds)
            if result == [[-1]]
                hasStopped = true
                highPoint = max(highestPoint(mod(i,5),currY) + 4,highPoint)
                #println(highPoint)
                for p in Bounds
                    cave[p[1],p[2]] = true
                end
                #println(highestPoint(mod(i,5),currY))
            else
                currY += -1
            end

            #println(" ")
            #printCave(cave,Bounds)
        end
        currY = highPoint
        hasStopped = false
        i += 1

        depths = Vector{Integer}()
        for j in 1:7
            k = 0
            while k != highPoint && !cave[j,highPoint - k]
                k += 1
            end
            push!(depths,k)
        end

        if (depths,mod(i,5),mod(currJet -1,streamLength) + 1) ∈ states
            foundDuplicate = true
            occurence = stateNumber[(depths,mod(i,5),mod(currJet -1,streamLength) + 1)]
            Heightdiff = highPoint - occurence[2]
            NrDiff = i - occurence[1]

            height += occurence[2] + 4

            middle = div(1000000000000 - occurence[1],NrDiff)
            height += Heightdiff * middle

            remaining = 1000000000000 - occurence[1] - middle * NrDiff
            heightbeforeEnd = highPoint
        else
            push!(states, (depths,mod(i,5),mod(currJet -1,streamLength) + 1))
            push!(stateNumber, (depths,mod(i,5),mod(currJet -1,streamLength) + 1) => (i,highPoint))
        end
    end



    for m in i:i+remaining-1
        Bounds = getPieceCoordinates(mod(i,5),highPoint)
        #println("Trying Piece ", mod(i,5), " with Bounds= ", Bounds)
        #println(Bounds)
        while !hasStopped

            movement = line[mod(currJet - 1,streamLength) + 1]
            if movement == '<'
                Bounds = moveHorizontal(Bounds,-1,cave)
            else
                Bounds = moveHorizontal(Bounds,1,cave)
            end
            currJet += 1

            #printCave(cave,Bounds)

            result = moveVertical(Bounds,-1,cave)
            #println(result, " is this the same as ", Bounds)
            if result == [[-1]]
                hasStopped = true
                highPoint = max(highestPoint(mod(i,5),currY) + 4,highPoint)
                #println(highPoint)
                for p in Bounds
                    cave[p[1],p[2]] = true
                end
                #println(highestPoint(mod(i,5),currY))
            else
                currY += -1
            end

            #println(" ")
            #printCave(cave,Bounds)
        end
        currY = highPoint
        hasStopped = false
        i += 1
    end

    height += highPoint - heightbeforeEnd

    println(remaining)
    println(height - 8) #-8 for some reason
    #println(highPoint - 4)
    #printCave(cave)
end

function printCave(cave::BitMatrix, Bounds::Vector)
    for i in axes(cave,2)
        for j in axes(cave,1)
            if cave[j,lastindex(cave,2)- (i-1)]
                print("█")
            elseif [j,lastindex(cave,2)- (i-1)] ∈ Bounds 
                print("@")
            else
                print(" ")
            end
        end
        println(" ")
    end
end

function getPieceCoordinates(PieceNumber::Integer,y::Integer)
    if PieceNumber == 0
        return Vector([[3,y],[4,y],[5,y],[6,y]])
    elseif PieceNumber == 1
        return Vector([[4,y],[3,y+1],[4,y+1],[5,y+1],[4,y+2]])
    elseif PieceNumber == 2
        return Vector([[3,y],[4,y],[5,y],[5,y+1],[5,y+2]])
    elseif PieceNumber == 3
        return Vector([[3,y],[3,y+1],[3,y+2],[3,y+3]])
    elseif PieceNumber == 4
        return Vector([[3,y],[4,y],[3,y+1],[4,y+1]])
    else
        return Vector([[-1,-1]])
    end
end

function highestPoint(PieceNumber::Integer,y::Integer)
    if PieceNumber == 0
        return y
    elseif PieceNumber == 1
        return y+2
    elseif PieceNumber == 2
        return y+2
    elseif PieceNumber == 3
        return y+3
    elseif PieceNumber == 4
        return y+1
    else
        return -1
    end
end

function moveHorizontal(Positions::Vector,offset::Integer, cave::BitMatrix)
    valid = true
    for p in Positions
        if !(0 < p[1] + offset < 8 && cave[p[1] + offset, p[2]] == false)
            valid = false 
        end
    end
    if valid
        for p in Positions
            p[1] += offset
        end
    end
    return Positions
end

function moveVertical(Positions::Vector,offset::Integer, cave::BitMatrix)
    valid = true
    for p in Positions
        if !(0 < p[2] + offset && cave[p[1],p[2] + offset] == false)
            valid = false
        end
    end
    if valid
        for p in Positions
            p[2] += offset
        end
        return Positions
    else
        return [[-1]]
    end
end