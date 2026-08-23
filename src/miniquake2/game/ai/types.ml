/* Managed records for callback-driven g_ai.c/g_monster.c behavior. */
package miniquake2.game.ai.types

import miniquake2.game.ai.constants as gaiconstants
import miniquake2.game.types as gtypes
import miniquake2.qcommon.types as gaiqtypes

struct MonsterFrame
  aiFunction
  distance
  thinkFunction
end struct

struct MonsterMove
  name
  firstFrame
  lastFrame
  frames
  endFunction
end struct

struct MonsterInfo
  currentMove
  nextFrame
  scale
  aiFlags
  pauseTime
  idleTime
  searchTime
  attackFinished
  lastSighting
  trailTime
  attackState
  lefty
  linkCount
  stand
  idle
  search
  walk
  run
  dodge
  attack
  melee
  sight
  checkAttack
end struct

struct AIActor
  edict
  className
  model
  mins
  maxs
  health
  maxHealth
  gibHealth
  mass
  viewHeight
  yawSpeed
  idealYaw
  flags
  spawnFlags
  moveType
  takeDamage
  deadFlag
  nextThink
  showHostile
  lightLevel
  areaNumber
  isClient
  isMonster
  target
  targetName
  deathTarget
  combatTarget
  enemy
  oldEnemy
  goalEntity
  moveTarget
  owner
  activator
  item
  info
  pain
  die
  activity
  painCount
  dieCount
  attackCount
  meleeCount
  thinkKind
  deathUseComplete
  bossPhase
  successorClassName
  successorDueTime
  successorSpawned
  number
  reactionDebounce
  attackAim
  attackAimValid
  attackCycles
end struct

struct AIContext
  time
  frameNumber
  skill
  deathmatch
  cooperative
  sightClient
  sightEntity
  sightEntityFrame
  soundEntity
  soundEntityFrame
  sound2Entity
  sound2EntityFrame
  randomAttack
  randomDelay
  randomIdle
  randomFrame
  walkMove
  moveToGoal
  visible
  clearShot
  inPHS
  areasConnected
  pickTarget
  useTargets
  dropItem
  spawnMonster
  playSound
  tempEntity
  deathEffect
end struct

struct TargetSelection
  candidate
  heard
end struct

struct MonsterArchetype
  className
  model
  mins
  maxs
  health
  gibHealth
  mass
  movement
  hasAttack
  hasMelee
  scale
end struct

struct ArchetypeRegistry
  entries
  campaignEntries
end struct

function noOperation()
  return true
end function

function defaultMonsterInfo()
  lastSighting = [0.0, 0.0, 0.0]
  return MonsterInfo(
    void, 0, 1.0, 0, 0.0, 0.0, 0.0, 0.0,
    lastSighting, 0.0, gaiconstants.AS_STRAIGHT, 0, 0,
    void, void, void, void, void, void, void, void, void, void
  )
end function

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
  actor = AIActor(
    edict, className, "", mins, maxs,
    100, 100, -40, 200, 25.0, 20.0, 0.0,
    0, 0, gaiconstants.MOVETYPE_STEP, 2, gaiconstants.DEAD_NO,
    0.0, 0.0, 128, 0, false, true,
    "", "", "", "", void, void, void, void, void, void, void,
    info, void, void, "created", 0, 0, 0, 0, "none",
    false, "none", "", 0.0, false, number, 0.0,
    gaiAttackAimHolder, false, 0
  )
  actor.edict = edict
  gtypes.stabilizeEdict(actor.edict)
  return actor
end function

function createClientTarget(number)
  actor = createActor(number, "player")
  actor.isClient = true
  actor.isMonster = false
  gaiClientHolder = gtypes.zeroGameClient()
  actor.edict.client = gaiClientHolder
  gtypes.stabilizeEdict(actor.edict)
  return actor
end function

function defaultContext()
  return AIContext(
    0.0, 0, 1, false, false,
    void, void, -1000, void, -1000, void, -1000,
    0.0, 0.0, 0.0, 0,
    void, void, void, void, void, void, void, void, void, void, void, void, void
  )
end function
