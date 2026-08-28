/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Strict integrated Quake II 3.19 server-message dispatcher. */
package miniquake2.client.runtime.dispatcher

import miniquake2.qcommon.constants as qc
import miniquake2.protocol.constants as pc
import miniquake2.protocol.checked as pchecked
import miniquake2.protocol.entity_delta as pentity
import miniquake2.protocol.netchan as pnetchan
import miniquake2.protocol.types as pt
import miniquake2.network.constants as nc
import miniquake2.network.client as nclient
import miniquake2.network.runtime.messages as rmessages
import miniquake2.network.runtime.types as nrtypes
import miniquake2.network.runtime.lifecycle as nrlifecycle
import miniquake2.client.demo as cdemo
import miniquake2.client.downloads as cdownloads
import miniquake2.client.effects.parser as ceparser
import miniquake2.client.effects.state as cestate
import miniquake2.client.effects.constants as ceconstants
import miniquake2.client.runtime.types as crtypes
import miniquake2.client.state as cstate

activeResolverRuntime = void

const MAX_PRINT_HANDOFFS = 64
const MAX_SCREEN_HANDOFFS = 16

// Create state.
function create(networkRuntime, clientState, effectState)
  if networkRuntime is void or clientState is void or effectState is void then return error(8280, "client dispatcher state is incomplete") end if
  runtime = crtypes.create(networkRuntime, clientState, effectState)
  if networkRuntime.client.state >= nc.CA_CONNECTED then cstate.setConnectionState(clientState, "connected")
  else if networkRuntime.client.state == nc.CA_CONNECTING then cstate.setConnectionState(clientState, "connecting")
  else cstate.setConnectionState(clientState, "disconnected")
  end if
  return runtime
end function

// Set demo recorder.
function setDemoRecorder(runtime, demo)
  if demo is not void and typeof(demo) != "struct" then return error(8281, "demo recorder must be a Demo") end if
  runtime.demo = demo
  return true
end function

// Set download manager.
function setDownloadManager(runtime, manager)
  if manager is not void and typeof(manager) != "struct" then
    return error(8281, "download manager must be a struct")
  end if
  runtime.downloads = manager
  return true
end function

// Release DM2 files shipped with Quake II use protocol 26. The 3.19 client
// kept an explicit demo-only compatibility hack; live network sessions remain
// strictly Protocol 34.
function setLegacyDemoCompatibility(runtime, enabled)
  if typeof(enabled) != "bool" then return error(8281, "legacy demo compatibility flag must be boolean") end if
  runtime.allowDemoProtocol26 = enabled
  return true
end function

// Release resolver.
function releaseResolver()
  global activeResolverRuntime
  activeResolverRuntime = void
  return true
end function

// Reset client state.
function resetClientState(runtime)
  if runtime.downloads is not void then cdownloads.cancel(runtime.downloads) end if
  clean = cstate.create()
  runtime.client.state = "connected"
  runtime.client.snapshots = clean.snapshots
  runtime.client.current = clean.current
  runtime.client.previous = clean.previous
  runtime.client.predictedOrigin = clean.predictedOrigin
  runtime.client.predictedAngles = clean.predictedAngles
  runtime.client.predictionError = clean.predictionError
  runtime.client.predictionValid = clean.predictionValid
  runtime.client.predictedStep = clean.predictedStep
  runtime.client.predictedStepTime = clean.predictedStepTime
  runtime.client.predictionRealTime = clean.predictionRealTime
  runtime.client.predictionStepOriginZ = clean.predictionStepOriginZ
  runtime.client.predictionStepOriginValid = clean.predictionStepOriginValid
  runtime.client.serverFrame = clean.serverFrame
  runtime.client.serverTime = clean.serverTime
  runtime.client.lightStyles = clean.lightStyles
  runtime.client.lightStyleMaps = clean.lightStyleMaps
  runtime.client.lightStyleOffset = clean.lightStyleOffset
  runtime.effects.dLights = []
  runtime.effects.particles = []
  runtime.effects.particleCount = 0
  runtime.effects.beams = []
  runtime.effects.lasers = []
  runtime.effects.explosions = []
  runtime.effects.sustains = []
  runtime.effects.soundEvents = []
  runtime.effects.time = 0
  cestate.resetEntityTrails(runtime.effects)
  runtime.prints = []
  runtime.centerPrints = []
  runtime.layouts = []
  runtime.inventories = []
  runtime.committedServerFrame = -1
  runtime.frameHandoffs = []
  return true
