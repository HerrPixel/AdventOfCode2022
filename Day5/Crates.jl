using DataStructures

function CratesOnTop()
    
    lines = Iterators.Stateful(eachline("./Day5/input.txt"))
    State = GetInitialState(lines)
    
    println("returned")
    while !isempty(lines)
        line = popfirst!(lines)
        words = split(line, " ")
        howMany = parse(Int64,words[2])
        from = parse(Int64,words[4])
        to = parse(Int64,words[6])
        println("I want to move ", howMany, " Crates from ", from, " to ", to)
        temp = Stack{Char}()
        for i in 1:howMany
            push!(temp,pop!(State[from]))
            for j in 1:length(temp) 
                
            end
        end
        for j in 1:length(temp) 
            push!(State[to],pop!(temp))    
        end
    end
    finalConfig = ""
    for i in eachindex(State) 
        println(State[i])
        finalConfig *= pop!(State[i])
    end
    println(finalConfig)
end

function GetInitialState(lines::Base.Iterators.Stateful)
    s = Vector{Stack{Char}}()
    line = popfirst!(lines)
    NoOfStacks = Int((length(line) + 1)/4)
    println(NoOfStacks)

    for i in 1:NoOfStacks
        push!(s,Stack{Char}())
    end

    while line ≠ ""
        println("We have line ", line, " and the second char is ", line[2])
        if line[2] == "1"
            line = popfirst!(lines)
            continue
        end
        for i in 1:NoOfStacks
            c = line[2+(i-1)*4]
            if c == ' '
                continue
            end
            push!(s[i],c)
        end
        line = popfirst!(lines)
    end

    InitialState = Vector{Stack{Char}}()
    for i in 1:NoOfStacks
        push!(InitialState,Stack{Char}())
        for j in 1:length(s[i])
            push!(InitialState[i],pop!(s[i]))
        end
        println(InitialState[i])
    end

    return InitialState
end
    
