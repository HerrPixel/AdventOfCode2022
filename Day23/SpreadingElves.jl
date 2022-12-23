function parseInput()
    Positions = Dict()
    
    i = 1
    for line in eachline("./Day23/input.txt")
        j = 1
        for c in line
            if c == '#'
                Positions[(j,i)] = 0
            end
            j += 1
        end
        i += 1
    end
    return Positions
end

function Part1()
    Positions = Part1()
   
    for i in 1:10
        Propositions = Dict()
        for elf in Positions
            x = elf[1][1]
            y = elf[1][2]
            state = elf[2]
            if allFree(x,y,Positions)
                Propositions[(x,y)] = 1
            else
                found = false
                for j in 0:3
                    if checkDirection(x,y,Positions,state,Propositions)
                        found = true
                        break
                    else
                        state = mod(state+1,4)
                    end
                end
                # if nothing is free
                if !found
                    addProposition(x,y,Propositions)
                end
            end
        end

        #phase 2
end

function allFree(x,y,Positions)
    right = haskey(Positions,(x,y+1)) || haskey(Positions,(x+1,y+1)) || haskey(Positions,(x+1,y)) || haskey(Positions,(x+1,y-1))
    left = haskey(Positions,(x-1,y+1)) || haskey(Positions,(x-1,y)) || haskey(Positions,(x-1,y-1)) || haskey(Positions,(x,y-1))
    return !(right || left)
end

function checkDirection(x,y,Positions,state,Propositions)
    if state == 0 && north(x,y,Positions)
        addProposition(x,y+1,Propositions)
    elseif state == 1 && south(x,y,Positions)
        addProposition(x,y-1,Propositions)
    elseif state == 2 && west(x,y,Positions)
        addProposition(x-1,y,Propositions)
    elseif state == 3 && east(x,y,Positions)
        addProposition(x+1,y,Propositions)
    else
        return false
    end
    return true
end

function north(x,y,Positions)
    return !(haskey(Positions,(x-1,y+1)) || haskey(Positions,(x,y+1)) || haskey(Positions,(x+1,y+1)))
end

function east(x,y,Positions)
    return !(haskey(Positions,(x+1,y+1)) || haskey(Positions,(x+1,y)) || haskey(Positions,(x+1,y-1)))
end

function south(x,y,Positions)
    return !(haskey(Positions,(x+1,y-1)) || haskey(Positions,(x,y-1)) || haskey(Positions,(x-1,y-1)))
end

function west(x,y,Positions)
    return !(haskey(Positions,(x-1,y-1)) || haskey(Positions,(x-1,y)) || haskey(Positions,(x-1,y+1)))
end

function addProposition(x,y,Propositions)
    if haskey(Propositions,(x,y))
        Propositions[(x,y)] = Propositions[(x,y)] + 1
    else
        Propositions[(x,y)] = 1
    end
end