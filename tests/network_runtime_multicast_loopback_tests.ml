/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* GameImport multicast -> UDP/Netchan -> integrated client effects loopback. */
import miniquake2.qcommon.constants as nrml_qc
import miniquake2.qcommon.types as nrml_qtypes
import miniquake2.game.constants as nrml_gc
import miniquake2.server.game_bridge as nrml_bridge
import miniquake2.runtime.play_session as nrml_play

// Assert the multicast loop test condition.
function multicastLoopAssert(value, label)
  if value != true then return error(8466, label) end if
  return true
end function

entities = "{\n\"classname\" \"worldspawn\"\n}\n" +
  "{\n\"classname\" \"info_player_start\"\n\"origin\" \"0 0 24\"\n}\n"
session = nrml_play.createCore("multicast_loop", entities, void,
  "\\name\\MulticastLoop\\rate\\25000")
nrml_play.runUntilActive(session, 500)

imports = nrml_bridge.makeImports(session.server.bridgeRuntime)
player = session.server.gameExport.edicts[1]
origin = nrml_qtypes.Vec3(player.state.origin.x, player.state.origin.y, player.state.origin.z)
imports.writeByte(nrml_qc.SVC_MUZZLEFLASH2)
imports.writeShort(1)
imports.writeByte(57)
imports.multicast(origin, nrml_gc.MULTICAST_PVS)
multicastLoopAssert(len(session.server.bridgeRuntime.pendingMulticasts) == 1,
  "GameImport multicast did not reach the server queue")

result = nrml_play.step(session)
handoff = result.handoff
multicastLoopAssert(handoff is not void and len(handoff.dLights) == 1,
  "monster muzzle flash did not reach integrated client effects")
multicastLoopAssert(handoff.dLights[0].key == 1 and handoff.dLights[0].radius >= 200.0,
  "monster muzzle flash light fields mismatch")
multicastLoopAssert(len(handoff.sounds) == 1 and handoff.sounds[0].entity == 1 and
  handoff.sounds[0].soundName == "chick/chkatck2.wav",
  "monster muzzle flash sound handoff mismatch")
multicastLoopAssert(len(session.server.bridgeRuntime.pendingMulticasts) == 0,
  "delivered multicast queue was not drained")

// Reliable GameImport payloads use the same application-fragment queue and
// remain in the Netchan holding buffer until the integrated client ACKs them.
imports.writeByte(nrml_qc.SVC_NOP)
imports.multicast(origin, nrml_gc.MULTICAST_ALL_R)
nrml_play.step(session)
serverChannel = session.server.networkRuntime.server.clients[0].channel
multicastLoopAssert(serverChannel.reliableLength > 0 and
  len(session.server.bridgeRuntime.pendingMulticasts) == 0,
  "reliable multicast was not staged in Netchan")
nrml_play.step(session)
multicastLoopAssert(serverChannel.reliableLength == 0,
  "reliable multicast acknowledgement did not clear holding buffer")

nrml_play.shutdown(session)
print("network_runtime_multicast_loopback_tests: PASS")
