open MicroCamlTypes
open TokenTypes

val parse_expr : token list -> (token list * expr)
val parse_mutop : token list -> (token list * mutop)