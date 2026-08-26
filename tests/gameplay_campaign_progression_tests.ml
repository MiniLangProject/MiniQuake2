/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Goal-graph progression through real key/counter/changelevel callbacks. */
import miniquake2.game.integration.campaign_progression as goalprogress
import miniquake2.game.null_game as goalgame
import miniquake2.server.game_bridge as goalbridge
import miniquake2.runtime.play_session as goalplay

function goalAssert(value, message)
  if value != true then return error(9975, message) end if
  return true
end function

goalAssert(goalprogress.normalizedMapName("base2$base1") == "base2", "spawn suffix normalization")
goalAssert(goalprogress.normalizedMapName("eou1_.cin+*bunk1$start") == "bunk1", "unit cinematic normalization")
goalAssert(goalprogress.normalizedMapName("end.cin+victory.pcx") == "victory.pcx", "terminal cinematic normalization")

goalServer = goalbridge.createRuntime(4)
goalApi = goalgame.GetGameApi(goalbridge.makeImports(goalServer))
goalServer.game = goalApi
goalApi.init()
goalFixture = "{\"classname\" \"worldspawn\"}" +
  "{\"classname\" \"info_player_start\" \"origin\" \"0 0 0\"}" +
  "{\"classname\" \"key_data_cd\" \"origin\" \"24 0 0\"}" +
  "{\"classname\" \"trigger_key\" \"target\" \"exit_counter\" \"item\" \"key_data_cd\"}" +
  "{\"classname\" \"trigger_counter\" \"targetname\" \"exit_counter\" \"target\" \"exit_goal\" \"count\" \"2\"}" +
  "{\"classname\" \"target_changelevel\" \"targetname\" \"exit_goal\" \"map\" \"eou1_.cin+*bunk1$start\"}"
goalApi.spawnEntities("goal-source", goalFixture, "")
goalClient = goalApi.edicts[1]
goalAssert(goalApi.clientConnect(goalClient, "\\name\\GoalDriver\\skin\\male/grunt"), "client connect")
goalAssert(goalApi.clientBegin(goalClient), "client begin")
// SpawnItem exposes keys only after the original two-frame droptofloor think.
goalApi.runFrame(); goalApi.runFrame()
goalResult = goalprogress.driveToMap(goalgame.baseRuntime(), goalgame.playerContext(), "bunk1")
goalAssert(goalResult.reached and goalResult.selectedMapSpec == "eou1_.cin+*bunk1$start",
  "goal graph reaches normalized changelevel")
goalAssert(not goalResult.directFallback and goalResult.actions == 1 and goalResult.keys == 1,
  "key and counter state machines drive exit without direct fallback")
goalAssert(goalgame.playerContext().nextMap == "eou1_.cin+*bunk1$start",
  "original changelevel specification is retained")
goalApi.clientDisconnect(goalClient)
goalApi.shutdown()

function main(args)
  if len(args) > 1 then return error(9976, "expected optional Quake II install root") end if
  if len(args) == 1 then
    goalRetailSession = goalplay.createRetail(args[0], "base1",
      "\\name\\RetailGoalDriver\\skin\\male/grunt\\rate\\25000")
    goalplay.runUntilActive(goalRetailSession, 512)
    goalRetailResult = goalprogress.driveToMap(goalgame.baseRuntime(), goalgame.playerContext(), "base2")
    goalAssert(goalRetailResult.reached and not goalRetailResult.directFallback,
      "retail base1 exit did not traverse its real goal graph")
    goalAssert(goalRetailResult.selectedMapSpec == "base2$base1" and goalRetailResult.actions == 1,
      "retail base1 selected the wrong transition")
    goalplay.shutdown(goalRetailSession)
    print("gameplay_campaign_progression_tests: PASS (synthetic + retail base1)")
  else
    print("gameplay_campaign_progression_tests: PASS (synthetic)")
  end if
  return 0
end function
