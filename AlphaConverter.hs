
module AlphaConverter where

import Syntax

-- | Rename all atoms with the first name to the second name
-- under the given expression.
rename :: E -> E -> E -> E
rename (Atom from) (Atom to) expr = case expr of
    Atom a             -> Atom (if a == from then to else a)
    Apply e1 e2        -> Apply (continue e1) (continue e2)
    Lambda (Atom a) e  -> Lambda (continue (Atom a)) (continue e)
    Let (Atom a) e1 e2 -> Let (continue (Atom a)) (continue e1) (continue e2)
    _                  -> error "Invalid lambda calculus expression."
    where
        continue = rename (Atom from) (Atom to)

-- | Generate an atom from an integer
gen :: Int -> E
gen n = Atom ('_' : (show n))

-- | Short for Alpha Convert Helper
ach :: [E] -> Int -> E -> E
ach used curr expr = case expr of
    Atom a             -> Atom a
    Apply e1 e2        -> Apply (ach used curr e1) (ach used curr e2)
    Let (Atom a) e1 e2 -> Let (Atom a) (ach used curr e1) (ach used curr e2)
    Lambda (Atom a) e  -> let newAtom = gen curr
                              newUsed = newAtom : used
                              renamedExpr = rename (Atom a) newAtom e
                           in Lambda newAtom (ach newUsed (curr + 10) renamedExpr)
    _                  -> error "Invalid lambda calculus expression."

-- | Call to helper with default values
alphaConvert :: E -> E
alphaConvert = ach [] 10
