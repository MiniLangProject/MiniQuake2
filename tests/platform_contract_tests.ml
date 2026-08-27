/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Asset-free timer and two-socket UDP platform integration. */
import miniquake2.platform.system as system
import miniquake2.platform.udp as udp
import miniquake2.platform.window as window

// Assert the equal test condition.
function assertEqual(actual, expected, name)
  if actual != expected then return error(9920, name + ": expected " + expected + ", got " + actual) end if
  return true
end function

// Assert the true test condition.
function assertTrue(value, name)
  if value != true then return error(9921, name + ": expected true") end if
  return true
end function

// Verify clock.
function testClock()
  clock = system.createClock()
  before = system.counter(clock)
  system.sleep(2)
  after = system.counter(clock)
  assertTrue(after > before, "monotonic counter")
  assertTrue(system.handleCount() > 0, "process handle count")
  return true
end function

// Verify udp loopback.
function testUdpLoopback()
  server = udp.open("127.0.0.1", 0)
  client = udp.open("127.0.0.1", 0)
  payload = bytes([81, 50, 45, 85, 68, 80])
  udp.send(client, "127.0.0.1", server.port, payload)
  packet = void
  attempts = 0
  while packet is void and attempts < 100
    packet = udp.receive(server, 1400)
    if packet is void then system.sleep(1) end if
    attempts = attempts + 1
  end while
  udp.close(client)
  udp.close(server)
  assertTrue(packet is not void, "loopback packet received")
  assertEqual(decode(packet.data), "Q2-UDP", "loopback payload")
  assertEqual(packet.address, "127.0.0.1", "loopback source address")
  return true
end function

// Verify display mode fallback.
function testDisplayModeFallback()
  exclusive = window.resolvedDisplayMode(1920, 1080, true, true,
    2560, 1440)
  assertEqual(exclusive[0], 1920, "exclusive width")
  assertEqual(exclusive[1], 1080, "exclusive height")
  assertEqual(exclusive[2], 0, "exclusive display switch")
  fallback = window.resolvedDisplayMode(3840, 2160, true, false,
    2560, 1440)
  assertEqual(fallback[0], 2560, "fallback desktop width")
  assertEqual(fallback[1], 1440, "fallback desktop height")
  assertEqual(fallback[2], 1, "fallback uses current display mode")
  windowed = window.resolvedDisplayMode(3840, 2160, false, false,
    2560, 1440)
  assertEqual(windowed[0], 3840, "windowed requested width")
  assertEqual(windowed[1], 2160, "windowed requested height")
  assertEqual(windowed[2], 0, "windowed does not switch display")
  return true
end function

testClock()
testUdpLoopback()
testDisplayModeFallback()
print "platform_contract_tests: PASS"
