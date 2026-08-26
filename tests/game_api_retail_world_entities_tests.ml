/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Game-API integration of the formerly skipped base1 world entities. */
import miniquake2.game.constants as rwigameconstants
import miniquake2.game.integration.baseq2 as rwiintegration
import miniquake2.game.null_game as rwigameapi
import miniquake2.game.world.core as rwiworld
import miniquake2.protocol.types as rwiptypes
import miniquake2.qcommon.constants as rwiqconstants
import miniquake2.qcommon.types as rwiqtypes
import miniquake2.server.game_bridge as rwibridge
import miniquake2.server.snapshot as rwisnapshot

function assertEqual(actual, expected, name)
  if actual != expected then return error(9993, name + ": values differ") end if
  return true
end function

function assertTrue(value, name)
  if value != true then return error(9994, name + ": expected true") end if
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
  return rwiptypes.EntityState(
    state.number,
    [state.origin.x, state.origin.y, state.origin.z],
    [state.angles.x, state.angles.y, state.angles.z],
    [state.oldOrigin.x, state.oldOrigin.y, state.oldOrigin.z],
    state.modelIndex, state.modelIndex2, state.modelIndex3, state.modelIndex4,
    state.frame, state.skinNumber, state.effects, state.renderFx,
    state.solid, state.sound, state.event
  )
end function

function command(buttons)
  return rwiqtypes.UserCmd(0, buttons, [0, 0, 0], 0, 0, 0, 0, 64)
end function

fixture = "{ \"classname\" \"worldspawn\" }\n" +
  "{ \"classname\" \"info_player_start\" \"origin\" \"0 0 0\" }\n" +
  "{ \"classname\" \"misc_explobox\" \"origin\" \"80 0 0\" }\n" +
  "{ \"classname\" \"func_wall\" \"model\" \"*1\" \"origin\" \"300 0 0\" \"spawnflags\" \"3\" }\n" +
  "{ \"classname\" \"func_rotating\" \"model\" \"*2\" \"origin\" \"400 0 0\" \"spawnflags\" \"1\" \"speed\" \"90\" }\n" +
  "{ \"classname\" \"misc_banner\" \"origin\" \"500 0 0\" }\n" +
  "{ \"classname\" \"misc_deadsoldier\" \"origin\" \"600 0 0\" }\n" +
  "{ \"classname\" \"misc_strogg_ship\" \"origin\" \"700 0 0\" \"target\" \"ship_route\" \"targetname\" \"ship_trigger\" }\n" +
  "{ \"classname\" \"path_corner\" \"origin\" \"720 0 0\" \"targetname\" \"ship_route\" }\n" +
  "{ \"classname\" \"misc_gib_head\" \"origin\" \"800 0 0\" }\n" +
  "{ \"classname\" \"light\" \"origin\" \"900 0 0\" }\n" +
  "{ \"classname\" \"func_group\" \"model\" \"*3\" }"

server = rwibridge.createRuntime(4)
api = rwigameapi.GetGameApi(rwibridge.makeImports(server))
server.game = api
api.init()
api.spawnEntities("base1", fixture, "")
runtime = rwigameapi.baseRuntime()
assertEqual(rwigameapi.spawnResult().skippedEntityCount, 0, "retail world skipped count")
assertEqual(len(rwigameapi.spawnResult().skippedClasses), 0, "retail world skipped aggregate")

barrel = rwiintegration.findWorldByClass(runtime, "misc_explobox")
wall = rwiintegration.findWorldByClass(runtime, "func_wall")
rotating = rwiintegration.findWorldByClass(runtime, "func_rotating")
banner = rwiintegration.findWorldByClass(runtime, "misc_banner")
corpse = rwiintegration.findWorldByClass(runtime, "misc_deadsoldier")
ship = rwiintegration.findWorldByClass(runtime, "misc_strogg_ship")
gib = rwiintegration.findWorldByClass(runtime, "misc_gib_head")
assertTrue(barrel is not void and wall is not void and rotating is not void, "functional retail world entities")
assertTrue(banner is not void and corpse is not void and ship is not void and gib is not void, "decorative retail world entities")
assertTrue(rwiintegration.findWorldByClass(runtime, "light") is void, "untargeted light consumed")
assertTrue(rwiintegration.findWorldByClass(runtime, "func_group") is void, "func_group consumed")

