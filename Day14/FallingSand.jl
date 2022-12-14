function fallingSand()
    grid, basepointX, basepointY, width, height = parseInput()

    fallenDown = false
    placedSand = 0

    while !fallenDown
        sandX = 500 - basepointX
        sandY = 1
        for i in 1:height #maybe minus one
            if grid[sandX,sandY + 1] == false
                sandY += 1
            elseif grid[sandX - 1, sandY + 1] == false
                sandX += -1
                sandY += 1
            elseif grid[sandX + 1, sandY + 1] == false
                sandX += 1
                sandY += 1
            else
                if grid[sandX,sandY] == true
                    fallenDown = true
                    break
                else
                    grid[sandX,sandY] = true
                    placedSand += 1
                    break
                end
            end
            #=
            if sandY ≥ height
                fallenDown = true  
                break 
            end
            =#
        end
        #drawGrid(grid)
    end

    drawGrid(grid)
    println(placedSand)
end

function parseInput()
    maxLeft = 500
    maxRight = 0
    maxHeight = 0
    maxDepth = 0

    for line in eachline("./Day14/input.txt")
        coords = split(line," -> ")
        for w in coords
            XY = split(w,",")
            x = parse(Int,XY[1])
            y = parse(Int,XY[2])
            maxRight = max(x,maxRight)
            maxLeft = min(x,maxLeft)
            maxHeight = max(y,maxHeight)
            maxDepth = min(y,maxDepth)
        end
    end

    basepointY = maxDepth - 1

    height = abs(maxHeight - maxDepth) + 3
    width = 2 * height - 1

    basepointX = 500 - height

    grid = falses(width,height)

    for line in eachline("./Day14/input.txt")
        segments = split(line, " -> ")
        for i in 2:length(segments)
            startcoordinates = split(segments[i-1], ",")
            endcoordinates = split(segments[i], ",") 
            startx = parse(Int, startcoordinates[1]) - basepointX
            starty = parse(Int,startcoordinates[2]) - basepointY
            endX = parse(Int,endcoordinates[1]) - basepointX
            endY = parse(Int,endcoordinates[2]) - basepointY
            grid = drawLine(startx,starty,endX,endY,grid)
        end
    end

    grid = drawLine(1,height,width,height,grid)

    drawGrid(grid)
    return grid, basepointX, basepointY, width, height
end

function drawLine(startX::Integer,startY::Integer,endX::Integer,endY::Integer,grid::BitMatrix)
    if startX < endX
        for i in startX:endX
            grid[i,startY] = true
        end
    elseif startX > endX
        for i in startX:-1:endX
            grid[i,startY] = true
        end
    elseif startY < endY
        for i in startY:endY
            grid[startX,i] = true   
        end
    elseif startY ≥ endY
        for i in startY:-1:endY
            grid[startX,i] = true
        end
    end
    #drawGrid(grid)
    return grid
end

function drawGrid(grid::BitMatrix)
    for i in axes(grid, 2)
        for j in axes(grid, 1)
            if grid[j, i] == true
                print("#")
            else
                print(".")
            end
        end
        println("")
    end
    println("----")
end
    