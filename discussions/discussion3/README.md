# Discussion 3 - Friday, September 16<sup>nd</sup>

## Introduction

This week, we dive into Ocaml in discussions. We will be covering a breadth of material in Ocaml. Projects 2 to 4 are in Ocaml. So, please make sure you understand the fundamentals of the language as best as possible. Today, we will be covering **Ocaml expressions, values, and types, let bindings, let expressions, lists, pattern matching, tuples, variants, functions, and recursive functions `rec`**.

### **Note to TAs: Please open the code to go over the example with students.**

## Part 1: Ocaml expressions, values, and types

Some basics of Ocaml. Ocaml is a compiled and bootstrapped language. It is implicitly typed. That means, the compiler infers the type of your variables and values at compile time. Ocaml is also statically typed, meaning once the type of a variable is infered, the variable must abide by the type throughout its scope. Everything in Ocaml is immutable. Everything means everything. Once you initialize a variable, you cannot change throughout its scope. You should redefine it to change it. That being said, `=` is an equality operator and not the assignment operator outside `let` expressions. 

Some primitive built-in data types are `int`, `float`, `char`, `string`, `bool`, and `unit`. Other composite data types include `tuples`, `lists`, `option`, and variants. **Note that**

We know the primitive data types but we will learn more about the others later down in the discussion. Arithmetic operators in Ocaml are not overloaded. So, you can use `+`, `-`, `*`, `/` on two ints but not on floats. For floats, they are `+.`, `-.`, `*.`, `/.`. **Notice the period**.

Expressions are something that evaluates to some value. Example: `1 + 2`, `2 < 3`, `"hello"`.

## Part 2: Let bindings and Let expressions

Everything in Ocaml is expression , say `e`. So, everything will evaluate to some value of type, say `t`.

Examples:  
- `1: int`
- `true: bool`
- `'e': char`

The `let` syntax is the main way to bind a name to a value. Simply: 

```ocaml
let name = value;; (* syntax *)
let num1 = 5;; (* type: int *)
let num2 = 6;; (* type: int *)
let num3 = num1 + num2;; (* type: int *)
```

We use `let` to create expressions as well. Remember that expressions evaluate to some values. So, the variables initialized in the let expressions are limited to the expression in terms of scope.

Examples:

```ocaml
let x = 8 in x;;  (* will evaluate to 8 *)
let x = 10 in let y = 15 in x + y;; (* nested let expressions *)
let x = 5 in let y = 7 in if x > y then "bigger" else "smaller";; (* expression can be another expression *)
```

## Part 3: Functions and the `rec` keyword

Functions, conventionally, are multiline reusable code that might or might not depend on other variables (arguments). To denote the notion of functions in Ocaml, we can treat the functions as expressions i.e. something that can evaluate to a value. Technically, a function processes the input and generates an output. Putting multiple expressions together can work the same magic. So, we use `let` bindings to bind expression(s) and parameters to some name to make functions.

Example:

```ocaml
let my_function = 5;; (* type: int *)
let my_function2 a = a;; (* type 'a -> 'a *)
```
analogous to (java)
```java
int my_function() {
    return 5;
}
```

Raising the complexity of the functions:
```ocaml
let my_func param1 param2 = param1 + param2;; (* type: int -> int -> int *)
let to_arr a b = [a; b];;                     (* type: 'a -> 'a -> 'a list *)  
```
analogous to (java)
```java
int my_func(int param1, int param2) {
    return param1 + param2;
}

<T> T[] to_arr(T a, T b) {
    return {a, b};
}
```

```ocaml
let check_empty_string str_param = 
    if str_param = "" then true else false;; (* type: string -> boolean *)

let check_a_string str_param = 
    if str_param = "a" then true else "invalid string";; (* will fail to compile *)
```

Notice how each branch in a function (maybe if-else or pattern matching) should return the same data type.

### Note to TAs: Go over how Ocaml implicitly infers the type of parameters in the functions. If you do not see types of the expression in the examples, consider them as the opportunity of exercise.

The general pattern for determining the type of any function is:

`first_param_type -> second_param_type -> ... -> last_param_type -> return_type`.

### Recursive functions

The use of `rec` keyword makes a function recursive. You do not need to make recursive calls, but if you want to, you need the `rec` keyword.

```ocaml
let rec fibonacci num = 
    if num = 1 then 1 else num * (fibonacci (num - 1)) (* int -> int *)
```

## Part 4: Lists, Tuples, Variants

Lists are analogous to arrays to other languages with a difference that the Ocaml lists cannot be indexed. So, recursion is the prime way of iterating over a list and pattern-matching to access an element. The lists are homogenous in nature and the elements are separated by `;`. 

Examples: 
```ocaml
let my_list = [1;2;3];;
let my_second_list param_a param_b = [param_a; param_b] in my_second_list 1 2;;
let my_third_list = "first" :: ["second"; "third"];;
```

You preppend to a list using a cons `::` operator.

Tuples are fixed sized, heterogenous, ordered set of values. You cannot index tuples as well but can use pattern matching to access the desired element.

Examples:
```ocaml
let my_tuple = (1,"string",true);;
let my_second_tuple = [1, 2, "yes, this syntax is also valid"];; (* notice the brackets *)
let my_tuple_func a b c = (a, b, c);; 
```

Variants are beautifications of a certain type of existing data type. It is used to create customs types. Think of it like renaming a particular representation of values.

Examples:
```ocaml
type color = Red | Green | Blue;;
let colors = [Red; Green; Red; Red];;
type linked_list_node = TerminalNode of int | IntermediateNode of int * linked_list_node;;
let d = IntermediateNode(8, IntermediateNode(9, TerminalNode(10)));;
```

## Part 5: Pattern matching

Pattern matching is like regular expressions for values. You match the values against a desired pattern to validate that value, extract subvalues out of it, or even manipulate the subvalues.

Syntax:
```ocaml
match value with
pattern1 -> code if it match pattern1
| pattern2 -> code if it match pattern2
.
.
| _ -> default code;;
```

- List pattern matching

```ocaml
let my_list [ 1; 2; 3; 4; 5];;

let rec add_one lst = match lst with
[] -> []
| h :: t -> (h + 1) :: (add_one t)
in add_one my_list;;
```

You can even have multiple levels of patterns.

```ocaml
let check_min_len lst = match lst with
[] -> "zero"
| a :: t -> "at least one"
| a :: b :: t -> "at least two"
| a :: b :: c :: t -> "at least three"
| _ -> "at least four";;
```

In the same manner, you can pattern-match a tuple.

```ocaml
let get_nth_element tup index = match tup with
(a, b, c, d) when index = 0 -> a 
| (a, b, c, d) when index = 1 -> b 
| (a, b, c, d) when index = 2 -> c 
| (a, b, c, d) when index = 3 -> d;;

get_nth_element (2, 4, 6, 8) 3;; (* will return 8 *)
```