end function

// Begin map change.
function beginMapChange(runtime)
  nrlifecycle.resetClientLevel(runtime.network)
  resetClientState(runtime)
  cstate.setConnectionState(runtime.client, "connected")
  return true
end function

// Copy array data.
function copyArray(values)
  output = array(len(values), void)
  index = 0
  while index < len(values)
    value = values[index]
    if value is not void then output[index] = value end if
    index = index + 1
  end while
  return output
end function

// Return the validation runtime value.
function validationRuntime(runtime)
  sourceNetworkClient = runtime.network.client
  networkClient = nclient.create(sourceNetworkClient.qport, sourceNetworkClient.timeoutMsec)
  networkClient.state = sourceNetworkClient.state
  networkClient.serverName = sourceNetworkClient.serverName
  networkClient.serverAddress = sourceNetworkClient.serverAddress
  networkClient.challenge = sourceNetworkClient.challenge
  networkClient.userInfo = sourceNetworkClient.userInfo
  networkClient.connectTime = sourceNetworkClient.connectTime
  networkClient.realTime = sourceNetworkClient.realTime
  networkClient.channel = sourceNetworkClient.channel
  networkClient.timeoutCount = sourceNetworkClient.timeoutCount
  networkClient.frames = copyArray(sourceNetworkClient.frames)
  networkClient.currentFrame = sourceNetworkClient.currentFrame
  networkClient.lastPrint = sourceNetworkClient.lastPrint
  networkClient.lastInfo = sourceNetworkClient.lastInfo

  network = nrtypes.ClientRuntime(networkClient, runtime.network.protocol,
    runtime.network.spawnCount, runtime.network.attractLoop, runtime.network.gameDir,
    runtime.network.playerNumber, runtime.network.levelName,
    copyArray(runtime.network.configStrings), copyArray(runtime.network.baselines),
    copyArray(runtime.network.stuffedTexts), bytes(runtime.network.downloadData),
    runtime.network.downloadPercent, runtime.network.downloadMissing,
    runtime.network.ackPending, runtime.network.parsedMessages)

  client = cstate.create()
  client.state = runtime.client.state
  client.snapshots = copyArray(runtime.client.snapshots)
  client.current = runtime.client.current
  client.previous = runtime.client.previous
  client.predictedOrigin = runtime.client.predictedOrigin
  client.predictedAngles = runtime.client.predictedAngles
  client.predictionError = runtime.client.predictionError
  client.predictionValid = runtime.client.predictionValid
  client.predictedStep = runtime.client.predictedStep
  client.predictedStepTime = runtime.client.predictedStepTime
  client.predictionRealTime = runtime.client.predictionRealTime
  client.predictionStepOriginZ = runtime.client.predictionStepOriginZ
  client.predictionStepOriginValid = runtime.client.predictionStepOriginValid
  client.serverFrame = runtime.client.serverFrame
  client.serverTime = runtime.client.serverTime
  client.lightStyles = copyArray(runtime.client.lightStyles)
  client.lightStyleMaps = copyArray(runtime.client.lightStyleMaps)
  client.lightStyleOffset = runtime.client.lightStyleOffset
  effects = cestate.createSilent(runtime.effects.randomSeed)
  copy = crtypes.create(network, client, effects)
  copy.allowDemoProtocol26 = runtime.allowDemoProtocol26
  return copy
end function

// Append limited.
function appendLimited(values, value, maximum)
  output = []
  start = 0
  if len(values) >= maximum then start = len(values) - maximum + 1 end if
  index = start
  while index < len(values)
    output = output + [values[index]]
    index = index + 1
  end while
  return output + [value]
end function

