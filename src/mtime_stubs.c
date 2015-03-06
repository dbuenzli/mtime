/*---------------------------------------------------------------------------
   Copyright (c) 2015 Daniel C. Bünzli. All rights reserved.
   Distributed under the BSD3 license, see license at the end of the file.
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

CAMLprim value ocaml_mtime_elapsed_ns (value unit)
{
  static uint64 start = 0L;
  static mach_timebase_info_data_t scale;
  if (start == 0L)
  {
    start = mach_absolute_time ();
    mach_timebase_info (&scale);
    if (scale.denom == 0) { scale.numer = 0; scale.denom = 1; }
  }

  uint64 now = mach_absolute_time ();
  return caml_copy_int64 (((now - start) * scale.numer) / scale.denom);
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
  return caml_copy_int64 ((now.tv_sec - start.tv_sec) * 1000000000 +
                          (now.tv_nsec - start.tv_nsec));
}

/* Unsupported */

#else
#warning OCaml Mtime module: unsupported platform

#include <stdint.h>

CAMLprim value ocaml_mtime_elapsed_ns (value unit)
{
  return caml_copy_int64 (0L);
}

#endif

/*---------------------------------------------------------------------------
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
   --------------------------------------------------------------------------*/
