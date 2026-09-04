//! Provides miniquake2 network runtime commands facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Client command encoding and server-side clc dispatch from sv_user.c. */
package miniquake2.network.runtime.commands

import miniquake2.qcommon.constants as qc
import miniquake2.qcommon.types as qt
import miniquake2.qcommon.byteio as qbio
import miniquake2.qcommon.message as qmsg
import miniquake2.qcommon.sizebuf as qsz
import miniquake2.qcommon.info as qinfo
import miniquake2.qcommon.cmd as qcmd
import miniquake2.qcommon.text as qtext
import miniquake2.protocol.constants as pc
import miniquake2.protocol.types as pt
import miniquake2.protocol.checked as pchecked
import miniquake2.protocol.usercmd as pusercmd
import miniquake2.protocol.netchan as pnetchan
import miniquake2.network.constants as nc
import miniquake2.network.types as nt
import miniquake2.network.address as naddress
import miniquake2.network.connectionless as nconnectionless
import miniquake2.network.server as nserver
import miniquake2.network.runtime.types as nrtypes
import miniquake2.server.administration as nsadmin

/// Defines the max network command log constant used by the miniquake2 network runtime commands module.
const MAX_NETWORK_COMMAND_LOG = 1024

/// Append network command log.
/// @param runtime runtime value consumed by this operation.
/// @param slot slot value consumed by this operation.
/// @param value Value consumed or transformed by the operation.
function networkCommandAppendLog(runtime, slot, value)
  entry = [slot, value]
  if len(runtime.commandLog) < MAX_NETWORK_COMMAND_LOG then
    runtime.commandLog = runtime.commandLog + [entry]
    return true
  end if
  output = array(MAX_NETWORK_COMMAND_LOG, void)
  index = 1
  while index < MAX_NETWORK_COMMAND_LOG
    output[index - 1] = runtime.commandLog[index]
    index = index + 1
  end while
  output[MAX_NETWORK_COMMAND_LOG - 1] = entry
  runtime.commandLog = output
  return true
end function
import miniquake2.network.runtime.messages as rmessages
import miniquake2.network.runtime.checksum as rchecksum

/// Defines the max string commands constant used by the miniquake2 network runtime commands module.
const MAX_STRING_COMMANDS = 8
/// Defines the download chunk constant used by the miniquake2 network runtime commands module.
const DOWNLOAD_CHUNK = 1024
/// Defines the max deferred reliable work constant used by the miniquake2 network runtime commands module.
const MAX_DEFERRED_RELIABLE_WORK = 16
/// Defines the reliable work configstrings constant used by the miniquake2 network runtime commands module.
const RELIABLE_WORK_CONFIGSTRINGS = 1
/// Defines the reliable work baselines constant used by the miniquake2 network runtime commands module.
const RELIABLE_WORK_BASELINES = 2
/// Defines the reliable work download constant used by the miniquake2 network runtime commands module.
const RELIABLE_WORK_DOWNLOAD = 3

/// MSG_Write/ReadDeltaUsercmd never mutates its base command. Keep the stock
networkRuntimeZeroUserCmd = qt.zeroUserCmd()

/// Write user info.
/// @param buffer Buffer that receives or supplies the operation data.
/// @param userInfo userInfo value consumed by this operation.
function writeUserInfo(buffer, userInfo)
  if not qinfo.validate(userInfo) then return error(7250, "invalid clc_userinfo string") end if
  qmsg.writeByte(buffer, qc.CLC_USERINFO)
  qmsg.writeString(buffer, userInfo)
  return buffer
end function

/// Write string command.
/// @param buffer Buffer that receives or supplies the operation data.
/// @param command command value consumed by this operation.
function writeStringCommand(buffer, command)
  if typeof(command) != "string" or len(bytes(command)) >= qc.MAX_STRING_CHARS then return error(7251, "invalid clc_stringcmd") end if
  qmsg.writeByte(buffer, qc.CLC_STRINGCMD)
  qmsg.writeString(buffer, command)
  return buffer
end function

