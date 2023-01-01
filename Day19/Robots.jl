using DataStructures

# Solution to puzzle 1 is Part1()
# Solution to Puzzle 2 is Part2()

# Helper struct for tracking the costs of building a specific robot
struct RobotBlueprint
    oreCosts::Integer
    clayCosts::Integer
    obsidianCosts::Integer

    function RobotBlueprint(oreCosts::Integer, clayCosts::Integer, obsidianCosts::Integer)
        return new(oreCosts, clayCosts, obsidianCosts)
    end
end

# Helper struct to keep a state of the current situation in our DFS
struct world
    NumberOfRobots::Vector{<:Integer}
    maximumRobots::Vector{<:Integer}
    Ressources::Vector{<:Integer}
    Blueprints::Vector{RobotBlueprint}


    function world(NumberOfRobots::Vector{<:Integer}, maximumRobots::Vector{<:Integer}, Ressources::Vector{<:Integer}, Blueprints::Vector{RobotBlueprint})
        return new(NumberOfRobots, maximumRobots, Ressources, Blueprints)
    end
end

# We capture the information we need from the input via a regex
# and just create the blueprints
function parseInput()
    blueprints = Vector{Vector{RobotBlueprint}}()
    regex = r"Blueprint [0-9]+: Each ore robot costs ([0-9]+) ore. Each clay robot costs ([0-9]+) ore. Each obsidian robot costs ([0-9]+) ore and ([0-9]+) clay. Each geode robot costs ([0-9]+) ore and ([0-9]+) obsidian."

    for line in eachline("./Day19/input.txt")
        currentBluePrint = Vector{RobotBlueprint}()

        matches = match(regex, line)
        OreRobotCosts = parse(Int, matches[1])
        ClayRobotCosts = parse(Int, matches[2])
        ObsidianRobotOreCosts = parse(Int, matches[3])
        ObsidianRobotClayCosts = parse(Int, matches[4])
        GeodeRobotOreCosts = parse(Int, matches[5])
        GeodeRobotObsidianCosts = parse(Int, matches[6])

        push!(currentBluePrint, RobotBlueprint(OreRobotCosts, 0, 0))
        push!(currentBluePrint, RobotBlueprint(ClayRobotCosts, 0, 0))
        push!(currentBluePrint, RobotBlueprint(ObsidianRobotOreCosts, ObsidianRobotClayCosts, 0))
        push!(currentBluePrint, RobotBlueprint(GeodeRobotOreCosts, 0, GeodeRobotObsidianCosts))

        push!(blueprints, currentBluePrint)
    end

    return blueprints
end

# Via DFS, we obtain the maximum Geodes we can open in the specified time
# and then just calculate the QualityLevels and sum them.
# Via many Pruning strategies, this DFS runs fast.
# We explain them below.
function Part1()
    # Maximum geodes obtained in 24 time with 30 (=all) blueprints
    maximumGeodes = GetMaximumPossibleGeodes(24, 30)
    SumOfQualityLevels = 0
    for i in eachindex(maximumGeodes)
        SumOfQualityLevels += (i * maximumGeodes[i])
    end
    println(SumOfQualityLevels)
end

# Like in Part1, DFS with pruning to obtain maximum geodes in the time
# and then multiply those numbers.
function Part2()
    # maximum geodes obtainable in 32 time with top 3 blueprints
    maximumGeodes = GetMaximumPossibleGeodes(32, 3)
    println(prod(maximumGeodes))
end

