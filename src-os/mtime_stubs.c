/*---------------------------------------------------------------------------
   Copyright (c) 2015 Daniel C. Bünzli. All rights reserved.
   Distributed under the ISC license, see license at the end of the file.
   %%NAME%% release %%VERSION%%
   --------------------------------------------------------------------------*/

#include <caml/mlvalues.h>
#include <caml/alloc.h>
#include <caml/memory.h>

/* Detect platform */

#if defined(__APPLE__) && defined(__MACH__)
  #define OCAML_MTIME_DARWIN

#elif defined (__unix__) || defined(__unix)
 #include <unistd.h>
 #if defined(_POSIX_VERSION)
   #define OCAML_MTIME_POSIX
 #endif
#endif

/* Darwin */

#if defined(OCAML_MTIME_DARWIN)

#include <mach/mach_time.h>
#include <stdint.h>

static mach_timebase_info_data_t scale;

CAMLprim value ocaml_mtime_elapsed_ns (value unit)
{
  static uint64_t start = 0L;
  if (start == 0L)
  {
    start = mach_absolute_time ();
    mach_timebase_info (&scale);
    if (scale.denom == 0) { scale.numer = 0; scale.denom = 1; }
  }

  uint64_t now = mach_absolute_time ();
  return caml_copy_int64 (((now - start) * scale.numer) / scale.denom);
}

// scale is initialized by ocaml_mtime_elapsed_ns during startup
CAMLprim value ocaml_mtime_absolute_ns (value unit)
{
  uint64_t now = mach_absolute_time ();
  return caml_copy_int64 ((now * scale.numer) / scale.denom);
}

/* POSIX */

#elif defined(OCAML_MTIME_POSIX)

#include <time.h>
#include <stdint.h>

CAMLprim value ocaml_mtime_elapsed_ns (value unit)
{
  static struct timespec start = { 0, 0 };
  if (start.tv_sec == 0)
  {
    if (clock_gettime (CLOCK_MONOTONIC, &start)) return caml_copy_int64 (0L);
  }
  struct timespec now;
  if (clock_gettime (CLOCK_MONOTONIC, &now)) return caml_copy_int64 (0L);
  return caml_copy_int64 ((uint64_t)(now.tv_sec - start.tv_sec) *
                          (uint64_t)1000000000 +
                          (uint64_t)(now.tv_nsec - start.tv_nsec));
}

CAMLprim value ocaml_mtime_absolute_ns (value unit)
{
  struct timespec now;
  if (clock_gettime (CLOCK_MONOTONIC, &now)) return caml_copy_int64 (0L);
  return caml_copy_int64 ((uint64_t)(now.tv_sec) *
                          (uint64_t)1000000000 +
                          (uint64_t)(now.tv_nsec));
}

/* Unsupported */

#else
#warning OCaml Mtime module: unsupported platform

#include <stdint.h>

CAMLprim value ocaml_mtime_elapsed_ns (value unit)
{
  return caml_copy_int64 (0L);
}

CAMLprim value ocaml_mtime_absolute_ns (value unit)
{
  return caml_copy_int64 (0L);
}

#endif

/*---------------------------------------------------------------------------
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
  ---------------------------------------------------------------------------*/
