/* Bounded SpawnEntities precache and snapshot model-index regression. */
import miniquake2.game.null_game as sppgameapi
import miniquake2.qcommon.constants as sppqconstants
import miniquake2.protocol.types as sppptypes
import miniquake2.server.game_bridge as sppbridge
import miniquake2.server.snapshot as sppsnapshot
import miniquake2.server.sound_events as sppsounds
import miniquake2.game.constants as sppgameconstants
import miniquake2.game.integration.baseq2 as sppintegration
import miniquake2.game.world.core as sppworld

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
  "{ \"classname\" \"monster_gunner\" \"origin\" \"160 0 8\" }\n" +
  "{ \"classname\" \"monster_jorg\" \"origin\" \"512 0 8\" }\n" +
  "{ \"classname\" \"func_door\" \"targetname\" \"sound_door\" \"origin\" \"256 0 0\" }\n" +
  "{ \"classname\" \"func_door_secret\" \"targetname\" \"secret_sound_door\" \"sounds\" \"1\" \"origin\" \"320 0 0\" }\n" +
  "{ \"classname\" \"target_speaker\" \"noise\" \"world/amb10\" \"spawnflags\" \"1\" \"volume\" \"0.4\" \"attenuation\" \"-1\" }\n" +
  "{ \"classname\" \"target_speaker\" \"noise\" \"misc/talk\" \"spawnflags\" \"4\" \"volume\" \"0.25\" \"attenuation\" \"3\" }\n" +
  "{ \"classname\" \"misc_teleporter\" \"target\" \"tele_dest\" \"origin\" \"384 0 0\" }\n" +
  "{ \"classname\" \"misc_teleporter_dest\" \"targetname\" \"tele_dest\" \"origin\" \"448 0 0\" }"

server = sppbridge.createRuntime(4)
api = sppgameapi.GetGameApi(sppbridge.makeImports(server))
server.game = api
api.init()
api.spawnEntities("base1", fixture, "")
runtime = sppgameapi.baseRuntime()

assertEqual(server.configStrings[sppqconstants.CS_MODELS + 1], "maps/base1.bsp", "reserved map model configstring")
assertTrue(server.configStrings[sppqconstants.CS_STATUSBAR] != "",
  "stock statusbar configstring")
assertEqual(api.edicts[0].state.modelIndex, 1, "world keeps reserved map model index")
machineModel = findName(server.modelNames, "models/weapons/g_machn/tris.md2")
soldierModel = findName(server.modelNames, "models/monsters/soldier/tris.md2")
gunnerModel = findName(server.modelNames, "models/monsters/gunner/tris.md2")
jorgRiderModel = findName(server.modelNames, "models/monsters/boss3/rider/tris.md2")
jorgChassisModel = findName(server.modelNames, "models/monsters/boss3/jorg/tris.md2")
assertTrue(machineModel > 1, "spawned item model precached")
assertTrue(soldierModel > 1, "active soldier model precached")
assertTrue(gunnerModel > 1, "active gunner model precached")
assertTrue(jorgRiderModel > 1 and jorgChassisModel > 1, "Jorg rider and chassis models precached")
assertEqual(server.configStrings[sppqconstants.CS_MODELS + machineModel], "models/weapons/g_machn/tris.md2", "item model configstring")
assertTrue(findName(server.soundNames, "weapons/blastf1a.wav") > 0, "default player weapon sound precached")
assertTrue(findName(server.soundNames, "soldier/solatck1.wav") > 0 and
  findName(server.soundNames, "gunner/gunatck1.wav") > 0,
  "spawned Soldier and Gunner stock sound inventories precached")
assertTrue(findName(server.soundNames, "boss3/xfire.wav") > 0 and
  findName(server.soundNames, "makron/rail_up.wav") > 0,
  "Jorg spawn also precaches its dynamic Makron successor sounds")
doorStartSound = findName(server.soundNames, "doors/dr1_strt.wav")
doorMiddleSound = findName(server.soundNames, "doors/dr1_mid.wav")
doorEndSound = findName(server.soundNames, "doors/dr1_end.wav")
speakerSound = findName(server.soundNames, "world/amb10.wav")
assertTrue(doorStartSound > 0 and doorMiddleSound > 0 and doorEndSound > 0,
  "stock door sound set precached")
assertTrue(speakerSound > 0, "target_speaker noise precached")
assertTrue(findName(server.imageNames, "w_machinegun") > 0, "spawned item image precached")
assertEqual(runtime.items[0].edict.state.modelIndex, machineModel, "item edict model index")
assertEqual(runtime.monsters[0].edict.state.modelIndex, soldierModel, "soldier edict model index")
assertEqual(runtime.monsters[1].edict.state.modelIndex, gunnerModel, "gunner edict model index")
assertEqual(runtime.monsters[2].edict.state.modelIndex, jorgRiderModel, "Jorg rider model index")
assertEqual(runtime.monsters[2].edict.state.modelIndex2, jorgChassisModel, "Jorg chassis model2 index")

