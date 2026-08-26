/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Deterministic Classic 3.19 turret base/breach/driver golden scenarios. */
import miniquake2.game.world.constants as turrettestconstants
import miniquake2.game.world.core as turrettestcore
import miniquake2.game.world.vector as turrettestvector
import miniquake2.game.world.turret as turrettestlogic
import miniquake2.game.world.turret_types as turrettesttypes
import miniquake2.game.ai.constants as turrettestaiconstants
import miniquake2.qcommon.constants as turrettestqconstants
import miniquake2.qcommon.types as turrettestqtypes

turretTestEnemy = void
turretTestVisible = true
turretTestRockets = []
turretTestDamageAmount = 0
turretTestDamageAttacker = 0
turretTestSpawnCount = 0
turretTestUseCount = 0
turretTestDieCount = 0
turretTestLinks = 0
turretTestModels = 0
turretTestPositionedSounds = []
turretTestCrushKnockback = 0
turretTestLiveSkill = 2.0

function turretTestAssert(condition, label)
  if condition == false then return error(9960, label) end if
end function

function turretTestAssertEqual(actual, expected, label)
  if actual != expected then return error(9961, label + ": expected " + expected + ", got " + actual) end if
end function

function turretTestAssertNear(actual, expected, tolerance, label)
  difference = actual - expected
  if difference < 0.0 then difference = -difference end if
  if difference > tolerance then return error(9962, label + ": expected " + expected + ", got " + actual) end if
end function

function turretTestAcquire(driver, world)
  global turretTestEnemy
  return turretTestEnemy
end function

function turretTestTraceVisible(driver, enemy, world)
  global turretTestVisible
  return turretTestVisible
end function

function turretTestRandom()
  return 0.5
end function

function turretTestSkillValue()
  global turretTestLiveSkill
  return turretTestLiveSkill
end function

function turretTestFire(attacker, start, direction, damage, speed, splashRadius, world)
  global turretTestRockets
  turretTestRockets = turretTestRockets + [[attacker.number, start, direction, damage, speed, splashRadius]]
  return true
end function

function turretTestPositionedSound(origin, entity, soundName, world)
  global turretTestPositionedSounds
  turretTestPositionedSounds = turretTestPositionedSounds + [
    [turrettestvector.copy(origin), entity.number, soundName]]
  return true
end function

function turretTestCrush(target, inflictor, attacker, amount, knockback, means, world)
  global turretTestCrushKnockback
  turretTestCrushKnockback = knockback
  return world.callbacks.damage(target, inflictor, attacker, amount, means)
end function

function turretTestDriverSpawn(driver, world)
  global turretTestSpawnCount
  turretTestSpawnCount = turretTestSpawnCount + 1
  return true
end function

function turretTestDriverUse(driver, other, activator, world)
  global turretTestUseCount
  turretTestUseCount = turretTestUseCount + 1
  return true
end function

function turretTestDriverDie(driver, inflictor, attacker, damage, point, world)
  global turretTestDieCount
  turretTestDieCount = turretTestDieCount + 1
  return true
end function

function turretTestDamage(target, inflictor, attacker, amount, means)
  global turretTestDamageAmount, turretTestDamageAttacker
  turretTestDamageAmount = amount
  turretTestDamageAttacker = attacker.number
  return true
end function

function turretTestSetModel(entity, modelName)
  global turretTestModels
  turretTestModels = turretTestModels + 1
  entity.modelIndex = entity.number + 200
  return true
end function

function turretTestLink(entity)
  global turretTestLinks
  turretTestLinks = turretTestLinks + 1
  return true
end function

function turretTestWorld()
  callbacks = turrettestcore.defaultCallbacks()
  callbacks.damage = turretTestDamage
  callbacks.setModel = turretTestSetModel
  callbacks.linkEntity = turretTestLink
  return turrettestcore.createWorld(callbacks)
end function

