open MicroCamlTypes
open TokenTypes

let string_of_token (t : token) : string = match t with
  | Tok_Sub -> "Tok_Sub"
  | Tok_RParen -> "Tok_RParen"
  | Tok_Add -> "Tok_Add"
  | Tok_Or -> "Tok_Or"
  | Tok_NotEqual -> "Tok_NotEqual"
  | Tok_Not -> "Tok_Not"
  | Tok_Mult -> "Tok_Mult"
  | Tok_LessEqual -> "Tok_LessEqual"
  | Tok_Less -> "Tok_Less"
  | Tok_LParen -> "Tok_LParen"
  | Tok_Int(i) -> "Tok_Int(" ^ (string_of_int i) ^ ")"
  | Tok_If -> "Tok_If"
  | Tok_ID(id) -> "Tok_ID(\"" ^ id ^ "\")"
  | Tok_String(s) -> "Tok_String(\"" ^ s ^ "\")"
  | Tok_GreaterEqual -> "Tok_GreaterEqual"
  | Tok_Greater -> "Tok_Greater"
  | Tok_Equal -> "Tok_Equal"
  | Tok_Then -> "Tok_Then"
  | Tok_Else -> "Tok_Else"
  | Tok_Div -> "Tok_Div"
  | Tok_Bool(b) -> "Tok_Bool(" ^ (string_of_bool b) ^ ")"
  | Tok_And -> "Tok_And"
  | Tok_Concat -> "Tok_Concat"
  | Tok_Let -> "Tok_Let"
  | Tok_Def -> "Tok_Def"
  | Tok_In -> "Tok_In"
  | Tok_Rec -> "Tok_Rec"
  | Tok_Arrow -> "Tok_Arrow"
  | Tok_Fun -> "Tok_Fun"
  | Tok_DoubleSemi -> "Tok_DoubleSemi"

let string_of_list ?newline:(newline=false) (f : 'a -> string) (l : 'a list) : string =
  "[" ^ (String.concat ", " @@ List.map f l) ^ "]" ^ (if newline then "\n" else "");;

let rec string_of_value (v : value) : string =
  match v with
  | Int(n) -> "Int " ^ string_of_int n
  | Bool(b) -> "Bool " ^ string_of_bool b
  | String(s) -> "String \"" ^ s ^ "\""
  | Closure(env, s, e) -> 
      "Closure(" ^ string_of_list (fun (v, v') -> "(" ^ v ^ ", " ^ string_of_value v' ^ ")") env ^ ", " ^ s ^ ", " ^ string_of_expr e ^ ")"

and string_of_expr (e : expr) : string =
  let unparse_two (s : string) (e1 : expr) (e2 : expr) =
    s ^ "(" ^ string_of_expr e1 ^ ", " ^ string_of_expr e2 ^ ")"
  in
  match e with
  | Value(v) -> string_of_value v
  | ID(s) -> "ID \"" ^ s ^ "\""
  | Fun(s, e) -> "Fun(" ^ s ^ ", " ^ string_of_expr e ^ ")"

  | Binop(Add, e1, e2) -> unparse_two "Add" e1 e2
  | Binop(Sub, e1, e2) -> unparse_two "Sub" e1 e2
  | Binop(Mult, e1, e2) -> unparse_two "Mult" e1 e2
  | Binop(Div, e1, e2) -> unparse_two "Div" e1 e2

  | Binop(Concat, e1, e2) -> unparse_two "Concat" e1 e2

  | Binop(Greater, e1, e2) -> unparse_two "Greater" e1 e2
  | Binop(Less, e1, e2) -> unparse_two "Less" e1 e2
  | Binop(GreaterEqual, e1, e2) -> unparse_two "GreaterEqual" e1 e2
  | Binop(LessEqual, e1, e2) -> unparse_two "LessEqual" e1 e2

  | Binop(Equal, e1, e2) -> unparse_two "Equal" e1 e2
  | Binop(NotEqual, e1, e2) -> unparse_two "NotEquals" e1 e2

  | Binop(Or, e1, e2) -> unparse_two "Or" e1 e2
  | Binop(And, e1, e2) -> unparse_two "Add" e1 e2
  | Not(e) -> "Not(" ^ string_of_expr e ^ ")"
  | FunctionCall(e1, e2) -> unparse_two "FunctionCall" e1 e2

  | If(e1, e2, e3) -> "If(" ^ string_of_expr e1 ^ ", " ^ string_of_expr e2 ^ ", " ^ string_of_expr e3 ^ ")"
  | Let(s, r, e1, e2) -> "Let(" ^ s ^ ", " ^ string_of_bool r ^ "," ^ string_of_expr e1 ^ ", " ^ string_of_expr e2 ^ ")"

and string_of_mutop (m: mutop) : string =
  match m with
  | Def(s, e) -> "Def(" ^ s ^ ", " ^ string_of_expr e ^ ")"
  | Expr(e) -> "Expr(" ^ string_of_expr e ^ ")"
  | NoOp -> "NoOp"

(**********************************
 * BEGIN ACTUAL PARSE HELPER CODE *
 **********************************)

let string_of_in_channel (ic : in_channel) : string =
  let lines : string list =
    let try_read () =
      try Some ((input_line ic) ^ "\n") with End_of_file -> None in
    let rec loop acc = match try_read () with
      | Some s -> loop (s :: acc)
      | None -> List.rev acc in
    loop []
  in

  List.fold_left (fun a e -> a ^ e) "" @@ lines

let tokenize_from_channel (c : in_channel) : token list =
  Lexer.tokenize @@ string_of_in_channel c

let tokenize_from_file (filename : string) : token list =
  let c = open_in filename in
  let s = tokenize_from_channel c in
  close_in c;
  s