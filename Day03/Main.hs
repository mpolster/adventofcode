import System.IO
import Day3

main = do
    content <- readFile "input.txt"
    let lineList = lines content
    print $ powerConsumption lineList
    print $ lifeSupportRating lineList