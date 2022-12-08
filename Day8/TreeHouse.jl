function visibleTrees()
    grid = Vector{Vector{Integer}}()
    i = 1
    NoOfVisibleTrees = 0

    for line in eachline("./Day8/test.txt") 
        push!(grid,Vector{Int}())
        j = 1
        for c in line
            push!(grid[i],parse(Int,c))
            j += 1
        end
        i += 1
    end

    NotSeenBefore = trues(length(grid),length(grid[1]))

    # top down
    referenceElement = -1
    for i in 1:length(grid)
        for j in 1:length(grid[i])
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

    
    # left to right
    for j in 1:length(grid[1]) 
        for i in 1:length(grid)
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

    # down to up
    for i in 1:length(grid)
        for j in length(grid[i]):-1:1
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

    # right to left
    for j in 1:length(grid[1]) 
        for i in length(grid):-1:1
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

    println(NoOfVisibleTrees)
end

function scenicScore()
    grid = Vector{Vector{Integer}}()
    i = 1

    for line in eachline("./Day8/input.txt") 
        push!(grid,Vector{Int}())
        j = 1
        for c in line
            push!(grid[i],parse(Int,c))
            j += 1
        end
        i += 1
    end

    maxScore = 0
    currScore = 1
    for i in 2:length(grid) -1
        for j in 2:length(grid[i]) -1
            currHeight = grid[i][j]

            for l in i-1:-1:1
                if grid[l][j] ≥ currHeight || l == 1
                    currScore *= (i - l)
                    break
                    #println("curr scenic score for [", i, j, "is " , currScore)
                end
            end
            

            for l in i+1:length(grid)
                if grid[l][j] ≥ currHeight || l == length(grid)
                    currScore *= (l - i)
                    break
                end
            end

            for l in j-1:-1:1
                if grid[i][l] ≥ currHeight || l == 1
                    currScore *= (j - l)
                    break
                end
            end

            for l in j+1:length(grid[i])
                if grid[i][l] ≥ currHeight || l == length(grid[i])
                    currScore *= (l - j)
                    break
                end
            end

            #println("curr scenic score for [", i, j, "is " , currScore)

            if currScore > maxScore
                maxScore = currScore
            end

            currScore = 1
        end
    end
    println(maxScore)
end
