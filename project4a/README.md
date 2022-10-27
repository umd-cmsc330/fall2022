# Project 4a: MicroCaml Lexer and Parser
Soft Deadline: November 16th, 2022 at 11:59 pm

Due: November 27th, 2022 at 11:59pm (late November 28th, *10% penalty*)

**Even though both parts of this project are due November 27th we strongly suggest you to start early! Project 4b relies on this part of the project working. We recommend completing this portion of the project by November 16th for a comfortable schedule.**

Points: 48 public, 52 semipublic

## Introduction

Over the course of Projects 4a and 4b, you will implement MicroCaml — a *dynamically-typed* version of OCaml with a subset of its features. Because MicroCaml is dynamically typed, it is not type checked at compile time; like Ruby, type checking will take place when the program runs. As part of your implementation of MicroCaml, you will also implement parts of `mutop` (μtop or Microtop), a version of `utop` for MicroCaml.

In Project 4a, you will implement a lexer and parser for MicroCaml. Your lexer function will convert an input string of MicroCaml into a list of tokens, and your parser function will consume these tokens to produce an abstract symbol tree (AST), either for a MicroCaml expression, or for a `mutop` directive. In Project 4b, you will implement an interpreter to actually execute the produced AST.

Here is an example call to the lexer and parser on a MicroCaml `mutop` directive (as a string):

```ocaml
parse_mutop (tokenize "def b = let x = true in x;;")
```

This will return the AST as the following OCaml value (which we will explain in due course):

```ocaml
 Def ("b", Let ("x", false, Value (Bool true), ID "x"))
```

### Ground Rules

In your code, you may use any OCaml modules and features we have taught in this class **except imperative OCaml** features like references, mutable records, and arrays. This means that you'll have to adjust the approach of the `match_tok` etc. functions given in lecture; these functions will take and return a token list, rather than modify a global list in place; we provide helper functions in the project to do this. Also, we have changed the definition of `lookahead` from the one given in lecture; the version presented here returns an `option` type, which is critical for your parser to work properly.

### Testing & Submitting

You can submit through `gradescope-submit` from the project directory and the project will be automatically submitted.

