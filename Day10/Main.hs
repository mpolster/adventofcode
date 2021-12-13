import System.IO
import Day10

main = do
    content <- readFile "input.txt"
    let lineList = lines content
    print $ syntaxErrorScore lineList
    print $ middleScore lineList
