/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Headless Protocol-34 client session used for interoperability and soak gates.
Only the fixed signon commands emitted by the server are interpreted here;
arbitrary stufftext remains queued for the UI/command-policy layer.
*/
package miniquake2.runtime.client_session

import miniquake2.qcommon.cmd as csqcmd
import miniquake2.qcommon.byteio as csqbyteio
import miniquake2.qcommon.constants as csqconstants
import miniquake2.qcommon.sizebuf as csqsz
import miniquake2.qcommon.types as csqtypes
import miniquake2.protocol.constants as cspc
import miniquake2.protocol.types as cspt
import miniquake2.protocol.netchan as cspnetchan
import miniquake2.network.constants as csnc
import miniquake2.network.client as csnclient
import miniquake2.network.runtime.types as csnrtypes
import miniquake2.network.runtime.commands as cscommands
import miniquake2.network.runtime.transport as cstransport
import miniquake2.network.runtime.pump as cspump
import miniquake2.client.effects.state as cseffects
import miniquake2.client.runtime.dispatcher as csdispatcher
import miniquake2.client.state as csstate
import miniquake2.client.prediction as csprediction
import miniquake2.client.prediction_world as cspredictionworld
import miniquake2.client.downloads as csdownloads
import miniquake2.platform.system as cssystem
import miniquake2.platform.udp as csudp

struct ClientSession
  integrated
  socket
  clock
  signonSpawnCount
  commandIndex
  previousCommand
  lastCommand
  pendingCommands
  pendingCommandHead
  pendingCommandCount
  commandHistory
  commandSequences
  predictedOrigins
  predictedSequences
  lastPredictionAck
  packetsReceived
  packetsSent
  packetsRejected
  closed
end struct

const MAX_PENDING_USERCMDS = 64
const CMD_BACKUP = 64
const CMD_MASK = 63

function create(serverAddress, serverPort, userInfo, localPort)
  socket = csudp.open("0.0.0.0", localPort)
  address = cstransport.fromUdp(serverAddress, serverPort)
  client = csnclient.create(socket.port & 65535, 120000)
  csnclient.beginConnect(client, serverAddress + ":" + serverPort, address, userInfo, 0)
  network = csnrtypes.createClient(client)
  integrated = csdispatcher.create(network, csstate.create(), cseffects.createSilent(1))
  return ClientSession(integrated, socket, cssystem.createClock(), 0, 0,
    csqtypes.zeroUserCmd(), csqtypes.zeroUserCmd(),
    array(MAX_PENDING_USERCMDS, void), 0, 0,
    array(CMD_BACKUP, void), array(CMD_BACKUP, -1),
    array(CMD_BACKUP, void), array(CMD_BACKUP, -1), -1,
    0, 0, 0, false)
end function

function validatedMovement(value)
  if typeof(value) != "int" and typeof(value) != "float" then
    return error(9997, "client usercmd movement must be numeric")
  end if
  encoded = csqbyteio.truncInt(value)
  if encoded < -32768 or encoded > 32767 then
    return error(9997, "client usercmd movement outside short range")
  end if
  return encoded
end function

function validateUserCmd(command)
  if typeof(command) != "struct" then return error(9992, "client usercmd must be a struct") end if
  if typeof(command.msec) != "int" or command.msec < 0 or command.msec > 255 then
    return error(9993, "client usercmd msec outside byte range")
  end if
  if typeof(command.buttons) != "int" or command.buttons < 0 or command.buttons > 255 or
      typeof(command.impulse) != "int" or command.impulse < 0 or command.impulse > 255 or
      typeof(command.lightLevel) != "int" or command.lightLevel < 0 or command.lightLevel > 255 then
    return error(9994, "client usercmd byte field outside range")
  end if
  if typeof(command.angles) != "array" or len(command.angles) != 3 then
    return error(9995, "client usercmd requires three angles")
  end if
  for each angle in command.angles
    if typeof(angle) != "int" or angle < -32768 or angle > 32767 then
      return error(9996, "client usercmd angle outside short range")
    end if
  end for
  forwardMove = validatedMovement(command.forwardMove)
  sideMove = validatedMovement(command.sideMove)
  upMove = validatedMovement(command.upMove)
  return csqtypes.UserCmd(command.msec, command.buttons,
    [command.angles[0], command.angles[1], command.angles[2]],
    forwardMove, sideMove, upMove, command.impulse, command.lightLevel)
