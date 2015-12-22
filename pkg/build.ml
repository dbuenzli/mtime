#!/usr/bin/env ocaml
#directory "pkg";;
#use "topkg.ml";;

let jsoo = Env.bool "jsoo"

let () =
  Pkg.describe "mtime" ~builder:(`OCamlbuild []) [
    Pkg.lib "pkg/META";
    Pkg.lib ~exts:Exts.module_library "src-os/mtime" ~dst:"os/mtime";
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
