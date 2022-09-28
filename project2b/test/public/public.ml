open OUnit2
open TestUtils
open P2b.Data
open P2b.Funs
open P2b.Higher

let public_contains_elem _ = 
  let a = [] in
  let b = ["a";"b";"c";"d"] in
  let c = [91;2;96;42;100] in
  
  assert_equal ~printer:string_of_bool false @@ contains_elem a "hello";
  assert_equal ~printer:string_of_bool true @@ contains_elem  b "b";
  assert_equal ~printer:string_of_bool false @@ contains_elem b "z";
  assert_equal ~printer:string_of_bool true @@ contains_elem c 42;
  assert_equal ~printer:string_of_bool false @@ contains_elem c 90

let public_is_present _ = 
  let a = [] in
  let b = ["w";"x";"y";"z"] in
  let c = [14;20;42;1;81] in

  assert_equal ~printer:string_of_int_list [] @@ is_present a 123;
  assert_equal ~printer:string_of_int_list [0;0;1;0] @@ is_present b "y";
  assert_equal ~printer:string_of_int_list [0;0;0;0] @@ is_present b "v";
  assert_equal ~printer:string_of_int_list [0;0;1;0;0] @@ is_present c 42;
  assert_equal ~printer:string_of_int_list [1;0;0;0;0] @@ is_present c 14

let public_count_occ _ =
  let y = ["a";"a";"b";"a"] in
  let z = [1;7;7;1;5;2;7;7] in
  let a = [true;false;false;true;false;false;false] in
  let b = [] in

  assert_equal ~printer:string_of_int_pair (3,1) @@ (count_occ y "a", count_occ y "b");
  assert_equal ~printer:string_of_int_quad (2,4,1,1) @@ (count_occ z 1, count_occ z 7, count_occ z 5, count_occ z 2);
  assert_equal ~printer:string_of_int_pair (2,5) @@ (count_occ a true, count_occ a false);
  assert_equal ~printer:string_of_int_pair (0,0) @@ (count_occ b "a", count_occ b 1)

let public_uniq _ =
  let y = ["a";"a";"b";"a"] in
  let z = [1;7;7;1;5;2;7;7] in
  let a = [true;false;false;true;false;false;false] in
  let b = [] in
  let cmp x y = if x < y then (-1) else if x = y then 0 else 1 in

  assert_equal ~printer:string_of_string_list ["a";"b"] @@ List.sort cmp (uniq y);
  assert_equal ~printer:string_of_int_list [1;2;5;7] @@ List.sort cmp (uniq z);
  assert_equal ~printer:string_of_bool_list [false;true] @@ List.sort cmp (uniq a);
  assert_equal ~printer:string_of_int_list [] @@ uniq b

let public_assoc_list _ =
  let y = ["a";"a";"b";"a"] in
  let z = [1;7;7;1;5;2;7;7] in
  let a = [true;false;false;true;false;false;false] in
  let b = [] in
  let cmp x y = if x < y then (-1) else if x = y then 0 else 1 in

  assert_equal ~printer:string_of_string_int_pair_list [("a",3);("b",1)] @@ List.sort cmp (assoc_list y);
  assert_equal ~printer:string_of_int_pair_list [(1,2);(2,1);(5,1);(7,4)] @@ List.sort cmp (assoc_list z);
  assert_equal ~printer:string_of_bool_int_pair_list [(false,5);(true,2)] @@ List.sort cmp (assoc_list a);
  assert_equal ~printer:string_of_int_pair_list [] @@ assoc_list b

let public_ap _ =
  let x = [5;6;7;3] in
  let y = [5;6;7] in
  let z = [7;5] in
  let a = [3;5;8;10;9] in
  let b = [3] in
  let c = [] in

  let fs1 = [((+) 2) ; (( * ) 7)] in
  let fs2 = [pred] in

  assert_equal ~printer:string_of_int_list [7;8;9;5;35;42;49;21] @@ ap fs1 x;
  assert_equal ~printer:string_of_int_list [7;8;9;35;42;49] @@ ap fs1 y;
  assert_equal ~printer:string_of_int_list [9;7;49;35] @@ ap fs1 z;
  assert_equal ~printer:string_of_int_list [5;7;10;12;11;21;35;56;70;63] @@ ap fs1 a;
  assert_equal ~printer:string_of_int_list [5;21] @@ ap fs1 b;
  assert_equal ~printer:string_of_int_list [] @@ ap fs1 c;

  assert_equal ~printer:string_of_int_list (map pred x) @@ ap fs2 x;
  assert_equal ~printer:string_of_int_list (map pred y) @@ ap fs2 y;
  assert_equal ~printer:string_of_int_list (map pred z) @@ ap fs2 z;
  assert_equal ~printer:string_of_int_list (map pred a) @@ ap fs2 a;
  assert_equal ~printer:string_of_int_list (map pred b) @@ ap fs2 b;
  assert_equal ~printer:string_of_int_list (map pred c) @@ ap fs2 c

