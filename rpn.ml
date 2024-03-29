open Tokenize

(* operate : String op -> String f1 -> String f2 -> String result *)
let operate op f1 f2 = match op with
  | "+" -> string_of_float(float_of_string f1 +. float_of_string f2)
  | "-" -> string_of_float(float_of_string f1 -. float_of_string f2)
  | "*" -> string_of_float(float_of_string f1 *. float_of_string f2)
  | "/" -> string_of_float(float_of_string f1 /. float_of_string f2)
  | "^" -> string_of_float(float_of_string f1 ** float_of_string f2)
  | _   -> "1.0"

(* rpn : [Token] -> [Token] -> [Token] *)
let rec rpn numbers unread = match unread with
  | [] -> 
    if List.length numbers > 1  then 
      print_endline "Error: not enough operators.";
      numbers
  | Tokenize.Op (op)::xs ->  
      if (List.length numbers == 1) then (
        (* Stack has only 1 operand. Print error. *)
        let Tokenize.Value (operand) = List.hd numbers in
        print_endline ("Error: Missing operand in subexpression: "^operand^" "^op);
        numbers @ unread
      ) else if (List.length numbers < 1) then (
        (* Stack is empty. Print error. *)
        print_endline ("Error: No operands available for operator: " ^ op);
        numbers @ unread
      ) else (
        (* Operate on top 2 elems from list, push to list, and recurse on altered list *)
        let Tokenize.Value (operand1) = List.hd numbers in
        let Tokenize.Value (operand2) = List.hd (List.tl numbers) in
        let numbers2 = (Tokenize.Value (operate op operand2 operand1) )::(List.tl (List.tl numbers)) in
        let unread2 = xs in
        rpn numbers2 unread2
      ) (* end ELSE *)
  | _  -> 
        let numbers2 = (List.hd unread) :: numbers in
        let unread2 = List.tl unread in
        rpn numbers2 unread2