/// Write move.
/// @param buffer Buffer that receives or supplies the operation data.
/// @param sequence sequence value consumed by this operation.
/// @param lastFrame lastFrame value consumed by this operation.
/// @param oldest oldest value consumed by this operation.
/// @param oldCommand oldCommand value consumed by this operation.
/// @param newCommand newCommand value consumed by this operation.
function writeMove(buffer, sequence, lastFrame, oldest, oldCommand, newCommand)
  if typeof(sequence) != "int" or sequence < 0 then return error(7252, "move sequence must be non-negative") end if
  qmsg.writeByte(buffer, qc.CLC_MOVE)
  checksumIndex = buffer.curSize
  qmsg.writeByte(buffer, 0)
  qmsg.writeLong(buffer, lastFrame)
  pusercmd.writeDelta(buffer, networkRuntimeZeroUserCmd, oldest)
  pusercmd.writeDelta(buffer, oldest, oldCommand)
  pusercmd.writeDelta(buffer, oldCommand, newCommand)
  buffer.data[checksumIndex] = rchecksum.blockSequence(buffer.data, checksumIndex + 1,
    buffer.curSize - checksumIndex - 1, sequence)
  return buffer
end function

/// Report whether contains traversal.
/// @param name Name of the affected item.
function containsTraversal(name)
  value = bytes(name)
  index = 0
  while index + 1 < len(value)
    if value[index] == 46 and value[index + 1] == 46 then return true end if
    index = index + 1
  end while
  return false
end function

/// Report whether has subdirectory.
/// @param name Name of the affected item.
function hasSubdirectory(name)
  value = bytes(name)
  for each character in value
    if character == 47 then return true end if
  end for
  return false
end function

/// Return the safe download name.
/// @param name Name of the affected item.
function safeDownloadName(name)
  if typeof(name) != "string" or name == "" or len(bytes(name)) >= qc.MAX_QPATH then return false end if
  value = bytes(name)
  if value[0] == 46 or value[0] == 47 or value[0] == 92 then return false end if
  return not containsTraversal(name) and hasSubdirectory(name)
end function

/// Register download.
/// @param runtime runtime value consumed by this operation.
/// @param name Name of the affected item.
/// @param data Input data consumed by the operation.
function registerDownload(runtime, name, data)
  if not safeDownloadName(name) or typeof(data) != "bytes" then return error(7253, "invalid runtime download") end if
  index = 0
  while index < len(runtime.downloads)
    if runtime.downloads[index].name == name then runtime.downloads[index] = nrtypes.DownloadFile(name, data); return true end if
    index = index + 1
  end while
  runtime.downloads = runtime.downloads + [nrtypes.DownloadFile(name, data)]
  return true
end function

/// Find download.
/// @param runtime runtime value consumed by this operation.
/// @param name Name of the affected item.
function findDownload(runtime, name)
  for each entry in runtime.downloads
    if entry.name == name then return entry.data end if
  end for
  return void
end function

/// Return the server data fragments value.
/// @param runtime runtime value consumed by this operation.
/// @param slot slot value consumed by this operation.
function serverDataFragments(runtime, slot)
  buffer = qsz.alloc(pc.RELIABLE_BUFFER_SIZE)
  rmessages.writeServerData(buffer, runtime.spawnCount,
    runtime.server.attractLoop, runtime.gameDir, slot, runtime.levelName)
  rmessages.writeStuffText(buffer, "cmd configstrings " + runtime.spawnCount + " 0\n")
  return [qsz.dataSlice(buffer)]
end function

/// Return the config string fragment value.
/// @param index Zero-based index of the affected item.
/// @param value Value consumed or transformed by the operation.
function configStringFragment(index, value)
  buffer = qsz.alloc(pc.RELIABLE_BUFFER_SIZE)
  rmessages.writeConfigString(buffer, index, value)
  return qsz.dataSlice(buffer)
end function

/// Return the stuff text fragment value.
/// @param text Text consumed by the operation.
function stuffTextFragment(text)
  buffer = qsz.alloc(pc.RELIABLE_BUFFER_SIZE)
  rmessages.writeStuffText(buffer, text)
  return qsz.dataSlice(buffer)
end function

