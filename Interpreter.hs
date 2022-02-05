
module Interpreter where

import Syntax

-- | Turn lambda expressions into functions that return the body beta-reduced based on input
evalLambda :: Env -> E -> (E -> E)
evalLambda env expr = case expr of
    Lambda p b -> (\argument -> eval (\x -> if x == p then argument else env x) b)
    _          -> error "Non lambda expression was evaluated as a lambda."

-- | Evaluate lambda calculus expressions recursively using a function to bind atoms to expressions
eval :: Env -> E -> E
eval env expr = case expr of
    Atom _             -> env expr
    Let (Atom a) e1 e2 -> eval (\x -> if x == (Atom a) then e1 else env x) e2
    Apply e1 e2        -> case eval env e1 of
        Lambda (Atom a) b -> let betaReduce = (evalLambda env (Lambda (Atom a) b)) in eval env (betaReduce e2)
        irreducible       -> Apply irreducible (eval env e2)
    Lambda (Atom a) b  -> Lambda (Atom a) (eval env b)
    _                  -> error "Invalid lambda calculus expression."

evalp :: Program -> Program
evalp program = case program of
    []     -> []
    ex:exs -> (eval (\x -> x) ex) : (evalp exs)

-- | Call to evalp with a blank environment (the ID function)
interpretProgram = evalp
