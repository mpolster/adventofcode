import Day9

main = do
    content <- readFile "input.txt"
    let lns = lines content
    print $ part1 lns
    print $ part2 lns