/// Return the baseline fragment value.
/// @param baseline baseline value consumed by this operation.
function baselineFragment(baseline)
  buffer = qsz.alloc(256)
  rmessages.writeSpawnBaseline(buffer, baseline)
  return qsz.dataSlice(buffer)
end function

/// Return the download fragment value.
/// @param data Input data consumed by the operation.
/// @param offset Zero-based offset at which processing starts.
/// @param count Number of items or units to process.
/// @param percent percent value consumed by this operation.
function downloadFragment(data, offset, count, percent)
  buffer = qsz.alloc(pc.RELIABLE_BUFFER_SIZE)
  rmessages.writeDownload(buffer, data, offset, count, percent)
  return qsz.dataSlice(buffer)
end function

/// Queue server data.
/// @param runtime runtime value consumed by this operation.
/// @param slot slot value consumed by this operation.
function queueServerData(runtime, slot)
  client = runtime.server.clients[slot]
  if client.state != nc.CS_CONNECTED then return false end if
  queued = pnetchan.queueReliableFragments(client.channel,
    serverDataFragments(runtime, slot))
  if queued == false then return false end if
  runtime.lastCommands[slot] = qt.zeroUserCmd()
  return true
end function

/// Queue config strings.
/// @param runtime runtime value consumed by this operation.
/// @param slot slot value consumed by this operation.
/// @param requestedSpawn requestedSpawn value consumed by this operation.
/// @param start start value consumed by this operation.
function queueConfigStrings(runtime, slot, requestedSpawn, start)
  client = runtime.server.clients[slot]
  if client.state != nc.CS_CONNECTED then return false end if
  if requestedSpawn != runtime.spawnCount then return queueServerData(runtime, slot) end if
  if start < 0 or start > qc.MAX_CONFIGSTRINGS then return error(7254, "configstring start outside range") end if
  fragments = []
  batchBytes = 0
  while batchBytes < qc.MAX_MSGLEN / 2 and start < qc.MAX_CONFIGSTRINGS
    value = runtime.configStrings[start]
    if value != "" then
      fragment = configStringFragment(start, value)
      fragments = fragments + [fragment]
      batchBytes = batchBytes + len(fragment)
    end if
    start = start + 1
  end while
  if start == qc.MAX_CONFIGSTRINGS then
    fragments = fragments + [stuffTextFragment("cmd baselines " + runtime.spawnCount + " 0\n")]
  else
    fragments = fragments + [stuffTextFragment("cmd configstrings " + runtime.spawnCount + " " + start + "\n")]
  end if
  queued = pnetchan.queueReliableFragments(client.channel, fragments)
  if queued == false then return false end if
  return start
end function

/// Queue baselines.
/// @param runtime runtime value consumed by this operation.
/// @param slot slot value consumed by this operation.
/// @param requestedSpawn requestedSpawn value consumed by this operation.
/// @param start start value consumed by this operation.
function queueBaselines(runtime, slot, requestedSpawn, start)
  client = runtime.server.clients[slot]
  if client.state != nc.CS_CONNECTED then return false end if
  if requestedSpawn != runtime.spawnCount then return queueServerData(runtime, slot) end if
  if start < 0 or start > pc.MAX_EDICTS then return error(7255, "baseline start outside range") end if
  fragments = []
  batchBytes = 0
  while batchBytes < qc.MAX_MSGLEN / 2 and start < pc.MAX_EDICTS
    baseline = runtime.baselines[start]
    if baseline.modelIndex != 0 or baseline.sound != 0 or baseline.effects != 0 then
      encoded = baselineFragment(baseline)
      fragments = fragments + [encoded]
      batchBytes = batchBytes + len(encoded)
    end if
    start = start + 1
  end while
  if start == pc.MAX_EDICTS then
    fragments = fragments + [stuffTextFragment("precache " + runtime.spawnCount + "\n")]
  else
    fragments = fragments + [stuffTextFragment("cmd baselines " + runtime.spawnCount + " " + start + "\n")]
  end if
  queued = pnetchan.queueReliableFragments(client.channel, fragments)
  if queued == false then return false end if
  return start
end function

