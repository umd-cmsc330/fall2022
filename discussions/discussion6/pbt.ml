open QCheck
open List

let reverse lst = List.fold_left (fun acc x -> x :: acc) [] lst;;

(* What are some properties of the above function and its output? *)


let delete lst elem = List.fold_right (fun x a -> if x = elem then a else x :: a) lst [];;

(* What are some properties of the above function and its output? *)

