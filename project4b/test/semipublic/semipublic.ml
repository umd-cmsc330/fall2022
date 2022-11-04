open OUnit2
open TestUtils
open P4b.MicroCamlTypes

let semipublic_infinite_sanity _ =
  let ast = ([], Def ("f", Fun ("x", FunctionCall (ID "f", ID "x")))) in 
  let _, student = eval_mutop_ast [] ast in
  match student with
  | Some (Closure (env, _, _)) -> 
      (try assert_equal (Some (lookup env "f")) student with
      | Out_of_memory -> assert_succeed ()
      | _ -> assert_failure "Expected to be infinite loop")
  | _ -> assert_failure "Incorrect evaluation"

let semipublic_fibonacci _ = 
  let ast = ([],
  Let ("fib", true,
   Fun ("x",
    If
     (Binop (Or, Binop (Equal, ID "x", Value (Int 1)),
       Binop (Equal, ID "x", Value (Int 2))),
     Value (Int 1),
     Binop (Add, FunctionCall (ID "fib", Binop (Sub, ID "x", Value (Int 1))),
      FunctionCall (ID "fib", Binop (Sub, ID "x", Value (Int 2)))))),
   FunctionCall (ID "fib", Value (Int 6)))) in
  let student = eval_expr_ast [] ast in
  let result = Int 8 in
  assert_equal student result ~msg:"semipublic_fibonacci"

let semipublic_hello_n_times _ =
  let ast = ([],
  Let ("hellontimes", true,
   Fun ("n",
    If (Binop (Equal, ID "n", Value (Int 0)), Value (String ""),
     Binop (Concat, Value (String "Hello! "),
      FunctionCall (ID "hellontimes", Binop (Sub, ID "n", Value (Int 1)))))),
   FunctionCall (ID "hellontimes", Value (Int 5)))) in
  let student = eval_expr_ast [] ast in
  let result = String "Hello! Hello! Hello! Hello! Hello! " in
  assert_equal student result ~msg:"semipublic_hello_n_times"

let semipublic_nested_rec _ =
  let ast = ([],
  Let ("f", true,
   Fun ("x",
    Let ("g", true,
     Fun ("y",
      If (Binop (Equal, ID "x", Value (Int 0)),
       If (Binop (Equal, ID "y", Value (Int 0)), Value (Int 0),
        FunctionCall (ID "g", Binop (Sub, ID "y", Value (Int 1)))),
       FunctionCall (ID "f", Binop (Sub, ID "x", Value (Int 1))))),
     FunctionCall (ID "g", Value (Int 5)))),
   FunctionCall (ID "f", Value (Int 5)))) in
  let student = eval_expr_ast [] ast in
  let result = Int 0 in
  assert_equal student result ~msg:"semipublic_nested_rec"

let semipublic_not_function _ = 
  let ast = ([], FunctionCall (Value (Int 1), Value (Int 1))) in
  type_error_ex_handler (fun () -> eval_expr_ast [] ast)

let semipublic_declare_error _ = 
  let ast = ([],
 Let ("f", false, Fun ("y", ID "x"),
  Let ("x", false, Value (Int 1), FunctionCall (ID "f", Value (Int 0))))) in
  declare_error_ex_handler (fun () -> eval_expr_ast [] ast)
 
let semipublic_type_error _ = 
  let ast = ([],
   Let ("f", false, Fun ("x", Binop (Add, ID "x", Value (Int 1))),
    Let ("g", false, Fun ("y", Binop (Add, ID "y", Value (Int 1))),
     If (Binop (NotEqual, ID "f", ID "g"), Value (Bool true),
      If (Binop (Equal, ID "f", ID "g"), Value (Bool true), Value (Bool false)))))) in
  type_error_ex_handler (fun () -> eval_expr_ast [] ast)

let semipublic_conditional_boolean_only _ = 
  let ast = ([],
   If (Value (Int 1), Value (Bool true),
    If (Value (String "hello"), Value (Bool true), Value (Bool false)))) in
  type_error_ex_handler (fun () -> eval_expr_ast [] ast)

let semipublic_call_by_value _ =
  let ast = ([],
   Let ("f", false, Fun ("x", Fun ("y", ID "x")),
    FunctionCall (FunctionCall (ID "f", Value (Int 0)), ID "z"))) in
  declare_error_ex_handler (fun () -> eval_expr_ast [] ast)

let semipublic_lazy_branch _ = 
  let ast = ([],
   Let ("inf", true, Fun ("x", FunctionCall (ID "inf", ID "x")),
    If (Value (Bool true), Value (Int 0),
     FunctionCall (ID "inf", Value (Int 0))))) in
  let student = eval_expr_ast [] ast in
  let result = Int 0 in
  assert_equal student result ~msg:"semipublic_lazy_branch"