/// Queue download chunk.
/// @param runtime runtime value consumed by this operation.
/// @param slot slot value consumed by this operation.
function queueDownloadChunk(runtime, slot)
  transfer = runtime.transfers[slot]
  if transfer is void or transfer.offset < 0 then return false end if
  remaining = len(transfer.data) - transfer.offset
  count = remaining
  if count > DOWNLOAD_CHUNK then count = DOWNLOAD_CHUNK end if
  endOffset = transfer.offset + count
  divisor = len(transfer.data)
  if divisor == 0 then divisor = 1 end if
  percent = qbio.truncInt((endOffset * 100) / divisor)
  client = runtime.server.clients[slot]
  queued = pnetchan.queueReliableFragments(client.channel,
    [downloadFragment(transfer.data, transfer.offset, count, percent)])
  if queued == false then return false end if
  transfer.offset = endOffset
  if transfer.offset == len(transfer.data) then runtime.transfers[slot] = nrtypes.DownloadTransfer("", bytes(), -1) end if
  return count
end function

/// Return the defer reliable work value.
/// @param runtime runtime value consumed by this operation.
/// @param slot slot value consumed by this operation.
/// @param kind kind value consumed by this operation.
/// @param first first value consumed by this operation.
/// @param second second value consumed by this operation.
function deferReliableWork(runtime, slot, kind, first, second)
  if slot < 0 or slot >= runtime.server.maxClients then
    return error(7262, "deferred reliable work slot outside range")
  end if
  pending = runtime.deferredReliable[slot]
  if len(pending) >= MAX_DEFERRED_RELIABLE_WORK then
    return error(7263, "deferred reliable work queue is full")
  end if
  runtime.deferredReliable[slot] = pending + [nrtypes.DeferredReliableWork(
    kind, first, second)]
  return true
end function

/// Client string commands are themselves reliably acknowledged before their
/// server response necessarily fits.  Retain a bounded typed retry record so
/// backpressure cannot consume config/baseline/download requests.
/// @param runtime runtime value consumed by this operation.
/// @param slot slot value consumed by this operation.
function retryDeferredReliable(runtime, slot)
  if slot < 0 or slot >= runtime.server.maxClients then
    return error(7262, "deferred reliable work slot outside range")
  end if
  while len(runtime.deferredReliable[slot]) > 0
    work = runtime.deferredReliable[slot][0]
    completed = false
    if work.kind == RELIABLE_WORK_CONFIGSTRINGS then
      completed = queueConfigStrings(runtime, slot, work.first, work.second)
    else if work.kind == RELIABLE_WORK_BASELINES then
      completed = queueBaselines(runtime, slot, work.first, work.second)
    else if work.kind == RELIABLE_WORK_DOWNLOAD then
      completed = queueDownloadChunk(runtime, slot)
    else
      return error(7264, "deferred reliable work kind is corrupt")
    end if
    if completed == false then return false end if
    remaining = []
    index = 1
    while index < len(runtime.deferredReliable[slot])
      remaining = remaining + [runtime.deferredReliable[slot][index]]
      index = index + 1
    end while
    runtime.deferredReliable[slot] = remaining
  end while
  return true
end function

/// Return the replenish command msec value.
/// @param runtime runtime value consumed by this operation.
function replenishCommandMsec(runtime)
  index = 0
  while index < runtime.server.maxClients
    runtime.commandMsec[index] = 1800
    index = index + 1
  end while
  return true
end function

/// Begin download.
/// @param runtime runtime value consumed by this operation.
/// @param slot slot value consumed by this operation.
/// @param name Name of the affected item.
/// @param offset Zero-based offset at which processing starts.
function beginDownload(runtime, slot, name, offset)
  if not safeDownloadName(name) then
    pnetchan.queueReliableFragments(runtime.server.clients[slot].channel,
      [downloadFragment(bytes(), 0, -1, 0)])
    return false
  end if
  data = findDownload(runtime, name)
  if data is void then
    pnetchan.queueReliableFragments(runtime.server.clients[slot].channel,
      [downloadFragment(bytes(), 0, -1, 0)])
    return false
  end if
  if offset < 0 then offset = 0 end if
  if offset > len(data) then offset = len(data) end if
  runtime.transfers[slot] = nrtypes.DownloadTransfer(name, data, offset)
  queueDownloadChunk(runtime, slot)
  return true
