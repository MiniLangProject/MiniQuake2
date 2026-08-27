/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Monotonic time and process services for Qcommon_Frame. */
package miniquake2.platform.system

import miniquake2.native as native

// Store clock data.
struct Clock
  frequency
  origin
end struct

// Create clock.
function createClock()
  frequency = native.sysFrequency()
  if frequency <= 0 then return error(2900, "high-resolution timer unavailable") end if
  return Clock(frequency, native.sysCounter())
end function

// Return the counter value.
function counter(clock)
  return native.sysCounter() - clock.origin
end function

// Return the milliseconds value.
function milliseconds(clock)
  return counter(clock) * 1000 / clock.frequency
end function

// Return the sleep value.
function sleep(millisecondsToWait)
  if millisecondsToWait < 0 then return error(2901, "negative sleep interval") end if
  native.winSleep(millisecondsToWait)
  return true
end function

// Handle count.
function handleCount()
  return native.processHandleCount()
end function
