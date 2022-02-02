
module Interpreter where

import Syntax
import Data.Either

eval :: (Either Expr (Expr -> Expr)) -> Env -> (Either Expr (Expr -> Expr))
eval expr env = case expr of
    Left (Atom s)            -> if (env (Atom s)) == (Atom "NULL") then (Atom s) else (env (Atom s))
    Left (Lambda (Atom s) e) -> (\argument -> eval e (\atom -> if atom == (Atom s) then argument else env atom))
    Left (Apply e1 e2)       -> case e1 of
        Lambda _ _ -> (evalLambda e1 env) (eval e2 env)
        Atom _     -> expr

    _            -> error "Expression did not match correct lambda calculus forms."

interpret :: Expr -> Env -> (Either Expr (Expr -> Expr))
interpret expr = eval (Left expr) (\x -> (Atom "NULL"))
