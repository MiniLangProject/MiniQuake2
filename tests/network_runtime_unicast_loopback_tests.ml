/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* GameImport client prints -> reliable UDP -> transactional UI handoff. */
import miniquake2.qcommon.constants as nrul_qc
import miniquake2.server.game_bridge as nrul_bridge
import miniquake2.runtime.play_session as nrul_play

// Assert the unicast loop test condition.
function unicastLoopAssert(value, label)
  if value != true then return error(8471, label) end if
  return true
end function

entities = "{\n\"classname\" \"worldspawn\"\n}\n" +
  "{\n\"classname\" \"info_player_start\"\n\"origin\" \"0 0 24\"\n}\n"
session = nrul_play.createCore("unicast_loop", entities, void,
  "\\name\\UnicastLoop\\rate\\25000")
nrul_play.runUntilActive(session, 500)
imports = nrul_bridge.makeImports(session.server.bridgeRuntime)
player = session.server.gameExport.edicts[1]

imports.cprintf(player, nrul_qc.PRINT_HIGH, "Access denied")
imports.centerprintf(player, "You need the key")
unicastLoopAssert(session.server.bridgeRuntime.pendingUnicastCount == 2,
  "GameImport client prints did not reach unicast queue")
result = nrul_play.step(session)
handoff = result.handoff
unicastLoopAssert(handoff is not void and len(handoff.prints) == 1 and
  handoff.prints[0].level == nrul_qc.PRINT_HIGH and
  handoff.prints[0].text == "Access denied",
  "cprintf did not reach client print handoff")
unicastLoopAssert(len(handoff.centerPrints) == 1 and
  handoff.centerPrints[0].text == "You need the key",
  "centerprintf did not reach client centerprint handoff")
unicastLoopAssert(session.server.bridgeRuntime.pendingUnicastCount == 0,
  "delivered unicast queue was not drained")
serverChannel = session.server.networkRuntime.server.clients[0].channel
unicastLoopAssert(serverChannel.reliableLength > 0,
  "reliable client prints were not held for acknowledgement")
nrul_play.step(session)
unicastLoopAssert(serverChannel.reliableLength == 0,
  "client print acknowledgement did not clear reliable holding buffer")

// The raw GameImport path can still request a sequenced-unreliable unicast.
imports.writeByte(nrul_qc.SVC_NOP)
imports.unicast(player, false)
nrul_play.step(session)
unicastLoopAssert(session.server.bridgeRuntime.pendingUnicastCount == 0,
  "unreliable unicast was not delivered and drained")

nrul_play.shutdown(session)
print("network_runtime_unicast_loopback_tests: PASS")
