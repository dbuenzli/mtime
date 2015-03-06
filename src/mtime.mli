(*---------------------------------------------------------------------------
   Copyright (c) 2015 Daniel C. Bünzli. All rights reserved.
   Distributed under the BSD3 license, see license at the end of the file.
   %%NAME%% release %%VERSION%%
  ---------------------------------------------------------------------------*)

(** Monotonic wall-clock time.

    [Mtime] provides access to monotonic wall-clock time. This time
    increases monotonically and is not subject to operating system
    calendar time adjustments. Its absolute value has no meaning and
    is not exposed. It can only be used to measure wall-clock time
    spans.

    Time resolution should be nanoseconds but can be less, consult the
    {{!platform}platform support} for more information.

    {e Release %%VERSION%% - %%MAINTAINER%% } *)

(** {1 Availability} *)

val available : bool
(** [available] is [true] iff monotonic wall-clock time is available. If
    [available] is [false] time spans always return zero. *)

(** {1 Time spans} *)

type span_s = float
(** The type for time spans in seconds. *)

type span_ns = int64
(** The type for time spans in nano seconds. The integer
    is unsigned and can measure ~585 years. *)

(** {1 Passing time} *)

val elapsed_s : unit -> span_s
(** [elapsed_s ()] is the number of monotonic wall-clock seconds
    elapsed since the beginning of the program. *)

val elapsed_ns : unit -> span_ns
(** [elapsed_ns] is like {!elapsed_s} but in nanoseconds. *)

(** {1 Time counters} *)

type counter
(** The type for monotonic wall-clock time counters. *)

val counter : unit -> counter
(** [counter ()] is a counter counting time from now on. *)

val count_s : counter -> span_s
(** [count_s c] is the current counter value of [c] in seconds. *)

val count_ns : counter -> span_ns
(** [count_ns] is like {!count_s} but in nanoseconds. *)

(** {1 Converting time spans} *)

type scale = [ `Ns | `Mus | `Ms | `S  |  `Min | `Hour | `Day | `Year ]
(** The type for time scale (units). Units are defined according to
    {{:http://www.bipm.org/en/publications/si-brochure/chapter3.html}SI
    prefixes} on seconds and
    {{:http://www.bipm.org/en/publications/si-brochure/table6.html}accepted
    non-SI units}; [`Year] is counted as 365 SI days. *)

val span_s_to : scale -> span_s -> float
(** [span_s_to scale s] is [s] converted to [scale] units. *)

val span_s_of : scale -> float -> span_s
(** [span_s_of scale s] is [s] in [scale] units converted to {!span_s}. *)

val span_ns_to : scale -> span_ns -> int64
(** [span_ns_to scale s] is [s] converted to [scale] units. *)

val span_ns_of : scale -> int64 -> span_ns
(** [span_s_of scale s] is [s] in [scale] units converted to {!span_s}. *)

(** {1:platform Platform support}

    {ul
    {- Platforms with a POSIX clock (includes Linux) use
       {{:http://pubs.opengroup.org/onlinepubs/9699919799/functions/clock_gettime.html}[clock_gettime]}
       with CLOCK_MONOTONIC.}
    {- Darwin uses
       {{:https://developer.apple.com/library/mac/qa/qa1398/_index.html}[mach_absolute_time]}.}
    {- Windows is TODO, use
       {{:https://msdn.microsoft.com/en-us/library/windows/desktop/aa373083%28v=vs.85%29.aspx}Performance counters}. }
    {- JavaScript uses
       {{:http://www.w3.org/TR/hr-time/}[performance.now]} (consult
       {{:http://caniuse.com/#feat=high-resolution-time}availability}).
       The clock returns a
       {{:http://www.w3.org/TR/hr-time/#sec-DOMHighResTimeStamp}double
       floating point value} in milliseconds with
       resolution up to the micro second; as such using {!span_ns}
       values on this platform may not be very useful.}}
*)

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