(* Church numerals *)
let church_init =
  let churchzero = ([], Def ("churchzero", Fun ("f", Fun ("x", ID "x")))) in
  let churchone = ([], Def ("churchone", Fun ("f", Fun ("x", FunctionCall (ID "f", ID "x"))))) in
  let churchsucc = ([],
    Def ("churchsucc",
      Fun ("n",
        Fun ("f",
          Fun ("x",
            FunctionCall (ID "f",
              FunctionCall (FunctionCall (ID "n", ID "f"), ID "x"))))))) in
  let churchadd = ([],
    Def ("churchadd",
      Fun ("n",
        Fun ("m",
          Fun ("f",
            Fun ("x",
              FunctionCall (FunctionCall (ID "n", ID "f"),
                FunctionCall (FunctionCall (ID "m", ID "f"), ID "x")))))))) in
  let churchmult = ([], 
    Def ("churchmult",
      Fun ("n",
        Fun ("m",
          FunctionCall
            (FunctionCall (ID "n", FunctionCall (ID "churchadd", ID "m")),
            ID "churchzero"))))) in
  let churchexp = ([], 
    Def ("churchexp",
      Fun ("n",
        Fun ("m",
          FunctionCall
            (FunctionCall (ID "m", FunctionCall (ID "churchmult", ID "n")),
            ID "churchone"))))) in
  let toint = ([],
    Def ("toint",
      Fun ("n",
        FunctionCall
          (FunctionCall (ID "n", Fun ("i", Binop (Add, ID "i", Value (Int 1)))),
          Value (Int 0))))) in
  let fromint = ([],
    Def ("fromint",
      Fun ("i",
        If (Binop (Equal, ID "i", Value (Int 0)), ID "churchzero",
          FunctionCall (ID "churchsucc",
            FunctionCall (ID "fromint", Binop (Sub, ID "i", Value (Int 1)))))))) in
  let env, _ = eval_mutop_ast [] churchzero in
  let env, _ = eval_mutop_ast env churchone in
  let env, _ = eval_mutop_ast env churchsucc in
  let env, _ = eval_mutop_ast env churchadd in
  let env, _ = eval_mutop_ast env churchmult in
  let env, _ = eval_mutop_ast env churchexp in 
  let env, _ = eval_mutop_ast env toint in
  let env, _ = eval_mutop_ast env fromint in
  env

let semipublic_church_add _ = 
  let call = ([],
    Expr
      (FunctionCall (ID "toint",
        Let ("x", false, FunctionCall (ID "fromint", Value (Int 3)),
          Let ("y", false, FunctionCall (ID "fromint", Value (Int 5)),
            FunctionCall (FunctionCall (ID "churchadd", ID "x"), ID "y")))))) in
  let _, student = eval_mutop_ast church_init call in
  let result = Some (Int 8) in
  assert_equal student result ~msg:"semipublic_church_add"

let semipublic_church_sanity _ =
  let call = ([], 
    Expr (If (Binop (Equal,
      FunctionCall (ID "toint",
        FunctionCall
          (FunctionCall (ID "churchmult",
            FunctionCall (ID "fromint", Value (Int 4))),
          FunctionCall (ID "fromint", Value (Int 8)))),
      FunctionCall (ID "toint",
        FunctionCall
          (FunctionCall (ID "churchexp", FunctionCall (ID "fromint", Value (Int 2))),
        FunctionCall (ID "fromint", Value (Int 5))))),
      Value (Bool true), Value (Bool false)))) in
  let _, student = eval_mutop_ast church_init call in
  let result = Some (Bool true) in
  assert_equal student result ~msg:"semipublic_church_sanity"

let suite = 
  "semipublic" >::: [
    "semipublic_fibonacci" >:: semipublic_fibonacci;
    "semipublic_hello_n_times" >:: semipublic_hello_n_times;
    "semipublic_nested_rec" >:: semipublic_nested_rec;
    "semipublic_not_function" >:: semipublic_not_function;
    "semipublic_declare_error" >:: semipublic_declare_error;  
    "semipublic_type_error" >:: semipublic_type_error;
    "semipublic_conditional_boolean_only" >:: semipublic_conditional_boolean_only;
    "semipublic_call_by_value" >:: semipublic_call_by_value;  
    "semipublic_lazy_branch" >:: semipublic_lazy_branch;  
    "semipublic_infinite_sanity" >:: semipublic_infinite_sanity;
    "semipublic_church_add" >:: semipublic_church_add;
    "semipublic_church_sanity" >:: semipublic_church_sanity;  
  ]

let _ = run_test_tt_main suite