function turretTestControl(skill)
  callbacks = turrettesttypes.defaultTurretCallbacks()
  callbacks.acquireTarget = turretTestAcquire
  callbacks.traceVisible = turretTestTraceVisible
  callbacks.randomUnit = turretTestRandom
  callbacks.skillValue = turretTestSkillValue
  callbacks.fireRocket = turretTestFire
  callbacks.positionedSound = turretTestPositionedSound
  callbacks.crushDamage = turretTestCrush
  callbacks.driverSpawn = turretTestDriverSpawn
  callbacks.driverUse = turretTestDriverUse
  callbacks.driverDie = turretTestDriverDie
  return turrettesttypes.createTurretControl(callbacks, skill)
end function

function testAnglesAndTeamBinding()
  global turretTestRockets, turretTestPositionedSounds, turretTestLiveSkill
  turretTestRockets = []; turretTestPositionedSounds = []; turretTestLiveSkill = 2.0
  world = turretTestWorld()
  control = turretTestControl(2.0)
  baseEntity = turrettestcore.spawnEntity(world, "turret_base")
  baseEntity.team = "gun-a"; baseEntity.model = "*1"
  breach = turrettestcore.spawnEntity(world, "turret_breach")
  breach.team = "gun-a"; breach.model = "*2"
  breach.angles = turrettestqtypes.Vec3(0.0, 0.0, 0.0)
  turrettestlogic.spawnTurretBreach(breach, world, control,
    turrettesttypes.createTurretLimits(-20.0, 30.0, 10.0, 90.0))
  turrettestlogic.spawnTurretBase(baseEntity, world, control)
  turretTestAssertEqual(baseEntity.teamMaster, baseEntity, "turret base becomes team master")
  turretTestAssertEqual(baseEntity.teamChain, breach, "turret breach joins base chain")
  turretTestAssertEqual(breach.teamMaster, baseEntity, "breach records team master")
  turretTestAssert((breach.flags & turrettestconstants.FL_TEAMSLAVE) != 0, "breach is a team slave")

  breach.moveDirection = turrettestqtypes.Vec3(-100.0, 200.0, 0.0)
  turrettestlogic.turretBreachThink(breach, world)
  turretTestAssertNear(breach.moveDirection.x, -30.0, 0.0001, "breach minimum pitch clamp")
  turretTestAssertNear(breach.moveDirection.y, 90.0, 0.0001, "breach nearest yaw clamp")
  turretTestAssertNear(breach.angularVelocity.x, -50.0, 0.0001, "breach pitch speed clamp")
  turretTestAssertNear(breach.angularVelocity.y, 50.0, 0.0001, "breach yaw speed clamp")
  turretTestAssertNear(baseEntity.angularVelocity.y, 50.0, 0.0001, "base inherits breach yaw velocity")
  turretTestAssertNear(turrettestlogic.turretSnapToEighth(1.07), 1.125, 0.0001, "positive eighth snap")
  turretTestAssertNear(turrettestlogic.turretSnapToEighth(-1.07), -1.125, 0.0001, "negative eighth snap")
  turretTestLiveSkill = 3.0
  turrettestlogic.turretBreachFire(breach, world)
  turretTestAssertEqual(turretTestRockets[0][4], 700,
    "turret fire reads live skill rather than spawn-time skill")
  turretTestAssertEqual(len(turretTestPositionedSounds), 1,
    "turret emits one positioned launch sound")
  turretTestAssertEqual(turretTestPositionedSounds[0][2], "weapons/rocklf1a.wav",
    "turret launch sound asset")
  turretTestAssertNear(turretTestPositionedSounds[0][0].x,
    turretTestRockets[0][1].x, 0.0001, "launch sound shares muzzle x")
  turretTestLiveSkill = 2.0
end function

