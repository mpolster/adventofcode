-- compile with ghc Main.hs -package split

import Day4
import System.IO
import Data.List.Split

main = do
    content <- readFile "input1.txt"
    let lineList = lines content
    print $ getFinalScore1 lineList
    print $ getFinalScore2 lineList
