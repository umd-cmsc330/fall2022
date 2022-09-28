type int_tree =
  | IntLeaf
  | IntNode of int * int option * int_tree * int_tree * int_tree 
val empty_int_tree: int_tree
val int_insert: int -> int_tree -> int_tree
val int_mem: int -> int_tree -> bool
val int_size: int_tree -> int
val int_max: int_tree -> int

type 'a tree_map =
  | MapLeaf
  | MapNode of (int * 'a) * (int * 'a) option * 'a tree_map * 'a tree_map * 'a tree_map
val empty_tree_map: 'a tree_map
val map_put: int -> 'a -> 'a tree_map -> 'a tree_map
val map_contains: int -> 'a tree_map -> bool
val map_get: int -> 'a tree_map -> 'a

type lookup_table
val empty_table : lookup_table
val push_scope : lookup_table -> lookup_table
val pop_scope : lookup_table -> lookup_table
val add_var : string -> int -> lookup_table -> lookup_table
val lookup : string -> lookup_table -> int