end function

/// Return the integer argument value.
/// @param arguments arguments value consumed by this operation.
/// @param index Zero-based index of the affected item.
function integerArgument(arguments, index)
  if index >= len(arguments) then return 0 end if
  return nconnectionless.parseDecimal(arguments[index])
end function

/// CL_Disconnect in the 3.19 client transmits strlen(final), deliberately
/// omitting the strcpy terminator. Accept only that one exact terminal command;
/// every other clc_stringcmd still requires regular NUL framing.
/// @param buffer Buffer that receives or supplies the operation data.
function readClientStringCommand(buffer)
  index = buffer.readCount
  while index < buffer.curSize
    if buffer.data[index] == 0 then
      return rmessages.readString(buffer, "client string command", qc.MAX_STRING_CHARS)
    end if
    index = index + 1
  end while
  expected = bytes("disconnect")
  remaining = buffer.curSize - buffer.readCount
  if remaining != len(expected) then return error(7261, "client string command: unterminated string") end if
  index = 0
  while index < len(expected)
    if buffer.data[buffer.readCount + index] != expected[index] then
      return error(7261, "client string command: unterminated string")
    end if
    index = index + 1
  end while
  buffer.readCount = buffer.curSize
  return "disconnect"
end function

/// Execute string.
/// @param runtime runtime value consumed by this operation.
/// @param slot slot value consumed by this operation.
/// @param text Text consumed by the operation.
function executeString(runtime, slot, text)
  // Keep execute string phases explicit: validate inputs, update owned state, then publish the result.
  arguments = qcmd.tokenize(text)
  if len(arguments) == 0 then return false end if
  networkCommandAppendLog(runtime, slot, text)
  name = arguments[0]
  if name == "new" then return queueServerData(runtime, slot) end if
  if name == "configstrings" then
    requestedSpawn = integerArgument(arguments, 1)
    requestedStart = integerArgument(arguments, 2)
    queued = queueConfigStrings(runtime, slot, requestedSpawn, requestedStart)
    if queued == false and runtime.server.clients[slot].state == nc.CS_CONNECTED then
      return deferReliableWork(runtime, slot, RELIABLE_WORK_CONFIGSTRINGS,
        requestedSpawn, requestedStart)
    end if
    return queued
  end if
  if name == "baselines" then
    requestedSpawn = integerArgument(arguments, 1)
    requestedStart = integerArgument(arguments, 2)
    queued = queueBaselines(runtime, slot, requestedSpawn, requestedStart)
    if queued == false and runtime.server.clients[slot].state == nc.CS_CONNECTED then
      return deferReliableWork(runtime, slot, RELIABLE_WORK_BASELINES,
        requestedSpawn, requestedStart)
    end if
    return queued
  end if
  if name == "begin" then
    if integerArgument(arguments, 1) != runtime.spawnCount then return queueServerData(runtime, slot) end if
    if nserver.markSpawned(runtime.server, slot) then return runtime.callbacks.clientBegin(slot) end if
    return false
  end if
  if name == "download" then
    if len(arguments) < 2 then return beginDownload(runtime, slot, "", 0) end if
    queued = beginDownload(runtime, slot, arguments[1], integerArgument(arguments, 2))
    if queued == false and runtime.transfers[slot].offset >= 0 then
      return deferReliableWork(runtime, slot, RELIABLE_WORK_DOWNLOAD, 0, 0)
    end if
    return queued
  end if
  if name == "nextdl" then
    queued = queueDownloadChunk(runtime, slot)
    if queued == false and runtime.transfers[slot].offset >= 0 then
      return deferReliableWork(runtime, slot, RELIABLE_WORK_DOWNLOAD, 0, 0)
    end if
    return queued
  end if
  if name == "disconnect" then
    runtime.deferredReliable[slot] = []
    runtime.callbacks.clientDisconnect(slot)
    nserver.dropClient(runtime.server, slot, runtime.server.realTime, false)
    return true
  end if
  if name == "info" then return true end if
  return runtime.callbacks.clientCommand(slot, text)
