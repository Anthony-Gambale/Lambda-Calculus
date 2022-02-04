
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

getBlocks = getAfterInclusive '('

getBlockHelper :: Int -> Char -> Char -> Source -> Source
getBlockHelper cnt open close str = case str of
    "" -> ""
    x:xs
        | x == open              -> x : (getBlockHelper (cnt + 1) open close xs)
        | x == close && cnt == 1 -> close : ""
        | x == close && cnt > 1  -> x : (getBlockHelper (cnt - 1) open close xs)
        | otherwise              -> x : getBlockHelper cnt open close xs

getFirstBlock = getBlockHelper 0 '(' ')' . getBlocks

getSecondBlock = (getFirstBlock . dropFirstBlock)

dropBlockHelper :: Int -> Char -> Char -> Source -> Source
dropBlockHelper cnt open close str = case str of
    "" -> ""
    x:xs
        | x == open              -> dropBlockHelper (cnt + 1) open close xs
        | x == close && cnt == 1 -> xs
        | x == close && cnt > 1  -> dropBlockHelper (cnt - 1) open close xs
        | otherwise              -> dropBlockHelper cnt open close xs

dropFirstBlock = getBlocks . dropBlockHelper 0 '(' ')' . getBlocks

dropParens :: Source -> Source
dropParens source = drop 1 (init source)

-- | Parse source code of an expression into an expression object
parse :: Source -> E
parse source
    | notElem ')' source'        = if head source' == '_' then error "Must not begin a variable name with _." else Atom (source')
    | take 5 source' == "apply"  = Apply (parse (getFirstBlock source')) (parse (getSecondBlock source'))
    | take 6 source' == "lambda" = Lambda (parse (getFirstBlock source')) (parse (getSecondBlock source'))
    | take 3 source' == "let"    = let name = (getFirstBlock . dropParens) (getFirstBlock source')
                                       val = (getSecondBlock . dropParens) (getFirstBlock source')
                                       rest = getSecondBlock source'
                                    in Let (parse name) (parse val) (parse rest)
    where
        source' = dropParens source


-- | Parse entire list of expressions
parseProgram :: Source -> Program
parseProgram src
    | notElem ')' src = []
    | otherwise       = (parse (getFirstBlock src)) : (parseProgram (dropFirstBlock src))
