/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Focused g_phys.c elevator relink and 1/8-unit movement regression. */
import miniquake2.game.integration.pusher as elevatortestpusher
import miniquake2.game.world.core as elevatortestworld
import miniquake2.game.world.types as elevatortesttypes
import miniquake2.game.world.constants as elevatortestconstants
import miniquake2.game.types as elevatortestgametypes
import miniquake2.qcommon.constants as elevatortestqconstants
import miniquake2.qcommon.types as elevatortestqtypes
import miniquake2.game.weapons.types as elevatortestweapontypes
import miniquake2.game.weapons.constants as elevatortestweaponconstants

// Store elevator runtime data.
struct ElevatorRuntime
  world
  playerContext
  monsters
  pusherCapture
  exportTable
  weaponContext
end struct

// Store elevator imports data.
struct ElevatorImports
  trace
  linkEntity
end struct

// Store elevator player context data.
struct ElevatorPlayerContext
  imports
  players
end struct

// Store elevator export data.
struct ElevatorExport
  edicts
  numEdicts
end struct

// Store the narrow weapon callback surface used by projectile pusher tests.
struct ElevatorWeaponCallbacks
  linkEntity
end struct

// Store projectile records visible to the pusher transaction.
struct ElevatorWeaponContext
  projectiles
  callbacks
end struct

// Store elevator player data.
struct ElevatorPlayer
  edict
  groundEntity
  health
end struct

elevatorLinkCount = 0
elevatorLinkedOrigin = elevatortestqtypes.zeroVec3()
elevatorTraceMode = 0
elevatorTraceCount = 0
elevatorTraceStationary = true
elevatorTracePassNumber = -1
elevatorTraceMask = 0
elevatorThinkCount = 0
elevatorThinkOrigin = 0.0

// Assert the elevator test condition.
function elevatorAssert(value, message)
  if value != true then return error(9887, message) end if
  return true
end function

// Record elevator link.
function recordElevatorLink(entity)
  global elevatorLinkCount, elevatorLinkedOrigin
  elevatorLinkCount = elevatorLinkCount + 1
  elevatorLinkedOrigin.x = entity.origin.x
  elevatorLinkedOrigin.y = entity.origin.y
  elevatorLinkedOrigin.z = entity.origin.z
  return true
end function

// Trace elevator.
function elevatorTrace(start, mins, maxs, finish, passEntity, mask)
  global elevatorTraceMode, elevatorTraceCount, elevatorTraceStationary
  global elevatorTracePassNumber, elevatorTraceMask
  if start.x != finish.x or start.y != finish.y or start.z != finish.z then
    elevatorTraceStationary = false
  end if
  elevatorTraceCount = elevatorTraceCount + 1
  elevatorTraceMask = mask
  if passEntity is not void then elevatorTracePassNumber = passEntity.state.number end if
  startSolid = false
  // Mode 1 models a downward elevator whose carried destination is obstructed
  // while the translation-only fallback remains clear.
  if elevatorTraceMode == 1 and elevatorTraceCount == 1 then startSolid = true end if
  if elevatorTraceMode == 2 then startSolid = true end if
  if elevatorTraceMode == 3 and elevatorTraceCount == 1 then startSolid = true end if
  return elevatortestqtypes.Trace(false, startSolid, 1.0, finish,
    elevatortestqtypes.Plane(elevatortestqtypes.zeroVec3(), 0.0, 0, 0),
    elevatortestqtypes.CollisionSurface("", 0, 0), 0, void)
end function

// Ignore elevator edict link.
function ignoreElevatorEdictLink(entity)
  return true
end function

// Record the stock post-move pusher think position.
function recordElevatorThink(entity, world)
  global elevatorThinkCount, elevatorThinkOrigin
  elevatorThinkCount = elevatorThinkCount + 1
  elevatorThinkOrigin = entity.origin.x
  return true
end function

