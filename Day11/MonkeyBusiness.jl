using DataStructures

# Solution to Puzzle 1 is getMonkeyBusinessScore(20,divideByThree)
# Solution to Puzzle 2 is getMonkeyBusinessScore(10000,identity)

# We first parse the input, 7 lines at a time, 
# since each Monkey is defined by these 7 lines.
# We then construct a monkey struct for each monkey
# that contains all relevent information.
# Finally we strictly follow the iteration protocol:
# Take an item out of the monkeys queue, apply the function
# and then add the new value to the queue of another monkey,
# depending on the result of the test.
# To keep the Worry levels low, observe that the test
# only relies on divisibility, which is invariant in specific
# residue rings. In this case, we multiply all divisors
# to get a residue ring big enough for our rules to hold but
# not big enough to overflow an Int64

# The Julia function builder or eval world problem is very frustrating.
# I didn't find a better way to do this than have a specific struct for the function.
struct monkeyOperation
    Operation::Function
    leftArgument::Integer
    rightArgument::Integer

    function monkeyOperation(Operation::Function,firstArgument::Integer,secondArgument::Integer)
        return new(Operation,firstArgument,secondArgument)
    end
end

# Here we keep every relevant Information for the monkey.
# Since the items of the monkey and the times it inspected an item change,
# this struct needs to be mutable.
mutable struct monkey
    items::Queue{Integer}
    timesInspected::Integer
    Operation::monkeyOperation
    Test::Function
    MonkeyIfTrue::Integer
    MonkeyIfFalse::Integer

    function monkey(items::Queue{Integer}, timesInspected::Integer, Operation::monkeyOperation, Test::Function, MonkeyIfTrue::Integer, MonkeyIfFalse::Integer)
        return new(items,timesInspected,Operation,Test,MonkeyIfTrue,MonkeyIfFalse)
    end
end

# This applies the specific monkeys operation on an item with the given WorryLevel.
# We implicitly store fixed arguments as numbers in the monkeyOperation struct
# and arguments that are to be replaced with the worryLevel as "-1". 
# This is in no way a good solution but I didn't have a better way.
function ApplyMonkeyOperation(Monkey::monkey, WorryLevel::Integer)
    # We replace a possible "-1" with the argument or keep the fixed given argument
    firstArgument = Monkey.Operation.leftArgument == -1 ? WorryLevel : Monkey.Operation.leftArgument

    # same as above
    secondArgument = Monkey.Operation.rightArgument == -1 ? WorryLevel : Monkey.Operation.rightArgument
    return Monkey.Operation.Operation(firstArgument,secondArgument)
end

# helper function to make the solution to Puzzle 1 more clean
function divideByThree(x::Integer)
    return div(x,3)
end

# helper function to make the solution to Puzzle 2 more clean
function identity(x::Integer)
    return x
end

# The main function that calculates the Monkey business score. 
# You can also supply a function that gets executed after every inspection,
# i.e. the division by 3 like in the first puzzle.
# The logic is straight forward: 
# After parsing, we loop through the monkeys
# and apply the inspection protocol.
# Like mentioned above, we can modulo the Worry levels by a good residue field
# to keep the numbers low enough.
function getMonkeyBusinessScore(rounds::Integer,functionAfterInspecting::Function)

    Monkeys, residueRing = parseInput()
    
    for i in 1:rounds
        for monkey in Monkeys

            while !isempty(monkey.items)

                monkey.timesInspected += 1
                item = dequeue!(monkey.items)
                
                # We apply the specific monkeys Operation and then modulo 
                # with the size of the residue ring to keep the number low
                item = mod(ApplyMonkeyOperation(monkey,item),residueRing)

                # Possible reduction depending on the input.
                # For example, we divide by three in Puzzle 1
                item = functionAfterInspecting(item)
                
                # Protocol for which monkey to throw the item, 
                # depending on divisibility
                if monkey.Test(item)
                    # mind the +1, since monkeys are 0-indexed
                    # but Julia is 1-indexed
                    enqueue!(Monkeys[monkey.MonkeyIfTrue + 1].items, item)
                else
                    enqueue!(Monkeys[monkey.MonkeyIfFalse + 1].items, item)
                end
            end
        end
    end

    # We iterate over all Monkeys to find the two highest Scores
    highestMonkeyScore = 0
    secondHighestMonkeyScore = 0
    for m in Monkeys
        if m.timesInspected > highestMonkeyScore
            secondHighestMonkeyScore = highestMonkeyScore
            highestMonkeyScore = m.timesInspected
        elseif m.timesInspected > secondHighestMonkeyScore
            secondHighestMonkeyScore = m.timesInspected
        end
    end

    # And print out our result
    println(highestMonkeyScore * secondHighestMonkeyScore)
end

# We take 7 lines at a time
# and then parse each line to its relevant information.
# we also calculate the size of the residueRing while parsing the
# division rules and finally return the parsed data.
function parseInput()
    # the list of monkeys and size of residue ring
    Monkeys = Vector{monkey}()
    residueRing = 1

    lines = Iterators.Stateful(eachline("./Day11/input.txt"))

    while !isempty(lines)
        LinesOfCurrentMonkey = collect(Iterators.take(lines,7))

        # the monkey name is not relevant to us, so line 1 gets skipped

        items = getItems(LinesOfCurrentMonkey[2])
        operation = getOperation(LinesOfCurrentMonkey[3])
        divisionNumber = getDivisionNumber(LinesOfCurrentMonkey[4])

        # we manually construct the function for the test
        # as an anonymous function 
        test = x -> 0 == mod(x,divisionNumber)
        residueRing *= divisionNumber

        MonkeyIfTrue = getMonkeyNumber(LinesOfCurrentMonkey[5])
        MonkeyIfFalse = getMonkeyNumber(LinesOfCurrentMonkey[6])
        
        push!(Monkeys,monkey(items,0,operation,test,MonkeyIfTrue,MonkeyIfFalse))

        # line 7 is empty, so we also skip that.
    end
    return Monkeys, residueRing
end

# We use a regex to extract the item string
# and then split it at each item
# and parse them to integers
# to be added to the monkeys item item list.
function getItems(s::String)

    numbers = "[1-9][0-9]*"
    regex = Regex("  Starting items: ((?:$numbers, )*$numbers)")

    itemList = split(match(regex,s)[1], ", ")

    items = Queue{Integer}()
    for item in itemList
        enqueue!(items,parse(Int,item))
    end

    return items
end

# By assuming you only get the 4 main arithmetic operations,
# we first get the operation by looking up the string in a dictionary
# and then parse the arguments and either set them or supply "-1"
# as a fallback for the argument to be replaced with the
# supplied worry level
function getOperation(s::String)

    functions = Dict([("*",*),("+",+),("-",-),("/",div)])

    s = replace(s,"  Operation: new = " => "")
    words = split(s," ")

    argument1 = words[1] == "old" ? -1 : parse(Int,words[1])

    operation = functions[words[2]]

    argument2 = words[3] == "old" ? -1 : parse(Int,words[3])

    monkeyOp = monkeyOperation(operation,argument1,argument2)
    return monkeyOp
end

# By deleting the text of the string,
# we extract the number by which to divide
function getDivisionNumber(s::String)
    s = replace(s, "  Test: divisible by " => "")
    return parse(Int,s)
end

# We use a regex to catch the number of the monkey
# to which the items should be thrown.
function getMonkeyNumber(s::String)
    numbers = "[0-9]*"
    regex = Regex("    If (?:true|false): throw to monkey ($numbers)")
    return parse(Int,match(regex,s)[1])
end