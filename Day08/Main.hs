import Day8

main = do
    content <- readFile "input.txt"
    let lns = lines content
    print $ part1 lns