// Return an empty projectile context.
function emptyWeaponContext()
  return ElevatorWeaponContext([], ElevatorWeaponCallbacks(
    ignoreElevatorEdictLink))
end function

world = elevatortestworld.createWorld(void)
world.callbacks.linkEntity = recordElevatorLink
runtime = ElevatorRuntime(world, void, [], void, void, emptyWeaponContext())
elevator = elevatortesttypes.createEntity(10, "func_train")
elevator.solid = elevatortestconstants.SOLID_BSP
elevator.moveType = elevatortestconstants.MOVETYPE_PUSH
elevator.mins = elevatortestqtypes.Vec3(-32.0, -32.0, -8.0)
elevator.maxs = elevatortestqtypes.Vec3(32.0, 32.0, 8.0)
elevator.velocity = elevatortestqtypes.Vec3(0.0, 0.0, 100.3)
elevatortestworld.addEntity(world, elevator)

capture = elevatortestpusher.capture(runtime)
elevatortestworld.runFrame(world)
elevatorAssert(elevator.origin.z > 10.0,
  "fixture did not advance the elevator before pusher resolution")
elevatorAssert(elevatortestpusher.resolve(runtime, capture) == 1,
  "moving elevator team was not resolved")

// g_phys.c rounds 10.03 to 10.0 and links the final transform before any rider
// is tested. Both properties are required by Protocol-34 player prediction.
elevatorAssert(elevator.origin.z == 10.0,
  "SV_Push 1/8-unit translation clamp changed")
elevatorAssert(elevatorLinkCount == 1 and elevatorLinkedOrigin.z == 10.0,
  "successful elevator move did not publish its final linked transform")

// SV_TestEntityPosition checks only the candidate position, passes the moved
// body itself, and honors its clipmask. A blocked carried pose may leave a
// rider at the translation-only fallback without rolling the train back.
fallbackWorld = elevatortestworld.createWorld(void)
fallbackWorld.callbacks.linkEntity = recordElevatorLink
fallbackTrain = elevatortesttypes.createEntity(20, "func_train")
fallbackTrain.solid = elevatortestconstants.SOLID_BSP
fallbackTrain.moveType = elevatortestconstants.MOVETYPE_PUSH
fallbackTrain.mins = elevatortestqtypes.Vec3(-8.0, -8.0, -1.0)
fallbackTrain.maxs = elevatortestqtypes.Vec3(8.0, 8.0, 1.0)
fallbackTrain.velocity = elevatortestqtypes.Vec3(0.0, 0.0, -10.0)
fallbackBody = elevatortesttypes.createEntity(21, "rider")
fallbackBody.solid = elevatortestconstants.SOLID_BBOX
fallbackBody.moveType = elevatortestconstants.MOVETYPE_TOSS
fallbackBody.mins = elevatortestqtypes.Vec3(-1.0, -1.0, 0.0)
fallbackBody.maxs = elevatortestqtypes.Vec3(1.0, 1.0, 2.0)
fallbackBody.origin = elevatortestqtypes.Vec3(0.0, 0.0, 1.0)
fallbackBody.groundEntity = fallbackTrain
fallbackBody.clipMask = elevatortestqconstants.MASK_SOLID
elevatortestworld.addEntity(fallbackWorld, fallbackTrain)
elevatortestworld.addEntity(fallbackWorld, fallbackBody)
fallbackEdicts = array(22, void)
fallbackEdicts[20] = elevatortestgametypes.zeroEdict(20)
fallbackEdicts[21] = elevatortestgametypes.zeroEdict(21)
fallbackImports = ElevatorImports(elevatorTrace, ignoreElevatorEdictLink)
fallbackContext = ElevatorPlayerContext(fallbackImports, [])
fallbackRuntime = ElevatorRuntime(fallbackWorld, fallbackContext, [], void,
  ElevatorExport(fallbackEdicts, 22), emptyWeaponContext())