function createLinkedTurretWorld()
  global turretTestEnemy
  world = turretTestWorld()
  control = turretTestControl(2.0)
  muzzle = turrettestcore.spawnEntity(world, "info_notnull")
  muzzle.targetName = "muzzle-a"
  muzzle.origin = turrettestqtypes.Vec3(32.0, 0.0, 16.0)
  baseEntity = turrettestcore.spawnEntity(world, "turret_base")
  baseEntity.team = "gun-a"; baseEntity.model = "*1"
  turrettestlogic.spawnTurretBase(baseEntity, world, control)
  breach = turrettestcore.spawnEntity(world, "turret_breach")
  breach.team = "gun-a"; breach.targetName = "breach-a"; breach.target = "muzzle-a"; breach.model = "*2"
  breach.origin = turrettestqtypes.Vec3(0.0, 0.0, 16.0)
  turrettestlogic.spawnTurretBreach(breach, world, control, turrettesttypes.defaultTurretLimits())
  driver = turrettestcore.spawnEntity(world, "turret_driver")
  driver.target = "breach-a"
  driver.origin = turrettestqtypes.Vec3(0.0, -32.0, 0.0)
  turrettestlogic.spawnTurretDriver(driver, world, control, false)
  enemy = turrettestcore.spawnEntity(world, "player")
  enemy.isClient = true; enemy.health = 100; enemy.height = 24.0
  enemy.origin = turrettestqtypes.Vec3(100.0, 0.0, 16.0)
  turretTestEnemy = enemy
  return [world, control, baseEntity, breach, driver, enemy, muzzle]
end function

function testDriverAimFireAndDamage()
  global turretTestRockets, turretTestDamageAmount, turretTestDamageAttacker, turretTestVisible, turretTestPositionedSounds, turretTestCrushKnockback, turretTestLiveSkill
  turretTestRockets = []; turretTestDamageAmount = 0; turretTestDamageAttacker = 0
  turretTestVisible = true; turretTestPositionedSounds = []
  turretTestCrushKnockback = 0; turretTestLiveSkill = 2.0
  rig = createLinkedTurretWorld()
  world = rig[0]; baseEntity = rig[2]; breach = rig[3]; driver = rig[4]; muzzle = rig[6]
  turrettestcore.advance(world, 0.1)
  turretTestAssertEqual(muzzle.inUse, false, "breach consumes muzzle helper")
  turretTestAssertNear(breach.moveInfo.endOrigin.x, 32.0, 0.0001, "breach stores muzzle offset")
  turretTestAssertEqual(breach.owner, driver, "breach owns linked driver")
  turretTestAssertEqual(baseEntity.owner, driver, "base master owns linked driver")
  turretTestAssertEqual(driver.targetEntity, breach, "driver targets breach")
  turretTestAssert((driver.flags & turrettestconstants.FL_TEAMSLAVE) != 0, "driver appended as team slave")
  turretTestAssert(driver.gibHealth == 0 and
    driver.clipMask == turrettestqconstants.MASK_MONSTERSOLID and
    (driver.aiFlags & turrettestaiconstants.AI_STAND_GROUND) != 0 and
    (driver.aiFlags & turrettestaiconstants.AI_DUCKED) != 0,
    "driver stock gib/clip/stand-ground state")

  turrettestcore.advance(world, 0.4)
  turretTestAssert(breach.moveDirection.x < 0.0, "driver aims breach at enemy viewheight")
  turretTestAssertNear(driver.moveDirection.x, 32.0, 0.0001, "driver radial transform recorded")
  turretTestAssert(driver.velocity.x != 0.0 or driver.velocity.y != 0.0 or driver.velocity.z != 0.0,
    "breach drives driver translation")
  turrettestcore.advance(world, 1.4)
  turretTestAssertEqual(len(turretTestRockets), 1, "reaction cadence emits one rocket")
  rocket = turretTestRockets[0]
  turretTestAssertEqual(rocket[0], driver.number, "driver owns rocket damage")
  turretTestAssertEqual(rocket[3], 125, "rocket deterministic damage")
  turretTestAssertEqual(rocket[4], 650, "rocket skill-scaled speed")
  turretTestAssertEqual(rocket[5], 150, "rocket splash radius")
  muzzleDistance = turrettestvector.length(turrettestvector.subtract(rocket[1], breach.origin))
  turretTestAssertNear(muzzleDistance, 32.0, 0.001, "rocket starts at rotated muzzle offset")
  turretTestAssertEqual(len(turretTestPositionedSounds), 1,
    "one positioned sound follows one rocket")
  turretTestAssertNear(turretTestPositionedSounds[0][0].x, rocket[1].x,
    0.001, "positioned sound follows rotated muzzle")

  turretTestVisible = false
  turrettestcore.advance(world, 2.4)
  turretTestAssertEqual(len(turretTestRockets), 1, "lost sight suppresses fire")
  turretTestAssert((driver.aiFlags & turrettestaiconstants.AI_LOST_SIGHT) != 0,
    "lost sight state retained on serializable driver")
  turretTestVisible = true
  turrettestcore.advance(world, 3.6)
  turretTestAssertEqual(len(turretTestRockets), 2, "reacquisition restarts reaction cadence")

  victim = turrettestcore.spawnEntity(world, "victim")
  victim.takeDamage = turrettestconstants.DAMAGE_YES
  turrettestcore.blockedEntity(world, baseEntity, victim)
  turretTestAssertEqual(turretTestDamageAmount, 10, "blocked damage inherited from breach")
  turretTestAssertEqual(turretTestDamageAttacker, driver.number, "driver receives blocked damage credit")
  turretTestAssertEqual(turretTestCrushKnockback, 10,
    "blocked damage retains stock crush knockback")
