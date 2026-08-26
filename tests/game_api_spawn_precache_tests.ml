/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
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
import miniquake2.game.weapons.constants as sppweaponconstants
import miniquake2.game.gameplay.constants as sppgameplayconstants

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

fixture = "{ \"classname\" \"worldspawn\" \"sounds\" \"7\" }\n" +
  "{ \"classname\" \"info_player_start\" \"origin\" \"0 0 0\" }\n" +
  "{ \"classname\" \"weapon_machinegun\" \"origin\" \"48 0 8\" }\n" +
  "{ \"classname\" \"ammo_shells\" \"origin\" \"80 256 64\" \"target\" \"item_help\" }\n" +
  "{ \"classname\" \"target_help\" \"targetname\" \"item_help\" \"message\" \"Item target fired\" }\n" +
  "{ \"classname\" \"key_power_cube\" \"origin\" \"128 256 64\" \"targetname\" \"reveal_item\" \"spawnflags\" \"3\" }\n" +
  "{ \"classname\" \"trigger_relay\" \"targetname\" \"reveal_switch\" \"target\" \"reveal_item\" }\n" +
  "{ \"classname\" \"item_armor_body\" \"origin\" \"176 256 64\" \"spawnflags\" \"2\" }\n" +
  "{ \"classname\" \"weapon_bfg\" \"origin\" \"224 256 64\" \"team\" \"weapon_cycle\" }\n" +
  "{ \"classname\" \"weapon_hyperblaster\" \"origin\" \"272 256 64\" \"team\" \"weapon_cycle\" }\n" +
  "{ \"classname\" \"item_quad\" \"origin\" \"320 256 64\" }\n" +
  "{ \"classname\" \"monster_soldier\" \"origin\" \"96 0 8\" }\n" +
  "{ \"classname\" \"monster_gunner\" \"origin\" \"160 0 8\" }\n" +
  "{ \"classname\" \"monster_jorg\" \"origin\" \"512 0 8\" }\n" +
  "{ \"classname\" \"monster_flyer\" \"origin\" \"576 0 8\" }\n" +
  "{ \"classname\" \"monster_floater\" \"origin\" \"640 0 8\" }\n" +
  "{ \"classname\" \"monster_hover\" \"origin\" \"704 0 8\" }\n" +
  "{ \"classname\" \"monster_boss2\" \"origin\" \"768 0 8\" }\n" +
  "{ \"classname\" \"func_door\" \"targetname\" \"sound_door\" \"origin\" \"256 0 0\" }\n" +
  "{ \"classname\" \"func_door_secret\" \"targetname\" \"secret_sound_door\" \"sounds\" \"1\" \"origin\" \"320 0 0\" }\n" +
  "{ \"classname\" \"func_water\" \"targetname\" \"sound_water\" \"sounds\" \"1\" \"origin\" \"352 0 0\" }\n" +
  "{ \"classname\" \"target_speaker\" \"noise\" \"world/amb10\" \"spawnflags\" \"1\" \"volume\" \"0.4\" \"attenuation\" \"-1\" }\n" +
  "{ \"classname\" \"target_speaker\" \"noise\" \"misc/talk\" \"spawnflags\" \"4\" \"volume\" \"0.25\" \"attenuation\" \"3\" }\n" +
  "{ \"classname\" \"target_laser\" \"origin\" \"1024 1024 1024\" \"angle\" \"0\" \"spawnflags\" \"66\" }\n" +
  "{ \"classname\" \"target_earthquake\" \"targetname\" \"quake_test\" }\n" +
  "{ \"classname\" \"target_blaster\" \"origin\" \"2048 2048 2048\" \"angle\" \"90\" }\n" +
  "{ \"classname\" \"target_explosion\" \"targetname\" \"wire_boom\" \"origin\" \"32 64 96\" }\n" +
  "{ \"classname\" \"target_splash\" \"targetname\" \"wire_splash\" \"origin\" \"40 72 104\" \"angle\" \"90\" \"count\" \"7\" \"sounds\" \"4\" }\n" +
  "{ \"classname\" \"target_spawner\" \"target\" \"monster_soldier\" \"origin\" \"3000 3000 3000\" \"angle\" \"180\" }\n" +
  "{ \"classname\" \"target_spawner\" \"target\" \"item_adrenaline\" \"origin\" \"3100 3000 3000\" }\n" +
  "{ \"classname\" \"target_spawner\" \"target\" \"misc_gib_arm\" \"origin\" \"3200 3000 3000\" \"angle\" \"90\" \"speed\" \"80\" }\n" +
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
assertEqual(server.configStrings[sppqconstants.CS_CDTRACK], "7",
  "worldspawn music track configstring")
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
quakeSound = findName(server.soundNames, "world/quake.wav")
assertTrue(quakeSound > 0, "target_earthquake sound precached")
assertTrue(findName(server.imageNames, "w_machinegun") > 0, "spawned item image precached")
assertEqual(runtime.items[0].edict.state.modelIndex, machineModel, "item edict model index")
assertEqual(runtime.monsters[0].edict.state.modelIndex, soldierModel, "soldier edict model index")
assertEqual(runtime.monsters[1].edict.state.modelIndex, gunnerModel, "gunner edict model index")
assertEqual(runtime.monsters[2].edict.state.modelIndex, jorgRiderModel, "Jorg rider model index")
assertEqual(runtime.monsters[2].edict.state.modelIndex2, jorgChassisModel, "Jorg chassis model2 index")
flyerLoop = findName(server.soundNames, "flyer/flyidle1.wav")
floaterLoop = findName(server.soundNames, "floater/fltsrch1.wav")
hoverLoop = findName(server.soundNames, "hover/hovidle1.wav")
boss2Loop = findName(server.soundNames, "bosshovr/bhvengn1.wav")
assertTrue(flyerLoop > 0 and floaterLoop > 0 and hoverLoop > 0 and boss2Loop > 0,
  "stock persistent monster loops precached")