client = sppgameapi.edictAt(1)
assertTrue(api.clientConnect(client, "\\name\\Ranger\\skin\\male/grunt"), "client connect")
assertTrue(api.clientBegin(client), "client begin")
api.runFrame()
player = sppgameapi.playerContext().players[0]
assertTrue(player.edict.state.modelIndex > 0, "player entity model index")
assertTrue(player.edict.client.playerState.gunIndex > 0, "player gun model index")
assertEqual(server.configStrings[sppqconstants.CS_MODELS + player.edict.client.playerState.gunIndex], "models/weapons/v_blast/tris.md2", "player gun configstring")

speaker = sppintegration.findWorldByClass(runtime, "target_speaker")
speakerEdict = api.edicts[speaker.number]
assertEqual(speaker.soundIndex, speakerSound,
  "target_speaker uses configstring sound index")
assertEqual(speakerEdict.state.sound, speakerSound,
  "target_speaker loop reaches engine EntityState.sound")
teleporter = sppintegration.findWorldByClass(runtime, "misc_teleporter")
assertEqual(teleporter.soundIndex, speakerSound,
  "teleporter ambient uses world/amb10 configstring index")
assertEqual(api.edicts[teleporter.number].state.sound, speakerSound,
  "teleporter ambient reaches engine EntityState.sound")
reliableSpeaker = void
for each worldEntity in runtime.world.entities
  if worldEntity.className == "target_speaker" and
      (worldEntity.spawnFlags & 4) != 0 then reliableSpeaker = worldEntity end if
end for
assertTrue(reliableSpeaker is not void, "reliable target_speaker fixture")
sppworld.useEntity(runtime.world, reliableSpeaker, reliableSpeaker,
  reliableSpeaker)
speakerEvents = sppsounds.pendingSnapshot(server)
reliableSpeakerEvent = speakerEvents[len(speakerEvents) - 1]
assertEqual(reliableSpeakerEvent.channelFlags,
  sppgameconstants.CHAN_VOICE | sppgameconstants.CHAN_RELIABLE,
  "target_speaker spawnflag 4 uses reliable voice channel")
assertEqual(reliableSpeakerEvent.volume, 0.25,
  "target_speaker authored volume reaches sound packet")
assertEqual(reliableSpeakerEvent.attenuation, 3.0,
  "target_speaker authored attenuation reaches sound packet")
door = sppintegration.findWorldByClass(runtime, "func_door")
assertEqual(door.soundIndex, doorMiddleSound, "door middle loop sound index")
sppworld.useEntity(runtime.world, door, door, door)
assertEqual(door.loopSound, doorMiddleSound, "opening door starts middle loop")
doorEvents = sppsounds.pendingSnapshot(server)
lastDoorEvent = doorEvents[len(doorEvents) - 1]
assertEqual(lastDoorEvent.soundIndex, doorStartSound,
  "opening door emits stock start sound")
assertEqual(lastDoorEvent.channelFlags,
  sppgameconstants.CHAN_NO_PHS_ADD | sppgameconstants.CHAN_VOICE,
  "door sound uses stock no-PHS voice channel")
assertEqual(lastDoorEvent.attenuation, sppgameconstants.ATTN_STATIC,
  "door sound uses stock static attenuation")
api.runFrame()
assertEqual(api.edicts[door.number].state.sound, doorMiddleSound,
  "door loop reaches engine EntityState.sound")
secretDoor = sppintegration.findWorldByClass(runtime, "func_door_secret")
assertEqual(secretDoor.soundIndex, doorMiddleSound,
  "secret door keeps unconditional stock middle sound")
sppworld.useEntity(runtime.world, secretDoor, secretDoor, secretDoor)
assertEqual(secretDoor.loopSound, doorMiddleSound,
  "secret door movement starts stock middle loop even with sounds 1")

entities = [
  protocolEntity(player.edict.state),
  protocolEntity(runtime.items[0].edict.state),
  protocolEntity(runtime.monsters[0].edict.state),
  protocolEntity(runtime.monsters[1].edict.state),
  protocolEntity(runtime.monsters[2].edict.state)
]
history = sppsnapshot.createHistory(4)
frame = sppsnapshot.addFrame(history, 1, bytes([]), sppptypes.zeroPlayerState(), entities)
assertTrue(frame.entities[0].modelIndex > 0, "snapshot player model index")
assertEqual(frame.entities[1].modelIndex, machineModel, "snapshot item model index")
assertEqual(frame.entities[2].modelIndex, soldierModel, "snapshot soldier model index")
assertEqual(frame.entities[3].modelIndex, gunnerModel, "snapshot gunner model index")
assertEqual(frame.entities[4].modelIndex, jorgRiderModel, "snapshot Jorg rider model index")
assertEqual(frame.entities[4].modelIndex2, jorgChassisModel, "snapshot Jorg chassis model2 index")

api.clientDisconnect(client)
api.shutdown()
print "MiniQuake2 Game API spawn precache tests passed: 2"
