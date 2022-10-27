open OUnit2
open QCheck
open P4b.MicroCamlTypes
open P4b.Lexer
open P4b.Parser

let test_simple_def = 
  Test.make
  ~name:"test_simple_def"
  ~count:1000
  (small_int)
  (fun x ->
    let def_string = "def " ^ "validstring" ^ " = " ^ string_of_int x ^ ";;" in
    let ast = def_string |> tokenize |> parse_mutop in
    ast = ([], Def ("validstring", Value (Int x)))
  )

let test_simple_let = 
  Test.make
  ~name:"test_simple_let"
  ~count:1000
  (quad small_int bool small_int small_int)
  (fun (w, x, y, z) ->
    let let_string_1 = "let validstring1 = " ^ (string_of_int w) ^ " in" in 
    let let_string_2 = let_string_1 ^ " let validstring2 = if " ^ (string_of_bool x) in
    let let_string_3 = let_string_2 ^ " then " ^ (string_of_int y) ^ " else " ^ (string_of_int z) ^ " in validstring2" in
    let ast = let_string_3 |> tokenize |> parse_expr in
    ast = ([], Let ("validstring1", false, Value (Int w),
      Let ("validstring2", false,
      If (Value (Bool x), Value (Int y), Value (Int z)), ID "validstring2")))
  )

let test_sum_small_ints = 
  Test.make
  ~name:"test_sum_small_ints"
  ~count:1000 
  (pair small_int small_int) 
  (fun (x, y) ->
    let sum = (string_of_int x) ^ " + " ^ (string_of_int y) in
    let ast = sum |> tokenize |> parse_expr in
    ast = ([], Binop (Add, Value (Int x), Value (Int y)))
  )

let test_operator_precedence = 
  Test.make
  ~name:"test_operator_precedence"
  ~count:1000
  (triple small_int small_int small_int)
  (fun (x, y, z) ->
    let lower_precedence = [(" + ", Add); (" - ", Sub)] in
    let higher_precedence = [(" * ", Mult); (" / ", Div)] in
    let lower_str, lower_tok = List.nth lower_precedence (x mod 2) in
    let higher_str, higher_tok = List.nth higher_precedence (y mod 2) in
    let generated = (string_of_int x) ^ higher_str ^ (string_of_int y) ^ lower_str ^ (string_of_int z) in
    let ast = generated |> tokenize |> parse_expr in
    ast = ([], Binop (lower_tok, Binop(higher_tok, Value (Int x), Value (Int y)), Value (Int z)))
  )

let suite = 
  "pbt" >::: [
    QCheck_runner.to_ounit2_test test_simple_def;
    QCheck_runner.to_ounit2_test test_simple_let;
    QCheck_runner.to_ounit2_test test_sum_small_ints;
    QCheck_runner.to_ounit2_test test_operator_precedence; 
  ]

let _ = run_test_tt_main suite
