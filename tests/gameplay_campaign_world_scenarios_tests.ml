/* Deterministic campaign entity behavior scenarios without retail assets. */
import miniquake2.game.base.spawn as campworldspawn
import miniquake2.game.integration.baseq2 as campworldintegration
import miniquake2.game.world.core as campworldcore
import miniquake2.game.world.types as campworldtypes
import miniquake2.game.world.constants as campworldconstants

function scenarioAssert(value, message)
  if value != true then return error(9895, message) end if
  return true
end function

fixture = "{\"classname\" \"worldspawn\"}" +
  "{\"classname\" \"func_door_rotating\" \"model\" \"*1\" \"targetname\" \"rot\" \"distance\" \"90\" \"speed\" \"100\"}" +
  "{\"classname\" \"trigger_push\" \"targetname\" \"push\" \"angle\" \"0\" \"speed\" \"100\"}" +
  "{\"classname\" \"misc_teleporter\" \"target\" \"arrival\"}" +
  "{\"classname\" \"misc_teleporter_dest\" \"targetname\" \"arrival\" \"origin\" \"100 20 30\" \"angle\" \"90\"}" +
  "{\"classname\" \"trigger_counter\" \"target\" \"pulse\" \"count\" \"2\"}" +
  "{\"classname\" \"target_temp_entity\" \"targetname\" \"pulse\" \"style\" \"7\"}" +
  "{\"classname\" \"target_laser\" \"target\" \"arrival\" \"dmg\" \"3\"}"

runtime = campworldintegration.create(campworldspawn.SpawnEntities("campaign-scenarios", fixture, ""))
world = runtime.world

rotatingDoor = campworldintegration.findWorldByClass(runtime, "func_door_rotating")
campworldcore.useEntity(world, rotatingDoor, void, rotatingDoor)
campworldcore.advance(world, 0.9)
scenarioAssert(rotatingDoor.moveInfo.state == campworldconstants.STATE_TOP, "rotating door reaches top state")
scenarioAssert(rotatingDoor.angles.y == 90.0, "rotating door reaches configured angle")

actor = campworldtypes.createEntity(900, "player-proxy")
actor.isClient = true
actor.health = 100
push = campworldintegration.findWorldByClass(runtime, "trigger_push")
campworldcore.touchEntity(world, push, actor)
scenarioAssert(actor.velocity.x == 1000.0, "trigger_push applies BaseQ2 tenfold launch speed")

teleporter = campworldintegration.findWorldByClass(runtime, "misc_teleporter")
campworldcore.touchEntity(world, teleporter, actor)
scenarioAssert(actor.origin.x == 100.0 and actor.origin.y == 20.0 and actor.origin.z == 40.0, "teleporter resolves destination and height offset")
scenarioAssert(actor.angles.y == 90.0, "teleporter adopts destination angles")

counter = campworldintegration.findWorldByClass(runtime, "trigger_counter")
campworldcore.useEntity(world, counter, void, actor)
scenarioAssert(counter.count == 1, "counter waits for remaining activation")
eventCount = len(world.events)
campworldcore.useEntity(world, counter, void, actor)
scenarioAssert(counter.count == 0 and len(world.events) > eventCount, "counter completes and fires targets")

laser = campworldintegration.findWorldByClass(runtime, "target_laser")
// Stock SP_target_laser defers target resolution and installs its use
// callback one second so all possible targets have spawned first.
campworldcore.advance(world, world.time + 0.2)
campworldcore.useEntity(world, laser, void, actor)
scenarioAssert(laser.nextThink > world.time, "laser starts deterministic frame think")
scenarioAssert(laser.moveDirection.x != 0.0 or laser.moveDirection.y != 0.0 or laser.moveDirection.z != 0.0, "laser aims at target")

print "gameplay_campaign_world_scenarios_tests: PASS"
