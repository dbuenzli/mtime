(*---------------------------------------------------------------------------
   Copyright (c) 2015 Daniel C. Bünzli. All rights reserved.
   Distributed under the BSD3 license, see license at the end of the file.
   %%NAME%% release %%VERSION%%
  ---------------------------------------------------------------------------*)

let log f = Format.printf (f ^^ "@.")

let test_available () =
  if Mtime.available then log "Monotonic time available !" else
  log "[WARNING] no monotonic time available !"

let test_secs_in () =
  log "Testing Mtime.{s_to_*,*_to_s}";
  let equalf f f' = abs_float (f -. f') < 1e-9 in
  assert (Mtime.ns_to_s = 1e-9);
  assert (Mtime.us_to_s = 1e-6);
  assert (Mtime.ms_to_s = 1e-3);
  assert (Mtime.min_to_s = 60.);
  assert (Mtime.hour_to_s = (60. *. 60.));
  assert (Mtime.day_to_s = (24. *. 60. *. 60.));
  assert (Mtime.year_to_s = (365.25 *. 24. *. 60. *. 60.));
  assert (equalf (Mtime.s_to_ns *. 1e-9) 1.);
  assert (equalf (Mtime.s_to_us *. 1e-6) 1.);
  assert (equalf (Mtime.s_to_ms *. 1e-3) 1.);
  assert (equalf (Mtime.s_to_min *. 60.) 1.);
  assert (equalf (Mtime.s_to_hour *. (60. *. 60.)) 1.);
  assert (equalf (Mtime.s_to_day *. (24. *. 60. *. 60.)) 1.);
  assert (equalf (Mtime.s_to_year *. (365.25 *. 24. *. 60. *. 60.)) 1.);
  ()

let test_counters () =
  log "Test counters";
  let count max =
    let c = Mtime.counter () in
    for i = 1 to max do () done;
    Mtime.count c
  in
  let do_count max =
    let span = count max in
    let span_ns = Mtime.to_ns_uint64 span in
    let span_s = Mtime.to_s span in
    log " * Count to % 8d: % 10Luns %.10fs" max span_ns span_s
  in
  do_count 1000000;
  do_count 100000;
  do_count 10000;
  do_count 1000;
  do_count 100;
  do_count 10;
  do_count 1;
  ()

let test_elapsed () =
  log "Test Mtime.elapsed_{s,ns}";
  let span = Mtime.elapsed () in
  log " * Elapsed: %Luns %gs" (Mtime.to_ns_uint64 span) (Mtime.to_s span);
  ()

let run () =
  try
    test_available ();
    test_secs_in ();
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