You can also manually submit to [Gradescope](https://www.gradescope.com/courses/358171/assignments/1959273/).  You may only submit the **lexer.ml** and **parser.ml** files.  To test locally, run `dune runtest -f`.

All tests will be run on direct calls to your code, comparing your return values to the expected return values. Any other output (e.g., for your own debugging) will be ignored. You are free and encouraged to have additional output. The only requirement for error handling is that input that cannot be lexed/parsed according to the provided rules should raise an `InvalidInputException`. We recommend using relevant error messages when raising these exceptions, to make debugging easier. We are not requiring intelligent messages that pinpoint an error to help a programmer debug, but as you do this project you might find you see where you could add those.

You can run your lexer or parser directly on a MicroCaml program by running `dune exec bin/interface.bc lex [filename]` or `dune exec bin/interface.bc parse [filename]` where the `[filename]` argument is required.

To test from the toplevel, run `dune utop src`. The necessary functions and types will automatically be imported for you.

You can write your own tests which only test the parser by feeding it a custom token list. For example, to see how the expression `let x = true in x` would be parsed, you can construct the token list manually (e.g. in `utop`):

```ocaml
parse_expr [Tok_Let; Tok_ID "x"; Tok_Equal; Tok_Bool true; Tok_In; Tok_ID "x"];;
```

This way, you can work on the parser even if your lexer is not complete yet.

## Part 1: The Lexer (aka Scanner or Tokenizer)

Your parser will take as input a list of tokens; this list is produced by the *lexer* (also called a *scanner*) as a result of processing the input string. Lexing is readily implemented by use of regular expressions, as demonstrated in **[lecture][lecture] slides 3-5**. Information about OCaml's regular expressions library can be found in the [`Str` module documentation][str doc]. You aren't required to use it, but you may find it helpful.

Your lexer must be written in [lexer.ml](./src/lexer.ml). You will need to implement the following function: 

#### `tokenize`

- **Type:** `string -> token list` 
- **Description:** Converts MicroCaml syntax (given as a string) to a corresponding token list.
- **Examples:**
  ```ocaml
  tokenize "1 + 2" = [Tok_Int 1; Tok_Add; Tok_Int 2]

  tokenize "1 (-1)" = [Tok_Int 1; Tok_Int (-1)]

  tokenize ";;" = [Tok_DoubleSemi]

  tokenize "+ - let def" = [Tok_Add; Tok_Sub; Tok_Let; Tok_Def]

  tokenize "let rec ex = fun x -> x || true;;" = 
    [Tok_Let; Tok_Rec; Tok_ID "ex"; Tok_Equal; Tok_Fun; Tok_ID "x"; Tok_Arrow; Tok_ID "x"; Tok_Or; Tok_Bool true; Tok_DoubleSemi]
  ```

The `token` type is defined in [tokenTypes.ml](./src/tokenTypes.ml).

Notes:
- The lexer input is case sensitive.
- Tokens can be separated by arbitrary amounts of whitespace, which your lexer should discard. Spaces, tabs ('\t') and newlines ('\n') are all considered whitespace.
- When excaping characters with `\` within Ocaml strings/regexp you must use `\\` to escape from the string and regexp.
- If the beginning of a string could match multiple tokens, the **longest** match should be preferred, for example:
  - "let0" should not be lexed as `Tok_Let` followed by `Tok_Int 0`, but as `Tok_ID("let0")`, since it is an identifier.
  - "330dlet" should be tokenized as `[Tok_Int 330; Tok_ID "dlet"]`. Arbitrary amounts of whitespace also includes no whitespace.
  - "(-1)" should not be lexed as `[Tok_LParen; Tok_Sub; Tok_Int(1); Tok_LParen]` but as `Tok_Int(-1)`. (This is further explained below)
- There is no "end" token (like `Tok_END` the [lecture][lecture] slides 3-5)  -- when you reach the end of the input, you are done lexing.

Most tokens only exist in one form (for example, the only way for `Tok_Concat` to appear in the program is as `^` and the only way for `Tok_Let` to appear in the program is as `let`). However, a few tokens have more complex rules. The regular expressions for these more complex rules are provided here:

- `Tok_Bool of bool`: The value will be set to `true` on the input string "true" and `false` on the input string "false".
  - *Regular Expression*: `true|false`
- `Tok_Int of int`: Valid ints may be positive or negative and consist of 1 or more digits. **Negative integers must be surrounded by parentheses** (without extra whitespace) to differentiate from subtraction (examples below). You may find the functions `int_of_string` and `String.sub` useful in lexing this token type.
  - *Regular Expression*: `[0-9]+` OR `(-[0-9]+)`
  - *Examples of int parenthesization*:
    - `tokenize "x -1" = [Tok_ID "x"; Tok_Sub; Tok_Int 1]`
    - `tokenize "x (-1)" = [Tok_ID "x"; Tok_Int (-1)]`
- `Tok_String of string`: Valid string will always be surrounded by `""` and **should accept any character except quotes** within them (as well as nothing). You have to "sanitize" the matched string to remove surrounding escaped quotes.
  - *Regular Expression*: `\"[^\"]*\"`
  - *Examples*:
    - `tokenize "330" = [Tok_Int 330]`
    - `tokenize "\"330\"" = [Tok_String "330"]`
    - `tokenize "\"\"\"" (* InvalidInputException *)`
- `Tok_ID of string`: Valid IDs must start with a letter and can be followed by any number of letters or numbers. **Note: Keywords may be substrings of IDs**.
  - *Regular Expression*: `[a-zA-Z][a-zA-Z0-9]*`
  - *Valid examples*:
    - "a"
    - "ABC"
    - "a1b2c3DEF6"
    - "fun1"
    - "ifthenelse"

MicroCaml syntax with its corresponding token is shown below, excluding the four literal token types specified above.

Token Name | Lexical Representation
--- | ---
`Tok_LParen` | `(`
`Tok_RParen` | `)`
`Tok_Equal` | `=`
`Tok_NotEqual` | `<>`
`Tok_Greater` | `>`
`Tok_Less` | `<`
`Tok_GreaterEqual` | `>=`
`Tok_LessEqual` | `<=`
`Tok_Or` | `\|\|`
`Tok_And` | `&&`
`Tok_Not` | `not`
`Tok_If` | `if`
`Tok_Then` | `then`
`Tok_Else` | `else`
`Tok_Add` | `+`
`Tok_Sub` | `-`
`Tok_Mult` | `*`
`Tok_Div` | `/`
`Tok_Concat` | `^`
`Tok_Let` | `let`
`Tok_Def` | `def`
`Tok_In` | `in`
`Tok_Rec` | `rec`
`Tok_Fun` | `fun`
`Tok_Arrow` | `->`
`Tok_DoubleSemi` | `;;`

Notes:
- Your lexing code will feed the tokens into your parser, so a broken lexer can cause you to fail tests related to parsing. 
- In grammars given below, the syntax matching tokens (lexical representation) is used instead of the token name. For example, the grammars below will use `(` instead of `Tok_LParen`. 

## Part 2: Parsing MicroCaml Expressions

In this part, you will implement `parse_expr`, which takes a stream of tokens and outputs as AST for the input expression of type `expr`. Put all of your parser code in [parser.ml](./src/parser.ml) in accordance with the signature found in [parser.mli](./src/parser.mli). 

We present a quick overview of `parse_expr` first, then the definition of AST types it should return, and finally the grammar it should parse.

### `parse_expr`
- **Type:** `token list -> token list * expr`
- **Description:** Takes a list of tokens and returns an AST representing the MicroCaml expression corresponding to the given tokens, along with any tokens left in the token list.
- **Exceptions:** Raise `InvalidInputException` if the input fails to parse i.e does not match the MicroCaml expression grammar.
- **Examples** (more below):
  ```ocaml
  parse_expr [Tok_Int(1); Tok_Add; Tok_Int(2)] =  ([], Binop (Add, Value (Int 1), Value (Int 2)))

  parse_expr [Tok_Int(1)] = ([], Value (Int 1))

  parse_expr [Tok_Let; Tok_ID("x"); Tok_Equal; Tok_Bool(true); Tok_In; Tok_ID("x")] = 
  ([], Let ("x", false, Value (Bool true), ID "x"))

  parse_expr [Tok_DoubleSemi] (* raises InvalidInputException *)
  ```

You will likely want to implement your parser using the the `lookahead` and `match_tok` functions that we have provided; more about them is at the end of this README.

### AST and Grammar for `parse_expr`

Below is the AST type `expr`, which is returned by `parse_expr`. **Note** that the `environment` and `Closure of environment * var * expr` parts are only relevant to Project 4b, so you can ignore them for now.

```ocaml
type op = Add | Sub | Mult | Div | Concat | Greater | Less | GreaterEqual | LessEqual | Equal | NotEqual | Or | And

type var = string

type value =
  | Int of int
  | Bool of bool
  | String of string
  | Closure of environment * var * expr (* not used in P4A *)

and environment = (var * value) list (* not used in P4A *)

and expr =
  | Value of value
  | ID of var
  | Fun of var * expr (* an anonymous function: var is the parameter and expr is the body *)
  | Not of expr
  | Binop of op * expr * expr
  | If of expr * expr * expr
  | FunctionCall of expr * expr
  | Let of var * bool * expr * expr (* bool determines whether var is recursive *)
```

The CFG below describes the language of MicroCaml expressions. This CFG is right-recursive, so something like `1 + 2 + 3` will parse as `Add (Int 1, Add (Int 2, Int 3))`, essentially implying parentheses in the form `(1 + (2 + 3))`.) In the given CFG note that all non-terminals are capitalized, all syntax literals (terminals) are formatted `as non-italicized code` and will come in to the parser as tokens from your lexer. Variant token types (i.e. `Tok_Bool`, `Tok_Int`, `Tok_String` and `Tok_ID`) will be printed *`as italicized code`*.

