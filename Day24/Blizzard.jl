using DataStructures

function parseInput()
    file = "./Day24/input.txt"
    grid = zeros(1, 1)

    height = countlines(file)
    width = 0
    start = (0, 0)
    goal = (0, 0)

    DownwardBlizzards = Vector{Tuple{<:Integer,<:Integer}}()
    UpwardBlizzards = Vector{Tuple{<:Integer,<:Integer}}()
    RightwardBlizzards = Vector{Tuple{<:Integer,<:Integer}}()
    LeftwardBlizzards = Vector{Tuple{<:Integer,<:Integer}}()

    j = 1
    for line in eachline(file)
        if width == 0
            width = length(line)
            grid = zeros(Int, width, height)
        end

        i = 1
        for c in line
            if c == '#'
                grid[i, j] = -1
            elseif c == '.'
                if j == 1
                    start = (i, j)
                elseif j == height
                    goal = (i, j)
                end
            elseif c == '>'
                grid[i, j] += 1
                push!(RightwardBlizzards, (i, j))
            elseif c == '<'
                grid[i, j] += 1
                push!(LeftwardBlizzards, (i, j))
            elseif c == '^'
                grid[i, j] += 1
                push!(UpwardBlizzards, (i, j))
            elseif c == 'v'
                grid[i, j] += 1
                push!(DownwardBlizzards, (i, j))
            end
            i += 1
        end
        j += 1
    end

    return grid, start, goal, UpwardBlizzards, DownwardBlizzards, RightwardBlizzards, LeftwardBlizzards
end

function drawGrid(grid)
    for j in axes(grid, 2)
        for i in axes(grid, 1)
            if grid[i, j] == -1
                print("#")
            elseif grid[i, j] == 0
                print(".")
            else
                print(grid[i, j])
            end
        end
        println("")
    end
end

function BlizzardBFS()
    grid, start, goal, UpwardBlizzards, DownwardBlizzards, RightwardBlizzards, LeftwardBlizzards = parseInput()

    #println(start)
    Positions = Set{Tuple{<:Integer,<:Integer}}()
    push!(Positions, start)

    time = 0
    finished = false

    while !finished

        time += 1
        #println("In Loop: ", time)

        grid, DownwardBlizzards = moveBlizzardsDown(grid, DownwardBlizzards)
        grid, LeftwardBlizzards = moveBlizzardsLeft(grid, LeftwardBlizzards)
        grid, RightwardBlizzards = moveBlizzardsRight(grid, RightwardBlizzards)
        grid, UpwardBlizzards = moveBlizzardsUp(grid, UpwardBlizzards)

        #drawGrid(grid)

        newPositions = Set{Tuple{<:Integer,<:Integer}}()
        for (x, y) in Positions
            #println("Considering ", (x, y))
            if grid[x, y] == 0
                push!(newPositions, (x, y))
            end
            if grid[x+1, y] == 0
                push!(newPositions, (x + 1, y))
            end
            if grid[x-1, y] == 0
                push!(newPositions, (x - 1, y))
            end
            if grid[x, y+1] == 0
                if (x, y + 1) == goal
                    finished = true
                    break
                else
                    push!(newPositions, (x, y + 1))
                end
            end
            if y - 1 > 0 && grid[x, y-1] == 0
                if (x, y - 1) != start
                    push!(newPositions, (x, y - 1))
                end
            end
        end

        Positions = newPositions

    end

    println("First goal: ", time)

    finished = false

    Positions = Set{Tuple{<:Integer,<:Integer}}()
    push!(Positions, goal)

    while !finished

        time += 1
        #println("In Loop: ", time)

        grid, DownwardBlizzards = moveBlizzardsDown(grid, DownwardBlizzards)
        grid, LeftwardBlizzards = moveBlizzardsLeft(grid, LeftwardBlizzards)
        grid, RightwardBlizzards = moveBlizzardsRight(grid, RightwardBlizzards)
        grid, UpwardBlizzards = moveBlizzardsUp(grid, UpwardBlizzards)

        #drawGrid(grid)

        newPositions = Set{Tuple{<:Integer,<:Integer}}()
        for (x, y) in Positions
            #println("Considering ", (x, y))
            if grid[x, y] == 0
                push!(newPositions, (x, y))
            end
            if grid[x+1, y] == 0
                push!(newPositions, (x + 1, y))
            end
            if grid[x-1, y] == 0
                push!(newPositions, (x - 1, y))
            end
            if y + 1 < size(grid, 2) && grid[x, y+1] == 0
                push!(newPositions, (x, y + 1))
            end
            if y - 1 > 0 && grid[x, y-1] == 0
                if (x, y - 1) == start
                    finished = true
                    break
                end
                if (x, y - 1) != start
                    push!(newPositions, (x, y - 1))
                end
            end
        end

        Positions = newPositions

    end

    println("second goal: ", time)

    finished = false

    Positions = Set{Tuple{<:Integer,<:Integer}}()
    push!(Positions, start)

    while !finished

        time += 1
        #println("In Loop: ", time)

        grid, DownwardBlizzards = moveBlizzardsDown(grid, DownwardBlizzards)
        grid, LeftwardBlizzards = moveBlizzardsLeft(grid, LeftwardBlizzards)
        grid, RightwardBlizzards = moveBlizzardsRight(grid, RightwardBlizzards)
        grid, UpwardBlizzards = moveBlizzardsUp(grid, UpwardBlizzards)

        #drawGrid(grid)

        newPositions = Set{Tuple{<:Integer,<:Integer}}()
        for (x, y) in Positions
            #println("Considering ", (x, y))
            if grid[x, y] == 0
                push!(newPositions, (x, y))
            end
            if grid[x+1, y] == 0
                push!(newPositions, (x + 1, y))
            end
            if grid[x-1, y] == 0
                push!(newPositions, (x - 1, y))
            end
            if grid[x, y+1] == 0
                if (x, y + 1) == goal
                    finished = true
                    break
                else
                    push!(newPositions, (x, y + 1))
                end
            end
            if y - 1 > 0 && grid[x, y-1] == 0
                if (x, y - 1) != start
                    push!(newPositions, (x, y - 1))
                end
            end
        end

        Positions = newPositions

    end


    println("final time: ", time)