let public_int_tree_insert_and_mem _ =
  let root = int_insert 20 (int_insert 10 empty_int_tree) in
  let left = int_insert 9 (int_insert 5 root) in
  let middle = int_insert 15 (int_insert 13 left) in
  let right = int_insert 29 (int_insert 21 middle) in

  assert_equal ~printer:string_of_bool true (int_mem 10 right);
  assert_equal ~printer:string_of_bool true (int_mem 15 right);
  assert_equal ~printer:string_of_bool true (int_mem 20 right);
  assert_equal ~printer:string_of_bool true (int_mem 5 right)


let public_int_tree_insert_and_size _ =
  let root = int_insert 20 (int_insert 10 empty_int_tree) in
  let left = int_insert 9 (int_insert 5 root) in
  let middle = int_insert 15 (int_insert 13 left) in
  let right = int_insert 29 (int_insert 21 middle) in

  assert_equal ~printer:string_of_int 8 (int_size right);
  assert_equal ~printer:string_of_int 6 (int_size middle);
  assert_equal ~printer:string_of_int 4 (int_size left);
  assert_equal ~printer:string_of_int 2 (int_size root)

let public_int_tree_insert_and_max _ =
  let root = int_insert 20 (int_insert 10 empty_int_tree) in
  let left = int_insert 9 (int_insert 5 root) in
  let middle = int_insert 15 (int_insert 13 left) in
  let right = int_insert 29 (int_insert 21 middle) in
  
  assert_equal ~printer:string_of_int 29 (int_max right);
  assert_equal ~printer:string_of_int 20 (int_max middle)

let public_tree_map_put_and_get _ =
  let t0 = empty_tree_map in
  let t1 = map_put 5 "a" t0 in
  let t2 = map_put 3 "b" t1 in
  let t3 = map_put 1 "c" t2 in
  let t4 = map_put 13 "d" t3 in

  assert_equal ~printer:string_of_string "a" (map_get 5 t1);
  assert_equal ~printer:string_of_string "b" (map_get 3 t2);
  assert_equal ~printer:string_of_string "c" (map_get 1 t4)

let public_var _ =
  let t = push_scope empty_table in
  let t = add_var "x" 3 t in
  let t = add_var "y" 4 t in
  let t = add_var "asdf" 14 t in
  assert_equal 3 (lookup "x" t) ~msg:"public_var (1)";
  assert_equal 4 (lookup "y" t) ~msg:"public_var (2)";
  assert_equal 14 (lookup "asdf" t) ~msg:"public_var (3)";
  assert_raises (Failure ("Variable not found!")) (fun () -> lookup "z" t) ~msg:"public_var (2)"

let public_scopes _ =
  let a = push_scope empty_table in
  let a = add_var "a" 10 a in
  let a = add_var "b" 40 a in
  let b = push_scope a in
  let b = add_var "a" 20 b in
  let b = add_var "c" 30 b in
  let c = pop_scope b in
  assert_equal 10 (lookup "a" c) ~msg:"public_scopes (1)";
  assert_equal 40 (lookup "b" c) ~msg:"public_scopes (2)";
  assert_equal 20 (lookup "a" b) ~msg:"public_scopes (3)";
  assert_equal 30 (lookup "c" b) ~msg:"public_scopes (4)";
  assert_raises (Failure ("Variable not found!")) (fun () -> lookup "c" c) ~msg:"public_scopes (5)"

let suite =
  "public" >::: [
    "is_elem" >:: public_contains_elem;
    "is_present" >:: public_is_present; 
    "count_occ" >:: public_count_occ;
    "uniq" >:: public_uniq;
    "assoc_list" >:: public_assoc_list;
    "ap" >:: public_ap;
    "insert_and_max" >:: public_int_tree_insert_and_max;
    "int_tree_insert_and_mem" >:: public_int_tree_insert_and_mem;
    "int_tree_insert_and_size" >:: public_int_tree_insert_and_size;
    "tree_map_put_and_get" >:: public_tree_map_put_and_get;
    "var" >:: public_var;
    "scopes" >:: public_scopes
  ]

let _ = run_test_tt_main suite
