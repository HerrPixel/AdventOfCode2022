# Answer to Puzzle 1 is getSumOfSignalStrength()
# Answer to Puzzle 2 is getCRTOutput() Attention: This is a picture!

# Both puzzles use the same logic for reading lines, 
# we just pass a puzzle specific function to the input parser
# that needs to be checked every cycle.
function getSumOfSignalStrength()
    sumOfImportantSignals = 0

    sumOfImportantSignals = parseInput(cycleCheck, sumOfImportantSignals)
    println(sumOfImportantSignals)
end

# Both puzzles use the same logic for reading lines, 
# we just pass a puzzle specific function to the input parser
# that needs to be checked every cycle.
function getCRTOutput()
    screen = falses(40, 6)

    screen = parseInput(pixelCheck, screen)
    drawPicture(screen)
end

# This just parses the input and updates the register and cycles accordingly.
# You can parse a function and an additional argument to this 
# that gets updated every cycle
function parseInput(applyEachCycle::Function, additionalArgument)
    currRegister = 1
    currCycle = 1

    # since the cycles are not counted by the line number but seperately,
    # we can just simulate the next step when we read an add operation
    # and then update the cycle by 2 after that
    for line in eachline("./Day10/input.txt")

        # we apply this function on every cycle
        additionalArgument = applyEachCycle(currCycle, currRegister, additionalArgument)

        # if we read an add operation, we simulate the cycle after that 
        # by passing the cycle number + 1 to the function and then 
        # update the cycle number by 2 and update the register after that.
        if line[1] == 'a'
            value = parse(Int, split(line, " ")[2])

            # simulation of the next cycle by passing the cycle number from the future
            additionalArgument = applyEachCycle(currCycle + 1, currRegister, additionalArgument)

            # now we can skip ahead one step
            currRegister += value
            currCycle += 1
        end
        currCycle += 1
    end

    return additionalArgument
end

# This just checks if the cycle is at one of the important points
# and updates the signal sum if it is necessary
function cycleCheck(cycle::Integer, registervalue::Integer, sumOfImportantSignals)
    if cycle ∈ Set([20, 60, 100, 140, 180, 220])
        sumOfImportantSignals += (cycle * registervalue)
    end
    return sumOfImportantSignals
end

# this checks if the register and the horizontal position of the CRT match
# and draws a pixel accordingly
function pixelCheck(cycle::Integer, registervalue::Integer, screen::BitMatrix)
    cycle += -1

    # we can get the horizontal position of the CRT with this operation
    horizontalPosition = mod(cycle, 40)

    # the sprite extends one pixel in each direction so we check all occupied spaces
    if horizontalPosition ∈ Set([registervalue - 1, registervalue, registervalue + 1])

        # should we hit it, we get the position of the CRT by division and remainder with 40
        index = divrem(cycle, 40)
        
        # Careful, Julia starts its indices with 1!
        screen[index[2]+1, index[1]+1] = true
    end
    return screen
end

# Just a drawing function for the screen
function drawPicture(screen::BitMatrix)
    for i in axes(screen, 2)
        for j in axes(screen, 1)
            if screen[j, i] == true
                print("█")
            else
                print(" ")
            end
        end
        println("")
    end
end