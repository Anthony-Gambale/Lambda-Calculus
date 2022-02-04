# Lambda-Calculus
Interpreter for the lambda calculus with lisp-like syntax.

## How to use
The lambda expression `(\x.y x) z` would be written as
```
(apply
    (lambda (x)
        (apply (y) (x)))
    (z))
```
and evaluates to
```
(apply (y) (z))
```
or `y z` in lambda calculus notation.

On top of the lambda calculus, this interpreter features variable assignment. To temporarily assign a value inside a scope, use `let`.
```
(let ((identity) (lambda (z) (z)))
    (apply (identity) (y)))
```
It evaluates to the following
```
(y)
```
To globally assign a value, use `defglobal`.
```
(defglobal (identity)
    (lambda (x) (x)))

(apply (identity) (another program))
```
This evaluates to the atom `(another program)`. For fun, here is a program that evaluates to itself (runs forever).
```
(let ((apply-self)
      (lambda (x) (apply (x) (x))))
      (apply (apply-self) (apply-self)))
```
It's equivalent to `(\x.x x) (\x.x x)` in lambda calculus notation.
