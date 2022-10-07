# Discussion 6 - Friday, October 7<sup>th</sup>

## Announcements

- Quiz due today
- Today's discussion will be shorter to accomodate for the quiz
- Midterm next thursday
- Midterm review this Monday
- No discussion next week

## Tail Recursion

To recap, OCaml uses a **lot** of recursion. Recursive functions are just functions that call themselves; recall that recursive functions will accumulate recursive calls on a callstack. 


We can use **tail recursion** to optimize recursive functions. A tail recursive function is defined as a recursive function in which the recursive call is the last statement that is executed by the function. Tail recursive functions are more efficient than non-tail recursive functions.

In non-tail recursive functions, calculation will happen ***after*** the recursion call. In tail recursive functions, the calculation will occur ***before*** the recursive call, so it is more efficient. This is because we don't need to evaluate a bunch of recursive calls before we get the answer; the answer has already been computed by the time we want it!

We will go through some examples of recursive functions as well as tail-recursive implementations of those functions.

### Fold:

Non-tail recursive (`fold_right`)
```ocaml
let rec fold_right f xs a = match xs with
| [] -> a
| x :: xt -> f x (fold_right f xt a) ;;
```

Tail-recursive (`fold_left`)
```ocaml
let rec fold_left f a xs = match xs with
| [] -> a
| x :: xt -> fold f (f a x) xt ;;
```

### Factorial:

Non-tail recursive

```ocaml
let rec factorial num =
	if num > 1 then num * factorial (num - 1)
	else 1 ;;
```

Tail-recursive
```ocaml
let factorial num =
  if num = 0 then 1
  else if num = 0 then 1
  else
	let rec helper n acc =
	  if n > 0 then helper (n-1) (acc * n)
	  else acc
	in helper num 1 ;;
```

### Fibonacci:

Non-tail recursive
```ocaml
let rec fibonacci n = 
	if n = 1 then 1
	else if n = 2 then 1
	else fib (n-1) + fib (n-2) ;;
```

Tail-recursive
```ocaml
let fibonacci n = 
  if n = 1 then 1 
  else if n = 2 then 1 
  else 
	let rec helper n first second = 
	  if n > 2 then helper (n-1) second (first + second)
	  else second
	in helper n 1 1 ;;
```

Observe that when writing tail-recursive versions of `factorial` and `fibonacci`, that we define a helper function which stores the result of the calculation at each given step (similar to the accumulator in fold). More precisely, the helper function stores the **current result** and the number of the **current step**. Generally, this is the easiest way to convert a non-tail recursive function into a tail recursive function.

## Property Based Testing

Testing on particular examples is call __unit testing__ while testing on arbitrary inputs to validate the properties of output is called **property-based testing**.

Set up to write PBTs.

```
opam install qcheck 	# terminal
open QCheck				# in your .ml file
#require "qcheck"		# in utop before running open QCheck
(libraries qcheck)		# in dune file
```

### Anatomy of a test

```ocaml
let test_name =
  QCheck.Test.make 		# call the function to make the test
	~count:1000			# number of inputs to test the function on
    ~name:"reverse"			# name of the test in verbose
    QCheck.(list int)					# type of input
    (fun lst -> prop_reverse_reverses_the_list lst);;	# anonymous function that asserts the prop
```

### Example 1: Reversing a list

Given a function:

```ocaml
let reverse lst = List.fold_left (fun a x -> x :: a) [] lst;;
```

We want to test it using property based testing.

What are some properties of the function `reverse` and its output?

### Example 2: Deleting an element from the list

Given the delete function:

```ocaml
let delete lst elem = List.fold_right (fun x a -> if x = elem then a else x :: a) lst [];;
```

What will be some properties of this function and its output?