- Expr -> LetExpr | IfExpr | FunctionExpr | OrExpr
- LetExpr -> `let` Recursion *`Tok_ID`* `=` Expr `in` Expr
  -	Recursion -> `rec` | ε
- FunctionExpr -> `fun` *`Tok_ID`* `->` Expr
- IfExpr -> `if` Expr `then` Expr `else` Expr
- OrExpr -> AndExpr `||` OrExpr | AndExpr
- AndExpr -> EqualityExpr `&&` AndExpr | EqualityExpr
- EqualityExpr -> RelationalExpr EqualityOperator EqualityExpr | RelationalExpr
  - EqualityOperator -> `=` | `<>`
- RelationalExpr -> AdditiveExpr RelationalOperator RelationalExpr | AdditiveExpr
  - RelationalOperator -> `<` | `>` | `<=` | `>=`
- AdditiveExpr -> MultiplicativeExpr AdditiveOperator AdditiveExpr | MultiplicativeExpr
  - AdditiveOperator -> `+` | `-`
- MultiplicativeExpr -> ConcatExpr MultiplicativeOperator MultiplicativeExpr | ConcatExpr
  - MultiplicativeOperator -> `*` | `/`
- ConcatExpr -> UnaryExpr `^` ConcatExpr | UnaryExpr
- UnaryExpr -> `not` UnaryExpr | FunctionCallExpr
- FunctionCallExpr -> PrimaryExpr PrimaryExpr | PrimaryExpr
- PrimaryExpr -> *`Tok_Int`* | *`Tok_Bool`* | *`Tok_String`* | *`Tok_ID`* | `(` Expr `)`