end function

/// Apply think.
/// @param runtime runtime value consumed by this operation.
/// @param slot slot value consumed by this operation.
/// @param command command value consumed by this operation.
function applyThink(runtime, slot, command)
  runtime.commandMsec[slot] = runtime.commandMsec[slot] - command.msec
  if runtime.commandMsec[slot] < 0 then return false end if
  return runtime.callbacks.clientThink(slot, command)
end function

/// Parse client payload.
/// @param runtime runtime value consumed by this operation.
/// @param slot slot value consumed by this operation.
/// @param payload payload value consumed by this operation.
/// @param sequence sequence value consumed by this operation.
/// @param dropped dropped value consumed by this operation.
/// @param paused paused value consumed by this operation.
function parseClientPayload(runtime, slot, payload, sequence, dropped, paused)
  if slot < 0 or slot >= runtime.server.maxClients then return error(7256, "client payload slot outside range") end if
  buffer = rmessages.readingBuffer(payload)
  moveIssued = false
  stringCount = 0
  while buffer.readCount < buffer.curSize
    opcode = pchecked.readByte(buffer, "client command")
    if opcode == qc.CLC_NOP then
      // no payload
    else if opcode == qc.CLC_USERINFO then
      userInfo = rmessages.readString(buffer, "client userinfo", qc.MAX_INFO_STRING)
      if not qinfo.validate(userInfo) then return error(7257, "malformed clc_userinfo") end if
      client = runtime.server.clients[slot]
      nserver.applyUserInfo(client, userInfo)
      runtime.callbacks.clientUserinfoChanged(slot, userInfo)
    else if opcode == qc.CLC_MOVE then
      if moveIssued then return error(7258, "multiple clc_move commands in one packet") end if
      moveIssued = true
      checksumIndex = buffer.readCount
      checksum = pchecked.readByte(buffer, "move checksum")
      lastFrame = pchecked.readLong(buffer, "move last frame")
      oldest = pusercmd.readDelta(buffer, networkRuntimeZeroUserCmd)
      oldCommand = pusercmd.readDelta(buffer, oldest)
      newCommand = pusercmd.readDelta(buffer, oldCommand)
      nserver.acknowledgeFrame(runtime.server, slot, lastFrame)
      if runtime.server.clients[slot].state == nc.CS_SPAWNED then
        calculated = rchecksum.blockSequence(buffer.data, checksumIndex + 1,
          buffer.readCount - checksumIndex - 1, sequence)
        if calculated != checksum then return error(7259, "clc_move checksum mismatch") end if
        if not paused then
          recovery = dropped
          if recovery < 20 then
            while recovery > 2
              applyThink(runtime, slot, runtime.lastCommands[slot])
              recovery = recovery - 1
            end while
            if recovery > 1 then applyThink(runtime, slot, oldest) end if
            if recovery > 0 then applyThink(runtime, slot, oldCommand) end if
          end if
          applyThink(runtime, slot, newCommand)
        end if
        runtime.lastCommands[slot] = pt.copyUserCmd(newCommand)
      else
        runtime.server.clients[slot].lastFrame = -1
      end if
    else if opcode == qc.CLC_STRINGCMD then
      commandText = readClientStringCommand(buffer)
      stringCount = stringCount + 1
      if stringCount < MAX_STRING_COMMANDS then executeString(runtime, slot, commandText) end if
      if runtime.server.clients[slot].state == nc.CS_ZOMBIE or runtime.server.clients[slot].state == nc.CS_FREE then return true end if
    else
      return error(7260, "unknown client command " + opcode)
    end if
  end while
  return true
end function

/// Return the joined arguments value.
/// @param arguments arguments value consumed by this operation.
/// @param startIndex Zero-based index of start.
function joinedArguments(arguments, startIndex)
  output = ""
  index = startIndex
  while index < len(arguments)
    if output != "" then output = output + " " end if
    output = output + arguments[index]
    index = index + 1
  end while
  return output
