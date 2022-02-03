# Lambda-Calculus
Interpreter for the lambda calculus with lisp-like syntax.

For example, the following program
```
(apply
    ;; Example comment
    (lambda (x)
        (apply (y) (x)))
    (z))
```
Evaluates to
```
(apply (y) (z))
```
This interpreter also features scoped variable assignment. The following program assigns the identity function to the value of x, and applies y to it.
```
(let ((x) (lambda (z) (z)))
    (apply (x) (y)))
```
It evaluates to the following
```
(y)
```