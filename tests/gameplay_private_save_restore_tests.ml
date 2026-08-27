/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Representative private World/Monster/Item/Player level-save restoration. */
import std.fs as privatesaveexistsfs
import std.fs as privatesavedeletefs
import miniquake2.server.game_bridge as privaterestorebridge
import miniquake2.game.null_game as privaterestoregame
import miniquake2.game.integration.baseq2 as privaterestoreintegration
import miniquake2.game.gameplay.item_rules as privaterestoreitems
import miniquake2.game.gameplay.constants as privaterestoreitemconstants
import miniquake2.game.world.core as privaterestoreworld
import miniquake2.game.ai.constants as privaterestoreaiconstants
import miniquake2.qcommon.constants as privaterestoreqconstants
import miniquake2.qcommon.types as privaterestoreqtypes

// Assert the restore test condition.
function restoreAssert(value, message)
  if value != true then return error(9897, message) end if
  return true
end function

// Find private save monster.
function findPrivateSaveMonster(runtime, className)
  for each candidate in runtime.monsters
    if candidate.className == className then return candidate end if
  end for
  return void
end function

savePath = "gameplay_private_save_restore_tests.sav"
privateSaveExists = privatesaveexistsfs.exists
privateSaveDelete = privatesavedeletefs.delete
if privateSaveExists(savePath) then
  removedOldSave = privateSaveDelete(savePath)
end if

server = privaterestorebridge.createRuntime(4)
api = privaterestoregame.GetGameApi(privaterestorebridge.makeImports(server))
server.game = api
privaterestoregame.configureSkill(2)
api.init()
fixture = "{\"classname\" \"worldspawn\"}" +
  "{\"classname\" \"info_player_start\" \"origin\" \"0 0 0\"}" +
  "{\"classname\" \"func_door_rotating\" \"model\" \"*1\" \"targetname\" \"save-door\" \"distance\" \"90\" \"speed\" \"90\"}" +
  "{\"classname\" \"func_door\" \"model\" \"*2\" \"targetname\" \"save-linear\" \"speed\" \"10\" \"wait\" \"-1\"}" +
  "{\"classname\" \"ammo_shells\" \"origin\" \"40 0 0\"}" +
  "{\"classname\" \"monster_soldier\" \"origin\" \"80 64 0\"}" +
  "{\"classname\" \"monster_medic\" \"origin\" \"160 0 10\" \"angle\" \"0\"}" +
  "{\"classname\" \"monster_gunner\" \"origin\" \"240 0 10\"}" +
  "{\"classname\" \"info_notnull\" \"targetname\" \"save-turret-muzzle\" \"origin\" \"32 0 16\"}" +
  "{\"classname\" \"turret_base\" \"team\" \"save-turret\" \"model\" \"*3\"}" +
  "{\"classname\" \"turret_breach\" \"team\" \"save-turret\" \"targetname\" \"save-turret-gun\" \"target\" \"save-turret-muzzle\" \"model\" \"*4\"}" +
  "{\"classname\" \"turret_driver\" \"target\" \"save-turret-gun\" \"origin\" \"0 -32 0\"}"
api.spawnEntities("save-unit", fixture, "")
client = api.edicts[1]
api.clientConnect(client, "\\name\\Saver")
api.clientBegin(client)

runtime = privaterestoregame.baseRuntime()
context = privaterestoregame.playerContext()
door = privaterestoreintegration.findWorldByClass(runtime, "func_door_rotating")
linearDoor = privaterestoreintegration.findWorldByClass(runtime, "func_door")
saveTurretBreach = privaterestoreintegration.findWorldByClass(runtime, "turret_breach")
saveTurretDriver = privaterestoreintegration.findWorldByClass(runtime, "turret_driver")
privaterestoreworld.useEntity(runtime.world, door, void, door)
privaterestoreworld.useEntity(runtime.world, linearDoor, void, linearDoor)
api.runFrame()
savedDoorAngle = door.angles.y
savedDoorState = door.moveInfo.state
door.gravity = 0.25
door.oldVelocity = privaterestoreqtypes.Vec3(7.0, 8.0, 9.0)
door.flySoundDebounceTime = 4.5
savedLinearDirectionX = linearDoor.moveInfo.direction.x
savedLinearRemaining = linearDoor.moveInfo.remainingDistance
runtime.world.totalSecrets = 4; runtime.world.foundSecrets = 3
saveTurretDriver.timestamp = 4.25
saveTurretDriver.pauseTime = 8.5
saveTurretDriver.aiFlags = saveTurretDriver.aiFlags |
  privaterestoreaiconstants.AI_LOST_SIGHT
