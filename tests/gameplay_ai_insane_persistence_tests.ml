/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Integrated misc_insane spawn and private move-phase restoration. */
import std.fs as insanepersistfs
import miniquake2.server.game_bridge as insanepersistbridge
import miniquake2.game.null_game as insanepersistgame
import miniquake2.game.integration.baseq2 as insanepersistintegration
import miniquake2.game.constants as insanepersistconstants

// Assert the insane persist test condition.
function insanePersistAssert(value, message)
  if value != true then return error(9829, message) end if
  return true
end function

insanePersistPath = "gameplay_ai_insane_persistence_tests.sav"
if insanepersistfs.exists(insanePersistPath) then insanepersistfs.delete(insanePersistPath) end if

insanePersistServer = insanepersistbridge.createRuntime(4)
insanePersistApi = insanepersistgame.GetGameApi(insanepersistbridge.makeImports(insanePersistServer))
insanePersistServer.game = insanePersistApi
insanePersistApi.init()
insanePersistFixture = "{\"classname\" \"worldspawn\"}" +
  "{\"classname\" \"info_player_start\" \"origin\" \"0 0 0\"}" +
  "{\"classname\" \"misc_insane\" \"origin\" \"64 16 8\" \"angles\" \"0 90 0\" \"spawnflags\" \"20\"}"
insanePersistApi.spawnEntities("insane-save", insanePersistFixture, "")
insanePersistRuntime = insanepersistgame.baseRuntime()
insanePersistAssert(len(insanePersistRuntime.monsters) == 1 and
  insanePersistRuntime.monsters[0].className == "misc_insane", "misc_insane uses integrated AI path")
insanePersistActor = insanePersistRuntime.monsters[0]
insanePersistAssert(insanePersistActor.health == 100 and insanePersistActor.mass == 300 and
  insanePersistActor.model == "models/monsters/insane/tris.md2", "integrated Classic defaults")
insanePersistAssert(insanePersistActor.info.currentMove.name == "insane-down", "parsed crawl/stand-ground flags applied")
insanePersistAssert(insanePersistActor.edict.state.modelIndex > 0, "insane model is precached and bound")

insanePersistActor.edict.state.frame = 100
insanepersistintegration.damageMonster(insanePersistRuntime, 0, void, 10)
insanePersistAssert(insanePersistActor.info.currentMove.name == "insane-crawl-pain" and
  insanePersistActor.activity == "insane-crawl-pain", "crawl pain phase entered")
insanePersistSavedFrame = insanePersistActor.edict.state.frame
insanePersistSavedThink = insanePersistActor.nextThink
insanePersistApi.writeLevel(insanePersistPath)

insanePersistActor.activity = "mutated"
insanePersistActor.info.currentMove = void
insanePersistActor.health = 1
insanePersistApi.readLevel(insanePersistPath)
insanePersistRuntime = insanepersistgame.baseRuntime()
insanePersistActor = insanePersistRuntime.monsters[0]
insanePersistAssert(insanePersistActor.className == "misc_insane" and insanePersistActor.health == 90,
  "insane health/class restored")
insanePersistAssert(insanePersistActor.info.currentMove.name == "insane-crawl-pain" and
  insanePersistActor.activity == "insane-crawl-pain", "crawl pain move callback table rebound")
insanePersistAssert(insanePersistActor.edict.state.frame == insanePersistSavedFrame, "pain frame restored")
insanePersistAssert(insanePersistActor.nextThink > 0.0 and insanePersistActor.nextThink < 0.11,
  "pain think deadline restored")
insanePersistApi.runFrame(); insanePersistApi.runFrame()
insanePersistAssert(insanePersistActor.edict.state.frame == 236, "restored pain phase continues deterministically")

insanePersistActor.edict.state.frame = 230
insanePersistActor.health = 40
insanepersistintegration.damageMonster(insanePersistRuntime, 0, void, 50)
insanePersistAssert(insanePersistActor.info.currentMove.name == "insane-crawl-death", "crawl death phase entered")
insanePersistApi.writeLevel(insanePersistPath)
insanePersistApi.readLevel(insanePersistPath)
insanePersistRuntime = insanepersistgame.baseRuntime()
insanePersistActor = insanePersistRuntime.monsters[0]
insanePersistAssert(insanePersistActor.info.currentMove.name == "insane-crawl-death" and
  insanePersistActor.deathUseComplete, "death phase and exactly-once gate restored")
insanePersistDeathFrames = 0
while insanePersistActor.activity != "insane-dead" and insanePersistDeathFrames < 10
  insanePersistApi.runFrame()
  insanePersistDeathFrames = insanePersistDeathFrames + 1
end while
insanePersistAssert(insanePersistActor.activity == "insane-dead" and insanePersistActor.nextThink == 0.0,
  "restored death move reaches terminal corpse")
insanePersistAssert(insanePersistActor.edict.maxs.z == -8.0 and
  (insanePersistActor.edict.serverFlags & insanepersistconstants.SVF_DEADMONSTER) != 0,
  "restored corpse bounds/server flag")

insanePersistApi.shutdown()
insanepersistfs.delete(insanePersistPath)
print("gameplay_ai_insane_persistence_tests: PASS")
