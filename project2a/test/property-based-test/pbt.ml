open OUnit2
open Basics
open QCheck

(* 
  Each function you see below is a property for a function that we would
  like to test. The structure of a PBT is as follows:

    let test_my_test_name = 
      Test.make
      ~name:"identifiable_name"
      ~count:x
      (type of data you'd like of generate)
      (anonymous function to be run)

  The count can be any number you'd like, the more you test, the longer
  it will take. It sometimes makes sense to generate a lot different tests
  for a single function, while in other cases it does not. Think about what
  different things might happen depending on what input, and try to generate
  accordingly. If you generate more than needed you'll still pass the tests
  if you're correct, but it will make the testing process take longer.

  The type of data to generate refers to exactly that, what should be 
  generated. You can generate ints, floats, strings, lists of them, as well
  as tuples of various sizes. Use the code below as reference, as well as the
  following documentation: http://c-cube.github.io/qcheck/0.5.1/QCheck.html

  Finally, there's an anonymous function to be run. Here's where the magic 
  happens. In it, we take the randomly generated input, and we use it to
  test our function, and see how it behaves. The function should return either
  true or false. true = PASS, false = FAIL.

  Example: Say we'd like to test an add1 function, that will add 1 to a number
  we pass into it.

  We might write the first part of our test like so:

  (NOTE: A good way of writing your test names is like so: 
    test_functionname_property)

  One characteristic of adding 1, is that substracting 1 gives you the same. 
  Thus, we can test it:

  let test_add1_giveandtake = 
    Test.make
      ~name:"My awesome, identifiable, memorable name"
      ~count:100
      (int) (* I want to generate a single integer, positive or negative *)
      (fun x -> if ((add1 x) - 1) = x then true else false)

Once you know what properties you'd like to test, writing them is very easy
and straight forward. The hard part is coming up with them! Think of how your
functions should work in general, and what should always be true of them.

Use the methods implemented below for reference, and finally, once you've
written your tests, add them below where shown.

*)

(* Straight forward implementation test, should probably be ommitted *)
let test_rev_tup = 
  Test.make
    ~name:"test_rev_tup"
    ~count:25
    (triple int int int)
    (fun (x, y, z) ->
      rev_tup (x, y, z) = (z, y, x)
    )

(* Reversing twice gives you the same *)
let test_rev_tup_twice = 
  Test.make
    ~name:"test_rev_twice"
    ~count:25
    (triple int int int)
    (fun (x, y, z) ->
      rev_tup (rev_tup (x, y, z)) = (x, y, z)
    )
  
(* All numbers of the form 2x+1 are odd *)
let test_is_odd_odds = 
  Test.make
    ~name:"test_is_odd_odds"
    ~count:10
    (int_range (-1000000) (1000000))
    (fun x -> is_odd (2*x+1))

(* All numbers of the form 2x are not odd *)
let test_is_odd_evens =
  Test.make
    ~name:"test_is_odd_evens"
    ~count:10
    (int_range (-1000000) (1000000))
    (fun x -> not (is_odd (2*x)))

(* Product of two numbers is only even if one
   operand is even *)
let test_is_odd_multiplicativity = 
  Test.make
    ~name:"test_is_odd_multiplicativity"
    ~count:10
    (pair small_int small_int)
    (fun (x, y) -> if is_odd (x * y) then true else (
      if is_odd x then (if is_odd y then false else true)
      else true))

(* Sum of two numbers is only odd if ones is even
   and the other is odd *)
let test_is_odd_additivity =
  Test.make
  ~name:"test_is_odd_additivity"
  ~count:10
  (pair small_int small_int)
  (fun (x, y) -> if not (is_odd (x + y)) then true else (
    if is_odd x then (if is_odd y then false else true)
    else is_odd y))

(* Area *)
let test_area_positive =
  Test.make
  ~name:"test_area_positive"
  ~count:10
  (quad small_int small_int small_int small_int)
  (fun (a,b,c,d) -> area (a, b) (c, d) >= 0)

(* Make sure that fib(x+1) >= fib(x) *)
let test_fib_inc = 
  Test.make
  ~name:"test_fib_inc"
  ~count:10
  (int_range 0 25)
  (fun x -> fibonacci (x + 1) >= fibonacci x)

(* Make sure that fib(x) is always positive *)
let test_fib_geq_z = 
  Test.make
  ~name:"test_fib_geq_z"
  ~count:20
  (int_range 0 25)
  (fun x -> fibonacci x >= 0)

(* Powers should always be positive *)
let test_pow_pos = 
  Test.make
  ~name:"test_pow_pos"
  ~count:30
  (pair small_int small_int)
  (fun (a, b) -> 
    let x = a mod 100 in
    let y = b mod 10 in
    (pow x y > 0)
  )

(* (a^b)^b = a^(b^2) *)
let test_pow_twice = 
  Test.make
    ~name:"test_pow_twice"
    ~count:30
    (pair small_int small_int)
    (fun (a, b) -> 
      let x = a mod 100 in let y = b mod 10 in
      ((pow (pow x y) y) = (pow x (pow y 2)))
    )

(* Reversing twice gives you the same *)
let test_rev_lst = 
  Test.make
    ~name:"test_rev_lst"
    ~count:30
    (list int)
    (fun lst -> reverse (reverse lst) = lst)

let suite = 
  "public" >::: [
    QCheck_runner.to_ounit2_test test_rev_tup;
    QCheck_runner.to_ounit2_test test_rev_tup_twice;
    QCheck_runner.to_ounit2_test test_is_odd_odds; 
    QCheck_runner.to_ounit2_test test_is_odd_evens;
    QCheck_runner.to_ounit2_test test_is_odd_additivity;
    QCheck_runner.to_ounit2_test test_is_odd_multiplicativity;
    QCheck_runner.to_ounit2_test test_area_positive;
    QCheck_runner.to_ounit2_test test_fib_inc;
    QCheck_runner.to_ounit2_test test_fib_geq_z;
    QCheck_runner.to_ounit2_test test_pow_pos;
    QCheck_runner.to_ounit2_test test_pow_twice;
(* Add your tests here after writing them! Like so: *)
(*  QCheck_runner.to_ounit2_test my_test_name_here; *)
    QCheck_runner.to_ounit2_test test_rev_lst
  ]

let _ = run_test_tt_main suite
