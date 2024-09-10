open B0_kit.V000
open Result.Syntax

(* OCaml library names *)

let b0_std = B0_ocaml.libname "b0.std"
let compiler_libs_toplevel = B0_ocaml.libname "compiler-libs.toplevel"

let mtime = B0_ocaml.libname "mtime"
let mtime_clock = B0_ocaml.libname "mtime.clock"
let mtime_clock_os = B0_ocaml.libname "mtime.clock.os"
let mtime_top = B0_ocaml.libname "mtime.top"

(* Libraries *)

let mtime_lib =
  let srcs = [`Dir ~/"src"; `X ~/"src/mtime_top_init.ml"] in
  B0_ocaml.lib mtime ~srcs

let mtime_clock_lib =
  let srcs = [`Dir ~/"src/clock"] in
  B0_ocaml.lib mtime_clock ~srcs ~requires:[mtime] ~exports:[mtime]

let mtime_clock_os_lib =
  B0_ocaml.deprecated_lib ~exports:[mtime_clock] mtime_clock_os

let mtime_top =
  let srcs = [`Dir ~/"src/top"] in
  B0_ocaml.lib mtime_top ~srcs ~requires:[mtime; compiler_libs_toplevel]

(* Tests *)

let test_mtime =
  let requires = [b0_std; mtime] in
  B0_ocaml.test ~/"test/test_mtime.ml" ~requires ~doc:"Mtime tests"

let test_mtime_clock =
  let requires = [b0_std; mtime; mtime_clock] in
  B0_ocaml.test ~/"test/test_mtime_clock.ml" ~requires ~doc:"Mtime_clock tests"

let min_clock =
  let doc = "Minimal clock example" in
  let requires = [mtime; mtime_clock] in
  B0_ocaml.test ~/"test/min_clock.ml" ~run:false ~requires ~doc

let min_clock_jsoo =
  let doc = "Minimal clock example in JavaScript" in
  let srcs = Fpath.[`File (v "test/min_clock.ml") ] in
  let meta = B0_meta.(empty |> tag test) in
  let requires = [mtime; mtime_clock] in
  B0_jsoo.html_page "min-clock-jsoo" ~srcs ~requires ~meta ~doc

(* Packs *)

let default =
  let meta =
    B0_meta.empty
    |> ~~ B0_meta.authors ["The mtime programmers"]
    |> ~~ B0_meta.maintainers ["Daniel Bünzli <daniel.buenzl i@erratique.ch>"]
    |> ~~ B0_meta.homepage "https://erratique.ch/software/mtime"
    |> ~~ B0_meta.online_doc "https://erratique.ch/software/mtime/doc/"
    |> ~~ B0_meta.licenses ["ISC"]
    |> ~~ B0_meta.repo "git+https://erratique.ch/repos/mtime.git"
    |> ~~ B0_meta.issues "https://github.com/dbuenzli/mtime/issues"
    |> ~~ B0_meta.description_tags
      ["time"; "monotonic"; "system"; "org:erratique"]
    |> B0_meta.add B0_opam.depends
      [ "ocaml", {|>= "4.08.0"|};
        "ocamlfind", {|build|};
        "ocamlbuild", {|build & != "0.9.0"|};
        "topkg", {|build & >= "1.0.3"|};
      ]
    |> B0_meta.add B0_opam.build
      {|[["ocaml" "pkg/pkg.ml" "build" "--dev-pkg" "%{dev}%"]]|}
    |> B0_meta.tag B0_opam.tag
    |> B0_meta.tag B0_release.tag
  in
  B0_pack.make "default" ~doc:"mtime package" ~meta ~locked:true @@
  B0_unit.list ()
