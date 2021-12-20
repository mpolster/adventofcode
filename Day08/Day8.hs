module Day8 (part1, part2) where

import Data.List.Split
import Data.Set (Set, fromList, size, isSubsetOf, intersection, union, difference)
import Data.Maybe

parseLine :: String -> ([String], [String])
parseLine xs = 
    let inputOutput = splitOn " | " xs
        inputs = splitOn " " (inputOutput !! 0)
        outputs = splitOn " " (inputOutput !! 1)
    in (inputs, outputs)

-- returns the corresponding digits to patterns with a unique length, else Nothing
predictDigit :: String -> Maybe (Int, Set Char)
predictDigit str = case length str of
    2 -> Just (1, fromList str)
    4 -> Just (4, fromList str)
    3 -> Just (7, fromList str)
    7 -> Just (8, fromList str)
    _ -> Nothing

part1 :: [String] -> Int
part1 xs = length predictionList where
    parsedInput = concat $ snd <$> parseLine <$> xs
    maybeList = predictDigit <$> parsedInput
    predictionList = (snd . fromJust) <$> filter isJust maybeList

guessDigit :: String -> [(Int, Set Char)] -> (Int, Set Char)
guessDigit digit clearPatterns = (number, patternSet) where
    one = snd $ (filter ((1 ==) . fst) clearPatterns) !! 0
    four = snd $ (filter ((4 ==) . fst) clearPatterns) !! 0
    seven = snd $ (filter ((7 ==) . fst) clearPatterns) !! 0
    eigth = snd $ (filter ((8 ==) . fst) clearPatterns) !! 0
    patternSet = fromList digit

    number :: Int
    number = case size patternSet of
        5 -> if seven `isSubsetOf` patternSet then 3 
             else if eigth `difference` seven `difference` four `isSubsetOf` patternSet  then 2 
             else if four `difference` one `isSubsetOf` patternSet then 5
             else error "Wrong Pattern"
        6 -> if size (patternSet `intersection` one) == 1 then 6 
             else if eigth `difference` four `union` one `isSubsetOf` patternSet then 0 
             else if four `isSubsetOf` patternSet then 9
             else error "Wrong Pattern!"
        _ -> error "Wrong Pattern!"

part2 :: [String] -> Int
part2 input = sum $ makeOutput <$> (parseLine <$> input) where

    makeDictionary :: ([String], [String]) -> [(Int, Set Char)]
    makeDictionary (xs, ys) = safeDigits ++ guessedDigits where
        safeDigits = fromJust <$> (filter isJust $ predictDigit <$> xs)
        guessedDigits = (flip guessDigit safeDigits) <$> filter (isNothing . predictDigit) xs

    makeOutput :: ([String], [String]) -> Int
    makeOutput (xs, ys) = 
        let dictionary = makeDictionary (xs, ys)
            filteredlist = (\y -> fst (head (filter ((fromList y == ) . snd) dictionary))) <$> ys
        in 1000 * filteredlist !! 0 + 100 * filteredlist !! 1 + 10 * filteredlist !! 2 + filteredlist !! 3