end function

// Queue preserves every input sample. The bounded backlog prevents a paused
// UI producer from causing unbounded latency when networking resumes.
function queueUserCmd(session, command)
  if session.closed then return error(9998, "client session is closed") end if
  if session.pendingCommandCount >= MAX_PENDING_USERCMDS then return error(9999, "client usercmd queue is full") end if
  slot = (session.pendingCommandHead + session.pendingCommandCount) & (MAX_PENDING_USERCMDS - 1)
  session.pendingCommands[slot] = validateUserCmd(command)
  session.pendingCommandCount = session.pendingCommandCount + 1
  return session.pendingCommandCount
end function

// Replace pending samples with the newest command, useful for frame-driven UI
// where old unsent mouse deltas must not be replayed later.
function setUserCmd(session, command)
  if session.closed then return error(9998, "client session is closed") end if
  session.pendingCommandHead = 0
  session.pendingCommandCount = 1
  session.pendingCommands[0] = validateUserCmd(command)
  return true
end function

function pendingUserCmds(session)
  return session.pendingCommandCount
end function

function nextUserCmd(session)
  if session.pendingCommandCount == 0 then
    command = csqtypes.zeroUserCmd()
    command.msec = 100
    return command
  end if
  command = session.pendingCommands[session.pendingCommandHead]
  session.pendingCommandHead = (session.pendingCommandHead + 1) & (MAX_PENDING_USERCMDS - 1)
  session.pendingCommandCount = session.pendingCommandCount - 1
  return command
end function

function inline sequenceDistance(candidate, base)
  return (candidate - base) & cspc.SEQUENCE_MASK
end function

// Return exactly the unacknowledged cmd ring followed by the current render
// preview. Missing pre-active/sign-on sequences are intentionally skipped.
function predictionCommands(session, previewCommand)
  network = session.integrated.network
  if network.client.channel is void then return [] end if
  channel = network.client.channel
  distance = sequenceDistance(channel.outgoingSequence,
    channel.incomingAcknowledged)
  if distance >= CMD_BACKUP then return [] end if
  count = 0
  sequence = cspnetchan.nextSequence(channel.incomingAcknowledged)
  while sequence != channel.outgoingSequence
    slot = sequence & CMD_MASK
    if session.commandSequences[slot] == sequence then count = count + 1 end if
    sequence = cspnetchan.nextSequence(sequence)
  end while
  if previewCommand is not void then count = count + 1 end if
  if count == 0 then return [] end if
  output = array(count, void)
  outputIndex = 0
  sequence = cspnetchan.nextSequence(channel.incomingAcknowledged)
  while sequence != channel.outgoingSequence
    slot = sequence & CMD_MASK
    if session.commandSequences[slot] == sequence then
      output[outputIndex] = cspt.copyUserCmd(session.commandHistory[slot])
      outputIndex = outputIndex + 1
    end if
    sequence = cspnetchan.nextSequence(sequence)
  end while
  if previewCommand is not void then output[outputIndex] = validateUserCmd(previewCommand) end if
  return output
end function

function predictionSequence(session)
  channel = session.integrated.network.client.channel
  if channel is void then return -1 end if
  return channel.outgoingSequence
end function

function storePredictedOrigin(session, sequence, fixedOrigin)
  if sequence < 0 then return false end if
  slot = sequence & CMD_MASK
  session.predictedOrigins[slot] = [fixedOrigin[0], fixedOrigin[1], fixedOrigin[2]]
  session.predictedSequences[slot] = sequence
  return true
end function

function reconcilePrediction(session)
  networkClient = session.integrated.network.client
  if networkClient.channel is void or session.integrated.client.current is void then return false end if
  acknowledge = networkClient.channel.incomingAcknowledged
  if acknowledge == session.lastPredictionAck then return false end if
  slot = acknowledge & CMD_MASK
  if session.predictedSequences[slot] != acknowledge then return false end if
  session.lastPredictionAck = acknowledge
  csstate.updatePredictionError(session.integrated.client,
    session.predictedOrigins[slot])
  return true
end function