elevatorTraceMode = 1; elevatorTraceCount = 0
elevatorTraceStationary = true; elevatorTracePassNumber = -1
fallbackCapture = elevatortestpusher.capture(fallbackRuntime)
elevatortestworld.runFrame(fallbackWorld)
elevatorAssert(elevatortestpusher.resolve(fallbackRuntime, fallbackCapture) == 1,
  "clear translation fallback rolled the elevator back")
elevatorAssert(fallbackTrain.origin.z == -1.0 and fallbackBody.origin.z == 1.0,
  "downward elevator fallback did not leave the rider at its old height")
elevatorAssert(elevatorTraceCount == 2 and elevatorTraceStationary and
  elevatorTracePassNumber == 21 and elevatorTraceMask == elevatortestqconstants.MASK_SOLID,
  "SV_TestEntityPosition pass-entity/mask/stationary trace contract changed")

// Rotating pushers change a client's command yaw, not the entity angles.
yawWorld = elevatortestworld.createWorld(void)
yawWorld.callbacks.linkEntity = recordElevatorLink
yawTrain = elevatortesttypes.createEntity(30, "func_train")
yawTrain.solid = elevatortestconstants.SOLID_BSP
yawTrain.moveType = elevatortestconstants.MOVETYPE_PUSH
yawTrain.mins = elevatortestqtypes.Vec3(-8.0, -8.0, -1.0)
yawTrain.maxs = elevatortestqtypes.Vec3(8.0, 8.0, 1.0)
yawTrain.angularVelocity = elevatortestqtypes.Vec3(0.0, 900.0, 0.0)
yawEdict = elevatortestgametypes.zeroEdict(31)
yawEdict.inUse = true; yawEdict.solid = elevatortestconstants.SOLID_BBOX
yawEdict.client = elevatortestgametypes.zeroGameClient()
yawEdict.state.origin = elevatortestqtypes.Vec3(5.0, 0.0, 1.0)
yawEdict.mins = elevatortestqtypes.Vec3(-0.5, -0.5, 0.0)
yawEdict.maxs = elevatortestqtypes.Vec3(0.5, 0.5, 1.0)
yawEdict.clipMask = elevatortestqconstants.MASK_PLAYERSOLID
yawGroundEdict = elevatortestgametypes.zeroEdict(30)
yawPlayer = ElevatorPlayer(yawEdict, yawGroundEdict, 100)
elevatortestworld.addEntity(yawWorld, yawTrain)
yawEdicts = array(32, void); yawEdicts[30] = elevatortestgametypes.zeroEdict(30)
yawEdicts[31] = yawEdict
yawContext = ElevatorPlayerContext(fallbackImports, [yawPlayer])
yawRuntime = ElevatorRuntime(yawWorld, yawContext, [], void,
  ElevatorExport(yawEdicts, 32), emptyWeaponContext())
elevatorTraceMode = 0; elevatorTraceCount = 0
yawCapture = elevatortestpusher.capture(yawRuntime)
elevatortestworld.runFrame(yawWorld)
elevatorAssert(elevatortestpusher.resolve(yawRuntime, yawCapture) == 1,
  "rotating elevator rider did not resolve")
elevatorAssert(yawEdict.client.playerState.pmove.deltaAngles[1] == 90 and
  yawEdict.state.angles.y == 0.0,
  "rotating pusher did not apply stock client delta-yaw semantics")

