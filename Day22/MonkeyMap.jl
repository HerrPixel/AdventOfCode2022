mutable struct Boardstate
    grid::Matrix{Int}
    RowRanges::Matrix{Int}
    ColumnRanges::Matrix{Int}
    X::Integer
    Y::Integer
    direction::Integer

    function Boardstate(grid,rowRanges,columnRanges,currX,currY,direction)
        return new(grid,rowRanges,columnRanges,currX,currY,direction)
    end
end

function turnLeft(board::Boardstate)
    board.direction = mod(board.direction - 1,4)
end

function turnRight(board::Boardstate)
    board.direction = mod(board.direction + 1,4)
end

function walk(board::Boardstate,steps::Integer)
   
    function isoutOfBounds(X,Y)
        return X == 0 || Y == 0 || X > size(board.grid,1) || Y > size(board.grid,2)
    end

    function walkUp()
        if isoutOfBounds(board.X,board.Y - 1)
            if board.grid[board.X,board.ColumnRanges[2,board.X]] != 2
                board.Y = board.ColumnRanges[2,board.X]
            end
            return
        end
        if board.grid[board.X,board.Y - 1] == 2
            #println("Wand bei ", board.X,",", board.Y - 1)
            return
        elseif board.grid[board.X,board.Y - 1] == 1
            #println("Gehe zu ", board.X,",", board.Y - 1)
            board.Y += -1
            return
            #println("Bin bei ", board.X,",", board.Y)
        elseif board.grid[board.X,board.ColumnRanges[2,board.X]] != 2
            #println("loope zu  ", board.X,",", board.ColumnRanges[2,board.X])
            board.Y = board.ColumnRanges[2,board.X]

        end
    end

    function walkDown()
        if isoutOfBounds(board.X,board.Y + 1)
            if board.grid[board.X,board.ColumnRanges[1,board.X]] != 2
                board.Y = board.ColumnRanges[1,board.X]
            end
            return
        end
        if board.grid[board.X,board.Y + 1] == 2
            return
        elseif board.grid[board.X,board.Y + 1] == 1
            board.Y += 1
        elseif board.grid[board.X,board.ColumnRanges[1,board.X]] != 2
            board.Y = board.ColumnRanges[1,board.X]
        end
    end

    function walkRight()
        #println("I am ", isoutOfBounds(board.X+1,board.Y), " mit " ,board.X+1, "," , board.Y)
        if isoutOfBounds(board.X+1,board.Y)
            if board.grid[board.RowRanges[1,board.Y],board.Y] != 2
                board.X = board.RowRanges[1,board.Y]
            end
            return
        end
        if board.grid[board.X + 1,board.Y] == 2
            return
        elseif board.grid[board.X + 1,board.Y] == 1
            board.X += 1
        elseif board.grid[board.RowRanges[1,board.Y],board.Y] != 2
            #println("komischerweise hier")
            board.X = board.RowRanges[1,board.Y]
        end
    end

    function walkLeft()
        if isoutOfBounds(board.X - 1,board.Y)
            if board.grid[board.RowRanges[2,board.Y],board.Y] != 2
                board.X = board.RowRanges[2,board.Y]
            end
            return
        end
        if board.grid[board.X - 1,board.Y] == 2
            return
        elseif board.grid[board.X - 1,board.Y] == 1
            board.X += -1
        elseif board.grid[board.RowRanges[2,board.Y],board.Y] != 2
            board.X = board.RowRanges[2,board.Y]
        end
    end

    x = board.X
    y = board.Y


    while steps != 0
        #println("Im Loop mit ", board.X, ",", board.Y)
        #println("im Loop mit ", steps)
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

