(*---------------------------------------------------------------------------
   Copyright (c) 2015 Daniel C. Bünzli. All rights reserved.
   Distributed under the BSD3 license, see license at the end of the file.
   %%NAME%% release %%VERSION%%
  ---------------------------------------------------------------------------*)

(* Time spans

   In this backend time spans are in nanoseconds and we represent them
   by an unsigned 64-bit integer. This allows to represent spans for:
   (2^64-1) / 1_000_000_000 / (24 * 3600 * 365.25) ≅ 584.5 Julian years *)

type span = int64 (* unsigned nanoseconds *)

(* Passing time *)

external elapsed : unit -> span = "ocaml_mtime_elapsed_ns"
let available = elapsed () <> 0L

(* Counters *)

type counter = span
let counter = elapsed
let count c = Int64.sub (elapsed ()) c

(* Time scale conversion and pretty printers *)

include Mtime_base

let to_ns_uint64 ns = ns
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
