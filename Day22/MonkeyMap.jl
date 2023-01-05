# Notice: this is the only Day that is not optimized for readabilty or performance.
# I really don't know how to write a good cube building function and all other ideas are just
# ugly to write down, so I kept my original solution.

# Solution to Puzzle1 is Part1()
# Solution to Puzzle2 is Part2()

# helper struct to store the current board
mutable struct Boardstate
    grid::Matrix{Int}
    RowRanges::Matrix{Int}
    ColumnRanges::Matrix{Int}
    X::Integer
    Y::Integer
    direction::Integer

    function Boardstate(grid, rowRanges, columnRanges, currX, currY, direction)
        return new(grid, rowRanges, columnRanges, currX, currY, direction)
    end
end

# since we store the direction as an integer from 0-3, 
# turning left/right is the same as incrementing/decrementing that
function turnLeft(board::Boardstate)
    board.direction = mod(board.direction - 1, 4)
end

# since we store the direction as an integer from 0-3, 
# turning left/right is the same as incrementing/decrementing that
function turnRight(board::Boardstate)
    board.direction = mod(board.direction + 1, 4)
end

# we execute each step, finding out our next coordinates 
# and stop if its a wall or walk there.
# if we get out of bounds or into a zone that is not a grid, 
# wrap around by finding out the opposite space via our column and row ranges and go there.
function walk(board::Boardstate, steps::Integer)

    # many helper functions for walking a specific direction
    function isoutOfBounds(X, Y)
        return X == 0 || Y == 0 || X > size(board.grid, 1) || Y > size(board.grid, 2)
    end

    function walkUp()

        # if we would walk out of bounds and the opposite side is not a wall, wrap around
        if isoutOfBounds(board.X, board.Y - 1)
            if board.grid[board.X, board.ColumnRanges[2, board.X]] != 2
                board.Y = board.ColumnRanges[2, board.X]
            end
            return
        end
        # if the next space is a wall, stop
        if board.grid[board.X, board.Y-1] == 2
            return
            # otherwise, go there
        elseif board.grid[board.X, board.Y-1] == 1
            board.Y += -1
            return

            # if we would walk into a "dead zone" and the opposite side is not a wall, wrap around
        elseif board.grid[board.X, board.ColumnRanges[2, board.X]] != 2
            board.Y = board.ColumnRanges[2, board.X]

        end
    end

    function walkDown()

        # if we would walk out of bounds and the opposite side is not a wall, wrap around
        if isoutOfBounds(board.X, board.Y + 1)
            if board.grid[board.X, board.ColumnRanges[1, board.X]] != 2
                board.Y = board.ColumnRanges[1, board.X]
            end
            return
        end
        # if the next space is a wall, stop
        if board.grid[board.X, board.Y+1] == 2
            return
            # otherwise, go there
        elseif board.grid[board.X, board.Y+1] == 1
            board.Y += 1

            # if we would walk into a "dead zone" and the opposite side is not a wall, wrap around
        elseif board.grid[board.X, board.ColumnRanges[1, board.X]] != 2
            board.Y = board.ColumnRanges[1, board.X]
        end
    end

    function walkRight()

        # if we would walk out of bounds and the opposite side is not a wall, wrap around
        if isoutOfBounds(board.X + 1, board.Y)
            if board.grid[board.RowRanges[1, board.Y], board.Y] != 2
                board.X = board.RowRanges[1, board.Y]
            end
            return
        end
        # if the next space is a wall, stop
        if board.grid[board.X+1, board.Y] == 2
            return
            # otherwise, go there
        elseif board.grid[board.X+1, board.Y] == 1
            board.X += 1

            # if we would walk into a "dead zone" and the opposite side is not a wall, wrap around
        elseif board.grid[board.RowRanges[1, board.Y], board.Y] != 2
            board.X = board.RowRanges[1, board.Y]
        end
    end

    function walkLeft()

        # if we would walk out of bounds and the opposite side is not a wall, wrap around
        if isoutOfBounds(board.X - 1, board.Y)
            if board.grid[board.RowRanges[2, board.Y], board.Y] != 2
                board.X = board.RowRanges[2, board.Y]
            end
            return
        end
        # if the next space is a wall, stop
        if board.grid[board.X-1, board.Y] == 2
            return
            # otherwise, go there
        elseif board.grid[board.X-1, board.Y] == 1
            board.X += -1

            # if we would walk into a "dead zone" and the opposite side is not a wall, wrap around
        elseif board.grid[board.RowRanges[2, board.Y], board.Y] != 2
            board.X = board.RowRanges[2, board.Y]
        end
    end

    x = board.X
    y = board.Y

    while steps != 0
        if board.direction == 0
            walkRight()
        elseif board.direction == 1
            walkDown()
        elseif board.direction == 2
            walkLeft()
        else
            walkUp()
        end
        steps += -1
    end
    return
