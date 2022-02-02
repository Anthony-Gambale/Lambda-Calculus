# Lambda-Calculus
Interpreter for the lambda calculus with lisp-like syntax.

For example, the following program
```
(apply
    (lambda (atom x) (atom x))
    (atom y))
```
Evaluates to
```
Atom "y"
```
