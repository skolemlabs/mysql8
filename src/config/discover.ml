open Configurator.V1
open C_define
open Flags

let ccopt s = [ "-ccopt"; s ]
let cclib s = [ "-cclib"; s ]
let value_of_bool = function
  | true -> Value.Int 1
  | false -> Value.Int 0

let execute_with_output cmd =
  let ic = Unix.open_process_in cmd in
  let rec get_output str =
    try
      let line = input_line ic in
      get_output (str ^ line ^ "\n")
    with
    | _ ->
      close_in ic;
      ( match String.length str - 1 with
      | -1
      | 0 ->
        None
      | l -> Some (String.sub str 0 l)
      )
  in
  get_output ""

let mysql_config_path =
  match execute_with_output "which mysql_config" with
  | Some str -> str
  | None ->
    failwith "Unable to find mysql_config, please make sure it's in your path."

let c_flags =
  match execute_with_output (mysql_config_path ^ " --cflags") with
  | Some str -> (String.split_on_char ' ' str) @ ["-fPIC"]
  | None -> []

let libs =
  match execute_with_output (mysql_config_path ^ " --libs") with
  | Some str -> String.split_on_char ' ' str
  | None -> []

let replace_exact rep _with str =
  Str.global_replace (Str.regexp_string rep) _with str

let headers_to_test =
  [
    "inttypes.h";
    "memory.h";
    "mysql.h";
    "mysql/mysql.h";
    "stdint.h";
    "stdlib.h";
    "strings.h";
    "string.h";
    "sys/stat.h";
    "sys/types.h";
    "unistd.h";
  ]

let generate_config_h t =
  let c_flags = c_flags @ [ "-c" ] in
  let test_header str =
    let prog = Printf.sprintf {|
#include <%s>

int main(void) {}
    |} str in

    let compiles = c_test t ~c_flags prog in
    let value = value_of_bool compiles in
    let definition =
      "HAVE_"
      ^ (str
        |> replace_exact "/" "_"
        |> replace_exact "." "_"
        |> String.uppercase_ascii
        )
    in
    (definition, value)
  in
  let defs = headers_to_test |> List.map test_header in
  gen_header_file ~fname:"config.h" t defs

let _ =
  main ~name:"mysql8" (fun t ->
      write_sexp "c_flags.sexp" c_flags;
      write_sexp "libs.sexp" libs;
      generate_config_h t
  )
