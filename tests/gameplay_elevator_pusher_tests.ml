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
  touchTriggers
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
  groundLinkCount
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
elevatorTriggerTouchCount = 0
elevatorTeamSecondNumber = -1
elevatorTeamFirstRiderNumber = -1
elevatorTeamSecondLinked = false
elevatorTeamFirstTraceSawSecond = false

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
  global elevatorTeamFirstRiderNumber, elevatorTeamSecondLinked
  global elevatorTeamFirstTraceSawSecond
  if start.x != finish.x or start.y != finish.y or start.z != finish.z then
    elevatorTraceStationary = false
  end if
  elevatorTraceCount = elevatorTraceCount + 1
  elevatorTraceMask = mask
  if passEntity is not void then
    elevatorTracePassNumber = passEntity.state.number
    if elevatorTracePassNumber == elevatorTeamFirstRiderNumber then
      elevatorTeamFirstTraceSawSecond = elevatorTeamSecondLinked
    end if
  end if
  startSolid = false
  // Mode 1 models a downward elevator whose carried destination is obstructed
  // while the translation-only fallback remains clear.
  if elevatorTraceMode == 1 and elevatorTraceCount == 1 then startSolid = true end if
  if elevatorTraceMode == 2 then startSolid = true end if
  if elevatorTraceMode == 3 and elevatorTraceCount == 1 then startSolid = true end if
  // Mode 4 blocks only the second team part's contacted body so the test can
  // prove that the first part and its rider join the same rollback transaction.
  if elevatorTraceMode == 4 and elevatorTracePassNumber == 93 then startSolid = true end if
  return elevatortestqtypes.Trace(false, startSolid, 1.0, finish,
    elevatortestqtypes.Plane(elevatortestqtypes.zeroVec3(), 0.0, 0, 0),
    elevatortestqtypes.CollisionSurface("", 0, 0), 0, void)
end function

// Ignore elevator edict link.
function ignoreElevatorEdictLink(entity)
  return true
end function

// Record when the second pusher part is published to the world collision tree.
function recordElevatorTeamLink(entity)
  global elevatorTeamSecondNumber, elevatorTeamSecondLinked
  if entity.number == elevatorTeamSecondNumber then
    elevatorTeamSecondLinked = true
  end if
  return true
end function

// Record each stock SV_Push trigger pass for a carried player.
function recordElevatorTriggerTouch(player)
  global elevatorTriggerTouchCount
  elevatorTriggerTouchCount = elevatorTriggerTouchCount + 1
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
fallbackContext = ElevatorPlayerContext(fallbackImports, [], void)
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
yawPlayer = ElevatorPlayer(yawEdict, yawGroundEdict, 0, 100)
elevatortestworld.addEntity(yawWorld, yawTrain)
yawEdicts = array(32, void); yawEdicts[30] = elevatortestgametypes.zeroEdict(30)
yawEdicts[31] = yawEdict
yawContext = ElevatorPlayerContext(fallbackImports, [yawPlayer],
  recordElevatorTriggerTouch)
yawRuntime = ElevatorRuntime(yawWorld, yawContext, [], void,
  ElevatorExport(yawEdicts, 32), emptyWeaponContext())
elevatorTraceMode = 0; elevatorTraceCount = 0
elevatorTriggerTouchCount = 0
yawCapture = elevatortestpusher.capture(yawRuntime)
elevatortestworld.runFrame(yawWorld)
elevatorAssert(elevatortestpusher.resolve(yawRuntime, yawCapture) == 1,
  "rotating elevator rider did not resolve")
elevatorAssert(yawEdict.client.playerState.pmove.deltaAngles[1] == 90 and
  yawEdict.state.angles.y == 0.0,
  "rotating pusher did not apply stock client delta-yaw semantics")
