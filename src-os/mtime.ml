(*---------------------------------------------------------------------------
   Copyright (c) 2015 Daniel C. Bünzli. All rights reserved.
   Distributed under the ISC license, see terms at the end of the file.
   %%NAME%% %%VERSION%%
  ---------------------------------------------------------------------------*)

(* Time spans

   In this backend time spans are in nanoseconds and we represent them
   by an unsigned 64-bit integer. This allows to represent spans for:
   (2^64-1) / 1_000_000_000 / (24 * 3600 * 365.25) ≅ 584.5 Julian years *)

type t = int64 (* unsigned nanoseconds *)
type span = t

(* Passing time *)

external elapsed : unit -> span = "ocaml_mtime_elapsed_ns"
let available = elapsed () <> 0L

(* Counters *)

type counter = span
let counter = elapsed
let count c = Int64.sub (elapsed ()) c

(* Comparisons *)

let equal = Int64.equal
(* TODO: unsigned *)
let compare = Int64.compare

(* Time scale conversion and pretty printers *)

include Mtime_base

let to_ns_uint64 ns = ns
let of_ns_uint64 ns = ns

let to_ns ns = (Int64.to_float ns)
let to_us ns = (Int64.to_float ns) *. 1e-3
let to_ms ns = (Int64.to_float ns) *. 1e-6
let to_s  ns = (Int64.to_float ns) *. 1e-9

let ns_to_min = ns_to_s *. s_to_min
let to_min ns = (Int64.to_float ns) *. ns_to_min

let ns_to_hour = ns_to_s *. s_to_hour
let to_hour ns = (Int64.to_float ns) *. ns_to_hour

let ns_to_day = ns_to_s *. s_to_day
let to_day ns = (Int64.to_float ns) *. ns_to_day

let ns_to_year = ns_to_s *. s_to_year
let to_year ns = (Int64.to_float ns) *. ns_to_year

let pp_span ppf ns = pp_span_s ppf (to_s ns)

(* System time *)
module System = struct
  type t = int64

  external now : unit -> span = "ocaml_mtime_system_now_ns"

  let equal = Int64.equal

  (* TODO: unsigned *)
  let compare = Int64.compare

  (* TODO: unsigned *)
  let is_earlier t ~than = compare t than < 0

  (* TODO: unsigned *)
  let is_later t ~than = compare t than > 0

  (* TODO: unsigned *)
  let span t t' = Int64.(abs (sub t t'))

  (* TODO: detect overflow *)
  let add_span t s = Some (Int64.add t s)

  (* TODO: detect underflow *)
  let sub_span t s = Some (Int64.sub t s)

  let to_ns_uint64 ns = ns

  let of_ns_uint64 ns = ns

  let pp = pp_span
end

(*---------------------------------------------------------------------------
   Copyright (c) 2015 Daniel C. Bünzli

   Permission to use, copy, modify, and/or distribute this software for any
   purpose with or without fee is hereby granted, provided that the above
   copyright notice and this permission notice appear in all copies.

   THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
   WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
   MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
   ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
   WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
   ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
   OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  ---------------------------------------------------------------------------*)
