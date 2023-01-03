# Solution to Puzzle 1 is Part1()
# Solution to Puzzle 2 is Part2()

# Parsing the input into a Set of Positions
function parseInput()
    Positions = Set{Tuple{Int,Int}}()

    i = 0
    for line in eachline("./Day23/input.txt")
        i += 1
        j = 0
        for c in line
            j += 1
            if c == '#'
                push!(Positions, (j, i))
            end
        end
    end
    return Positions
end

# for each elf, we first check if it has no neighbours, 
# then it stays where it is.
# If it has neighbours, we check the directions as wanted
# and if we propose a move, we check if someone else has proposed that move,
# i.e. check if this spot is reserved in the next step.
# If it is, we "push" that reservation back to its original step.
# Otherwise, we reserve that spot.
function nextRound(Positions::Set{Tuple{Int,Int}}, firstDirection::Int)
    # the spots we need to check for each cardinal direction.
    # Neigbourhood[1] = North
    # Neigbourhood[2] = South
    # Neigbourhood[3] = West
    # Neigbourhood[4] = East
    Neigbourhood = [
        [(-1, -1), (0, -1), (1, -1)],
        [(-1, 1), (0, 1), (1, 1)],
        [(-1, 1), (-1, 0), (-1, -1)],
        [(1, 1), (1, 0), (1, -1)]
    ]

    # when we found a direction to go, we can obtain the deltas through this vector
    Directions = [(0, -1), (0, 1), (-1, 0), (1, 0)]

    # all 8 tiles to check
    surroundingTiles = [
        (1, 0), (1, -1), (0, -1), (-1, -1), (-1, 0), (-1, 1), (0, 1), (1, 1)
    ]

    # the reservation for the next phase.
    NextPositions = Set{Tuple{Int,Int}}()

    for (x, y) in Positions
        # our current looking direction
        direction = firstDirection

        # if we have no neighbours...
        allFree = true
        for (Δx, Δy) in surroundingTiles
            if (x + Δx, y + Δy) ∈ Positions
                allFree = false
            end
        end

        # ... don't move at all
        if allFree
            push!(NextPositions, (x, y))
            continue
        end

        hasMoved = false

        # otherwise check the direction one after the one
        for i in 1:4

            # if any of the directions is free ...
            isFree = true
            for (Δx, Δy) in Neigbourhood[direction]
                if (x + Δx, y + Δy) ∈ Positions
                    isFree = false
                end
            end

            # .. try to move there
            if isFree
                (Δx, Δy) = Directions[direction]

                # if someone else proposed moving there
                if (x + Δx, y + Δy) ∈ NextPositions

                    # we push back their reservation.
                    # Notice that two elfs can only propose the same spot, 
                    # if they come from opposite sides, so we know where to push back that elf.
                    # This saves us the work to construct another Set with Propositions.
                    delete!(NextPositions, (x + Δx, y + Δy))
                    push!(NextPositions, (x + 2 * Δx, y + 2 * Δy))

                    # and we also stand still.
                    push!(NextPositions, (x, y))
                else

                    # otherwise, move to our proposed spot
                    push!(NextPositions, (x + Δx, y + Δy))
                end

                hasMoved = true
                break
            else

                # If this direction is not free,
                # look at the next direction in the list
                direction = mod(direction, 4) + 1
            end
        end

        # if no direction is free, stand still
        if !hasMoved
            push!(NextPositions, (x, y))
        end
    end

    return NextPositions
end

# we just simulate 10 rounds and then calculate the bounding box
# via the maximum and minimum coordinates of all points
function Part1()
    Positions = parseInput()

    for i in 0:9
        Positions = nextRound(Positions, mod(i, 4) + 1)
    end

    maxX = 0
    minX = 0
    maxY = 0
    minY = 0

    for (x, y) in Positions
        maxX = max(x, maxX)
        minX = min(x, minX)
        maxY = max(y, maxY)
        minY = min(y, minY)
    end

    width = abs(maxX - minX) + 1
    height = abs(maxY - minY) + 1

    println(width * height - length(Positions))
end

# we simulate rounds until no position changes and then print out the round number
function Part2()
    Positions = parseInput()
    OldPositions = Set{Tuple{Int,Int}}()
    i = 0
    while Positions != OldPositions
        OldPositions = Positions
        Positions = nextRound(Positions, mod(i, 4) + 1)
        i += 1
    end

    println(i)
end