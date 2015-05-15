
open Ocamlbuild_plugin
open Command

let os = Ocamlbuild_pack.My_unix.run_and_read "uname -s"

let byte_librt, native_librt = match os with
| "Linux\n" -> [A "-dllib"; A "-lrt"], [A "-cclib"; A "-lrt"]
| _ -> [], []

let () =
  dispatch begin fun d ->
    Ocamlbuild_js_of_ocaml.dispatcher d;
    match d with
    | After_rules ->
        flag ["link"; "library"; "ocaml"; "byte"; "use_mtime"]
          (S ([A "-dllib"; A "-lmtime_stubs"] @ byte_librt));
        flag ["link"; "library"; "ocaml"; "native"; "use_mtime"]
          (S ([A "-cclib"; A "-lmtime_stubs"] @ native_librt));
        flag ["link"; "ocaml"; "link_mtime"]
          (A "src-os/libmtime_stubs.a");
        dep ["link"; "ocaml"; "use_mtime"]
          ["src-os/libmtime_stubs.a"];
    | _ -> ()
  end