// MOVETYPE_STOP still carries an entity whose groundentity is the pusher; it
// differs from MOVETYPE_PUSH only for contacted non-riders.
stopWorld = elevatortestworld.createWorld(void)
stopWorld.callbacks.linkEntity = recordElevatorLink
stopElevator = elevatortesttypes.createEntity(40, "func_train")
stopElevator.solid = elevatortestconstants.SOLID_BSP
stopElevator.moveType = elevatortestconstants.MOVETYPE_STOP
stopElevator.mins = elevatortestqtypes.Vec3(-8.0, -8.0, -1.0)
stopElevator.maxs = elevatortestqtypes.Vec3(8.0, 8.0, 1.0)
stopElevator.velocity = elevatortestqtypes.Vec3(0.0, 0.0, 10.0)
stopRider = elevatortesttypes.createEntity(41, "stop-rider")
stopRider.solid = elevatortestconstants.SOLID_BBOX
stopRider.moveType = elevatortestconstants.MOVETYPE_TOSS
stopRider.mins = elevatortestqtypes.Vec3(-1.0, -1.0, 0.0)
stopRider.maxs = elevatortestqtypes.Vec3(1.0, 1.0, 2.0)
stopRider.origin = elevatortestqtypes.Vec3(0.0, 0.0, 1.0)
stopRider.groundEntity = stopElevator
elevatortestworld.addEntity(stopWorld, stopElevator)
elevatortestworld.addEntity(stopWorld, stopRider)
stopRuntime = ElevatorRuntime(stopWorld, void, [], void, void,
  emptyWeaponContext())
stopCapture = elevatortestpusher.capture(stopRuntime)
elevatortestworld.runFrame(stopWorld)
elevatorAssert(elevatortestpusher.resolve(stopRuntime, stopCapture) == 1 and
  stopElevator.origin.z == 1.0 and stopRider.origin.z == 2.0,
  "MOVETYPE_STOP did not carry its explicit groundentity rider")

// A stationary missile contacted by a PUSH brush participates in the same
// pushed[] transaction before its own missile physics runs.
missileWorld = elevatortestworld.createWorld(void)
missileWorld.callbacks.linkEntity = recordElevatorLink
missileTrain = elevatortesttypes.createEntity(50, "func_train")
missileTrain.solid = elevatortestconstants.SOLID_BSP
missileTrain.moveType = elevatortestconstants.MOVETYPE_PUSH
missileTrain.mins = elevatortestqtypes.Vec3(-8.0, -8.0, -8.0)
missileTrain.maxs = elevatortestqtypes.Vec3(8.0, 8.0, 8.0)
missileTrain.velocity = elevatortestqtypes.Vec3(10.0, 0.0, 0.0)
missile = elevatortestweapontypes.createProjectile(1, "rocket")
missile.engineNumber = 51
missile.moveType = elevatortestweaponconstants.MOVETYPE_FLYMISSILE
missile.solid = elevatortestweaponconstants.SOLID_BBOX
missile.origin = elevatortestqtypes.Vec3(7.5, 0.0, 0.0)
missile.mins = elevatortestqtypes.Vec3(-0.5, -0.5, -0.5)
missile.maxs = elevatortestqtypes.Vec3(0.5, 0.5, 0.5)
elevatortestworld.addEntity(missileWorld, missileTrain)
missileEdicts = array(52, void)
missileEdicts[50] = elevatortestgametypes.zeroEdict(50)
missileEdicts[51] = elevatortestgametypes.zeroEdict(51)
missileRuntime = ElevatorRuntime(missileWorld, fallbackContext, [], void,
  ElevatorExport(missileEdicts, 52), ElevatorWeaponContext([missile],
    ElevatorWeaponCallbacks(ignoreElevatorEdictLink)))
elevatorTraceMode = 3; elevatorTraceCount = 0
missileCapture = elevatortestpusher.capture(missileRuntime)
elevatortestworld.runFrame(missileWorld)
elevatorAssert(elevatortestpusher.resolve(missileRuntime, missileCapture) == 1 and
  missile.origin.x == 8.5,
  "MOVETYPE_FLYMISSILE did not join the pusher transaction")

