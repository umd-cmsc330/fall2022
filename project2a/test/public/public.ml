open OUnit2
open Basics

let test_rev_tup _ =
  assert_equal (1, 2, 3) (rev_tup (3, 2, 1)) ~msg:"rev_tup (1)";
  assert_equal (3, 2, 1) (rev_tup (1, 2, 3)) ~msg:"rev_tup (2)";
  assert_equal (3, 1, 1) (rev_tup (1, 1, 3)) ~msg:"rev_tup (3)";
  assert_equal (1, 1, 1) (rev_tup (1, 1, 1)) ~msg:"rev_tup (4)"

let test_is_odd _ =
  assert_equal true (is_odd 1) ~msg:"is_odd (1)";
  assert_equal true (is_odd (-1)) ~msg:"is_odd (2)";
  assert_equal false (is_odd 12) ~msg:"is_odd (3)";
  assert_equal false (is_odd 0) ~msg:"is_odd (4)"

let test_area _ =
  assert_equal 1 (area (1, 1) (2, 2)) ~msg:"area (1)";
  assert_equal 2 (area (1, 1) (2, 3)) ~msg:"area (2)";
  assert_equal 2 (area (1, 1) (3, 2)) ~msg:"area (3)";
  assert_equal 4 (area (1, 1) (3, 3)) ~msg:"area (4)"

let test_volume _ =
  assert_equal 1 (volume (1, 1, 1) (2, 2, 2)) ~msg:"volume (1)";
  assert_equal 4 (volume (1, 1, 1) (2, 3, 3)) ~msg:"volume (2)";
  assert_equal 4 (volume (1, 1, 1) (3, 2, 3)) ~msg:"volume (3)";
  assert_equal 4 (volume (1, 1, 1) (3, 3, 2)) ~msg:"volume (4)";
  assert_equal 8 (volume (1, 1, 1) (3, 3, 3)) ~msg:"volume (5)"

let test_fibonacci _ = 
  assert_equal 1 (fibonacci 1) ~msg:"fibonacci (1)";
  assert_equal 1 (fibonacci 2) ~msg:"fibonacci (2)";
  assert_equal 8 (fibonacci 6) ~msg:"fibonacci (3)";
  assert_equal 144 (fibonacci 12) ~msg:"fibonacci (4)"

let test_pow _ =
  assert_equal 2 (pow 2 1) ~msg:"pow (1)";
  assert_equal 4 (pow 2 2) ~msg:"pow (2)";
  assert_equal 3 (pow 3 1) ~msg:"pow (3)";
  assert_equal 27 (pow 3 3) ~msg:"pow (4)";
  assert_equal 625 (pow 5 4) ~msg:"pow (5)";
  assert_equal (-27) (pow (-3) 3) ~msg:"pow (6)"

let test_log _ =
  assert_equal 1 (log 4 4) ~msg:"log (1)";
  assert_equal 2 (log 4 16) ~msg:"log (2)";
  assert_equal 1 (log 4 15) ~msg:"log (3)";
  assert_equal 3 (log 4 64) ~msg:"log (4)"

let test_gcf _ =
  assert_equal 0 (gcf 0 0) ~msg:"gcf (1)";
  assert_equal 3 (gcf 3 0) ~msg:"gcf (2)";
  assert_equal 4 (gcf 12 8) ~msg:"gcf (3)";
  assert_equal 6 (gcf 24 6) ~msg:"gcf (4)";
  assert_equal 1 (gcf 27 10) ~msg:"gcf (3)";
  assert_equal 13 (gcf 13 13) ~msg:"gcf (4)";
  assert_equal 32 (gcf 128 96) ~msg:"gcf (5)"

let test_is_prime _ =
  assert_equal false (is_prime 1) ~msg:"is_prime (1)";
  assert_equal true (is_prime 2) ~msg:"is_prime (2)";
  assert_equal true (is_prime 3) ~msg:"is_prime (3)";
  assert_equal false (is_prime 4) ~msg:"is_prime (4)";
  assert_equal true (is_prime 5) ~msg:"is_prime (5)";
  assert_equal false (is_prime 60) ~msg:"is_prime (6)";
  assert_equal true (is_prime 61) ~msg:"is_prime (7)"

let test_get _ =
  assert_equal 26 (get 0 [26; 11; 99]) ~msg:"get (1)";
  assert_equal 11 (get 1 [26; 11; 99]) ~msg:"get (2)";
  assert_equal 99 (get 2 [26; 11; 99]) ~msg:"get (3)";
  assert_raises (Failure ("Out of bounds")) (fun () -> get 3 [26; 11; 99]) ~msg:"get (4)"

let test_larger _ =
  assert_equal [1; 2; 3] (larger [1; 2; 3] [5; 6]) ~msg:"larger (1)";
  assert_equal [1; 2; 3] (larger [5; 6] [1; 2; 3]) ~msg:"larger (2)";
  assert_equal [1; 2; 3] (larger [] [1; 2; 3]) ~msg:"larger (3)";
  assert_equal [1; 2; 3] (larger [1; 2; 3] []) ~msg:"larger (4)";
  assert_equal [1] (larger [1] []) ~msg:"larger (5)"

let test_reverse _ =
  assert_equal [1] (reverse [1]) ~msg:"reverse (1)";
  assert_equal [3; 2; 1] (reverse [1; 2; 3]) ~msg:"reverse (2)"

let test_combine _ =
  assert_equal [1; 2] (combine [1] [2]) ~msg:"combine (1)";
  assert_equal [1; 2; 3] (combine [1] [2; 3]) ~msg:"combine (2)";
  assert_equal [1; 2; 3] (combine [1; 2] [3]) ~msg:"combine (3)";
  assert_equal [1; 2; 3; 4] (combine [1; 2] [3; 4]) ~msg:"combine (4)"

let test_merge _ =
  assert_equal [1; 2] (merge [1] [2]) ~msg:"merge (1)";
  assert_equal [] (merge [] []) ~msg:"merge (2)";
  assert_equal [1; 2; 3; 4] (merge [1; 4] [2; 3]) ~msg:"merge (3)";
  assert_equal [0; 1] (merge [1] [0]) ~msg:"merge (4)"

let test_is_palindrome _ =
  assert_equal true (is_palindrome [1; 2; 3; 2; 1]) ~msg:"is_palindrome (1)";
  assert_equal true (is_palindrome ["a"; "n"; "n"; "a"]) ~msg:"is_palindrome (2)";
  assert_equal false (is_palindrome ["N"; "o"; "o"; "n"]) ~msg:"is_palindrome (3)";
  assert_equal false (is_palindrome ["O"; "C"; "A"; "M"; "L"]) ~msg:"is_palindrome (4)"

let suite =
  "public" >::: [
    "rev_tup" >:: test_rev_tup;
    "is_odd" >:: test_is_odd;
    "area" >:: test_area;
    "volume" >:: test_volume;
    "fibonacci" >:: test_fibonacci;
    "pow" >:: test_pow;
    "log" >:: test_log;
    "gcf" >:: test_gcf; 
    "is_prime" >:: test_is_prime;
    "get" >:: test_get;
    "larger" >:: test_larger;
    "reverse" >:: test_reverse;
    "combine" >:: test_combine;
    "merge" >:: test_merge; 
    "is_palindrome" >:: test_is_palindrome
  ]

let _ = run_test_tt_main suite