monster = findPrivateSaveMonster(runtime, "monster_soldier"); monster.health = 41; monster.activity = "soldier-shotgun-attack2"; monster.edict.state.frame = 77
monster.attackCount = 7; monster.meleeCount = 2; monster.painCount = 3; monster.dieCount = 1
monster.info.nextFrame = 0; monster.info.pauseTime = runtime.world.time + 0.2
monster.info.attackState = privaterestoreaiconstants.AS_MISSILE
monster.attackAim = privaterestoreqtypes.Vec3(81.0, -12.0, 47.0); monster.attackAimValid = true
monster.attackCycles = 3
monster.info.aiFlags = monster.info.aiFlags | privaterestoreaiconstants.AI_HOLD_FRAME
monster.info.aiFlags = monster.info.aiFlags |
  privaterestoreaiconstants.AI_LOST_SIGHT | privaterestoreaiconstants.AI_PURSUE_TEMP
monster.info.searchTime = 7.25; monster.info.idleTime = 8.5
monster.info.lastSighting[0] = 301.0; monster.info.lastSighting[1] = -42.0
monster.info.lastSighting[2] = 19.0
monster.info.savedGoal[0] = 512.0; monster.info.savedGoal[1] = 16.0
monster.info.savedGoal[2] = 24.0
monster.info.trailTime = 6.75; monster.idealYaw = 135.0
monster.info.lefty = 1; monster.showHostile = 9.25
monster.velocity = privaterestoreqtypes.Vec3(11.0, 12.0, 13.0)
monster.airFinished = 14.5; monster.painDebounceTime = 15.5
monster.damageDebounceTime = 16.5; monster.powerArmorTime = 17.5
monster.powerArmorType = privaterestoreaiconstants.POWER_ARMOR_SCREEN
monster.powerArmorPower = 23; monster.gravity = 0.75
saveMedic = findPrivateSaveMonster(runtime, "monster_medic")
savePatient = findPrivateSaveMonster(runtime, "monster_gunner")
monster.enemy = runtime.aiPlayers[0]
monster.goalEntity = monster.enemy
monster.moveTarget = savePatient
saveMedic.enemy = savePatient
saveMedic.oldEnemy = runtime.aiPlayers[0]
saveMedic.info.aiFlags = saveMedic.info.aiFlags | privaterestoreaiconstants.AI_MEDIC
saveMedic.activity = "medic-cable"
saveMedic.info.nextFrame = 4
saveMedic.info.pauseTime = runtime.world.time + 0.2
saveMedic.info.attackState = privaterestoreaiconstants.AS_MISSILE
savePatient.health = -25
savePatient.nextThink = 0.0
savePatient.activity = "corpse"
savePatient.owner = saveMedic
savePatient.info.aiFlags = privaterestoreaiconstants.AI_RESURRECTING
runtime.randomState.seed = 305419896
item = runtime.items[0]; item.hidden = true; item.nextThink = 12.5; item.count = 9
player = context.players[0]; player.health = 73; player.maxHealth = 125; player.gameplay.inventory.counts[2] = 17
player.powerups.quadFrame = 321; player.persistent.score = 6
player.gravity = 0.5; player.flySoundDebounceTime = 6.25
player.gameplay.inventory.maxBullets = 300
player.gameplay.inventory.maxShells = 200
player.gameplay.inventory.maxRockets = 100
player.gameplay.inventory.maxGrenades = 100
player.gameplay.inventory.maxCells = 300
player.gameplay.inventory.maxSlugs = 100
player.gameplay.inventory.selectedItem = 2
player.gameplay.silencerShots = 17
player.gameplay.powerCubes = 5
player.respawn.cooperativeInventory[2] = 11
player.persistent.gameHelpChanged = 4
player.persistent.helpChanged = 2
player.edict.state.frame = 166
privateSavedBody = privaterestoreintegration.copyPlayerBody(runtime, player)
context.imports.linkEntity(player.edict)
privateSaveShells = privaterestoreitems.findByPickupName(context.registry,
  "Shells")
