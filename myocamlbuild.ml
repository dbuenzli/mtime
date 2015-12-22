
open Ocamlbuild_plugin
open Command

let os = Ocamlbuild_pack.My_unix.run_and_read "uname -s"

let system_support_lib = match os with
| "Linux\n" -> [A "-cclib"; A "-lrt"]
| _ -> []

let js_rule () =
  let dep = "%.byte" in
  let prod = "%.js" in
  let f env _ =
    let dep = env dep in
    let prod = env prod in
    let tags = tags_of_pathname prod ++ "js_of_ocaml" in
    Cmd (S [A "js_of_ocaml"; T tags; A "-o";
            Px prod; P dep])
  in
  rule "js_of_ocaml: .byte -> .js" ~dep ~prod f

let () =
  dispatch begin function
  | After_rules ->
      js_rule ();
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
