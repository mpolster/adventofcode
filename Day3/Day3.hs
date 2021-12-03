module Day3 (powerConsumption, lifeSupportRating) where

import Data.List
import Data.Char

countChar :: Char -> String -> Int
countChar c xs = length $ filter (==c) xs

bin2dec :: String -> Int
bin2dec = foldl (\acc x -> acc * 2 + digitToInt x) 0

mostCommonChar :: String -> Char
mostCommonChar xs = if countChar '0' xs > countChar '1' xs then '0' else '1'

leastCommonChar :: String -> Char
leastCommonChar xs = if countChar '1' xs < countChar '0' xs then '1' else '0'

gammaRating :: [String] -> Int
gammaRating xs = bin2dec (map (mostCommonChar) (transpose xs))

epsilonRating :: [String] -> Int
epsilonRating xs = bin2dec (map (leastCommonChar) (transpose xs))

powerConsumption :: [String] -> Int
powerConsumption xs = epsilonRating xs * gammaRating xs

oxygenGeneratorRating :: [String] -> Int -> Int
oxygenGeneratorRating xs i 
    | length (xs !! 0) == i || length xs == 1 = bin2dec (xs !! 0)
    | otherwise = oxygenGeneratorRating (filter (\x -> x !! i == mostCommonChar row) xs) (i+1)
    where row = (transpose xs )!! i

co2ScrubberRating :: [String] -> Int -> Int
co2ScrubberRating xs i 
    | length (xs !! 0) == i || length xs == 1 = bin2dec (xs !! 0)
    | otherwise = co2ScrubberRating (filter (\x -> x !! i == leastCommonChar row) xs) (i+1)
    where row = (transpose xs ) !! i

lifeSupportRating :: [String] -> Int
lifeSupportRating xs =  (oxygenGeneratorRating xs 0) * (co2ScrubberRating xs 0)