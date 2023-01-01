# Solution to Puzzle 1 is Part1()
# Solution to Puzzle 2 is Part2()

# helper function to parse the input into a number Vector
function parseInput()
    numbers = Vector{Integer}()

    for line in eachline("./Day20/input.txt")
        push!(numbers, parse(Int, line))
    end

    indices = collect(1:length(numbers))

    return numbers, indices
end

# helper function to get the index of an element in a Vector
# assuming it is the only element of that value
function getIndex(list::Vector{<:Integer}, value::Integer)
    return findfirst(isequal(value), list)
end

# The main function, we only shuffle the vector of indices by the corresponding values in the number vector. 
# By using modulus operations on the index, we don't need special
# behaviour for negative indices and can save time on large values.
function mix(indices::Vector{<:Integer}, numbers::Vector{<:Integer})
    for i in 1:length(indices)
        j = getIndex(indices, i)
        deleteat!(indices, j)

        # since Julia is 1-indexed, our modulo operation needs special offsets -_-
        newPosition = mod(j + numbers[i] - 1, length(indices)) + 1
        insert!(indices, newPosition, i)
    end
end

# simple Solution for part1, we parse the input, shuffle the list of indices and then
# finally translate the relevant indices to numbers and get our decryption key
function Part1()
    numbers, indices = parseInput()

    mix(indices, numbers)

    PositionOfZero = getIndex(indices, getIndex(numbers, 0))

    decryptionSum = 0
    for i in [1000, 2000, 3000]
        # since Julia is 1-indexed, our modulo operation needs special offsets -_-
        index = mod(PositionOfZero + i - 1, length(numbers)) + 1
        value = numbers[indices[index]]
        decryptionSum += value
    end

    println(decryptionSum)
end

# same thing as in part1, we parse our input and enlarge the numbers, then shuffle
# the list 10 times and get our relevant indices again, finally we translate
# those to numbers and add them up.
function Part2()
    numbers, indices = parseInput()

    numbers .*= 811589153

    for i in 1:10
        mix(indices, numbers)
    end

    PositionOfZero = getIndex(indices, getIndex(numbers, 0))

    decryptionSum = 0
    for i in [1000, 2000, 3000]
        # since Julia is 1-indexed, our modulo operation needs special offsets -_-
        index = mod(PositionOfZero + i - 1, length(numbers)) + 1
        value = numbers[indices[index]]
        decryptionSum += value
    end

    println(decryptionSum)
end
