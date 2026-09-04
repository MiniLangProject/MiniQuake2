//! Provides miniquake2 game player types facilities for this project.

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

/// Store spawn spot data.
struct SpawnSpot
  /// Stores the class name value associated with spawn spot.
  className
  /// Stores the target name value associated with spawn spot.
  targetName
  /// Stores the origin value associated with spawn spot.
  origin
  /// Stores the angles value associated with spawn spot.
  angles
end struct

/// Store spawn selection data.
struct SpawnSelection
  /// Stores the spot value associated with spawn selection.
  spot
  /// Stores the origin value associated with spawn selection.
  origin
  /// Stores the angles value associated with spawn selection.
  angles
end struct

/// Store player persistent data.
struct PlayerPersistent
  /// Stores the user info value associated with player persistent.
  userInfo
  /// Stores the net name value associated with player persistent.
  netName
  /// Stores the skin value associated with player persistent.
  skin
  /// Stores the spectator value associated with player persistent.
  spectator
  /// Stores the hand value associated with player persistent.
  hand
  /// Stores the connected value associated with player persistent.
  connected
  /// Stores the health value associated with player persistent.
  health
  /// Stores the max health value associated with player persistent.
  maxHealth
  /// Stores the score value associated with player persistent.
  score
  /// Stores the selected item value associated with player persistent.
  selectedItem
  /// Stores the game help changed value associated with player persistent.
  gameHelpChanged
  /// Stores the help changed value associated with player persistent.
  helpChanged
end struct

/// Store player respawn data.
struct PlayerRespawn
  /// Stores the score value associated with player respawn.
  score
  /// Stores the enter frame value associated with player respawn.
  enterFrame
  /// Stores the spectator value associated with player respawn.
  spectator
  /// Stores the command angles value associated with player respawn.
  commandAngles
  /// Stores the cooperative inventory value associated with player respawn.
  cooperativeInventory
end struct

/// Store player powerups data.
struct PlayerPowerups
  /// Stores the quad frame value associated with player powerups.
  quadFrame
  /// Stores the invincible frame value associated with player powerups.
  invincibleFrame
  /// Stores the enviro frame value associated with player powerups.
  enviroFrame
  /// Stores the breather frame value associated with player powerups.
  breatherFrame
end struct

/// Store player view data.
struct PlayerView
  /// Stores the old velocity value associated with player view.
  oldVelocity
  /// Stores the old view angles value associated with player view.
  oldViewAngles
  /// Stores the kick origin value associated with player view.
  kickOrigin
  /// Stores the kick angles value associated with player view.
  kickAngles
  /// Stores the damage from value associated with player view.
  damageFrom
  /// Stores the damage blend value associated with player view.
  damageBlend
  /// Stores the damage blood value associated with player view.
  damageBlood
  /// Stores the damage armor value associated with player view.
  damageArmor
  /// Stores the damage power armor value associated with player view.
  damagePowerArmor
  /// Stores the damage knockback value associated with player view.
  damageKnockback
  /// Stores the damage alpha value associated with player view.
  damageAlpha
  /// Stores the bonus alpha value associated with player view.
  bonusAlpha
  /// Stores the damage roll value associated with player view.
  damageRoll
  /// Stores the damage pitch value associated with player view.
  damagePitch
  /// Stores the damage time value associated with player view.
  damageTime
  /// Stores the fall value value associated with player view.
  fallValue
  /// Stores the fall time value associated with player view.
  fallTime
  /// Stores the pain debounce time value associated with player view.
  painDebounceTime
  /// Stores the damage debounce time value associated with player view.
  damageDebounceTime
  /// Stores the air finished value associated with player view.
  airFinished
  /// Stores the next drown time value associated with player view.
  nextDrownTime
  /// Stores the drown damage value associated with player view.
  drownDamage
  /// Stores the old water level value associated with player view.
  oldWaterLevel
  /// Stores the breather sound value associated with player view.
  breatherSound
  /// Stores the bob time value associated with player view.
  bobTime
  /// Stores the bob move value associated with player view.
  bobMove
  /// Stores the bob cycle value associated with player view.
  bobCycle
  /// Stores the bob frac sin value associated with player view.
  bobFracSin
  /// Stores the xy speed value associated with player view.
  xySpeed
  /// Stores the anim priority value associated with player view.
  animPriority
  /// Stores the anim end value associated with player view.
  animEnd
  /// Stores the anim duck value associated with player view.
  animDuck
  /// Stores the anim run value associated with player view.
  animRun
  /// Stores the pain cycle value associated with player view.
  painCycle
  /// Stores the death cycle value associated with player view.
  deathCycle
  /// Stores the weapon sound value associated with player view.
  weaponSound
  /// Stores the machinegun shots value associated with player view.
  machinegunShots
