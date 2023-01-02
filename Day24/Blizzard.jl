using DataStructures

# Solution to Puzzle 1 is Part1()
# Solution to Puzzle 2 is Part2()

# helper struct modelling a Blizzard
mutable struct Blizzard
    x::Integer
    y::Integer
    Orientation::Integer

    # Orientation 1 is right, 2 is down, 3 is left and 4 is up
    function Blizzard(x::Integer, y::Integer, Orientation::Integer)
        return new(x, y, Orientation)
    end
end

# Parsing each Blizzard into its respective struct while also 
# find the width and height of the grid
function parseInput()
    width = 0
    height = 0
    Blizzards = Vector{Blizzard}()

    i = 0
    for line in eachline("./Day24/input.txt")
        i += 1
        width = length(line)

        j = 0
        for c in line
            j += 1
            if c == '>'
                push!(Blizzards, Blizzard(j, i, 1))
            elseif c == 'v'
                push!(Blizzards, Blizzard(j, i, 2))
            elseif c == '<'
                push!(Blizzards, Blizzard(j, i, 3))
            elseif c == '^'
                push!(Blizzards, Blizzard(j, i, 4))
            end
        end
    end

    height = i

    return Blizzards, width, height
end

# creating an empty base grid with only the walls.
# each step then copies this grid and populates it with Blizzards
function createBaseGrid(width::Integer, height::Integer)
    BaseGrid = falses(width, height)

    # the walls
    for i in 1:width
        BaseGrid[i, 1] = true
        BaseGrid[i, height] = true
    end

    for j in 1:height
        BaseGrid[1, j] = true
        BaseGrid[width, j] = true
    end

    # the two open spots for the beginning and end
    BaseGrid[2, 1] = false
    BaseGrid[width-1, height] = false

    return BaseGrid
end

# we create our grid and blizzards and then just use BFS to get the fastest way
function Part1()
    Blizzards, width, height = parseInput()

    BaseGrid = createBaseGrid(width, height)

    time = BFS(BaseGrid, Blizzards, (2, 1), (width - 1, height))

    println(time)
end

# Like in Part1, we use BFS to get the fastest Paths, this time only three times.
function Part2()
    Blizzards, width, height = parseInput()

    BaseGrid = createBaseGrid(width, height)

    time1 = BFS(BaseGrid, Blizzards, (2, 1), (width - 1, height))
    time2 = BFS(BaseGrid, Blizzards, (width - 1, height), (2, 1))
    time3 = BFS(BaseGrid, Blizzards, (2, 1), (width - 1, height))

    println(time1 + time2 + time3)
end

# each step we first update the Blizzards Positions, 
# then populate the grid at that time step and finally
# calculate the next possible Posiitons out of the current ones and alle directions to go.
function BFS(BaseGrid::BitMatrix, Blizzards::Vector{Blizzard}, start::Tuple{<:Integer,<:Integer}, goal::Tuple{<:Integer,<:Integer})
    possiblePositions = [start]
    time = 0

    # all directions we can go from a space
    movements = [(0, 0), (1, 0), (0, -1), (-1, 0), (0, 1)]

    while true
        time += 1

        # we always copy the baseGrid with the walls 
        # and then populate that with the Blizzards Positions
        grid = copy(BaseGrid)
        moveBlizzards(Blizzards, size(grid, 1), size(grid, 2))

        for b in Blizzards
            grid[b.x, b.y] = true
        end

        NewPositions = Set{Tuple{<:Integer,<:Integer}}()

        # calculating each new Position out of the old ones
        for (x, y) in possiblePositions
            for (Δx, Δy) in movements
                if !checkbounds(Bool, grid, x + Δx, y + Δy)
                    continue
                end

                if (x + Δx, y + Δy) == goal
                    return time
                end

                if grid[x+Δx, y+Δy] == false
                    push!(NewPositions, (x + Δx, y + Δy))
                end
            end
        end

        possiblePositions = NewPositions
    end
end

# each blizzard updates its position according to its orientation and wraps around, 
# if it hits a wall
# curiously, the blizzards wrapping around can be modeled with a modulo operation
# with careful offsets
function moveBlizzards(Blizzards::Vector{Blizzard}, width::Integer, height::Integer)
    directionDeltas = [(1, 0), (0, 1), (-1, 0), (0, -1)]

    for b in Blizzards
        (Δx, Δy) = directionDeltas[b.Orientation]
        b.x = mod(b.x + Δx - 2, width - 2) + 2
        b.y = mod(b.y + Δy - 2, height - 2) + 2
    end
end