// CL_PredictMovement for a real remote client: replay the unacknowledged
// command ring against the locally loaded BSP plus the current packet-entity
// solids. Listen play may keep using its authoritative Game-API bridge.
function predictRemote(session, previewCommand, collision)
  clientState = session.integrated.client
  if session.closed or clientState.current is void then return false end if
  if not csprediction.predictionEnabled(
      clientState.current.playerState) then return false end if
  commands = predictionCommands(session, previewCommand)
  if len(commands) == 0 then return false end if
  airAcceleration = 0.0
  configStrings = session.integrated.network.configStrings
  if csqconstants.CS_AIRACCEL < len(configStrings) and
      configStrings[csqconstants.CS_AIRACCEL] != "" then
    parsed = try(toNumber(configStrings[csqconstants.CS_AIRACCEL]))
    if parsed is not error then airAcceleration = parsed end if
  end if
  localEntityNumber = session.integrated.network.playerNumber + 1
  result = cspredictionworld.predict(clientState.current.playerState, commands,
    collision, configStrings, clientState.current, localEntityNumber,
    airAcceleration)
  csstate.acceptPrediction(clientState, result.state.origin, result.viewAngles)
  csstate.notePredictionStep(clientState, result.previousOrigin,
    result.state.origin, result.state.flags, commands[len(commands) - 1].msec)
  storePredictedOrigin(session, predictionSequence(session), result.state.origin)
  return result
end function

function sendStringCommand(session, command, now)
  network = session.integrated.network
  if network.client.state < csnc.CA_CONNECTED or network.client.channel is void then return false end if
  buffer = csqsz.alloc(1024)
  cscommands.writeStringCommand(buffer, command)
  queued = cspnetchan.queueReliableFragments(network.client.channel,
    [csqsz.dataSlice(buffer)])
  if queued == false then return false end if
  stats = csnrtypes.stats()
  cspump.flushClient(network, session.socket, now, bytes(), stats)
  session.packetsSent = session.packetsSent + stats.sent
  return true
end function

function sendUserInfo(session, userInfo, now)
  network = session.integrated.network
  if network.client.state < csnc.CA_CONNECTED or network.client.channel is void then return false end if
  buffer = csqsz.alloc(1024)
  cscommands.writeUserInfo(buffer, userInfo)
  queued = cspnetchan.queueReliableFragments(network.client.channel,
    [csqsz.dataSlice(buffer)])
  if queued == false then return false end if
  network.client.userInfo = userInfo
  stats = csnrtypes.stats()
  cspump.flushClient(network, session.socket, now, bytes(), stats)
  session.packetsSent = session.packetsSent + stats.sent
  return true
end function

function configureDownloads(session, manager)
  return csdispatcher.setDownloadManager(session.integrated, manager)
end function

function signonCommand(text)
  arguments = csqcmd.tokenize(text)
  if len(arguments) == 0 then return "" end if
  if arguments[0] == "cmd" and len(arguments) >= 2 then
    if arguments[1] == "configstrings" and len(arguments) == 4 then return "configstrings " + arguments[2] + " " + arguments[3] end if
    if arguments[1] == "baselines" and len(arguments) == 4 then return "baselines " + arguments[2] + " " + arguments[3] end if
    return ""
  end if
  if arguments[0] == "precache" and len(arguments) == 2 then return "begin " + arguments[1] end if
  return ""
end function

function resetMapInput(session)
  session.previousCommand = csqtypes.zeroUserCmd()
  session.lastCommand = csqtypes.zeroUserCmd()
  session.pendingCommands = array(MAX_PENDING_USERCMDS, void)
  session.pendingCommandHead = 0
  session.pendingCommandCount = 0
  session.commandHistory = array(CMD_BACKUP, void)
  session.commandSequences = array(CMD_BACKUP, -1)
  session.predictedOrigins = array(CMD_BACKUP, void)
  session.predictedSequences = array(CMD_BACKUP, -1)
  session.lastPredictionAck = -1
  csstate.clearPrediction(session.integrated.client)
  return true
end function

function synchronizeSpawnCount(session)
  current = session.integrated.network.spawnCount
  if current == session.signonSpawnCount then return false end if
  session.signonSpawnCount = current
  session.commandIndex = 0
  resetMapInput(session)
  return true
end function

