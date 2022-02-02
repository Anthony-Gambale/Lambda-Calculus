
module Parser where

import Syntax

getBeforeInclusive :: Char -> Program -> Program
getBeforeInclusive c s = case s of
    x:xs -> if x == c then x : "" else x : getBeforeInclusive c xs
    ""   -> ""

getAfterInclusive :: Char -> Program -> Program
getAfterInclusive c s = case s of
    x:xs -> if x == c then x:xs else getAfterInclusive c xs
    ""   -> ""

getFirstArg :: Program -> Program
getFirstArg = getArgHelper 0 '(' ')' . getAfterInclusive '('

getSecondArg :: Program -> Program
getSecondArg = reverse . getArgHelper 0 ')' '(' . getAfterInclusive ')' . reverse

getArgHelper :: Int -> Char -> Char -> Program -> Program
getArgHelper cnt open close str = case str of
    "" -> ""
    x:xs
        | x == open              -> x : (getArgHelper (cnt + 1) open close xs)
        | x == close && cnt == 1 -> close : ""
        | x == close && cnt > 1  -> x : (getArgHelper (cnt - 1) open close xs)
        | otherwise              -> x : (getArgHelper cnt open close xs)

dropParens :: Program -> Program
dropParens program = drop 1 (init program)

parse :: Program -> E
parse program
    | notElem ')' program'        = Atom (program')
    | take 5 program' == "apply"  = Apply (parse (getFirstArg program')) (parse (getSecondArg program'))
    | take 6 program' == "lambda" = Lambda (parse (getFirstArg program')) (parse (getSecondArg program'))
    | take 3 program' == "let"     = let name = (getFirstArg . dropParens) (getFirstArg program')
                                         val = (getSecondArg . dropParens) (getFirstArg program')
                                         rest = getSecondArg program'
                                         in Let (parse name) (parse val) (parse rest)
    where
        program' = dropParens program
