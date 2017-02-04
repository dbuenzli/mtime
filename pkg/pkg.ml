#!/usr/bin/env ocaml
#use "topfind"
#require "topkg"
open Topkg

let jsoo = Conf.with_pkg "js_of_ocaml"

let () =
  Pkg.describe "mtime" @@ fun c ->
  let jsoo = Conf.value c jsoo in
  Ok [ Pkg.mllib ~api:["Mtime"] "src-os/mtime.mllib" ~dst_dir:"os/";
       Pkg.clib "src-os/libmtime_stubs.clib" ~lib_dst_dir:"os/";
       Pkg.mllib ~api:[] "src-os/mtime_top.mllib" ~dst_dir:"os/";
       Pkg.lib "src-os/mtime_top_init.ml" ~dst:"os/";
       Pkg.mllib ~cond:jsoo ~api:["Mtime"] "src-jsoo/mtime.mllib"
         ~dst_dir:"jsoo";
       Pkg.test "test-os/min";
       Pkg.test "test-os/test";
       Pkg.test ~run:false ~cond:jsoo ~auto:false "test-jsoo/test_jsoo.js";
       Pkg.test ~run:false ~cond:jsoo ~auto:false "test-jsoo/test_jsoo.html";
       Pkg.doc "test-os/min.ml" ]
