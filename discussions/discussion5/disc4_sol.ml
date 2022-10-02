(* Tuple concatenation *)

let concat lst = 
  map (fun x -> match x with 
                | (y,z) -> y^z) lst

(* Average *)

let length lst = 
  fold (fun a x -> a+1) 0 lst

let sum lst = 
  fold (a x -> a+x) 0 lst

let average lst = 
  (sum lst) / (length lst)

(* Sentence formation *)

let sentence lst = 
  fold (fun a x -> a^x) "" (concat lst)

(* Index *)

let index lst elem = 
  let value = 
    fold (fun a x -> match a with
                    | (a,b) -> if elem = b then (x,b+1) else (a,b+1)) 
          (0,0) lst in 
  match value with
  | (a,b) -> a

(* Zip *)

let get_nums lst = fold (a x -> a @ length a) [] lst

let zip a b = map (fun x -> (index a x, index b x)) (get_nums a)

(* List Difference *)

let diff lsta lstb = 
  map (fun a x-> match a with
                | (b,c) -> b-c)) 
      (zip lsta lstb)