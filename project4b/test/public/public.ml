open OUnit2
open TestUtils
open P4b.MicroCamlTypes

let public_nothing _ =
  let ast = ([], NoOp) in
  let result = ([], None) in
  let student = eval_mutop_ast [] ast in
  assert_equal student result ~msg:"public_nothing"

let public_mutop_pi_def _ = 
  let ast = ([], Def ("pi", Value (Int 31416))) in
  let result = ([("pi", {contents = Int 31416})], Some (Int 31416)) in
  let student = eval_mutop_ast [] ast in
  assert_equal student result ~msg:"public_mutop_pi_def"

let public_mutop_simple_def_and_let _ = 
  let ast = ([], Def ("x", Let ("y", false, Binop (Add, Value (Int 123), Value (Int 456)),
   Binop (Add, ID "y", Value (Int 1))))) in
  let result = ([("x", {contents = Int 580})], Some (Int 580)) in 
  let student = eval_mutop_ast [] ast in
  assert_equal student result ~msg:"public_mutop_simple_def_and_let"

let public_expr_add1 _ = 
  let ast = ([],
  Let ("add1", false, Fun ("x", Binop (Add, ID "x", Value (Int 1))),
   FunctionCall (ID "add1", Value (Int 1)))) in
  let result = Int 2 in
  let student = eval_expr_ast [] ast in
  assert_equal student result ~msg:"public_add1"

let public_expr_apply _ = 
  let ast = ([], Let ("apply", false, Fun ("x", Fun ("y", FunctionCall (ID "x", ID "y"))),
   Let ("add1", false, Fun ("z", Binop (Add, ID "z", Value (Int 1))),
    FunctionCall (FunctionCall (ID "apply", ID "add1"), Value (Int 5))))) in
   let result = Int 6 in
   let student = eval_expr_ast [] ast in
  assert_equal student result ~msg:"public_expr_apply"

let public_expr_double_fun _ = 
  let ast = ([],
  FunctionCall
   (FunctionCall (Fun ("x", Fun ("y", Binop (Add, ID "x", ID "y"))),
     Value (Int 5)),
   Value (Int 2))) in
  let result = Int 7 in
  let student = eval_expr_ast [] ast in
  assert_equal student result ~msg:"public_expr_double_fun"

let public_expr_let_if _ = 
  let ast = ([],
  Let ("sanity", false,
   If (Binop (Equal, Value (Int 1), Value (Int 1)), Value (Bool true),
    Value (Bool false)),
   ID "sanity")) in
  let result = Bool true in
  let student = eval_expr_ast [] ast in
  assert_equal student result ~msg:"public_expr_let_if"

let public_expr_let_fun _ =
  let ast = ([], Let ("abc", false, Fun ("a", Binop (Add, ID "a", Value (Int 1))),
    FunctionCall (ID "abc", Value (Int 1)))) in
  let result = Int 2 in
  let student = eval_expr_ast [] ast in
  assert_equal student result ~msg:"public_expr_let_fun"

let public_expr_minus_one _ = 
  let ast = ([], Let ("x", false, Binop (Sub, Value (Int 1), Value (Int 1)), ID "x")) in
  let result = Int 0 in
  let student = eval_expr_ast [] ast in
  assert_equal student result ~msg:"public_expr_minus_one"

