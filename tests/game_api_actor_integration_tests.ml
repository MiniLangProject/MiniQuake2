/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Live Game API spawn, model, dormant-use and invalid-gate coverage for misc_actor. */
import miniquake2.server.game_bridge as actorlivebridge
import miniquake2.game.null_game as actorlivegame
import miniquake2.game.integration.baseq2 as actorliveintegration
import miniquake2.game.world.core as actorliveworld
import miniquake2.game.world.types as actorlivetypes
import miniquake2.game.world.constants as actorliveworldconstants
import std.fs as actorlivefs

// Assert the actor live test condition.
function actorLiveAssert(value, message)
  if value != true then return error(9840, message) end if
  return true
end function

// Report whether actor live equal.
function actorLiveEqual(actual, expected, message)
  if actual != expected then
    return error(9841, message + ": expected " + expected + ", got " + actual)
  end if
  return true
end function

server = actorlivebridge.createRuntime(4)
api = actorlivegame.GetGameApi(actorlivebridge.makeImports(server))
server.game = api
api.init()

fixture = "{\"classname\" \"worldspawn\"}" +
  "{\"classname\" \"info_player_start\" \"origin\" \"0 0 0\"}" +
  "{\"classname\" \"misc_actor\" \"origin\" \"0 0 24\" " +
    "\"targetname\" \"start-actor\" \"target\" \"actor-route-1\"}" +
  "{\"classname\" \"target_actor\" \"origin\" \"128 0 24\" " +
    "\"targetname\" \"actor-route-1\" \"pathtarget\" \"actor-enemy\" " +
    "\"spawnflags\" \"4\"}" +
  "{\"classname\" \"info_notnull\" \"origin\" \"256 0 24\" " +
    "\"targetname\" \"actor-enemy\" \"health\" \"50\"}"
api.spawnEntities("actor-live", fixture, "")
runtime = actorlivegame.baseRuntime()
actorLiveEqual(len(runtime.monsters), 1, "one live scripted actor")
actor = runtime.monsters[0]
actorLiveEqual(actor.className, "misc_actor", "live AI class")
actorLiveEqual(actor.model, "players/male/tris.md2", "live actor model")
actorLiveAssert(actor.edict.state.modelIndex > 0, "actor model indexed during spawn")
actorLiveEqual(actor.edict.mins.x, -16.0, "actor bbox minimum")
actorLiveEqual(actor.edict.maxs.z, 32.0, "actor bbox maximum")
actorLiveEqual(actor.info.currentMove.name, "actor-stand", "live actor dormant")
actorLiveAssert(actor.moveTarget is void and actor.target == "actor-route-1",
  "route remains unresolved before use")

startTargets = actorliveworld.matchingTargets(runtime.world, "start-actor")
actorLiveEqual(len(startTargets), 1, "targetname proxy installed")
actorLiveAssert(actorliveworld.useEntity(runtime.world, startTargets[0], void, void),
  "live world use reaches actor_use")
actorLiveEqual(actor.info.currentMove.name, "actor-walk", "live use enters walk")
actorLiveAssert(actor.moveTarget is not void and
  actor.moveTarget.className == "target_actor", "live route resolves target_actor")
actorLiveEqual(actor.target, "", "live route start is single-use")

startX = actor.edict.state.origin.x
api.runFrame()
api.runFrame()
actorLiveAssert(actor.edict.state.origin.x > startX,
  "live actor advances along route after use")
actorLiveAssert(actor.edict.linkCount > 0, "moving actor remains engine-linked")

savePath = "game_api_actor_integration_tests.sav"
if actorlivefs.exists(savePath) then actorlivefs.delete(savePath) end if
savedFrame = actor.edict.state.frame
api.writeLevel(savePath)
actor.info.currentMove = void
actor.activity = "mutated"
actor.health = 1
api.readLevel(savePath)
runtime = actorlivegame.baseRuntime()
actor = runtime.monsters[0]
actorLiveEqual(actor.health, 100, "actor health restored")
actorLiveEqual(actor.info.currentMove.name, "actor-walk",
  "actor callback table rebound after restore")
actorLiveEqual(actor.activity, "actor-walk", "actor route phase restored")
actorLiveEqual(actor.edict.state.frame, savedFrame, "actor route frame restored")
actorlivefs.delete(savePath)

waypoints = actorliveworld.matchingTargets(runtime.world, "actor-route-1")
actorLiveEqual(len(waypoints), 1, "live actor attack waypoint")
attackTargets = actorliveworld.matchingTargets(runtime.world, "actor-enemy")
actorLiveEqual(len(attackTargets), 1, "live actor attack target")
attackTargets[0].takeDamage = actorliveworldconstants.DAMAGE_YES
actorProxy = actorlivetypes.createEntity(actor.edict.state.number, "misc_actor")
actorProxy.targetEntity = waypoints[0]
actorProxy.origin = actor.edict.state.origin
actorProxy.health = actor.health
actorProxy.maxHealth = actor.maxHealth
actorLiveAssert(actorliveworld.touchEntity(runtime.world, waypoints[0], actorProxy),
  "live target_actor attack touch")
actorLiveAssert(actor.enemy is not void and actor.goalEntity is not void and
  actor.goalEntity.edict.state.number == actor.enemy.edict.state.number,
  "attack waypoint assigns enemy and goal")
actorLiveEqual(actor.info.currentMove.name, "actor-run", "attack waypoint enters run")
actorliveintegration.runMonsterCombat(runtime, actor)
actorLiveEqual(actor.activity, "misc_actor-single", "live actor attack plan")
actorLiveAssert(actor.attackCycles >= 10 and actor.attackCycles <= 25,
  "live actor burst length follows rand-and-15 range")
actorLiveEqual(actor.edict.state.frame, 0, "live burst holds attack01")

invalidFixture = "{\"classname\" \"worldspawn\"}" +
  "{\"classname\" \"info_player_start\" \"origin\" \"0 0 0\"}" +
  "{\"classname\" \"misc_actor\" \"target\" \"actor-route-1\"}" +
  "{\"classname\" \"misc_actor\" \"targetname\" \"start-actor\"}"
api.spawnEntities("actor-invalid", invalidFixture, "")
runtime = actorlivegame.baseRuntime()
actorLiveEqual(len(runtime.monsters), 0, "malformed actors are freed during spawn")
// GameExport retains world + four reserved client slots before the sole
// info_player_start edict. The two freed actors must not raise that floor.
actorLiveEqual(api.numEdicts, 6, "malformed actors consume no live edict slots")

api.shutdown()
print("game_api_actor_integration_tests: PASS")
