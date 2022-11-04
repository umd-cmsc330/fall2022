(* Provided definitions - DO NOT MODIFY *)

type op = Add | Sub | Mult | Div | Concat | Greater | Less | GreaterEqual | LessEqual | Equal | NotEqual | Or | And

type var = string

type value =
  | Int of int
  | Bool of bool
  | String of string
  | Closure of environment * var * expr

and environment = (var * value ref) list

and expr =
  | Value of value
  | ID of var
  | Fun of var * expr
  | Not of expr
  | Binop of op * expr * expr
  | If of expr * expr * expr
  | FunctionCall of expr * expr
  | Let of var * bool * expr * expr

type mutop = 
  | Def of var * expr
  | Expr of expr
  | NoOp