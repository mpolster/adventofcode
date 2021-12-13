module Day4 (getFinalScore1, getFinalScore2) where

import Data.String
import Data.List
import Data.Bool
import Data.List.Split

type Cell = (Int, Bool)
type Board = [[Cell]]
data Game = Game {numbers :: [Int], boards :: [Board]}

bingoLineToTupleList :: String -> [(Int, Bool)]
bingoLineToTupleList xs = (\x -> (x, False)) . read <$> words xs

boardStringListToBoard :: [String] -> [[(Int, Bool)]]
boardStringListToBoard = map bingoLineToTupleList

createGame :: [String] -> Game
createGame [] = Game {numbers = [], boards = [[]]}
createGame (x:xs) = Game {numbers = nums, boards = bds} where
    nums = read <$> splitOn "," x
    bds = filter (not . null) $ boardStringListToBoard <$> splitOn [""] xs

markRow :: Int -> [(Int, Bool)] -> [(Int, Bool)]
markRow n xs = (\(x, y) -> if x == n then (x, True) else (x, y)) <$> xs

markBoard :: Int -> Board -> Board
markBoard n board = markRow n <$> board

checkLine :: [Cell] -> Bool
checkLine xs = and $ snd <$> xs

checkBoard :: Board -> Bool
checkBoard board = any checkLine board || any checkLine (transpose board)

sumUnmarkedNumbers :: Board -> Int
sumUnmarkedNumbers board = sum $ fst <$> filter (not . snd) (concat board)

finalScore :: (Board, Int) -> Int
finalScore (board, n) = sumUnmarkedNumbers board * n

getFinalScore1 :: [String] -> Int
getFinalScore1 = finalScore . playGameUntilFirstWin . createGame

getFinalScore2 :: [String] -> Int
getFinalScore2 = finalScore . playGameUntilLastWin . createGame

existsWinningBoard :: [Board] -> Bool
existsWinningBoard boards = or $ checkBoard <$> boards

-- returns first winning board and last drawn element
playGameUntilFirstWin :: Game -> (Board, Int)
playGameUntilFirstWin (Game nums bds) = start bds nums where
    start :: [Board] -> [Int] -> (Board, Int)
    start boards (x:xs) = 
        let newBoards = markBoard x <$> boards in
            if existsWinningBoard newBoards then (head $ filter checkBoard newBoards, x) 
            else start newBoards xs

-- returns last winning board and last drawn element
playGameUntilLastWin :: Game -> (Board, Int)
playGameUntilLastWin (Game nums boards) = start boards nums where
    start :: [Board] -> [Int] -> (Board, Int)
    start bds (x:xs) =
        let newBoards = markBoard x <$> bds
            filteredBoards = filter (not . checkBoard) newBoards
        in
        if length newBoards == 1 && null filteredBoards then (head newBoards, x)
        else start filteredBoards xs
 