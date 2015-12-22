#!/usr/bin/env ocaml
#directory "pkg";;
#use "topkg.ml";;

let jsoo = Env.bool "jsoo"

let builder =
  if not jsoo
  then `OCamlbuild (* FIXME this doesn't work, the plugin is still mentioned
                      in myocamlbuild.ml *)
  else
 `Other
    ("ocamlbuild -use-ocamlfind -classic-display \
                 -plugin-tag \"package(js_of_ocaml.ocamlbuild)\"",
     "_build")

let () =
  Pkg.describe "mtime" ~builder [
    Pkg.lib "pkg/META";
    Pkg.lib ~exts:Exts.module_library "src-os/mtime"
      ~dst:"os/mtime";
    Pkg.lib ~exts:Exts.c_library "src-os/libmtime_stubs"
      ~dst:"os/libmtime_stubs";
    Pkg.stublibs ~exts:Exts.c_dll_library "src-os/dllmtime_stubs";
    Pkg.lib ~exts:Exts.library "src-os/mtime_top" ~dst:"os/mtime_top";
    Pkg.lib "src-os/mtime_top_init.ml" ~dst:"os/mtime_top_init.ml";
    Pkg.lib ~cond:jsoo ~exts:Exts.module_library "src-jsoo/mtime"
      ~dst:"jsoo/mtime" ;
    Pkg.doc "README.md";
    Pkg.doc "CHANGES.md";
    Pkg.doc "test-os/min.ml" ]