end function

function testDriverLifecycleAndMalformed()
  global turretTestUseCount, turretTestDieCount, turretTestSpawnCount
  turretTestUseCount = 0; turretTestDieCount = 0; turretTestSpawnCount = 0
  rig = createLinkedTurretWorld()
  world = rig[0]; baseEntity = rig[2]; breach = rig[3]; driver = rig[4]
  turrettestcore.advance(world, 0.1)
  turretTestAssertEqual(turretTestSpawnCount, 1, "driver spawn lifecycle callback")
  turrettestcore.useEntity(world, driver, baseEntity, rig[5])
  turretTestAssertEqual(turretTestUseCount, 1, "driver use lifecycle callback")
  breach.moveDirection.x = -15.0
  turrettestcore.killEntity(world, driver, breach, breach, 120, turrettestqtypes.zeroVec3())
  turretTestAssertEqual(turretTestDieCount, 1, "driver death handoff callback")
  turretTestAssertNear(breach.moveDirection.x, 0.0, 0.0001, "driver death levels gun")
  turretTestAssert(breach.owner is void and baseEntity.owner is void, "driver death clears turret owners")
  turretTestAssert(driver.teamMaster is void and (driver.flags & turrettestconstants.FL_TEAMSLAVE) == 0,
    "driver death detaches team state")
  turretTestAssertEqual(baseEntity.teamChain, breach, "driver removed from end of team chain")
  turretTestAssert(breach.teamChain is void, "breach chain terminates after driver death")

  malformedWorld = turretTestWorld()
  control = turretTestControl(1.0)
  badBase = turrettestcore.spawnEntity(malformedWorld, "turret_base")
  turretTestAssertEqual(turrettestlogic.spawnTurretBase(badBase, malformedWorld, control), false,
    "turret_base missing model rejected")
  badBreach = turrettestcore.spawnEntity(malformedWorld, "turret_breach")
  turretTestAssertEqual(turrettestlogic.spawnTurretBreach(badBreach, malformedWorld, control, void), false,
    "turret_breach missing model rejected")
  orphan = turrettestcore.spawnEntity(malformedWorld, "turret_driver")
  orphan.target = "missing-breach"
  turrettestlogic.spawnTurretDriver(orphan, malformedWorld, control, false)
  turrettestcore.advance(malformedWorld, malformedWorld.frameTime)
  turretTestAssert(orphan.targetEntity is void and orphan.nextThink == 0.0, "orphan driver remains safely unlinked")
  deathmatchDriver = turrettestcore.spawnEntity(malformedWorld, "turret_driver")
  turretTestAssertEqual(turrettestlogic.spawnTurretDriver(deathmatchDriver, malformedWorld, control, true), false,
    "deathmatch driver removed")
end function

function main(args)
  testAnglesAndTeamBinding()
  testDriverAimFireAndDamage()
  testDriverLifecycleAndMalformed()
  print "gameplay_world_turret_tests: PASS"
  return 0
end function