player.gameplay.inventory.counts[privateSaveShells.index] = 20
privateSaveDrop = privaterestoreintegration.dropPlayerItem(runtime, player,
  context, privateSaveShells)
restoreAssert(privateSaveDrop.success, "dynamic dropped-item save fixture")
privateSaveDroppedNumber = privateSaveDrop.droppedEntity.edict.state.number
api.writeLevel(savePath)

door.angles.y = 999.0; door.moveInfo.state = 99
runtime.world.foundSecrets = 0
monster.health = 1; monster.activity = "mutated"; monster.edict.state.frame = 1
monster.attackCount = 0; monster.meleeCount = 0; monster.painCount = 0; monster.dieCount = 0
monster.info.nextFrame = 99; monster.info.pauseTime = 999.0; monster.info.attackState = 0
monster.attackAim = privaterestoreqtypes.Vec3(0.0, 0.0, 0.0); monster.attackAimValid = false
monster.attackCycles = 0
monster.info.aiFlags = monster.info.aiFlags & ~privaterestoreaiconstants.AI_HOLD_FRAME
runtime.randomState.seed = 1
saveTurretDriver.timestamp = 0.0; saveTurretDriver.pauseTime = 0.0
saveTurretDriver.aiFlags = saveTurretDriver.aiFlags &
  ~privaterestoreaiconstants.AI_LOST_SIGHT
saveTurretDriver.clipMask = 0
item.hidden = false; item.nextThink = 0.0; item.count = 0
player.health = 1; player.gameplay.inventory.counts[2] = 0; player.powerups.quadFrame = 0; player.persistent.score = 0

api.readLevel(savePath)
restoredRuntime = privaterestoregame.baseRuntime()
restoredContext = privaterestoregame.playerContext()
restoredDoor = privaterestoreintegration.findWorldByClass(restoredRuntime, "func_door_rotating")
restoredLinearDoor = privaterestoreintegration.findWorldByClass(restoredRuntime, "func_door")
restoredTurretBreach = privaterestoreintegration.findWorldByClass(restoredRuntime, "turret_breach")
restoredTurretDriver = privaterestoreintegration.findWorldByClass(restoredRuntime, "turret_driver")
restoreAssert(restoredDoor.angles.y == savedDoorAngle and restoredDoor.moveInfo.state == savedDoorState, "mover transform/state restored")
restoreAssert(restoredDoor.gravity == 0.25 and
  restoredDoor.oldVelocity.x == 7.0 and restoredDoor.oldVelocity.y == 8.0 and
  restoredDoor.oldVelocity.z == 9.0 and
  restoredDoor.flySoundDebounceTime == 4.5,
  "private v16 restores world gravity/push state")
restoreAssert(restoredDoor.think is not void, "mid-move callback rebound")
restoreAssert(typeof(restoredLinearDoor.moveInfo.direction) == "struct" and
  restoredLinearDoor.moveInfo.direction.x == savedLinearDirectionX and
  restoredLinearDoor.moveInfo.remainingDistance == savedLinearRemaining,
  "linear mover direction/distance restored")
restoreAssert(restoredRuntime.world.totalSecrets == 4 and restoredRuntime.world.foundSecrets == 3, "level counters restored")
restoreAssert(restoredRuntime.aiContext.skill == 2 and
  privaterestoregame.configuredGameSkill() == 2,
  "new game skill restored and retained for later maps")
