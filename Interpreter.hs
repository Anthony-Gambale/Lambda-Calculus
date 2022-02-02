
module Interpreter where

import Syntax
import Data.Either

evalLambda :: E -> Env -> (E -> E)
evalLambda expr env = case expr of
    Lambda e1 e2 -> (\argument -> eval e2 (\atom -> if atom == e1 then argument else env atom))
    _            -> error "Non lambda expression was evaluated as a lambda."

eval :: E -> Env -> E
eval expr env = case expr of
    Atom s           -> env (Atom s)
    Apply (Atom _) _ -> expr
    Apply e1 e2      -> case eval e1 env of
        Lambda _ _  -> eval ((evalLambda e1 env) e2) env
        irreducible -> Apply irreducible (eval e2 env)
    _           -> error "Not a valid lambda calculus expression."

interpret :: E -> E
interpret expr = eval expr (\x -> x)
