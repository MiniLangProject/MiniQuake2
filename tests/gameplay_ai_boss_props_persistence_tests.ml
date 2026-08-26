/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Integrated save/restore of scripted boss prop think/use phases. */
import std.fs as bosspropsavefs
import miniquake2.server.game_bridge as bosspropsavebridge
import miniquake2.game.null_game as bosspropsavegame
import miniquake2.game.ai.monster as bosspropsavemonster
import miniquake2.game.ai.constants as bosspropsaveconstants
import miniquake2.game.integration.baseq2 as bosspropsaveintegration

function bossPropSaveAssert(value, message)
  if value != true then return error(9629, message) end if
  return true
end function

function bossPropSaveActor(runtime, className)
  for each bossPropSaveCandidate in runtime.monsters
    if bossPropSaveCandidate.className == className then return bossPropSaveCandidate end if
  end for
  return void
end function

function bossPropSaveFindName(values, name)
  bossPropSaveIndex = 0
  while bossPropSaveIndex < len(values)
    if values[bossPropSaveIndex] == name then return bossPropSaveIndex end if
    bossPropSaveIndex = bossPropSaveIndex + 1
  end while
  return -1
end function

bossPropSavePath = "gameplay_ai_boss_props_persistence_tests.sav"
if bosspropsavefs.exists(bossPropSavePath) then bosspropsavefs.delete(bossPropSavePath) end if

bossPropSaveServer = bosspropsavebridge.createRuntime(4)
bossPropSaveApi = bosspropsavegame.GetGameApi(bosspropsavebridge.makeImports(bossPropSaveServer))
bossPropSaveServer.game = bossPropSaveApi
bossPropSaveApi.init()
bossPropSaveFixture = "{\"classname\" \"worldspawn\"}" +
  "{\"classname\" \"info_player_start\" \"origin\" \"0 0 0\"}" +
  "{\"classname\" \"monster_boss3_stand\" \"origin\" \"64 0 8\" \"targetname\" \"boss-prop\"}" +
  "{\"classname\" \"monster_commander_body\" \"origin\" \"128 0 16\" \"targetname\" \"body-prop\"}"
bossPropSaveApi.spawnEntities("boss-props", bossPropSaveFixture, "")
bossPropSaveRuntime = bosspropsavegame.baseRuntime()
bossPropSaveBoss = bossPropSaveActor(bossPropSaveRuntime, "monster_boss3_stand")
bossPropSaveBody = bossPropSaveActor(bossPropSaveRuntime, "monster_commander_body")
bossPropSaveAssert(len(bossPropSaveRuntime.monsters) == 2 and bossPropSaveBoss is not void and bossPropSaveBody is not void,
  "scripted props use integrated AI archetype path")
bossPropSaveAssert(bossPropSaveBoss.edict.state.modelIndex > 0 and bossPropSaveBody.edict.state.modelIndex > 0,
  "scripted prop models bound: boss=" + bossPropSaveBoss.edict.state.modelIndex +
  " commander=" + bossPropSaveBody.edict.state.modelIndex +
  " boss-model=" + bossPropSaveBoss.model + " commander-model=" + bossPropSaveBody.model +
  " registered-boss=" + bossPropSaveFindName(bossPropSaveServer.modelNames, bossPropSaveBoss.model) +
  " registered-commander=" + bossPropSaveFindName(bossPropSaveServer.modelNames, bossPropSaveBody.model))
bossPropSaveAssert(bosspropsaveintegration.damageMonster(bossPropSaveRuntime, 1, void, 1000) == false and
  bossPropSaveBody.health == bossPropSaveBody.maxHealth, "integrated commander godmode rejects damage")

bossPropSaveApi.runFrame(); bossPropSaveApi.runFrame(); bossPropSaveApi.runFrame()
bossPropSaveBossFrame = bossPropSaveBoss.edict.state.frame
bossPropSaveAssert(bossPropSaveBossFrame > 414 and bossPropSaveBody.activity == "commander-drop-wait",
  "pre-save recurring/drop-wait phases: boss-frame=" + bossPropSaveBossFrame +
  " commander=" + bossPropSaveBody.activity)
