//! Provides miniquake2 game ai types facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Managed records for callback-driven g_ai.c/g_monster.c behavior. */
package miniquake2.game.ai.types

import miniquake2.game.ai.constants as gaiconstants
import miniquake2.game.types as gtypes
import miniquake2.qcommon.types as gaiqtypes

/// Store monster frame data.
struct MonsterFrame
  /// Stores the ai function value associated with monster frame.
  aiFunction
  /// Stores the distance value associated with monster frame.
  distance
  /// Stores the think function value associated with monster frame.
  thinkFunction
end struct

/// Store monster move data.
struct MonsterMove
  /// Stores the name value associated with monster move.
  name
  /// Stores the first frame value associated with monster move.
  firstFrame
  /// Stores the last frame value associated with monster move.
  lastFrame
  /// Stores the frames value associated with monster move.
  frames
  /// Stores the end function value associated with monster move.
  endFunction
end struct

/// Store monster info data.
struct MonsterInfo
  /// Stores the current move value associated with monster info.
  currentMove
  /// Stores the next frame value associated with monster info.
  nextFrame
  /// Stores the scale value associated with monster info.
  scale
  /// Stores the ai flags value associated with monster info.
  aiFlags
  /// Stores the pause time value associated with monster info.
  pauseTime
  /// Stores the idle time value associated with monster info.
  idleTime
  /// Stores the search time value associated with monster info.
  searchTime
  /// Stores the attack finished value associated with monster info.
  attackFinished
  /// Stores the last sighting value associated with monster info.
  lastSighting
  /// Stores the saved goal value associated with monster info.
  savedGoal
  /// Stores the trail time value associated with monster info.
  trailTime
  /// Stores the attack state value associated with monster info.
  attackState
  /// Stores the lefty value associated with monster info.
  lefty
  /// Stores the link count value associated with monster info.
  linkCount
  /// Stores the stand value associated with monster info.
  stand
  /// Stores the idle value associated with monster info.
  idle
  /// Stores the search value associated with monster info.
  search
  /// Stores the walk value associated with monster info.
  walk
  /// Stores the run value associated with monster info.
  run
  /// Stores the dodge value associated with monster info.
  dodge
  /// Stores the attack value associated with monster info.
  attack
  /// Stores the melee value associated with monster info.
  melee
  /// Stores the sight value associated with monster info.
  sight
  /// Stores the check attack value associated with monster info.
  checkAttack
end struct

/// Store ai actor data.
struct AIActor
  /// Stores the edict value associated with aiactor.
  edict
  /// Stores the class name value associated with aiactor.
  className
  /// Stores the model value associated with aiactor.
  model
  /// Stores the mins value associated with aiactor.
  mins
  /// Stores the maxs value associated with aiactor.
  maxs
  /// Stores the health value associated with aiactor.
  health
  /// Stores the max health value associated with aiactor.
  maxHealth
  /// Stores the gib health value associated with aiactor.
  gibHealth
  /// Stores the mass value associated with aiactor.
  mass
  /// Stores the view height value associated with aiactor.
  viewHeight
  /// Stores the yaw speed value associated with aiactor.
  yawSpeed
  /// Stores the ideal yaw value associated with aiactor.
  idealYaw
  /// Stores the flags value associated with aiactor.
  flags
  /// Stores the spawn flags value associated with aiactor.
  spawnFlags
  /// Stores the move type value associated with aiactor.
  moveType
  /// Stores the take damage value associated with aiactor.
  takeDamage
  /// Stores the dead flag value associated with aiactor.
  deadFlag
  /// Stores the next think value associated with aiactor.
  nextThink
  /// Stores the show hostile value associated with aiactor.
  showHostile
  /// Stores the light level value associated with aiactor.
  lightLevel
  /// Stores the area number value associated with aiactor.
  areaNumber
  /// Indicates whether is client is active for the aiactor value.
  isClient
  /// Indicates whether is monster is active for the aiactor value.
  isMonster
  /// Stores the target value associated with aiactor.
  target
  /// Stores the target name value associated with aiactor.
  targetName
  /// Stores the death target value associated with aiactor.
  deathTarget
  /// Stores the combat target value associated with aiactor.
  combatTarget
  /// Stores the enemy value associated with aiactor.
  enemy
  /// Stores the old enemy value associated with aiactor.
  oldEnemy
  /// Stores the goal entity value associated with aiactor.
  goalEntity
  /// Stores the move target value associated with aiactor.
  moveTarget
  /// Stores the owner value associated with aiactor.
  owner
  /// Stores the activator value associated with aiactor.
  activator
  /// Stores the item value associated with aiactor.
  item
  /// Stores the info value associated with aiactor.
  info
  /// Stores the pain value associated with aiactor.
  pain
  /// Stores the die value associated with aiactor.
  die
  /// Stores the activity value associated with aiactor.
  activity
  /// Stores the pain count value associated with aiactor.
  painCount
  /// Stores the die count value associated with aiactor.
  dieCount
  /// Stores the attack count value associated with aiactor.
  attackCount
  /// Stores the melee count value associated with aiactor.
  meleeCount
  /// Stores the think kind value associated with aiactor.
  thinkKind
  /// Stores the death use complete value associated with aiactor.
  deathUseComplete
  /// Stores the boss phase value associated with aiactor.
  bossPhase
  /// Stores the successor class name value associated with aiactor.
  successorClassName
  /// Stores the successor due time value associated with aiactor.
  successorDueTime
  /// Stores the successor spawned value associated with aiactor.
  successorSpawned
  /// Stores the number value associated with aiactor.
  number
  /// Stores the reaction debounce value associated with aiactor.
  reactionDebounce
  /// Stores the attack aim value associated with aiactor.
  attackAim
  /// Stores the attack aim valid value associated with aiactor.
  attackAimValid
  /// Stores the attack cycles value associated with aiactor.
  attackCycles
  /// Stores the teleport time value associated with aiactor.
  teleportTime
  /// Stores the noise primary value associated with aiactor.
  noisePrimary
  /// Stores the noise secondary value associated with aiactor.
  noiseSecondary
  /// Stores the ground entity value associated with aiactor.
  groundEntity
  /// Stores the ground link count value associated with aiactor.
  groundLinkCount
  /// Stores the water level value associated with aiactor.
  waterLevel
  /// Stores the water type value associated with aiactor.
  waterType
  /// Stores the velocity value associated with aiactor.
  velocity
  /// Stores the movement initialized value associated with aiactor.
  movementInitialized
  /// Stores the pursuit goal value associated with aiactor.
  pursuitGoal
  /// Stores the timestamp value associated with aiactor.
  timestamp
  /// Stores the trigger proxy value associated with aiactor.
  triggerProxy
  /// Stores the enemy visible value associated with aiactor.
  enemyVisible
  /// Stores the air finished value associated with aiactor.
  airFinished
  /// Stores the pain debounce time value associated with aiactor.
  painDebounceTime
  /// Stores the damage debounce time value associated with aiactor.
  damageDebounceTime
  /// Stores the power armor time value associated with aiactor.
  powerArmorTime
  /// Stores the power armor type value associated with aiactor.
  powerArmorType
  /// Stores the power armor power value associated with aiactor.
  powerArmorPower
  /// Stores the gravity value associated with aiactor.
  gravity
