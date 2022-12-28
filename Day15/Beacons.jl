using DataStructures

# Solution to puzzle 1 is calculateEmptySpots(2000000)
# Solution to puzzle 2 is calculateDistressBeaconSpot(4000000)


# three helper structs for cleaner code
struct sensor
    x::Integer
    y::Integer
    range::Integer

    function sensor(x::Integer, y::Integer, range::Integer)
        return new(x, y, range)
    end
end

struct beacon
    x::Integer
    y::Integer

    function beacon(x::Integer, y::Integer)
        return new(x, y)
    end
end

struct quadrant
    x₁::Integer
    y₁::Integer

    x₂::Integer
    y₂::Integer

    function quadrant(x₁::Integer, y₁::Integer, x₂::Integer, y₂::Integer)
        return new(x₁, y₁, x₂, y₂)
    end
end

# For each sensor, we calculate the interval which it covers on the given y-level.
# We then calculate the union of this interval with the intervals we already got.
# Lastly we calculate the size of the interval and subtract any beacon that we already
# know lies on the y-level.
function calculateEmptySpots(level::Integer)

    Ranges = Vector{Tuple{<:Integer,<:Integer}}()
    occupiedSpaces = 0

    sensors, beacons = parseInput()

    for sensor in sensors
        range = sensor.range
        x = sensor.x
        y = sensor.y

        # rangeRemaining is the number of spots the interval extends
        # in each direction from the x-coordinate of the sensor
        # on the given y-level.
        # If this is negative, the given sensor does not cover any field
        # on that level.
        rangeRemaining = range - abs(level - y)
        if rangeRemaining < 0
            continue
        end

        # the bounds of the interval the sensor is covering on the given y-level
        left = x - rangeRemaining
        right = x + rangeRemaining

        # here we calculate the union of the given interval with the ones we already have.
        union(left, right, Ranges)

    end

    # Finally we count the spaces covered
    for (a, b) in Ranges
        occupiedSpaces += (b - a) + 1
    end

    # and subtract the beacons already known on that level
    for b in beacons
        if b.y == level
            occupiedSpaces += -1
        end
    end

    println(occupiedSpaces)
end

# We use divide-and-conquer to divide the search space in four quadrants every step.
# Each quadrant is checked if it could contain uncovered points.
# This is done by checking if for each sensor, at least one corner is not covered.
# If a sensor covers all corners, that quadrant is fully covered and has no uncovered points.
# Finally if our quadrant is only a single point and is uncovered, we have found our Solution.
function calculateDistressBeaconSpot(maximumCoordinate::Integer)

    # We check if there is a sensor that covers all corners, then our quadrant can be dismissed.
    function IsCovered(q::quadrant)

        x₁ = q.x₁
        y₁ = q.y₁
        x₂ = q.x₂
        y₂ = q.y₂
        corners = [(x₁, y₁), (x₁, y₂), (x₂, y₁), (x₂, y₂)]

        for sensor in sensors
            x = sensor.x
            y = sensor.y
            range = sensor.range
            covered = true

            # a corner is covered, if it is in the range of the sensor
            for (a, b) in corners
                if abs(x - a) + abs(y - b) > range
                    covered = false
                end
            end

            if covered
                return true
            end
        end
        return false
    end

    sensors, _ = parseInput()
    x = 0
    y = 0
    quadrants = Stack{quadrant}()

    push!(quadrants, quadrant(0, 0, maximumCoordinate, maximumCoordinate))

    while !isempty(quadrants)
        q = pop!(quadrants)

        # if it is covered, we can dismiss this corner
        if IsCovered(q)
            continue
        end
        x₁ = q.x₁
        y₁ = q.y₁
        x₂ = q.x₂
        y₂ = q.y₂

        # if our quadrant is only a point, we have found our Solution
        if x₁ == x₂ && y₁ == y₂
            x = x₁
            y = y₁
            break
        end

        # otherwise we divide into four quadrants and add them to our Stack.
        mid₁ = div(x₁ + x₂, 2)
        mid₂ = div(y₁ + y₂, 2)

        q₁ = quadrant(x₁, y₁, mid₁, mid₂)
        q₂ = quadrant(mid₁ + 1, y₁, x₂, mid₂)
        q₃ = quadrant(x₁, mid₂ + 1, mid₁, y₂)
        q₄ = quadrant(mid₁ + 1, mid₂ + 1, x₂, y₂)

        push!(quadrants, q₁)
        push!(quadrants, q₂)
        push!(quadrants, q₃)
        push!(quadrants, q₄)

    end

    println(x * 4000000 + y)
end

# We use a regex to capture the information we need and then build the structs for it
function parseInput()

    sensors = Vector{sensor}()
    # Since some sensors spot the same beacon, we need a set to not have duplicates.
    beacons = Set{beacon}()

    for line in eachline("./Day15/input.txt")
        regex = r"Sensor at x=(-*[0-9]*), y=(-*[0-9]*): closest beacon is at x=(-*[0-9]*), y=(-*[0-9]*)"
        matches = match(regex, line)

        x = parse(Int, matches[1])
        y = parse(Int, matches[2])
        BeaconX = parse(Int, matches[3])
        BeaconY = parse(Int, matches[4])

        range = abs(BeaconX - x) + abs(BeaconY - y)
        push!(sensors, sensor(x, y, range))
        push!(beacons, beacon(BeaconX, BeaconY))
    end
    return sensors, beacons
end

# two intervals intersect when one starting point lies in the other interval
function areIntersecting(Astart::Integer, Aend::Integer, Bstart::Integer, Bend::Integer)
    return Astart ≤ Bstart ≤ Aend || Bstart ≤ Astart ≤ Bend
end

# we first check each Interval if it intersects with our current interval
# and then "absorb" the other interval.
# When we have checked every interval, we delete the absorbed ones from our Vector
# and add the new one to our Vector.
function union(left::Integer, right::Integer, Ranges::Vector{Tuple{<:Integer,<:Integer}})
    # Here we store the indices we need to remove later, to not mess with out iterator on the fly
    absorbed = Vector{Integer}()
    for i in eachindex(Ranges)
        (a, b) = Ranges[i]

        # if the new interval and the one we are currently looking at
        # intersect, we build a new one that is the union of both
        if areIntersecting(left, right, a, b)

            # with these bounds, the new interval is the union of the two
            left = min(left, a)
            right = max(right, b)
            push!(absorbed, i)

        end
    end

    # finally we delete absorbed ones and add our new one
    deleteat!(Ranges, absorbed)
    push!(Ranges, (left, right))
end