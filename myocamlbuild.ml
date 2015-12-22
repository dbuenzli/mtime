
open Ocamlbuild_plugin
open Command

let os = Ocamlbuild_pack.My_unix.run_and_read "uname -s"

let system_support_lib = match os with
| "Linux\n" -> [A "-cclib"; A "-lrt"]
| _ -> []

let () =
  dispatch begin fun d ->
    Ocamlbuild_js_of_ocaml.dispatcher d;
    match d with
    | After_rules ->
        flag ["link"; "library"; "ocaml"; "byte"; "use_mtime"]
          (S ([A "-dllib"; A "-lmtime_stubs"] @ system_support_lib));
        flag ["link"; "library"; "ocaml"; "native"; "use_mtime"]
          (S ([A "-cclib"; A "-lmtime_stubs"] @ system_support_lib));
        flag ["link"; "ocaml"; "link_mtime"]
          (A "src-os/libmtime_stubs.a");
        dep ["link"; "ocaml"; "use_mtime"]
          ["src-os/libmtime_stubs.a"];
    | _ -> ()
  end
