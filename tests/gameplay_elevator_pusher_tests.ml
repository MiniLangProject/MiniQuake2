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

// Store elevator runtime data.
struct ElevatorRuntime
  world
  playerContext
  monsters
  pusherCapture
  exportTable
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
  return elevatortestqtypes.Trace(false, startSolid, 1.0, finish,
    elevatortestqtypes.Plane(elevatortestqtypes.zeroVec3(), 0.0, 0, 0),
    elevatortestqtypes.CollisionSurface("", 0, 0), 0, void)
end function

// Ignore elevator edict link.
function ignoreElevatorEdictLink(entity)
  return true
end function

world = elevatortestworld.createWorld(void)
world.callbacks.linkEntity = recordElevatorLink
runtime = ElevatorRuntime(world, void, [], void, void)
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
  ElevatorExport(fallbackEdicts))
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
yawRuntime = ElevatorRuntime(yawWorld, yawContext, [], void, ElevatorExport(yawEdicts))
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
stopRuntime = ElevatorRuntime(stopWorld, void, [], void, void)
stopCapture = elevatortestpusher.capture(stopRuntime)
elevatortestworld.runFrame(stopWorld)
elevatorAssert(elevatortestpusher.resolve(stopRuntime, stopCapture) == 1 and
  stopElevator.origin.z == 1.0 and stopRider.origin.z == 2.0,
  "MOVETYPE_STOP did not carry its explicit groundentity rider")

print "gameplay_elevator_pusher_tests: PASS"
