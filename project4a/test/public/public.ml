open OUnit2
open TestUtils
open P4a.Lexer
open P4a.Parser
open P4a.MicroCamlTypes

let public_nothing _ =
  let result = ([], NoOp) in
  let student = ";;" |> tokenize |> parse_mutop in
  assert_equal student result ~msg:"public_nothing"

let public_mutop_pi_def _ = 
  let result = ([], Def ("pi", Value (Int 31416))) in
  let student = "def pi = 31416;;" |> tokenize |> parse_mutop in
  assert_equal student result ~msg:"public_mutop_pi_def"

let public_mutop_simple_def_and_let _ = 
  let result = ([], Def ("x", Let ("y", false, Binop (Add, Value (Int 123), Value (Int 456)),
   Binop (Add, ID "y", Value (Int 1))))) in
  let student = "def x = let y = (123 + 456) in y + 1;;" |> tokenize |> parse_mutop in
  assert_equal student result ~msg:"public_mutop_simple_def_and_let"

let public_expr_add1 _ = 
  let result = ([], 
    Let ("add1", false, Fun ("x", Binop (Add, ID "x", Value (Int 1))), ID "add1")) in
  let student = "let add1 = fun x -> x + 1 in add1" |> tokenize |> parse_expr in
  assert_equal student result ~msg:"public_add1"

let public_expr_apply _ = 
  let result = ([], Let ("apply", false, Fun ("x", Fun ("y", FunctionCall (ID "x", ID "y"))),
   Let ("add1", false, Fun ("z", Binop (Add, ID "z", Value (Int 1))),
    FunctionCall (FunctionCall (ID "apply", ID "add1"), Value (Int 5))))) in
  let student = "let apply = fun x -> fun y -> x y in let add1 = fun z -> z + 1 in (apply add1) 5" |> tokenize |> parse_expr in
  assert_equal student result ~msg:"public_expr_apply"

let public_expr_double_fun _ = 
  let result = ([], Fun ("x", Fun ("y", Binop (Add, ID "x", ID "y")))) in
  let student = "fun x -> fun y -> x + y" |> tokenize |> parse_expr in
  assert_equal student result ~msg:"public_expr_double_fun"

let public_expr_let_if _ = 
  let result = ([],
  Let ("sanity", false,
   If (Binop (Equal, Value (Int 1), Value (Int 1)), Value (Bool true),
    Value (Bool false)),
   ID "sanity")) in
  let student = "let sanity = if 1 = 1 then true else false in sanity" |> tokenize |> parse_expr in
  assert_equal student result ~msg:"public_expr_let_if"

let public_expr_let_fun _ =
  let result = ([], Let ("abc", false, Fun ("a", Binop (Add, ID "a", Value (Int 1))),
    FunctionCall (ID "abc", Value (Int 1)))) in
  let student = "let abc = fun a -> a + 1 in abc 1" |> tokenize |> parse_expr in
  assert_equal student result ~msg:"public_expr_let_fun"

let public_expr_minus_one _ = 
  let result = ([], Let ("x", false, Binop (Sub, Value (Int 1), Value (Int 1)), ID "x")) in
  let student = "let x = 1-1 in x" |> tokenize |> parse_expr in
  assert_equal student result ~msg:"public_expr_minus_one"

let public_expr_nested_let _ = 
  let result = ([],
  Let ("a", false, Value (Int 1),
   Let ("b", false, Value (Int 2), Let ("c", false, Value (Int 3),
     Let ("d", false, Value (Int 4),
      Let ("e", false, Value (Int 5),
       Let ("f", false, Value (Int 6),
        Let ("g", false, Value (Int 7),
         Let ("h", false, Value (Int 8),
          Let ("i", false, Value (Int 9),
           Let ("j", false, Value (Int 10),
            Binop (Add, ID "a",
             Binop (Add, ID "b",
              Binop (Add, ID "c",
               Binop (Add, ID "d",
                Binop (Add, ID "e",
                 Binop (Add, ID "f", Binop (Add, ID "g", ID "h")))))))))))))))))) in
  let student = "let a = 1 in let b = 2 in let c = 3 in let d = 4 in let e = 5 in let f = 6 in let g = 7 in let h = 8 in let i = 9 in let j = 10 in a+b+c+d+e+f+g+h" |> tokenize |> parse_expr in
  assert_equal student result ~msg:"public_expr_nested_let"
 
