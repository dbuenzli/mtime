
open Ocamlbuild_plugin
open Command

let () =
  dispatch begin fun d ->
    Ocamlbuild_js_of_ocaml.dispatcher d;
    match d with
    | After_rules ->
        flag ["link"; "library"; "ocaml"; "byte"; "use_mtime"]
          (S [A "-dllib"; A "-lmtime_stubs"; A "-dllib"; A "-lrt";]);
        flag ["link"; "library"; "ocaml"; "native"; "use_mtime"]
          (S [A "-cclib"; A "-lmtime_stubs"; A "-cclib"; A "-lrt";]);
        flag ["link"; "ocaml"; "link_mtime"]
          (A "src-os/libmtime_stubs.a");
        dep ["link"; "ocaml"; "use_mtime"]
          ["src-os/libmtime_stubs.a"];
    | _ -> ()
  end
