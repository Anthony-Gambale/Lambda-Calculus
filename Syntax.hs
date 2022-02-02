
module Syntax where

type Program = String

data Expression = Atom String
                | Lambda Expression Expression
                | Apply Expression Expression
                  deriving (Eq, Show)

type Environment = Expression -> Expression
