(*---------------------------------------------------------------------------
   Copyright (c) 2015 The mtime programmers. All rights reserved.
   SPDX-License-Identifier: ISC
  ---------------------------------------------------------------------------*)

open B0_testing

(* Note nothing is being asserted in these tests. *)

let test_available () = try ignore (Mtime_clock.elapsed ()) with
| Sys_error e -> Test.failstop "No monotonic time available: %s" e

let test_counters =
  Test.test "Mtime_clock.counter" @@ fun () ->
  let count max =
    let c = Mtime_clock.counter () in
    for i = 1 to max do () done;
    Mtime_clock.count c
  in
  let do_count max =
    let span = count max in
    let span_ns = Mtime.Span.to_uint64_ns span in
    Test.Log.msg "Count to % 8d: %10Luns %gs %a"
      max span_ns (Mtime.Span.to_float_ns span *. 1e-9) Mtime.Span.pp  span
  in
  do_count 1000000;
  do_count 100000;
  do_count 10000;
  do_count 1000;
  do_count 100;
  do_count 10;
  do_count 1;
  ()

let test_elapsed =
  Test.test "Mtime_clock.elapsed ns - s - pp - dump" @@ fun () ->
  let span = Mtime_clock.elapsed () in
  Test.Log.msg " %Luns - %gs - %a - %a"
    (Mtime.Span.to_uint64_ns span)
    (Mtime.Span.to_float_ns span *. 1e-9)
    Mtime.Span.pp span
    Mtime.Span.dump span;
  ()

let test_now =
  Test.test "Mtime_clock.now ns - s - pp - dump " @@ fun () ->
  let t = Mtime_clock.now () in
  let span = Mtime.(span t (of_uint64_ns 0_L)) in
  Test.Log.msg " %Luns - %gs - %a - %a"
    (Mtime.to_uint64_ns t) (Mtime.Span.to_float_ns span *. 1e-9)
    Mtime.pp t Mtime.dump t;
  ()

let main () = Test.main @@ fun () -> Test.autorun ()
let () = if !Sys.interactive then () else exit (main ())
