open QCheck
open List

let reverse lst = List.fold_left (fun acc x -> x :: acc) [] lst;;

(* What are some properties of the above function and its output? *)

(* 1. The reverse of the reverse of a list is the same list *)

let prop_preserved_list lst = reverse (reverse lst) = lst;;

(* 2. The output is of same length as the input *)

let prop_preserved_length lst = List.length (reverse lst) = List.length lst;;

let test_reverse_preserves_list =
  QCheck.Test.make ~count:1000
	~name:"reverse preserves list"
	QCheck.(list int)
	(fun lst -> prop_preserved_list lst);;

let test_reverse_length_preserved =
  QCheck.Test.make ~count:1000
	~name:"reverse preserves length"
	QCheck.(list int)
	(fun lst -> prop_preserved_length lst);;


let delete lst elem = List.fold_right (fun x a -> if x = elem then a else x :: a) lst [];;

(* 1. elem is no longer in the list *)

let prop_elem_absent lst elem = not (List.mem elem (delete lst elem));;

(* 2. The length of the list is one less than the original list *)

let prop_length_decreased lst elem = List.length (delete lst elem) = List.length lst - 1;;

let test_prop_elem_absent =
  QCheck.Test.make ~count:1000
	~name:"delete removes element"
	QCheck.(pair (small_list int) int)					(* notice how we give mulitple parameters as tuples *)
	(fun (lst, elem) -> prop_elem_absent lst elem);;

let test_prop_length_decreased =
  QCheck.Test.make ~count:1000
	~name:"delete decreases length"
	QCheck.(pair (small_list int) int)	
	(fun (lst, elem) -> prop_length_decreased lst elem);;

QCheck_runner.run_tests ~verbose:true [test_reverse_preserves_list; test_reverse_length_preserved; test_prop_elem_absent; test_prop_length_decreased];;