end struct

/// Store view settings data.
struct ViewSettings
  /// Stores the roll angle value associated with view settings.
  rollAngle
  /// Stores the roll speed value associated with view settings.
  rollSpeed
  /// Stores the run pitch value associated with view settings.
  runPitch
  /// Stores the run roll value associated with view settings.
  runRoll
  /// Stores the bob pitch value associated with view settings.
  bobPitch
  /// Stores the bob roll value associated with view settings.
  bobRoll
  /// Stores the bob up value associated with view settings.
  bobUp
  /// Stores the gun x value associated with view settings.
  gunX
  /// Stores the gun y value associated with view settings.
  gunY
  /// Stores the gun z value associated with view settings.
  gunZ
end struct

/// Store player data data.
struct PlayerData
  /// Stores the edict value associated with player data.
  edict
  /// Stores the gameplay value associated with player data.
  gameplay
  /// Stores the persistent value associated with player data.
  persistent
  /// Stores the respawn value associated with player data.
  respawn
  /// Stores the velocity value associated with player data.
  velocity
  /// Stores the old pmove value associated with player data.
  oldPmove
  /// Stores the health value associated with player data.
  health
  /// Stores the max health value associated with player data.
  maxHealth
  /// Stores the move type value associated with player data.
  moveType
  /// Stores the dead flag value associated with player data.
  deadFlag
  /// Stores the take damage value associated with player data.
  takeDamage
  /// Stores the view height value associated with player data.
  viewHeight
  /// Stores the water level value associated with player data.
  waterLevel
  /// Stores the water type value associated with player data.
  waterType
  /// Stores the ground entity value associated with player data.
  groundEntity
  /// Stores the ground link count value associated with player data.
  groundLinkCount
  /// Stores the old buttons value associated with player data.
  oldButtons
  /// Stores the buttons value associated with player data.
  buttons
  /// Stores the latched buttons value associated with player data.
  latchedButtons
  /// Stores the weapon thunk value associated with player data.
  weaponThunk
  /// Stores the respawn time value associated with player data.
  respawnTime
  /// Stores the killer yaw value associated with player data.
  killerYaw
  /// Stores the chase target value associated with player data.
  chaseTarget
  /// Stores the light level value associated with player data.
  lightLevel
  /// Stores the show scores value associated with player data.
  showScores
  /// Stores the show inventory value associated with player data.
  showInventory
  /// Stores the show help value associated with player data.
  showHelp
  /// Stores the pickup message time value associated with player data.
  pickupMessageTime
  /// Stores the powerups value associated with player data.
  powerups
  /// Stores the armor item index value associated with player data.
  armorItemIndex
  /// Stores the flags value associated with player data.
  flags
  /// Stores the obituary value associated with player data.
  obituary
  /// Stores the view value associated with player data.
  view
  /// Stores the hand grenade state value associated with player data.
  handGrenadeState
  /// Stores the flood when value associated with player data.
  floodWhen
  /// Stores the flood when head value associated with player data.
  floodWhenHead
  /// Stores the flood lock till value associated with player data.
  floodLockTill
  /// Stores the gravity value associated with player data.
  gravity
  /// Stores the power armor time value associated with player data.
  powerArmorTime
  /// Stores the fly sound debounce time value associated with player data.
  flySoundDebounceTime
end struct