Notice that this grammar is not actually quite compatible with recursive descent parsing. In particular, the first sets of the productions of many of the non-terminals overlap. For example:

- OrExpr -> AndExpr `||` OrExpr | AndExpr

defines two productions for nonterminal OrExpr, separated by |. Notice that both productions starting with AndExpr, so we can't use the lookahead (via FIRST sets) to determine which one to take. This is clear when we rewrite the two productions thus:

- OrExpr -> AndExpr `||` OrExpr
- OrExpr -> AndExpr

When my parser is handling OrExpr, which production should it use? From the above, you cannot tell. The solution is: **You need to refactor the grammar, as shown in [lecture][lecture]** slides 35-37.

To illustrate `parse_expr` in action, we show several examples of input and their output AST.

### Example 1: Basic math

**Input:**
```ocaml
(1 + 2 + 3) / 3
```

**Output (after lexing and parsing):**
```ocaml
Binop (Div,
  Binop (Add, Value (Int 1), Binop (Add, Value (Int 2), Value (Int 3))),
  Value (Int 3))
```

In other words, if we run `parse_expr (tokenize "(1 + 2 + 3) / 3")` it will return the AST above.

### Example 2: `let` expressions

**Input:**
```ocaml
let x = 2 * 3 / 5 + 4 in x - 5
```

**Output (after lexing and parsing):**
```ocaml
Let ("x", false,
  Binop (Add,
    Binop (Mult, Value (Int 2), Binop (Div, Value (Int 3), Value (Int 5))),
    Value (Int 4)),
  Binop (Sub, ID "x", Value (Int 5)))
```

### Example 3: `if then ... else ...`

**Input:**
```ocaml
let x = 3 in if not true then x > 3 else x < 3
```

**Output (after lexing and parsing):**
```ocaml
Let ("x", false, Value (Int 3),
  If (Not (Value (Bool true)), Binop (Greater, ID "x", Value (Int 3)),
   Binop (Less, ID "x", Value (Int 3))))
```

### Example 4: Anonymous functions

**Input:**
```ocaml
let rec f = fun x -> x ^ 1 in f 1
```

