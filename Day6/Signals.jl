using DataStructures

# Answer to puzzle 1 is getMarkerPosition(4)
# Answer to puzzle 2 is getMarkerPosition(14)

# We save our current trail of characters in a queue of the wanted size
# and for each new symbol, we trash the oldest symbol and push the new one.
# We then check if the queue has only unique chars
# if not, we go to the next step, otherwise we have found our answer.
function getMarkerPosition(NumberOfSymbolsForMarker::Integer)
    Input = read(open("./Day6/input.txt"), String)

    # Here we store our current trail of the last Symbols read
    lastSymbols = Queue{Char}()

    # for each char
    for i in eachindex(Input) 

        # we push the new char
        enqueue!(lastSymbols, Input[i])
        
        # check if we are big enough, i.e. not at the beginning
        if length(lastSymbols) == NumberOfSymbolsForMarker

            # check if we have  a valid answer
            if allunique(Iterators.Stateful(lastSymbols))
                println(i)
                break
            end

            # otherwise, trash the oldest symbol
            dequeue!(lastSymbols)
        end 
    end
end