(*---------------------------------------------------------------------------
   Copyright (c) 2015 The mtime programmers. All rights reserved.
   SPDX-License-Identifier: ISC
  ---------------------------------------------------------------------------*)

open B0_testing

let test_pp_span =
  Test.test "Mtime.pp_span" @@ fun () ->
  (* The floating point stuff here comes from the previous incarnations
     of the formatter. Let's keep that it exercices a bit the of_float_ns. *)
  let pp s =
    let s = Option.get (Mtime.Span.of_float_ns (s *. 1e+9)) in
    Format.asprintf "%a" Mtime.Span.pp s
  in
  (* sub ns scale *)
  Test.string ~__POS__ (pp 1.0e-10) "0ns";
  Test.string ~__POS__ (pp 4.0e-10) "0ns";
  Test.string ~__POS__ (pp 6.0e-10) "0ns";
  Test.string ~__POS__ (pp 9.0e-10) "0ns";
  (* ns scale *)
  Test.string ~__POS__ (pp 2.0e-9) "2ns";
  Test.string ~__POS__ (pp 2.136767676e-9) "2ns";
  Test.string ~__POS__ (pp 2.6e-9) "2ns";
  Test.string ~__POS__ (pp 2.836767676e-9) "2ns";
  (* us scale *)
  Test.string ~__POS__ (pp 2.0e-6) "2μs";
  Test.string ~__POS__ (pp 2.555e-6) "2.56μs";
  Test.string ~__POS__ (pp 2.5556e-6) "2.56μs";
  Test.string ~__POS__ (pp 99.9994e-6) "100μs";
  Test.string ~__POS__ (pp 99.9996e-6) "100μs";
  Test.string ~__POS__ (pp 100.1555e-6) "101μs";
  Test.string ~__POS__ (pp 100.5555e-6) "101μs";
  Test.string ~__POS__ (pp 100.6555e-6) "101μs";
  Test.string ~__POS__ (pp 999.4e-6) "1ms";
  Test.string ~__POS__ (pp 999.6e-6) "1ms";
  (* ms scale *)
  Test.string ~__POS__ (pp 1e-3) "1ms";
  Test.string ~__POS__ (pp 1.555e-3) "1.56ms";
  Test.string ~__POS__ (pp 1.5556e-3) "1.56ms";
  Test.string ~__POS__ (pp 99.9994e-3) "100ms";
  Test.string ~__POS__ (pp 99.9996e-3) "100ms";
  Test.string ~__POS__ (pp 100.1555e-3) "101ms";
  Test.string ~__POS__ (pp 100.5555e-3) "101ms";
  Test.string ~__POS__ (pp 100.6555e-3) "101ms";
  Test.string ~__POS__ (pp 999.4e-3) "1s";
  Test.string ~__POS__ (pp 999.6e-3) "1s";
  (* s scale *)
  Test.string ~__POS__ (pp 1.) "1s";
  Test.string ~__POS__ (pp 1.555) "1.56s";
  Test.string ~__POS__ (pp 1.5554) "1.56s";
  Test.string ~__POS__ (pp 1.5556) "1.56s";
  Test.string ~__POS__ (pp 59.) "59s";
  Test.string ~__POS__ (pp 59.9994) "1min";
  Test.string ~__POS__ (pp 59.9996) "1min";
  (* min scale *)
  Test.string ~__POS__ (pp 60.) "1min";
  Test.string ~__POS__ (pp 62.) "1min2s";
  Test.string ~__POS__ (pp 62.4) "1min3s";
  Test.string ~__POS__ (pp 3599.) "59min59s";
  (* hour scale *)
  Test.string ~__POS__ (pp 3600.0) "1h";
  Test.string ~__POS__ (pp 3629.0) "1h1min";
  Test.string ~__POS__ (pp 3660.0) "1h1min";
  Test.string ~__POS__ (pp 7164.0) "2h";
  Test.string ~__POS__ (pp 7200.0) "2h";
  Test.string ~__POS__ (pp 86399.) "1d";
  (* day scale *)
  Test.string ~__POS__ (pp 86400.) "1d";
  Test.string ~__POS__ (pp (86400. +. (23. *. 3600.))) "1d23h";
  Test.string ~__POS__ (pp (86400. +. (24. *. 3600.))) "2d";
  (* These tests come from the b0 Fmt.uint64_ns_span tes *);
  let span s =
    Format.asprintf "%a"
      Mtime.Span.pp (Mtime.Span.of_uint64_ns (Int64.of_string s));
  in
  Test.string ~__POS__ (span "0u0") "0ns";
  Test.string ~__POS__ (span "0u999") "999ns";
  Test.string ~__POS__ (span "0u1_000") "1μs";
  Test.string ~__POS__ (span "0u1_001") "1.01μs";
  Test.string ~__POS__ (span "0u1_009") "1.01μs";
  Test.string ~__POS__ (span "0u1_010") "1.01μs";
  Test.string ~__POS__ (span "0u1_011") "1.02μs";
  Test.string ~__POS__ (span "0u1_090") "1.09μs";
  Test.string ~__POS__ (span "0u1_091") "1.1μs";
  Test.string ~__POS__ (span "0u1_100") "1.1μs";
  Test.string ~__POS__ (span "0u1_101") "1.11μs";
  Test.string ~__POS__ (span "0u1_109") "1.11μs";
  Test.string ~__POS__ (span "0u1_110") "1.11μs";
  Test.string ~__POS__ (span "0u1_111") "1.12μs";
  Test.string ~__POS__ (span "0u1_990") "1.99μs";
  Test.string ~__POS__ (span "0u1_991") "2μs";
  Test.string ~__POS__ (span "0u1_999") "2μs";
  Test.string ~__POS__ (span "0u2_000") "2μs";
  Test.string ~__POS__ (span "0u2_001") "2.01μs";
  Test.string ~__POS__ (span "0u9_990") "9.99μs";
  Test.string ~__POS__ (span "0u9_991") "10μs";
  Test.string ~__POS__ (span "0u9_999") "10μs";
  Test.string ~__POS__ (span "0u10_000") "10μs";
  Test.string ~__POS__ (span "0u10_001") "10.1μs";
  Test.string ~__POS__ (span "0u10_099") "10.1μs";
  Test.string ~__POS__ (span "0u10_100") "10.1μs";
  Test.string ~__POS__ (span "0u10_101") "10.2μs";
  Test.string ~__POS__ (span "0u10_900") "10.9μs";
  Test.string ~__POS__ (span "0u10_901") "11μs";
  Test.string ~__POS__ (span "0u10_999") "11μs";
  Test.string ~__POS__ (span "0u11_000") "11μs";
  Test.string ~__POS__ (span "0u11_001") "11.1μs";
  Test.string ~__POS__ (span "0u11_099") "11.1μs";
  Test.string ~__POS__ (span "0u11_100") "11.1μs";
  Test.string ~__POS__ (span "0u11_101") "11.2μs";
  Test.string ~__POS__ (span "0u99_900") "99.9μs";
  Test.string ~__POS__ (span "0u99_901") "100μs";
  Test.string ~__POS__ (span "0u99_999") "100μs";
  Test.string ~__POS__ (span "0u100_000") "100μs";
  Test.string ~__POS__ (span "0u100_001") "101μs";
  Test.string ~__POS__ (span "0u100_999") "101μs";
  Test.string ~__POS__ (span "0u101_000") "101μs";
  Test.string ~__POS__ (span "0u101_001") "102μs";
  Test.string ~__POS__ (span "0u101_999") "102μs";
  Test.string ~__POS__ (span "0u102_000") "102μs";
  Test.string ~__POS__ (span "0u999_000") "999μs";
  Test.string ~__POS__ (span "0u999_001") "1ms";
  Test.string ~__POS__ (span "0u999_001") "1ms";
  Test.string ~__POS__ (span "0u999_999") "1ms";
  Test.string ~__POS__ (span "0u1_000_000") "1ms";
  Test.string ~__POS__ (span "0u1_000_001") "1.01ms";
  Test.string ~__POS__ (span "0u1_009_999") "1.01ms";
  Test.string ~__POS__ (span "0u1_010_000") "1.01ms";
  Test.string ~__POS__ (span "0u1_010_001") "1.02ms";
  Test.string ~__POS__ (span "0u9_990_000") "9.99ms";
  Test.string ~__POS__ (span "0u9_990_001") "10ms";
  Test.string ~__POS__ (span "0u9_999_999") "10ms";
  Test.string ~__POS__ (span "0u10_000_000") "10ms";
  Test.string ~__POS__ (span "0u10_000_001") "10.1ms";
  Test.string ~__POS__ (span "0u10_000_001") "10.1ms";
  Test.string ~__POS__ (span "0u10_099_999") "10.1ms";
  Test.string ~__POS__ (span "0u10_100_000") "10.1ms";
  Test.string ~__POS__ (span "0u10_100_001") "10.2ms";
  Test.string ~__POS__ (span "0u99_900_000") "99.9ms";
  Test.string ~__POS__ (span "0u99_900_001") "100ms";
  Test.string ~__POS__ (span "0u99_999_999") "100ms";
  Test.string ~__POS__ (span "0u100_000_000") "100ms";
  Test.string ~__POS__ (span "0u100_000_001") "101ms";
  Test.string ~__POS__ (span "0u100_999_999") "101ms";
  Test.string ~__POS__ (span "0u101_000_000") "101ms";
  Test.string ~__POS__ (span "0u101_000_001") "102ms";
  Test.string ~__POS__ (span "0u999_000_000") "999ms";
  Test.string ~__POS__ (span "0u999_000_001") "1s";
  Test.string ~__POS__ (span "0u999_999_999") "1s";
  Test.string ~__POS__ (span "0u1_000_000_000") "1s";
  Test.string ~__POS__ (span "0u1_000_000_001") "1.01s";
  Test.string ~__POS__ (span "0u1_009_999_999") "1.01s";
  Test.string ~__POS__ (span "0u1_010_000_000") "1.01s";
  Test.string ~__POS__ (span "0u1_010_000_001") "1.02s";
  Test.string ~__POS__ (span "0u1_990_000_000") "1.99s";
  Test.string ~__POS__ (span "0u1_990_000_001") "2s";
  Test.string ~__POS__ (span "0u1_999_999_999") "2s";
  Test.string ~__POS__ (span "0u2_000_000_000") "2s";
  Test.string ~__POS__ (span "0u2_000_000_001") "2.01s";
  Test.string ~__POS__ (span "0u9_990_000_000") "9.99s";
  Test.string ~__POS__ (span "0u9_999_999_999") "10s";
  Test.string ~__POS__ (span "0u10_000_000_000") "10s";
  Test.string ~__POS__ (span "0u10_000_000_001") "10.1s";
  Test.string ~__POS__ (span "0u10_099_999_999") "10.1s";
  Test.string ~__POS__ (span "0u10_100_000_000") "10.1s";
  Test.string ~__POS__ (span "0u10_100_000_001") "10.2s";
  Test.string ~__POS__ (span "0u59_900_000_000") "59.9s";
  Test.string ~__POS__ (span "0u59_900_000_001") "1min";
  Test.string ~__POS__ (span "0u59_999_999_999") "1min";
  Test.string ~__POS__ (span "0u60_000_000_000") "1min";
  Test.string ~__POS__ (span "0u60_000_000_001") "1min1s";
  Test.string ~__POS__ (span "0u60_999_999_999") "1min1s";
  Test.string ~__POS__ (span "0u61_000_000_000") "1min1s";
  Test.string ~__POS__ (span "0u61_000_000_001") "1min2s";
  Test.string ~__POS__ (span "0u119_000_000_000") "1min59s";
  Test.string ~__POS__ (span "0u119_000_000_001") "2min";
  Test.string ~__POS__ (span "0u119_999_999_999") "2min";
  Test.string ~__POS__ (span "0u120_000_000_000") "2min";
  Test.string ~__POS__ (span "0u120_000_000_001") "2min1s";
  Test.string ~__POS__ (span "0u3599_000_000_000") "59min59s";
  Test.string ~__POS__ (span "0u3599_000_000_001") "1h";
  Test.string ~__POS__ (span "0u3599_999_999_999") "1h";
  Test.string ~__POS__ (span "0u3600_000_000_000") "1h";
  Test.string ~__POS__ (span "0u3600_000_000_001") "1h1min";
  Test.string ~__POS__ (span "0u3659_000_000_000") "1h1min";
  Test.string ~__POS__ (span "0u3659_000_000_001") "1h1min";
  Test.string ~__POS__ (span "0u3659_999_999_999") "1h1min";
  Test.string ~__POS__ (span "0u3660_000_000_000") "1h1min";
  Test.string ~__POS__ (span "0u3660_000_000_001") "1h2min";
  Test.string ~__POS__ (span "0u3660_000_000_001") "1h2min";
  Test.string ~__POS__ (span "0u3660_000_000_001") "1h2min";
  Test.string ~__POS__ (span "0u3720_000_000_000") "1h2min";
  Test.string ~__POS__ (span "0u3720_000_000_001") "1h3min";
  Test.string ~__POS__ (span "0u7140_000_000_000") "1h59min";
  Test.string ~__POS__ (span "0u7140_000_000_001") "2h";
  Test.string ~__POS__ (span "0u7199_999_999_999") "2h";
  Test.string ~__POS__ (span "0u7200_000_000_000") "2h";
  Test.string ~__POS__ (span "0u7200_000_000_001") "2h1min";
  Test.string ~__POS__ (span "0u86340_000_000_000") "23h59min";
  Test.string ~__POS__ (span "0u86340_000_000_001") "1d";
  Test.string ~__POS__ (span "0u86400_000_000_000") "1d";
  Test.string ~__POS__ (span "0u86400_000_000_001") "1d1h";
  Test.string ~__POS__ (span "0u89999_999_999_999") "1d1h";
  Test.string ~__POS__ (span "0u90000_000_000_000") "1d1h";
  Test.string ~__POS__ (span "0u90000_000_000_001") "1d2h";
  Test.string ~__POS__ (span "0u169200_000_000_000") "1d23h";
  Test.string ~__POS__ (span "0u169200_000_000_001") "2d";
  Test.string ~__POS__ (span "0u169200_000_000_001") "2d";
  Test.string ~__POS__ (span "0u172799_999_999_999") "2d";
  Test.string ~__POS__ (span "0u172800_000_000_000") "2d";
  Test.string ~__POS__ (span "0u172800_000_000_001") "2d1h";
  Test.string ~__POS__ (span "0u31536000_000_000_000") "365d";
  Test.string ~__POS__ (span "0u31554000_000_000_000") "365d5h";
  Test.string ~__POS__ (
    (* Technically this should round to a year but it does get rendered.
       I don't think it matters, it's not inacurate per se. *)
    span "0u31554000_000_000_001") "365d6h";
  Test.string ~__POS__ (span "0u31557600_000_000_000") "1a";
  Test.string ~__POS__ (span "0u31557600_000_000_001") "1a1d";
  Test.string ~__POS__ (span "0u63028800_000_000_000") "1a365d";
  Test.string ~__POS__ (span "0u63093600_000_000_000") "1a365d";
  Test.string ~__POS__ (span "0u63093600_000_000_001") "2a";
  Test.string ~__POS__ (span "0u63115200_000_000_000") "2a";
  Test.string ~__POS__ (span "0u63115200_000_000_001") "2a1d";
  ()

let test_span_compare =
  Test.test "Mtime.Span.{compare,is_shorter,is_longer}" @@ fun () ->
  let zero_mtime = Mtime.Span.of_uint64_ns 0_L in
  let large_mtime = Mtime.Span.of_uint64_ns Int64.max_int in
  let larger_mtime = Mtime.Span.of_uint64_ns Int64.min_int in
  let max_mtime = Mtime.Span.of_uint64_ns (-1_L) in
  let test_less_than fn =
    let (<) = fn in
    assert (zero_mtime < large_mtime);
    assert (zero_mtime < larger_mtime);
    assert (zero_mtime < max_mtime);
    assert (large_mtime < larger_mtime);
    assert (large_mtime < max_mtime);
    assert (larger_mtime < max_mtime);
    ()
  in
  test_less_than (fun x y -> Mtime.Span.compare x y < 0);
  test_less_than (fun x y -> Mtime.Span.is_shorter x ~than:y);
  test_less_than (fun x y -> Mtime.Span.compare y x > 0);
  test_less_than (fun x y -> Mtime.Span.is_longer y ~than:x);
  ()

let test_span_constants =
  Test.test "Mtime.Span.{zero,one,max_span,min_span}" @@ fun () ->
  let (<) x y = Mtime.Span.compare x y < 0 in
  assert (Mtime.Span.zero < Mtime.Span.one);
  assert (Mtime.Span.zero < Mtime.Span.max_span);
  assert (Mtime.Span.min_span < Mtime.Span.one);
  assert (Mtime.Span.min_span < Mtime.Span.max_span);
  assert (Mtime.Span.one < Mtime.Span.max_span);
  ()

let test_span_arith =
  Test.test "Mtime.Span.{abs_diff,add}" @@ fun () ->
  assert (Mtime.Span.(equal (add zero one) one));
  assert (Mtime.Span.(equal (add one zero) one));
  assert (Mtime.Span.(equal (add (abs_diff max_span one) one) max_span));
  ()

let test_float_ns =
  Test.test "Mtime.{to,of}_float_ns" @@ fun () ->
  assert (Mtime.Span.to_float_ns Mtime.Span.max_span = (2. ** 64.) -. 1.);
  assert (Mtime.Span.to_float_ns Mtime.Span.min_span = 0.);
  assert (Mtime.Span.of_float_ns (2. ** 53. -. 1.) =
          Some (Mtime.Span.of_uint64_ns (Int64.(sub (shift_left 1L 53) one))));
  assert (Mtime.Span.of_float_ns (2. ** 53.) = None);
  assert (Mtime.Span.of_float_ns 0. = Some Mtime.Span.zero);
  assert (Mtime.Span.of_float_ns (-.0.) = Some Mtime.Span.zero);
  assert (Mtime.Span.of_float_ns infinity = None);
  assert (Mtime.Span.of_float_ns nan = None);
  assert (Mtime.Span.of_float_ns (-3.) = None);
  assert (Mtime.Span.of_float_ns 1. = Some Mtime.Span.one);
  ()

let main () = Test.main @@ fun () -> Test.autorun ()
let () = if !Sys.interactive then () else exit (main ())
