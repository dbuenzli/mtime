(*---------------------------------------------------------------------------
   Copyright (c) 2015 Daniel C. Bünzli. All rights reserved.
   Distributed under the ISC license, see terms at the end of the file.
   %%NAME%% %%VERSION%%
  ---------------------------------------------------------------------------*)

let log f = Format.printf (f ^^ "@.")

let test_available () =
  if Mtime.available then log "Monotonic time available !" else
  log "[WARNING] no monotonic time available !"

let count = ref 0
let fail = ref 0
let test f v =
  incr count;
  try f v with
  | Failure _ | Assert_failure _ as exn ->
      let bt = Printexc.get_backtrace () in
      incr fail; log "[ERROR] %s@.%s" (Printexc.to_string exn) bt

let log_result () =
  if !fail = 0 then log "[OK] All %d tests passed !" !count else
  log "[FAIL] %d failure(s) out of %d" !fail !count;
  ()

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

let test_pp_span_s () =
  (* N.B. this test may fail as it may be sensitive to black art of
     floating point formatting. Also note that ties on negative
     numbers round towards positive infinity, i.e. -0.5 rounds to 0. *)
  log "Testing Mtime.pp_span_s";
  let pp s = Format.asprintf "%a" Mtime.pp_span_s s in
  let eq_str s s' = if s <> s' then failwith (Printf.sprintf "%S <> %S" s s') in
  (* sub ns scale *)
  eq_str (pp 1.0e-10) "0us";
  eq_str (pp ~-.1.0e-10) "0us";
  eq_str (pp 4.0e-10) "0us";
  eq_str (pp ~-.4.0e-10) "0us";
  eq_str (pp 6.0e-10) "0.001us";
  eq_str (pp ~-.6.0e-10) "-0.001us";
  eq_str (pp 9.0e-10) "0.001us";
  eq_str (pp ~-.9.0e-10) "-0.001us";
  (* ns scale *)
  eq_str (pp 2.0e-9) "0.002us";
  eq_str (pp ~-.2.0e-9) "-0.002us";
  eq_str (pp 2.136767676e-9) "0.002us";
  eq_str (pp ~-.2.136767676e-9) "-0.002us";
  eq_str (pp 2.6e-9) "0.003us";
  eq_str (pp ~-.2.6e-9) "-0.003us";
  eq_str (pp 2.836767676e-9) "0.003us";
  eq_str (pp ~-.2.836767676e-9) "-0.003us";
  (* us scale *)
  eq_str (pp 2.0e-6) "2us";
  eq_str (pp ~-.2.0e-6) "-2us";
  eq_str (pp 2.555e-6) "2.555us";
  eq_str (pp ~-.2.555e-6) "-2.555us";
  eq_str (pp 2.5556e-6) "2.556us";
  eq_str (pp ~-.2.5556e-6) "-2.556us";
  eq_str (pp 99.9994e-6) "99.999us";
  eq_str (pp ~-.99.9994e-6) "-99.999us";
  eq_str (pp 99.9996e-6) "100us";
  eq_str (pp ~-.99.9996e-6) "-100us";
  eq_str (pp 100.1555e-6) "100us";
  eq_str (pp ~-.100.1555e-6) "-100us";
  eq_str (pp 100.5555e-6) "101us";
  eq_str (pp ~-.100.5555e-6) "-101us";
  eq_str (pp 100.6555e-6) "101us";
  eq_str (pp ~-.100.6555e-6) "-101us";
  eq_str (pp 999.4e-6) "999us";
  eq_str (pp ~-.999.4e-6) "-999us";
  eq_str (pp 999.6e-6) "1ms";
  eq_str (pp ~-.999.6e-6) "-1ms";
  (* ms scale *)
  eq_str (pp 1e-3) "1ms";
  eq_str (pp ~-.1e-3) "-1ms";
  eq_str (pp 1.555e-3) "1.555ms";
  eq_str (pp ~-.1.555e-3) "-1.555ms";
  eq_str (pp 1.5556e-3) "1.556ms";
  eq_str (pp ~-.1.5556e-3) "-1.556ms";
  eq_str (pp 99.9994e-3) "99.999ms";
  eq_str (pp ~-.99.9994e-3) "-99.999ms";
  eq_str (pp 99.9996e-3) "100ms";
  eq_str (pp ~-.99.9996e-3) "-100ms";
  eq_str (pp 100.1555e-3) "100ms";
  eq_str (pp ~-.100.1555e-3) "-100ms";
  eq_str (pp 100.5555e-3) "101ms";
  eq_str (pp ~-.100.5555e-3) "-101ms";
  eq_str (pp 100.6555e-3) "101ms";
  eq_str (pp ~-.100.6555e-3) "-101ms";
  eq_str (pp 999.4e-3) "999ms";
  eq_str (pp ~-.999.4e-3) "-999ms";
  eq_str (pp 999.6e-3) "1s";
  eq_str (pp ~-.999.6e-3) "-1s";
  (* s scale *)
  eq_str (pp 1.) "1s";
  eq_str (pp ~-.1.) "-1s";
  eq_str (pp 1.555) "1.555s";
  eq_str (pp ~-.1.555) "-1.555s";
  eq_str (pp 1.5554) "1.555s";
  eq_str (pp ~-.1.5554) "-1.555s";
  eq_str (pp 1.5556) "1.556s";
  eq_str (pp ~-.1.5556) "-1.556s";
  eq_str (pp 59.) "59s";
  eq_str (pp ~-.59.) "-59s";
  eq_str (pp 59.9994) "59.999s";
  eq_str (pp ~-.59.9994) "-59.999s";
  eq_str (pp 59.9996) "1min";
  eq_str (pp ~-.59.9996) "-1min";
  (* min scale *)
  eq_str (pp 60.) "1min";
  eq_str (pp ~-.60.) "-1min";
  eq_str (pp 62.) "1min2s";
  eq_str (pp ~-.62.) "-1min2s";
  eq_str (pp 62.4) "1min2s";
  eq_str (pp ~-.62.4) "-1min2s";
  eq_str (pp 3599.) "59min59s";
  eq_str (pp ~-.3599.) "-59min59s";
  (* hour scale *)
  eq_str (pp 3600.0) "1h";
  eq_str (pp ~-.3600.0) "-1h";
  eq_str (pp 3629.0) "1h";
  eq_str (pp ~-.3629.0) "-1h";
  eq_str (pp 3660.0) "1h1min";
  eq_str (pp ~-.3660.0) "-1h1min";
  eq_str (pp 7164.0) "1h59min";
  eq_str (pp ~-.7164.0) "-1h59min";
  eq_str (pp 7200.0) "2h";
  eq_str (pp ~-.7200.0) "-2h";
  eq_str (pp 86399.) "23h59min";
  eq_str (pp ~-.86399.) "-23h59min";
  (* day scale *)
  eq_str (pp 86400.) "1d";
  eq_str (pp ~-.86400.) "-1d";
  eq_str (pp (86400. +. (23. *. 3600.))) "1d23h";
  eq_str (pp ~-.(86400. +. (23. *. 3600.))) "-1d23h";
  eq_str (pp (86400. +. (24. *. 3600.))) "2d";
  eq_str (pp ~-.(86400. +. (24. *. 3600.))) "-2d";
  eq_str (pp (365.25 *. 86_400. -. 1.)) "365d5h";
  eq_str (pp ~-.(365.25 *. 86_400. -. 1.)) "-365d5h";
  (* year scale *)
  eq_str (pp (31557600.)) "1a";
  eq_str (pp ~-.(365.25 *. 86_400.)) "-1a";
  eq_str (pp (365.25 *. 86_400. +. 86400.)) "1a1d";
  eq_str (pp ~-.(365.25 *. 86_400. +. 86400.)) "-1a1d";
  eq_str (pp (365.25 *. 2. *. 86_400.)) "2a";
  eq_str (pp ~-.(365.25 *. 2. *. 86_400.)) "-2a";
  eq_str (pp (365.25 *. 2. *. 86_400. -. 1.)) "1a365d";
  eq_str (pp ~-.(365.25 *. 2. *. 86_400. -. 1.)) "-1a365d";
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
    log " * Count to % 8d: % 10Luns %.10fs %a"
      max span_ns span_s Mtime.pp_span span
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
  log " * Elapsed: %Luns %gs %a"
    (Mtime.to_ns_uint64 span) (Mtime.to_s span) Mtime.pp_span span;
  ()

let test_system_now () =
  log "Test Mtime.System.now_{s,ns}";
  let t = Mtime.System.now () in
  let span = Mtime.System.(span t (of_ns_uint64 0_L)) in
  log " * System: %Luns %gs %a"
    (Mtime.System.to_ns_uint64 t) (Mtime.to_s span) Mtime.System.pp t;
  ()

let run () =
  test test_available ();
  test test_secs_in ();
  test test_pp_span_s ();
  test test_counters ();
  test test_elapsed ();
  test test_system_now ();
  log_result ();
  exit !fail

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