// Read ui string.
function readUiString(buffer, operation)
  value = rmessages.readString(buffer, operation, qc.MAX_STRING_CHARS)
  // Managed destinations mirror the 1024-byte Quake client buffers and keep
  // one byte available for the terminating NUL.
  if len(bytes(value)) >= qc.MAX_STRING_CHARS then return error(8292, operation + ": string exceeds client buffer") end if
  return value
end function

// Parse print.
function parsePrint(runtime, buffer, now)
  level = pchecked.readByte(buffer, "print level")
  if level < qc.PRINT_LOW or level > qc.PRINT_CHAT then return error(8293, "print level outside Protocol-34 range") end if
  text = readUiString(buffer, "print text")
  runtime.prints = appendLimited(runtime.prints,
    crtypes.PrintHandoff(level, text, now, level == qc.PRINT_CHAT), MAX_PRINT_HANDOFFS)
  return true
end function

// Parse center print.
function parseCenterPrint(runtime, buffer, now)
  text = readUiString(buffer, "centerprint text")
  runtime.centerPrints = appendLimited(runtime.centerPrints,
    crtypes.CenterPrintHandoff(text, now), MAX_SCREEN_HANDOFFS)
  return true
end function

// Parse layout.
function parseLayout(runtime, buffer, now)
  text = readUiString(buffer, "layout text")
  runtime.layouts = appendLimited(runtime.layouts,
    crtypes.LayoutHandoff(text, now), MAX_SCREEN_HANDOFFS)
  return true
end function

// Parse inventory.
function parseInventory(runtime, buffer, now)
  values = array(qc.MAX_ITEMS, 0)
  index = 0
  while index < qc.MAX_ITEMS
    values[index] = pchecked.readShort(buffer, "inventory item")
    index = index + 1
  end while
  runtime.inventories = appendLimited(runtime.inventories,
    crtypes.InventoryHandoff(values, now), MAX_SCREEN_HANDOFFS)
  return true
end function

// Return the entity value.
function entity(runtime, number)
  if runtime.client.current is not void then
    value = cstate.findEntity(runtime.client.current.entities, number)
    if value is not void then return value end if
  end if
  if number >= 0 and number < len(runtime.network.baselines) then return runtime.network.baselines[number] end if
  return void
end function

// Resolve entity.
function resolveEntity(number)
  global activeResolverRuntime
  if activeResolverRuntime is void then return error(8291, "effect entity resolver is not active") end if
  return entity(activeResolverRuntime, number)
end function

// Append download.
function appendDownload(runtime, buffer)
  count = pchecked.readShort(buffer, "download size")
  percent = pchecked.readByte(buffer, "download percent")
  if percent < 0 or percent > 100 then return error(8282, "download percent outside range") end if
  if count == -1 then
    runtime.network.downloadMissing = true
    runtime.network.downloadData = bytes()
    if runtime.downloads is not void then
      acceptedDownload = try(cdownloads.acceptChunk(runtime.downloads,
        bytes(), percent, true))
      if acceptedDownload is error then return acceptedDownload end if
    end if
  else
    if count < 0 or count > 1024 then return error(8283, "download chunk size outside range") end if
    chunk = pchecked.readBytes(buffer, count, "download data")
    if runtime.downloads is void then
      runtime.network.downloadData = rmessages.appendBytes(runtime.network.downloadData,
        chunk)
    else
      // The manager streams to disk; retaining and concatenating a second
      // complete map image here would be quadratic and doubles peak memory.
      runtime.network.downloadData = bytes()
      acceptedDownload = try(cdownloads.acceptChunk(runtime.downloads, chunk,
        percent, false))
      if acceptedDownload is error then return acceptedDownload end if
    end if
    runtime.network.downloadMissing = false
  end if
  runtime.network.downloadPercent = percent
  return true
end function

