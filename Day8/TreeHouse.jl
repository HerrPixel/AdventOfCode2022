# Answer to puzzle 1 is visibleTrees()
# Answer to puzzle 2 is scenicScore()

# We first parse our input into a grid of trees heights.
# We then iterate throughout the lines and columns from all sides.
# To avoid double counting we keep a grid of booleans
# that denote the position of trees that have been accounted for.
function visibleTrees()
    
    # We keep two helper functions to avoid code bloating
    # this function iterates over all columns first and then all rows, i.e. top down and bottom up
    function iterateHorizontalFirst(xRange::OrdinalRange{<:Integer,<:Integer}, yRange::OrdinalRange{<:Integer,<:Integer})
        # We always keep the highest tree seen in that view
        referenceElement = -1
        for i in xRange
            for j in yRange

                if grid[i][j] > referenceElement
                    referenceElement = grid[i][j]

                    # Our highest seen tree might already be the highest tree of another iteration,
                    # so we need to check if we have counted this one already
                    if NotSeenBefore[i,j]
                        NoOfVisibleTrees += 1
                        NotSeenBefore[i,j] = false
                    end
                end
            end
            referenceElement = -1
        end 
    end

    # We keep two helper functions to avoid code bloating
    # this function iterates over all rows first and then all columns, i.e. right to left and left to right
    function iterateVerticalFirst(xRange::OrdinalRange{<: Integer,<: Integer}, yRange::OrdinalRange{<: Integer,<:Integer})
        # We always keep the highest tree seen in that view
        referenceElement = -1
        for j in yRange
            for i in xRange

                if grid[i][j] > referenceElement
                    referenceElement = grid[i][j]

                    # Our highest seen tree might already be the highest tree of another iteration,
                    # so we need to check if we have counted this one already
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
    
    iterateHorizontalFirst(1:width, 1:height) # top down columns
    iterateHorizontalFirst(1:width, height:-1:1) # bottom up columns
    iterateVerticalFirst(1:width,1:height) # left to right rows
    iterateVerticalFirst(width:-1:1,1:height) # right to left rows

    println(NoOfVisibleTrees)
end

# We first parse our input into a grid of tree heights.
# We then iterate over all trees and calculate their scenic scores
# by iterating in all four cardinal directions until we hit a tree big enough.
# We then compare its score to the highest score seen so far and keep the bigger one.
function scenicScore()

    # We keep helper functions to avoid code bloating
    # This function iterates horizontaly while keeping its y-coordinate
    # it returns the first tree higher or equal than the starting tree
    # in the current iteration protocol
    function iterateHorizontal(x::Integer, xRange::OrdinalRange{<:Integer,<:Integer}, y::Integer)
        currHeight = grid[x][y]
        for l in xRange
            # an edge case is given, if the starting tree is the highest tree, i.e. we hit the edge of the grid
            if grid[l][y] ≥ currHeight || l == last(xRange)
                return abs(x-l)
            end
        end
    end

    # We keep helper functions to avoid code bloating
    # This function iterates vertically while keeping its x-coordinate
    # it returns the first tree higher or equal than the starting tree
    # in the current iteration protocol
    function iterateVertical(x::Integer, y::Integer, yRange::OrdinalRange{<:Integer,<:Integer})
        currHeight = grid[x][y]
        for l in yRange
            # an edge case is given, if the starting tree is the highest tree, i.e. we hit the edge of the grid
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

    # Since the trees on the edge all have scenicScore 0, since atleast one direction has view 0, we can ignore them
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

# We just read the input and write each single number into a new cell in the grid
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