let public_expr_nested_let _ = 
  let ast = ([],
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
           let result = Int 36 in
  let student = eval_expr_ast [] ast in
  assert_equal student result ~msg:"public_expr_nested_let"

  
(* Simple Expression Tests: *)
let public_expr_simple_equal _ =
  let ast = ([], Binop (Equal, Value (Int 1), Value (Int 1))) in
  let result = Bool true in
  let student = eval_expr_ast [] ast in
  assert_equal student result ~msg:"public_simple_equal"

let public_expr_simple_concat _ = 
  let ast = ([], Binop (Concat, Value (String "Hello"), Value (String " World"))) in
  let result = String "Hello World" in
  let student = eval_expr_ast [] ast in
  assert_equal student result ~msg:"public_simple_concat"

let public_expr_simple_div _ = 
  let ast = ([], Binop (Div, Value (Int 15), Value (Int 3))) in 
  let result = Int 5 in
  let student = eval_expr_ast [] ast in
  assert_equal student result ~msg:"public_expr_simple_div"
 
let public_expr_simple_mult _ =
  let ast = ([], Binop (Mult, Value (Int 5), Value (Int 3))) in
  let result = Int 15 in
  let student = eval_expr_ast [] ast in
  assert_equal student result ~msg:"public_expr_simple_mult"

let public_expr_simple_sub _ =
  let ast = ([], Binop (Sub, Value (Int 3), Value (Int 2))) in
  let result = Int 1 in
  let student = eval_expr_ast [] ast in
  assert_equal student result ~msg:"public_expr_simple_sub"

let public_expr_simple_sum _ =
  let ast = ([], Binop (Add, Value (Int 1), Value (Int 2))) in
  let result = Int 3 in
  let student = eval_expr_ast [] ast in
  assert_equal student result ~msg:"public_expr_simple_sum"
  
let public_expr_single_and _ =
  let ast = ([], Binop (And, Value (Bool true), Value (Bool true))) in
  let result = Bool true in
  let student = eval_expr_ast [] ast in
  assert_equal student result ~msg:"public_expr_single_and"
 
let public_expr_single_bool _ =
  let ast = ([], Value (Bool false)) in
  let result = Bool false in
  let student = eval_expr_ast [] ast in
  assert_equal student result ~msg:"public_expr_single_bool"
 
let public_expr_single_fun _ =
  let ast = ([],
  FunctionCall (Fun ("x", Binop (Add, ID "x", Value (Int 1))), Value (Int 1)))in
  let result = Int 2 in
  let student = eval_expr_ast [] ast in
  assert_equal student result ~msg:"public_expr_single_fun"

let public_expr_single_if _ =
  let ast = ([], If (Binop (Equal, Value (Int 1), Value (Int 2)), Value (Bool false),
   Value (Bool true))) in
  let result = Bool true in
  let student = eval_expr_ast [] ast in
  assert_equal student result ~msg:"public_expr_single_if"

let public_expr_single_let _ =
  let ast = ([], Let ("x", false, Value (Int 42), ID "x")) in
  let result = Int 42 in
  let student = eval_expr_ast [] ast in
  assert_equal student result ~msg:"public_expr_single_let"

let public_expr_single_notequal _ =
  let ast = ([], Binop (NotEqual, Value (Int 1), Value (Int 2))) in
  let result = Bool true in 
  let student = eval_expr_ast [] ast in
  assert_equal student result ~msg:"public_expr_single_notequal"

let public_expr_single_not _ =
  let ast = ([], Not (Value (Bool true))) in
  let result = Bool false in
  let student = eval_expr_ast [] ast in
  assert_equal student result ~msg:"public_expr_single_not"

let public_expr_single_number _ =
  let ast = ([], Value (Int 42)) in
  let result = Int 42 in
  let student = eval_expr_ast [] ast in
  assert_equal student result ~msg:"public_expr_single_number"
 
let public_expr_single_or _ =
  let ast = ([], Binop (Or, Value (Bool true), Value (Bool false))) in
  let result = Bool true in
  let student = eval_expr_ast [] ast in
  assert_equal student result ~msg:"public_expr_single_or"
 
let public_expr_single_string _ =
  let ast = ([], Value (String "Hello World")) in
  let result = String "Hello World" in
  let student = eval_expr_ast [] ast in
  assert_equal student result ~msg:"public_expr_single_string"

let public_err_div_by_zero _ = 
  let ast = ([], Let ("x", false, Binop (Div, Value (Int 1), Value (Int 0)), ID "x")) in
  div_by_zero_ex_handler (fun () -> eval_expr_ast [] ast)

let public_mutop_factorial _ = 
  let ast = ([], Expr (Let ("fact", true, Fun ("x",
     If (Binop (Equal, ID "x", Value (Int 1)), Value (Int 1),
      Binop (Mult, ID "x",
       FunctionCall (ID "fact", Binop (Sub, ID "x", Value (Int 1)))))),
    FunctionCall (ID "fact", Value (Int 3))))) in
  let result = ([], Some (Int 6)) in
  let student = eval_mutop_ast [] ast in
  assert_equal student result ~msg:"public_rec_function_factorial"

let public_mutop_nonempty_env _ = 
  let ast = ([], Expr
  (Let ("a", false, Value (Int 1),
    Let ("b", false, Value (Int 2),
     Binop (Add, ID "a", Binop (Add, ID "b", Binop (Add, ID "c", ID "d"))))))) in
  let result = ([("c", {contents = Int 3}); ("d", {contents = Int 4})], Some (Int 10)) in
  let student = eval_mutop_ast [("c", {contents = Int 3}); ("d", {contents = Int 4})] ast in
  assert_equal student result ~msg:"public_mutop_nonempty_env"

let public_expr_shadow _ = 
  let ast = ([],
   Let ("x", false, Value (Int 20),
    Let ("f", false, Fun ("x", Binop (Add, ID "x", Value (Int 22))),
     FunctionCall (ID "f", ID "x")))) in
  let result = Int 42 in
  let student = eval_expr_ast [] ast in
  assert_equal student result ~msg:"public_expr_shadow"

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
    "public_err_div_by_zero" >:: public_err_div_by_zero;  
    "public_mutop_factorial" >:: public_mutop_factorial;
    "public_mutop_nonempty_env" >:: public_mutop_nonempty_env;
    "public_expr_shadow" >:: public_expr_shadow;
  ]

let _ = run_test_tt_main suite