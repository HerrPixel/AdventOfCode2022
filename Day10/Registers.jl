
function getSumOfSignalStrength()
    currRegister = 1
    currCycle = 1
    sumOfImportantSignals = 0

    for line in eachline("./Day10/input.txt")
        if currCycle ∈ Set([20,60,100,140,180,220])
            sumOfImportantSignals += (currCycle * currRegister)
        end
        if line[1] == 'a'
            value = parse(Int,split(line," ")[2])
            if currCycle + 1 ∈ Set([20,60,100,140,180,220])
                sumOfImportantSignals += ( (currCycle + 1) * currRegister)
            end
            currRegister += value
            currCycle += 2
        else
            currCycle += 1
        end
    end

    println(sumOfImportantSignals)
end

function getCRTOutput()
    screen = falses(40,6)

    currRegister = 1
    currScreenPosition = 0

    for line in eachline("./Day10/input.txt")
        screen = checkToDrawPixel(currRegister,currScreenPosition,screen)
        if line[1] == 'a'
            value = parse(Int,split(line," ")[2])
            screen = checkToDrawPixel(currRegister, currScreenPosition + 1, screen)
            currRegister += value
            currScreenPosition += 1
        end
        currScreenPosition += 1
    end
    drawPicture(screen)
end

function checkToDrawPixel(currRegister::Integer, currScreenPosition::Integer,screen::BitMatrix)
    horizontalPosition = mod(currScreenPosition,40)
    if horizontalPosition ∈ Set([currRegister-1 , currRegister, currRegister+1])
        index = divrem(currScreenPosition, 40)
        screen[index[2] + 1, index[1] + 1] = true
    end
    return screen
end

function drawPicture(screen::BitMatrix)
    for i in 1:size(screen,2)
        for j in 1:size(screen,1)
            if screen[j,i] == true
                print("#")
            else
                print(" ")
            end
        end
        println("")
    end
end