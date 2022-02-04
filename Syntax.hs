
module Syntax where

type Source = String

type Program = [E]

-- | Expressions can either be atoms, lambdas or applications.
data E = Atom String
       | Lambda E E
       | Apply E E
       | Let E E E -- Let an atom equal an expression in an expression
       | Defglobal E E -- Define a global variable
         deriving (Eq, Show)

-- | Environments bind atoms to other expressions.
type Env = E -> E