// Accept frame.
function acceptFrame(runtime, buffer)
  // network.snapshot.readFrame owns the svc_frame byte. The outer dispatcher
  // already inspected it, so expose it again to the existing parser.
  buffer.readCount = buffer.readCount - 1
  frameProtocol = runtime.network.protocol
  if frameProtocol == 0 then frameProtocol = qc.PROTOCOL_VERSION end if
  frame = nclient.parseFrameProtocol(runtime.network.client, buffer,
    runtime.network.baselines, frameProtocol)
  snapshot = crtypes.snapshot(frame)
  accepted = cstate.acceptSnapshot(runtime.client, snapshot)
  if accepted then
    // Effects live on the receiving client's monotonic clock. A remote
    // server's uptime is an unrelated epoch; assigning frame.serverTime here
    // makes a freshly connected client fail as soon as it renders effects.
    for each entityState in frame.entities
      if entityState.event != 0 then ceparser.handleEntityEvent(runtime.effects, entityState) end if
      if (entityState.effects & ceconstants.EF_TELEPORTER) != 0 then
        cestate.teleporterEntityParticles(runtime.effects,
          cestate.vecFromArray(entityState.origin))
      end if
    end for
    return 1
  end if
  return 0
end function

// Parse buffer.
function parseBuffer(runtime, buffer, now)
  global activeResolverRuntime
  commands = 0
  effectCommands = 0
  frames = 0
  reconnecting = false
  activeResolverRuntime = runtime
  resolver = resolveEntity
  runtime.effects.time = now
  while buffer.readCount < buffer.curSize
    opcode = pchecked.readByte(buffer, "server command")
    if opcode == qc.SVC_NOP then
      // no body
    else if opcode == qc.SVC_SERVERDATA then
      rmessages.parseServerDataVersion(runtime.network, buffer,
        runtime.allowDemoProtocol26)
      runtime.network.stuffedTexts = []
      resetClientState(runtime)
    else if opcode == qc.SVC_CONFIGSTRING then
      index = pchecked.readShort(buffer, "configstring index")
      if index < 0 or index >= qc.MAX_CONFIGSTRINGS then return error(8284, "configstring index outside range") end if
      runtime.network.configStrings[index] = rmessages.readString(buffer, "configstring value", qc.MAX_STRING_CHARS)
      if index >= qc.CS_LIGHTS and index < qc.CS_LIGHTS + qc.MAX_LIGHTSTYLES then
        cstate.setLightStyle(runtime.client, index - qc.CS_LIGHTS,
          runtime.network.configStrings[index])
      end if
    else if opcode == qc.SVC_SPAWNBASELINE then
      header = pentity.readHeader(buffer)
      if header.endMarker or header.remove or header.number <= 0 then return error(8285, "invalid spawnbaseline header") end if
      runtime.network.baselines[header.number] = pentity.readDelta(buffer, pt.zeroEntityState(), header)
    else if opcode == qc.SVC_STUFFTEXT then
      // Deliberately queue only. No command-system execution is reachable here.
      runtime.network.stuffedTexts = runtime.network.stuffedTexts + [
        rmessages.readString(buffer, "stufftext", qc.MAX_STRING_CHARS)]
    else if opcode == qc.SVC_PRINT then parsePrint(runtime, buffer, now)
    else if opcode == qc.SVC_CENTERPRINT then parseCenterPrint(runtime, buffer, now)
    else if opcode == qc.SVC_LAYOUT then parseLayout(runtime, buffer, now)
    else if opcode == qc.SVC_INVENTORY then parseInventory(runtime, buffer, now)
    else if opcode == qc.SVC_DOWNLOAD then appendDownload(runtime, buffer)
    else if opcode == qc.SVC_FRAME then frames = frames + acceptFrame(runtime, buffer)
    else if opcode == qc.SVC_SOUND or opcode == qc.SVC_MUZZLEFLASH or
        opcode == qc.SVC_MUZZLEFLASH2 or opcode == qc.SVC_TEMP_ENTITY then
      ceparser.parseServiceCommand(runtime.effects, buffer, opcode, resolver)
      effectCommands = effectCommands + 1
    else if opcode == qc.SVC_DISCONNECT then
      runtime.network.client.state = nc.CA_DISCONNECTED
      runtime.network.client.channel = void
      cstate.setConnectionState(runtime.client, "disconnected")
    else if opcode == qc.SVC_RECONNECT then
      beginReconnect(runtime, now)
      reconnecting = true
      if buffer.readCount != buffer.curSize then return error(8294, "svc_reconnect must terminate its packet") end if
    else
      return error(8286, "unsupported or malformed server command " + opcode)
    end if
    commands = commands + 1
  end while
  return [commands, effectCommands, frames, reconnecting]
