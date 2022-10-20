open QCheck
open List

let reverse lst = List.fold_left (fun acc x -> x :: acc) [] lst;;

(* What are some properties of the above function and its output? *)

(* 1. The output is a list of the same length as the input *)

let prop_length lst = List.length (reverse lst) = List.length lst;;

(* 2. The output is a permutation of the input *)

let prop_permutation lst = List.sort compare (reverse lst) = List.sort compare lst;;

(* 3. The output is a reverse of the input *)

let prop_reverse lst = reverse (reverse lst) = lst;;

let test_reverse_length = 
  Test.make
  ~name:"test_reverse_length"
  ~count:2007
  QCheck(list int)
  (fun lst -> prop_length lst);;

  let test_reverse_permutation = 
    Test.make
    ~name:"test_reverse_permutation"
    ~count:2007
    QCheck(list int)
    (fun lst -> prop_permutation lst);;

let test_reverse_reverse = 
      Test.make
      ~name:"test_reverse_reverse"
      ~count:2007
      QCheck(list int)
      (fun lst -> prop_reverse lst);;


let delete lst elem = List.fold_right (fun x a -> if x = elem then a else x :: a) lst [];;

QCheck_runner.run_tests ~verbose:true [test_reverse_length; test_reverse_permutation; test_reverse_reverse];;


(* What are some properties of the above function and its output? *)

