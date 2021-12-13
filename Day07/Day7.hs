module Day7 (part1, part2) where

import Data.List
import Data.List.Split

part1 :: String -> Int
part1 = calculateMinimalFuel calculateCosts1 . parseInput

part2 :: String -> Int
part2 = calculateMinimalFuel calculateCosts2 . parseInput

parseInput :: String -> [Int]
parseInput = map read . splitOn ","

calculateCosts1 :: Int -> Int -> Int
calculateCosts1 = (abs .) . (-)

calculateCosts2 :: Int -> Int -> Int
calculateCosts2 x y = sum [1..calculateCosts1 x y]

calculateMinimalFuel :: (Int -> Int -> Int) -> [Int] -> Int
calculateMinimalFuel cosFunc input = minimum $ sumCosts input <$> [minimum input..maximum input] 
    where sumCosts inp n = sum $ cosFunc n <$> input
