/* Monotonic time and process services for Qcommon_Frame. */
package miniquake2.platform.system

import miniquake2.native as native

struct Clock
  frequency
  origin
end struct

function createClock()
  frequency = native.sysFrequency()
  if frequency <= 0 then return error(2900, "high-resolution timer unavailable") end if
  return Clock(frequency, native.sysCounter())
end function

function counter(clock)
  return native.sysCounter() - clock.origin
end function

function milliseconds(clock)
  return counter(clock) * 1000 / clock.frequency
end function

function sleep(millisecondsToWait)
  if millisecondsToWait < 0 then return error(2901, "negative sleep interval") end if
  native.winSleep(millisecondsToWait)
  return true
end function

function handleCount()
  return native.processHandleCount()
end function
