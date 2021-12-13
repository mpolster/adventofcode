import Day5

main = do
    content <- readFile "input.txt"
    let lineList = lines content
    print $ part1 lineList
    print $ part2 lineList
