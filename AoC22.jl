Puzzles = [
    ("Day 1: Calorie Counting", "Day1/Calories.jl", "CaloriesOfTopElves(1)", "CaloriesOfTopElves(3)"),
    ("Day 2: Rock Paper Scissors", "Day2/RockPaperScissors.jl", "ScoreOfStrategyOne()", "ScoreOfStrategyTwo()"),
    ("Day 3: Rucksack Reorganization", "Day3/Rucksack.jl", "GetPriorityOfWrongItems()", "GetPriorityOfBadges()"),
    ("Day 4: Camp Cleanup", "Day4/Cleaning.jl", "DominatingSections()", "OverlappingSections()"),
    ("Day 5: Supply Stacks", "Day5/Crates.jl", "CratesOnTop(false)", "CratesOnTop(true)"),
    ("Day 6: Tuning Trouble", "Day6/Signals.jl", "getMarkerPosition(4)", "getMarkerPosition(14)"),
    ("Day 7: No Space Left On Device", "Day7/Directories.jl", "getSizesBelowThreshold(100000)", "makeEnoughSpace(30000000,70000000)"),
    ("Day 8: Treetop Tree House", "Day8/TreeHouse.jl", "visibleTrees()", "scenicScore()"),
    ("Day 9: Rope Bridge", "Day9/Ropes.jl", "moveRopes(2)", "moveRopes(10)"),
    ("Day 10: Cathode-Ray Tube", "Day10/Registers.jl", "getSumOfSignalStrength()", "(println(), getCRTOutput())"),
    ("Day 11: Monkey in the Middle", "Day11/MonkeyBusiness.jl", "getMonkeyBusinessScore(20,divideByThree)", "getMonkeyBusinessScore(10000,identity)"),
    ("Day 12: Hill Climbing Algorithm", "Day12/Mountain.jl", "getDistanceToGoal()", "getDistanceOfHikingTrail()"),
    ("Day 13: Distress Signal", "Day13/DistressSignal.jl", "getPackageOrderNumber()", "GetDecoderKey()"),
    ("Day 14: Regolith Reservoir", "Day14/FallingSand.jl", "simulateSand(true)", "simulateSand(false)"),
    ("Day 15: Beacon Exclusion Zone", "Day15/Beacons.jl", "calculateEmptySpots(2000000)", "calculateDistressBeaconSpot(4000000)"),
    ("Day 16: Proboscidea Volcanium", "Day16/Pressure.jl", "releaseMaximumPressureAlone()", "releaseMaximumPressureWithElephant()"),
    ("Day 17: Pyroclastic Flow", "Day17/Rocks.jl", "simulateRocks(2022)", "simulateRocks(1000000000000)"),
    ("Day 18: Boiling Boulders", "Day18/Cubes.jl", "countAllSurface()", "countExteriorSurface()"),
    ("Day 19: Not Enough Minerals", "Day19/Robots.jl", "Part1()", "Part2()"),
    ("Day 20: Grove Positioning System", "Day20/Encryption.jl", "Part1()", "Part2()"),
    ("Day 21: Monkey Math", "Day21/MonkeyRiddle.jl", "Part1()", "Part2()"),
    ("Day 22: Monkey Map", "Day22/MonkeyMap.jl", "Part1()", "Part2()"),
    ("Day 23: Unstable Diffusion", "Day23/SpreadingElves.jl", "Part1()", "Part2()"),
    ("Day 24: Blizzard Basin", "Day24/Blizzard.jl", "Part1()", "Part2()"),
    ("Day 25: Full of Hot Air", "Day25/Fuel.jl", "Part1()", "println('-')")
]

function run()
    for (name, file, part1Call, part2Call) in Puzzles
        let
            include(file)
            println(name)
            print("   Part1: ")
            part1Time = eval(Meta.parse("@elapsed " * part1Call))
            println("   Took $(round(part1Time * 1000, digits=2)) miliseconds")
            print("   Part2: ")
            part2Time = eval(Meta.parse("@elapsed " * part2Call))
            println("   Took $(round(part2Time * 1000, digits=2)) miliseconds")
            println()
        end
    end
end
