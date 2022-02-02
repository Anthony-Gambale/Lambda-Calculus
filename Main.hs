
module Main where

import Syntax
import Parser
import Interpreter
import System.IO  
import Control.Monad

removeTabs :: Bool -> Program -> Program
removeTabs tabMode str = case str of
    "" -> ""
    x:xs
        | tabMode == False -> x : removeTabs (x == ' ') xs
        | tabMode == True  -> case x of
            '(' -> x : removeTabs True xs
            ' ' -> removeTabs True xs
            _   -> x : removeTabs False xs

concatExceptComments :: [Program] -> Program
concatExceptComments program = case program of
    []   -> []
    x:xs
        | take 2 (dropWhile (==' ') x) == ";;" -> concatExceptComments xs
        | otherwise        -> x ++ concatExceptComments xs

main = do
    putStrLn "Enter path to file:"
    path <- getLine
    handle <- openFile path ReadMode
    content <- hGetContents handle
    let program = removeTabs False (concatExceptComments (lines content))
    print program
    print ((interpret . parse) program)

repl = do
    content <- getLine
    let program = removeTabs False content
    print ((interpret . parse) program)