// Due mover thinks run after a successful push, at the final transform.
thinkWorld = elevatortestworld.createWorld(void)
thinkWorld.callbacks.linkEntity = recordElevatorLink
thinkTrain = elevatortesttypes.createEntity(60, "func_train")
thinkTrain.moveType = elevatortestconstants.MOVETYPE_PUSH
thinkTrain.solid = elevatortestconstants.SOLID_BSP
thinkTrain.mins = elevatortestqtypes.Vec3(-8.0, -8.0, -8.0)
thinkTrain.maxs = elevatortestqtypes.Vec3(8.0, 8.0, 8.0)
thinkTrain.velocity = elevatortestqtypes.Vec3(10.0, 0.0, 0.0)
thinkTrain.think = recordElevatorThink
thinkTrain.nextThink = 0.1
elevatortestworld.addEntity(thinkWorld, thinkTrain)
thinkRuntime = ElevatorRuntime(thinkWorld, void, [], void, void,
  emptyWeaponContext())
elevatorThinkCount = 0; elevatorThinkOrigin = 0.0
thinkCapture = elevatortestpusher.capture(thinkRuntime)
elevatortestpusher.deferDueThinks(thinkCapture, 0.1)
elevatortestworld.runFrame(thinkWorld)
elevatortestpusher.resolve(thinkRuntime, thinkCapture)
elevatorAssert(elevatorThinkCount == 1 and elevatorThinkOrigin == 1.0,
  "due pusher think did not run after successful movement")

// A blocked transaction rolls the team back, delays every scheduled think by
// one server frame, and does not execute the due callback on the blocked frame.
blockedWorld = elevatortestworld.createWorld(void)
blockedWorld.callbacks.linkEntity = recordElevatorLink
blockedTrain = elevatortesttypes.createEntity(70, "func_train")
blockedTrain.moveType = elevatortestconstants.MOVETYPE_PUSH
blockedTrain.solid = elevatortestconstants.SOLID_BSP
blockedTrain.mins = elevatortestqtypes.Vec3(-8.0, -8.0, -1.0)
blockedTrain.maxs = elevatortestqtypes.Vec3(8.0, 8.0, 1.0)
blockedTrain.velocity = elevatortestqtypes.Vec3(10.0, 0.0, 0.0)
blockedTrain.think = recordElevatorThink
blockedTrain.nextThink = 0.1
blockedRider = elevatortesttypes.createEntity(71, "blocked-rider")
blockedRider.solid = elevatortestconstants.SOLID_BBOX
blockedRider.moveType = elevatortestconstants.MOVETYPE_TOSS
blockedRider.mins = elevatortestqtypes.Vec3(-1.0, -1.0, 0.0)
blockedRider.maxs = elevatortestqtypes.Vec3(1.0, 1.0, 2.0)
blockedRider.origin = elevatortestqtypes.Vec3(0.0, 0.0, 1.0)
blockedRider.groundEntity = blockedTrain
elevatortestworld.addEntity(blockedWorld, blockedTrain)
elevatortestworld.addEntity(blockedWorld, blockedRider)
blockedEdicts = array(72, void)
blockedEdicts[70] = elevatortestgametypes.zeroEdict(70)
blockedEdicts[71] = elevatortestgametypes.zeroEdict(71)
blockedRuntime = ElevatorRuntime(blockedWorld, fallbackContext, [], void,
  ElevatorExport(blockedEdicts, 72), emptyWeaponContext())
elevatorTraceMode = 2; elevatorTraceCount = 0; elevatorThinkCount = 0
blockedCapture = elevatortestpusher.capture(blockedRuntime)
elevatortestpusher.deferDueThinks(blockedCapture, 0.1)
elevatortestworld.runFrame(blockedWorld)
elevatorAssert(elevatortestpusher.resolve(blockedRuntime, blockedCapture) == 0 and
  blockedTrain.origin.x == 0.0 and elevatorThinkCount == 0 and
  blockedTrain.nextThink == 0.2,
  "blocked pusher did not roll back and delay its due think")

print "gameplay_elevator_pusher_tests: PASS"