assertEqual(runtime.monsters[3].edict.state.sound, flyerLoop,
  "Flyer spawn publishes engine loop")
assertEqual(runtime.monsters[4].edict.state.sound, floaterLoop,
  "Floater spawn publishes engine loop")
assertEqual(runtime.monsters[5].edict.state.sound, hoverLoop,
  "Hover spawn publishes engine loop")
assertEqual(runtime.monsters[6].edict.state.sound, boss2Loop,
  "Boss2 spawn publishes engine loop")

client = sppgameapi.edictAt(1)
assertTrue(api.clientConnect(client, "\\name\\Ranger\\skin\\male/grunt"), "client connect")
assertTrue(api.clientBegin(client), "client begin")
api.runFrame()
player = sppgameapi.playerContext().players[0]
assertTrue(player.edict.state.modelIndex > 0, "player entity model index")
assertTrue(player.edict.client.playerState.gunIndex > 0, "player gun model index")
assertEqual(server.configStrings[sppqconstants.CS_MODELS + player.edict.client.playerState.gunIndex], "models/weapons/v_blast/tris.md2", "player gun configstring")
assertEqual(api.edicts[runtime.monsters[3].edict.state.number].state.sound,
  flyerLoop, "live Flyer edict keeps engine loop")
assertEqual(api.edicts[runtime.monsters[4].edict.state.number].state.sound,
  floaterLoop, "live Floater edict keeps engine loop")
assertEqual(api.edicts[runtime.monsters[5].edict.state.number].state.sound,
  hoverLoop, "live Hover edict keeps engine loop")
assertEqual(api.edicts[runtime.monsters[6].edict.state.number].state.sound,
  boss2Loop, "live Boss2 edict keeps engine loop")

// SpawnItem waits two frames for BSP solids, then droptofloor plants the
// item, applies render flags and initializes authored item modes/teams.
sppgameapi.playerContext().cooperative = true
api.runFrame()
api.runFrame()
machineItem = sppintegration.findItemByClass(runtime, "weapon_machinegun")
assertEqual(machineItem.edict.state.origin.z, -120.0,
  "droptofloor traces stock 128 units")
assertTrue(machineItem.edict.solid == sppgameconstants.SOLID_TRIGGER and
  (machineItem.edict.state.effects & sppgameconstants.EF_ROTATE) != 0 and
  (machineItem.edict.state.renderFx & sppgameconstants.RF_GLOW) != 0,
  "ordinary item trigger/rotate/glow initialization")
