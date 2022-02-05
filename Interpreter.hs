
module Interpreter where

import Syntax

-- | Turn lambda expressions into functions that return the body beta-reduced based on input
evalLambda :: Env -> E -> (E -> E)
evalLambda env expr = case expr of
    Lambda p b -> (\argument -> eval (\atom -> if atom == p then argument else env atom) b)
    _          -> error "Non lambda expression was evaluated as a lambda."

-- | Evaluate lambda calculus expressions recursively using a function to bind atoms to expressions
eval :: Env -> E -> E
eval env expr = case expr of
    Atom _             -> env expr
    Let (Atom a) e1 e2 -> eval (\atom -> if atom == (Atom a) then e1 else env atom) e2
    Apply e1 e2        -> case eval env e1 of
        Lambda (Atom a) b -> eval env ((evalLambda env (Lambda (Atom a) b)) (eval env e2))
        irreducible       -> Apply irreducible (eval env e2)
    Lambda (Atom a) b  -> Lambda (Atom a) (eval env b)
    _                  -> error "Invalid lambda calculus expression."

-- | evalp for Evaluate Program
-- Use global environment to enable Defglobal expressions
-- evalp :: Env -> Program -> Program
-- evalp env program = case program of
--     []     -> []
--     ex:exs -> case ex of
--         Defglobal (Atom a) e -> evalp (\atom -> if atom == (Atom a) then e else env atom) exs
--         _                    -> (eval env ex) : (evalp env exs)
evalp :: Env -> Program -> Program
evalp env program = case program of
    []     -> []
    ex:exs -> (eval env ex) : (evalp env exs)

-- | Call to evalp with a blank environment (the ID function)
interpretProgram = evalp (\x -> x)
