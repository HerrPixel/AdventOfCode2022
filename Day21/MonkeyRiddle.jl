mutable struct Monkey
    number::Integer
    operation::Function
    firstArgument::String
    secondArgument::String
    firstMonkey::Monkey
    secondMonkey::Monkey
    function Monkey(operation::Function,firstArgument::AbstractString,secondArgument::AbstractString)
        return new(-1,operation,firstArgument,secondArgument)
    end

    function Monkey(number::Integer)
        return new(number)
    end
end

function setMonkeys(target::Monkey, m::Monkey, n::Monkey)
    target.firstMonkey = m
    target.secondMonkey = n
end

function getValue(m::Monkey)
    if m.number != -1
        return m.number
    else
        return m.operation(getValue(m.firstMonkey),getValue(m.secondMonkey))
    end
end

function evaluate(m::Monkey)
    if m.number < -1
        return nothing
    end
    if m.number > -1
        return m.number
    else
        first = evaluate(m.firstMonkey)
        second = evaluate(m.secondMonkey)
        if isnothing(first)
            m.firstMonkey.number = min(-2,m.firstMonkey.number)
            m.secondMonkey.number = second
            return nothing
        elseif isnothing(second)
            m.secondMonkey.number = min(-2,m.secondMonkey.number)
            m.firstMonkey.number = first
            return nothing
        else
            #println(first, " and ", second)
            m.number = m.operation(first,second)
            return m.number
        end
    end
end

function resolve(m::Monkey,n::Integer)
    if m.number == -3
        println(n)
        return
    end
    #println(m)
    if m.operation == +
        if m.firstMonkey.number < -1
            return resolve(m.firstMonkey,n - m.secondMonkey.number)
        else
            return resolve(m.secondMonkey,n - m.firstMonkey.number)
        end
    elseif m.operation == -
        if m.firstMonkey.number < -1
            return resolve(m.firstMonkey, n + m.secondMonkey.number)
        else
            return resolve(m.secondMonkey,m.firstMonkey.number - n)
        end
    elseif m.operation == *
        if m.firstMonkey.number < -1
            return resolve(m.firstMonkey, div(n,m.secondMonkey.number))
        else
            return resolve(m.secondMonkey,div(n,m.firstMonkey.number))
        end
    elseif m.operation == div
        if m.firstMonkey.number < -1
            return resolve(m.firstMonkey,n * m.secondMonkey.number)
        else
            return resolve(m.secondMonkey,div(m.firstMonkey.number,n))
        end
    end
end

function parseInput()
    names = Dict{String,Monkey}()
    functions = Dict([("+",+),("*",*),("-",-),("/",div)])
    for line in eachline("./Day21/input.txt")
        words = split(replace(line, ":" => "")," ")
        if words[1] == "humn"
            m = Monkey(-3)
            names["humn"] = m
            continue
        end
        if length(words) == 2
            number = parse(Int,words[2])
            m = Monkey(number)
            names[words[1]] = m
        else
            operation = functions[words[3]]
            m = Monkey(operation,words[2],words[4])
            names[words[1]] = m
        end
    end

    for (name,monkey) in names
        if monkey.number == -1
            m = names[monkey.firstArgument]
            n = names[monkey.secondArgument]
            setMonkeys(monkey,m,n)
        end
    end

    return names
end

function getAnswer()
    names = parseInput()
    println(getValue(names["root"]))
end

function getAnswer2()
    names = parseInput()
    m = names["root"]
    evaluate(m)
    if m.firstMonkey.number < -1
        resolve(m.firstMonkey,m.secondMonkey.number)
    else
        resolve(m.secondMonkey,m.firstMonkey.number)
    end
end