**Output (after lexing and parsing):**
```ocaml
Let ("f", true, Fun ("x", Binop (Concat, ID "x", Value (Int 1))),
  FunctionCall (ID "f", Value (Int 1)))
```

Keep in mind that the parser is not responsible for finding type errors. This is the job of the interpreter (Project 4b). For example, while the AST for `1 1` should be parsed as `FunctionCall (Value (Int 1), Value (Int 1))`; if it is executed by the interpreter, it will at that time be flagged as a type error.

### Example 5: Recursive anonymous functions

Notice how the AST for `let` expressions uses a `bool` flag to determine whether a function is recursive or not. When a recursive anonymous function `let rec f = fun x -> ... in ...` is defined, `f` will bind to `fun x -> ...` when evaluating the function. The interpreter will be responsible for handling this. In Project 4b, you will also handle the cases where `rec` is used without anonymous functions as well as attempting recursion without using `rec`.

For now, let's create an infinite recursive loop for fun. 

**Input:**
```ocaml
let rec f = fun x -> f (x*x) in f 2
```

**Output (after lexing and parsing):**
```ocaml
Let ("f", true,
  Fun ("x", FunctionCall (ID "f", Binop (Mult, ID "x", ID "x"))),
  FunctionCall (ID "f", Value (Int 2))))
```

### Example 6: Currying

We will **ONLY** be currying to create multivariable functions as well as passing multiple arguments to them. Here is an example:

**Input:**
```ocaml
let f = fun x -> fun y -> x + y in (f 1) 2
```

**Output (after lexing and parsing):**
```ocaml
Let ("f", false, 
  Fun ("x", Fun ("y", Binop (Add, ID "x", ID "y"))),
  FunctionCall (FunctionCall (ID "f", Value (Int 1)), Value (Int 2)))
```

## Part 3: Parsing `mutop` directives

In this part, you will implement `parse_mutop` (putting your code in [parser.ml](./src/parser.ml)) in accordance with the signature found in [parser.mli](./src/parser.mli). Thus function takes a token list produced by lexing a string that is a mutop (top-level) MicroCaml directive, and returns an AST of OCaml type `mutop`. Your implementation of `parse_mutop` will reuse your `parse_expr` implementation, and will not be much extra work.

We present a quick overview of the function first, then the definition of AST types it should return, and finally the grammar it should parse.

#### `parse_mutop`
- **Type:** `token list -> token list * mutop`
- **Description:** Takes a list of tokens and returns an AST representing the MicroCaml expression at the `mutop` level corresponding to the given tokens, along with any tokens left in the token list.
- **Exceptions:** Raise `InvalidInputException` if the input fails to parse i.e does not match the MicroCaml definition grammar.
- **Examples:**
  ```ocaml
  parse_mutop [Tok_Def; Tok_ID("x"); Tok_Equal; Tok_Bool(true); Tok_DoubleSemi] = ([], Def ("x", Value (Bool true)))

  parse_mutop [Tok_DoubleSemi] = ([], NoOp)

  parse_mutop [Tok_Int(1); Tok_DoubleSemi] = ([], Expr (Value (Int 1))))

  parse_mutop [Tok_Let; Tok_ID "x"; Tok_Equal; Tok_Bool true; Tok_In; Tok_ID "x"; Tok_DoubleSemi] = 
  ([], Expr (Let ("x", false, Value (Bool true), ID "x")))
  ```

### AST and Grammar of `parse_mutop`

Below is the AST type `mutop`, which is returned by `parse_mutop`, followed by the CFG that it parses for MicroCaml expressions at the `mutop` level. This CFG is similar (and similarly formatted) to the CFG of `parse_expr` and relies its implementation of Expr.

```ocaml
type mutop = 
  | Def of var * expr
  | Expr of expr
  | NoOp
```

The CFG is as follows:

- Mutop -> DefMutop | ExprMutop | `;;`
- DefMutop -> `def` *`Tok_ID`* `=` Expr `;;`
- ExprMutop -> Expr `;;`

Notice how a valid input for the `parse_mutop` must always terminate with `Tok_DoubleSemi` and input of just `Tok_DoubleSemi` to the parser is considered valid as per the AST.