elevatorAssert(elevatorTriggerTouchCount == 1,
  "committed elevator rider did not touch triggers exactly once")

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
blockedPlayerEdict = elevatortestgametypes.zeroEdict(71)
blockedPlayerEdict.inUse = true
blockedPlayerEdict.solid = elevatortestconstants.SOLID_BBOX
blockedPlayerEdict.client = elevatortestgametypes.zeroGameClient()
blockedPlayerEdict.state.origin = elevatortestqtypes.Vec3(0.0, 0.0, 1.0)
blockedPlayerEdict.mins = elevatortestqtypes.Vec3(-1.0, -1.0, 0.0)
blockedPlayerEdict.maxs = elevatortestqtypes.Vec3(1.0, 1.0, 2.0)
blockedPlayerEdict.clipMask = elevatortestqconstants.MASK_PLAYERSOLID
blockedGroundEdict = elevatortestgametypes.zeroEdict(70)
blockedPlayer = ElevatorPlayer(blockedPlayerEdict, blockedGroundEdict, 0, 100)
elevatortestworld.addEntity(blockedWorld, blockedTrain)
blockedEdicts = array(72, void)
blockedEdicts[70] = elevatortestgametypes.zeroEdict(70)
blockedEdicts[71] = blockedPlayerEdict
blockedContext = ElevatorPlayerContext(fallbackImports, [blockedPlayer],
  recordElevatorTriggerTouch)
blockedRuntime = ElevatorRuntime(blockedWorld, blockedContext, [], void,
  ElevatorExport(blockedEdicts, 72), emptyWeaponContext())
elevatorTraceMode = 2; elevatorTraceCount = 0; elevatorThinkCount = 0
elevatorTriggerTouchCount = 0
blockedCapture = elevatortestpusher.capture(blockedRuntime)
elevatortestpusher.deferDueThinks(blockedCapture, 0.1)
elevatortestworld.runFrame(blockedWorld)
elevatorAssert(elevatortestpusher.resolve(blockedRuntime, blockedCapture) == 0 and
  blockedTrain.origin.x == 0.0 and elevatorThinkCount == 0 and
  blockedTrain.nextThink == 0.2 and blockedPlayerEdict.state.origin.x == 0.0 and
  elevatorTriggerTouchCount == 0,
  "blocked pusher did not roll back and delay its due think")

// SV_Physics_Pusher publishes and resolves one team-chain member at a time.
// The first rider trace must therefore run before the second brush is linked.
teamWorld = elevatortestworld.createWorld(void)
teamWorld.callbacks.linkEntity = recordElevatorTeamLink
teamFirst = elevatortesttypes.createEntity(80, "func_door")
teamFirst.moveType = elevatortestconstants.MOVETYPE_PUSH
teamFirst.solid = elevatortestconstants.SOLID_BSP
teamFirst.mins = elevatortestqtypes.Vec3(-2.0, -2.0, -1.0)
teamFirst.maxs = elevatortestqtypes.Vec3(2.0, 2.0, 1.0)
teamFirst.velocity = elevatortestqtypes.Vec3(10.0, 0.0, 0.0)
teamSecond = elevatortesttypes.createEntity(81, "func_door")
teamSecond.moveType = elevatortestconstants.MOVETYPE_PUSH
teamSecond.solid = elevatortestconstants.SOLID_BSP
teamSecond.origin = elevatortestqtypes.Vec3(100.0, 0.0, 0.0)
teamSecond.mins = elevatortestqtypes.Vec3(-2.0, -2.0, -1.0)
teamSecond.maxs = elevatortestqtypes.Vec3(2.0, 2.0, 1.0)
teamSecond.velocity = elevatortestqtypes.Vec3(10.0, 0.0, 0.0)
teamFirst.teamMaster = teamFirst; teamFirst.teamChain = teamSecond
teamSecond.teamMaster = teamFirst
teamRiderEdict = elevatortestgametypes.zeroEdict(82)
teamRiderEdict.inUse = true
teamRiderEdict.solid = elevatortestconstants.SOLID_BBOX
teamRiderEdict.client = elevatortestgametypes.zeroGameClient()
teamRiderEdict.state.origin = elevatortestqtypes.Vec3(0.0, 0.0, 1.0)
teamRiderEdict.mins = elevatortestqtypes.Vec3(-0.5, -0.5, 0.0)
teamRiderEdict.maxs = elevatortestqtypes.Vec3(0.5, 0.5, 1.0)
teamRiderEdict.clipMask = elevatortestqconstants.MASK_PLAYERSOLID
teamGroundEdict = elevatortestgametypes.zeroEdict(80)
teamRider = ElevatorPlayer(teamRiderEdict, teamGroundEdict, 0, 100)
elevatortestworld.addEntity(teamWorld, teamFirst)
elevatortestworld.addEntity(teamWorld, teamSecond)
teamEdicts = array(83, void)
teamEdicts[80] = teamGroundEdict
teamEdicts[81] = elevatortestgametypes.zeroEdict(81)
teamEdicts[82] = teamRiderEdict
teamContext = ElevatorPlayerContext(fallbackImports, [teamRider], void)
teamRuntime = ElevatorRuntime(teamWorld, teamContext, [], void,
  ElevatorExport(teamEdicts, 83), emptyWeaponContext())
