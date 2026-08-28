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
  assertEqual(session.gameExport.numEdicts, 13,
    "client/body-queue-aware map edicts")
  assertEqual(session.gameExport.edicts[12].state.number, 12,
    "monster edict mapping")

  // SV_BuildClientFrame clears owner missile solidity only in that owner's
  // snapshot. The underlying game entity must remain solid for other clients.
  viewer = session.gameExport.edicts[1]
  otherViewer = session.gameExport.edicts[2]
  projectile = session.gameExport.edicts[12]
  viewer.state.origin.x = 0.0; viewer.state.origin.y = 0.0; viewer.state.origin.z = 0.0
  otherViewer.state.origin.x = 0.0; otherViewer.state.origin.y = 0.0; otherViewer.state.origin.z = 0.0
  projectile.inUse = true
  projectile.owner = viewer
  projectile.state.modelIndex = 1
  projectile.state.solid = 1234
  ownerPacket = tsession.packetEntitiesForClient(session, viewer)
  otherPacket = tsession.packetEntitiesForClient(session, otherViewer)
  ownerSolid = -1; otherSolid = -1
  for each ownerEntity in ownerPacket
    if ownerEntity.number == projectile.state.number then ownerSolid = ownerEntity.solid end if
  end for
  for each otherEntity in otherPacket
    if otherEntity.number == projectile.state.number then otherSolid = otherEntity.solid end if
  end for
  assertEqual(ownerSolid, 0, "owner missile prediction solid cleared")
  assertEqual(otherSolid, 1234, "remote missile solid retained")

  // Sound-only entity states beyond the stock 400-unit attenuation cutoff do
  // not consume snapshot bandwidth.
  projectile.owner = void
  projectile.state.modelIndex = 0
  projectile.state.modelIndex2 = 0
  projectile.state.modelIndex3 = 0
  projectile.state.modelIndex4 = 0
  projectile.state.solid = 0
  projectile.state.sound = 1
  projectile.state.origin.x = 401.0
  distantSoundPacket = tsession.packetEntitiesForClient(session, viewer)
  distantSoundFound = false
  for each distantEntity in distantSoundPacket
    if distantEntity.number == projectile.state.number then distantSoundFound = true end if
  end for
  assertEqual(distantSoundFound, false, "distant sound-only entity omitted")
  projectile.state.origin.x = 399.0
  nearSoundPacket = tsession.packetEntitiesForClient(session, viewer)
  nearSoundFound = false
  for each nearEntity in nearSoundPacket
    if nearEntity.number == projectile.state.number then nearSoundFound = true end if
  end for
  assertEqual(nearSoundFound, true, "near sound-only entity retained")
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
