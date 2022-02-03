
module Main where

import Syntax
import Parser
import Interpreter
import System.IO  
import Control.Monad

getBeforeExclusive :: Char -> Program -> Program
getBeforeExclusive c s = case s of
    x:xs -> if x == c then "" else x : getBeforeExclusive c xs
    ""   -> ""

removeTabs :: Bool -> Program -> Program
removeTabs tabMode str = case str of
    "" -> ""
    x:xs
        | tabMode == False -> x : removeTabs (x == ' ') xs
        | tabMode == True  -> case x of
            ' ' -> removeTabs True xs
            _   -> x : removeTabs False xs

concatExceptComments :: [Program] -> Program
concatExceptComments programs = foldr (++) "" (map (dropFinalWhitespace . getBeforeExclusive ';') programs)

dropFinalWhitespace :: Program -> Program
dropFinalWhitespace program = case program of
    "" -> program
    _  -> case last program of
        ' ' -> dropFinalWhitespace (init program)
        _   -> program

main :: IO ()
main = do
    putStrLn "Enter path to file:"
    path <- getLine
    handle <- openFile path ReadMode
    content <- hGetContents handle
    let program = removeTabs False (concatExceptComments (lines content))
    -- print program
    print ((interpret . parse) program)
