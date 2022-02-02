# Lambda-Calculus
Interpreter for the lambda calculus with lisp-like syntax.

For example, the following program
```
(apply
    (lambda (x)
        (apply (x) (x)))
    (y))

```
Evaluates to
```
(apply (y) (y))
```
