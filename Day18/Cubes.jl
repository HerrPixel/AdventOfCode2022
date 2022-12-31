using DataStructures

# Solution to puzzle 1 is countAllSurface()
# Solution to puzzle 2 is countExteriorSurface()

# helper struct to keep track of the maximum perimeter.
# With this we can test if a surface is on the outside:
# if there is a path of non-cubes to any coordinate
# outside of the perimeter, then that surface cube is
# not on the inside.
mutable struct Perimeter
    minX::Integer
    maxX::Integer
    minY::Integer
    maxY::Integer
    minZ::Integer
    maxZ::Integer

    function Perimeter(minX::Integer, maxX::Integer, minY::Integer, maxY::Integer, minZ::Integer, maxZ::Integer)
        return new(minX, maxX, minY, maxY, minZ, maxZ)
    end
end

# helper function for updating the perimeter with new inputs
function updatePerimeter(perimeter::Perimeter, x::Integer, y::Integer, z::Integer)
    perimeter.minX = min(perimeter.minX, x)
    perimeter.maxX = max(perimeter.maxX, x)
    perimeter.minY = min(perimeter.minY, y)
    perimeter.maxY = max(perimeter.maxY, y)
    perimeter.minZ = min(perimeter.minZ, z)
    perimeter.maxZ = max(perimeter.maxZ, z)
end

# helper function to test if a coordinate is in the perimeter
function inBounds(perimeter::Perimeter, x::Integer, y::Integer, z::Integer)
    isInBoundsX = perimeter.minX ≤ x ≤ perimeter.maxX
    isInBoundsY = perimeter.minY ≤ y ≤ perimeter.maxY
    isInBoundsZ = perimeter.minZ ≤ z ≤ perimeter.maxZ
    return isInBoundsX && isInBoundsY && isInBoundsZ
end

# helper function to parse the input into a Set of cubes
# and the minimal perimeter enclosing them
function parseInput()
    cubes = Set{Tuple{<:Integer,<:Integer,<:Integer}}()
    perimeter = Perimeter(0, 0, 0, 0, 0, 0)

    for line in eachline("./Day18/input.txt")
        Stringx, Stringy, Stringz = split(line, ",")
        x = parse(Int, Stringx)
        y = parse(Int, Stringy)
        z = parse(Int, Stringz)
        push!(cubes, (x, y, z))
        updatePerimeter(perimeter, x, y, z)
    end

    return cubes, perimeter
end

# easy solution for puzzle 1, we calculate the maximum surface area,
# i.e. if all 6 sides are free and then test each side if the neighbour
# exists and subtract that side from the SurfaceArea
function countAllSurface()

    cubes, _ = parseInput()
    neighbours = [(1, 0, 0), (-1, 0, 0), (0, 1, 0), (0, -1, 0), (0, 0, 1), (0, 0, -1)]
    SurfaceArea = length(cubes) * 6

    for (x, y, z) in cubes
        for (Δx, Δy, Δz) in neighbours
            if (x + Δx, y + Δy, z + Δz) ∈ cubes
                SurfaceArea += -1
            end
        end
    end

    println(SurfaceArea)
end

# For puzzle 2, we first store each free coordinate adjacent to any cube
# and then do BFS from each of those to check if they are on the outside or inside.
# Finally we count the surface area of all cubes like in puzzle 1 but also check if
# the neighbour is on the inside and also subtract this side from the Surface Area
function countExteriorSurface()

    cubes, perimeter = parseInput()
    neighbours = [(1, 0, 0), (-1, 0, 0), (0, 1, 0), (0, -1, 0), (0, 0, 1), (0, 0, -1)]

    surfaces = Set{Tuple{<:Integer,<:Integer,<:Integer}}()
    insides = Set{Tuple{<:Integer,<:Integer,<:Integer}}()
    outsides = Set{Tuple{<:Integer,<:Integer,<:Integer}}()

    # finding out all adjacent coordinates that are not cubes themselves
    for (x, y, z) in cubes
        for (Δx, Δy, Δz) in neighbours
            if (x + Δx, y + Δy, z + Δz) ∉ cubes
                push!(surfaces, (x + Δx, y + Δy, z + Δz))
            end
        end
    end

    # BFS from each of those coordinates to check if they are on the inside or outside
    for cube in surfaces

        # If we already labeled that coordinate, skip it
        if cube ∈ insides || cube ∈ outsides
            continue
        end

        visited = Set{Tuple{<:Integer,<:Integer,<:Integer}}()
        queue = Queue{Tuple{<:Integer,<:Integer,<:Integer}}()
        enqueue!(queue, cube)
        push!(visited, cube)
        inside = true

        while !isempty(queue)
            (x, y, z) = dequeue!(queue)

            # If a coordinate reaches outside of the perimeter, 
            # then it is on the outside as well as every other coordinate it touches
            if !inBounds(perimeter, x, y, z)
                inside = false
                break
            end

            for (Δx, Δy, Δz) in neighbours
                if (x + Δx, y + Δy, z + Δz) ∉ cubes && (x + Δx, y + Δy, z + Δz) ∉ visited
                    enqueue!(queue, (x + Δx, y + Δy, z + Δz))
                    push!(visited, (x + Δx, y + Δy, z + Δz))
                end
            end
        end

        # every coordinate that can be reached from the current one has the same label,
        # so we label all of them simultaniously
        if inside
            flush(insides, queue, visited)
        else
            flush(outsides, queue, visited)
        end
    end

    # finally the same strategy as in puzzle 1 
    # except also ignoring coordinates on the inside

    SurfaceArea = length(cubes) * 6

    for (x, y, z) in cubes
        for (Δx, Δy, Δz) in neighbours
            if (x + Δx, y + Δy, z + Δz) ∈ cubes || (x + Δx, y + Δy, z + Δz) ∈ insides
                SurfaceArea += -1
            end
        end
    end

    println(SurfaceArea)
end

# helper function to label all reached coordinates simultaniously
function flush(target::Set{Tuple{<:Integer,<:Integer,<:Integer}}, queue::Queue{Tuple{<:Integer,<:Integer,<:Integer}}, visitedCubes::Set{Tuple{<:Integer,<:Integer,<:Integer}})
    for v in visitedCubes
        push!(target, v)
    end
    while !isempty(queue)
        push!(target, dequeue!(queue))
    end
end