elevatorTraceMode = 0; elevatorTraceCount = 0
elevatorTeamSecondNumber = 81; elevatorTeamFirstRiderNumber = 82
elevatorTeamSecondLinked = false; elevatorTeamFirstTraceSawSecond = false
teamCapture = elevatortestpusher.capture(teamRuntime)
elevatortestworld.runFrame(teamWorld)
elevatorAssert(elevatortestpusher.resolve(teamRuntime, teamCapture) == 1 and
  teamFirst.origin.x == 1.0 and teamSecond.origin.x == 101.0 and
  teamRiderEdict.state.origin.x == 1.0 and
  not elevatorTeamFirstTraceSawSecond,
  "pusher team parts were not linked and resolved sequentially")

// A blocker encountered by a later team part rolls back every already-linked
// part and every rider carried by an earlier part.
rollbackWorld = elevatortestworld.createWorld(void)
rollbackWorld.callbacks.linkEntity = recordElevatorTeamLink
rollbackFirst = elevatortesttypes.createEntity(90, "func_door")
rollbackFirst.moveType = elevatortestconstants.MOVETYPE_PUSH
rollbackFirst.solid = elevatortestconstants.SOLID_BSP
rollbackFirst.mins = elevatortestqtypes.Vec3(-2.0, -2.0, -1.0)
rollbackFirst.maxs = elevatortestqtypes.Vec3(2.0, 2.0, 1.0)
rollbackFirst.velocity = elevatortestqtypes.Vec3(10.0, 0.0, 0.0)
rollbackSecond = elevatortesttypes.createEntity(91, "func_door")
rollbackSecond.moveType = elevatortestconstants.MOVETYPE_PUSH
rollbackSecond.solid = elevatortestconstants.SOLID_BSP
rollbackSecond.origin = elevatortestqtypes.Vec3(20.0, 0.0, 0.0)
rollbackSecond.mins = elevatortestqtypes.Vec3(-2.0, -2.0, -1.0)
rollbackSecond.maxs = elevatortestqtypes.Vec3(2.0, 2.0, 1.0)
rollbackSecond.velocity = elevatortestqtypes.Vec3(10.0, 0.0, 0.0)
rollbackFirst.teamMaster = rollbackFirst; rollbackFirst.teamChain = rollbackSecond
rollbackSecond.teamMaster = rollbackFirst
rollbackRiderEdict = elevatortestgametypes.zeroEdict(92)
rollbackRiderEdict.inUse = true
rollbackRiderEdict.solid = elevatortestconstants.SOLID_BBOX
rollbackRiderEdict.client = elevatortestgametypes.zeroGameClient()
rollbackRiderEdict.state.origin = elevatortestqtypes.Vec3(0.0, 0.0, 1.0)
rollbackRiderEdict.mins = elevatortestqtypes.Vec3(-0.5, -0.5, 0.0)
rollbackRiderEdict.maxs = elevatortestqtypes.Vec3(0.5, 0.5, 1.0)
rollbackRiderEdict.clipMask = elevatortestqconstants.MASK_PLAYERSOLID
rollbackGroundEdict = elevatortestgametypes.zeroEdict(90)
rollbackRider = ElevatorPlayer(rollbackRiderEdict, rollbackGroundEdict, 0, 100)
rollbackBlockerEdict = elevatortestgametypes.zeroEdict(93)
rollbackBlockerEdict.inUse = true
rollbackBlockerEdict.solid = elevatortestconstants.SOLID_BBOX
rollbackBlockerEdict.client = elevatortestgametypes.zeroGameClient()
rollbackBlockerEdict.state.origin = elevatortestqtypes.Vec3(21.0, 0.0, 0.0)
rollbackBlockerEdict.mins = elevatortestqtypes.Vec3(-0.5, -0.5, -0.5)
rollbackBlockerEdict.maxs = elevatortestqtypes.Vec3(0.5, 0.5, 0.5)
rollbackBlockerEdict.clipMask = elevatortestqconstants.MASK_PLAYERSOLID
rollbackBlocker = ElevatorPlayer(rollbackBlockerEdict, void, 0, 100)
elevatortestworld.addEntity(rollbackWorld, rollbackFirst)
elevatortestworld.addEntity(rollbackWorld, rollbackSecond)
rollbackEdicts = array(94, void)
rollbackEdicts[90] = rollbackGroundEdict
rollbackEdicts[91] = elevatortestgametypes.zeroEdict(91)
rollbackEdicts[92] = rollbackRiderEdict
rollbackEdicts[93] = rollbackBlockerEdict
rollbackContext = ElevatorPlayerContext(fallbackImports,
  [rollbackRider, rollbackBlocker], recordElevatorTriggerTouch)
