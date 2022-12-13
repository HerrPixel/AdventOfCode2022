
#=
function getSumOfRightOrderPackages

    a = SubString(a,2,length(a) - 1)
    b = SubString(b,2,length(b) - 1)
end
=#
function decoderKey()
    packages = Vector{String}()
    lines = Iterators.Stateful(eachline("./Day13/input.txt"))

    while !isempty(lines)
        group = collect(Iterators.take(lines,3))

        push!(packages,group[1])
        push!(packages,group[2])
    end

    push!(packages,"[[2]]")
    push!(packages,"[[6]]")

    sort!(packages, lt=isInRightOrder)

    first = findfirst(x -> x == "[[2]]",packages)
    second = findfirst(x -> x == "[[6]]",packages)

    println(first * second)

end


function getRightOrderPackageNumbers()

    rightOrderPackages = 0
    PairNumber = 1
    lines = Iterators.Stateful(eachline("./Day13/input.txt"))

    while !isempty(lines)
        group = collect(Iterators.take(lines,3))

        if isInRightOrder(group[1],group[2])
            rightOrderPackages += PairNumber
        end

        PairNumber += 1
    end

    println(rightOrderPackages)
end
    

function isInRightOrder(a::AbstractString,b::AbstractString)
    a = eval(Meta.parse(a))
    b = eval(Meta.parse(b))
    
    result, finished = compare(a,b)
    return result
end

function compare(x::Integer,y::Integer)
    if x < y
        return true, true
    elseif x > y
        return false, true
    else
        return false, false
    end
end

function compare(x::Vector{<:Any},y::Vector{<:Any})
    i = 1
    while true
        if i > lastindex(x) && i ≤ lastindex(y)
            return true, true
        elseif i ≤ lastindex(x) && i > lastindex(y)
            return false, true
        elseif i > lastindex(x) && i > lastindex(y)
            return false, false
        else
            result,finished = compare(x[i],y[i])
            if finished
                return result, true
            else
                i += 1
            end
        end
    end
end

function compare(x::Vector{<:Any},y::Integer) 
    result, finished = compare(x,[y])
    return result, finished
end

function compare(x::Integer,y::Vector{<:Any}) 
    result, finished = compare([x],y)
    return result, finished
end

#=
function getFirstArgument(s::String)
    m = match(r"\[(?:(\[(?:[0-9]|\,|\[|\])*\]|[1-9]*)(?:\,(?:\[(?:[0-9]|\,|\[|\])*\]|[1-9]*))+|([1-9]*)|(\[(?:[0-9]|\,|\[|\])*\]))\]", s).capture

    firstArg = isnothing(capture[1]) ? (isnothing(capture[2]) ? (isnothing(capture[3] ? nothing : capture[3])): capture[2]) : capture[1]

    return firstArg
end
=#