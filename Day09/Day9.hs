module Day9 (part1, part2) where

import Data.List (sortBy)
import Data.Char (digitToInt)

type Coordinate = (Int, Int, Int)

stringToCoordinateList :: String -> Int -> [Coordinate]
stringToCoordinateList xs y = zip3 [0..length xs] (repeat y) (digitToInt <$> xs)

parseInput :: [String] -> [Coordinate]
parseInput xs = concat $ zipWith stringToCoordinateList xs [0..length xs -1]

getNeighbours :: Coordinate -> [Coordinate] -> [Coordinate]
getNeighbours (x, y, h) xs = filter isNeighbour xs where
    isNeighbour :: Coordinate -> Bool
    isNeighbour (x1, y1, _) 
        | x1 == x+1 && y1 == y = True
        | x1 == x-1 && y1 == y = True
        | x1 == x && y1 == y+1 = True
        | x1 == x && y1 == y-1 = True
        | otherwise = False

findLocalMinima :: [Coordinate] -> [Coordinate]
findLocalMinima xs = filter isLocalMinima xs where
    isLocalMinima :: Coordinate -> Bool
    isLocalMinima c1@(x1, y1, h) = and $ (\(x2, y2, h1) -> h < h1) <$> getNeighbours c1 xs

calculateScore :: [Coordinate] -> Int
calculateScore xs = sum $ (\(_, _, h) -> h+1) <$> xs

part1 :: [String] -> Int
part1 = calculateScore . findLocalMinima . parseInput

getBasin :: Coordinate -> [Coordinate] -> [Coordinate]
getBasin start field = depthSearch [] [start] field where
    depthSearch :: [Coordinate] -> [Coordinate] -> [Coordinate] -> [Coordinate]
    depthSearch acc [] field = acc
    depthSearch acc queue field = 
        let current@(x,y,h) = head queue
            neighbours = getNeighbours current field
            validNeighbours = filter (\nb@(x1, y1, h1) -> nb `notElem` acc && nb `notElem` queue && h1 /= 9) neighbours
        in depthSearch (current:acc) (tail queue ++ validNeighbours) field

part2 :: [String] -> Int
part2 xs = 
    let field = parseInput xs
    in product $ (take 3) $ sortBy (flip compare) $ length <$> flip getBasin field <$> findLocalMinima field
