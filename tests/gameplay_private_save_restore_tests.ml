/* Representative private World/Monster/Item/Player level-save restoration. */
import std.fs as privatesaveexistsfs
import std.fs as privatesavedeletefs
import miniquake2.server.game_bridge as privaterestorebridge
import miniquake2.game.null_game as privaterestoregame
import miniquake2.game.integration.baseq2 as privaterestoreintegration
import miniquake2.game.world.core as privaterestoreworld
import miniquake2.game.ai.constants as privaterestoreaiconstants

function restoreAssert(value, message)
  if value != true then return error(9897, message) end if
  return true
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
  "{\"classname\" \"monster_soldier\" \"origin\" \"80 0 0\"}"
api.spawnEntities("save-unit", fixture, "")
client = api.edicts[1]
api.clientConnect(client, "\\name\\Saver")
api.clientBegin(client)

runtime = privaterestoregame.baseRuntime()
context = privaterestoregame.playerContext()
door = privaterestoreintegration.findWorldByClass(runtime, "func_door_rotating")
linearDoor = privaterestoreintegration.findWorldByClass(runtime, "func_door")
privaterestoreworld.useEntity(runtime.world, door, void, door)
privaterestoreworld.useEntity(runtime.world, linearDoor, void, linearDoor)
api.runFrame()
savedDoorAngle = door.angles.y
savedDoorState = door.moveInfo.state
savedLinearDirectionX = linearDoor.moveInfo.direction.x
savedLinearRemaining = linearDoor.moveInfo.remainingDistance
runtime.world.totalSecrets = 4; runtime.world.foundSecrets = 3
monster = runtime.monsters[0]; monster.health = 41; monster.activity = "soldier-shotgun-attack2"; monster.edict.state.frame = 77
monster.attackCount = 7; monster.meleeCount = 2; monster.painCount = 3; monster.dieCount = 1
monster.info.nextFrame = 0; monster.info.pauseTime = runtime.world.time + 0.2
monster.info.attackState = privaterestoreaiconstants.AS_MISSILE
item = runtime.items[0]; item.hidden = true; item.nextThink = 12.5; item.count = 9
player = context.players[0]; player.health = 73; player.maxHealth = 125; player.gameplay.inventory.counts[2] = 17
player.powerups.quadFrame = 321; player.persistent.score = 6
api.writeLevel(savePath)

door.angles.y = 999.0; door.moveInfo.state = 99
runtime.world.foundSecrets = 0
monster.health = 1; monster.activity = "mutated"; monster.edict.state.frame = 1
monster.attackCount = 0; monster.meleeCount = 0; monster.painCount = 0; monster.dieCount = 0
monster.info.nextFrame = 99; monster.info.pauseTime = 999.0; monster.info.attackState = 0
item.hidden = false; item.nextThink = 0.0; item.count = 0
player.health = 1; player.gameplay.inventory.counts[2] = 0; player.powerups.quadFrame = 0; player.persistent.score = 0

api.readLevel(savePath)
restoredRuntime = privaterestoregame.baseRuntime()
restoredContext = privaterestoregame.playerContext()
restoredDoor = privaterestoreintegration.findWorldByClass(restoredRuntime, "func_door_rotating")
restoredLinearDoor = privaterestoreintegration.findWorldByClass(restoredRuntime, "func_door")
restoreAssert(restoredDoor.angles.y == savedDoorAngle and restoredDoor.moveInfo.state == savedDoorState, "mover transform/state restored")
restoreAssert(restoredDoor.think is not void, "mid-move callback rebound")
restoreAssert(typeof(restoredLinearDoor.moveInfo.direction) == "struct" and
  restoredLinearDoor.moveInfo.direction.x == savedLinearDirectionX and
  restoredLinearDoor.moveInfo.remainingDistance == savedLinearRemaining,
  "linear mover direction/distance restored")
restoreAssert(restoredRuntime.world.totalSecrets == 4 and restoredRuntime.world.foundSecrets == 3, "level counters restored")
restoreAssert(restoredRuntime.aiContext.skill == 2 and
  privaterestoregame.configuredGameSkill() == 2,
  "new game skill restored and retained for later maps")
restoredMonster = restoredRuntime.monsters[0]
restoreAssert(restoredMonster.health == 41 and restoredMonster.activity == "soldier-shotgun-attack2" and restoredMonster.edict.state.frame == 77, "monster private state restored")
restoreAssert(restoredMonster.attackCount == 7 and restoredMonster.meleeCount == 2 and
  restoredMonster.painCount == 3 and restoredMonster.dieCount == 1 and
  restoredMonster.info.nextFrame == 0 and restoredMonster.info.pauseTime > 0.29 and restoredMonster.info.pauseTime < 0.31 and
  restoredMonster.info.attackState == privaterestoreaiconstants.AS_MISSILE,
  "in-flight monster attack sequence restored")
restoreAssert(restoredRuntime.items[0].hidden and restoredRuntime.items[0].nextThink == 12.5 and restoredRuntime.items[0].count == 9, "item respawn state restored")
restoredPlayer = restoredContext.players[0]
restoreAssert(restoredPlayer.health == 73 and restoredPlayer.maxHealth == 125, "player health restored")
restoreAssert(restoredPlayer.gameplay.inventory.counts[2] == 17 and restoredPlayer.powerups.quadFrame == 321 and restoredPlayer.persistent.score == 6, "inventory/powerup/score restored")
api.runFrame(); api.runFrame(); api.runFrame()
restoreAssert(restoredDoor.angles.y != savedDoorAngle, "restored mover continues simulation")

api.shutdown()
removedSave = privateSaveDelete(savePath)
print "gameplay_private_save_restore_tests: PASS"
