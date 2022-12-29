using DataStructures
using Combinatorics

# Solution for puzzle 1 is releaseMaximumPressureAlone()
# Solution for puzzle 2 is releaseMaximumPressureWithElephant()

# helper struct modeling a node in a graph
mutable struct node
    name::String
    index::Integer
    flow::Integer
    Neighbours::Vector{node}

    function node(name::AbstractString, index::Integer, flow::Integer)
        return new(name, index, flow, [])
    end

    function node(name::AbstractString, index::Integer)
        return new(name, index, 0, [])
    end
end

# helper struct modeling the world for calculating the best Values for a valve combination.
# With this, we avoid function header cluttering.
mutable struct world
    currNode::node
    timeRemaining::Integer
    openedValves::Set
    currFlow::Integer
    NonTrivialNodes::Vector{node}
    distances::Matrix{Integer}

    function world(currNode::node, timeRemaining::Integer, openedValves::Set, currFlow::Integer, NonTrivialNodes::Vector{node}, distances::Matrix{<:Integer})
        return new(currNode, timeRemaining, openedValves, currFlow, NonTrivialNodes, distances)
    end
end

# We parse the Input into a graph, use Floyd-Warshall to precompute the best distances
# and then find out the best values for each combination of opened nodes, regardless of the order.
# Finally we find the maximum of those values
function releaseMaximumPressureAlone()
    nodes, nodeNames = parseInput()
    distances = FloydWarshallAlgorithm(nodes)

    # we only need to select nodes with a non-trivial flow value,
    # with floyd-warshall we already have the distances between them
    # and can just ignore the rest of the graph.
    NonTrivialValves = Vector{node}()
    for currNode in nodes
        if currNode.flow != 0
            push!(NonTrivialValves, currNode)
        end
    end

    # we initalize our "world" in which the simulating happens with the conditions of Part1
    thisWorld = world(nodeNames["AA"], 30, Set([]), 0, NonTrivialValves, distances)
    bestFlowValues = getBestFlowValues(thisWorld, Dict{Set,Integer}())

    println(maximum(values(bestFlowValues)))
end

# We parse the input into a graph, use Floyd-Warshall to precompute the best distances
# and then find out the best values for each combination of opened nodes, regardless of the order.
# Finally we search the combination of nodes into two subsets 
# whose combined released Pressure is the greatest.
function releaseMaximumPressureWithElephant()
    nodes, nodeNames = parseInput()
    distances = FloydWarshallAlgorithm(nodes)

    # Same as above, we only need to consider non-trivial valves
    # and can ignore the rest
    NonTrivialValves = Vector{node}()
    for currNode in nodes
        if currNode.flow != 0
            push!(NonTrivialValves, currNode)
        end
    end

    # we initialize our "world" with the conditions of Part2
    thisWorld = world(nodeNames["AA"], 26, Set([]), 0, NonTrivialValves, distances)
    bestFlowValues = getBestFlowValues(thisWorld, Dict{Set,Integer}())

    # finally we find the maximum of the sum of two disjoint valve-subsets
    println(disjointMaximum(bestFlowValues, bestFlowValues))
end

# Helper function to find the maximum of the sum of two disjoint valve-subsets
function disjointMaximum(a::Dict{Set,Integer}, b::Dict{Set,Integer})
    currMax = 0

    for (Akey, Avalue) in a
        for (Bkey, Bvalue) in b
            if isdisjoint(Akey, Bkey)
                currMax = max(currMax, Avalue + Bvalue)
            end
        end
    end

    return currMax
end

# This is where the magic happens.
# We store the best values we found for a set of opened values regardless of the order
# and then basically simulate every possible path and store those best values
function getBestFlowValues(w::world, bestValues::Dict{Set,Integer})
    # if our current value is better than the old best value
    # for that set of opened valves, we update the best value
    bestValues[w.openedValves] = max(get(bestValues, w.openedValves, 0), w.currFlow)

    # we then recurse for each node we can go to
    for nextNode in w.NonTrivialNodes

        time = w.timeRemaining - w.distances[w.currNode.index, nextNode.index] - 1

        # if we ran out of time or have already opened this valve, skip 
        if !(time ≤ 0 || nextNode ∈ w.openedValves)

            # we need to make a copy, since Julia is pass-by-reference and 
            # we want each recursion to be independent
            newOpenedValves = push!(copy(w.openedValves), nextNode)

            # notice that the total pressure added by a valve 
            # is just the time remaining times its flow value
            newFlow = w.currFlow + time * nextNode.flow


            newWorld = world(nextNode, time, newOpenedValves, newFlow, w.NonTrivialNodes, w.distances)
            getBestFlowValues(newWorld, bestValues)
        end
    end

    return bestValues
end

# standard Floyd-Warshall Algorithm.
# We populate the matrix with (hopefully) high enough values 
# so that distances are intialized correctly.
function FloydWarshallAlgorithm(nodes::Vector{node})
    distances = zeros(Int, length(nodes), length(nodes))

    # since we add two of these values in the min-check,
    # having a value too large would lead to overflow
    # and the sum would actually be negative.
    fill!(distances, div(typemax(Int), 2))

    for i in eachindex(nodes)
        distances[i, i] = 0
        for neighbour in nodes[i].Neighbours
            j = neighbour.index
            distances[i, j] = 1
        end
    end

    for i in eachindex(nodes)
        for j in eachindex(nodes)
            for k in eachindex(nodes)
                distances[j, k] = min(distances[j, k], distances[j, i] + distances[i, k])
            end
        end
    end

    return distances
end

# We match the parts of the input lines we need via a regex and then populate our nodes.
# if a node is mentioned before its defining line is parsed, we create a preliminary version of it.
function parseInput()
    nodes = Vector{node}()
    nodeNames = Dict{String,node}()

    # This captures the relevant parts of the lines 
    regex = r"Valve ([a-zA-Z]+) has flow rate=([0-9]+); tunnels* leads* to valves* ([a-zA-Z]+(?:, [a-zA-Z]+)*)"

    # we keep this counter to populate each node with its index in the node Vector
    i = 1
    for line in eachline("./Day16/input.txt")
        matches = match(regex, line)
        name = matches[1]
        flow = parse(Int, matches[2])
        neighbours = split(matches[3], ", ")

        # as mentioned above, if a node is mentioned before its relevant line was parsed
        # a preliminary version was created. We fill that preliminary version if it existed,
        # otherwise we create the node.
        if haskey(nodeNames, matches[1])
            thisNode = nodeNames[name]
            thisNode.flow = flow
        else
            thisNode = node(name, i, flow)
            nodeNames[name] = thisNode
            push!(nodes, thisNode)
            i += 1
        end

        # same as above, if a node is mentioned but hasn't been created,
        # a preliminary version is made.
        for neighbour in neighbours
            if !haskey(nodeNames, neighbour)
                neighbourNode = node(neighbour, i)
                nodeNames[neighbour] = neighbourNode
                push!(nodes, neighbourNode)
                i += 1
            end
            push!(thisNode.Neighbours, nodeNames[neighbour])
        end
    end

    return nodes, nodeNames
end