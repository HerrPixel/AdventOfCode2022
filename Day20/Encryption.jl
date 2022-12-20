using DataStructures

mutable struct node
    value::Integer
    originalIndex::Integer
    next::node
    last::node

    function node(value::Integer,originalIndex::Integer)
        return new(value,originalIndex)
    end

    function node(value::Integer,originalIndex::Integer,next::node,last::node)
        return new(value,originalIndex,next,last)
    end
end

mutable struct List
    start::node
    length::Integer

    function List(start::node)
        start.next = start
        start.last = start
        return new(start,1)
    end

end

function append!(l::List,n::node)
    last = l.start.last
    last.next = n
    l.start.last = n
    n.last = last
    n.next = l.start
    l.length += 1
end

function getNode(l::List,Nr::Integer)
    node = l.start
    while node.originalIndex != Nr
        node = node.next
    end
    return node
end

function getbyValue(l::List,v::Integer)
    node = l.start
    while node.value != v
        node = node.next
    end
    return node
end

function mix(thisnode::node,value::Integer)
    if value == 0
        return
    end

    targetnode = thisnode
    if value > 0
        for i in value:-1:1
            targetnode = targetnode.next
        end
    elseif value < 0
        targetnode = node.last
        for i in 1:value
            targetnode = targetnode.last
        end
    end

    temp = targetnode.next
    targetnode.next = thisnode
    temp.last = thisnode
    
    thisnode.last.next = thisnode.next
    thisnode.next.last = thisnode.last

    thisnode.last = targetnode
    thisnode.next = temp
    return
end

function findAfter(thisnode::node,HowMany::Integer)
    if HowMany == 0
        thisnode
    end

    targetnode = thisnode
    if HowMany > 0
        for i in HowMany:-1:1
            targetnode = targetnode.next
        end
    elseif HowMany < 0
        targetnode = thisnode.last
        for i in 1:HowMany
            targetnode = targetnode.last
        end
    end

    return targetnode
end

function parseInput()
    l = List

    i = 1
    for line in eachline("./Day20/input.txt")
        currNode = node(parse(Int,line) * 811589153,i) #changed
        if i == 1
            l = List(currNode)
        else
            append!(l,currNode)
        end
        i += 1
    end
    return l
end

function mixList()
    l = parseInput()
    for j in 1:10
        for i in 1:l.length
            n = getNode(l,i)
            mix(n,mod(n.value,l.length-1))
        end
    end

    n = getbyValue(l,0)
    first = findAfter(n,mod(1000,l.length)).value
    second = findAfter(n,mod(2000,l.length)).value
    third = findAfter(n,mod(3000,l.length)).value
    println(first ,",", second, ",", third, " and sum: ", first+second+third)
end
