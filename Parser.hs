
module Parser where

import Syntax

getBeforeInclusive :: Char -> Source -> Source
getBeforeInclusive c s = case s of
    x:xs -> if x == c then x : "" else x : getBeforeInclusive c xs
    ""   -> ""

getAfterInclusive :: Char -> Source -> Source
getAfterInclusive c s = case s of
    x:xs -> if x == c then x:xs else getAfterInclusive c xs
    ""   -> ""

getFirstArg :: Source -> Source
getFirstArg = getArgHelper 0 '(' ')' . getAfterInclusive '('

getSecondArg :: Source -> Source
getSecondArg = reverse . getArgHelper 0 ')' '(' . getAfterInclusive ')' . reverse

getArgHelper :: Int -> Char -> Char -> Source -> Source
getArgHelper cnt open close str = case str of
    "" -> ""
    x:xs
        | x == open              -> x : (getArgHelper (cnt + 1) open close xs)
        | x == close && cnt == 1 -> close : ""
        | x == close && cnt > 1  -> x : (getArgHelper (cnt - 1) open close xs)
        | otherwise              -> x : (getArgHelper cnt open close xs)

dropParens :: Source -> Source
dropParens source = drop 1 (init source)

parse :: Source -> E
parse source
    | notElem ')' source'        = if head source' == '_' then error "Must not begin a variable name with _." else Atom (source')
    | take 5 source' == "apply"  = Apply (parse (getFirstArg source')) (parse (getSecondArg source'))
    | take 6 source' == "lambda" = Lambda (parse (getFirstArg source')) (parse (getSecondArg source'))
    | take 3 source' == "let"    = let name = (getFirstArg . dropParens) (getFirstArg source')
                                       val = (getSecondArg . dropParens) (getFirstArg source')
                                       rest = getSecondArg source'
                                    in Let (parse name) (parse val) (parse rest)
    where
        source' = dropParens source
