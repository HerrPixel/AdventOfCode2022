using DataStructures

# Solution to Puzzle 1 is getDistanceToGoal()
# Solution to Puzzle 2 is getDistanceOfHikingTrail()

# The idea is simple, we parse the input to a graph with an edge from x to y
# if y is at most one char higher than y, i.e. the logic of the puzzle.
# We then execute BFS on this graph from the start node and output the shortest distance.
# For Puzzle 2 we just reverse the edges and output the distance of 
# the first node with value 'a'

# A helper struct for a node
mutable struct node
    symbol::Char
    distance::Integer
    Neighbours::Vector{node}

    function node(symbol::Char, distance::Integer, Neighbours::Vector{node})
        return new(symbol, distance, Neighbours)
    end
end

# Standard BFS which stops the moment it reaches a goal and outputs the distance
function BFS(start::node, goals::Vector{node})
    visitedNodes = Set{node}()
    queueOfNodes = Queue{node}()

    push!(visitedNodes, start)
    enqueue!(queueOfNodes, start)

    while !isempty(queueOfNodes)
        node = dequeue!(queueOfNodes)
        depth = node.distance
        for neighbour in node.Neighbours
            if neighbour ∈ goals
                return depth + 1
            end
            if neighbour ∉ visitedNodes
                neighbour.distance = depth + 1
                push!(visitedNodes, neighbour)
                enqueue!(queueOfNodes, neighbour)
            end
        end
    end
end

# Solution to Part 1
function getDistanceToGoal()

    grid, start, finish, _ = parseInput()
    calculateNeighbours(grid, ShouldBePossibleNeighbours)

    println(BFS(start, [finish]))
end

# Solution to Part2
function getDistanceOfHikingTrail()

    grid, _, finish, goals = parseInput()
    calculateNeighbours(grid, ReverseShouldBePossibleNeighbours)

    println(BFS(finish, goals))
end

# We first parse the input to a matrix of nodes and later calculate edges in another function
function parseInput()
    grid = Vector{Vector{node}}()
    startCoordinates = (0, 0)
    finishCoordinates = (0, 0)
    lowestElevationPointsCoordinates = Vector{Tuple{<:Integer,<:Integer}}()

    # All nodes here are relatively unitialized

    i = 1
    for line in eachline("./Day12/input.txt")
        push!(grid, Vector{node}())
        j = 1
        for c in line

            # Special Behaviour for input encoded start/end points
            if c == 'S'
                startCoordinates = (i, j)
                push!(grid[i], node('a', 0, Vector{node}()))
            elseif c == 'E'
                finishCoordinates = (i, j)
                push!(grid[i], node('z', 0, Vector{node}()))

                # Special collect all points with elevation 'a' to mark as goals in part 2
            elseif c == 'a'
                push!(lowestElevationPointsCoordinates, (i, j))
                push!(grid[i], node('a', 0, Vector{node}()))
            else
                push!(grid[i], node(c, 0, Vector{node}()))
            end
            j += 1
        end
        i += 1
    end

    # transforming the coordinates to nodes
    start = grid[startCoordinates[1]][startCoordinates[2]]
    finish = grid[finishCoordinates[1]][finishCoordinates[2]]
    lowestElevationPoints = Vector{node}()

    for (x, y) in lowestElevationPointsCoordinates
        push!(lowestElevationPoints, grid[x][y])
    end

    return grid, start, finish, lowestElevationPoints
end

# this applies a function "NeighbourCheck" to each pair of possible neighbours,
# i.e. nodes that are beside each other in the input grid
function calculateNeighbours(grid::Vector{Vector{node}}, NeighbourCheck::Function)

    function outOfBounds(i::Integer, j::Integer)
        return i == 0 || j == 0 || i == lastindex(grid) + 1 || j == lastindex(grid[i]) + 1
    end

    NeighbourOffsets = [(1, 0), (0, 1), (-1, 0), (0, -1)]

    for i in eachindex(grid)
        for j in eachindex(grid[i])
            node = grid[i][j]
            for (x, y) in NeighbourOffsets
                if !outOfBounds(i + x, j + y)
                    neighbour = grid[i+x][j+y]
                    NeighbourCheck(node, neighbour)
                end
            end
        end
    end
end

# Check for two elevations to be traversable
function areNear(a::Char, b::Char)
    return Int(b) - Int(a) ≤ 1
end

# Helper function for calculating Neighbours in Part1.
function ShouldBePossibleNeighbours(n::node, m::node)
    if areNear(n.symbol, m.symbol)
        push!(n.Neighbours, m)
    end
end

# Helper function for calculating Neighbours in Part 2.
# Note, this is just the reverse edge of Part 1.
function ReverseShouldBePossibleNeighbours(n::node, m::node)
    if areNear(n.symbol, m.symbol)
        push!(m.Neighbours, n)
    end
end