end function

/// Return the operator status value.
/// @param runtime runtime value consumed by this operation.
function operatorStatus(runtime)
  return "map              : " + runtime.server.mapName + "\n" +
    nserver.statusString(runtime.server)
end function

/// Resolve an operator client selector by numeric slot or case-insensitive
/// player name. Numeric slots use Quake II's human-facing zero-based values.
/// @param runtime runtime value consumed by this operation.
/// @param selector selector value consumed by this operation.
function operatorClientSlot(runtime, selector)
  numeric = try(toNumber(selector))
  if numeric is not error and numeric is not void then
    slot = qbio.truncInt(numeric)
    if numeric == slot and slot >= 0 and slot < runtime.server.maxClients and
        runtime.server.clients[slot].state >= nc.CS_CONNECTED then return slot end if
  end if
  slot = 0
  while slot < runtime.server.maxClients
    client = runtime.server.clients[slot]
    if client.state >= nc.CS_CONNECTED and
        qtext.equalInsensitive(client.name, selector) then return slot end if
    slot = slot + 1
  end while
  return -1
end function

/// Return the stock dumpuser-style information for one connected client.
/// @param runtime runtime value consumed by this operation.
/// @param slot slot value consumed by this operation.
function operatorDumpUser(runtime, slot)
  client = runtime.server.clients[slot]
  return "userinfo\n--------\n" + client.userInfo + "\n"
end function

/// A deliberately bounded operator surface.  These are the stock commands
/// needed to administer the Protocol-34 endpoint; it never delegates RCON text
/// to the host shell or filesystem command parser.
/// @param runtime runtime value consumed by this operation.
/// @param text Text consumed by the operation.
function executeOperator(runtime, text)
  // Keep execute operator phases explicit: validate inputs, update owned state, then publish the result.
  arguments = qcmd.tokenize(text)
  if len(arguments) == 0 then return "" end if
  command = arguments[0]
  if qtext.equalInsensitive(command, "sv") then
    return nsadmin.serverCommand(runtime.administration, arguments)
  end if
  if qtext.equalInsensitive(command, "status") then return operatorStatus(runtime) end if
  if qtext.equalInsensitive(command, "dumpuser") then
    if len(arguments) != 2 then return "Usage: dumpuser <userid>\n" end if
    slot = operatorClientSlot(runtime, arguments[1])
    if slot < 0 then return "Couldn't find user " + arguments[1] + "\n" end if
    return operatorDumpUser(runtime, slot)
  end if
  if qtext.equalInsensitive(command, "kick") then
    if len(arguments) != 2 then return "Usage: kick <userid>\n" end if
    slot = operatorClientSlot(runtime, arguments[1])
    if slot < 0 then return "Couldn't find user " + arguments[1] + "\n" end if
    name = runtime.server.clients[slot].name
    runtime.deferredReliable[slot] = []
    runtime.callbacks.clientDisconnect(slot)
    nserver.dropClient(runtime.server, slot, runtime.server.realTime, false)
    return "Kicked " + name + ".\n"
  end if
  if qtext.equalInsensitive(command, "serverinfo") then
    return "Server info settings:\n" + runtime.server.serverInfo + "\n"
  end if
  if qtext.equalInsensitive(command, "heartbeat") then
    runtime.server.lastHeartbeat = runtime.server.realTime - nc.HEARTBEAT_MSEC
    return "Heartbeat forced.\n"
  end if
  if qtext.equalInsensitive(command, "setmaster") then
    if not runtime.server.dedicated then return "Only dedicated servers use masters.\n" end if
    configured = try(nsadmin.configureMasters(runtime.administration, arguments, 1))
    if configured is error then return "Bad master address.\n" end if
    runtime.server.publicServer = len(runtime.administration.masters) > 0
    runtime.server.lastHeartbeat = runtime.server.realTime - nc.HEARTBEAT_MSEC
    return configured
  end if
  if qtext.equalInsensitive(command, "set") and len(arguments) >= 3 then
    variable = arguments[1]
    if qtext.equalInsensitive(variable, "filterban") then
      changed = try(nsadmin.setFilterBan(runtime.administration, arguments[2]))
      if changed is error then return "filterban must be 0 or 1.\n" end if
      return "filterban set.\n"
    end if
    if qtext.equalInsensitive(variable, "rcon_password") then
      changed = try(nsadmin.setRconPassword(runtime.administration, arguments[2]))
      if changed is error then return "rcon_password rejected by policy.\n" end if
      return "rcon_password updated.\n"
    end if
  end if
  if qtext.equalInsensitive(command, "filterban") then
    if len(arguments) == 1 then
      value = 0
      if runtime.administration.filterBan then value = 1 end if
      return "filterban is " + value + "\n"
    end if
    changed = try(nsadmin.setFilterBan(runtime.administration, arguments[1]))
    if changed is error then return "filterban must be 0 or 1.\n" end if
    return "filterban set.\n"
  end if
  if qtext.equalInsensitive(command, "rcon_password") then
    if len(arguments) == 1 then
      if runtime.administration.rconPassword == "" then return "rcon_password is disabled.\n" end if
      return "rcon_password is configured.\n"
    end if
    changed = try(nsadmin.setRconPassword(runtime.administration, arguments[1]))
    if changed is error then return "rcon_password rejected by policy.\n" end if
    return "rcon_password updated.\n"
  end if
  return "Unknown command \"" + command + "\"\n"
