# Answer to puzzle 1 is visibleTrees()
# Answer to puzzle 2 is scenicScore()

function visibleTrees()
    
    function iterateHorizontalFirst(xRange::OrdinalRange{<:Integer,<:Integer}, yRange::OrdinalRange{<:Integer,<:Integer})
        referenceElement = -1
        for i in xRange
            for j in yRange
                if grid[i][j] > referenceElement
                    referenceElement = grid[i][j]
                    if NotSeenBefore[i,j]
                        NoOfVisibleTrees += 1
                        NotSeenBefore[i,j] = false
                    end
                end
            end
            referenceElement = -1
        end 
    end

    function iterateVerticalFirst(xRange::OrdinalRange{<: Integer,<: Integer}, yRange::OrdinalRange{<: Integer,<:Integer})
        referenceElement = -1
        for j in yRange
            for i in xRange
                if grid[i][j] > referenceElement
                    referenceElement = grid[i][j]
                    if NotSeenBefore[i,j]
                        NoOfVisibleTrees += 1
                        NotSeenBefore[i,j] = false
                    end
                end
            end
            referenceElement = -1
        end 
    end
    
    grid = initializeGrid()
    NoOfVisibleTrees = 0
    width = length(grid)
    height = length(grid[1])
    NotSeenBefore = trues(width,height)
    

    iterateHorizontalFirst(1:width, 1:height) 
    iterateHorizontalFirst(1:width, height:-1:1)
    iterateVerticalFirst(1:width,1:height)
    iterateVerticalFirst(width:-1:1,1:height)

    println(NoOfVisibleTrees)
end

function scenicScore()

    function iterateHorizontal(x::Integer, xRange::OrdinalRange{<:Integer,<:Integer}, y::Integer)
        currHeight = grid[x][y]
        for l in xRange
            if grid[l][y] ≥ currHeight || l == last(xRange)
                return abs(x-l)
            end
        end
    end

    function iterateVertical(x::Integer, y::Integer, yRange::OrdinalRange{<:Integer,<:Integer})
        currHeight = grid[x][y]
        for l in yRange
            if grid[x][l] ≥ currHeight || l == last(yRange)
                return abs(y-l)
            end
        end
    end

    grid = initializeGrid()
    width = length(grid)
    height = length(grid[1])
    maxScore = 0
    currScore = 1

    for i in 2:width-1
        for j in 2:height-1

            currScore *= iterateHorizontal(i, i-1:-1:1, j)
            currScore *= iterateHorizontal(i, i+1:width, j,)
            currScore *= iterateVertical(i, j, j-1:-1:1)
            currScore *= iterateVertical(i, j, j+1:height)

            maxScore = max(currScore,maxScore)
            currScore = 1
        end
    end
    println(maxScore)
end

function initializeGrid()
    grid = Vector{Vector{Integer}}()

    i = 1
    for line in eachline("./Day8/input.txt") 
        push!(grid,Vector{Int}())
        for c in eachindex(line)
            push!(grid[i],parse(Int,line[c]))
        end
        i += 1
    end

    return grid
end