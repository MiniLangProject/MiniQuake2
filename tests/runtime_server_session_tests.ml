/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Asset-free dedicated-session lifecycle over a real ephemeral UDP socket. */
import miniquake2.runtime.server_session as tsession
import miniquake2.qcommon.constants as tqc
import miniquake2.qcommon.checksum as tchecksum

// Assert the equal test condition.
function assertEqual(actual, expected, name)
  if actual != expected then return error(9980, name + ": values differ") end if
  return true
end function

// Assert the true test condition.
function assertTrue(value, name)
  if value != true then return error(9981, name + ": expected true") end if
  return true
end function

// Run this source file's command-line entry point.
function main(args)
  print "MiniQuake2 dedicated session tests starting: 1"
  text = "{ \"classname\" \"worldspawn\" \"message\" \"Authored Unit\" } " +
    "{ \"classname\" \"info_player_start\" \"origin\" \"0 0 24\" } " +
    "{ \"classname\" \"monster_soldier\" \"origin\" \"64 0 24\" }"
  session = tsession.createCore("synthetic", text, void, "127.0.0.1", 0, 2, true)
  assertTrue(session.socket.port > 0, "ephemeral UDP binding")
  assertEqual(session.networkRuntime.configStrings[tqc.CS_NAME],
    "Authored Unit", "worldspawn level title survives session synchronization")
  assertEqual(tsession.run(session, 2), 2, "fixed-step run")
  assertEqual(session.frameNumber, 2, "server frame count")
  assertEqual(session.gameExport.numEdicts, 5, "client-slot-aware map edicts")
  assertEqual(session.gameExport.edicts[4].state.number, 4, "monster edict mapping")
  checksumBytes = bytes([1, 2, 3, 4, 5, 6, 7, 8])
  expectedChecksum = tchecksum.blockChecksum(checksumBytes, 0,
    len(checksumBytes)) + ""
  assertEqual(tsession.setMapChecksum(session, checksumBytes), expectedChecksum,
    "map checksum return")
  assertEqual(session.networkRuntime.configStrings[tqc.CS_MAPCHECKSUM],
    expectedChecksum, "protocol map checksum")
  assertTrue(tsession.shutdown(session), "first shutdown")
  assertEqual(tsession.shutdown(session), false, "idempotent shutdown")
  print "MiniQuake2 dedicated session tests passed: 1"
  return 0
end function