restoreAssert(restoredRuntime.randomState.seed == 305419896,
  "shared Win32 random stream restored")
restoreAssert(restoredTurretDriver.timestamp == 4.25 and
  restoredTurretDriver.pauseTime == 8.5 and
  (restoredTurretDriver.aiFlags & privaterestoreaiconstants.AI_LOST_SIGHT) != 0 and
  restoredTurretDriver.clipMask == privaterestoreqconstants.MASK_MONSTERSOLID and
  restoredTurretDriver.think is not void and restoredTurretDriver.die is not void and
  nativeRawValue(restoredTurretBreach.owner) == nativeRawValue(restoredTurretDriver),
  "private v13 restores live turret AI/cooldown/team state")
restoredMonster = findPrivateSaveMonster(restoredRuntime, "monster_soldier")
restoreAssert(restoredMonster.health == 41 and restoredMonster.activity == "soldier-shotgun-attack2" and restoredMonster.edict.state.frame == 77, "monster private state restored")
restoreAssert(restoredMonster.attackCount == 7 and restoredMonster.meleeCount == 2 and
  restoredMonster.painCount == 3 and restoredMonster.dieCount == 1 and
  restoredMonster.info.nextFrame == 0 and restoredMonster.info.pauseTime > 0.29 and restoredMonster.info.pauseTime < 0.31 and
  restoredMonster.info.attackState == privaterestoreaiconstants.AS_MISSILE and
  restoredMonster.attackAimValid and restoredMonster.attackAim.x == 81.0 and
  restoredMonster.attackAim.y == -12.0 and restoredMonster.attackAim.z == 47.0 and
  restoredMonster.attackCycles == 3 and
  (restoredMonster.info.aiFlags & privaterestoreaiconstants.AI_HOLD_FRAME) != 0,
  "in-flight monster attack/held-frame sequence restored")
restoreAssert((restoredMonster.info.aiFlags & privaterestoreaiconstants.AI_LOST_SIGHT) != 0 and
  (restoredMonster.info.aiFlags & privaterestoreaiconstants.AI_PURSUE_TEMP) != 0 and
  restoredMonster.info.searchTime == 7.25 and restoredMonster.info.idleTime == 8.5 and
  restoredMonster.info.lastSighting[0] == 301.0 and
  restoredMonster.info.lastSighting[1] == -42.0 and
  restoredMonster.info.lastSighting[2] == 19.0 and
  restoredMonster.info.savedGoal[0] == 512.0 and
  restoredMonster.info.savedGoal[1] == 16.0 and
  restoredMonster.info.savedGoal[2] == 24.0 and
  restoredMonster.info.trailTime == 6.75 and restoredMonster.idealYaw == 135.0 and
  restoredMonster.info.lefty == 1 and restoredMonster.showHostile == 9.25 and
  restoredMonster.velocity.x == 11.0 and restoredMonster.velocity.y == 12.0 and
  restoredMonster.velocity.z == 13.0 and restoredMonster.enemy is not void and
  nativeRawValue(restoredMonster.goalEntity) == nativeRawValue(restoredMonster.enemy) and
  restoredMonster.moveTarget is not void and restoredMonster.moveTarget.className == "monster_gunner",
  "private v14 restores lost-sight pursuit and movement state")
restoreAssert(restoredMonster.airFinished == 14.5 and
  restoredMonster.painDebounceTime == 15.5 and
  restoredMonster.damageDebounceTime == 16.5 and
  restoredMonster.powerArmorTime == 17.5 and
  restoredMonster.powerArmorType == privaterestoreaiconstants.POWER_ARMOR_SCREEN and
  restoredMonster.powerArmorPower == 23 and restoredMonster.gravity == 0.75,
  "private v16 restores monster environment/power-armor state")
