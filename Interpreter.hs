
module Interpreter where

import Syntax
import Data.Either

evalLambda :: Env -> E -> (E -> E)
evalLambda env expr = case expr of
    Lambda e1 e2 -> (\argument -> eval (\atom -> if atom == e1 then argument else env atom) e2)
    _            -> error "Non lambda expression was evaluated as a lambda."

eval :: Env -> E -> E
eval env expr = case expr of
    Atom _           -> env expr
    Apply e1 e2      -> case eval env e1 of
        Lambda _ _  -> eval env ((evalLambda env e1) e2)
        _           -> Apply expr (eval env e2)
    _           -> expr

interpret :: E -> E
interpret expr = eval (\x -> x) expr