noTouchItem = sppintegration.findItemByClass(runtime, "item_armor_body")
assertTrue(noTouchItem.spawnFlags == 0 and
  noTouchItem.edict.solid == sppgameconstants.SOLID_TRIGGER and
  (noTouchItem.edict.state.effects & sppgameconstants.EF_ROTATE) != 0 and
  (noTouchItem.edict.state.renderFx & sppgameconstants.RF_GLOW) != 0,
  "SpawnItem clears invalid non-cube item flags")
triggerItem = sppintegration.findItemByClass(runtime, "key_power_cube")
assertTrue(triggerItem.hidden and
  triggerItem.edict.solid == sppgameconstants.SOLID_NOT and
  (triggerItem.spawnFlags & 0x0000ff00) == 0x00000100,
  "power-cube ITEM_TRIGGER_SPAWN starts hidden")
revealRelay = sppintegration.findWorldByClass(runtime, "trigger_relay")
sppworld.useEntity(runtime.world, revealRelay, revealRelay, player)
assertTrue(not triggerItem.hidden and
  triggerItem.edict.solid == sppgameconstants.SOLID_BBOX and
  (triggerItem.edict.state.effects & sppgameconstants.EF_ROTATE) == 0 and
  (triggerItem.edict.state.renderFx & sppgameconstants.RF_GLOW) == 0,
  "power-cube trigger use preserves ITEM_NO_TOUCH bbox mode")
sppgameapi.playerContext().cooperative = false
teamBfg = sppintegration.findItemByClass(runtime, "weapon_bfg")
teamHyper = sppintegration.findItemByClass(runtime, "weapon_hyperblaster")
teamVisible = 0
if not teamBfg.hidden then teamVisible = teamVisible + 1 end if
if not teamHyper.hidden then teamVisible = teamVisible + 1 end if
assertEqual(teamVisible, 1, "item team exposes exactly one random member")

skillQuad = sppintegration.findItemByClass(runtime, "item_quad")
runtime.aiContext.skill = 3
player.gameplay.inventory.counts[skillQuad.item.index] = 1
skillQuadPickup = sppintegration.touchItem(runtime, skillQuad, player,
  sppgameapi.playerContext())
assertTrue(not skillQuadPickup.success and
  player.gameplay.inventory.counts[skillQuad.item.index] == 1,
  "live pickup path forwards skill-3 powerup cap")
runtime.aiContext.skill = 1

targetShells = sppintegration.findItemByClass(runtime, "ammo_shells")
player.gameplay.inventory.counts[targetShells.item.index] = player.gameplay.inventory.maxShells
itemHelpBefore = runtime.world.helpChanged
rejectedPickup = sppintegration.touchItem(runtime, targetShells, player,
  sppgameapi.playerContext())
assertTrue(not rejectedPickup.success and
  runtime.world.helpMessage2 == "Item target fired" and
  runtime.world.helpChanged == itemHelpBefore + 1 and
  (targetShells.spawnFlags &
    sppgameplayconstants.ITEM_TARGETS_USED) != 0,
  "rejected pickup still fires item targets exactly once")

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

earthquake = sppintegration.findWorldByClass(runtime, "target_earthquake")
player.groundEntity = api.edicts[0]
player.velocity = [0.0, 0.0, 0.0]
sppworld.useEntity(runtime.world, earthquake, earthquake, player)
sppworld.advance(runtime.world, runtime.world.time + 0.1)
assertTrue(player.groundEntity is void,
  "target_earthquake clears grounded player")
assertEqual(player.velocity[2], 100.0,
  "target_earthquake applies stock mass-200 vertical speed")
quakeEvents = sppsounds.pendingSnapshot(server)
quakeEvent = quakeEvents[len(quakeEvents) - 1]
assertEqual(quakeEvent.soundIndex, quakeSound,
  "target_earthquake emits stock sound")
assertEqual(quakeEvent.attenuation, sppgameconstants.ATTN_NONE,
  "target_earthquake sound is level-wide")

laser = sppintegration.findWorldByClass(runtime, "target_laser")
sppworld.advance(runtime.world, 1.0)
assertEqual(laser.modelIndex, 1, "target_laser delayed beam initialization")
player.edict.state.origin.x = 1100.0
player.edict.state.origin.y = 1024.0
player.edict.state.origin.z = 1024.0
laserHealthBefore = player.health
sppworld.useEntity(runtime.world, laser, laser, player)
assertEqual(player.health, laserHealthBefore - 1,
  "target_laser integrated trace damages player")
