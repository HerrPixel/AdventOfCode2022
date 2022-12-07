using DataStructures

function getSizesBelowThreshold(lowerThan::Integer)
    DirSizes = getDirectorySizes()
    println(sum(filter(x -> x ≤ lowerThan, DirSizes)))
end

function makeEnoughSpace(spaceNeeded::Integer, maxSystemSpace::Integer)
    DirSizes = getDirectorySizes()
    #println(DirSizes[1])
    #println(DirSizes)
    currSpaceLeft = maxSystemSpace - last(DirSizes)
    currSpaceNeeded = spaceNeeded - currSpaceLeft
    DirSizes = filter(x -> x ≥ currSpaceNeeded, DirSizes)
    println(reduce(min,DirSizes))
end

#=
    cap = resolveStack2(Nodes, SizesOfNodes)
    println("We have a size of ", cap)
    need = 30000000 - (70000000 - cap)
    best = 70000000
    for i in SizesOfNodes
        if i ≥ need && i < best
            best = i
        end
    end
    println(best)



=#

function getDirectorySizes()
    SizesOfNodes = Vector{Integer}()
    Nodes = Stack{Integer}()
    for line in eachline("./Day7/input.txt")
        parseLine(line, Nodes, SizesOfNodes)
    end
    resolveStack(Nodes, SizesOfNodes)
    return SizesOfNodes
    #println(sum(filter( x -> x ≤ LowerThan, SizesOfNodes)))
end

function parseLine(line::String, Nodes::Stack{Integer}, SizesOfNodes::Vector{Integer})
    if line[1] == '$'
        parseCommand(line,Nodes,SizesOfNodes)
    else
        parseDirectoryEntry(line,Nodes)
    end
    return
end

function parseDirectoryEntry(entry::String, Nodes::Stack{Integer})
    if entry[1] != 'd'
        addFileSize(entry,Nodes)
    end
    return
end

function addFileSize(entry::String, Nodes::Stack{Integer})
    output = split(entry, " ")
    push!(Nodes, pop!(Nodes) + parse(Int, output[1]))
    return
end

function parseCommand(command::String, Nodes::Stack{Integer}, SizesOfNodes::Vector{Integer})
    if command[3] == 'c'
        parseDirectoryChange(command, Nodes, SizesOfNodes)
    end
    return
end

function parseDirectoryChange(command::String, Nodes::Stack{Integer}, SizesOfNodes::Vector{Integer})
    if command[6] == '.'
        GoUpDirectory(Nodes, SizesOfNodes)
    else
        GoDownDirectory(Nodes)
    end
    return
end

function GoUpDirectory(Nodes::Stack{Integer}, SizesOfNodes::Vector{Integer}) 
    DirectorySize = pop!(Nodes)
    push!(SizesOfNodes, DirectorySize)
    push!(Nodes, pop!(Nodes) + DirectorySize)
    return
end

function GoDownDirectory(Nodes::Stack{Integer})
    push!(Nodes,0)
    return
end

function resolveStack(Nodes::Stack{Integer}, SizesOfNodes::Vector{Integer})
    while !isempty(Nodes)
        dirSize = pop!(Nodes)
        push!(SizesOfNodes, dirSize)
        if !isempty(Nodes)
            push!(Nodes, pop!(Nodes) + dirSize)
        end
    end 
end

#--------------------------------------

#=
function getBest()
    SizesOfNodes = Vector{Int64}()
    Nodes = Stack{fNode}()
    for line in eachline("./Day7/input.txt")
        parseCommand2(line, Nodes, SizesOfNodes)
    end
    cap = resolveStack2(Nodes, SizesOfNodes)
    println("We have a size of ", cap)
    need = 30000000 - (70000000 - cap)
    best = 70000000
    for i in SizesOfNodes
        if i ≥ need && i < best
            best = i
        end
    end
    println(best)
end

function parseCommand2(command::String, Nodes::Stack{fNode}, SizesOfNodes::Vector{Int64})
    if command[1] == '$'
        if command[3] == 'c'
            if command[6] == '.'
                dirSize = getSize(first(Nodes))
                push!(SizesOfNodes, dirSize)
                pop!(Nodes)
                addSize!(first(Nodes), dirSize)
            else
                push!(Nodes, fNode(0))
            end
        end
    elseif command[1] != 'd'
        output = split(command, " ")
        addSize!(first(Nodes), parse(Int64, output[1]))
    end
end

function resolveStack2(Nodes::Stack{fNode}, SizesOfNodes::Vector{Int64})
    while !isempty(Nodes)
        dirSize = getSize(first(Nodes))
        push!(SizesOfNodes, dirSize)
        pop!(Nodes)
        if !isempty(Nodes)
            addSize!(first(Nodes), dirSize)
        else
            return dirSize
        end
    end
end

=#