/// Store player context data.
struct PlayerContext
  /// Stores the imports value associated with player context.
  imports
  /// Stores the registry value associated with player context.
  registry
  /// Stores the players value associated with player context.
  players
  /// Stores the spawn spots value associated with player context.
  spawnSpots
  /// Stores the deathmatch value associated with player context.
  deathmatch
  /// Stores the cooperative value associated with player context.
  cooperative
  /// Stores the dm flags value associated with player context.
  dmFlags
  /// Stores the time value associated with player context.
  time
  /// Stores the frame number value associated with player context.
  frameNumber
  /// Stores the help changed value associated with player context.
  helpChanged
  /// Stores the gravity value associated with player context.
  gravity
  /// Stores the intermission time value associated with player context.
  intermissionTime
  /// Stores the exit intermission value associated with player context.
  exitIntermission
  /// Stores the spawn point value associated with player context.
  spawnPoint
  /// Stores the password value associated with player context.
  password
  /// Stores the spectator password value associated with player context.
  spectatorPassword
  /// Stores the max spectators value associated with player context.
  maxSpectators
  /// Stores the frag limit value associated with player context.
  fragLimit
  /// Stores the time limit value associated with player context.
  timeLimit
  /// Stores the map name value associated with player context.
  mapName
  /// Stores the next map value associated with player context.
  nextMap
  /// Stores the map list value associated with player context.
  mapList
  /// Stores the random index value associated with player context.
  randomIndex
  /// Stores the ban check value associated with player context.
  banCheck
  /// Stores the pmove trace value associated with player context.
  pmoveTrace
  /// Stores the point contents value associated with player context.
  pointContents
  /// Stores the pmove value associated with player context.
  pmove
  /// Stores the touch triggers value associated with player context.
  touchTriggers
  /// Stores the touch entity value associated with player context.
  touchEntity
  /// Stores the weapon think value associated with player context.
  weaponThink
  /// Stores the kill box value associated with player context.
  killBox
  /// Stores the copy body value associated with player context.
  copyBody
  /// Stores the death drop value associated with player context.
  deathDrop
  /// Stores the death grenade value associated with player context.
  deathGrenade
  /// Stores the messages value associated with player context.
  messages
  /// Stores the view settings value associated with player context.
  viewSettings
  /// Stores the damage player value associated with player context.
  damagePlayer
  /// Stores the player noise value associated with player context.
  playerNoise
end struct

/// Store connect result data.
struct ConnectResult
  /// Stores the accepted value associated with connect result.
  accepted
  /// Stores the user info value associated with connect result.
  userInfo
  /// Stores the rejection value associated with connect result.
  rejection
end struct

/// Store death result data.
struct DeathResult
  /// Stores the message value associated with death result.
  message
  /// Stores the victim score value associated with death result.
  victimScore
  /// Stores the attacker score value associated with death result.
  attackerScore
  /// Stores the friendly fire value associated with death result.
  friendlyFire
end struct

/// Store frame result data.
struct FrameResult
  /// Stores the moved value associated with frame result.
  moved
  /// Stores the fired value associated with frame result.
  fired
  /// Stores the respawned value associated with frame result.
  respawned
  /// Stores the exit intermission value associated with frame result.
  exitIntermission
end struct

/// Store rule result data.
struct RuleResult
  /// Stores the ended value associated with rule result.
  ended
  /// Stores the reason value associated with rule result.
  reason
  /// Stores the next map value associated with rule result.
  nextMap
end struct

/// Spawn spot.
/// @param className className value consumed by this operation.
/// @param targetName targetName value consumed by this operation.
/// @param origin origin value consumed by this operation.
/// @param angles angles value consumed by this operation.
function spawnSpot(className, targetName, origin, angles)
  return SpawnSpot(className, targetName, origin, angles)
end function

/// Return the zero persistent value.
function zeroPersistent()
  return PlayerPersistent("", "unnamed", "male/grunt", false, 0, false,
    0, 100, 0, 0, 0, 0)
end function

/// Return the zero respawn value.
/// @param itemSlots itemSlots value consumed by this operation.
function zeroRespawn(itemSlots)
  return PlayerRespawn(0, 0, false, [0.0, 0.0, 0.0], array(itemSlots, 0))
end function

/// Return the zero player view value.
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

/// Return the default view settings value.
function defaultViewSettings()
  return ViewSettings(2.0, 200.0, 0.002, 0.005, 0.002, 0.002, 0.005, 0.0, 0.0, 0.0)
end function

/// Create player.
/// @param number number value consumed by this operation.
/// @param registry registry value consumed by this operation.
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
    array(10, 0.0), 0, 0.0, 1.0, 0.0, 0.0
  )
end function

/// Create context.
/// @param imports imports value consumed by this operation.
/// @param registry registry value consumed by this operation.
/// @param pmoveTrace pmoveTrace value consumed by this operation.
function createContext(imports, registry, pmoveTrace)
  return PlayerContext(
    imports, registry, [], [], false, false, 0,
    0.0, 0, 0, gplayerconstants.DEFAULT_GRAVITY, 0.0, false, "",
    "", "", 4, 0, 0.0, "", "", "",
    void, void, pmoveTrace, imports.pointContents, imports.pmove,
    void, void, void, void, void, void, void, [], defaultViewSettings(), void,
    void
  )
end function

/// Connect result.
/// @param accepted accepted value consumed by this operation.
/// @param userInfo userInfo value consumed by this operation.
/// @param rejection rejection value consumed by this operation.
function connectResult(accepted, userInfo, rejection)
  return ConnectResult(accepted, userInfo, rejection)
end function
