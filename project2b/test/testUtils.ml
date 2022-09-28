open OUnit2
open P2b.Data

let assert_true x = assert_equal true x
let assert_false x = assert_equal false x

let string_of_string s = s

let string_of_list f xs =
  "[" ^ (String.concat "; " (List.map f xs)) ^ "]"

let string_of_pair f g (x, y) =
  "(" ^ (f x) ^ ", " ^ (g y) ^ ")"

let string_of_option f o = 
  match o with
  |Some v -> (f v)
  |None -> "None"

let string_of_int_pair = string_of_pair string_of_int string_of_int
let string_of_string_int_pair = string_of_pair (fun x -> x) string_of_int
let string_of_bool_int_pair = string_of_pair string_of_bool string_of_int
let string_of_float_int_pair = string_of_pair string_of_float string_of_int

let string_of_int_triple _ _ _ (x, y, z) =
  "(" ^ (string_of_int x) ^ ", " ^ (string_of_int y) ^ ", " ^ (string_of_int z) ^ ")"
let string_of_int_quad (x, y, z, a) =
  "(" ^ (string_of_int x) ^ ", " ^ (string_of_int y) ^ ", " ^ (string_of_int z) ^ ", " ^ (string_of_int a) ^ ")"

let string_of_int_list = string_of_list string_of_int
let string_of_int_pair_list = string_of_list string_of_int_pair
let string_of_bool_list = string_of_list string_of_bool
let string_of_float_list = string_of_list string_of_float
let string_of_bool_int_pair_list = string_of_list string_of_bool_int_pair
let string_of_string_int_pair_list = string_of_list string_of_string_int_pair
let string_of_float_int_pair_list = string_of_list string_of_float_int_pair
let string_of_string_list = string_of_list (fun x -> x)
let string_of_string_list_list = (string_of_list (string_of_list (fun x -> x)))
let string_of_string_option = string_of_option (fun x -> x)
let string_of_string_list_option = string_of_option string_of_string_list

let rec list_of_int_tree t = 
  match t with
    |IntLeaf -> []
    |IntNode (f, Some s, l, m, r) -> (list_of_int_tree l) @ [f] @ (list_of_int_tree m) @ [s] @ (list_of_int_tree r)
    |IntNode (f, None, l, m, r) -> (list_of_int_tree l) @ [f] @ (list_of_int_tree m) @ (list_of_int_tree r) 
    (*|_ -> failwith "Empty node found"*)

let rec list_of_tree_map_keys m =
  match m with
    | MapLeaf -> []
    | MapNode ((k, _), None, l, m, r) -> (list_of_tree_map_keys l) @ [k] @ (list_of_tree_map_keys m) @ (list_of_tree_map_keys r)
    | MapNode ((k1, _), Some (k2, _), l, m, r) -> (list_of_tree_map_keys l) @ [k1] @ (list_of_tree_map_keys m) @ [k2] @ (list_of_tree_map_keys r)
  (*
    | MapNode ((, Some (_, _)), _, _, _) -> failwith "Unbalanced tree_map node @ tree_map_keys"
    | MapNode ((None, None), _, _, _) -> failwith "Empty tree_map node @ tree_map_keys"
*)

let rec list_of_tree_map_values m =
  match m with
    | MapLeaf -> []
    | MapNode ((_, v), None, l, m, r) -> (list_of_tree_map_values l) @ [v] @ (list_of_tree_map_values m) @ (list_of_tree_map_values r)
    | MapNode ((_, v1), Some (_, v2), l, m, r) -> (list_of_tree_map_values l) @ [v1] @ (list_of_tree_map_values m) @ [v2] @ (list_of_tree_map_values r)
(*    | MapNode ((None, Some (_, _)), _, _, _) -> failwith "Unbalanced tree_map node @ tree_map_values"
    | MapNode ((None, None), _, _, _) -> failwith "Empty tree_map node @ tree_map_values"
    *)
