/* Representative private World/Monster/Item/Player level-save restoration. */
import std.fs as privatesaveexistsfs
import std.fs as privatesavedeletefs
import miniquake2.server.game_bridge as privaterestorebridge
import miniquake2.game.null_game as privaterestoregame
import miniquake2.game.integration.baseq2 as privaterestoreintegration
import miniquake2.game.world.core as privaterestoreworld

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
monster = runtime.monsters[0]; monster.health = 41; monster.activity = "saved-pain"; monster.edict.state.frame = 77
item = runtime.items[0]; item.hidden = true; item.nextThink = 12.5; item.count = 9
player = context.players[0]; player.health = 73; player.maxHealth = 125; player.gameplay.inventory.counts[2] = 17
player.powerups.quadFrame = 321; player.persistent.score = 6
api.writeLevel(savePath)

door.angles.y = 999.0; door.moveInfo.state = 99
runtime.world.foundSecrets = 0
monster.health = 1; monster.activity = "mutated"; monster.edict.state.frame = 1
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
restoreAssert(restoredRuntime.monsters[0].health == 41 and restoredRuntime.monsters[0].activity == "saved-pain" and restoredRuntime.monsters[0].edict.state.frame == 77, "monster private state restored")
restoreAssert(restoredRuntime.items[0].hidden and restoredRuntime.items[0].nextThink == 12.5 and restoredRuntime.items[0].count == 9, "item respawn state restored")
restoredPlayer = restoredContext.players[0]
restoreAssert(restoredPlayer.health == 73 and restoredPlayer.maxHealth == 125, "player health restored")
restoreAssert(restoredPlayer.gameplay.inventory.counts[2] == 17 and restoredPlayer.powerups.quadFrame == 321 and restoredPlayer.persistent.score == 6, "inventory/powerup/score restored")
api.runFrame(); api.runFrame(); api.runFrame()
restoreAssert(restoredDoor.angles.y != savedDoorAngle, "restored mover continues simulation")

api.shutdown()
removedSave = privateSaveDelete(savePath)
print "gameplay_private_save_restore_tests: PASS"
