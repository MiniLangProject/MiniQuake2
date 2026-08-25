/* Deterministic g_misc.c/func_wall/func_rotating behavior regressions. */
import miniquake2.game.world.constants as rwconstants
import miniquake2.game.world.core as rwcore
import miniquake2.game.world.misc as rwmisc
import miniquake2.game.world.types as rwtypes
import miniquake2.qcommon.types as rwqtypes

retailWorldLinks = 0
retailWorldDamage = 0
retailWorldRadius = 0
retailWorldEffects = 0
retailWorldKillBoxes = 0

function assertEqual(actual, expected, name)
  if actual != expected then return error(9991, name + ": values differ") end if
  return true
end function

function assertTrue(value, name)
  if value != true then return error(9992, name + ": expected true") end if
  return true
end function

function recordLink(entity)
  global retailWorldLinks
  retailWorldLinks = retailWorldLinks + 1
  return true
end function

function recordDamage(target, inflictor, attacker, amount, means)
  global retailWorldDamage
  retailWorldDamage = retailWorldDamage + amount
  return true
end function

function recordRadius(inflictor, attacker, amount, radius, means)
  global retailWorldRadius
  retailWorldRadius = retailWorldRadius + amount
  return true
end function

function recordEffect(kind, origin, style, count)
  global retailWorldEffects
  retailWorldEffects = retailWorldEffects + 1
  return true
end function

function recordKillBox(entity)
  global retailWorldKillBoxes
  retailWorldKillBoxes = retailWorldKillBoxes + 1
  return true
end function

function createWorld()
  callbacks = rwcore.defaultCallbacks()
  callbacks.linkEntity = recordLink
  callbacks.damage = recordDamage
  callbacks.radiusDamage = recordRadius
  callbacks.effect = recordEffect
  callbacks.killBox = recordKillBox
  return rwcore.createWorld(callbacks)
end function

function testWallAndRotating()
  global retailWorldDamage, retailWorldKillBoxes
  world = createWorld()
  wall = rwtypes.createEntity(1, "func_wall")
  wall.model = "*1"
  wall.spawnFlags = 1 | 2
  rwcore.addEntity(world, wall)
  rwmisc.spawnWall(wall, world)
  assertEqual(wall.solid, rwconstants.SOLID_NOT, "trigger wall starts hidden")
  assertTrue((wall.serverFlags & rwconstants.SVF_NOCLIENT) != 0, "hidden wall no-client")
  rwcore.useEntity(world, wall, void, void)
  assertEqual(wall.solid, rwconstants.SOLID_BSP, "wall use enables collision")
  assertEqual(retailWorldKillBoxes, 1, "wall use killbox")
  rwcore.useEntity(world, wall, void, void)
  assertEqual(wall.solid, rwconstants.SOLID_NOT, "toggle wall disables collision")

  rotating = rwtypes.createEntity(2, "func_rotating")
  rotating.model = "*2"
  rotating.spawnFlags = 1 | 4 | 16
  rotating.speed = 120.0
  rwcore.addEntity(world, rotating)
  rwmisc.spawnRotating(rotating, world)
  assertEqual(rotating.angularVelocity.z, 120.0, "rotating X-axis mapping and start-on")
  victim = rwtypes.createEntity(3, "player-proxy")
  rwmisc.rotatingTouch(rotating, victim, world)
  assertEqual(retailWorldDamage, 2, "rotating touch damage")
  rwcore.useEntity(world, rotating, void, void)
  assertEqual(rotating.angularVelocity.z, 0.0, "rotating use stops")
  return true
end function

function testExploboxLifecycle()
  global retailWorldRadius, retailWorldEffects
  world = createWorld()
  barrel = rwtypes.createEntity(1, "misc_explobox")
  barrel.origin = rwqtypes.Vec3(32.0, 0.0, 0.0)
  rwcore.addEntity(world, barrel)
  rwmisc.spawnExplobox(barrel, world)
  assertEqual(barrel.model, "models/objects/barrels/tris.md2", "barrel model")
  assertEqual(barrel.health, 10, "barrel default health")
  assertEqual(barrel.mass, 400, "barrel default mass")
  assertEqual(barrel.damage, 150, "barrel default damage")
  assertEqual(barrel.solid, rwconstants.SOLID_BBOX, "barrel bbox solid")
  rwcore.advance(world, 0.2)
  assertEqual(barrel.nextThink, 0.0, "barrel drop-to-floor think completed")
  attacker = rwtypes.createEntity(2, "player-proxy")
  barrel.health = -5
  rwcore.killEntity(world, barrel, void, attacker, 15, rwqtypes.zeroVec3())
  assertTrue(barrel.inUse, "barrel explosion delayed")
  assertEqual(barrel.takeDamage, rwconstants.DAMAGE_NO, "barrel delay disables damage")
  rwcore.advance(world, 0.4)
  assertTrue(barrel.inUse == false, "barrel explosion frees entity")
  assertEqual(retailWorldRadius, 150, "barrel radius damage")
  assertEqual(retailWorldEffects, 3, "barrel debris/explosion effects")
  return true
end function

