/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Managed gclient/private edict state for the BaseQ2 player port. */
package miniquake2.game.player.types

import miniquake2.game.gameplay.registry as gpregistry
import miniquake2.game.gameplay.types as gptypes
import miniquake2.game.player.constants as gplayerconstants
import miniquake2.game.types as gtypes

struct SpawnSpot
  className
  targetName
  origin
  angles
end struct

struct SpawnSelection
  spot
  origin
  angles
end struct

struct PlayerPersistent
  userInfo
  netName
  skin
  spectator
  hand
  connected
  health
  maxHealth
  score
  selectedItem
end struct

struct PlayerRespawn
  score
  enterFrame
  spectator
  commandAngles
  cooperativeInventory
end struct

struct PlayerPowerups
  quadFrame
  invincibleFrame
  enviroFrame
  breatherFrame
end struct

struct PlayerView
  oldVelocity
  oldViewAngles
  kickOrigin
  kickAngles
  damageFrom
  damageBlend
  damageBlood
  damageArmor
  damagePowerArmor
  damageKnockback
  damageAlpha
  bonusAlpha
  damageRoll
  damagePitch
  damageTime
  fallValue
  fallTime
  painDebounceTime
  damageDebounceTime
  airFinished
  nextDrownTime
  drownDamage
  oldWaterLevel
  breatherSound
  bobTime
  bobMove
  bobCycle
  bobFracSin
  xySpeed
  animPriority
  animEnd
  animDuck
  animRun
  painCycle
  deathCycle
  weaponSound
  machinegunShots
end struct

struct ViewSettings
  rollAngle
  rollSpeed
  runPitch
  runRoll
  bobPitch
  bobRoll
  bobUp
  gunX
  gunY
  gunZ
end struct

struct PlayerData
  edict
  gameplay
  persistent
  respawn
  velocity
  oldPmove
  health
  maxHealth
  moveType
  deadFlag
  takeDamage
  viewHeight
  waterLevel
  waterType
  groundEntity
  groundLinkCount
  oldButtons
  buttons
  latchedButtons
  weaponThunk
  respawnTime
  killerYaw
  chaseTarget
  lightLevel
  showScores
  showInventory
  showHelp
  pickupMessageTime
  powerups
  armorItemIndex
  flags
  obituary
  view
  handGrenadeState
  floodWhen
  floodWhenHead
  floodLockTill
  gravity
  flySoundDebounceTime
end struct

struct PlayerContext
  imports
  registry
  players
  spawnSpots
  deathmatch
  cooperative
  dmFlags
  time
  frameNumber
  gravity
  intermissionTime
  exitIntermission
  spawnPoint
  password
  spectatorPassword
  maxSpectators
  fragLimit
  timeLimit
  mapName
  nextMap
  mapList
  randomIndex
  banCheck
  pmoveTrace
  pointContents
  pmove
  touchTriggers
  touchEntity
  weaponThink
  killBox
  copyBody
  messages
  viewSettings
  damagePlayer
end struct

struct ConnectResult
  accepted
  userInfo
  rejection
end struct

struct DeathResult
  message
  victimScore
  attackerScore
  friendlyFire
end struct

struct FrameResult
  moved
  fired
  respawned
  exitIntermission
end struct

struct RuleResult
  ended
  reason
  nextMap
end struct

function spawnSpot(className, targetName, origin, angles)
  return SpawnSpot(className, targetName, origin, angles)
end function

function zeroPersistent()
  return PlayerPersistent("", "unnamed", "male/grunt", false, 0, false, 0, 100, 0, 0)
end function

function zeroRespawn(itemSlots)
  return PlayerRespawn(0, 0, false, [0.0, 0.0, 0.0], array(itemSlots, 0))
end function

function zeroPlayerView()
  oldVelocity = [0.0, 0.0, 0.0]
  oldViewAngles = miniquake2.qcommon.types.Vec3(0.0, 0.0, 0.0)
  kickOrigin = miniquake2.qcommon.types.Vec3(0.0, 0.0, 0.0)
  kickAngles = miniquake2.qcommon.types.Vec3(0.0, 0.0, 0.0)
  damageFrom = miniquake2.qcommon.types.Vec3(0.0, 0.0, 0.0)
  damageBlend = [0.0, 0.0, 0.0]
  return PlayerView(
    oldVelocity, oldViewAngles,
    kickOrigin, kickAngles, damageFrom, damageBlend,
    0, 0, 0, 0, 0.0, 0.0, 0.0, 0.0, 0.0,
    0.0, 0.0, 0.0, 0.0, 12.0, 0.0, 2, 0, 0,
    0.0, 0.0, 0, 0.0, 0.0,
    gplayerconstants.ANIM_BASIC, 0, false, false, 0, 0, 0, 0
  )
end function

function defaultViewSettings()
  return ViewSettings(2.0, 200.0, 0.002, 0.005, 0.002, 0.002, 0.005, 0.0, 0.0, 0.0)
end function

function createPlayer(number, registry)
  itemSlots = gpregistry.inventorySlots(registry)
  edict = gtypes.zeroEdict(number)
  // Re-root nested vectors before the enclosing PlayerData allocation.
  edict.state.origin = miniquake2.qcommon.types.Vec3(0.0, 0.0, 0.0)
  edict.state.angles = miniquake2.qcommon.types.Vec3(0.0, 0.0, 0.0)
  edict.state.oldOrigin = miniquake2.qcommon.types.Vec3(0.0, 0.0, 0.0)
  edict.mins = miniquake2.qcommon.types.Vec3(-16.0, -16.0, -24.0)
  edict.maxs = miniquake2.qcommon.types.Vec3(16.0, 16.0, 32.0)
  edict.client = gtypes.zeroGameClient()
  gameplay = gptypes.createPlayer(number, itemSlots)
  gameplay.edict = edict
  persistent = zeroPersistent()
  respawn = zeroRespawn(itemSlots)
  velocity = [0.0, 0.0, 0.0]
  powerups = PlayerPowerups(0, 0, 0, 0)
  view = zeroPlayerView()
  return PlayerData(
    edict, gameplay, persistent, respawn, velocity, gtypes.zeroPmoveState(),
    0, 100, gplayerconstants.MOVETYPE_WALK, gplayerconstants.DEAD_NO,
    gplayerconstants.DAMAGE_AIM, 22.0, 0, 0, void, 0,
    0, 0, 0, false, 0.0, 0.0, void, 0,
    false, false, false, 0.0, powerups, 0, 0, "", view, void,
    array(10, 0.0), 0, 0.0, 1.0, 0.0
  )
end function

function createContext(imports, registry, pmoveTrace)
  return PlayerContext(
    imports, registry, [], [], false, false, 0,
    0.0, 0, gplayerconstants.DEFAULT_GRAVITY, 0.0, false, "",
    "", "", 4, 0, 0.0, "", "", "",
    void, void, pmoveTrace, imports.pointContents, imports.pmove,
    void, void, void, void, void, [], defaultViewSettings(), void
  )
end function

function connectResult(accepted, userInfo, rejection)
  return ConnectResult(accepted, userInfo, rejection)
end function
