open MicroCamlTypes

exception TypeError of string
exception DeclareError of string
exception DivByZeroError

val eval_expr: environment -> expr -> value
val eval_mutop: environment -> mutop -> environment * value option
