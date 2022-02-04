
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

getFirstBlock :: Source -> Source
getFirstBlock = getBlockHelper 0 '(' ')' . getAfterInclusive '('

getLastBlock :: Source -> Source
getLastBlock = reverse . getBlockHelper 0 ')' '(' . getAfterInclusive ')' . reverse

getBlockHelper :: Int -> Char -> Char -> Source -> Source
getBlockHelper cnt open close str = case str of
    "" -> ""
    x:xs
        | x == open              -> x : (getBlockHelper (cnt + 1) open close xs)
        | x == close && cnt == 1 -> close : ""
        | x == close && cnt > 1  -> x : (getBlockHelper (cnt - 1) open close xs)
        | otherwise              -> x : (getBlockHelper cnt open close xs)

dropParens :: Source -> Source
dropParens source = drop 1 (init source)

parse :: Source -> E
parse source
    | notElem ')' source'        = if head source' == '_' then error "Must not begin a variable name with _." else Atom (source')
    | take 5 source' == "apply"  = Apply (parse (getFirstBlock source')) (parse (getLastBlock source'))
    | take 6 source' == "lambda" = Lambda (parse (getFirstBlock source')) (parse (getLastBlock source'))
    | take 3 source' == "let"    = let name = (getFirstBlock . dropParens) (getFirstBlock source')
                                       val = (getLastBlock . dropParens) (getFirstBlock source')
                                       rest = getLastBlock source'
                                    in Let (parse name) (parse val) (parse rest)
    where
        source' = dropParens source