end function

// Begin a user-requested reconnect through the same atomic retirement path as
// svc_reconnect, without pretending that a server packet was received.
function beginReconnect(runtime, now)
  beginMapChange(runtime)
  nclient.reconnect(runtime.network.client, now)
  runtime.network.ackPending = false
  cstate.setConnectionState(runtime.client, "connecting")
  return true
end function

// Dispatch state.
function dispatch(runtime, payload, sequence, now)
  if typeof(payload) != "bytes" or len(payload) <= 0 or len(payload) > pc.MAX_MSGLEN then return error(8287, "server payload outside protocol message limit") end if
  if typeof(sequence) != "int" or sequence < 0 or sequence > pc.SEQUENCE_MASK then return error(8288, "server payload sequence outside 31-bit range") end if
  if typeof(now) != "int" then return error(8289, "server payload time must be integer milliseconds") end if
  if runtime.sequenceInitialized and not pnetchan.sequenceNewer(sequence, runtime.lastSequence) then
    runtime.rejectedPackets = runtime.rejectedPackets + 1
    return crtypes.result(false, sequence, 0, 0, 0, "stale-or-duplicate")
  end if

  // Validate against detached state first. This prevents a late malformed
  // opcode from committing earlier configstrings, stufftext or one-shot FX.
  validation = validationRuntime(runtime)
  validationBuffer = rmessages.readingBuffer(payload)
  preflight = try(parseBuffer(validation, validationBuffer, now))
  if preflight is error then runtime.rejectedPackets = runtime.rejectedPackets + 1; return preflight end if
  if validationBuffer.readCount != validationBuffer.curSize then return error(8290, "server payload was not consumed exactly") end if

  buffer = rmessages.readingBuffer(payload)
  parsed = try(parseBuffer(runtime, buffer, now))
  if parsed is error then runtime.rejectedPackets = runtime.rejectedPackets + 1; return parsed end if
  if buffer.readCount != buffer.curSize then return error(8290, "server payload was not consumed exactly") end if

  if parsed[3] then
    // A server restart creates a fresh Netchan whose first packet begins at
    // sequence one.  Do not compare it against the retired channel.
    runtime.sequenceInitialized = false
    runtime.lastSequence = 0
  else
    runtime.sequenceInitialized = true
    runtime.lastSequence = sequence
  end if
  runtime.parsedPackets = runtime.parsedPackets + 1
  runtime.network.parsedMessages = runtime.network.parsedMessages + parsed[0]
  if runtime.demo is not void then
    demoDeltaNumber = -1
    if runtime.client.current is not void then
      demoDeltaNumber = runtime.client.current.deltaNumber
    end if
    cdemo.appendLive(runtime.demo, payload, parsed[2], demoDeltaNumber)
  end if
  return crtypes.result(true, sequence, parsed[0], parsed[1], parsed[2], "accepted")
end function

// Return the next demo value.
function nextDemo(runtime, player, now)
  packet = cdemo.nextPacket(player)
  if packet is void then return void end if
  sequence = 1
  if runtime.replayInitialized then sequence = pnetchan.nextSequence(runtime.replaySequence) end if
  runtime.replaySequence = sequence
  runtime.replayInitialized = true
  return dispatch(runtime, packet, sequence, now)
end function

// Report whether pending stuff text.
function pendingStuffText(runtime)
  return runtime.network.stuffedTexts
end function

// Consume prints.
function takePrints(runtime)
  output = runtime.prints
  runtime.prints = []
  return output
end function

// Consume center prints.
function takeCenterPrints(runtime)
  output = runtime.centerPrints
  runtime.centerPrints = []
  return output
end function

// Consume layouts.
function takeLayouts(runtime)
  output = runtime.layouts
  runtime.layouts = []
  return output
end function

// Consume inventories.
function takeInventories(runtime)
  output = runtime.inventories
  runtime.inventories = []
  return output
end function