end struct

/// Store ai context data.
struct AIContext
  /// Stores the time value associated with aicontext.
  time
  /// Stores the frame number value associated with aicontext.
  frameNumber
  /// Stores the skill value associated with aicontext.
  skill
  /// Stores the deathmatch value associated with aicontext.
  deathmatch
  /// Stores the cooperative value associated with aicontext.
  cooperative
  /// Stores the sight client value associated with aicontext.
  sightClient
  /// Stores the sight entity value associated with aicontext.
  sightEntity
  /// Stores the sight entity frame value associated with aicontext.
  sightEntityFrame
  /// Stores the sound entity value associated with aicontext.
  soundEntity
  /// Stores the sound entity frame value associated with aicontext.
  soundEntityFrame
  /// Stores the sound2 entity value associated with aicontext.
  sound2Entity
  /// Stores the sound2 entity frame value associated with aicontext.
  sound2EntityFrame
  /// Stores the random attack value associated with aicontext.
  randomAttack
  /// Stores the random delay value associated with aicontext.
  randomDelay
  /// Stores the random idle value associated with aicontext.
  randomIdle
  /// Stores the random frame value associated with aicontext.
  randomFrame
  /// Stores the next random unit value associated with aicontext.
  nextRandomUnit
  /// Stores the next random integer value associated with aicontext.
  nextRandomInteger
  /// Stores the find dead monster value associated with aicontext.
  findDeadMonster
  /// Stores the reaction frame event value associated with aicontext.
  reactionFrameEvent
  /// Stores the walk move value associated with aicontext.
  walkMove
  /// Stores the move to goal value associated with aicontext.
  moveToGoal
  /// Stores the visible value associated with aicontext.
  visible
  /// Stores the clear shot value associated with aicontext.
  clearShot
  /// Stores the in phs value associated with aicontext.
  inPHS
  /// Stores the areas connected value associated with aicontext.
  areasConnected
  /// Stores the pick target value associated with aicontext.
  pickTarget
  /// Stores the use targets value associated with aicontext.
  useTargets
  /// Stores the drop item value associated with aicontext.
  dropItem
  /// Stores the spawn monster value associated with aicontext.
  spawnMonster
  /// Stores the play sound value associated with aicontext.
  playSound
  /// Stores the temp entity value associated with aicontext.
  tempEntity
  /// Stores the death effect value associated with aicontext.
  deathEffect
  /// Stores the move trace value associated with aicontext.
  moveTrace
  /// Stores the point contents value associated with aicontext.
  pointContents
  /// Stores the link actor value associated with aicontext.
  linkActor
  /// Stores the touch actor triggers value associated with aicontext.
  touchActorTriggers
  /// Stores the trail pick first value associated with aicontext.
  trailPickFirst
  /// Stores the trail pick next value associated with aicontext.
  trailPickNext
  /// Stores the find targets value associated with aicontext.
  findTargets
  /// Stores the damage value associated with aicontext.
  damage
  /// Stores the kill box value associated with aicontext.
  killBox
  /// Stores the sound index value associated with aicontext.
  soundIndex
  /// Stores the log value associated with aicontext.
  log
  /// Stores the actor chat value associated with aicontext.
  actorChat
