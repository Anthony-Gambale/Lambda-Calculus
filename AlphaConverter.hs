
module AlphaConverter where

import Syntax

-- | Rename all atoms with the first name to the second name
-- under the given expression.
renameAll :: E -> E -> E -> E
renameAll (Atom from) (Atom to) expr = case expr of
    Atom a            -> Atom (if a == from then to else a)
    Apply e1 e2       -> Apply (renameAll from to e1) (renameAll from to e2)
    Lambda (Atom a) e -> Lambda (renameAll from to (Atom a)) (renameAll from to e)
    Let (Atom a) e    -> Let (renameAll from to (Atom a)) (renameAll from to e)
    _                 -> error "Invalid lambda calculus expression."

-- | Generate an atom from an integer
gen :: Int -> Atom
gen n = Atom ('_' : (show n))

-- | Short for Alpha Convert Helper
ach :: [E] -> Int -> E -> E
ach used curr expr = case expr of
    Atom a            -> Atom a
    Apply e1 e2       -> Apply (ach used curr e1) (ach used curr e2)
    Let (Atom a) e    -> Let (Atom a) (ach used curr e)
    Lambda (Atom a) e -> let newAtom = gen curr
                             newUsed = newAtom : used
                             renamedExpr = renameAll (Atom a) newAtom e
                          in Lambda newAtom (ach newUsed (curr + 10) renamedExpr)
    _                 -> error "Invalid lambda calculus expression."

-- | Call to helper with default values
alphaConvert :: E -> E
alphaConvert = ach [] 10
