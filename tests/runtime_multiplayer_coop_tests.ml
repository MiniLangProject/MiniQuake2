/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Real two-client UDP coop session: shared map, key stay, disconnect/reconnect. */
import miniquake2.network.constants as mpctestnetworkconstants
import miniquake2.game.null_game as mpctestgameapi
import miniquake2.game.integration.baseq2 as mpctestbaseq2
import miniquake2.runtime.multiplayer_session as mpctestsession

// Assert the mpc test condition.
function mpcAssert(value, name)
  if not value then return error(8430, name) end if
  return true
end function

mpcEntities = "{\n\"classname\" \"worldspawn\"\n\"message\" \"Two Player Coop\"\n}\n" +
  "{\n\"classname\" \"info_player_start\"\n\"origin\" \"0 0 24\"\n}\n" +
  "{\n\"classname\" \"info_player_coop\"\n\"origin\" \"96 0 24\"\n}\n" +
  "{\n\"classname\" \"key_data_cd\"\n\"origin\" \"48 0 24\"\n}\n"

mpcSession = mpctestsession.createCore(mpctestsession.MODE_COOP,
  "coop_two", mpcEntities, void,
  ["\\name\\Ranger\\skin\\male/grunt", "\\name\\Athena\\skin\\female/athena"])
mpcActive = mpctestsession.runUntilActive(mpcSession, 500)
mpcAssert(mpcActive.activeClients == 2, "both coop clients did not become active")
mpcContext = mpctestgameapi.playerContext()
mpcAssert(mpcContext.cooperative and not mpcContext.deathmatch,
  "coop mode was not installed before spawn")
mpcAssert(mpcSession.clients[0].integrated.network.levelName == "coop_two" and
  mpcSession.clients[1].integrated.network.levelName == "coop_two" and
  mpcSession.clients[0].integrated.network.spawnCount == mpcSession.clients[1].integrated.network.spawnCount,
  "coop clients do not share map/spawn epoch")
mpcPlayer0 = mpctestsession.player(mpcSession, 0)
mpcPlayer1 = mpctestsession.player(mpcSession, 1)
mpcAssert(mpctestsession.snapshotHasEntity(mpcSession, 0, mpcPlayer1.edict.state.number) and
  mpctestsession.snapshotHasEntity(mpcSession, 1, mpcPlayer0.edict.state.number),
  "coop snapshots do not expose the teammate")

mpcKey = mpctestbaseq2.findItemByClass(mpctestgameapi.baseRuntime(), "key_data_cd")
mpcAssert(mpcKey is not void and mpcKey.edict.inUse, "coop key did not spawn")
mpcFirstPickup = mpctestsession.touchItem(mpcSession, 0, "key_data_cd")
mpcAssert(mpcFirstPickup.success and mpcKey.edict.inUse and not mpcKey.hidden,
  "coop key did not stay after first pickup")
mpcSecondPickup = mpctestsession.touchItem(mpcSession, 1, "key_data_cd")
mpcAssert(mpcSecondPickup.success and mpcKey.edict.inUse and not mpcKey.hidden,
  "coop key did not stay for teammate pickup")
mpcKeyIndex = mpcKey.item.index
mpcAssert(mpcPlayer0.gameplay.inventory.counts[mpcKeyIndex] == 1 and
  mpcPlayer1.gameplay.inventory.counts[mpcKeyIndex] == 1,
  "coop players did not retain independent key inventory")
mpcAssert(mpctestsession.result(mpcSession).packetsRejected == 0,
  "coop active transport rejected a packet")

mpcOldSlot = mpctestsession.serverSlot(mpcSession, 1)
mpcAssert(mpctestsession.disconnectClient(mpcSession, 1), "coop disconnect did not free server slot")
mpcAssert(mpcSession.server.networkRuntime.server.clients[mpcOldSlot].state == mpctestnetworkconstants.CS_FREE,
  "coop disconnected slot is not free")
mpcAssert(not mpcPlayer1.persistent.connected and not mpcPlayer1.edict.inUse,
  "game ClientDisconnect was not dispatched")
mpcAssert(mpctestsession.activeClients(mpcSession) == 1,
  "surviving coop client did not remain active")
mpctestsession.reconnectClient(mpcSession, 1,
  "\\name\\AthenaReturns\\skin\\female/athena")
mpcReconnected = mpctestsession.runUntilActive(mpcSession, 500)
mpcAssert(mpcReconnected.activeClients == 2, "coop reconnect did not complete signon")
mpcNewPlayer = mpctestsession.player(mpcSession, 1)
mpcAssert(mpcNewPlayer.persistent.connected and mpcNewPlayer.edict.inUse and
  mpcNewPlayer.persistent.netName == "AthenaReturns",
  "reconnected coop player did not re-enter live game state")
mpcAssert(mpcSession.clients[1].integrated.network.levelName == "coop_two" and
  mpcSession.clients[1].integrated.network.spawnCount == mpcSession.clients[0].integrated.network.spawnCount,
  "reconnected coop client joined a stale map epoch")
mpcAssert(mpctestsession.snapshotHasEntity(mpcSession, 0, mpcNewPlayer.edict.state.number) and
  mpctestsession.snapshotHasEntity(mpcSession, 1, mpcPlayer0.edict.state.number),
  "coop teammate visibility did not recover after reconnect")
mpcAssert(mpctestsession.shutdown(mpcSession), "coop shutdown failed")
print("runtime_multiplayer_coop_tests: PASS")
