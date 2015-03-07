(*---------------------------------------------------------------------------
   Copyright (c) 2015 Daniel C. Bünzli. All rights reserved.
   Distributed under the BSD3 license, see license at the end of the file.
   %%NAME%% release %%VERSION%%
  ---------------------------------------------------------------------------*)

(* Time spans *)

type span_ms = float
type span_s = float
type span_ns = int64

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

let elapsed_ms () = now_ms () -. start_ms
let elapsed_s () = elapsed_ms () /. 1000.
let elapsed_ns () = Int64.(of_float (elapsed_ms () *. 1_000_000.))

(* Counters *)

type counter = span_ms
let counter = elapsed_ms
let count_ms c = elapsed_ms () -. c
let count_s c = (count_ms c) /. 1000.
let count_ns c = Int64.(of_float (count_ms c *. 1_000_000.))

(* Converting time spans *)

include Mtime_convert

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
