# Lambda-Calculus
Interpreter for the lambda calculus with lisp-like syntax.

## Examples
The lambda expression `(\x.y x) z` would be written as
```
(apply
    ;; Example comment
    (lambda (x)
        (apply (y) (x)))
    (z))
```
and evaluates to
```
(apply (y) (z))
```
or `y z` in lambda calculus notation.

On top of the lambda calculus, this interpreter features scoped variable assignment. The following program assigns the identity function to the value of `identity`, and applies `y` to it.
```
(let ((identity) (lambda (z) (z)))
    (apply (identity) (y)))
```
It evaluates to the following
```
(y)
```
For fun, this is a program that evaluates to itself (runs forever).
```
(let ((apply-self)
      (lambda (x) (apply (x) (x))))
      (apply (apply-self) (apply-self)))
```
It's equivalent to `(\x.x x) (\x.x x)` in lambda calculus notation.
