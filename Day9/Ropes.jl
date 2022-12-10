# Answer to puzzle 1 is moveRopes(2)
# Answer to puzzle 2 is moveRopes(10)

# We keep a vector of all parts of the rope
# and for each line of the input, we move the head of the rope
# one step at a time and update the rest of the rope sequentially
# each section being the head for the next section.
# Finally we store each visited position of the Tail of the rope and
# give out the number of those visited locations at the end.
function moveRopes(NrOfSections::Integer)

    # nested function to avoid code bloating
    # this moves the head of the rope one step at a timeand then iterates
    # through the rest of the rope and updates each section
    function move(step::Integer,howOftenHorizontal::Integer, howOftenVertical::Integer)
        for i in 1:howOftenHorizontal
            x = ropes[1].first
            y = ropes[1].second
            ropes[1] = Pair(x + step, y)
            for j in 2:NrOfSections
                # each section is the head for the next section
                ropes[j] = Follow(ropes[j-1],ropes[j])
            end
            # this stores all visited Locations of the tail
            push!(visitedSpaces, ropes[NrOfSections])
        end
        for i in 1:howOftenVertical
            x = ropes[1].first
            y = ropes[1].second
            ropes[1] = Pair(x, y + step)
            for j in 2:NrOfSections
                # each section is the head for the next section
                ropes[j] = Follow(ropes[j-1],ropes[j])
            end
            # this stores all visited Locations of the tail
            push!(visitedSpaces, ropes[NrOfSections])
        end
    end

    # nested function to avoid code bloating
    # this lets a section of the rope follow its respective head
    # and returns its updated position
    function Follow(Head::Pair{Integer,Integer}, Tail::Pair{Integer,Integer})
        headX = Head.first
        headY = Head.second
        tailX = Tail.first
        tailY = Tail.second
        # if the two parts are more than 2 spaces away in any direction,
        # we move the tail by one step at a time for each 
        # dimension where they are not "aligned" 
        if abs(tailX - headX) > 1 || abs(tailY - headY) > 1
            tailX += sign(headX - tailX)
            tailY += sign(headY- tailY)
        end
        return Pair(tailX,tailY)
    end

    # Initialization of variables
    visitedSpaces = Set{Pair{Integer,Integer}}()
    push!(visitedSpaces, Pair(0, 0))
    ropes = Vector{Pair{Integer,Integer}}()
    for i in 1:NrOfSections
        push!(ropes, Pair(0, 0))
    end

    # and simple parsing
    for line in eachline("./Day9/input.txt")
        words = split(line, " ")
        if words[1] == "R"
            move(1,parse(Int,words[2]),0)
        elseif words[1] == "L"
            move(-1,parse(Int,words[2]),0)
        elseif words[1] == "U"
            move(1,0,parse(Int,words[2]))
        elseif words[1] == "D"
            move(-1,0,parse(Int,words[2]))
        end
    end
    println(length(visitedSpaces))
end