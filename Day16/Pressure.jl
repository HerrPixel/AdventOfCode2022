mutable struct node
    name::String
    flow::Integer
    Neighbours::Vector{node}

    function node(name::String,flow::Integer,Neighbours::Vector{node})
        return new(name,flow,Neighbours)
    end

    function node(name::String, flow::Integer)
        return new(name,flow,[])
    end
end

function getMaximumFlow()
    nodes = parseInput()
    distances = distances(nodes)
    startnode = 0

    NonTrivialEntries = Vector{Integer}()
    for i in nodes
        if nodes[i].flow ≠ 0
            push!(NonTrivialEntries,i)
        end
        if nodes[i].name == "AA"
            startnode = i
        end
    end

    #=
    goodDistances = zeros(Int,length(NonTrivialEntries),length(NonTrivialEntries))
    for i in eachindex(NonTrivialEntries)
        for j in eachindex(NonTrivialEntries)
            goodDistances[i,j] = distances[NonTrivialEntries[i],NonTrivialEntries[j]]
        end
    end
    =#


end

function OrderSearch(nodes::Vector{node},grid::Matrix,NonTrivialEntries::Vector{Integer})
    currMax = 0

    
end

function recursion(grid::Matrix,Entries::Vector{Integer},currNode::Integer,currTime::Integer,currValue::Integer)
    for i in Entries
        if currTime + grid[currNode,i] > 30


function distances(nodes::Vector{node})
    grid = zeros(Int8,length(nodes),length(nodes))
    for i in axes(grid,1)
        for j in axes(grid,2)
            grid[i,j] = 2^6
        end
    end



    for i in eachindex(nodes)
        for neighbour in nodes[i].Neighbours
            j = findfirst(isequal(neighbour),nodes)
            grid[i,j] = 1
        end
        grid[i,i] = 0
    end

    for k in eachindex(nodes)
        for i in eachindex(nodes)
            for j in eachindex(nodes)
                if grid[i,j] > grid[i,k] + grid[k,j]
                    grid[i,j] = grid[i,k] + grid[k,j]
                end
            end
        end
    end

    return grid
end


function parseInput()
    nodes::Vector{node}

    nodeNames = Dict{String,node}()

    for line in eachline("./Day16/input.txt")
        words = split(line," ")
        name = words[2]
        flow = parse(Int,words[5][6][end-1])
        thisNode = node(name,flow)
        push!(nodes,thisNode)
        nodeNames[name] = thisNode
    end

    for line in eachline("./Day16/input.txt")
        words = split(line," ")
        name = words[2]
        thisNode = nodeNames[name]
        for i in words[10]:lastindex(words)
            neighbour = rstrip(i,',')
            push!(thisNode.Neighbours,nodeNames[neighbour])
        end
    end

    return nodes
end