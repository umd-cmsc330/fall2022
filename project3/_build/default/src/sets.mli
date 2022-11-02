val elem : 'a -> 'a list -> bool
val insert : 'a -> 'a list -> 'a list
val insert_all : 'a list -> 'a list -> 'a list
val subset : 'a list -> 'a list -> bool
val eq : 'a list -> 'a list -> bool
val remove : 'a -> 'a list -> 'a list
val minus : 'a list -> 'a list -> 'a list
val union : 'a list -> 'a list -> 'a list
val intersection : 'a list -> 'a list -> 'a list
val product : 'a list -> 'b list -> ('a * 'b) list
val diff : 'a list -> 'a list -> 'a list
val cat : 'a -> 'b list -> ('a * 'b) list
