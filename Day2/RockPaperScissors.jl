# Answer to Puzzle 1 is ScoreOfStrategyOne()
# Answer to Puzzle 2 is ScoreOfStrategyTwo()

# Since the Scores are the independent of the line number
# and the same for each same pair,
# we just create a lookup table for each pair and its corresponding score
# and then just iterate over the lines and add up the score of the lines

function ScoreOfStrategyOne()
    Score = Dict([("A X", 4),("A Y", 8),("A Z", 3),("B X", 1),("B Y", 5),("B Z", 9),("C X", 7),("C Y", 2),("C Z", 6)])
    totalScore = 0
    
    for line in eachline("./Day2/input.txt")
        totalScore += Score[line]
    end
    println(totalScore)
end

function ScoreOfStrategyTwo()
    Score = Dict([("A X", 3),("A Y", 4),("A Z", 8),("B X", 1),("B Y", 5),("B Z", 9),("C X", 2),("C Y", 6),("C Z", 7)])
    totalScore = 0
    
    for line in eachline("./Day2/input.txt")
        totalScore += Score[line]
    end
    println(totalScore)
end

#=
Round 1:
A = Rock, B = Paper, C = Scissors
X = Rock, Y = Paper, Z = Scissors
1 = Rock, 2 = Paper, 3 = Scissors
0 = Lose, 3 = Draw, 6 = Win

ScoreLookups
"A X", 4
"A Y", 8
"A Z", 3
"B X", 1
"B Y", 5
"B Z", 9
"C X", 7
"C Y", 2
"C Z", 6

Round 2:
A = Rock, B = Paper, C = Scissors
X = Lose, Y = Draw, Z = Win
1 = Rock, 2 = Paper, 3 = Scissors
0 = Lose, 3 = Draw, 6 = Win

ScoreLookups
"A X", 3
"A Y", 4
"A Z", 8
"B X", 1
"B Y", 5
"B Z", 9
"C X", 2
"C Y", 6
"C Z", 7
=#