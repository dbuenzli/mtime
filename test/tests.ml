(*---------------------------------------------------------------------------
   Copyright (c) 2015 Daniel C. Bünzli. All rights reserved.
   Distributed under the BSD3 license, see license at the end of the file.
   %%NAME%% release %%VERSION%%
  ---------------------------------------------------------------------------*)

let log f = Format.printf (f ^^ "@.")

let test_available () =
  if Mtime.available then log "Monotonic time available !" else
  log "[WARNING] no monotonic time available !"

let test_convert_s () =
  log "Testing Mtime.span_s_{to,of}";
  let assert_float f f' = assert (abs_float (f -. f') < 1e-9) in
  let scale_secs =
    [ `Ns,   1e-9;
      `Mus,  1e-6;
      `Ms,   1e-3;
      `S,    1.;
      `Min,  60.;
      `Hour, 60. *. 60.;
      `Day,  24. *. 60. *. 60.;
      `Year, 365. *. 24. *. 60. *. 60.; ]
  in
  let assert_scale (scale, scale_secs) =
    assert_float (Mtime.span_s_to scale scale_secs) 1.;
    assert_float (Mtime.span_s_of scale 1.) scale_secs;
  in
  List.iter assert_scale scale_secs;
  ()

let test_convert_ns () =
  log "Testing Mtime.span_ns_{to,of}";
  log "Testing Mtime.span_s_{to,of}";
  let scale_ns =
    [ `Ns,  1L;
      `Mus, 1_000L;
      `Ms,  1_000_000L;
      `S,   1_000_000_000L;
      `Min, Int64.mul 60L 1_000_000_000L;
      `Hour, Int64.(mul 60L (mul 60L 1_000_000_000L));
      `Day, Int64.(mul 24L (mul 60L (mul 60L 1_000_000_000L)));
      `Year, Int64.(mul 365L (mul 24L (mul 60L (mul 60L 1_000_000_000L))))];
  in
  let assert_scale (scale, scale_ns) =
    assert (Mtime.span_ns_to scale scale_ns = 1L);
    assert (Mtime.span_ns_of scale 1L = scale_ns);
  in
  List.iter assert_scale scale_ns;
  ()

let test_counters () =
  log "Test counters";
  let count_s max =
    let c = Mtime.counter () in
    for i = 1 to max do () done;
    Mtime.count_s c
  in
  let count_ns max =
    let c = Mtime.counter () in
    for i = 1 to max do () done;
    Mtime.count_ns c
  in
  let do_count max =
    log " * Count to % 8d: %6Luns %.10fs"
      max (count_ns max) (count_s max)
  in
  do_count 1;
  do_count 10;
  do_count 100;
  do_count 1000;
  do_count 10000;
  do_count 100000;
  do_count 1000000;
  ()

let test_elapsed () =
  log "Test Mtime.elapsed_{s,ns}";
  log "Elapsed: %gs" (Mtime.elapsed_s ());
  log "Elapsed: %Luns" (Mtime.elapsed_ns ());
  ()

let run () =
  try
    test_available ();
    test_convert_s ();
    test_convert_ns ();
    test_counters ();
    test_elapsed ();
    log "[OK] All test passed !";
    ()
  with Assert_failure _ ->
    let bt = Printexc.get_backtrace () in
    log "[ERROR] %s" bt;
    log "[FAIL] A test failed.";
    exit 1

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
