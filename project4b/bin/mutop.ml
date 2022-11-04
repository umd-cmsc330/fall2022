open P4b.MicroCamlTypes
open P4b.Utils
open P4b.Parser
open P4b.Lexer
open P4b.Eval

let end_r = Str.string_match (Str.regexp {|.*;;$|});;
let exit_r = Str.string_match (Str.regexp {|^exit;;$|});;
(* Set this to false if you want to turn off the coloring *)
let use_color = true;;

let green_str st = if use_color then Printf.sprintf "\027[0;32m%s\027[0m" st else st
let red_str st = if use_color then Printf.sprintf "\027[1;31m%s\027[0m" st else st
let alternative_str st = if use_color then Printf.sprintf "\027[0;36m%s\027[0m" st else st
let get_top_constname = function
  | [] -> ""
  | (constname, _)::_ -> constname

let are_top_envs_equal env1 env2 = 
 ((List.length env1) == (List.length env2)) && ((get_top_constname env1) == (get_top_constname env2))

let mutop_to_string optional_val constname is_same_env = 
  match optional_val with
 | Some Closure (_, _, _) -> Printf.sprintf "val %s : <fun>\n" constname
 | Some value -> Printf.sprintf "%s%s\n" (if is_same_env then "- : val: " else (Printf.sprintf "val %s = " constname))(string_of_value value)
 | None -> ""

let rec line_reader text = 
  let str_inpt = read_line () in
  let new_text = text ^ "\n" ^ str_inpt in
  if end_r str_inpt 0 || exit_r str_inpt 0 then  
    if exit_r str_inpt 0 then 
      (text, str_inpt)
    else
      ((String.sub new_text 0 ((String.length new_text))), str_inpt)
  else
    line_reader new_text

let rec run_cli statements environment = 
    let _ = print_string (alternative_str "mutop " ^ green_str "# ") in
    let (str_inpt, last_input) = line_reader "" in
    if exit_r last_input 0 then 
      (statements, environment)
    else
      try 
        let (_, stms) = parse_mutop(tokenize str_inpt) in
        let (final_env, mutop_val) = eval_mutop environment stms in
        let _ = print_string (mutop_to_string mutop_val (get_top_constname final_env) (are_top_envs_equal environment final_env)) in
        if exit_r last_input 0 then 
          (statements, environment)
        else
          run_cli (statements@[str_inpt]) (final_env@environment)
      with e -> (
        let msg = Printexc.to_string e in
        let t = String.split_on_char '.' msg in
        let t = List.nth t (List.length t - 1) in
        let p = String.index t '(' + 1 in
        let p' = String.index t ')' - p in
        let err = String.sub t 0 (p-1) in
        let err' = String.sub t p p' in
        let text = Printf.sprintf "%s: %s\n" err err' in
        print_string (red_str text);
        run_cli (statements) (environment));;
run_cli [] [];;
