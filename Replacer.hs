
module Replacer where

import Syntax

-- | Replace 
replace :: Env -> E -> E
replace env expr = case expr of
    Atom a             -> env (Atom a)
    Lambda (Atom a) e  -> Lambda (Atom a) (replace (\x -> if x == (Atom a) then (Atom a) else env (Atom a)) e)
    Apply e1 e2        -> Apply (replace env e1) (replace env e2)
    Let (Atom a) e1 e2 -> let newe1 = replace env e1
                           in Let (Atom a) newe1 (replace (\x -> if x == (Atom a) then newe1 else env (Atom a)) e2)
    _                  -> error "Invalid lambda calculus expression."

-- | Replace Program Helper
rph :: Env -> Program -> Program
rph env program = case program of
    []     -> []
    ex:exs -> case ex of
        Defglobal (Atom a) e -> rph (\x -> if x == (Atom a) then (replace env e) else env x) exs
        _                    -> replace env ex

replaceProgram = rph (\x -> x)
