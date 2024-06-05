(*---------------------------------------------------------------------------
   Copyright (c) 2017 The mtime programmers. All rights reserved.
   SPDX-License-Identifier: ISC
  ---------------------------------------------------------------------------*)

(* Raw interface *)

external elapsed_ns : unit -> int64 = "ocaml_mtime_clock_elapsed_ns"
external now_ns : unit -> int64 = "ocaml_mtime_clock_now_ns"
external period_ns : unit -> int64 option = "ocaml_mtime_clock_period_ns"

let () = ignore (elapsed_ns ()) (* Initalize elapsed_ns's origin. *)

(* Monotonic clock *)

let elapsed () = Mtime.Span.of_uint64_ns (elapsed_ns ())
let now () = Mtime.of_uint64_ns (now_ns ())
let period () = Mtime.Span.unsafe_of_uint64_ns_option (period_ns ())

(* Counters *)

type counter = int64
let counter = elapsed_ns
let count c = Mtime.Span.of_uint64_ns (Int64.sub (elapsed_ns ()) c)