For this part, we created a new keyword `def` to refer to top-level MicroCaml expressions to differentiate local `let`. In essence, `def` is similar to top-level (global) `let` expressions in normal (OCaml) `utop`. This means `def` will create **global definitions** for variables while running `mutop`, in part 4b. Another key difference between `def` and the `let` expressions defined in Part 2 is that `def` should be *implicitly recursive*. (Note that `def rec x = ...;;` is not valid as per the given AST---basically the `rec` is implicit).

Here are some example mutop directives. Note that `parse_mutop` should return a tuple of (updated token list, parsed AST), but in these examples we omit the updated token list since it should always just be an empty list.

### Example 1: Global definition 

**Input:**
```ocaml
def x = let a = 3 in if a <> 3 then 0 else 1;;
```

**Output (after lexing and parsing):**
```ocaml
Def ("x",
  Let ("a", false, Value (Int 3),
    If (Binop (NotEqual, ID "a", Value (Int 3)), Value (Int 0), Value (Int 1))))
```

### Example 2: Implicit recursion on `f`

**Input:**
```ocaml
def f = fun x -> if x > 0 then f (x-1) else "done";;
```

**Output (after lexing and parsing):**
```ocaml
Def ("f",
  Fun ("x",
   If (Binop (Greater, ID "x", Value (Int 0)),
    FunctionCall (ID "f", Binop (Sub, ID "x", Value (Int 1))),
    Value (String "done"))))
```

### Example 3: Expression

**Input:**
```ocaml
(fun x -> "(" ^ x ^ ")") "parenthesis";;
```

**Output (after lexing and parsing):**
```ocaml
Expr (
  FunctionCall (Fun ("x",
    Binop (Concat, Value (String "("),
      Binop (Concat, ID "x", Value (String ")")))),
    Value (String "parenthesis")))
```

## Provided functions

To help you implement both parsers, we have provided some helper functions in the `parser.ml` file. You are not required to use these, but they are recommended.

### `match_token`
- **Type:** `token list -> token -> token list`
- **Description:** Takes the list of tokens and a single token as arguments, and returns a new token list with the first token removed IF the first token matches the second argument.
- **Exceptions:** Raise `InvalidInputException` if the first token does not match the second argument to the function.

### `match_many`
- **Type:** `token list -> token list -> token list`
- **Description:** An extension of `match_token` that matches a sequence of tokens given as the second token list and returns a new token list with that matches each token in the order in which they appear in the sequence. For example, `match_many toks [Tok_Let]` is equivalent to `match_token toks Tok_Let`.
- **Exceptions:** Raise `InvalidInputException` if the tokens do not match.

### `lookahead`
- **Type:** `token list -> token option`
- **Description:** Returns the top token in the list of tokens as an option, returning `None` if the token list is empty. **In constructing your parser, the lack of lookahead token (None) is fine for the epsilon case.**

### `lookahead_many`
- **Type:** `token list -> int -> token option`
- **Description:** An extension of `lookahead` that returns token at the nth index in the list of tokens as an option, returning `None` if the token list is empty at the given index or the index is negative. For example, `lookahead_many toks 0` is equivalent to `lookahead toks`.

## Academic Integrity

Please **carefully read** the academic honesty section of the course syllabus. **Any evidence** of impermissible cooperation on projects, use of disallowed materials or resources, or unauthorized use of computer accounts, **will be** submitted to the Student Honor Council, which could result in an XF for the course, or suspension or expulsion from the University. Be sure you understand what you are and what you are not permitted to do in regards to academic integrity when it comes to project assignments. These policies apply to all students, and the Student Honor Council does not consider lack of knowledge of the policies to be a defense for violating them. Full information is found in the course syllabus, which you should review before starting.

[str doc]: https://caml.inria.fr/pub/docs/manual-ocaml/libref/Str.html
[lecture]: http://www.cs.umd.edu/class/spring2021/cmsc330/lectures/20-parsing.pdf
