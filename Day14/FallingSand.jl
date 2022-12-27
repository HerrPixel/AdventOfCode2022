# Solution to Puzzle 1 is simulateSand(true)
# Solution to Puzzle 2 is simulateSand(false)

# We parse the input to get a grid with the walls already placed.
# Notice that the pile of sand cannot move more than the height horizontally,
# since each move is either down or diagonal and therefore you gain as much depth as you
# get horizontally away. You therefore only stay in a triangle under the starting point.
# This gives us an upper bound on the length of the possible field and we can just store
# everything in a bitmatrix.
# Then we just simulate each unit of sand.
# If it goes under the deepest wall, it would fall through the abyss in puzzle 1
# and we can stop.
# For Part2, we check if the unit of sand has not moved and therefore,
# our situation would be stale and we can also stop.
function simulateSand(HasEndlessVoid::Bool)
    grid, offset = parseInput()

    # If a unit of sand would be below this point,
    # it would fall endlessly in puzzle 1 and we can stop
    cutoff = size(grid,2) - 2

    placedSand = 0

    while true
        # we transform input coordinates to coordinates of our smaller BitMatrix
        x = 500 - offset
        y = 1
        hasMoved = true 
        while hasMoved
            hasMoved = false    

            # each possible move
            for Δx in [0,-1,1]
                if grid[x+Δx,y+1] == false
                    x += Δx
                    y += 1
                    hasMoved = true
                    break
                end
            end
        end

        # Check for Puzzle 1
        if HasEndlessVoid && y ≥ cutoff
            break
        end

        # Check for Puzzle 2
        if !HasEndlessVoid && grid[x,y] == true
            break
        end

        grid[x,y] = true
        placedSand += 1
    end

    println(placedSand)
end

# We first find out our bounds and then parse the walls
# and add them to our matrix
function parseInput()
    maxDepth = 0

    walls = Vector{Vector{Tuple{<:Integer,<:Integer}}}()

    i = 0
    for line in eachline("./Day14/input.txt")
        i += 1

        push!(walls,Vector{Tuple{<:Integer,<:Integer}}())
        words = split(line," -> ")

        for word in words
            coordinates = split(word,",")

            # to not have to go through the input a second time,
            # we store the walls as a sequence of points
            # until we have created our matrix
            x = parse(Int,coordinates[1])
            y = parse(Int,coordinates[2])
            push!(walls[i],(x,y))

            maxDepth = max(y,maxDepth)
        end
    end

    # since Julia is 1-indexed, we need another row as the 0th row
    height = maxDepth + 3
    
    # now all our x-coordinates are agreeing with our matrix-indices
    offset = 500 - height

    # maximum x-coordinate any unit of sand can reach as explained above
    width = 2 * height - 1

    # by storing this as a bitmatrix, we use cache-locality to have a very fast Solution.
    grid = falses(width,height)

    # we place walls for each consecutive pairs of points
    for wall in walls
        for i in eachindex(wall)
            if i == lastindex(wall)
                continue
            else
                (x1,y1) = wall[i]
                (x2,y2) = wall[i+1]
                (Δx,Δy) = (abs(x2 - x1),abs(y2-y1))
                (x,y) = (min(x1,x2),min(y1,y2))
                addWall(x-offset,y+1,Δx,Δy,grid)
            end
        end
    end

    # finally the bottom of the abyss for Part2
    addWall(1,size(grid,2),width-1,0,grid)
    
    return grid, offset
end

# helper function to place walls as defined by a base-point and a difference in coordinates
function addWall(x::Integer,y::Integer,Δx::Integer,Δy::Integer,grid::BitMatrix)

    function isOutOfBounds(x::Integer,y::Integer)
        return x < 1 || y < 1 || x > size(grid,1) || y > size(grid,2)
    end

    for i in 0:Δx
        for j in 0:Δy
            if !isOutOfBounds(x+i,y+j)
                grid[x+i,y+j] = true
            end
        end
    end
end