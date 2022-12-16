using DataStructures
using Combinatorics

mutable struct node
    name::String
    flow::Integer
    Neighbours::Vector{node}

    function node(name::AbstractString, flow::Integer, Neighbours::Vector{node})
        return new(name, flow, Neighbours)
    end

    function node(name::AbstractString, flow::Integer)
        return new(name, flow, [])
    end
end

function getMaximumFlow()
    nodes = parseInput()
    distanceMatrix = distances(nodes)
    startnode = 0

    NonTrivialEntries = Vector{Integer}()
    for i in eachindex(nodes)
        if nodes[i].flow ≠ 0
            push!(NonTrivialEntries, i)
        end
        if nodes[i].name == "AA"
            startnode = i
        end
    end

    #=
    maxFound = 0
    iteration = 0

    NrOfImportantEntries = length(NonTrivialEntries)
    println(NrOfImportantEntries)
    # alle aufteilungen
    for h in div(NrOfImportantEntries,2):-1:1
        #println(h)
        for j in combinations(1:NrOfImportantEntries,h)
            #println(j)
            firstSet = Vector{Integer}()
            secondSet = Vector{Integer}()

            iteration += 1
            println("Ich lebe noch in Iteration: ", iteration, " mit aktuellem Max: ", maxFound)

            for k in j
                push!(firstSet,NonTrivialEntries[k])
            end
            for k in 1:NrOfImportantEntries
                if k ∉ j
                    push!(secondSet,NonTrivialEntries[k])
                end
            end

            firstValue = OrderSearch(startnode, distanceMatrix, firstSet, nodes)
            secondValue = OrderSearch(startnode, distanceMatrix, secondSet, nodes)

            #println(firstSet, " und ", secondSet)
            #println("Mit ", subsetCode, " finde ich ", secondValue + firstValue)
            maxFound = max(maxFound, firstValue + secondValue)
        end
    end
    =#
    println(OrderSearch(startnode, distanceMatrix, NonTrivialEntries, nodes))
    #println(maxFound)
end

function OrderSearch(startNode::Integer, grid::Matrix, possibleNodes::Vector{Integer}, nodes::Vector{node})
    currMax = 0
    currOrder = Stack{Integer}() #indices in all of the nodes
    orderedIndices = Stack{Integer}()

    for i in eachindex(possibleNodes)
        #println("Ich lebe noch!")
        push!(currOrder, possibleNodes[i])
        push!(orderedIndices, 0)
        while !isempty(currOrder)


            next = findNext(possibleNodes, currOrder, first(orderedIndices))
            if next != 0 #&& length(currOrder) <= length(possibleNodes)

                pop!(orderedIndices)
                push!(orderedIndices, next)
                push!(currOrder, possibleNodes[next])
                push!(orderedIndices, 0)
                currValue = calculateFlow(currOrder, grid, startNode, nodes)

                if currValue == -1
                    #println("hier")
                    pop!(currOrder)
                    pop!(orderedIndices)
                else
                    currMax = max(currMax, currValue)
                end
            else

                pop!(currOrder)
                pop!(orderedIndices)
            end
        end
    end


    return currMax
end

function calculateFlow(currOrder::Stack{Integer}, grid::Matrix, startNode::Integer, nodes::Vector{node})
    value = 0
    time = 0
    currNode = startNode
    values = reverse(collect(Iterators.Stateful(currOrder)))
    for i in eachindex(values)
        time += grid[currNode, values[i]] + 1
        value += (30 - time) * nodes[values[i]].flow # change between part1 and 2
        currNode = values[i]
    end
    #println("Mit ", values, " bekommen wir ", value, " mit Zeit ", time, " und startnode ", startNode)
    if time > 30
        return -1
    else
        return value
    end
end

function findNext(possibleNodes::Vector{Integer}, currOrder::Stack{Integer}, lastNode::Integer)
    for i in lastNode+1:length(possibleNodes)
        if possibleNodes[i] ∉ currOrder
            #println("Index ", i, " mit wert ", possibleNodes[i], " ist nicht in", currOrder)
            return i
        end
    end
    return 0
end

function distances(nodes::Vector{node})
    grid = zeros(Int, length(nodes), length(nodes))
    for i in axes(grid, 1)
        for j in axes(grid, 2)
            grid[i, j] = 2^6
        end
    end

    for i in eachindex(nodes)
        for neighbour in nodes[i].Neighbours
            j = findfirst(isequal(neighbour), nodes)
            grid[i, j] = 1
        end
        grid[i, i] = 0
    end

    for k in eachindex(nodes)
        for i in eachindex(nodes)
            for j in eachindex(nodes)
                if grid[i, j] > grid[i, k] + grid[k, j]
                    grid[i, j] = grid[i, k] + grid[k, j]
                end
            end
        end
    end

    return grid
end


function parseInput()
    nodes = Vector{node}()

    nodeNames = Dict{String,node}()

    for line in eachline("./Day16/input.txt")
        words = split(line, " ")
        name = words[2]
        value = rstrip(lstrip(words[5], ['r', 'a', 't', 'e', '=']), ';')
        flow = parse(Int, value)
        thisNode = node(name, flow)
        push!(nodes, thisNode)
        nodeNames[name] = thisNode
    end

    for line in eachline("./Day16/input.txt")
        words = split(line, " ")
        name = words[2]
        thisNode = nodeNames[name]
        for i in 10:lastindex(words)
            neighbour = rstrip(words[i], ',')
            push!(thisNode.Neighbours, nodeNames[neighbour])
        end
    end

    return nodes
end