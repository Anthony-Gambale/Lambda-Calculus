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
This interpreter also features scoped variable assignment. The following program assigns the identity function to the value of `identity`, and applies y to it.
```
(let ((identity) (lambda (z) (z)))
    (apply (identity) (y)))
```
It evaluates to the following
```
(y)
```
For fun, this is a program that never terminates.
```
(let ((apply-self)
      (lambda (x) (apply (x) (x))))
      (apply (apply-self) (apply-self)))
```
