/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Focused g_phys.c toss clip-mask and post-link trigger regressions. */
import miniquake2.game.integration.baseq2 as tosstegration
import miniquake2.game.world.core as tossworld
import miniquake2.game.world.types as tossworldtypes
import miniquake2.game.world.constants as tossworldconstants
import miniquake2.game.types as tossgametypes
import miniquake2.qcommon.types as tossqtypes
import miniquake2.qcommon.constants as tossqconstants

// Store the import surface consumed by integrated toss physics.
struct TossImports
  trace
  pointContents
  positionedSound
  soundIndex
  boxEdicts
end struct

// Store the player-context surface consumed by integrated toss physics.
struct TossPlayerContext
  imports
  gravity
end struct

// Store the export table surface consumed by integrated toss physics.
struct TossExport
  edicts
  numEdicts
end struct

// Store the runtime surface consumed by integrated toss physics.
struct TossRuntime
  world
  playerContext
  exportTable
end struct

tossTraceMasks = array(3, 0)
tossTraceCount = 0
tossLinkCount = 0
tossTriggerTouchCount = 0
tossTriggerEdict = void

// Assert the toss parity condition.
function tossAssert(value, message)
  if value != true then return error(10019, message) end if
  return true
end function

// Record every physics trace mask and return a clear move.
function tossTrace(start, mins, maxs, finish, passEntity, mask)
  global tossTraceMasks, tossTraceCount
  tossTraceMasks[tossTraceCount] = mask
  tossTraceCount = tossTraceCount + 1
  return tossqtypes.Trace(false, false, 1.0, finish,
    tossqtypes.Plane(tossqtypes.zeroVec3(), 0.0, 0, 0),
    tossqtypes.CollisionSurface("", 0, 0), 0, void)
end function

// Return empty point contents for the dry synthetic fixture.
function tossPointContents(point)
  return 0
end function

// Ignore positioned sounds; this fixture never crosses a water boundary.
function tossPositionedSound(origin, entity, channel, soundIndex, volume,
    attenuation, timeOffset)
  return true
end function

// Return a stable dummy sound index.
function tossSoundIndex(name)
  return 1
end function

// Return the one trigger candidate intersecting each synthetic final bound.
function tossBoxEdicts(mins, maxs, areaType)
  global tossTriggerEdict
  return [tossTriggerEdict]
end function

// Record publication before the post-link trigger pass.
function tossLinkEntity(entity)
  global tossLinkCount
  tossLinkCount = tossLinkCount + 1
  entity.absoluteMins.x = entity.origin.x + entity.mins.x - 1.0
  entity.absoluteMins.y = entity.origin.y + entity.mins.y - 1.0
  entity.absoluteMins.z = entity.origin.z + entity.mins.z - 1.0
  entity.absoluteMaxs.x = entity.origin.x + entity.maxs.x + 1.0
  entity.absoluteMaxs.y = entity.origin.y + entity.maxs.y + 1.0
  entity.absoluteMaxs.z = entity.origin.z + entity.maxs.z + 1.0
  return true
end function

// Record a trigger touch from a successfully moved toss entity.
function tossTriggerTouch(trigger, other, world)
  global tossTriggerTouchCount
  tossTriggerTouchCount = tossTriggerTouchCount + 1
  return true
end function

world = tossworld.createWorld(void)
world.callbacks.linkEntity = tossLinkEntity
trigger = tossworldtypes.createEntity(10, "trigger_multiple")
trigger.solid = tossworldconstants.SOLID_TRIGGER
trigger.touch = tossTriggerTouch
tossworld.addEntity(world, trigger)
tossTriggerEdict = tossgametypes.zeroEdict(10)
tossTriggerEdict.inUse = true

ordinary = tossworldtypes.createEntity(20, "ordinary_toss")
ordinary.moveType = tossworldconstants.MOVETYPE_TOSS
ordinary.solid = tossworldconstants.SOLID_BBOX
ordinary.velocity = tossqtypes.Vec3(10.0, 0.0, 0.0)
ordinary.mins = tossqtypes.Vec3(-1.0, -1.0, -1.0)
ordinary.maxs = tossqtypes.Vec3(1.0, 1.0, 1.0)
tossworld.addEntity(world, ordinary)

monster = tossworldtypes.createEntity(21, "monster_toss")
monster.moveType = tossworldconstants.MOVETYPE_TOSS
monster.solid = tossworldconstants.SOLID_BBOX
monster.serverFlags = monster.serverFlags | tossworldconstants.SVF_MONSTER
monster.health = 100
monster.origin = tossqtypes.Vec3(0.0, 10.0, 0.0)
monster.velocity = tossqtypes.Vec3(10.0, 0.0, 0.0)
monster.mins = tossqtypes.Vec3(-1.0, -1.0, -1.0)
monster.maxs = tossqtypes.Vec3(1.0, 1.0, 1.0)
tossworld.addEntity(world, monster)

explicit = tossworldtypes.createEntity(22, "explicit_mask_toss")
explicit.moveType = tossworldconstants.MOVETYPE_TOSS
explicit.solid = tossworldconstants.SOLID_BBOX
explicit.clipMask = tossqconstants.MASK_PLAYERSOLID
explicit.origin = tossqtypes.Vec3(0.0, 20.0, 0.0)
explicit.velocity = tossqtypes.Vec3(10.0, 0.0, 0.0)
explicit.mins = tossqtypes.Vec3(-1.0, -1.0, -1.0)
explicit.maxs = tossqtypes.Vec3(1.0, 1.0, 1.0)
tossworld.addEntity(world, explicit)

edicts = array(23, void)
edicts[0] = tossgametypes.zeroEdict(0)
edicts[10] = tossTriggerEdict
edicts[20] = tossgametypes.zeroEdict(20)
edicts[21] = tossgametypes.zeroEdict(21)
edicts[22] = tossgametypes.zeroEdict(22)
imports = TossImports(tossTrace, tossPointContents, tossPositionedSound,
  tossSoundIndex, tossBoxEdicts)
runtime = TossRuntime(world, TossPlayerContext(imports, 0.0),
  TossExport(edicts, 23))

tossAssert(tosstegration.advanceWorldTossEntities(runtime) == 3,
  "integrated toss frame did not advance all three entities")
tossAssert(tossTraceCount == 3 and
  tossTraceMasks[0] == tossqconstants.MASK_SOLID and
  tossTraceMasks[1] == tossqconstants.MASK_MONSTERSOLID and
  tossTraceMasks[2] == tossqconstants.MASK_PLAYERSOLID,
  "default toss clip mask did not distinguish monsters or preserve overrides")
tossAssert(tossLinkCount == 3 and tossTriggerTouchCount == 3,
  "successful toss moves did not link and dispatch trigger contacts")
tossAssert(ordinary.origin.x == 1.0 and monster.origin.x == 1.0 and
  explicit.origin.x == 1.0,
  "clear toss traces did not commit their final origins")

print "gameplay_world_toss_parity_tests: PASS"
