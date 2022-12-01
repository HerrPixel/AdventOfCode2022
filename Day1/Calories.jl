using DataStructures

# Answer to Puzzle 1 is CaloriesOfTopElves(1)
# Answer to Puzzle 2 is CaloriesOfTopElves(3)
function CaloriesOfTopElves(NrOfTopElves::Integer=1)
    CalorieHeap = BinaryMinHeap{Int}(zeros(NrOfTopElves))
    currCalories = 0

    for line in eachline("./Day1/input.txt")
        if line == ""
            push!(CalorieHeap, currCalories)
            pop!(CalorieHeap)
            currCalories = 0
            continue
        end
    currCalories += parse(Int64, line)
    end
    println(sum(extract_all!(CalorieHeap)))
end