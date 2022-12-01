
function calculateCalories()
    maxCalories = 0
    currCalories = 0

    for line in eachline("input.txt")
        if line == ""
            maxCalories = max(maxCalories,currCalories)
            currCalories = 0
            continue
        end

    currCalories += parse(Int64, line)
    end
    println(maxCalories)
end

function calculateTop3Calories()
    maxCalories1 = 0
    maxCalories2 = 0
    maxCalories3 = 0
    currCalories = 0

    for line in eachline("input.txt")
        if line == ""
            if currCalories > maxCalories3
                if currCalories > maxCalories2
                    if currCalories > maxCalories1
                        maxCalories3 = maxCalories2
                        maxCalories2 = maxCalories1
                        maxCalories1 = currCalories
                    else
                        maxCalories3 = maxCalories2
                        maxCalories2 = currCalories
                    end
                else
                    maxCalories3 = currCalories
                end
                
            end
            currCalories = 0
            continue
        end

    currCalories += parse(Int64, line)
    end
    println(maxCalories1 + maxCalories2 + maxCalories3)
end


