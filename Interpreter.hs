
module Interpreter where

import Syntax
import Data.Either

evalLambda :: Env -> E -> (E -> E)
evalLambda env expr = case expr of
    Lambda p b -> (\argument -> eval (\atom -> if atom == p then argument else env atom) b)
    _          -> error "Non lambda expression was evaluated as a lambda."

eval :: Env -> E -> E
eval env expr = case expr of
    Atom _      -> env expr
    Let a e1 e2 -> eval (\atom -> if atom == a then e1 else env atom) e2
    Apply e1 e2 -> case eval env e1 of
        Lambda p b  -> eval env ((evalLambda env (Lambda p b)) (eval env e2))
        Atom s      -> Apply (Atom s) (eval env e2)
        Apply a e   -> Apply (Apply a e) (eval env e2)
    _           -> expr

interpret :: E -> E
interpret expr = eval (\x -> x) expr