end

# we execute each step, finding out our next coordinates 
# and stop if its a wall or walk there.
# if we change our 50x50 field, lookup our cube-wrapping table to find out our next position
# check if there is a wall and walk there if it's free.
function walkAroundTheCube(Board::Boardstate, steps::Integer)

    wrap = Dict((1, 0, 0) => (101, 1:50, 0), (1, 0, 1) => (51:100, 51, 1), (1, 0, 2) => (1, 150:-1:101, 0), (1, 0, 3) => (1, 151:200, 0), (2, 0, 0) => (100, 150:-1:101, 2), (2, 0, 1) => (100, 51:100, 2), (2, 0, 2) => (100, 1:50, 2), (2, 0, 3) => (1:50, 200, 3), (1, 1, 0) => (101:150, 50, 3), (1, 1, 1) => (51:100, 101, 1), (1, 1, 2) => (1:50, 101, 1), (1, 1, 3) => (51:100, 50, 3), (1, 2, 0) => (150, 50:-1:1, 2), (1, 2, 1) => (50, 151:200, 2), (1, 2, 2) => (50, 101:150, 2), (1, 2, 3) => (51:100, 100, 3), (0, 2, 0) => (51, 101:150, 0), (0, 2, 1) => (1:50, 151, 1), (0, 2, 2) => (51, 50:-1:1, 0), (0, 2, 3) => (51, 51:100, 0), (0, 3, 0) => (51:100, 150, 3), (0, 3, 1) => (101:150, 1, 1), (0, 3, 2) => (51:100, 1, 1), (0, 3, 3) => (1:50, 150, 3))

    # many helper functions
    function isoutOfBounds(X, Y)
        return X == 0 || Y == 0 || X > size(Board.grid, 1) || Y > size(Board.grid, 2)
    end

    # if we change our 50x50 space, we should consult our table
    function shouldWrapAround(x, y)
        return isoutOfBounds(x, y) || (div(Board.X - 1, 50), div(Board.Y - 1, 50)) != (div(x - 1, 50), div(y - 1, 50))
    end

    function isWall(x, y)
        return !isoutOfBounds(x, y) && Board.grid[x, y] == 2
    end

    while steps != 0
        x = Board.X
        y = Board.Y
        direction = Board.direction


        if Board.direction == 0
            # if we hit a wall, stop
            if isWall(x + 1, y)
                break

                # else wrap around
            elseif shouldWrapAround(x + 1, y)
                result = wrap[(div(x - 1, 50), div(y - 1, 50), direction)]

                # depending on the resulting direction, 
                # we either have a fixed x-coordinate
                # or a fixed y-coordinate and the other one is depending
                # on our last x or y coordinate.
                if mod(result[3], 2) == 0
                    tempx = result[1]
                    tempy = result[2][mod(y - 1, 50)+1]
                else
                    tempy = result[2]
                    tempx = result[1][mod(y - 1, 50)+1]
                end

                # if this space is a wall, also stop
                if !isWall(tempx, tempy)
                    Board.X = tempx
                    Board.Y = tempy
                    Board.direction = result[3]
                end
            else
                Board.X = x + 1
            end


        elseif Board.direction == 1
            # if we hit a wall, stop
            if isWall(x, y + 1)
                break

                # else wrap around
            elseif shouldWrapAround(x, y + 1)
                result = wrap[(div(x - 1, 50), div(y - 1, 50), direction)]

                # depending on the resulting direction, 
                # we either have a fixed x-coordinate
                # or a fixed y-coordinate and the other one is depending
                # on our last x or y coordinate.
                if mod(result[3], 2) == 0
                    tempx = result[1]
                    tempy = result[2][mod(x - 1, 50)+1]
                else
                    tempy = result[2]
                    tempx = result[1][mod(x - 1, 50)+1]
                end

                # if this space is a wall, also stop
                if !isWall(tempx, tempy)
                    Board.X = tempx
                    Board.Y = tempy
                    Board.direction = result[3]
                end
            else
                Board.Y = y + 1
            end


        elseif Board.direction == 2
            # if we hit a wall, stop
            if isWall(x - 1, y)
                break

                # else wrap around
            elseif shouldWrapAround(x - 1, y)
                result = wrap[(div(x - 1, 50), div(y - 1, 50), direction)]

                # depending on the resulting direction, 
                # we either have a fixed x-coordinate
                # or a fixed y-coordinate and the other one is depending
                # on our last x or y coordinate.
                if mod(result[3], 2) == 0

                    tempx = result[1]
                    tempy = result[2][mod(y - 1, 50)+1]
                else
                    tempy = result[2]
                    tempx = result[1][mod(y - 1, 50)+1]
                end

                # if this space is a wall, also stop
                if !isWall(tempx, tempy)
                    Board.X = tempx
                    Board.Y = tempy
                    Board.direction = result[3]
                end
            else
                Board.X = x - 1
            end


        else
            # if we hit a wall, stop
            if isWall(x, y - 1)
                break

                # else wrap around
            elseif shouldWrapAround(x, y - 1)
                result = wrap[(div(x - 1, 50), div(y - 1, 50), direction)]

                # depending on the resulting direction, 
                # we either have a fixed x-coordinate
                # or a fixed y-coordinate and the other one is depending
                # on our last x or y coordinate.
                if mod(result[3], 2) == 0
                    tempx = result[1]
                    tempy = result[2][mod(x - 1, 50)+1]
                else
                    tempy = result[2]
                    tempx = result[1][mod(x - 1, 50)+1]
                end

                # if this space is a wall, also stop
                if !isWall(tempx, tempy)
                    Board.X = tempx
                    Board.Y = tempy
                    Board.direction = result[3]
                end
            else
                Board.Y = y - 1
            end
        end
        steps += -1
    end
    return
