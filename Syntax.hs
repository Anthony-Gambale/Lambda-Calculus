
module Syntax where

type Program = String

-- | Expressions can either be atoms, lambdas or applications.
data E = Atom String
       | Lambda E E
       | Apply E E
         deriving (Eq, Show)

-- | Environments bind atoms to bigger unevaluated expressions.
type Env = E -> E
