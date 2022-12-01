using DataStructures

# Answer to Puzzle 1 is CaloriesOfTopElves(1)
# Answer to Puzzle 2 is CaloriesOfTopElves(3)

# We iterate over the lines of input and sum up consecutive number lines.
# When reading an empty line, we instead push the value to a minHeap and pop the lowest value,
# therefore only keeping the top #NrOfTopElves values
# Lastly when we finished reading the input, we output the sum of all remaining values in the heap.
function CaloriesOfTopElves(NrOfTopElves::Integer=1)
    CalorieHeap = BinaryMinHeap{Int}(zeros(NrOfTopElves))
    currCalories = 0

    for line in eachline("./Day1/input.txt")
        if line == ""
            push!(CalorieHeap, currCalories)
            pop!(CalorieHeap)
            currCalories = 0
        else
            currCalories += parse(Int64, line)
        end
    end
    println(sum(extract_all!(CalorieHeap)))
end