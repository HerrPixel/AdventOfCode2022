# Solution to Puzzle 1 is getPackageOrderNumber()
# Solution to Puzzle 2 is GetDecoderKey()

# We first parse each line and then compare two at a time.
# Via Julias Multiple Dispatch, the compare function
# best suited to the current arguments is chosen.
# If we couldn't reach a decision at this comparison,
# we return nothing and let the next step handle the result.
function getPackageOrderNumber()

    PackageOrderNumber = 0
    lists = parseInput()

    # taking input in pairs of two and then comparing them
    for i in 1:div(length(lists),2)
        if compare(lists[2 * i - 1],lists[2 * i])
            PackageOrderNumber += i
        end
    end

    println(PackageOrderNumber)
end

# We also parse the lines first and then add our two specia packages.
# We then sort the list and search for the indices of the packages.
# We could also just count the items lower then our packages
# for a better performance but we are quick enough already.
function GetDecoderKey()
    lists = parseInput()
    push!(lists,eval(Meta.parse("[[2]]")))
    push!(lists,eval(Meta.parse("[[6]]")))

    # We could just find out the number
    # of packages lower than our special ones,
    # to get their indices but we leave that as
    # an exercise to the reader ;)
    sort!(lists, lt=compare)
    firstIndex = findfirst(isequal([[2]]),lists)
    secondIndex = findfirst(isequal([[6]]),lists)

    println(firstIndex * secondIndex)

end

# We use Julias eval to parse the strings to their respective lists.
# This is very slow on compile time.
# We could also build a custom list parser but I have also left that out
function parseInput()
    lists = Vector{<:Any}()
    lines = Iterators.Stateful(eachline("./Day13/input.txt"))

    while !isempty(lines)
        group = collect(Iterators.take(lines,3))
        push!(lists,eval(Meta.parse(group[1])))
        push!(lists,eval(Meta.parse(group[2])))
    end
    
    return lists
end

# We have multiple compare functions.
# the most fitting one is chosen
# because of multiple dispatch.
# If a comparison couldn't decide, nothing is returned
function compare(x::Integer,y::Integer)
    if x == y
        return nothing
    else
        return x < y
    end
end

# we first pairwise compare items from each list
# until we run out of items.
# If both lists run out simultaniously, we couldn't reach a conclusion
# and return nothing. Otherwise we look if the first list is shorter.
function compare(x::Vector{<:Any},y::Vector{<:Any})
    for i in 1:min(length(x),length(y))
        result = compare(x[i],y[i])
        if !isnothing(result)
            return result
        end
    end
    if length(x) == length(y)
        return nothing
    else
        return length(x) < length(y)
    end
end

# per specification, we transform the integer to a list.
function compare(x::Vector{<:Any},y::Integer)
    return compare(x,[y])
end

# per specification, we transform the integer to a list.
function compare(x::Integer,y::Vector{<:Any}) 
    return compare([x],y)
end