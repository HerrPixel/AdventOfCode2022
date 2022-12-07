using DataStructures

function getMarkerPosition(NumberOfSymbolsForMarker::Integer)
    Input = read(open("./Day6/input.txt"), String)
    lastSymbols = Queue{Char}()

    for i in eachindex(Input) 
        enqueue!(lastSymbols, Input[i])
        if length(lastSymbols) == NumberOfSymbolsForMarker
            if allunique(Iterators.Stateful(lastSymbols))
                println(i)
                break
            end
            dequeue!(lastSymbols)
        end 
    end
end