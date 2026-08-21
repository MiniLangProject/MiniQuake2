/* Bounded SpawnEntities precache and snapshot model-index regression. */
import miniquake2.game.null_game as sppgameapi
import miniquake2.qcommon.constants as sppqconstants
import miniquake2.protocol.types as sppptypes
import miniquake2.server.game_bridge as sppbridge
import miniquake2.server.snapshot as sppsnapshot

function assertEqual(actual, expected, name)
  if actual != expected then return error(9985, name + ": values differ") end if
  return true
end function

function assertTrue(value, name)
  if value != true then return error(9986, name + ": expected true") end if
  return true
end function

function findName(values, name)
  index = 1
  while index < len(values)
    if values[index] == name then return index end if
    index = index + 1
  end while
  return 0
end function

function protocolEntity(state)
  return sppptypes.EntityState(
    state.number,
    [state.origin.x, state.origin.y, state.origin.z],
    [state.angles.x, state.angles.y, state.angles.z],
    [state.oldOrigin.x, state.oldOrigin.y, state.oldOrigin.z],
    state.modelIndex, state.modelIndex2, state.modelIndex3, state.modelIndex4,
    state.frame, state.skinNumber, state.effects, state.renderFx,
    state.solid, state.sound, state.event
  )
end function

fixture = "{ \"classname\" \"worldspawn\" }\n" +
  "{ \"classname\" \"info_player_start\" \"origin\" \"0 0 0\" }\n" +
  "{ \"classname\" \"weapon_machinegun\" \"origin\" \"48 0 8\" }\n" +
  "{ \"classname\" \"monster_soldier\" \"origin\" \"96 0 8\" }\n" +
  "{ \"classname\" \"monster_gunner\" \"origin\" \"160 0 8\" }"

server = sppbridge.createRuntime(4)
api = sppgameapi.GetGameApi(sppbridge.makeImports(server))
server.game = api
api.init()
api.spawnEntities("base1", fixture, "")
runtime = sppgameapi.baseRuntime()

assertEqual(server.configStrings[sppqconstants.CS_MODELS + 1], "maps/base1.bsp", "reserved map model configstring")
assertEqual(api.edicts[0].state.modelIndex, 1, "world keeps reserved map model index")
machineModel = findName(server.modelNames, "models/weapons/g_machn/tris.md2")
soldierModel = findName(server.modelNames, "models/monsters/soldier/tris.md2")
gunnerModel = findName(server.modelNames, "models/monsters/gunner/tris.md2")
assertTrue(machineModel > 1, "spawned item model precached")
assertTrue(soldierModel > 1, "active soldier model precached")
assertTrue(gunnerModel > 1, "active gunner model precached")
assertEqual(server.configStrings[sppqconstants.CS_MODELS + machineModel], "models/weapons/g_machn/tris.md2", "item model configstring")
assertTrue(findName(server.soundNames, "weapons/blastf1a.wav") > 0, "default player weapon sound precached")
assertTrue(findName(server.imageNames, "w_machinegun") > 0, "spawned item image precached")
assertEqual(runtime.items[0].edict.state.modelIndex, machineModel, "item edict model index")
assertEqual(runtime.monsters[0].edict.state.modelIndex, soldierModel, "soldier edict model index")
assertEqual(runtime.monsters[1].edict.state.modelIndex, gunnerModel, "gunner edict model index")

client = sppgameapi.edictAt(1)
assertTrue(api.clientConnect(client, "\\name\\Ranger\\skin\\male/grunt"), "client connect")
assertTrue(api.clientBegin(client), "client begin")
api.runFrame()
player = sppgameapi.playerContext().players[0]
assertTrue(player.edict.state.modelIndex > 0, "player entity model index")
assertTrue(player.edict.client.playerState.gunIndex > 0, "player gun model index")
assertEqual(server.configStrings[sppqconstants.CS_MODELS + player.edict.client.playerState.gunIndex], "models/weapons/v_blast/tris.md2", "player gun configstring")

entities = [
  protocolEntity(player.edict.state),
  protocolEntity(runtime.items[0].edict.state),
  protocolEntity(runtime.monsters[0].edict.state),
  protocolEntity(runtime.monsters[1].edict.state)
]
history = sppsnapshot.createHistory(4)
frame = sppsnapshot.addFrame(history, 1, bytes([]), sppptypes.zeroPlayerState(), entities)
assertTrue(frame.entities[0].modelIndex > 0, "snapshot player model index")
assertEqual(frame.entities[1].modelIndex, machineModel, "snapshot item model index")
assertEqual(frame.entities[2].modelIndex, soldierModel, "snapshot soldier model index")
assertEqual(frame.entities[3].modelIndex, gunnerModel, "snapshot gunner model index")

api.clientDisconnect(client)
api.shutdown()
print "MiniQuake2 Game API spawn precache tests passed: 2"
