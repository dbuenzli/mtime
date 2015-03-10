(*---------------------------------------------------------------------------
   Copyright (c) 2015 Daniel C. Bünzli. All rights reserved.
   Distributed under the BSD3 license, see license at the end of the file.
   %%NAME%% release %%VERSION%%
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
  let has_perf = (Js.Unsafe.coerce Dom_html.window) ## performance in
  match Js.Optdef.to_option has_perf with
  | None -> false, now_ms_unavailable
  | Some p ->
      match (Js.Unsafe.coerce p) ## now with
      | None -> false, now_ms_unavailable
      | Some n ->
          true,
          fun () -> (Js.Unsafe.coerce Dom_html.window) ## performance ## now ()

let start_ms = now_ms ()

let elapsed () = now_ms () -. start_ms

(* Counters *)

type counter = span
let counter = elapsed
let count c = elapsed () -. c

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
   Copyright (c) 2015 Daniel C. Bünzli.
   All rights reserved.

   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions
   are met:

   1. Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.

   2. Redistributions in binary form must reproduce the above
      copyright notice, this list of conditions and the following
      disclaimer in the documentation and/or other materials provided
      with the distribution.

   3. Neither the name of Daniel C. Bünzli nor the names of
      contributors may be used to endorse or promote products derived
      from this software without specific prior written permission.

   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
   "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
   A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
   OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
   SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
   LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
   DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
   THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
   (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
   OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  ---------------------------------------------------------------------------*)
