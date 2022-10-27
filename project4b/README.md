# Project 4B: MicroCaml Interpreter
Due: November 27th, 2022, 11:59PM (Late: November 28th, 2022, 11:59PM)

Points: 48 public, 52 semipublic

## Introduction

This is part (B) of project 4, in which you implement an interpreter for MicroCaml.

In particular, you will implement two functions, `eval_expr` and `eval_mutop`. Each of these takes an `environment` (defined in [microCamlTypes.ml](./src/microCamlTypes.ml)) as a parameter, which acts as a map from variables to values. The `eval_expr` function evaluates an expression in the given environment, returning a `value`, while `eval_mutop` takes a `mutop` -- a top-level directive -- and returns a possibly updated environment and any additional result.

You will need to use Imperative OCaml -- notably references -- to implement this project. This use is small, but important. More details below.

### Ground Rules and Extra Info

The interpreter must be implemented in `eval.ml` in accordance with the signatures for `eval_expr` and `eval_mutop` found in [eval.mli](./src/eval.mli). `eval.ml` is the only file you will write code in. 

In your code, you may use any standard library functions, but the ones that will be useful to you will be found in the [`Stdlib` module][stdlib doc]. If you come asking for help using something we have not taught we will direct you to use methods taught in this class.

### Compilation, Tests, and Running

