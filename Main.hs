
module Main where

import Syntax
import Parser
import AlphaConverter
import Interpreter
import System.IO  
import Control.Monad

getBeforeExclusive :: Char -> Source -> Source
getBeforeExclusive c s = case s of
    x:xs -> if x == c then "" else x : getBeforeExclusive c xs
    ""   -> ""

removeTabs :: Bool -> Source -> Source
removeTabs tabMode str = case str of
    "" -> ""
    x:xs
        | tabMode == False -> x : removeTabs (x == ' ') xs
        | tabMode == True  -> case x of
            ' ' -> removeTabs True xs
            _   -> x : removeTabs False xs

concatExceptComments :: [Source] -> Source
concatExceptComments lines = foldr (++) "" (map (dropFinalWhitespace . getBeforeExclusive ';') lines)

dropFinalWhitespace :: Source -> Source
dropFinalWhitespace source = case source of
    "" -> source
    _  -> case last source of
        ' ' -> dropFinalWhitespace (init source)
        _   -> source

-- | Side effects

displayProgram (ex:exs) = do
    print ex
    displayProgram exs

displayProgram [] = do
    putStrLn "Completed execution."

main = do
    putStrLn "Enter path to file:"
    path <- getLine
    handle <- openFile path ReadMode
    content <- hGetContents handle
    let source = removeTabs False (concatExceptComments (lines content))
    displayProgram ((interpretProgram . alphaConvertProgram . parseProgram) source)