end

function moveBlizzardsDown(grid, DownwardBlizzards)
    newBlizzards = Vector{Tuple{<:Integer,<:Integer}}()
    for (x, y) in DownwardBlizzards
        grid[x, y] += -1
        if grid[x, y+1] == -1
            push!(newBlizzards, (x, 2))
            grid[x, 2] += 1
        else
            push!(newBlizzards, (x, y + 1))
            grid[x, y+1] += 1
        end
    end

    return grid, newBlizzards
    #drawGrid(grid)
end

function moveBlizzardsUp(grid, UpwardBlizzards)
    newBlizzards = Vector{Tuple{<:Integer,<:Integer}}()
    for (x, y) in UpwardBlizzards
        grid[x, y] += -1
        if grid[x, y-1] == -1
            push!(newBlizzards, (x, size(grid, 2) - 1))
            grid[x, size(grid, 2)-1] += 1
        else
            push!(newBlizzards, (x, y - 1))
            grid[x, y-1] += 1
        end
    end

    return grid, newBlizzards
    #drawGrid(grid)
end

function moveBlizzardsRight(grid, RightwardBlizzards)
    newBlizzards = Vector{Tuple{<:Integer,<:Integer}}()
    for (x, y) in RightwardBlizzards
        grid[x, y] += -1
        if grid[x+1, y] == -1
            push!(newBlizzards, (2, y))
            grid[2, y] += 1
        else
            push!(newBlizzards, (x + 1, y))
            grid[x+1, y] += 1
        end
    end

    return grid, newBlizzards
    #drawGrid(grid)
end

function moveBlizzardsLeft(grid, LeftwardBlizzards)
    newBlizzards = Vector{Tuple{<:Integer,<:Integer}}()
    for (x, y) in LeftwardBlizzards
        grid[x, y] += -1
        if grid[x-1, y] == -1
            push!(newBlizzards, (size(grid, 1) - 1, y))
            grid[size(grid, 1)-1, y] += 1
        else
            push!(newBlizzards, (x - 1, y))
            grid[x-1, y] += 1
        end
    end

    return grid, newBlizzards
    #drawGrid(grid)
end