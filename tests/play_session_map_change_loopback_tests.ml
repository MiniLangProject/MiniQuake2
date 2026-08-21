/* Real UDP same-Netchan map change and complete Protocol-34 re-signon. */
import miniquake2.qcommon.constants as plmap_qc
import miniquake2.qcommon.sizebuf as plmap_qsz
import miniquake2.protocol.netchan as plmap_netchan
import miniquake2.network.constants as plmap_nc
import miniquake2.runtime.play_session as plmap_session

function playMapAssert(value, name)
  if not value then return error(8490, name) end if
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

oldEntities = "{\n\"classname\" \"worldspawn\"\n\"message\" \"Old Map\"\n}\n" +
  "{\n\"classname\" \"info_player_start\"\n\"origin\" \"0 0 24\"\n}\n" +
  "{\n\"classname\" \"monster_soldier\"\n\"origin\" \"64 0 24\"\n}\n"
newEntities = "{\n\"classname\" \"worldspawn\"\n\"message\" \"New Map\"\n}\n" +
  "{\n\"classname\" \"info_player_start\"\n\"origin\" \"128 0 24\"\n}\n"

session = plmap_session.createCore("map_old", oldEntities, void,
  "\\name\\MapLoop\\rate\\25000")
plmap_session.runUntilActive(session, 500)
playMapAssert(plmap_session.signonComplete(session), "old map signon failed")

// Finish any last signon reliable ACK before constructing deterministic
// staging-backpressure and sequence assertions.
serverChannel = session.server.networkRuntime.server.clients[0].channel
attempt = 0
while plmap_netchan.pendingReliableBytes(serverChannel) != 0 and attempt < 100
  plmap_session.step(session)
  attempt = attempt + 1
end while
playMapAssert(plmap_netchan.pendingReliableBytes(serverChannel) == 0,
  "old signon Netchan did not settle")
while plmap_session.takeFrame(session) is not void
end while

soldierName = "models/monsters/soldier/tris.md2"
soldierIndex = findName(session.server.bridgeRuntime.modelNames, soldierName)
playMapAssert(soldierIndex > 1 and
  session.client.integrated.network.configStrings[plmap_qc.CS_MODELS + soldierIndex] == soldierName,
  "old-map-only model did not reach the client")
playMapAssert(session.client.integrated.network.baselines[3].modelIndex == soldierIndex,
  "old monster baseline missing before transition")

oldSpawn = session.server.networkRuntime.spawnCount
oldFrame = session.server.frameNumber
oldClientFrame = session.client.integrated.client.current.number
oldServerOutgoing = serverChannel.outgoingSequence
oldClientChannel = session.client.integrated.network.client.channel
oldClientIncoming = oldClientChannel.incomingSequence

// Malformed entity text is rejected before any bridge, gameplay, network or
// sequence mutation.
playMapAssert(try(plmap_session.changeMapCore(session, "broken", "{", void)) is error,
  "malformed map transition was accepted")
playMapAssert(session.server.mapName == "map_old" and session.server.frameNumber == oldFrame and
  session.server.networkRuntime.spawnCount == oldSpawn and
  session.server.networkRuntime.server.clients[0].state == plmap_nc.CS_SPAWNED and
  serverChannel.outgoingSequence == oldServerOutgoing,
  "malformed map transition partially mutated the session")

// A full reliable staging buffer defers the whole switch.  No map/game/reset
// mutation occurs until capacity is available.
plmap_qsz.writeBytes(serverChannel.message,
  bytes(serverChannel.message.maxSize - serverChannel.message.curSize))
deferred = plmap_session.changeMapCore(session, "map_new", newEntities, void)
playMapAssert(not deferred.changed and deferred.deferred and deferred.spawnCount == oldSpawn and
  session.server.mapName == "map_old" and session.server.frameNumber == oldFrame and
  session.server.networkRuntime.server.clients[0].state == plmap_nc.CS_SPAWNED,
  "reliable backpressure partially committed the map transition")
plmap_qsz.clear(serverChannel.message)

// Pending UI input belongs to the old world and must not cross the generation.
pending = session.client.lastCommand
pending.msec = 77
session.client.lastCommand = pending
change = plmap_session.changeMapCore(session, "map_new", newEntities, void)
playMapAssert(change.changed and not change.deferred and change.spawnCount == oldSpawn + 1,
  "valid map transition did not commit")
playMapAssert(session.server.mapName == "map_new" and session.server.frameNumber == 0 and
  session.server.networkRuntime.server.clients[0].state == plmap_nc.CS_CONNECTED,
  "server did not enter new-map connected signon state")
playMapAssert(nativeRawValue(serverChannel) == nativeRawValue(
  session.server.networkRuntime.server.clients[0].channel) and
  serverChannel.outgoingSequence == oldServerOutgoing and serverChannel.message.curSize > 0,
  "server reset or prematurely transmitted the preserved Netchan")

active = plmap_session.runUntilActive(session, 500)
playMapAssert(active.signonComplete and active.clientState == plmap_nc.CA_ACTIVE,
  "new map re-signon did not reach active")
playMapAssert(session.client.integrated.network.spawnCount == oldSpawn + 1 and
  session.client.integrated.network.levelName == "map_new" and
  session.client.integrated.network.configStrings[plmap_qc.CS_MODELS + 1] == "maps/map_new.bsp",
  "new serverdata/configstrings did not replace the old generation")
playMapAssert(findName(session.server.bridgeRuntime.modelNames, soldierName) == 0 and
  findName(session.client.integrated.network.configStrings, soldierName) == 0,
  "old-map-only configstring survived reset")
playMapAssert(session.server.networkRuntime.baselines[3].modelIndex == 0 and
  session.client.integrated.network.baselines[3].modelIndex == 0,
  "old monster baseline survived map reset")
playMapAssert(session.client.lastCommand.msec == 0 and session.client.previousCommand.msec == 0 and
  plmap_session.pendingUserCmds(session) == 0,
  "old usercmd delta history crossed the map generation")
playMapAssert(nativeRawValue(oldClientChannel) == nativeRawValue(
  session.client.integrated.network.client.channel),
  "normal map change replaced the client Netchan")
playMapAssert(plmap_netchan.sequenceNewer(serverChannel.outgoingSequence, oldServerOutgoing) and
  plmap_netchan.sequenceNewer(oldClientChannel.incomingSequence, oldClientIncoming) and
  not serverChannel.fatalError and not oldClientChannel.fatalError,
  "map signon did not preserve monotonic Netchan sequences")
playMapAssert(session.client.integrated.client.current.number < oldClientFrame or
  session.server.frameNumber < oldFrame,
  "new lower snapshot generation was not accepted after reset")

playMapAssert(plmap_session.shutdown(session), "map-change loopback shutdown failed")
print("play_session_map_change_loopback_tests: PASS")
