using DataStructures

# Answer to Puzzle 1 is CratesOnTop(false)
# Answer to Puzzle 2 is CratesOnTop(true)

# We iterate through the lines of the input file
# first parsing the initial setup as a stack and then 
# sequentially execute each moving instruction 
# as poping and pushing some boxes from some stack to some other stack
# Finally we pop the top element of each stack and concatenate
# them to get our final answer
function CratesOnTop(TakeMultiple::Bool=false)
    
    # Stateful iterator so that we keep the state between function calls
    lines = Iterators.Stateful(eachline("./Day5/input.txt"))

    # parse the initial configuration
    Supplies = GetInitialSupplies(lines)
    
    while !isempty(lines)

        # Parsing an instruction line is easy, since the numbers
        # are always at the same position
        currInstruction = split(popfirst!(lines), " ")
        cratesToMove = parse(Int64,currInstruction[2])
        from = parse(Int64,currInstruction[4])
        to = parse(Int64,currInstruction[6])

        # This is the difference between puzzle 1 and 2,
        # taking multiple each instruction or moving them sequentially
        if TakeMultiple
            Supplies = move9001(Supplies,cratesToMove,from,to)
        else
            Supplies = move9000(Supplies,cratesToMove,from,to)
        end
    end

    # Finally building the result string
    finalConfiguration = ""
    for i in eachindex(Supplies) 
        finalConfiguration *= pop!(Supplies[i])
    end
    println(finalConfiguration)
end

function move9000(Supplies::Vector{Stack{Char}}, NoOfCrates::Integer,from::Integer, to::Integer)
    # Just sequentially pop from one stack and move to the other
    for i in 1:NoOfCrates
        push!(Supplies[to],pop!(Supplies[from]))
    end
    return Supplies
end

function move9001(Supplies::Vector{Stack{Char}}, NoOfCrates::Integer, from::Integer, to::Integer)
    # Since we reverse the ordering of the boxes if we pop them sequentially,
    # we need to store them elsewhere temporarily and then
    # reverse this ordering again to correctly move them
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

    # Carefully counting the spaces results in an
    # easy indexing of the box contents
    NoOfStacks = Int((length(input) + 1)/4)

    # Initialization of the stacks
    for i in 1:NoOfStacks
        push!(Supplies,Stack{Char}())
    end

    # an empty line is the dividor between initial state and instructions
    while input ≠ ""

        # true if we are in the numbering of the stacks
        # but this does not matter for us and we skip this line
        if input[2] == "1"
            input = popfirst!(lines)
            continue
        end

        for i in 1:NoOfStacks
            # as long as each box only contains a char,
            # each content char sits on a fixed position
            c = input[2+(i-1)*4]

            # if the stack is not high enough,
            # the position would be empty and we skip this
            if c == ' '
                continue
            end
            push!(Supplies[i],c)
        end
        input = popfirst!(lines)
    end

    # Finally since we push on the stack from top to bottom
    # i.e. in the reverse order, we need to reverse this by
    # poping and pushing onto fresh stacks
    InitialSupplies = Vector{Stack{Char}}()
    for i in 1:NoOfStacks
        push!(InitialSupplies,Stack{Char}())
        for j in 1:length(Supplies[i])
            push!(InitialSupplies[i],pop!(Supplies[i]))
        end
    end

    return InitialSupplies
end