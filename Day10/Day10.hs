module Day10 (syntaxErrorScore, middleScore) where

import Data.Maybe
import Data.String
import Data.List

-- define data structure stack
type Stack = [String]

emptyStack :: Stack
emptyStack = []

push :: String -> Stack -> Stack
push = (:)

pop :: Stack -> (Maybe String, Stack)
pop [] = (Nothing, [])
pop (x:xs) = (Just x, xs)
-- End

getOpening :: Char -> Char
getOpening ')' = '('
getOpening '}' = '{'
getOpening '>' = '<'
getOpening ']' = '['

getClosing :: Char -> Char
getClosing '(' = ')'
getClosing '{' = '}'
getClosing '<' = '>'
getClosing '[' = ']'

testCorrupted :: Stack -> String -> Maybe Char
testCorrupted _ [] = Nothing -- might be incomplete, but not corrupted
testCorrupted stack (x:xs) 
    | x `elem` "{(<[" = testCorrupted (push [x] stack) xs
    | x `elem` "})>]" = case pop stack of
        (Nothing, st) -> testCorrupted st xs
        (Just c, st) -> if c == [getOpening x] then testCorrupted st xs else Just x

isCorrupted :: String -> Bool
isCorrupted = isJust . testCorrupted emptyStack

-- Stack -> Completition -> Input Line -> Completition
completeLine :: Stack -> String -> String -> String
completeLine [] newLine [] = newLine
completeLine stack newLine [] = 
    let popResult = pop stack 
    in completeLine (snd popResult) (concat [newLine, [getClosing((fromJust $ fst popResult) !! 0)]]) ""
completeLine stack newLine (x:xs)
    | x `elem` "{(<[" = completeLine (push [x] stack) newLine xs
    | x `elem` "})>]" = 
        let popResult = pop stack 
        in completeLine (snd popResult) newLine xs

middleScore :: [String] -> Int
middleScore xs = 
    let list = sort $ score2 . completeLine emptyStack "" <$> (filter (not . isCorrupted) xs) 
    in list !! (length list `div` 2)

score2 :: String -> Int
score2 xs = score2' xs 0 where
    score2' [] acc = acc
    score2' (x:xs) acc = case x of
        ')' -> score2' xs (1 + 5*acc)
        ']' -> score2' xs (2 + 5*acc)
        '}' -> score2' xs (3 + 5*acc)
        '>' -> score2' xs (4 + 5*acc)

score :: Char -> Int
score ')' = 3
score ']' = 57
score '}' = 1197
score '>' = 25137

syntaxErrorScore :: [String] -> Int
syntaxErrorScore xs = sum $ score . fromJust <$> (filter isJust $ testCorrupted emptyStack <$> xs)

