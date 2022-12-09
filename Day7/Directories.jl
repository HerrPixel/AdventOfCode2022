using DataStructures

# answer to puzzle 1 is getSizesBelowThreshold(100000)
# answer to puzzle 2 is makeEnoughSpace(30000000,70000000)

# We get the sizes of all directories
# and then just filter out those that are too big.
# Lastly we sum up those valid sizes
function getSizesBelowThreshold(lowerThan::Integer)
    DirSizes = getDirectorySizes()
    println(sum(filter(x -> x ≤ lowerThan, DirSizes)))
end

# We again get the sizes of all directories
# and then filter out those directories that are too small
# lastly we choose that valid directory that is smallest
# among all directories big enough.
function makeEnoughSpace(spaceNeeded::Integer, maxSystemSpace::Integer)
    DirSizes = getDirectorySizes()
    currSpaceLeft = maxSystemSpace - last(DirSizes)
    currSpaceNeeded = spaceNeeded - currSpaceLeft
    DirSizes = filter(x -> x ≥ currSpaceNeeded, DirSizes)
    println(reduce(min,DirSizes))
end

# Since the input parses the directory structure via 
# depth first search, we can keep the directories in a Stack
# and push when we go down a directory and pop when we go up.
# Since each directory is only mentioned once, we can savely store
# the final size into a vector of directory sizes
function getDirectorySizes()
    SizesOfNodes = Vector{Integer}()
    Nodes = Stack{Integer}()

    for line in eachline("./Day7/input.txt")
        parseLine(line, Nodes, SizesOfNodes)
    end

    # since the input does not go up to the initial / directory
    # we still need to resolve our current stack, since we update
    # parent directory sizes when poping its children
    resolveStack(Nodes, SizesOfNodes)
    return SizesOfNodes
end

function parseLine(line::String, Nodes::Stack{Integer}, SizesOfNodes::Vector{Integer})
    # A command and a listing can be distuingished by the '$' symbol
    if line[1] == '$'
        parseCommand(line,Nodes,SizesOfNodes)
    else
        parseDirectoryEntry(line,Nodes)
    end
    return
end

function parseDirectoryEntry(entry::String, Nodes::Stack{Integer})
    # We don't care about directory entries since we solve those 
    # when we actually go down that directory
    if entry[1] != 'd'
        addFileSize(entry,Nodes)
    end
    return
end

function addFileSize(entry::String, Nodes::Stack{Integer})
    # The file size is always the starting argument,
    # the file name does not matter to us, so we don't store that
    output = split(entry, " ")
    push!(Nodes, pop!(Nodes) + parse(Int, output[1]))
    return
end

function parseCommand(command::String, Nodes::Stack{Integer}, SizesOfNodes::Vector{Integer})
    # We don't care about the line with the "ls" command so we ignore those
    # after the "ls" command, we get the listing and we solve those in the relevant lines
    if command[3] == 'c'
        parseDirectoryChange(command, Nodes, SizesOfNodes)
    end
    return
end

function parseDirectoryChange(command::String, Nodes::Stack{Integer}, SizesOfNodes::Vector{Integer})
    # an argument beginning with a dot signifies that we go up a directory,
    # otherwise we head further down
    if command[6] == '.'
        GoUpDirectory(Nodes, SizesOfNodes)
    else
        GoDownDirectory(Nodes)
    end
    return
end

# We add the size of the current directory to its parent directory
# and then pop our just finished directory from the stack
function GoUpDirectory(Nodes::Stack{Integer}, SizesOfNodes::Vector{Integer}) 
    DirectorySize = pop!(Nodes)
    push!(SizesOfNodes, DirectorySize)
    push!(Nodes, pop!(Nodes) + DirectorySize)
    return
end

# we add another node for that just traversed directory
function GoDownDirectory(Nodes::Stack{Integer})
    push!(Nodes,0)
    return
end

# finally, we add the sizes of the recursive directories to their parents 
function resolveStack(Nodes::Stack{Integer}, SizesOfNodes::Vector{Integer})
    while !isempty(Nodes)
        dirSize = pop!(Nodes)
        push!(SizesOfNodes, dirSize)

        # we cant add the size of / to anything
        if !isempty(Nodes)
            push!(Nodes, pop!(Nodes) + dirSize)
        end
    end 
end