let public_expr_sub1 _ = 
  let result = ([], Let ("sub1", false, Fun ("x", Binop (Sub, ID "x", Value (Int 1))), ID "sub1")) in
  let student = "let sub1 = fun x -> x - 1 in sub1" |> tokenize |> parse_expr in
  assert_equal student result ~msg:"public_expr_sub1"

let public_rec_function_factorial _ = 
  let result = ([], Expr (Let ("fact", true, Fun ("x",
     If (Binop (Equal, ID "x", Value (Int 1)), Value (Int 1),
      Binop (Mult, ID "x",
       FunctionCall (ID "fact", Binop (Sub, ID "x", Value (Int 1)))))),
    FunctionCall (ID "fact", Value (Int 3))))) in
  let student = "let rec fact = fun x -> if x = 1 then 1 else x * fact (x - 1) in fact 3;;" |> tokenize |> parse_mutop in
  assert_equal student result ~msg:"public_rec_function_factorial"
  
(* Simple Expression Tests: *)
let public_expr_simple_equal _ =
  let result = ([], Binop (Equal, Value (Int 1), Value (Int 1))) in
  let student = "1 = 1" |> tokenize |> parse_expr in
  assert_equal student result ~msg:"public_simple_equal"

let public_expr_simple_concat _ = 
  let result = ([], Binop (Concat, Value (String "Hello"), Value (String " World!"))) in
  let student = "\"Hello\" ^ \" World!\"" |> tokenize |> parse_expr in
  assert_equal student result ~msg:"public_simple_concat"

let public_expr_simple_div _ = 
  let result =  ([], Binop (Div, Value (Int 15), Value (Int 3))) in 
  let student = "15 / 3" |> tokenize |> parse_expr in
  assert_equal student result ~msg:"public_expr_simple_div"
 
let public_expr_simple_mult _ =
  let result = ([], Binop (Mult, Value (Int 5), Value (Int 3))) in
  let student = "5 * 3" |> tokenize |> parse_expr in
  assert_equal student result ~msg:"public_expr_simple_mult"

let public_expr_simple_sub _ =
  let result = ([], Binop (Sub, Value (Int 3), Value (Int 2))) in
  let student = "3 - 2" |> tokenize |> parse_expr in
  assert_equal student result ~msg:"public_expr_simple_sub"

let public_expr_simple_sum _ =
  let result = ([], Binop (Add, Value (Int 1), Value (Int 2))) in
  let student = "1 + 2" |> tokenize |> parse_expr in
  assert_equal student result ~msg:"public_expr_simple_sum"
  
let public_expr_single_and _ =
  let result = ([], Binop (And, Value (Bool true), Value (Bool true))) in
  let student = "true && true" |> tokenize |> parse_expr in
  assert_equal student result ~msg:"public_expr_single_and"
 
let public_expr_single_bool _ =
  let result = ([], Value (Bool false)) in
  let student = "false" |> tokenize |> parse_expr in
  assert_equal student result ~msg:"public_expr_single_bool"
 
let public_expr_single_fun _ =
  let result = ([], Fun ("x", Binop (Add, ID "x", Value (Int 1)))) in
  let student = "fun x -> x + 1" |> tokenize |> parse_expr in
  assert_equal student result ~msg:"public_expr_single_fun"