You can submit through `gradescope-submit` from the project directory and the project will be automatically submitted. You can also manually submit to [Gradescope](https://www.gradescope.com/courses/358171/assignments/1959298/). *You may only submit the `eval.ml` file.*

You do not need a working parser and lexer to implement this project --- all testing can be done on abstract syntax trees directly.

To test locally, run `dune runtest -f`. To test from the toplevel, run `dune utop src`. The necessary functions and types will automatically be imported for you. For example, from `utop`, you can write:

```ocaml
eval_expr [] (Let ("x", false, Value (Bool true), ID "x"));;
- : value = Bool true
```

### Running Mutop

If you do have a working parser and lexer, you can run them and your interpreter together in *mutop* (Micro-utop), a version of `utop` for MicroCaml. Run the command `dune exec bin/mutop.exe` in your terminal or use the shell script `bash mutop.sh` to start the mutop toplevel. The toplevel uses your implementations for `parse_mutop` and `eval_mutop` to execute MicroCaml expressions. Here is an example of its use:

![Mutop Example](assets/ex.gif)

**Note:** If you are having issues running *mutop*, run the command `dune build` before starting the mutop toplevel.

## Operational Semantics

We are going to describe how to implement your interpreter using examples, below. A more succinct description is this [operational semantics](./microcaml-opsem.pdf). Even if you don't use it much to do the project, we expect you to understand it -- we may take questions from it for the exam.

## Part 1: Evaluating Expressions
### `eval_expr : environment -> expr -> value` 

This function takes an environment `env` and an expression `e`, which is type `expr`, and produces the result of evaluating `e`, which is something of type `value`. All of the types mentioned here are defined in [microCamlTypes](src/microCamlTypes.ml); do not change any of them!

The environment `env` is a `(var * value ref) list`, where `var` refers to an variable name (which is a string), and the `value ref` refers to its corresponding value in the `environment`; it's a `ref` because the value could change, due to implementing recursion, as discussed for `Let` below. Elements earlier in the list shadow elements later in the list. 

There are three possible error cases, represented by three different exceptions (in `eval.ml` -- do not change):

```ocaml
exception TypeError of string
exception DeclareError of string
exception DivByZeroError
```

A `TypeError` happens when an operation receives an argument of the wrong type; a `DeclareError` happens when an ID is seen that has not been declared; and a `DivByZeroError` happens on attempted division by zero. We do not enforce what messages you use when raising the `TypeError` or `DeclareError` exceptions. That's up to you.

Evaluation of subexpressions should be done from left to right to ensure that lines with multiple possible errors match up with our expected errors.

Now we describe what your interpreter should do for each kind of `expr`, i.e.,

```ocaml
type expr =
  | Value of value
  | ID of var
  | Fun of var * expr
  | Not of expr
  | Binop of op * expr * expr
  | If of expr * expr * expr
  | FunctionCall of expr * expr
  | Let of var * bool * expr * expr
```

### Value 

A `value` is defined as
```ocaml
type value =
  | Int of int
  | Bool of bool
  | String of string
  | Closure of environment * var * expr
```
Values (often literals in the original source program) evaluate to themselves, i.e., 

```ocaml
eval_expr [] (Value(Int 1)) = Int 1
eval_expr [] (Value(Bool false)) = Bool false
eval_expr [] (Value(String "x")) = String "x"
```

A *closure* is the result of evaluating an anonymous function; it, too, evaluates to itself. We will discuss closures in detail when considering anonymous functions, and function calls, below.
```ocaml
eval_expr [] (Value(Closure ([], "x", Fun ("y", Binop (Add, ID "x", ID "y"))))) = Closure ([], "x", Fun ("y", Binop (Add, ID "x", ID "y")))
```

### ID

An identifier evaluates to whatever value it is mapped to by the environment. Should raise a `DeclareError` if the identifier has no binding.

```ocaml
eval_expr [("x", ref (Int 1))] (ID "x") = Int 1
eval_expr [] (ID "x") (* DeclareError "Unbound variable x" *)
```

See the discussion of `Let` below for advice about managing environments.

### Not

The unary `not` operator operates only on booleans and produces a `Bool` containing the negated value of the contained expression. If the expression in the `Not` is not a boolean (or does not evaluate to a boolean), a `TypeError` should be raised.

```ocaml
eval_expr [("x", ref (Bool true))] (Not (ID "x")) = Bool false
eval_expr [("x", ref (Bool true))] (Not (Not (ID "x"))) = Bool true
eval_expr [] (Not (Value(Int 1))) (* TypeError "Expected type bool" *)
```

### Binop

There are five sorts of binary operator: Those carrying out integer arithmetic; those carrying out integer ordering comparisons; one carrying out string concatenation; and one carrying out equality (and inequality) comparisons; and those implementing boolean logic.

#### Add, Sub, Mult, and Div

Arithmetic operators work on integers; if either argument evaluates to a non-`Int`, a `TypeError` should be raised. An attempt to divide by zero should raise a `DivByZeroError` exceptio. 

```ocaml
eval_expr [] (Binop (Add, Value(Int 1), Value(Int 2))) = Int 3
eval_expr [] (Binop (Add, Value(Int 1), Value(Bool false))) (* TypeError "Expected type int" *)
eval_expr [] (Binop (Div, Value(Int 1), Value(Int 0))) (* DivByZeroError *)
```

#### Greater, Less, GreaterEqual, and LessEqual

These relational operators operate only on integers and produce a `Bool` containing the result of the operation. If either argument evaluates to a non-`Int`, a `TypeError` should be raised.

```ocaml
eval_expr [] (Binop(Greater, Value(Int 1), Value(Int 2))) = Bool false
eval_expr [] (Binop(LessEqual, Value(Bool false), Value(Bool true))) (* TypeError "Expected type int" *)
```

#### Concat

This operation returns the result of concatenating two strings; if either argument evaluates to a non-`String`, a `TypeError` should be raised. 

```ocaml
eval_expr [] (Binop (Concat, Value(Int 1), Value(Int 2))) (* TypeError "Expected type string" *)
eval_expr [] (Binop (Concat, Value(String "hello "), Value(String "ocaml"))) = String "hello ocaml"
```

#### Equal and NotEqual

The equality operators require both arguments to be of the same type. The operators produce a `Bool` containing the result of the operation. If the two arguments to these operators do not evaluate to the same type (e.g., one boolean and one integer), a `TypeError` should be raised. Moreover, we *cannot compare two closures for equality* -- to do so risks an infinite loop because of the way recursive functions are implemented; trying to compare them also raises `TypeError` (OCaml does the same thing in its implementation, BTW).

```ocaml
eval_expr [] (Binop(NotEqual, Value(Int 1), Value(Int 2))) = Bool true
eval_expr [] (Binop(Equal, Value(Bool false), Value(Bool true))) = Bool false
eval_expr [] (Binop(Equal, Value(String "hi"), Value(String "hi"))) = Bool true
eval_expr [] (Binop(NotEqual, Value(Int 1), Value(Bool false))) (* TypeError "Cannot compare types" *)
```

#### Or and And

These logical operations operate only on booleans and produce a `Bool` result. If either argument evaluates to a non-`Bool`, a `TypeError` should be raised.

```ocaml
eval_expr [] (Binop(Or, Value(Int 1), Value(Int 2))) (* TypeError "Expected type bool" *)
eval_expr [] (Binop(Or, Value(Bool false), Value(Bool true))) = Bool true
```

### If

The `If` expression consists of three subexpressions - a guard, the true branch, and the false branch. The guard expression must evaluate to a `Bool` - if it does not, a `TypeError` should be raised. If it evaluates to `Bool true`, the true branch should be evaluated; else the false branch should be. 

```ocaml
eval_expr [] (If (Binop (Equal, Value (Int 3), Value (Int 3)), Value (Bool true), Value (Bool false))) = Bool true
eval_expr [] (If (Binop (Equal, Value (Int 3), Value (Int 2)), Value (Int 5), Value (Bool false))) = Bool false
```

Notes:
- Only one branch should be evaluated, not both. 
- The true and false branches **could evaluate to values having different types**. This is an effect of MicroCaml being dynamically typed.

### Let

The `Let` consists of four components - an ID's name `var` (which is a string); a boolean indicating whether or not the bound variable is referenced in its own definition (i.e., whether it's *recursive*); the *initialization expression*; and the *body expression*.

