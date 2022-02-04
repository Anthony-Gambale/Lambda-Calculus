
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
    Atom _      -> env expr
    Let a e1 e2 -> eval (\atom -> if atom == a then e1 else env atom) e2
    Apply e1 e2 -> case eval env e1 of
        Lambda p b  -> eval env ((evalLambda env (Lambda p b)) (eval env e2))
        irreducible -> Apply irreducible (eval env e2)
    Lambda p b  -> Lambda p (eval env b)

-- | Call to eval with a blank environment (the ID function)
interpret :: E -> E
interpret expr = eval (\x -> x) expr
