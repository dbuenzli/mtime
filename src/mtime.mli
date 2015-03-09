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
    spans in a single program run.

    Time resolution should be nanoseconds but can be less, consult the
    {{!platform}platform support} for more information.

    {e Release %%VERSION%% - %%MAINTAINER%% } *)

(** {1 Availability} *)

val available : bool
(** [available] is [true] iff monotonic wall-clock time is available. If
    [available] is [false] time spans always return zero. *)

(** {1 Time spans} *)

type span
(** The type for positive time spans.

    If the platform has nanosecond resolution the data types
    guarantees it can measure up to 584 years spans (remember this
    is in a single program run). *)

(** {1 Passing time} *)

val elapsed : unit -> span
(** [elapsed ()] is the wall-clock time span elapsed since the
    beginning of the program. *)

(** {1 Time counters} *)

type counter
(** The type for monotonic wall-clock time counters. *)

val counter : unit -> counter
(** [counter ()] is a counter counting time from now on. *)

val count : counter -> span
(** [count c] is is the wall-clock time span elapsed since
    [c] was created. *)

(** {1 Converting time spans} *)

val to_ns : span -> float
(** [to_ns span] is [span] in nanoseconds (1e-9s). *)

val to_us : span -> float
(** [to_us span] is [span] in microseconds (1e-3s). *)

val to_ms : span -> float
(** [to_ns span] is [span] in milliseconds (1e-6s). *)

val to_s : span -> float
(** [to_s span] is [span] is seconds. *)

val to_min : span -> float
(** [to_min span] is [span] in minutes (60s). *)

val to_hour : span -> float
(** [to_hour span] is [span] in hours (3600s). *)

val to_day : span -> float
(** [to_day span] is [span] in days (24 hours, 86400s). *)

val to_year : span -> float
(** [to_year span] is [span] in years (365 days, 31'536'000s). *)

val to_ns_uint64 : span -> int64
(** [to_ns_uint64] is [span] in nanoseconds as an {e unsigned} 64-bit
    integer. *)

(** {1 Time scale conversion}

    The following convenience constants relate time scales to seconds.
    Used as multiplicands they can be used to convert these units
    to and from seconds. *)

val ns_to_s : float
(** [ns_to_s] is [1e-9] the number of seconds in one nanosecond. *)

val us_to_s : float
(** [us_to_s] is [1e-6], the number of seconds in one microsecond. *)

val ms_to_s : float
(** [ms_to_s] is [1e-3], the number of seconds in one millisecond. *)

val min_to_s : float
(** [min_to_s] is [60.], the number of seconds in one minute. *)

val hour_to_s : float
(** [hour_to_s] is [3600.], the number of seconds in one hour. *)

val day_to_s : float
(** [day_to_s] is [86_400.], the number of seconds in one day. *)

val year_to_s : float
(** [year_to_s] is [31_536_000.], the number of seconds in 365 days. *)

val s_to_ns : float
(** [s_to_ns] is [1e9] the number of nanoseconds in one second. *)

val s_to_us : float
(** [s_to_us] is [1e6], the number of microseconds in one second. *)

val s_to_ms : float
(** [s_to_ms] is [1e3], the number of milliseconds in one second. *)

val s_to_min : float
(** [s_to_min] is [1. /. 60.], the number of minutes in one second.  *)

val s_to_hour : float
(** [s_to_hour] is [1. /. 3600.], the number of hours in one second. *)

val s_to_day : float
(** [s_to_day] is [1. /. 86400.], the number of days in one second. *)

val s_to_year : float
(** [s_to_year] is [1. /. 31_536_000.], the number of years in one second. *)

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
       {{:http://caniuse.com/#feat=high-resolution-time}availability})
       which returns a
       {{:http://www.w3.org/TR/hr-time/#sec-DOMHighResTimeStamp}double
       floating point value} in milliseconds with
       resolution up to the microsecond.}}
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