#### Non-recursive bindings

For a non-recursive `Let`, we first evaluate the initialization expression, which produces a value *v* or raises an error. If the former, we then return the result of evaluating the body expression in an environment extended with a mapping from the `Let`'s ID variable to *v*. (Evaluating the body might cause an exception to be raised.) 

```ocaml
eval_expr [] (Let ("x", false,
  Binop (Add, Binop (Mult, Value (Int 2), 
    Binop (Div, Value (Int 3), Value (Int 5))), Value (Int 4)),
  Binop (Sub, ID "x", Value (Int 5)))) = Int (-1)
```

#### Recursive bindings

For a recursive `Let`, we evaluate the initialization expression in an environment extended with a mapping from the ID we are binding to a temporary placeholder; this way, the initialization expression is permitted to refer to itself, the ID being bound. Then, we *update* that placeholder to *v*, the result, before evaluating the body.

The AST given in this example corresponds to the MicroCaml program `let rec f = fun x -> if x = 0 then x else (x + (f (x-1))) in f 8`:

```ocaml
eval_expr [] (Let ("f", true,
  Fun ("x",
    If (Binop (Equal, ID "x", Value (Int 0)), ID "x",
      Binop (Add, ID "x",
        FunctionCall (ID "f", Binop (Sub, ID "x", Value (Int 1)))))),
    FunctionCall (ID "f", Value (Int 8)))) = Int 36
```

#### Environments

Being able to modify the placeholder is made possibly by using references; this is why the type `environment` given in `microCamlTypes.ml` is `(var * value ref) list` and not `(var * value) list`. To make it easy to work with this kind of environment, we recommend you use the functions given at the top of `eval.ml`:

- `extend env x v` produces an environment that extends `env` with a mapping from `x` to `v`
- `lookup env x` returns `v` if `x` maps to `v` in `env`; if there are multiple mappings, it chooses the most recent.
- `extend_tmp x` produces an environment that extends `env` with a mapping from `x` to a temporary placeholder.
- `update env x v` produces an environment that updates `env` in place, modifying its most recent mapping for `x` to be `v` instead (removing the placeholder).

### Fun

The `Fun` is used for anonymous functions, which consist of two components - a parameter, which is a string as an ID's name, and a body, which is an expression. A `Fun` evaluates to a `Closure` that captures the current environment, so as to implement lexical (aka static) scoping.

