using DataStructures

mutable struct node
    symbol::Char
    distance::Integer
    Neighbours::Vector{Pair{Integer,Integer}}

    function node(symbol::Char, distance::Integer, Neighbours::Vector{Pair{Integer,Integer}})
        return new(symbol,distance,Neighbours)
    end
end

function getPathtoGoal()
    grid = Vector{Vector{node}}()
    start = Pair(0,0)
    finish = Pair(0,0)

    grid, start, finish = parseInput()
    grid = reverseNeighbours(grid) # changed

    unfinishednodes = Queue{Pair{Integer,Integer}}()
    finishedNodes = Set{Pair{Integer,Integer}}()

    enqueue!(unfinishednodes,finish) # changed
    push!(finishedNodes,finish) # changed

    while !isempty(unfinishednodes)
        currNode = dequeue!(unfinishednodes)
        currDepth = grid[currNode.first][currNode.second].distance
        for p in grid[currNode.first][currNode.second].Neighbours 
            if p ∉ finishedNodes
                grid[p.first][p.second].distance = currDepth + 1
                push!(finishedNodes,p)
                enqueue!(unfinishednodes, p)
            end
            if grid[p.first][p.second].symbol == 'a'
                println(grid[p.first][p.second].distance)
                empty!(unfinishednodes)
                break
            end
        end
    end
    #=
    for i in eachindex(grid)
        for j in eachindex(grid[i])
            print("[",lpad(string(grid[i][j].distance),3,'0'),"]")
        end
        println("")
    end
    =#



    #println(grid[finish.first][finish.second].distance)
end

function parseInput()
    grid = Vector{Vector{node}}()
    start = Pair(0,0)
    finish = Pair(0,0)

    i = 1
    for line in eachline("./Day12/input.txt")
        push!(grid,Vector{node}())
        j = 1
        for c in line
            if c == 'S'
                start = Pair(i,j)
                push!(grid[i],node('a',0,Vector{Pair{Integer,Integer}}()))
            elseif c == 'E'
                finish = Pair(i,j)
                push!(grid[i],node('z',0,Vector{Pair{Integer,Integer}}()))
            else
                push!(grid[i],node(c,0,Vector{Pair{Integer,Integer}}()))
            end
            j += 1
        end
        i += 1
    end

    return grid, start, finish
end

function calculateNeighbours(grid::Vector{Vector{node}})
    
    for i in eachindex(grid)
        for j in eachindex(grid[1])
            if i ≠ lastindex(grid) && areNear(grid[i][j].symbol,grid[i+1][j].symbol)
                push!(grid[i][j].Neighbours,Pair(i+1,j))
            end
            if j ≠ lastindex(grid[1]) && areNear(grid[i][j].symbol,grid[i][j+1].symbol)
                push!(grid[i][j].Neighbours,Pair(i,j+1))
            end
            if i ≠ 1 && areNear(grid[i][j].symbol,grid[i-1][j].symbol)
                push!(grid[i][j].Neighbours,Pair(i-1,j))
            end
            if j ≠ 1 && areNear(grid[i][j].symbol,grid[i][j-1].symbol)
                push!(grid[i][j].Neighbours,Pair(i,j-1))
            end
        end
    end

    return grid
end

function areNear(a::Char,b::Char)
    return Int(b) - Int(a) ≤ 1
end

function reverseNeighbours(grid::Vector{Vector{node}})

    for i in eachindex(grid)
        for j in eachindex(grid[1])
            if i ≠ lastindex(grid) && areNear(grid[i][j].symbol,grid[i+1][j].symbol)
                push!(grid[i+1][j].Neighbours,Pair(i,j))
            end
            if j ≠ lastindex(grid[1]) && areNear(grid[i][j].symbol,grid[i][j+1].symbol)
                push!(grid[i][j+1].Neighbours,Pair(i,j))
            end
            if i ≠ 1 && areNear(grid[i][j].symbol,grid[i-1][j].symbol)
                push!(grid[i-1][j].Neighbours,Pair(i,j))
            end
            if j ≠ 1 && areNear(grid[i][j].symbol,grid[i][j-1].symbol)
                push!(grid[i][j-1].Neighbours,Pair(i,j))
            end
        end
    end

    return grid
end