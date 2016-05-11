#!/usr/bin/env ocaml
#use "topfind"
#require "topkg"
open Topkg

let jsoo = Conf.with_pkg "js_of_ocaml"
let () =
  Pkg.describe "mtime" @@ fun c ->
  let jsoo = Conf.value c jsoo in
  Ok [ Pkg.mllib ~api:["Mtime"] "src-os/mtime.mllib" ~dst_dir:"os";
       Pkg.lib ~exts:Exts.c_library "src-os/libmtime_stubs" ~dst:"os/libmtime_stubs";
       Pkg.stublibs ~exts:Exts.c_dll_library "src-os/dllmtime_stubs";
       Pkg.lib "src-os/mtime_top_init.ml" ~dst:"os/mtime_top_init.ml";
       Pkg.mllib ~cond:jsoo ~api:["Mtime"] "src-jsoo/mtime.mllib"
         ~dst_dir:"jsoo";
       Pkg.doc "test-os/min.ml" ]