# we get our Blueprints and then DFS for each one of those.
# We also calculate the maximum number of ore,clay and obsidian robots we should build
# as the maximum cost of any robot for that ressource, since if we have any more 
# robots of that type then we produce more ressources than we can spend.
# since at the beginning we can only build ore or clay robots, we make two DFS,
# one with the target being the ore robot and the other being the clay robot first
function GetMaximumPossibleGeodes(rounds::Integer, NrOfBluePrints::Integer)

    blueprints = parseInput()
    blueprints = blueprints[1:min(NrOfBluePrints, end)]
    maximumGeodes = Vector{Integer}()

    for blueprint in blueprints

        # calculating the maximum robots of a specific ressource we should build
        maxOre = 0
        maxClay = 0
        maxObsidian = 0
        for costs in blueprint
            maxOre = max(maxOre, costs.oreCosts)
            maxClay = max(maxClay, costs.clayCosts)
            maxObsidian = max(maxObsidian, costs.obsidianCosts)
        end

        #creating the base setting for our world,
        # first is number of robots, second the maximum, third the ressources currently and fourth the costs
        World = world([1, 0, 0, 0], [maxOre, maxClay, maxObsidian, rounds], [0, 0, 0, 0], blueprint)

        # case1: we want to build an ore robot first
        bestGeodes = DFS(rounds, copyWorld(World), 0, 1)

        # case2: we want to build a clay robot firsts
        bestGeodes = DFS(rounds, copyWorld(World), bestGeodes, 2)
        push!(maximumGeodes, bestGeodes)
    end
    return maximumGeodes
end

# We use DFS while always having a target robot we want to build.
# If we can build that robot, do it and branch for each next robot we could
# and should build.
# Also, an upper bound to the number of geodes we could open on a branch
# is the number of geodes currently, plus the geodes our current robots can open in the remaining time
# plus the number of geodes robots could open, if we build a geode robot every time step 
# the last summand is the time'th triangular number.
# If that theoretical upper bound is already lower than the current found max, we can cut this branch
function DFS(time::Integer, World::world, bestGeodes::Integer, currentTarget::Integer)
    if time == 0
        return max(bestGeodes, World.Ressources[4])
    end

    # testing the theoretical upper bound 
    if World.Ressources[4] + time * World.NumberOfRobots[4] + TriangularNumber(time) ≤ bestGeodes
        return bestGeodes
    end


    if canBuild(World.Blueprints[currentTarget], World)

        # If we can build the target robot, do it and branch for each next possible target
        updateWorld(World)
        Build(World, currentTarget)

        for i in eachindex(World.Blueprints)
            if shouldBuild(i, World)
                bestGeodes = DFS(time - 1, copyWorld(World), bestGeodes, i)
            end
        end
    else
        # otherwise continue until we can build the target
        updateWorld(World)
        bestGeodes = DFS(time - 1, World, bestGeodes, currentTarget)
    end

    return bestGeodes
end

# since Julia is pass by reference,
# we need to copy the world to let each dfs branch have its seperate version.
function copyWorld(World::world)
    return world(copy(World.NumberOfRobots), World.maximumRobots, copy(World.Ressources), World.Blueprints)
end

# helper function to determine if we should build a specific robot.
# we should only build an obsidian robot if we have a clay robot
# and should only build a geode robot if we have an obsidian robot.
# also, build only as much robots of one type as the amount of that ressource we can spend per time step.
function shouldBuild(target::Integer, World::world)
    if target == 2 && World.NumberOfRobots[1] == 0
        return false
    elseif target == 3 && World.NumberOfRobots[2] == 0
        return false
    end

    if World.NumberOfRobots[target] ≥ World.maximumRobots[target]
        return false
    end

    return true
end

# helper function to determine if we can build a robot,
# i.e. if we have enough ressources for it
function canBuild(costs::RobotBlueprint, World::world)
    enoughOre = costs.oreCosts ≤ World.Ressources[1]
    enoughClay = costs.clayCosts ≤ World.Ressources[2]
    enoughObsidian = costs.obsidianCosts ≤ World.Ressources[3]
    return enoughOre && enoughClay && enoughObsidian
end

# we subtract the costs of a specific robot and then build that one
function Build(World::world, target::Integer)
    World.Ressources[1] += -World.Blueprints[target].oreCosts
    World.Ressources[2] += -World.Blueprints[target].clayCosts
    World.Ressources[3] += -World.Blueprints[target].obsidianCosts
    World.NumberOfRobots[target] += 1
end

# this updates the world one time step,
# i.e. each robot produces one of its ressource
function updateWorld(World::world)
    for i in eachindex(World.Ressources)
        World.Ressources[i] += World.NumberOfRobots[i]
    end
end

# Helper function to get the n'th triagnular number
function TriangularNumber(n::Integer)
    return div(n * (n - 1), 2)
end