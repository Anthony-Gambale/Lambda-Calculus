
module Interpreter where

import Syntax

evalLambda :: Expression -> Environment -> Expression -> Expression
evalLambda expr env = case expr of
    Lambda (Atom s) e -> (\argument -> eval e (\atom -> if atom == (Atom s) then argument else env atom))
    _                 -> error "Tried to evaluate an Atom or Apply expression as a Lambda expression."

eval :: Expression -> Environment -> Expression
eval expr env = case expr of
    Atom s       -> if (env (Atom s)) == (Atom "NULL") then (Atom s) else (env (Atom s))
    Apply e1 e2  -> case e1 of
        Lambda _ _ -> (evalLambda e1 env) (eval e2 env)
        _          -> (eval e1 env) (eval e2 env)
    _            -> error "Expression did not match correct lambda calculus forms."

interpret :: Expression -> Expression
interpret expr = eval expr (\x -> (Atom "NULL"))