barrelModel = findName(server.modelNames, "models/objects/barrels/tris.md2")
wallModel = findName(server.modelNames, "*1")
rotatingModel = findName(server.modelNames, "*2")
bannerModel = findName(server.modelNames, "models/objects/banner/tris.md2")
corpseModel = findName(server.modelNames, "models/deadbods/dude/tris.md2")
shipModel = findName(server.modelNames, "models/ships/strogg1/tris.md2")
gibModel = findName(server.modelNames, "models/objects/gibs/head/tris.md2")
assertTrue(barrelModel > 0 and wallModel > 0 and rotatingModel > 0, "functional models precached")
assertTrue(bannerModel > 0 and corpseModel > 0 and shipModel > 0 and gibModel > 0, "decorative models precached")
assertTrue(findName(server.modelNames, "models/objects/debris3/tris.md2") > 0, "barrel debris precached")
assertTrue(findName(server.soundNames, "tank/pain.wav") > 0, "barrel sound precached")
assertTrue(findName(server.soundNames, "misc/udeath.wav") > 0, "dead soldier sound precached")
assertEqual(api.edicts[barrel.number].state.modelIndex, barrelModel, "barrel snapshot model index")
assertEqual(api.edicts[wall.number].state.modelIndex, wallModel, "wall snapshot model index")
assertEqual(api.edicts[rotating.number].state.modelIndex, rotatingModel, "rotating snapshot model index")
assertEqual(api.edicts[banner.number].state.modelIndex, bannerModel, "banner snapshot model index")
assertEqual(api.edicts[corpse.number].state.modelIndex, corpseModel, "corpse snapshot model index")
assertEqual(api.edicts[ship.number].state.modelIndex, shipModel, "ship model index while hidden")
assertEqual(api.edicts[gib.number].state.modelIndex, gibModel, "gib snapshot model index")

snapshotEntities = [
  protocolEntity(api.edicts[barrel.number].state),
  protocolEntity(api.edicts[wall.number].state),
  protocolEntity(api.edicts[rotating.number].state),
  protocolEntity(api.edicts[banner.number].state),
  protocolEntity(api.edicts[corpse.number].state),
  protocolEntity(api.edicts[ship.number].state),
  protocolEntity(api.edicts[gib.number].state)
]
history = rwisnapshot.createHistory(4)
snapshot = rwisnapshot.addFrame(history, 1, bytes([]), rwiptypes.zeroPlayerState(), snapshotEntities)
for each state in snapshot.entities
  assertTrue(state.modelIndex > 0, "retail snapshot retains model index")
end for

rwiworld.useEntity(runtime.world, wall, void, void)
rwiworld.useEntity(runtime.world, ship, void, void)
api.runFrame()
assertEqual(api.edicts[wall.number].solid, rwigameconstants.SOLID_BSP, "wall use synced solid")
assertTrue((api.edicts[ship.number].serverFlags & rwigameconstants.SVF_NOCLIENT) == 0, "ship use synced visibility")
assertTrue(api.edicts[rotating.number].state.angles.y > 0.0, "rotating think/integration angle")

client = rwigameapi.edictAt(1)
assertTrue(api.clientConnect(client, "\\name\\Ranger\\skin\\male/grunt"), "client connect")
assertTrue(api.clientBegin(client), "client begin")
frame = 0
while frame < 5
  api.runFrame()
  frame = frame + 1
end while
api.clientThink(client, command(rwigameconstants.BUTTON_ATTACK))
api.clientThink(client, command(0))
api.runFrame()
assertTrue(barrel.health <= 0, "player projectile damages barrel")
assertTrue(barrel.inUse, "barrel uses delayed explosion think")
api.runFrame()
api.runFrame()
assertTrue(barrel.inUse == false, "barrel explosion lifecycle completed")
assertTrue(api.edicts[barrel.number].inUse == false, "barrel free synced to Game API")

api.clientDisconnect(client)
api.shutdown()
print "MiniQuake2 Game API retail world entity tests passed: 3"
