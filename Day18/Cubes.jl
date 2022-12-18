using DataStructures

function countAllSurface()

    cubes = Set{Tuple{<:Integer,<:Integer,<:Integer}}()

    for line in eachline("./Day18/input.txt")
        coordinates = split(line,",")
        push!(cubes,(parse(Int,coordinates[1]),parse(Int,coordinates[2]),parse(Int,coordinates[3])))
    end

    sides = length(cubes) * 6

    for c in cubes
        if (c[1]+1,c[2],c[3]) ∈ cubes
            sides += -1
        end
        if (c[1]-1,c[2],c[3]) ∈ cubes
            sides += -1
        end
        if (c[1],c[2]+1,c[3]) ∈ cubes
            sides += -1
        end
        if (c[1],c[2]-1,c[3]) ∈ cubes
            sides += -1
        end
        if (c[1],c[2],c[3]+1) ∈ cubes
            sides += -1
        end
        if (c[1],c[2],c[3]-1) ∈ cubes
            sides += -1
        end
    end

    println(sides)
end

function countExteriorSurface()
    
    cubes = Set{Tuple{<:Integer,<:Integer,<:Integer}}()
    maxCoordinates = Vector{Integer}([0,0,0,0,0,0])

    for line in eachline("./Day18/test.txt")
        coordinates = split(line,",")
        x = parse(Int,coordinates[1])
        y = parse(Int,coordinates[2])
        z = parse(Int,coordinates[3])
        push!(cubes,(x,y,z))
        maxCoordinates[1] = max(maxCoordinates[1],x)
        maxCoordinates[2] = min(maxCoordinates[2],x)
        maxCoordinates[3] = max(maxCoordinates[3],y)
        maxCoordinates[4] = min(maxCoordinates[4],y)
        maxCoordinates[5] = max(maxCoordinates[5],z)
        maxCoordinates[6] = min(maxCoordinates[6],z)
    end

    surfaces = Set{Tuple{<:Integer,<:Integer,<:Integer}}()
    insides = Set{Tuple{<:Integer,<:Integer,<:Integer}}()
    outsides = Set{Tuple{<:Integer,<:Integer,<:Integer}}()

    for c in cubes
        if (c[1]+1,c[2],c[3]) ∉ cubes
            push!(surfaces,(c[1]+1,c[2],c[3]))
        end
        if (c[1]-1,c[2],c[3]) ∉ cubes
            push!(surfaces,(c[1]-1,c[2],c[3]))
        end
        if (c[1],c[2]+1,c[3]) ∉ cubes
            push!(surfaces,(c[1],c[2]+1,c[3]))
        end
        if (c[1],c[2]-1,c[3]) ∉ cubes
            push!(surfaces,(c[1],c[2]-1,c[3]))
        end
        if (c[1],c[2],c[3]+1) ∉ cubes
            push!(surfaces,(c[1],c[2],c[3]+1))
        end
        if (c[1],c[2],c[3]-1) ∉ cubes
            push!(surfaces,(c[1],c[2],c[3]-1))
        end
    end

    println("maxCoordinates:", maxCoordinates)
    println("nr of surface cube: ", length(surfaces))
    for cube in surfaces
        println("testing surfaceCube")
        if cube ∈ insides || cube ∈ outsides
            continue
        end
        visited = Set{Tuple{<:Integer,<:Integer,<:Integer}}()
        queue = Queue{Tuple{<:Integer,<:Integer,<:Integer}}()
        enqueue!(queue,cube)
        inside = true
        tested = 1
        while !isempty(queue) && inside
            println("testNr: ", tested, " mit queue size: ", length(queue))
            tested += 1
            c = dequeue!(queue)
            push!(visited,c)
            if !inBounds(c,maxCoordinates)
                inside = false  
                break
            end
            if (c[1]+1,c[2],c[3]) ∉ cubes && (c[1]+1,c[2],c[3]) ∉ visited && (c[1]+1,c[2],c[3]) ∉ queue
                enqueue!(queue,(c[1]+1,c[2],c[3]))
            end
            if (c[1]-1,c[2],c[3]) ∉ cubes && (c[1]-1,c[2],c[3]) ∉ visited && (c[1]-1,c[2],c[3]) ∉ queue
                enqueue!(queue,(c[1]-1,c[2],c[3]))
            end
            if (c[1],c[2]+1,c[3]) ∉ cubes && (c[1],c[2]+1,c[3]) ∉ visited && (c[1],c[2]+1,c[3]) ∉ queue
                enqueue!(queue,(c[1],c[2]+1,c[3]))
            end
            if (c[1],c[2]-1,c[3]) ∉ cubes && (c[1],c[2]-1,c[3]) ∉ visited && (c[1],c[2]-1,c[3]) ∉ queue
                enqueue!(queue,(c[1],c[2]-1,c[3]))
            end
            if (c[1],c[2],c[3]+1) ∉ cubes && (c[1],c[2],c[3]+1) ∉ visited && (c[1],c[2],c[3]+1) ∉ queue
                enqueue!(queue,(c[1],c[2],c[3]+1))
            end
            if (c[1],c[2],c[3]-1) ∉ cubes && (c[1],c[2],c[3]-1) ∉ visited && (c[1],c[2],c[3]-1) ∉ queue
                enqueue!(queue,(c[1],c[2],c[3]-1))
            end
        end
        if inside
            for v in visited
                push!(insides,v)
            end
            while !isempty(queue)
                push!(insides,dequeue!(queue))
            end
        else
            for v in visited
                push!(outsides,v)
            end
            while !isempty(queue)
                push!(outsides,dequeue!(queue))
            end
        end
    end

    sides = length(cubes) * 6

    for c in cubes
        if (c[1]+1,c[2],c[3]) ∈ cubes || (c[1]+1,c[2],c[3]) ∈ insides
            sides += -1
        end
        if (c[1]-1,c[2],c[3]) ∈ cubes || (c[1]-1,c[2],c[3]) ∈ insides
            sides += -1
        end
        if (c[1],c[2]+1,c[3]) ∈ cubes || (c[1],c[2]+1,c[3]) ∈ insides
            sides += -1
        end
        if (c[1],c[2]-1,c[3]) ∈ cubes || (c[1],c[2]-1,c[3]) ∈ insides
            sides += -1
        end
        if (c[1],c[2],c[3]+1) ∈ cubes || (c[1],c[2],c[3]+1) ∈ insides
            sides += -1
        end
        if (c[1],c[2],c[3]-1) ∈ cubes || (c[1],c[2],c[3]-1) ∈ insides
            sides += -1
        end
    end

    #println(length(cubes))
    #println(length(insides))

    println(sides)
end

function inBounds(cube::Tuple{<:Integer,<:Integer,<:Integer},maxCoordinates::Vector{Integer})
    isInBoundsX = maxCoordinates[1] > cube[1] > maxCoordinates[2]
    isInBoundsY = maxCoordinates[3] > cube[2] > maxCoordinates[4]
    isInBoundsZ = maxCoordinates[5] > cube[3] > maxCoordinates[6]
    return isInBoundsX && isInBoundsY && isInBoundsZ
end