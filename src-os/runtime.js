//Provides: ocaml_mtime_clock_period_ns
function ocaml_mtime_clock_period_ns(_unit) {
  return 0;
}

//Provides: mtime_clock_now
//Requires: caml_int64_of_float
//Requires: caml_raise_sys_error
var performance_now;
function test_perf_now(obj) {
  if(obj && obj.performance && typeof obj.performance.now == "function"){
    performance_now = obj.performance.now
  }
}
test_perf_now(globalThis);
if(performance_now === undefined)
  test_perf_now(globalThis.perf_hooks)
if(performance_now === undefined && typeof require == "function"){
  var ph = require("perf_hooks");
  test_perf_now(ph);
}
if(performance_now === undefined)
  performance_now = (function () { caml_raise_sys_error("performance.now () is not available"); })
function mtime_clock_now(){
  var now_ms = performance_now ();
  var now_ns = caml_int64_of_float(now_ms * 1e6);
  return now_ns;
}

//Provides: ocaml_mtime_clock_now_ns
//Requires: mtime_clock_now
function ocaml_mtime_clock_now_ns(_unix) {
  return mtime_clock_now()
}


//Provides: ocaml_mtime_clock_elapsed_ns
//Requires: caml_int64_sub, mtime_clock_now
var mtime_clock_start;
function ocaml_mtime_clock_elapsed_ns(_unix) {
  if(!mtime_clock_start) mtime_clock_start = mtime_clock_now();
  var now = mtime_clock_now();
  return caml_int64_sub(now, mtime_clock_start);
}