end function

/// Handle rcon.
/// @param runtime runtime value consumed by this operation.
/// @param address address value consumed by this operation.
/// @param request request value consumed by this operation.
function handleRcon(runtime, address, request)
  supplied = ""
  if len(request.arguments) >= 2 then supplied = request.arguments[1] end if
  valid = nsadmin.rconValid(runtime.administration, supplied)
  if not valid then
    runtime.administration.rconRejected = runtime.administration.rconRejected + 1
    output = "Bad rcon_password.\n"
    action = nt.action("print", naddress.copy(address),
      nconnectionless.printReply(output), -1, "rcon-rejected")
    return nt.result(false, -1, [action], "rcon-rejected", void)
  end if
  runtime.administration.rconAccepted = runtime.administration.rconAccepted + 1
  commandText = joinedArguments(request.arguments, 2)
  output = executeOperator(runtime, commandText)
  // SV_OUTPUTBUF_LENGTH is 1024 in the original.  Retaining that boundary
  // also prevents a small spoofed request from producing a large UDP reply.
  output = nconnectionless.truncateText(output, 1024)
  action = nt.action("print", naddress.copy(address),
    nconnectionless.printReply(output), -1, "rcon")
  return nt.result(true, -1, [action], "rcon", void)
end function

/// Handles connectionless for the miniquake2 network runtime commands workflow.
/// @param runtime runtime value consumed by this operation.
/// @param address address value consumed by this operation.
/// @param datagram datagram value consumed by this operation.
/// @param now now value consumed by this operation.
function handleConnectionless(runtime, address, datagram, now)
  request = nconnectionless.parsePacket(datagram)
  runtime.server.realTime = now
  if request.command == "rcon" then return handleRcon(runtime, address, request) end if
  if request.command == "connect" and
      nsadmin.filterPacket(runtime.administration, address) then
    action = nt.action("print", naddress.copy(address),
      nconnectionless.printReply("Connection refused.\n"), -1, "ip-filter")
    return nt.result(false, -1, [action], "ip-filter", void)
  end if
  result = nserver.handleConnectionless(runtime.server, address, datagram, now)
  if not result.accepted or result.message != "connected" or result.slot < 0 then return result end if
  slot = result.slot
  runtime.deferredReliable[slot] = []
  runtime.transfers[slot] = nrtypes.DownloadTransfer("", bytes(), -1)
  userInfo = runtime.server.clients[slot].userInfo
  if runtime.callbacks.clientConnect(slot, userInfo) then return result end if
  runtime.server.clients[slot] = nserver.emptyClient(slot)
  action = nt.action("print", naddress.copy(address),
    nconnectionless.printReply("Connection refused by game.\n"), -1, "game-veto")
  return nt.result(false, -1, [action], "game-veto", void)
end function
