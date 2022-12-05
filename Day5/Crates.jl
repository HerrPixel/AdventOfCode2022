using DataStructures


function CratesOnTop(TakeMultiple::Bool=false)
    
    lines = Iterators.Stateful(eachline("./Day5/input.txt"))
    Supplies = GetInitialSupplies(lines)
    
    while !isempty(lines)
        currInstruction = split(popfirst!(lines), " ")
        cratesToMove = parse(Int64,currInstruction[2])
        from = parse(Int64,currInstruction[4])
        to = parse(Int64,currInstruction[6])

        if TakeMultiple
            Supplies = move9001(Supplies,cratesToMove,from,to)
        else
            Supplies = move9000(Supplies,cratesToMove,from,to)
        end
    end

    finalConfiguration = ""
    for i in eachindex(Supplies) 
        finalConfiguration *= pop!(Supplies[i])
    end
    println(finalConfiguration)
end

function move9000(Supplies::Vector{Stack{Char}}, NoOfCrates::Integer, from::Integer, to::Integer)
    for i in 1:NoOfCrates
        push!(Supplies[to],pop!(Supplies[from]))
    end
    return Supplies
end

function move9001(Supplies::Vector{Stack{Char}}, NoOfCrates::Integer, from::Integer, to::Integer)
    temporaryStack = Stack{Char}()
    for i in 1:NoOfCrates
        push!(temporaryStack,pop!(Supplies[from]))
    end
    for j in 1:NoOfCrates
        push!(Supplies[to],pop!(temporaryStack))
    end
    return Supplies
end

function GetInitialSupplies(lines::Base.Iterators.Stateful)
    Supplies = Vector{Stack{Char}}()
    input = popfirst!(lines)
    NoOfStacks = Int((length(input) + 1)/4)

    for i in 1:NoOfStacks
        push!(Supplies,Stack{Char}())
    end

    while input ≠ ""
        if input[2] == "1"
            input = popfirst!(lines)
            continue
        end
        for i in 1:NoOfStacks
            c = input[2+(i-1)*4]
            if c == ' '
                continue
            end
            push!(Supplies[i],c)
        end
        input = popfirst!(lines)
    end

    InitialSupplies = Vector{Stack{Char}}()
    for i in 1:NoOfStacks
        push!(InitialSupplies,Stack{Char}())
        for j in 1:length(Supplies[i])
            push!(InitialSupplies[i],pop!(Supplies[i]))
        end
    end

    return InitialSupplies
end