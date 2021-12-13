module Day8 (part1) where

import Data.List.Split

parseLine :: String -> ([String], [String])
parseLine xs = 
    let inputOutput = splitOn " | " xs
        inputs = splitOn " " (inputOutput !! 0)
        outputs = splitOn " " (inputOutput !! 1)
    in (inputs, outputs)


parseInput :: [String] -> [([String], [String])]
parseInput = map parseLine

predictDigit :: String -> Int
predictDigit str = case length str of
    2 -> 1
    4 -> 4
    3 -> 7
    7 -> 8
    _ -> -1

part1 :: [String] -> Int
part1 xs = 
    let parsedInput = parseInput xs -- [([String], [String])]
        secondsList = snd <$> parsedInput -- [[String]]
        concatedList = concat secondsList -- [String]
        predictionList = predictDigit <$> concatedList -- [Int]
    in length $ filter (/= -1) predictionList

-- Part 2 tbd.