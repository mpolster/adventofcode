module Day5 (part1, part2) where

import Data.List
import Data.List.Split
import qualified Data.Map as M

type Coordinate = (Int, Int)
type Line = ((Int, Int), (Int, Int))

isHorizontal :: Line -> Bool
isHorizontal ((x1, y1), (x2, y2)) = y1 == y2

isVertical :: Line -> Bool
isVertical ((x1, y1), (x2, y2)) = x1 == x2

parseLineFromString :: String -> Line
parseLineFromString = (\(([x1, y1]), ([x2, y2])) -> ((read x1, read y1), (read x2, read y2))) . (\[s1, s2] -> ((splitOn "," s1), (splitOn "," s2))) . splitOn " -> "

parseLines :: [String] -> [Line]
parseLines = map parseLineFromString

findCoordinatesOnLine :: Line -> [Coordinate]
findCoordinatesOnLine line@((x1, y1), (x2, y2)) 
    | isHorizontal line = zip xlist (repeat y1)
    | isVertical line = zip (repeat x1) ylist
    | otherwise = zip xlist ylist
    where xlist = if x1 <= x2 then [xi | xi <- [x1..x2]] else (reverse [xi | xi <- [x2..x1]])
          ylist = if y1 <= y2 then [yi | yi <- [y1..y2]] else (reverse [yi | yi <- [y2..y1]])

generateAllPassedCoordinates :: [Line] -> [Coordinate]
generateAllPassedCoordinates = concat . map findCoordinatesOnLine

countElems :: [Coordinate] -> M.Map Coordinate Int
countElems = M.fromListWith (+) . flip zip (repeat 1)

countHowManyOverlapsPerCoordinate :: [Line] -> [(Coordinate, Int)]
countHowManyOverlapsPerCoordinate lns = 
    let coordinates = generateAllPassedCoordinates lns
    in M.toList $ countElems coordinates

part1 :: [String] -> Int
part1 = numberAtLeastTwoOverlappingLines . (filter (\x -> isHorizontal x || isVertical x)) . map parseLineFromString

part2 :: [String] -> Int
part2 = numberAtLeastTwoOverlappingLines . map parseLineFromString

numberAtLeastTwoOverlappingLines :: [Line] -> Int
numberAtLeastTwoOverlappingLines = length . filter ((>=2) . snd) . countHowManyOverlapsPerCoordinate
