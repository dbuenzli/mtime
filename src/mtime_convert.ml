(*---------------------------------------------------------------------------
   Copyright (c) 2015 Daniel C. Bünzli. All rights reserved.
   Distributed under the BSD3 license, see license at the end of the file.
   %%NAME%% release %%VERSION%%
  ---------------------------------------------------------------------------*)

type scale = [ `Ns | `Mus | `Ms | `S  | `Min | `Hour | `Day | `Year ]

let s_in_ns  = 1e-9
let s_in_mus = 1e-6
let s_in_ms  = 1e-3
let s_in_min = 60.
let s_in_h   = 3600.
let s_in_d   = 86_400.
let s_in_y   = 31_536_000.

let s_to_ns  = 1e9
let s_to_mus = 1e6
let s_to_ms  = 1e3
let s_to_min = 1. /. s_in_min
let s_to_h   = 1. /. s_in_h
let s_to_d   = 1. /. s_in_d
let s_to_y   = 1. /. s_in_y

let span_s_to = function
| `Ns   -> fun s -> s_to_ns *. s
| `Mus  -> fun s -> s_to_mus *. s
| `Ms   -> fun s -> s_to_ms *. s
| `S    -> fun s -> s
| `Min  -> fun s -> s_to_min *. s
| `Hour -> fun s -> s_to_h *. s
| `Day  -> fun s -> s_to_d *. s
| `Year -> fun s -> s_to_y *. s

let span_s_of = function
| `Ns   -> fun s -> s_in_ns *. s
| `Mus  -> fun s -> s_in_mus *. s
| `Ms   -> fun s -> s_in_ms *. s
| `S    -> fun s -> s
| `Min  -> fun s -> s_in_min *. s
| `Hour -> fun s -> s_in_h *. s
| `Day  -> fun s -> s_in_d *. s
| `Year -> fun s -> s_in_y *. s

let ns_in_mus = 1_000L
let ns_in_ms  = 1_000_000L
let ns_in_s   = 1_000_000_000L
let ns_in_min = 60_000_000_000L
let ns_in_h   = 3600_000_000_000L
let ns_in_d   = 86_400_000_000_000L
let ns_in_y   = 31_536_000_000_000_000L

let span_ns_to = function
| `Ns   -> fun s -> s
| `Mus  -> fun s -> Int64.div s ns_in_mus
| `Ms   -> fun s -> Int64.div s ns_in_ms
| `S    -> fun s -> Int64.div s ns_in_s
| `Min  -> fun s -> Int64.div s ns_in_min
| `Hour -> fun s -> Int64.div s ns_in_h
| `Day  -> fun s -> Int64.div s ns_in_d
| `Year -> fun s -> Int64.div s ns_in_y

let span_ns_of = function
| `Ns   -> fun s -> s
| `Mus  -> fun s -> Int64.mul s ns_in_mus
| `Ms   -> fun s -> Int64.mul s ns_in_ms
| `S    -> fun s -> Int64.mul s ns_in_s
| `Min  -> fun s -> Int64.mul s ns_in_min
| `Hour -> fun s -> Int64.mul s ns_in_h
| `Day  -> fun s -> Int64.mul s ns_in_d
| `Year -> fun s -> Int64.mul s ns_in_y

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