let public_expr_single_if _ =
  let result = ([], If (Binop (Equal, Value (Int 1), Value (Int 2)), Value (Bool false),
   Value (Bool true))) in
  let student = "if 1 = 2 then false else true" |> tokenize |> parse_expr in
  assert_equal student result ~msg:"public_expr_single_if"

let public_expr_single_let _ =
  let result = ([], Let ("x", false, Value (Int 42), ID "x")) in
  let student = "let x = 42 in x" |> tokenize |> parse_expr in
  assert_equal student result ~msg:"public_expr_single_let"

let public_expr_single_notequal _ =
  let result = ([], Binop (NotEqual, Value (Int 1), Value (Int 2))) in
  let student = "1 <> 2" |> tokenize |> parse_expr in
  assert_equal student result ~msg:"public_expr_single_notequal"

let public_expr_single_not _ =
  let result = ([], Not (Value (Bool true))) in
  let student = "not true" |> tokenize |> parse_expr in
  assert_equal student result ~msg:"public_expr_single_not"

let public_expr_single_number _ =
  let result = ([], Value (Int 42)) in
  let student = "42" |> tokenize |> parse_expr in
  assert_equal student result ~msg:"public_expr_single_number"
 
let public_expr_single_or _ =
  let result = ([], Binop (Or, Value (Bool true), Value (Bool false))) in
  let student = "true || false" |> tokenize |> parse_expr in
  assert_equal student result ~msg:"public_expr_single_or"
 
let public_expr_single_string _ =
  let result = ([], Value (String "Hello World!")) in
  let student = "\"Hello World!\"" |> tokenize |> parse_expr in
  assert_equal student result ~msg:"public_expr_single_string"

let public_err_def_not_top_level _ = 
  input_handler (fun () -> "let x = 5 in let y = 3 in def z = 33;;" |> tokenize |> parse_mutop) 

let public_err_mutop_nested_def _ = 
  input_handler (fun () -> "def x = def y = 5;;" |> tokenize |> parse_mutop)

let suite = 
  "public" >::: [
    "public_nothing" >:: public_nothing;
    "public_mutop_pi_def" >:: public_mutop_pi_def;
    "public_mutop_simple_def_and_let" >:: public_mutop_simple_def_and_let;
    "public_expr_add1" >:: public_expr_add1;
    "public_expr_apply" >:: public_expr_apply;
    "public_expr_double_fun" >:: public_expr_double_fun;
    "public_expr_let_if" >:: public_expr_let_if;
    "public_expr_let_fun" >:: public_expr_let_fun;
    "public_expr_minus_one" >:: public_expr_minus_one;
    "public_expr_nested_let" >:: public_expr_nested_let;
    "public_expr_sub1" >:: public_expr_sub1;
    "public_rec_function_factorial" >:: public_rec_function_factorial;
    "public_expr_simple_equal" >:: public_expr_simple_equal;
    "public_expr_simple_concat" >:: public_expr_simple_concat;
    "public_expr_simple_div" >:: public_expr_simple_div;
    "public_expr_simple_mult" >:: public_expr_simple_mult;
    "public_expr_simple_sub" >:: public_expr_simple_sum;
    "public_expr_simple_sum" >:: public_expr_simple_sum;
    "public_expr_single_and" >:: public_expr_single_and;
    "public_expr_single_bool" >:: public_expr_single_bool;
    "public_expr_single_fun" >:: public_expr_single_fun;
    "public_expr_single_if" >:: public_expr_single_if;
    "public_expr_single_let" >:: public_expr_single_let;
    "public_expr_single_notequal" >:: public_expr_single_notequal;
    "public_expr_single_not" >:: public_expr_single_not;
    "public_expr_single_number" >:: public_expr_single_number;
    "public_expr_single_or" >:: public_expr_single_or;
    "public_expr_single_string" >:: public_expr_single_string;
    "public_err_def_not_top_level" >:: public_err_def_not_top_level;
    "public_err_mutop_nested_def" >:: public_err_mutop_nested_def  
  ]

let _ = run_test_tt_main suite
