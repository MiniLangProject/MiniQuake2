/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Dedicated-console input decoding and bounds regression tests. */
import miniquake2.platform.dedicated_console as dctest

// Assert dedicated-console equality.
function dcAssertEqual(actual, expected, message)
  if actual != expected then
    return error(9988, message)
  end if
  return true
end function

dcState = dctest.create()
// Key-down records are deliberately ignored; printable key-up records form a
// line and carriage return publishes it without retaining stale input.
dctest.acceptEvent(dcState, 0x80010000 | 120)
dcAssertEqual(dcState.length, 0, "key-down ignored")
for each dcByte in bytes("status")
  dctest.acceptEvent(dcState, 0x80000000 | dcByte)
end for
dcAssertEqual(dcState.length, 6, "printable input accepted")
dcCompleted = dctest.acceptEvent(dcState, 0x80000000 | 13)
dcAssertEqual(dcCompleted[0], "status", "completed console line")
dcAssertEqual(dcState.length, 0, "line reset")

for each dcByte in bytes("maps")
  dctest.acceptEvent(dcState, 0x80000000 | dcByte)
end for
dctest.acceptEvent(dcState, 0x80000000 | 8)
dcCompleted = dctest.acceptEvent(dcState, 0x80000000 | 13)
dcAssertEqual(dcCompleted[0], "map", "backspace editing")

dcIndex = 0
while dcIndex < 300
  dctest.acceptEvent(dcState, 0x80000000 | 97)
  dcIndex = dcIndex + 1
end while
dcAssertEqual(dcState.length, 255, "bounded console input")
print "platform_dedicated_console_tests: PASS"
