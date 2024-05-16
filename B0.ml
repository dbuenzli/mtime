open B0_kit.V000
open Result.Syntax

(* OCaml library names *)

let compiler_libs_toplevel = B0_ocaml.libname "compiler-libs.toplevel"

let mtime = B0_ocaml.libname "mtime"
let mtime_top = B0_ocaml.libname "mtime.top"
let mtime_clock = B0_ocaml.libname "mtime.clock"
let mtime_clock_os = B0_ocaml.libname "mtime.clock.os"

let b0_std = B0_ocaml.libname "b0.std"

(* Libraries *)

let mtime_lib =
  let srcs = [`File ~/"src/mtime.mli"; `File ~/"src/mtime.ml"] in
  B0_ocaml.lib mtime ~doc:"The mtime library" ~srcs

let mtime_top =
  let srcs = [`File ~/"src/mtime_top.ml"] in
  let requires = [compiler_libs_toplevel] in
  let wrap proc b = (* TODO b0: this should be easier *)
    let m = B0_build.memo b in
    let dir = B0_build.current_dir b in
    let init = B0_build.in_scope_dir b ~/"src/mtime_top_init.ml" in
    B0_memo.ready_file m init;
    ignore (B0_memo.copy_to_dir m init ~dir);
    proc b
  in
  B0_ocaml.lib mtime_top ~wrap ~doc:"The mtime.top library" ~srcs ~requires

let mtime_clock =
  let srcs = [`File ~/"src/mtime_clock.mli"] in
  let requires = [mtime] in
  let doc = "The mtime.clock interface library" in
  B0_ocaml.lib mtime_clock ~doc ~srcs ~requires

let mtime_clock_os_lib =
  let srcs = [`Dir ~/"src-clock"] in
  let requires = [mtime] in
  let doc = "The mtime.clock library (including JavaScript support)" in
  B0_ocaml.lib mtime_clock_os ~doc ~srcs ~requires

(* Tests *)

let test =
  let srcs = [`File ~/"test/test.ml"] in
  let meta = B0_meta.(empty |> tag test |> tag run) in
  let requires = [b0_std; mtime; mtime_clock_os ] in
  B0_ocaml.exe "test" ~doc:"Test suite" ~srcs ~meta ~requires

let min_clock =
  let srcs = [`File ~/"test/min_clock.ml"] in
  let meta = B0_meta.(empty |> tag test |> tag run) in
  let requires = [mtime; mtime_clock_os] in
  let doc = "Minimal clock example" in
  B0_ocaml.exe "min-clock" ~doc ~srcs ~meta ~requires

let min_clock_jsoo =
  let srcs = Fpath.[`File (v "test/min_clock.ml") ] in
  let meta = B0_meta.(empty |> tag test) in
  let requires = [mtime; mtime_clock_os] in
  let doc = "Minimal clock example" in
  B0_jsoo.html_page "min-clock-jsoo" ~requires ~doc ~srcs ~meta

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
