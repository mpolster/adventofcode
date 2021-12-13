import Day7

main = do
    content <- readFile "input.txt"
    let line = head (lines content)
    print $ part1 line
    print $ part2 line