end struct

/// Store target selection data.
struct TargetSelection
  /// Stores the candidate value associated with target selection.
  candidate
  /// Stores the heard value associated with target selection.
  heard
end struct

/// Store monster archetype data.
struct MonsterArchetype
  /// Stores the class name value associated with monster archetype.
  className
  /// Stores the model value associated with monster archetype.
  model
  /// Stores the mins value associated with monster archetype.
  mins
  /// Stores the maxs value associated with monster archetype.
  maxs
  /// Stores the health value associated with monster archetype.
  health
  /// Stores the gib health value associated with monster archetype.
  gibHealth
  /// Stores the mass value associated with monster archetype.
  mass
  /// Stores the movement value associated with monster archetype.
  movement
  /// Indicates whether has attack is active for the monster archetype value.
  hasAttack
  /// Indicates whether has melee is active for the monster archetype value.
  hasMelee
  /// Stores the scale value associated with monster archetype.
  scale
end struct

/// Store archetype registry data.
struct ArchetypeRegistry
  /// Stores the entries value associated with archetype registry.
  entries
  /// Stores the campaign entries value associated with archetype registry.
  campaignEntries
end struct

/// Report whether no operation.
function noOperation()
  return true
end function

/// Return the default monster info value.
function defaultMonsterInfo()
  lastSighting = [0.0, 0.0, 0.0]
  savedGoal = [0.0, 0.0, 0.0]
  return MonsterInfo(
    void, 0, 1.0, 0, 0.0, 0.0, 0.0, 0.0,
    lastSighting, savedGoal, 0.0, gaiconstants.AS_STRAIGHT, 0, 0,
    void, void, void, void, void, void, void, void, void, void
  )
end function

/// Create actor.
/// @param number number value consumed by this operation.
/// @param className className value consumed by this operation.
function createActor(number, className)
  edict = gtypes.zeroEdict(number)
  edict.inUse = true
  // Re-root the three nested render vectors before the larger AIActor
  // allocation. This package can be instantiated after large registry builds,
  // where an allocation-triggered GC makes constructor-only temporaries unsafe.
  gaiActorOriginHolder = gaiqtypes.Vec3(0.0, 0.0, 0.0)
  gaiActorAnglesHolder = gaiqtypes.Vec3(0.0, 0.0, 0.0)
  gaiActorOldOriginHolder = gaiqtypes.Vec3(0.0, 0.0, 0.0)
  edict.state.origin = gaiActorOriginHolder
  edict.state.angles = gaiActorAnglesHolder
  edict.state.oldOrigin = gaiActorOldOriginHolder
  gtypes.stabilizeEdict(edict)
  mins = [-16.0, -16.0, -24.0]
  maxs = [16.0, 16.0, 32.0]
  info = defaultMonsterInfo()
  gaiAttackAimHolder = gaiqtypes.Vec3(0.0, 0.0, 0.0)
  gaiVelocityHolder = gaiqtypes.Vec3(0.0, 0.0, 0.0)
  actor = AIActor(
    edict, className, "", mins, maxs,
    100, 100, -40, 200, 25.0, 20.0, 0.0,
    0, 0, gaiconstants.MOVETYPE_STEP, 2, gaiconstants.DEAD_NO,
    0.0, 0.0, 128, 0, false, true,
    "", "", "", "", void, void, void, void, void, void, void,
    info, void, void, "created", 0, 0, 0, 0, "none",
    false, "none", "", 0.0, false, number, 0.0,
    gaiAttackAimHolder, false, 0, 0.0, void, void,
    void, 0, 0, 0, gaiVelocityHolder, false, void, 0.0, void, false,
    0.0, 0.0, 0.0, 0.0, gaiconstants.POWER_ARMOR_NONE, 0, 1.0
  )
  actor.edict = edict
  gtypes.stabilizeEdict(actor.edict)
  return actor
end function

/// Create client target.
/// @param number number value consumed by this operation.
function createClientTarget(number)
  actor = createActor(number, "player")
  actor.isClient = true
  actor.isMonster = false
  gaiClientHolder = gtypes.zeroGameClient()
  actor.edict.client = gaiClientHolder
  gtypes.stabilizeEdict(actor.edict)
  return actor
end function

/// Return the default context value.
function defaultContext()
  return AIContext(
    0.0, 0, 1, false, false,
    void, void, -1000, void, -1000, void, -1000,
    0.0, 0.0, 0.0, 0,
    void, void, void, void,
    void, void, void, void, void, void, void, void, void, void, void, void, void,
    void, void, void, void, void, void,
    void, void, void, void, void, void
  )
end function
