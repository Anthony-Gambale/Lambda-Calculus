# Lambda-Calculus
Interpreter for the lambda calculus with lisp-like syntax.

The following example program:
```
(apply
    (lambda (atom x) (atom x))
    (atom y))
```
Evaluates to:
```
Atom "y"
```