end

# parses the input into a list of commands 
# and a list of rows and columns with their start and endpoint
function parseInput()
    gridRows = 0
    gridColumns = 0
    commands = Vector{String}()

    # we first determine the length and width and parse the commands
    parsingGrid = true
    for line in eachline("./Day22/input.txt")

        # this is the line dividing the grid and the commands
        if line == ""
            parsingGrid = false
            continue
        end

        # counting the rows and columns
        if parsingGrid
            gridRows += 1
            gridColumns = max(gridColumns, length(line))
        else

            # parsing the commands into a list
            regex = r"L|R|[0-9]+"
            m = collect(eachmatch(regex, line))
            for match in m
                push!(commands, match.match)
            end
        end
    end

    # then we create a grid and the unfilled ranges
    rowRanges = zeros(2, gridRows)
    columnRanges = zeros(2, gridColumns)
    grid = zeros(gridColumns, gridRows)
    startX = 0
    startY = 0

    # and finally parse the grid
    i = 1
    for line in eachline("./Day22/input.txt")
        if line == ""
            break
        end
        j = 1
        for c in line
            if c == '.'

                # the starting point for our walk
                if startX == 0
                    startX = j
                    startY = i
                end

                # parsing the min and max coordinates for that row and column
                if rowRanges[1, i] == 0
                    rowRanges[1, i] = j
                end
                if columnRanges[1, j] == 0
                    columnRanges[1, j] = i
                end
                rowRanges[2, i] = j
                columnRanges[2, j] = i
                grid[j, i] = 1

            elseif c == '#'
                # parsing the min and max coordinates for that row and column
                if rowRanges[1, i] == 0
                    rowRanges[1, i] = j
                end
                if columnRanges[1, j] == 0
                    columnRanges[1, j] = i
                end
                rowRanges[2, i] = j
                columnRanges[2, j] = i
                grid[j, i] = 2

            end
            j += 1
        end
        i += 1
    end

    board = Boardstate(grid, rowRanges, columnRanges, startX, startY, 0)

    return commands, board
end

# we execute each command one by one and follow the rules as specified.
# the specific implementation is documented in their functions
function Part1()
    commands, board = parseInput()
    for c in commands
        if c == "R"
            turnRight(board)
        elseif c == "L"
            turnLeft(board)
        else
            walk(board, parse(Int, c))
        end
    end
    println(1000 * board.Y + 4 * board.X + board.direction)
end

# we execute each command one by one and follow the rules as specified.
# the specific implementation is documented in their functions
function Part2()
    commands, board = parseInput()
    for c in commands
        if c == "R"
            turnRight(board)
        elseif c == "L"
            turnLeft(board)
        else
            walkAroundTheCube(board, parse(Int, c))
        end
    end
    println(1000 * board.Y + 4 * board.X + board.direction)
end