# Solution to Puzzle 1 is Part1()
# Solution to Puzzle 2 is Part2()

# Parsing the input into a dictionary of positions with the default 
function parseInput()
    Positions = Dict{Tuple{Int,Int},Int}()

    i = 0
    for line in eachline("./Day23/input.txt")
        i += 1
        j = 0
        for c in line
            j += 1
            if c == '#'
                Positions[(j, i)] = 1
            end
        end
    end
    return Positions
end

function nextRound(Positions::Dict{Tuple{Int,Int},Int})
    Neigbourhood = [
        [(-1, -1), (0, -1), (1, -1)],
        [(-1, 1), (0, 1), (1, 1)],
        [(-1, 1), (-1, 0), (-1, -1)],
        [(1, 1), (1, 0), (1, -1)]
    ]

    Directions = [(0, -1), (0, 1), (-1, 0), (1, 0)]

    surroundingTiles = [
        (1, 0), (1, -1), (0, -1), (-1, -1), (-1, 0), (-1, 1), (0, 1), (1, 1)
    ]

    NextPositions = Dict{Tuple{Int,Int},Int}()

    for ((x, y), direction) in Positions

        nextDirection = mod(direction, 4) + 1

        allFree = true
        for (Δx, Δy) in surroundingTiles
            if haskey(Positions, (x + Δx, y + Δy))
                allFree = false
            end
        end

        if allFree
            NextPositions[(x, y)] = nextDirection
            continue
        end

        hasMoved = false

        for i in 1:4

            isFree = true
            for (Δx, Δy) in Neigbourhood[direction]
                if haskey(Positions, (x + Δx, y + Δy))
                    isFree = false
                end
            end

            if isFree
                (Δx, Δy) = Directions[direction]

                if haskey(NextPositions, (x + Δx, y + Δy))
                    occupyingElf = NextPositions[(x + Δx, y + Δy)]
                    pushBack(x, y, Δx, Δy, occupyingElf, NextPositions)
                    NextPositions[(x, y)] = nextDirection
                else
                    NextPositions[(x + Δx, y + Δy)] = nextDirection
                end

                hasMoved = true
                break
            else
                direction = mod(direction, 4) + 1
            end
        end

        if !hasMoved
            NextPositions[x, y] = nextDirection
        end
    end

    return NextPositions
end

function pushBack(x::Int, y::Int, Δx::Int, Δy::Int, direction::Int, NextPositions::Dict{Tuple{Int,Int},Int})
    delete!(NextPositions, (x + Δx, y + Δy))
    NextPositions[(x + 2 * Δx, y + 2 * Δy)] = direction
end


function Part1()
    Positions = parseInput()

    for i in 1:10
        println("round; ", i - 1)
        #draw(Positions)
        Positions = nextRound(Positions)
    end

    #draw(Positions)

    maxX = 0
    minX = 0
    maxY = 0
    minY = 0

    for ((x, y), _) in Positions
        maxX = max(x, maxX)
        minX = min(x, minX)
        maxY = max(y, maxY)
        minY = min(y, minY)
    end

    width = abs(maxX - minX) + 1
    height = abs(maxY - minY) + 1

    println(width * height - length(Positions))
end

function Part2()

    Positions = parseInput()
    OldPositions = Dict{Tuple{Int,Int},Int}()
    i = 0
    while keys(Positions) != keys(OldPositions)
        OldPositions = Positions
        Positions = nextRound(Positions)
        i += 1
    end

    println(i)
end