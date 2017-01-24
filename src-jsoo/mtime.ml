(*---------------------------------------------------------------------------
   Copyright (c) 2015 Daniel C. Bünzli. All rights reserved.
   Distributed under the ISC license, see terms at the end of the file.
   %%NAME%% %%VERSION%%
  ---------------------------------------------------------------------------*)

(* Time spans

   In this backend time spans are in millseconds and we represent
   them by a double floating point number. This corresponds to
   what performance.now () gives us

   See http://www.w3.org/TR/hr-time/#sec-DOMHighResTimeStamp. *)

type span = float (* milliseconds *)

(* Passing time *)

let now_ms_unavailable () = 0.
let available, now_ms =
  let has_perf = Js.Unsafe.get Dom_html.window "performance" in
  match Js.Optdef.to_option has_perf with
  | None -> false, now_ms_unavailable
  | Some p ->
      match Js.Unsafe.get p "now" with
      | None -> false, now_ms_unavailable
      | Some n ->
          true, fun () -> Js.Unsafe.meth_call p "now" [||]

let start_ms = now_ms ()

let elapsed () = now_ms () -. start_ms

(* Counters *)

type counter = span
let counter = elapsed
let count c = elapsed () -. c

(* Operators *)

let compare (x : float) (y : float) = Pervasives.compare x y

(* Time scale conversion and pretty printers *)

include Mtime_base

let to_ns_uint64 ms = Int64.(of_float (ms *. 1_000_000.))
let to_ns ms = ms *. 1_000_000.
let to_us ms = ms *. 1_000.
let to_ms ms = ms
let to_s  ms = ms *. 1e-3

let ms_to_s = 1e-3

let ms_to_min = ms_to_s *. s_to_min
let to_min ms = ms *. ms_to_min

let ms_to_hour = ms_to_s *. s_to_hour
let to_hour ms = ms *. ms_to_hour

let ms_to_day = ms_to_s *. s_to_day
let to_day ms = ms *. ms_to_day

let ms_to_year = ms_to_s *. s_to_year
let to_year ms = ms *. ms_to_year

let pp_span ppf ms = pp_span_s ppf (to_s ms)

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
