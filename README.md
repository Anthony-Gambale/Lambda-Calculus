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
This interpreter also features scoped variable assignment. The following
```
(let ((x) (lambda (z) (z)))
    (apply (x) (y)))
```
Evaluates to
```
(y)
```