# Solution to Puzzle 1 is Part1()
# Solution to Puzzle 2 is Part2()

# helper struct for each monkey with references to its arguments
# or its number
mutable struct Monkey
    number::Int
    hasNumber::Bool
    operation::Function
    firstMonkey::Monkey
    secondMonkey::Monkey

    function Monkey()
        return new()
    end
end

# resolves this monkeys value
function getValue(m::Monkey)
    if m.hasNumber
        return m.number
    else
        return m.operation(getValue(m.firstMonkey), getValue(m.secondMonkey))
    end
end

# function for part2 that either collects all monkeys needed for the equation
# or solves the monkeys value if it is not part of the equation
function getEquation(x::Monkey, m::Monkey, equation::Vector{Monkey})
    # if we found our variable, return all collected monkeys 
    # in order as our equation
    if m == x
        return equation
    end

    # if this monkey has a value, return a default value to signify this
    if m.hasNumber
        return Vector{Monkey}()
    end

    # else go deeper and solve the two sub monkeys.
    # we also append our monkey as part of the equation.
    # should we not be part of the equation, both sub-monkeys
    # return an empty vector and then we do too, signifying the default value
    push!(equation, m)
    l = getEquation(x, m.firstMonkey, copy(equation))
    r = getEquation(x, m.secondMonkey, copy(equation))

    # if both sub-monkeys are not part of the equation,
    # i.e. their value has been calculated, then we can also calculate
    # this monkeys value.
    if isempty(l) && isempty(r)
        m.hasNumber = true
        m.number = m.operation(m.firstMonkey.number, m.secondMonkey.number)
    end

    # since the equation luckily never loops, 
    # one of those is always empty and we just return the non-empty
    # equation vector
    append!(l, r)
    return l
end

# solves for x when given an equation vector of monkeys
function solveFor(equation::Vector{Monkey}, x::Int)

    # with these lookups we find the inverses of the operations of the equation
    leftInverse = Dict([(+, -), (*, div), (-, (x, y) -> y - x), (div, (x, y) -> div(y, x)), (==, (x, y) -> y)])
    rightInverse = Dict([(+, -), (*, div), (-, +), (div, *), (==, (x, y) -> y)])

    # we first need to determine on which side we need to invert
    # and then apply that operation and go deeper in the equation
    for m in equation
        if m.firstMonkey.hasNumber
            operation = leftInverse[m.operation]
            x = operation(x, m.firstMonkey.number)
        else
            operation = rightInverse[m.operation]
            x = operation(x, m.secondMonkey.number)
        end
    end

    # finally we return our calculated value
    return x
end

# straight-forward, just resolving all monkeys
function Part1()
    names = parseInput()
    println(getValue(names["root"]))
end

# we first parse the monkey-tree, then build our equation and finally solve it.
# For how, see above.
function Part2()
    names = parseInput()
    m = names["root"]
    x = names["humn"]
    equation = getEquation(x, m, Vector{Monkey}())
    m.operation = ==
    x.hasNumber = false
    println(solveFor(equation, 0))
end

# we use a regex to capture the parts that we need and build monkeys out of it.
# each monkey references the monkeys it needs for its values or 
# sets the field "hasNumber" signifying, that it shouts a number.
# Should one referenced monkey not be initialized yet, then we do that on the fly.
function parseInput()
    names = Dict{String,Monkey}()
    functions = Dict([("+", +), ("*", *), ("-", -), ("/", div)])
    regex = r"([a-zA-Z]+): (?:([0-9]+)|([a-zA-Z]+) (\+|\-|\*|\/) ([a-zA-Z]+))"

    for line in eachline("./Day21/input.txt")
        matches = match(regex, line)
        # if our monkey is already initialized, then get it.
        monkey = haskey(names, matches[1]) ? names[matches[1]] : Monkey()

        if !isnothing(matches[2])
            # if it shouts a number
            monkey.number = parse(Int, matches[2])
            monkey.hasNumber = true
        else
            # else, first get the sub-monkeys or initialize them
            m = haskey(names, matches[3]) ? names[matches[3]] : Monkey()
            names[matches[3]] = m
            n = haskey(names, matches[5]) ? names[matches[5]] : Monkey()
            names[matches[5]] = n

            operation = functions[matches[4]]

            # and finally, initlaize our main monkey
            monkey.hasNumber = false
            monkey.operation = operation
            monkey.firstMonkey = m
            monkey.secondMonkey = n
        end

        names[matches[1]] = monkey
    end
    return names
end
