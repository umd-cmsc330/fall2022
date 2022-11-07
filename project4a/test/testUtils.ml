open OUnit2
open P4a.Lexer
open P4a.Parser
open P4a.TokenTypes

(* Assertion wrappers for convenience and readability *)
let assert_true b = assert_equal true b
let assert_false b = assert_equal false b
let assert_succeed () = assert_true true

let file_to_string file = 
  let ch = open_in file in
  let s = really_input_string ch (in_channel_length ch) in
  close_in ch;
  s

let get_file fname = file_to_string ("data/" ^ fname)

let string_to_tokens s = tokenize s

let gen_ast_parse_expr file = get_file file |> tokenize |> parse_expr

let gen_ast_parse_mutop file = get_file file |> tokenize |> parse_mutop

let input_handler f =
  try
    let _ = f () in assert_failure "Expected InvalidInputException, none received" with
  | InvalidInputException(_) -> assert_succeed ()
  | ex -> assert_failure ("Got " ^ (Printexc.to_string ex) ^ ", expected InvalidInputException")