restoredMedic = findPrivateSaveMonster(restoredRuntime, "monster_medic")
restoredPatient = findPrivateSaveMonster(restoredRuntime, "monster_gunner")
restoreAssert(restoredMedic.activity == "medic-cable" and
  restoredMedic.info.nextFrame == 4 and
  (restoredMedic.info.aiFlags & privaterestoreaiconstants.AI_MEDIC) != 0 and
  nativeRawValue(restoredMedic.enemy) == nativeRawValue(restoredPatient) and
  restoredMedic.oldEnemy is not void and restoredMedic.oldEnemy.isClient and
  restoredMedic.oldEnemy.edict.state.number == 1 and
  nativeRawValue(restoredPatient.owner) == nativeRawValue(restoredMedic) and
  (restoredPatient.info.aiFlags & privaterestoreaiconstants.AI_RESURRECTING) != 0,
  "private v14 restores Medic cable references and AI flags")
restoreAssert(restoredRuntime.items[0].hidden and restoredRuntime.items[0].nextThink == 12.5 and restoredRuntime.items[0].count == 9, "item respawn state restored")
restoredDroppedItem = privaterestoreintegration.findItemByNumber(
  restoredRuntime, privateSaveDroppedNumber)
restoreAssert(restoredDroppedItem is not void and
  (restoredDroppedItem.spawnFlags &
    privaterestoreitemconstants.DROPPED_ITEM) != 0 and
  restoredDroppedItem.velocity.z == 300.0 and
  restoredDroppedItem.owner is not void and
  restoredDroppedItem.edict.owner.state.number == 1,
  "private v16 restores dynamic Drop_Item velocity/owner")
restoredPlayer = restoredContext.players[0]
restoreAssert(restoredPlayer.health == 73 and restoredPlayer.maxHealth == 125, "player health restored")
restoreAssert(restoredPlayer.gravity == 0.5 and
  restoredPlayer.flySoundDebounceTime == 6.25,
  "private v16 restores player gravity/push debounce")
restoreAssert(restoredPlayer.gameplay.inventory.counts[2] == 17 and restoredPlayer.powerups.quadFrame == 321 and restoredPlayer.persistent.score == 6, "inventory/powerup/score restored")
restoreAssert(restoredPlayer.gameplay.inventory.maxBullets == 300 and
  restoredPlayer.gameplay.inventory.maxShells == 200 and
  restoredPlayer.gameplay.inventory.maxRockets == 100 and
  restoredPlayer.gameplay.inventory.maxGrenades == 100 and
  restoredPlayer.gameplay.inventory.maxCells == 300 and
  restoredPlayer.gameplay.inventory.maxSlugs == 100 and
  restoredPlayer.gameplay.inventory.selectedItem == 2 and
  restoredPlayer.gameplay.silencerShots == 17 and
  restoredPlayer.gameplay.powerCubes == 5 and
  restoredPlayer.respawn.cooperativeInventory[2] == 11,
  "private v18 restores complete item rule state")
restoreAssert(restoredPlayer.gameplay.inventory.counts[privateSaveShells.index] == 10,
  "dropped-item inventory persisted")
restoreAssert(restoredRuntime.bodyQueueIndex == 1 and
  restoredRuntime.bodyQueue[0].number == 5 and
  restoredRuntime.bodyQueue[0].inUse and
  api.edicts[5].state.frame == 166,
  "private v19 restores body queue ring and corpse state")
restoreAssert(restoredPlayer.persistent.gameHelpChanged == 4 and
  restoredPlayer.persistent.helpChanged == 2,
  "private v19 restores player help counters")
api.runFrame(); api.runFrame(); api.runFrame()
restoreAssert(restoredDoor.angles.y != savedDoorAngle, "restored mover continues simulation")
privateMedicResumeFrames = 0
while privateMedicResumeFrames < 24 and restoredPatient.health <= 0
  api.runFrame()
  privateMedicResumeFrames = privateMedicResumeFrames + 1
end while
restoreAssert(restoredPatient.health == 175 and restoredPatient.owner is void,
  "restored in-flight Medic cable completes resurrection")

api.shutdown()
removedSave = privateSaveDelete(savePath)
print "gameplay_private_save_restore_tests: PASS"