```ocaml
eval_expr [("x", ref (Bool true))] (Fun ("y", Binop (And, ID "x", ID "y")))
  = Closure ([("x", ref (Bool true))], "y", Binop (And, ID "x", ID "y"))
eval_expr [] (Fun ("x", Fun ("y", Binop (And, ID "x", ID "y"))))
	= Closure ([], "x", Fun ("y", Binop (And, ID "x", ID "y")))
```

### FunctionCall

The `FunctionCall` has two subexpressions. We evaluate the first to a `Closure(A,x,e)` (otherwise, a `TypeError` should be raised) and the second to a value *v*. Then we evaluate `e` (the closure's body) in environment `A` (the closure's environment), returning the result.

```ocaml
eval_expr [] (FunctionCall (Value (Int 1), Value (Int 1))) (* TypeError "Not a function" *)
eval_expr [] (Let ("f", false, Fun ("x", Fun ("y", Binop (Add, ID "x", ID "y"))),
  FunctionCall (FunctionCall (ID "f", Value (Int 1)), Value (Int 2)))) = Int 3
```

The AST in the second example is equivalent to the MicroCaml expression `let f = fun x -> fun y -> x + y in (f 1) 2`.

## Part 2: Evaluating Mutop Directive
### `eval_mutop : environment -> mutop -> environment * (value option)`

This function evaluates the given `mutop` directive in the given `environment`, returning an updated environment with an optional `value` as the result. There are three kinds of `mutop` directive (as defined in [microCamlTypes.ml](./src/microCamlTypes.ml)):

  ```ocaml
  type mutop =
    | Def of var * expr
    | Expr of expr
    | NoOp
  ```

### Def

For a `Def`, we evaluate its `expr` in the given environment, but with a placeholder set for `var` (see the discussion of recursive `Let`, above, for more about environment placeholders), producing value *v*. We then update the binding for `var` to be *v* and return the extended environment, along with the value itself. 

```ocaml
eval_mutop [] (Def ("x", Value(Bool(true)))) =  ([("x", {contents = Bool true})], Some (Bool true))
```
```ocaml
eval_mutop [] Def ("f",
  Fun ("y",
    If (Binop (Equal, ID "y", Value (Int 0)), Value (Int 1),
    FunctionCall (ID "f", Binop (Sub, ID "y", Value (Int 1)))))) =
([("f",
  {contents =
    Closure (<cycle>, "y",
      If (Binop (Equal, ID "y", Value (Int 0)), Value (Int 1),
        FunctionCall (ID "f", Binop (Sub, ID "y", Value (Int 1)))))})],
  Some 
    (Closure ([("f", {contents = <cycle>})], "y",
      If (Binop (Equal, ID "y", Value (Int 0)), Value (Int 1),
        FunctionCall (ID "f", Binop (Sub, ID "y", Value (Int 1)))))))
```

### Expr
For a `Expr`, we should evaluate the expression in the given environment, and return that environment and the resulting value.

```ocaml
eval_mutop [] (Expr (FunctionCall (Fun ("x",
  Binop (Concat, Value (String "("),
    Binop (Concat, ID "x", Value (String ")")))),
      Value (String "parenthesis")))) = ([], Some (String "(parenthesis)"))
```

### NoOp

The `NoOp` should return the original environment and no value (`None`).

```ocaml
eval_mutop [] NoOp = ([], None)
```

## Academic Integrity

Please **carefully read** the academic honesty section of the course syllabus. **Any evidence** of impermissible cooperation on projects, use of disallowed materials or resources, or unauthorized use of computer accounts, **will be** submitted to the Student Honor Council, which could result in an XF for the course, or suspension or expulsion from the University. Be sure you understand what you are and what you are not permitted to do in regards to academic integrity when it comes to project assignments. These policies apply to all students, and the Student Honor Council does not consider lack of knowledge of the policies to be a defense for violating them. Full information is found in the course syllabus, which you should review before starting.


<!-- links -->

[stdlib doc]: https://caml.inria.fr/pub/docs/manual-ocaml/libref/Stdlib.html
