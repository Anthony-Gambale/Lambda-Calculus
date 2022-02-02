
module Syntax where

type Program = String

data Expr = Atom String
          | Lambda Expr Expr
          | Apply Expr Expr
            deriving (Eq, Show)

type Env = Expr -> Expr
