open OUnit2
open Basics

let test_sanity _ =
    assert_equal 1 1 ~msg:"Custom error message"

let suite =
  "student" >::: [
    "sanity" >:: test_sanity
  ]

let _ = run_test_tt_main suite