function testDecorativeAndConsumedClasses()
  world = createWorld()
  banner = rwtypes.createEntity(1, "misc_banner")
  rwcore.addEntity(world, banner)
  rwmisc.spawnBanner(banner, world)
  firstFrame = banner.frame
  rwcore.advance(world, 0.1)
  assertEqual(banner.frame, (firstFrame + 1) % 16, "banner animation think")

  corpse = rwtypes.createEntity(2, "misc_deadsoldier")
  corpse.spawnFlags = 8
  rwcore.addEntity(world, corpse)
  rwmisc.spawnDeadSoldier(corpse, world)
  assertEqual(corpse.frame, 3, "dead soldier pose")
  corpse.health = -90
  rwcore.killEntity(world, corpse, void, void, 100, rwqtypes.zeroVec3())
  assertTrue(corpse.inUse == false, "dead soldier gib death")

  corner = rwtypes.createEntity(3, "path_corner")
  corner.targetName = "ship_route"
  corner.origin = rwqtypes.Vec3(64.0, 0.0, 0.0)
  rwcore.addEntity(world, corner)
  ship = rwtypes.createEntity(4, "misc_strogg_ship")
  ship.target = "ship_route"
  ship.targetName = "ship_trigger"
  rwcore.addEntity(world, ship)
  rwmisc.spawnStroggShip(ship, world)
  rwcore.advance(world, 0.2)
  assertTrue((ship.serverFlags & rwconstants.SVF_NOCLIENT) != 0, "ship initially hidden")
  rwcore.useEntity(world, ship, void, void)
  assertTrue((ship.serverFlags & rwconstants.SVF_NOCLIENT) == 0, "ship use reveals model")

  gib = rwtypes.createEntity(5, "misc_gib_head")
  rwcore.addEntity(world, gib)
  rwmisc.spawnGibHead(gib, world)
  assertEqual(gib.model, "models/objects/gibs/head/tris.md2", "gib head model")
  assertEqual(gib.nextThink, world.time + 30.0, "gib head lifetime")

  light = rwtypes.createEntity(6, "light")
  rwcore.addEntity(world, light)
  rwmisc.spawnLight(light, world)
  assertTrue(light.inUse == false, "untargeted light consumed")
  group = rwtypes.createEntity(7, "func_group")
  rwcore.addEntity(world, group)
  rwmisc.spawnNull(group, world)
  assertTrue(group.inUse == false, "func_group consumed")
  return true
end function

function testFuncObjectAndSpawnerGibs()
  global retailWorldDamage, retailWorldKillBoxes
  world = createWorld()
  object = rwtypes.createEntity(1, "func_object")
  object.model = "*1"
  object.mins = rwqtypes.Vec3(-16.0, -16.0, -16.0)
  object.maxs = rwqtypes.Vec3(16.0, 16.0, 16.0)
  rwcore.addEntity(world, object)
  rwmisc.spawnObject(object, world)
  assertEqual(object.damage, 100, "func_object default crush damage")
  assertEqual(object.solid, rwconstants.SOLID_BSP,
    "func_object begins solid")
  assertEqual(object.mins.x, -15.0, "func_object shrinks mins")
  assertEqual(object.maxs.x, 15.0, "func_object shrinks maxs")
  rwcore.advance(world, 0.2)
  assertEqual(object.moveType, rwconstants.MOVETYPE_TOSS,
    "func_object releases after two frames")
  victim = rwtypes.createEntity(2, "player")
  victim.takeDamage = rwconstants.DAMAGE_AIM
  damageBefore = retailWorldDamage
  object.moveDirection = rwqtypes.Vec3(0.0, 0.0, 1.0)
  rwmisc.funcObjectTouch(object, victim, world)
  assertEqual(retailWorldDamage, damageBefore + 100,
    "func_object crushes only from above")

  triggered = rwtypes.createEntity(3, "func_object")
  triggered.spawnFlags = 1
  triggered.mins = rwqtypes.Vec3(-8.0, -8.0, -8.0)
  triggered.maxs = rwqtypes.Vec3(8.0, 8.0, 8.0)
  rwcore.addEntity(world, triggered)
  rwmisc.spawnObject(triggered, world)
  assertEqual(triggered.solid, rwconstants.SOLID_NOT,
    "triggered func_object starts hidden")
  killBoxesBefore = retailWorldKillBoxes
  rwcore.useEntity(world, triggered, void, void)
  assertEqual(triggered.solid, rwconstants.SOLID_BSP,
    "triggered func_object becomes solid")
  assertEqual(triggered.moveType, rwconstants.MOVETYPE_TOSS,
    "triggered func_object releases immediately")
  assertEqual(retailWorldKillBoxes, killBoxesBefore + 1,
    "triggered func_object performs KillBox")

  arm = rwtypes.createEntity(4, "misc_gib_arm")
  leg = rwtypes.createEntity(5, "misc_gib_leg")
  rwmisc.spawnGibArm(arm, world)
  rwmisc.spawnGibLeg(leg, world)
  assertEqual(arm.model, "models/objects/gibs/arm/tris.md2",
    "spawner arm model")
  assertEqual(leg.model, "models/objects/gibs/leg/tris.md2",
    "spawner leg model")
  assertEqual(arm.moveType, rwconstants.MOVETYPE_TOSS,
    "spawner gib toss movement")
  return true
end function

print "MiniQuake2 retail world entity tests starting: 4"
testWallAndRotating()
testExploboxLifecycle()
testDecorativeAndConsumedClasses()
testFuncObjectAndSpawnerGibs()
print "MiniQuake2 retail world entity tests passed: 4"
