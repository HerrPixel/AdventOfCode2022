struct Robot
    oreCosts::Integer
    clayCosts::Integer
    obsidianCosts::Integer

    function Robot(oreCosts::Integer, clayCosts::Integer, obsidianCosts::Integer)
        return new(oreCosts,clayCosts,obsidianCosts)
    end
end

using DataStructures

function parseInput()
    blueprints = Vector{Vector{Robot}}()

    for line in eachline("./Day19/betterinput.txt")
        words = split(line," ")
        costs = Vector{Robot}()
        r1 = Robot(parse(Int,words[7]),0,0)
        push!(costs,r1)
        r2 = Robot(parse(Int,words[13]),0,0)
        push!(costs,r2)
        r3 = Robot(parse(Int,words[19]),parse(Int,words[22]),0)
        push!(costs,r3)
        r4 = Robot(parse(Int,words[28]),0,parse(Int,words[31]))
        push!(costs,r4)
        push!(blueprints,costs)
    end

    return blueprints
end

function maximumGeodes()

    blueprints = parseInput()
    QualityLevel = 1

    for b in eachindex(blueprints)
        maxOre = 0
        maxClay = 0
        maxObsidian = 0
        for c in blueprints[b]
            maxOre = max(maxOre,c.oreCosts)
            maxClay = max(maxClay,c.clayCosts)
            maxObsidian = max(maxObsidian,c.obsidianCosts)
        end
        bestGeodes = DFS(32,1,0,0,0,0,0,0,0,0,blueprints[b],maxOre,maxClay,maxObsidian)
        #QualityLevel += b * bestGeodes
        QualityLevel *= bestGeodes
        println("finished ", b)
    end
    println(QualityLevel)
end

    
function DFS(time::Integer,oreRobo::Integer,clayRobo::Integer,obsiRobo::Integer,geodeRobo::Integer,ore::Integer,clay::Integer,obsidian::Integer,geodes::Integer,currMax::Integer,costs::Vector{Robot},maxOre::Integer,maxClay::Integer,maxObsidian::Integer)
    if time == 0
        println("Hit bottom")
        return max(currMax,geodes)
    end
    if oreRobo > maxOre || clayRobo > maxClay || obsiRobo > maxObsidian
        return max(currMax,geodes)
    end
    if geodes + geodeRobo * time + Dreieckszahl(time) ≤ currMax
        return currMax
    end
    currMax = max(currMax,DFS(time-1,oreRobo,clayRobo,obsiRobo,geodeRobo,ore + oreRobo,clay + clayRobo, obsidian + obsiRobo, geodes + geodeRobo, currMax,costs,maxOre,maxClay,maxObsidian))

    if ore ≥ costs[1].oreCosts
            currMax = max(currMax,DFS(time-1,oreRobo + 1,clayRobo,obsiRobo,geodeRobo,ore + oreRobo - costs[1].oreCosts,clay + clayRobo, obsidian + obsiRobo, geodes + geodeRobo, currMax,costs,maxOre,maxClay,maxObsidian))
    end
    if ore ≥ costs[2].oreCosts
            currMax = max(currMax,DFS(time-1,oreRobo,clayRobo + 1,obsiRobo,geodeRobo,ore + oreRobo - costs[2].oreCosts,clay + clayRobo, obsidian + obsiRobo, geodes + geodeRobo, currMax,costs,maxOre,maxClay,maxObsidian))
    end
    if ore ≥ costs[3].oreCosts && clay ≥ costs[3].clayCosts
            currMax = max(currMax,DFS(time-1,oreRobo,clayRobo,obsiRobo+1,geodeRobo,ore + oreRobo - costs[3].oreCosts,clay + clayRobo - costs[3].clayCosts, obsidian + obsiRobo, geodes + geodeRobo, currMax,costs,maxOre,maxClay,maxObsidian))
    end
    if ore ≥ costs[4].oreCosts && obsidian ≥ costs[4].obsidianCosts
            currMax = max(currMax,DFS(time-1,oreRobo,clayRobo,obsiRobo,geodeRobo+1,ore + oreRobo - costs[4].oreCosts,clay + clayRobo, obsidian + obsiRobo - costs[4].obsidianCosts, geodes + geodeRobo, currMax,costs,maxOre,maxClay,maxObsidian))
    end
    return currMax
end

function Dreieckszahl(n::Integer)
    return div(n * (n-1),2)
end