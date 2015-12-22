(*
   Compile with:
   ocamlfind ocamlc -package mtime.os -linkpkg -o min.byte min.ml
   ocamlfind ocamlopt -package mtime.os -linkpkg -o min.native min.ml *)

let () =
  Format.printf "Elapsed: %a@." Mtime.pp_span (Mtime.elapsed ())
