type 'a tree = 
  | Leaf 
  | Node of 'a tree * 'a * 'a tree

let rec map f xs = 
  match xs with
      [] -> []
    | h::t -> (f h)::(map f t)

let rec fold f a lst =
    match lst with
    []->a
    |h::t->fold f (f a h) t

let rec fold_right f lst a =
    match lst with
    []->a
    |h::t-> f h (fold_right f t a)

let rec map_tree f t =
  match t with
  | Leaf           -> Leaf
  | Node (l, v, r) -> let new_l = map_tree f l in
      let new_r = map_tree f r in
      Node (new_l, f v, new_r)


let rec fold_tree f b t =
  match t with
  | Leaf           -> b
  | Node (l, v, r) -> let res_l = fold_tree f b l in
      let res_r = fold_tree f b r in
      f res_l v res_r


let add1 tree = map_tree (fun x -> x + 1) tree

let sum tree = fold_tree (fun x l r -> x + l + r) 0 tree

let test_tree = Node(Node(Leaf, 4, Leaf), 5, Node(Leaf, 2, Leaf)) ;;
    
sum test_tree;;

let test2 = add1 test_tree;;