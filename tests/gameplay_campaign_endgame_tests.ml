/* Deterministic boss2 Jorg -> Makron -> counter -> intermission progression. */
import miniquake2.server.game_bridge as endgamebridge
import miniquake2.game.null_game as endgamegame
import miniquake2.game.integration.baseq2 as endgameintegration
import miniquake2.game.world.constants as endgameworldconstants
import std.string as endgamestring

function endgameAssert(value, message)
  if value != true then return error(9845, message) end if
  return true
end function

server = endgamebridge.createRuntime(4)
api = endgamegame.GetGameApi(endgamebridge.makeImports(server))
server.game = api
api.init()
fixture = "{\"classname\" \"worldspawn\"}" +
  "{\"classname\" \"info_player_start\" \"origin\" \"0 0 0\"}" +
  "{\"classname\" \"trigger_counter\" \"targetname\" \"t26\" \"target\" \"t5\" \"count\" \"2\"}" +
  "{\"classname\" \"target_changelevel\" \"targetname\" \"t5\" \"map\" \"*victory\"}" +
  "{\"classname\" \"monster_jorg\" \"origin\" \"128 0 0\" \"target\" \"t26\"}"
api.spawnEntities("boss2", fixture, "")
runtime = endgamegame.baseRuntime()
context = endgamegame.playerContext()
counter = endgameintegration.findWorldByClass(runtime, "trigger_counter")
endgameAssert(len(runtime.monsters) == 1 and runtime.monsters[0].className == "monster_jorg", "Jorg spawn phase")
endgameAssert(counter.count == 2 and runtime.world.intermission == false, "endgame counter initial state")

runtime.world.serverFlags = endgameworldconstants.SFL_CROSS_TRIGGER_MASK | 0x100
jorgNumber = runtime.monsters[0].edict.state.number
endgameintegration.damageMonster(runtime, 0, void, 4000)
endgameAssert(runtime.monsters[0].deadFlag != 0, "Jorg death dispatch")
endgameAssert(counter.count == 1 and runtime.world.intermission == false, "Jorg only advances first counter phase")
endgameAssert(len(runtime.monsters) == 2, "Makron successor spawned")
makron = runtime.monsters[1]
endgameAssert(makron.className == "monster_makron" and makron.target == "t26", "Makron inherits Jorg target")
endgameAssert(makron.health == 3000 and makron.mass == 500 and makron.activity == "boss-successor", "Makron stock defaults")
endgameAssert(makron.edict.state.number != jorgNumber and makron.edict.state.number < api.numEdicts,
  "Makron owns a live exported edict")
endgameAssert(makron.edict.state.modelIndex > 0, "Makron model bound")

endgameintegration.damageMonster(runtime, 1, void, 4000)
endgameAssert(counter.count == 0, "Makron completes second counter phase")
endgameAssert(runtime.world.intermission, "endgame target begins intermission")
endgameAssert(context.nextMap == "*victory" and context.intermissionTime > 0.0, "changelevel reaches player transition state")
endgameAssert((runtime.world.serverFlags & endgameworldconstants.SFL_CROSS_TRIGGER_MASK) == 0,
  "new unit clears cross-level trigger flags")

context.exitIntermission = true
api.runFrame()
endgameAssert(endgamestring.contains(server.commands.buffer, "gamemap \"*victory\""),
  "intermission exit queues gamemap command")
api.shutdown()
print("gameplay_campaign_endgame_tests: PASS")
