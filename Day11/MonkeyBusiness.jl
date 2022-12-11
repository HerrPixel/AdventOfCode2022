using DataStructures

mutable struct monkey
    items::Queue{Integer}
    timesInspected::Integer
    Operation::Function
    Test::Function
    trueMonkey::Integer
    falseMonkey::Integer

    function monkey(items::Queue{Integer}, timesInspected::Integer, Operation::Function, Test::Function, trueMonkey::Integer, falseMonkey::Integer)
        return new(items,timesInspected,Operation,Test,trueMonkey,falseMonkey)
    end
end


function getMonkeyBusinessScore(rounds::Integer)
    Monkeys, maxWorry = parseInput()
    
    for i in 1:rounds
        for m in Monkeys
            while !isempty(m.items)
                m.timesInspected += 1
                item = dequeue!(m.items)
                item = mod(m.Operation(item),maxWorry)
                if m.Test(item)
                    enqueue!(Monkeys[m.trueMonkey + 1].items, item)
                else
                    enqueue!(Monkeys[m.falseMonkey + 1].items, item)
                end
            end
        end
    end

    m1 = 0
    m2 = 0
    for m in Monkeys
        #println(m.items)
        if m.timesInspected > m1
            m2 = m1
            m1 = m.timesInspected
        elseif m.timesInspected > m2
            m2 = m.timesInspected
        end
    end

    println(m1 * m2)
end

function parseInput()
    Monkeys = Vector{monkey}()
    maxWorry = 1

    lines =  Iterators.Stateful(eachline("./Day11/input.txt"))

    while !isempty(lines)
        currMonkey = collect(Iterators.take(lines,7))

        itemString = split(replace(currMonkey[2],"  Starting items: " => ""),", ")
        items = Queue{Integer}()
        for i in itemString
            enqueue!(items,parse(Int,i))
        end

        functionString = split(replace(currMonkey[3], "  Operation: new = " => "")," ")
        op = recognizeFunction(functionString[2])

        arg1 = recognizeArgument(functionString[1])
        arg2 = recognizeArgument(functionString[3])

        Operation = x -> op(isnothing(arg1) ? x : arg1, isnothing(arg2) ? x : arg2)

        testString = replace(currMonkey[4], "  Test: divisible by " => "")
        Test = x -> mod(x,parse(Int,testString)) == 0

        maxWorry *= parse(Int,testString)

        trueMonkey = parse(Int, replace(currMonkey[5], "    If true: throw to monkey " => ""))

        falseMonkey = parse(Int, replace(currMonkey[6], "    If false: throw to monkey " => ""))
        
        push!(Monkeys,monkey(items,0,Operation,Test,trueMonkey,falseMonkey))
    end
    return Monkeys, maxWorry
end

function recognizeFunction(s::AbstractString)
    if s == "*"
        return *
    elseif s == "+"
        return +
    elseif s == "-"
        return -
    elseif s == "/"
        return /
    end
end

function recognizeArgument(s::AbstractString)
    if s == "old"
        return
    else
        return parse(Int,s)
    end
end