bossPropSaveApi.writeLevel(bossPropSavePath)
bossPropSaveBoss.edict.state.frame = 999
bossPropSaveBody.activity = "mutated"
bossPropSaveBody.moveType = 999
bossPropSaveApi.readLevel(bossPropSavePath)
bossPropSaveRuntime = bosspropsavegame.baseRuntime()
bossPropSaveBoss = bossPropSaveActor(bossPropSaveRuntime, "monster_boss3_stand")
bossPropSaveBody = bossPropSaveActor(bossPropSaveRuntime, "monster_commander_body")
bossPropSaveAssert(bossPropSaveBoss.activity == "boss3-stand" and
  bossPropSaveBoss.edict.state.frame == bossPropSaveBossFrame, "boss3 stand frame/phase restored")
bossPropSaveAssert(bossPropSaveBody.activity == "commander-drop-wait" and
  bossPropSaveBody.moveType == bosspropsaveconstants.MOVETYPE_NONE, "commander pending-drop phase/movetype restored")

bossPropDropFrames = 0
while bossPropSaveBody.activity == "commander-drop-wait" and bossPropDropFrames < 5
  bossPropSaveApi.runFrame()
  bossPropDropFrames = bossPropDropFrames + 1
end while
bossPropSaveAssert(bossPropSaveBody.activity == "commander-idle" and
  bossPropSaveBody.moveType == bosspropsaveconstants.MOVETYPE_TOSS and
  bossPropSaveBody.edict.state.origin.z == 18.0,
  "restored commander drop continues: activity=" + bossPropSaveBody.activity +
    " movetype=" + bossPropSaveBody.moveType +
    " z=" + bossPropSaveBody.edict.state.origin.z +
    " nextthink=" + bossPropSaveBody.nextThink +
    " worldtime=" + bossPropSaveRuntime.world.time)

bossPropSaveContext = bossPropSaveRuntime.aiContext
bossPropSaveAssert(bosspropsavemonster.MonsterUse(bossPropSaveBoss, void, void, bossPropSaveContext),
  "boss3 Root handoff use")
bossPropSaveAssert(bosspropsavemonster.MonsterUse(bossPropSaveBody, void, void, bossPropSaveContext),
  "commander Root handoff use")
bossPropSaveBody.edict.state.frame = 21
bossPropSaveApi.writeLevel(bossPropSavePath)
bossPropSaveBody.activity = "mutated"
bossPropSaveBody.edict.state.frame = 0
bossPropSaveApi.readLevel(bossPropSavePath)
bossPropSaveRuntime = bosspropsavegame.baseRuntime()
bossPropSaveBoss = bossPropSaveActor(bossPropSaveRuntime, "monster_boss3_stand")
bossPropSaveBody = bossPropSaveActor(bossPropSaveRuntime, "monster_commander_body")
bossPropSaveAssert(bossPropSaveBoss.edict.inUse == false and bossPropSaveBoss.activity == "boss3-teleported" and
  bossPropSaveBoss.nextThink == 0.0, "boss3 freed/teleported phase restored")
bossPropSaveAssert(bossPropSaveBody.activity == "commander-animate" and bossPropSaveBody.edict.state.frame == 21 and
  bossPropSaveBody.moveType == bosspropsaveconstants.MOVETYPE_TOSS, "commander active frame/movetype restored")
bossPropSaveAssert((bossPropSaveBody.flags & bosspropsaveconstants.FL_GODMODE) != 0 and bossPropSaveBody.takeDamage == 1,
  "commander godmode/takedamage restored")

bossPropAnimateFrames = 0
while bossPropSaveBody.edict.state.frame == 21 and bossPropAnimateFrames < 3
  bossPropSaveApi.runFrame()
  bossPropAnimateFrames = bossPropAnimateFrames + 1
end while
bossPropSaveAssert(bossPropSaveBody.edict.state.frame == 22 and bossPropSaveBody.activity == "commander-animate",
  "restored commander animation resumes at thud frame")
bossPropTerminalFrames = 0
while bossPropSaveBody.activity == "commander-animate" and bossPropTerminalFrames < 10
  bossPropSaveApi.runFrame()
  bossPropTerminalFrames = bossPropTerminalFrames + 1
end while
bossPropSaveAssert(bossPropSaveBody.edict.state.frame == 24 and bossPropSaveBody.nextThink == 0.0,
  "restored commander animation reaches terminal frame")

bossPropSaveApi.shutdown()
bosspropsavefs.delete(bossPropSavePath)
print("gameplay_ai_boss_props_persistence_tests: PASS")
