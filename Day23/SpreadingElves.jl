function parseInput()
    Positions = Dict()

    i = 1
    for line in eachline("./Day23/smallerInput.txt")
        j = 1
        for c in line
            if c == '#'
                Positions[(j, i)] = 0
            end
            j += 1
        end
        i += 1
    end
    return Positions
end

function Part1()
    Positions = parseInput()

    for elf in Positions
        println(elf[1][1], ";", elf[1][2])
    end
    println("")

    for i in 1:10
        Propositions = Dict()
        for elf in Positions
            #println(elf)
            x = elf[1][1]
            y = elf[1][2]
            if allFree(x, y, Positions)
                Propositions[(x, y)] = 1
                Positions[(x, y)] = Positions[(x, y)] + 4
            else
                found = false
                for j in 0:3
                    #println("Checking direction ", Positions[(x, y)], " from coordinates ", x, ",", y)
                    if checkDirection(x, y, Positions, Positions[(x, y)], Propositions)
                        found = true
                        break
                    else
                        Positions[(x, y)] = mod(Positions[(x, y)] + 1, 4)
                    end
                end
                # if nothing is free
                if !found
                    addProposition(x, y, Propositions)
                    Positions[(x, y)] = Positions[(x, y)] + 4
                end
            end
        end

        #phase 2


        #println(Propositions)
        NewPositions = Dict()
        for elf in Positions
            x = elf[1][1]
            y = elf[1][2]
            state = elf[2]
            MoveIfFree(x, y, state, Propositions, Positions, NewPositions)
        end
        Positions = NewPositions

        # state only changes once per round
        for elf in Positions
            println(elf[1][1], ";", elf[1][2])
        end
        println("")

    end

    maxX = 0
    minX = 0
    maxY = 0
    minY = 0
    for elf in Positions
        x = elf[1][1]
        y = elf[1][2]
        println(x, ",", y)
        maxX = max(x, maxX)
        minX = min(x, minX)
        maxY = max(y, maxY)
        minY = min(y, minY)
    end

    width = abs(maxX - minX) + 1
    println(width)
    height = abs(maxY - minY) + 1
    println(height)
    RectangleSize = width * height
    finalsize = RectangleSize - length(Positions)
    println(finalsize)
end

function MoveIfFree(x, y, state, Propositions, Positions, NewPositions)
    if state == 0 && get(Propositions, (x, y - 1), 0) == 1
        delete!(Positions, (x, y))
        NewPositions[(x, y - 1)] = state + 1
    elseif state == 1 && get(Propositions, (x, y + 1), 0) == 1
        delete!(Positions, (x, y))
        NewPositions[(x, y + 1)] = state + 1
    elseif state == 2 && get(Propositions, (x - 1, y), 0) == 1
        delete!(Positions, (x, y))
        NewPositions[(x - 1, y)] = state + 1
    elseif state == 3 && get(Propositions, (x + 1, y), 0) == 1
        delete!(Positions, (x, y))
        NewPositions[(x + 1, y)] = 0
    else
        NewPositions[(x, y)] = mod(state + 1, 4)
    end
end


function allFree(x, y, Positions)
    right = haskey(Positions, (x, y + 1)) || haskey(Positions, (x + 1, y + 1)) || haskey(Positions, (x + 1, y)) || haskey(Positions, (x + 1, y - 1))
    left = haskey(Positions, (x - 1, y + 1)) || haskey(Positions, (x - 1, y)) || haskey(Positions, (x - 1, y - 1)) || haskey(Positions, (x, y - 1))
    return !(right || left)
end

function checkDirection(x, y, Positions, state, Propositions)

    if state == 0 && north(x, y, Positions)
        addProposition(x, y - 1, Propositions)
    elseif state == 1 && south(x, y, Positions)
        addProposition(x, y + 1, Propositions)
    elseif state == 2 && west(x, y, Positions)
        addProposition(x - 1, y, Propositions)
    elseif state == 3 && east(x, y, Positions)
        addProposition(x + 1, y, Propositions)
    else
        return false
    end
    return true
end

function north(x, y, Positions)
    return !(haskey(Positions, (x - 1, y - 1)) || haskey(Positions, (x, y - 1)) || haskey(Positions, (x + 1, y - 1)))
end

function east(x, y, Positions)
    return !(haskey(Positions, (x + 1, y + 1)) || haskey(Positions, (x + 1, y)) || haskey(Positions, (x + 1, y - 1)))
end

function south(x, y, Positions)
    return !(haskey(Positions, (x + 1, y + 1)) || haskey(Positions, (x, y + 1)) || haskey(Positions, (x - 1, y + 1)))
end

function west(x, y, Positions)
    return !(haskey(Positions, (x - 1, y - 1)) || haskey(Positions, (x - 1, y)) || haskey(Positions, (x - 1, y + 1)))
end

function addProposition(x, y, Propositions)
    if haskey(Propositions, (x, y))
        Propositions[(x, y)] = Propositions[(x, y)] + 1
    else
        Propositions[(x, y)] = 1
    end
end