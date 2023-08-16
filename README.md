# Advent of Code 2022

This is my code for the [Advent of Code 2022](https://adventofcode.com/2022).  
I have written my submissions in [Julia](https://julialang.org/).  

You can find the solutions to each day in their respective folders. At the top of the file, I have written the relevant calls to receive the solution for that day. I have also tried to explain each solution and clear up confusing lines.

To run this, your first need to instantiate the project:
```bash
$ julia --project=.

julia>

# Press ] to get into pkg

(AdventOfCode2022) pkg> instantiate
```
It will now download the dependencies and set some things up. This only needs to be done once.

Afterwards, if you want to run all problems, just include the `AoC22.jl` file and use `run()`
```bash
$ julia --project=.

julia> include("AoC22.jl")

julia> run()
```

If you want to run a specific problem, include the file and call the function you want.
```bash
$ julia --project=.

julia> include("Day1/Calories.jl")

julia> CaloriesOfTopElves(1)
70369
```
