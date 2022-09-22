# Discussion 4 - Friday, September 23<sup>nd</sup>

## Introduction

Today, we'll be covering `map` and `fold`, as well as an example of a custom data type. 

## Part 1: Map

Suppose you have a list in which you want to add one to each element. You could easily write a function to do this:

```ocaml
let rec add1 xs =
  match xs with
      [] -> []
    | h::t -> (h+1)::(add1 t)
;;
```

Now, let's consider a function that squares each element in a list:

```ocaml
let rec square xs =
  match xs with
      [] -> []
    | h::t -> (h*h)::(square t)
;;
```

Notice that both of these functions are *essentially* doing the same thing; they are performing the same task to each element of a list. We can generalize for any function `f` by using `map`.

```ocaml
let rec map f xs = 
  match xs with
      [] -> []
    | h::t -> (f h)::(map f t)
;;
```

## Part 2: Fold

Suppose you want to compute the sum of each element in a list. We can write a function that does this:

```ocaml
let rec sum xs =
  match xs with
      [] -> 0
    | h::t -> h+(sum t)
;;
```

What if you want to compute the size of a list?

```ocaml
let rec size xs =
  match xs with
      [] -> 0
    | h::t -> 1+(size t)
;;
```

In each case, we are keeping track of an *accumulator* and adding onto it based on some property of the current element. We can generalize this to any function `f` using `fold` and `fold_right`:

```ocaml
let rec fold f a lst =
    match lst with
    []->a
    |h::t->fold f (f a h) t
;;

let rec fold_right f lst a =
    match lst with
    []->a
    |h::t-> f h (fold_right f t a)
;;
```

A key difference between these two is the order of association. Consider the example of adding all elements of the list `[1;2;3;4]`.  `fold_left` will associate from the left as follows:

`((1 + 2) + 3) + 4`

On the other hand, `fold_right` will associate from the right as follows:

`1 + (2 + (3 + 4))`


## Part 3: Tree Type

To get more practice with pattern matching, custom data types and map/fold, let's build a `tree` data type!

First, we will define the `tree` type:

```ocaml
type 'a tree = 
  | Leaf 
  | Node of 'a tree * 'a * 'a tree
```

This recursively defines a `tree` to either be a
- `Leaf` 
- `Node` with a left sub-`tree`, a value, and a right sub-`tree`

Let's generalize `map` and `fold` to work on this `tree`. Try to implement it on your own! Can you describe the what the type of these functions should be?

To practice with this, let's write a few functions using map and fold define on trees:


- Write a function to return a `tree` with each value incremented by one:

- Write a function to return the sum of all the elements of a `tree`:

### **Note to TAs: Please use the tree in the solution as a basic example, and create larger trees to show that this works on your own.**

