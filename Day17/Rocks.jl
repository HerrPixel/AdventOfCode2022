# Solution to puzzle 1 is simulateRocks(2022)
# Solution to puzzle 2 is simulateRocks(1000000000000)

# helper struct for the five types of rocks, 
# modeled as functions of the bottom left-coordinate
# to each occupied space
struct rock
    points::Vector{Function}
    highestPoint::Function

    function rock(points::Vector{Function}, highestPoint::Function)
        return new(points, highestPoint)
    end
end

# builds the functions and the helper struct out of coordinate tuples,
# with this definition, moving the pieces is easy.
function makePiece(points::Vector{<:Tuple{<:Integer,<:Integer}})
    pointFunctions = Vector{Function}()
    highestPoint = 0

    for (a, b) in points
        func = (x, y) -> (x + a, y + b)
        push!(pointFunctions, func)
        highestPoint = max(highestPoint, b)
    end

    highestPointFunc = y -> y + highestPoint

    return rock(pointFunctions, highestPointFunc)
end


# We make an assumption on a maximum grid size and either simulate as much rocks as needed
# or we find a loop and skip ahead as far as possible, knowing the height-offset
# after repeating this loop.
function simulateRocks(NrOfRounds::Integer)
    PiecePoints = [
        [(0, 0), (1, 0), (2, 0), (3, 0)], # The - Piece
        [(1, 0), (0, 1), (1, 1), (2, 1), (1, 2)], # The + Piece
        [(0, 0), (1, 0), (2, 0), (2, 1), (2, 2)], # The L Piece
        [(0, 0), (0, 1), (0, 2), (0, 3)], # The | Piece
        [(0, 0), (0, 1), (1, 0), (1, 1)] # The [] Piece
    ]

    # building all the pieces
    Pieces = Vector{rock}()
    for piece in PiecePoints
        push!(Pieces, makePiece(piece))
    end

    Jet = first(eachline("./Day17/input.txt"))
    JetPosition = 1
    PieceNumber = 1
    # the starting position
    Position = (3, 4)
    # the cave height is an assumption when we expect the loop.
    # we could build this as a vector of vectors and update dynamically
    # but a bitmatrix is significantly faster but cannot be rescaled
    cave = falses(7, 10000)

    # for loop detection, we keep a list of seen states
    # with their height and number of placed pieces.
    # each state consists of the current Position in the jetStream, the piece placed
    # and the depth of each of the seven columns.
    # Note that there are edge cases where this detects a cycle when there is none but 
    # luckily this does not happen.
    States = Dict{Vector{Integer},Tuple{<:Integer,<:Integer}}()

    currState = ()
    noCycleFound = true
    highestPointFound = 1
    NumberOfRocksPlaced = 0

    while NumberOfRocksPlaced != NrOfRounds && noCycleFound

        # this loops until the rock is sedentary
        while true
            movement = Jet[JetPosition]

            # we move in the jet stream once
            if movement == '>'
                Position = move(Pieces[PieceNumber], Position, (1, 0), cave)
            else
                Position = move(Pieces[PieceNumber], Position, (-1, 0), cave)
            end

            JetPosition = mod(JetPosition, length(Jet)) + 1

            # and then downwards once
            newPosition = move(Pieces[PieceNumber], Position, (0, -1), cave)
            if newPosition != Position

                # if we can move downwards, do so and continue
                Position = newPosition
            else

                # otherwise, we become sedentary and therefore fix our position and place the piece
                placePiece(Pieces[PieceNumber], Position, cave)
                NumberOfRocksPlaced += 1

                # we also update the starting position for the next piece and our current height
                highestPointFound = max(Pieces[PieceNumber].highestPoint(Position[2]), highestPointFound)
                Position = (3, highestPointFound + 4)

                # and add our current state to the seen states
                currState = recordState(cave, highestPointFound, PieceNumber, JetPosition)

                # but if we find a cycle, we can end here and just calculate the final height.
                if haskey(States, currState)
                    noCycleFound = false
                else

                    # otherwise, we add our current state and continue with the next piece
                    States[currState] = (highestPointFound, NumberOfRocksPlaced)
                end

                break
            end
        end
        PieceNumber = mod(PieceNumber, 5) + 1
    end

    # if we found a cycle, we can repeat it as often as possible
    # and add offsets at the beginning and end of the cycles to get our final height.
    if !noCycleFound
        loopEnd = NumberOfRocksPlaced
        (_, loopStart) = States[currState]

        CycleLength = loopEnd - loopStart
        CycleHeightDifference = highestPointFound - findHeightAtTime(States, loopStart)

        # Presumably our cycle does not start with the first piece,
        # then we need to offset our cycle of cycles until the piece when it does start to repeat.
        # finally, we might not repeat until we hit exactly our quota so we need to place some remaining Pieces.
        (cycleRepetitions, NrOfRemainingPieces) = divrem(NrOfRounds - loopStart, CycleLength)

        # the height we get for those remainingPieces can also be calculated from information we already have.
        # Since the Number of remaining pieces is lower than the cycle length, the height we get
        # by placing them can already be found in our list of states.
        remainingHeight = findHeightAtTime(States, loopStart + NrOfRemainingPieces) - findHeightAtTime(States, loopStart)

        # finally our final height is the offset at the beginning plus the height we get from repeating plus the offset at the end.
        highestPointFound = findHeightAtTime(States, loopStart) + CycleHeightDifference * cycleRepetitions + remainingHeight
    end

    println(highestPointFound)
end

# a helper function
# this just returns the recorded height at the recorded time in our list of states.
function findHeightAtTime(States::Dict{Vector{Integer},Tuple{<:Integer,<:Integer}}, NrOfPiecesPlaced::Integer)
    for (a, b) in values(States)
        if b == NrOfPiecesPlaced
            return a
        end
    end
end

# this builds a state-tuple out of the current relevant information 
function recordState(cave::BitMatrix, highestPointFound::Integer, PieceNumber::Integer, JetPosition::Integer)
    depths = Vector{Integer}()
    push!(depths, PieceNumber)
    push!(depths, JetPosition)

    for i in 1:7
        j = highestPointFound
        while true
            if !checkbounds(Bool, cave, i, j) || cave[i, j]
                push!(depths, highestPointFound - j)
                break
            else
                j += -1
            end
        end
    end

    return depths
end

# after a piece has settled, we can fix it on the cave grid with this helper function
function placePiece(piece::rock, position::Tuple{<:Integer,<:Integer}, cave::BitMatrix)
    (x, y) = position

    for f in piece.points
        (a, b) = f(x, y)
        cave[a, b] = true
    end
end

# with this, we can move pieces or stand still, if we would collide with something.
function move(piece::rock, position::Tuple{<:Integer,<:Integer}, offset::Tuple{<:Integer,<:Integer}, cave::BitMatrix)
    canMove = true
    (x, y) = position
    (Δx, Δy) = offset

    for f in piece.points
        (a, b) = f(x + Δx, y + Δy)
        if !checkbounds(Bool, cave, a, b) || cave[a, b]
            canMove = false
            break
        end
    end

    if canMove
        return (x + Δx, y + Δy)
    else
        return (x, y)
    end
end