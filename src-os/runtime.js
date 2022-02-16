/*---------------------------------------------------------------------------
   Copyright (c) 2022 The mtime programmers. All rights reserved.
   Distributed under the ISC license, see license at the end of the file.
  ---------------------------------------------------------------------------*/

//Provides: ocaml_mtime_clock_period_ns
function ocaml_mtime_clock_period_ns (_unit) {
  return 0;
}

//Provides: mtime_clock_now
//Requires: caml_int64_of_float
//Requires: caml_raise_sys_error
var performance_now;
function test_perf_now (obj) {
  if (obj && obj.performance && typeof obj.performance.now == "function") {
    performance_now = obj.performance.now
  }
}
test_perf_now(globalThis);
if (performance_now === undefined)
  test_perf_now(globalThis.perf_hooks)
if (performance_now === undefined && typeof require == "function") {
  var ph = require ("perf_hooks");
  test_perf_now (ph);
}
if(performance_now === undefined)
  performance_now = (function ()
                     { caml_raise_sys_error
                       ("performance.now () is not available");})
function mtime_clock_now (){
  var now_ms = performance_now ();
  var now_ns = caml_int64_of_float (now_ms * 1e6);
  return now_ns;
}

//Provides: ocaml_mtime_clock_now_ns
//Requires: mtime_clock_now
function ocaml_mtime_clock_now_ns (_unit) {
  return mtime_clock_now ();
}

//Provides: ocaml_mtime_clock_elapsed_ns
//Requires: caml_int64_sub, mtime_clock_now
var mtime_clock_start;
function ocaml_mtime_clock_elapsed_ns (_unix) {
  if (!mtime_clock_start) mtime_clock_start = mtime_clock_now ();
  var now = mtime_clock_now ();
  return caml_int64_sub (now, mtime_clock_start);
}

/*---------------------------------------------------------------------------
   Copyright (c) 2022 The mtime programmers

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
  ---------------------------------------------------------------------------*/
