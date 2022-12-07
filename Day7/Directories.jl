using DataStructures

mutable struct fNode
    size::Integer

    function fNode(i::Integer)
        return new(i)
    end
end

function addSize!(n::fNode, i::Integer)
    n.size += i
end

function getSize(n::fNode)
    return n.size
end

function getSizes()
    SizesOfNodes = Vector{Int64}()
    Nodes = Stack{fNode}()
    for line in eachline("./Day7/input.txt")
        parseCommand(line, Nodes, SizesOfNodes)
    end
    resolveStack(Nodes, SizesOfNodes)
    println(sum(SizesOfNodes))
end

function parseCommand(command::String, Nodes::Stack{fNode}, SizesOfNodes::Vector{Int64})
    if command[1] == '$'
        if command[3] == 'c'
            if command[6] == '.'
                dirSize = getSize(first(Nodes))
                if dirSize ≤ 100000
                    push!(SizesOfNodes, dirSize)
                end
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

function resolveStack(Nodes::Stack{fNode}, SizesOfNodes::Vector{Int64})
    dirSize = getSize(first(Nodes))
    if dirSize ≤ 100000
        push!(SizesOfNodes, dirSize)
    end
    pop!(Nodes)
    if !isempty(Nodes)
        addSize!(first(Nodes), dirSize)
    end
end

#--------------------------------------

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