function walk2(Board::Boardstate,steps::Integer)

    wrap = Dict((1,0,0) => (101,1:50,0),(1,0,1) => (51:100,51,1),(1,0,2) => (1,150:-1:101,0),(1,0,3) => (1,151:200,0),(2,0,0)=>(100,150:-1:101,2),(2,0,1)=>(100,51:100,2),(2,0,2)=>(100,1:50,2),(2,0,3)=>(1:50,200,3),(1,1,0)=>(101:150,50,3),(1,1,1)=>(51:100,101,1),(1,1,2)=>(1:50,101,1),(1,1,3)=>(51:100,50,3),(1,2,0)=>(150,50:-1:1,2),(1,2,1)=>(50,151:200,2),(1,2,2)=>(50,101:150,2),(1,2,3)=>(51:100,100,3),(0,2,0)=>(51,101:150,0),(0,2,1)=>(1:50,151,1),(0,2,2)=>(51,50:-1:1,0),(0,2,3)=>(51,51:100,0),(0,3,0)=>(51:100,150,3),(0,3,1)=>(101:150,1,1),(0,3,2)=>(51:100,1,1),(0,3,3)=>(1:50,150,3)) #correct
   
    function isoutOfBounds(X,Y)
        return X == 0 || Y == 0 || X > size(Board.grid,1) || Y > size(Board.grid,2)
    end

    function shouldWrapAround(x,y)
        return isoutOfBounds(x,y) || (div(Board.X - 1,50),div(Board.Y-1,50)) != (div(x - 1,50),div(y-1,50))
    end

    function isWall(x,y)
        return !isoutOfBounds(x,y) && Board.grid[x,y] == 2
    end

    while steps != 0
        x = Board.X
        y = Board.Y
        direction = Board.direction
        if Board.direction == 0
            if isWall(x+1,y)
                break
            elseif shouldWrapAround(x+1,y)
                result = wrap[(div(x-1,50),div(y-1,50),direction)]
                if mod(result[3],2) == 0
                    tempx = result[1]
                    tempy = result[2][mod(y-1,50)+1]
                else
                    tempy = result[2]
                    tempx = result[1][mod(y-1,50)+1]
                end
                if !isWall(tempx,tempy)
                    Board.X = tempx
                    Board.Y = tempy
                    Board.direction = result[3]
                end
            else
                Board.X = x+1
            end
        elseif Board.direction == 1
            if isWall(x,y+1)
                break
            elseif shouldWrapAround(x,y+1)
                result = wrap[(div(x-1,50),div(y-1,50),direction)]
                if mod(result[3],2) == 0
                    tempx = result[1]
                    tempy = result[2][mod(x-1,50)+1]
                else
                    tempy = result[2]
                    tempx = result[1][mod(x-1,50)+1]
                end
                if !isWall(tempx,tempy)
                    Board.X = tempx
                    Board.Y = tempy
                    Board.direction = result[3]
                end
            else
                Board.Y = y+1
            end
        elseif Board.direction == 2
            if isWall(x-1,y)
                break
            elseif shouldWrapAround(x-1,y)
                result = wrap[(div(x-1,50),div(y-1,50),direction)]
                if mod(result[3],2) == 0
                    #println("Stelle des Bugs: " ,result)
                    #println("Eingabe: ", (div(x-1,50),div(y-1,50),direction))
                    tempx = result[1]
                    tempy = result[2][mod(y-1,50)+1]
                else
                    tempy = result[2]
                    tempx = result[1][mod(y-1,50)+1]
                end
                if !isWall(tempx,tempy)
                    Board.X = tempx
                    Board.Y = tempy
                    Board.direction = result[3]
                end
            else
                Board.X = x - 1
            end
        else
            if isWall(x,y-1)
                break
            elseif shouldWrapAround(x,y-1)
                result = wrap[(div(x-1,50),div(y-1,50),direction)]
                if mod(result[3],2) == 0
                    tempx = result[1]
                    tempy = result[2][mod(x-1,50)+1]
                else
                    tempy = result[2]
                    tempx = result[1][mod(x-1,50)+1]
                end
                if !isWall(tempx,tempy)
                    Board.X = tempx
                    Board.Y = tempy
                    Board.direction = result[3]
                end
            else
                Board.Y = y-1
            end
        end
        steps += -1
    end
    return   
end

function parseInput()
    gridRows = 0
    gridColumns = 0
    commands = Vector{String}()

    parsingGrid = true
    for line in eachline("./Day22/input.txt")
        if line == ""
            parsingGrid = false
            continue
        end
        if parsingGrid
            gridRows += 1
            gridColumns = max(gridColumns,length(line))
        else
            regex = r"L|R|[0-9]+"
            m = collect(eachmatch(regex,line))
            for match in m
                push!(commands,match.match)
            end
        end
    end

    rowRanges = zeros(2,gridRows)
    columnRanges = zeros(2,gridColumns)
    grid = zeros(gridColumns,gridRows)
    startX = 0
    startY = 0

    i = 1
    for line in eachline("./Day22/input.txt")
        if line == ""
            break
        end
        j = 1
        for c in line
            if c == '.'
                if startX == 0
                    startX = j
                    startY = i
                end
                if rowRanges[1,i] == 0
                    rowRanges[1,i] = j
                end
                if columnRanges[1,j] == 0
                    columnRanges[1,j] = i
                end
                rowRanges[2,i] = j
                columnRanges[2,j] = i
                grid[j,i] = 1
            elseif c == '#'
                if rowRanges[1,i] == 0
                    rowRanges[1,i] = j
                end
                if columnRanges[1,j] == 0
                    columnRanges[1,j] = i
                end
                rowRanges[2,i] = j
                columnRanges[2,j] = i
                grid[j,i] = 2
            end
            j += 1
        end
        i += 1
    end

    board = Boardstate(grid,rowRanges,columnRanges,startX,startY,0)

    return commands,board
end

function part1()
    commands, board = parseInput()
    #println(board.X, ",", board.Y)
    #println(board.grid[126,29])
    for c in commands
        println(c)
        if c == "R"
            turnRight(board)
        elseif c == "L"
            turnLeft(board)
        else
            walk2(board,parse(Int,c))
        end
        println(board.X, ",", board.Y, ",", board.direction)
    end
    #println(board.grid[126,29])
    println(1000 * board.Y + 4 * board.X + board.direction)
end