function processSignon(session, now)
  synchronizeSpawnCount(session)
  commands = session.integrated.network.stuffedTexts
  count = 0
  while session.commandIndex < len(commands)
    text = commands[session.commandIndex]
    session.commandIndex = session.commandIndex + 1
    if text == "changing\n" then
      csdispatcher.beginMapChange(session.integrated)
      resetMapInput(session)
    else if text == "reconnect\n" then
      // Exact engine-owned lifecycle text only; arbitrary stufftext remains
      // inert.  A normal level change preserves this live Netchan.
      csdispatcher.beginMapChange(session.integrated)
      resetMapInput(session)
      if sendStringCommand(session, "new", now) then count = count + 1 end if
    else
      arguments = csqcmd.tokenize(text)
      if len(arguments) == 2 and arguments[0] == "precache" and
          session.integrated.downloads is not void then
        spawnCount = try(toNumber(arguments[1]))
        if spawnCount is error or typeof(spawnCount) != "int" or spawnCount < 0 then
          return error(9991, "precache spawn count is invalid")
        end if
        selectedGameDirectory = try(csdownloads.setGameDirectory(
          session.integrated.downloads,
          session.integrated.network.gameDir))
        if selectedGameDirectory is error then return selectedGameDirectory end if
        startedDownload = try(csdownloads.beginPrecache(
          session.integrated.downloads,
          session.integrated.network.configStrings, spawnCount))
        if startedDownload is error then return startedDownload end if
      else
        command = signonCommand(text)
        if command != "" then sendStringCommand(session, command, now); count = count + 1 end if
      end if
    end if
  end while
  return count
end function

function processDownloads(session, now)
  manager = session.integrated.downloads
  if manager is void then return 0 end if
  commands = csdownloads.takeCommands(manager)
  sent = 0
  for each command in commands
    if sendStringCommand(session, command, now) then sent = sent + 1
    else csdownloads.queueCommand(manager, command)
    end if
  end for
  return sent
end function

function sendMove(session, now)
  network = session.integrated.network
  if network.client.state != csnc.CA_ACTIVE or network.client.channel is void then return false end if
  lastFrame = -1
  if network.client.currentFrame is not void then lastFrame = network.client.currentFrame.serverFrame end if
  command = nextUserCmd(session)
  sequence = network.client.channel.outgoingSequence
  historySlot = sequence & CMD_MASK
  session.commandHistory[historySlot] = cspt.copyUserCmd(command)
  session.commandSequences[historySlot] = sequence
  buffer = csqsz.alloc(256)
  cscommands.writeMove(buffer, sequence, lastFrame,
    session.previousCommand, session.lastCommand, command)
  stats = csnrtypes.stats()
  cspump.flushClient(network, session.socket, now, csqsz.dataSlice(buffer), stats)
  session.packetsSent = session.packetsSent + stats.sent
  session.previousCommand = session.lastCommand
  session.lastCommand = cspt.copyUserCmd(command)
  return true
end function

function pump(session, sendMovement)
  if session.closed then return error(9990, "client session is closed") end if
  now = csqbyteio.truncInt(cssystem.milliseconds(session.clock))
  stats = cspump.pumpIntegratedClient(session.integrated, session.socket, now, 128)
  session.packetsReceived = session.packetsReceived + stats.received
  session.packetsSent = session.packetsSent + stats.sent
  session.packetsRejected = session.packetsRejected + stats.rejected
  processSignon(session, now)
  processDownloads(session, now)
  reconcilePrediction(session)
  if sendMovement then sendMove(session, now) end if
  return session.integrated.network.client.state
end function

function step(session)
  return pump(session, true)
end function

// Receive/ACK/signon half of a listen-server tick without synthesizing a
// second usercmd for the same UI frame.
function poll(session)
  return pump(session, false)
end function

function run(session, frameLimit)
  if typeof(frameLimit) != "int" or frameLimit < 1 then return error(9991, "client frame limit must be positive") end if
  frames = 0
  while frames < frameLimit and session.integrated.network.client.state != csnc.CA_DISCONNECTED
    started = cssystem.milliseconds(session.clock)
    step(session)
    frames = frames + 1
    elapsed = cssystem.milliseconds(session.clock) - started
    if elapsed < 100 then cssystem.sleep(csqbyteio.truncInt(100 - elapsed)) end if
  end while
  return frames
end function

function shutdown(session)
  if session.closed then return false end if
  now = csqbyteio.truncInt(cssystem.milliseconds(session.clock))
  packets = csnclient.disconnect(session.integrated.network.client, now)
  for each packet in packets
    csudp.send(session.socket, cstransport.host(session.integrated.network.client.serverAddress),
      session.integrated.network.client.serverAddress.port, packet)
  end for
  csudp.close(session.socket)
  session.closed = true
  return true
end function