sppintegration.syncGameEdicts(runtime, api)
laserEdict = api.edicts[laser.number]
assertTrue((laserEdict.state.renderFx & sppgameconstants.RF_BEAM) != 0,
  "target_laser RF_BEAM reaches engine EntityState")
assertTrue((laserEdict.state.renderFx & sppgameconstants.RF_TRANSLUCENT) != 0,
  "target_laser translucency reaches engine EntityState")
assertEqual(laserEdict.state.frame, 16,
  "target_laser fat width reaches engine EntityState")
assertEqual(laserEdict.state.skinNumber, 0xf2f2f0f0,
  "target_laser packed color reaches engine EntityState")
assertEqual(laserEdict.state.oldOrigin.x, 3072.0,
  "target_laser beam endpoint reaches engine EntityState")

targetBlaster = sppintegration.findWorldByClass(runtime, "target_blaster")
projectileCountBefore = len(runtime.weaponContext.projectiles)
sppworld.useEntity(runtime.world, targetBlaster, targetBlaster, player)
assertEqual(len(runtime.weaponContext.projectiles), projectileCountBefore + 1,
  "target_blaster spawns a managed bolt")
targetBolt = runtime.weaponContext.projectiles[len(runtime.weaponContext.projectiles) - 1]
assertEqual(targetBolt.className, "bolt", "target_blaster projectile class")
assertTrue((targetBolt.spawnFlags & 2) != 0,
  "target_blaster projectile carries distinct means-of-death marker")
targetBlasterEvents = sppsounds.pendingSnapshot(server)
targetBlasterSound = targetBlasterEvents[len(targetBlasterEvents) - 1]
assertEqual(targetBlasterSound.channelFlags, sppgameconstants.CHAN_VOICE,
  "target_blaster sound uses stock voice channel")

targetExplosion = sppintegration.findWorldByClass(runtime,
  "target_explosion")
targetSplash = sppintegration.findWorldByClass(runtime, "target_splash")
targetTempBefore = len(server.pendingMulticasts)
sppworld.useEntity(runtime.world, targetExplosion, targetExplosion, player)
assertEqual(len(server.pendingMulticasts), targetTempBefore + 1,
  "target_explosion queues a live temp entity")
targetExplosionWire = server.pendingMulticasts[targetTempBefore]
assertEqual(targetExplosionWire.destination, sppgameconstants.MULTICAST_PHS,
  "target_explosion multicast scope")
assertTrue(len(targetExplosionWire.payload) == 8 and
  targetExplosionWire.payload[0] == sppqconstants.SVC_TEMP_ENTITY and
  targetExplosionWire.payload[1] == sppweaponconstants.TE_EXPLOSION1,
  "target_explosion wire framing")
sppworld.useEntity(runtime.world, targetSplash, targetSplash, player)
targetSplashWire = server.pendingMulticasts[targetTempBefore + 1]
assertEqual(targetSplashWire.destination, sppgameconstants.MULTICAST_PVS,
  "target_splash multicast scope")
assertTrue(len(targetSplashWire.payload) == 11 and
  targetSplashWire.payload[0] == sppqconstants.SVC_TEMP_ENTITY and
  targetSplashWire.payload[1] == sppweaponconstants.TE_SPLASH and
  targetSplashWire.payload[2] == 7 and
  targetSplashWire.payload[10] == 4,
  "target_splash count/direction/color wire framing")

monsterSpawner = void
itemSpawner = void
gibSpawner = void
for each spawnProbe in runtime.world.entities
  if spawnProbe.className == "target_spawner" then
    if spawnProbe.target == "monster_soldier" then monsterSpawner = spawnProbe
    else if spawnProbe.target == "item_adrenaline" then itemSpawner = spawnProbe
    else if spawnProbe.target == "misc_gib_arm" then gibSpawner = spawnProbe
    end if
  end if
end for
assertTrue(monsterSpawner is not void and itemSpawner is not void and
  gibSpawner is not void, "target_spawner fixtures")
monsterCountBefore = len(runtime.monsters)
sppworld.useEntity(runtime.world, monsterSpawner, monsterSpawner, player)
assertEqual(len(runtime.monsters), monsterCountBefore + 1,
  "target_spawner creates registered monster")
spawnedMonster = runtime.monsters[len(runtime.monsters) - 1]
assertEqual(spawnedMonster.edict.state.origin.x, 3000.0,
  "target_spawner monster origin")
