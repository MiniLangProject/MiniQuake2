/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Asset-free .dm2 recorder/player and malformed corpus. */
import miniquake2.client.demo as cdemo

// Assert the equal test condition.
function assertEqual(actual, expected, name)
  if actual != expected then return error(7998, name + ": expected " + expected + ", got " + actual) end if
end function

demo = cdemo.create()
cdemo.append(demo, bytes([12, 34, 56]))
cdemo.append(demo, bytes([1, 2]))
wire = cdemo.encodeDemo(demo)
decoded = cdemo.decodeDemo(wire)
assertEqual(len(decoded.packets), 2, "demo packet count")
player = cdemo.player(decoded)
assertEqual(cdemo.nextPacket(player)[1], 34, "first demo packet")
assertEqual(cdemo.nextPacket(player)[1], 2, "second demo packet")
assertEqual(player.finished, true, "demo player finished")
assertEqual(cdemo.nextPacket(player), void, "end returns void")
assertEqual(typeof(try(cdemo.decodeDemo(slice(wire, 0, len(wire) - 1)))), "error", "truncated demo rejected")
bad = bytes([0xff, 0xff, 0xff, 0x7f, 0xff, 0xff, 0xff, 0xff])
assertEqual(typeof(try(cdemo.decodeDemo(bad))), "error", "oversize demo packet rejected")
print("MiniQuake2 client demo tests passed: 1")
