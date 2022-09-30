# Discussion 5 - Friday, September 30<sup>nd</sup>

## Introduction
Please vote if you plan to attend the review session: https://piazza.com/class/l6ze7yj3fnd454/post/382

## fold_left vs fold_right

The order matters!

Example: Reversing a list.

```ocaml
List.fold_left (fun a x -> x::a) [] [1;2;3;4];;
List.fold_right (fun x a -> x::a) [1;2;3;4] [];;

List.fold_left (fun a x -> x^a) "" ["a";"b";"c";"d"];;
List.fold_right (fun x a -> x^a) ["a";"b";"c";"d"] "";;
```

## Project 2b Tree

TAs will go over a brief explanation of the project 2b.

## Exercise problems (35 minutes)

**Tuple concatenation** - Given a list of tuple pairs consisting of strings, create a list of strings

_Type:_ (string*string) list -> string list

_Example:_ [("ab","cd"); ("hello ","world")] -> ["abcd";"hello world"]

**Average** - Given a list of integers, find the average (rounded to the nearest integer) 

_Type:_ int list -> int 

**Sentence Formation** - Given a list of tuples with strings, combine them into a sentence

_Type:_ (string,string) list -> string

_Example:_ [("ab","cd "); ("hello ","world")] -> "abcd hello world"

**Index** - Given a list of integers, return the element at that index

_Type:_ integer list -> integer -> integer

**Zip** - Given two lists, combine these lists into one, with each element consisting of a tuple from each list

_Type:_ integer list -> integer list -> (integer*integer) list

_Example:_ [4;5;6], [1;2;3] -> [(4,1);(5,2);(6,3)]

**List Difference** - Given two lists of integers, find the difference of lists

_Type:_ integer list -> integer list -> integer list

_Example:_ [4;5;6], [1;2;3] -> [3,3,3]