assertTrue(spawnedMonster.edict.state.modelIndex > 0,
  "target_spawner monster linked model")

itemCountBefore = len(runtime.items)
sppworld.useEntity(runtime.world, itemSpawner, itemSpawner, player)
assertEqual(len(runtime.items), itemCountBefore + 1,
  "target_spawner creates registered item")
spawnedItem = runtime.items[len(runtime.items) - 1]
assertEqual(spawnedItem.item.className, "item_adrenaline",
  "target_spawner item definition")
assertTrue(spawnedItem.edict.state.modelIndex > 0,
  "target_spawner item linked model")

worldCountBefore = len(runtime.world.entities)
sppworld.useEntity(runtime.world, gibSpawner, gibSpawner, player)
assertEqual(len(runtime.world.entities), worldCountBefore + 1,
  "target_spawner creates stock gib")
spawnedGib = runtime.world.entities[len(runtime.world.entities) - 1]
assertEqual(spawnedGib.className, "misc_gib_arm",
  "target_spawner gib class")
assertTrue(spawnedGib.modelIndex > 0, "target_spawner gib linked model")
gibStartY = spawnedGib.origin.y
gibStartZ = spawnedGib.origin.z
sppintegration.runFrame(runtime)
assertTrue(spawnedGib.origin.y > gibStartY,
  "target_spawner speed drives gib toss")
assertTrue(spawnedGib.origin.z < gibStartZ,
  "spawned gib receives toss gravity")
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
water = sppintegration.findWorldByClass(runtime, "func_water")
waterSoundBefore = len(sppsounds.pendingSnapshot(server))
sppworld.useEntity(runtime.world, water, water, water)
waterEvents = sppsounds.pendingSnapshot(server)
waterEvent = waterEvents[waterSoundBefore]
assertEqual(waterEvent.channelFlags,
  sppgameconstants.CHAN_NO_PHS_ADD | sppgameconstants.CHAN_VOICE,
  "func_water sound uses stock no-PHS voice channel")
assertEqual(waterEvent.attenuation, sppgameconstants.ATTN_STATIC,
  "func_water sound uses stock static attenuation")

entities = [
  protocolEntity(player.edict.state),
  protocolEntity(runtime.items[0].edict.state),
  protocolEntity(runtime.monsters[0].edict.state),
  protocolEntity(runtime.monsters[1].edict.state),
  protocolEntity(runtime.monsters[2].edict.state),
  protocolEntity(runtime.monsters[3].edict.state),
  protocolEntity(runtime.monsters[4].edict.state),
  protocolEntity(runtime.monsters[5].edict.state),
  protocolEntity(runtime.monsters[6].edict.state),
  protocolEntity(laserEdict.state)
]
history = sppsnapshot.createHistory(4)
frame = sppsnapshot.addFrame(history, 1, bytes([]), sppptypes.zeroPlayerState(), entities)
assertTrue(frame.entities[0].modelIndex > 0, "snapshot player model index")
assertEqual(frame.entities[1].modelIndex, machineModel, "snapshot item model index")
assertEqual(frame.entities[2].modelIndex, soldierModel, "snapshot soldier model index")
assertEqual(frame.entities[3].modelIndex, gunnerModel, "snapshot gunner model index")
assertEqual(frame.entities[4].modelIndex, jorgRiderModel, "snapshot Jorg rider model index")
assertEqual(frame.entities[4].modelIndex2, jorgChassisModel, "snapshot Jorg chassis model2 index")
assertEqual(frame.entities[5].sound, flyerLoop, "snapshot Flyer engine loop")
assertEqual(frame.entities[6].sound, floaterLoop, "snapshot Floater engine loop")
assertEqual(frame.entities[7].sound, hoverLoop, "snapshot Hover engine loop")
assertEqual(frame.entities[8].sound, boss2Loop, "snapshot Boss2 engine loop")
assertTrue((frame.entities[9].renderFx & sppgameconstants.RF_BEAM) != 0,
  "snapshot preserves target_laser beam render flag")
assertEqual(frame.entities[9].skinNum, 0xf2f2f0f0,
  "snapshot preserves target_laser color")

api.clientDisconnect(client)
api.shutdown()
print "MiniQuake2 Game API spawn precache tests passed: 2"