rollbackRuntime = ElevatorRuntime(rollbackWorld, rollbackContext, [], void,
  ElevatorExport(rollbackEdicts, 94), emptyWeaponContext())
elevatorTraceMode = 4; elevatorTraceCount = 0
elevatorTriggerTouchCount = 0; elevatorTeamSecondNumber = 91
rollbackCapture = elevatortestpusher.capture(rollbackRuntime)
elevatortestworld.runFrame(rollbackWorld)
elevatorAssert(elevatortestpusher.resolve(rollbackRuntime,
    rollbackCapture) == 0 and
  rollbackFirst.origin.x == 0.0 and rollbackSecond.origin.x == 20.0 and
  rollbackRiderEdict.state.origin.x == 0.0 and
  rollbackBlockerEdict.state.origin.x == 21.0 and
  elevatorTriggerTouchCount == 1,
  "later team blocker lost the earlier successful SV_Push trigger pass")

// The native game clock advances in decimal 0.1-second ticks while MiniLang
// stores them as doubles. Treat a multiplication-derived nextthink as due when
// accumulated frame time differs only in its final floating-point ulps.
toleranceWorld = elevatortestworld.createWorld(void)
tolerancePusher = elevatortesttypes.createEntity(100, "func_door")
tolerancePusher.moveType = elevatortestconstants.MOVETYPE_PUSH
tolerancePusher.solid = elevatortestconstants.SOLID_BSP
tolerancePusher.nextThink = 1.0
tolerancePusher.think = recordElevatorThink
elevatortestworld.addEntity(toleranceWorld, tolerancePusher)
toleranceRuntime = ElevatorRuntime(toleranceWorld, void, [], void, void,
  emptyWeaponContext())
toleranceCapture = elevatortestpusher.capture(toleranceRuntime)
elevatorAssert(elevatortestpusher.deferDueThinks(toleranceCapture,
    0.9999999999999999) == 1 and
  toleranceCapture.pushers[0].thinkDue and tolerancePusher.nextThink == 0.0,
  "floating-point tick drift deferred a due mover by one full frame")

print "gameplay_elevator_pusher_tests: PASS"
