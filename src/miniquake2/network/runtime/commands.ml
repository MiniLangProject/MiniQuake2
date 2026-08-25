/* Client command encoding and server-side clc dispatch from sv_user.c. */
package miniquake2.network.runtime.commands

import miniquake2.qcommon.constants as qc
import miniquake2.qcommon.types as qt
import miniquake2.qcommon.byteio as qbio
import miniquake2.qcommon.message as qmsg
import miniquake2.qcommon.sizebuf as qsz
import miniquake2.qcommon.info as qinfo
import miniquake2.qcommon.cmd as qcmd
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

const MAX_NETWORK_COMMAND_LOG = 1024

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

const MAX_STRING_COMMANDS = 8
const DOWNLOAD_CHUNK = 1024
const MAX_DEFERRED_RELIABLE_WORK = 16
const RELIABLE_WORK_CONFIGSTRINGS = 1
const RELIABLE_WORK_BASELINES = 2
const RELIABLE_WORK_DOWNLOAD = 3

function writeUserInfo(buffer, userInfo)
  if not qinfo.validate(userInfo) then return error(7250, "invalid clc_userinfo string") end if
  qmsg.writeByte(buffer, qc.CLC_USERINFO)
  qmsg.writeString(buffer, userInfo)
  return buffer
end function

function writeStringCommand(buffer, command)
  if typeof(command) != "string" or len(bytes(command)) >= qc.MAX_STRING_CHARS then return error(7251, "invalid clc_stringcmd") end if
  qmsg.writeByte(buffer, qc.CLC_STRINGCMD)
  qmsg.writeString(buffer, command)
  return buffer
end function

function writeMove(buffer, sequence, lastFrame, oldest, oldCommand, newCommand)
  if typeof(sequence) != "int" or sequence < 0 then return error(7252, "move sequence must be non-negative") end if
  qmsg.writeByte(buffer, qc.CLC_MOVE)
  checksumIndex = buffer.curSize
  qmsg.writeByte(buffer, 0)
  qmsg.writeLong(buffer, lastFrame)
  pusercmd.writeDelta(buffer, qt.zeroUserCmd(), oldest)
  pusercmd.writeDelta(buffer, oldest, oldCommand)
  pusercmd.writeDelta(buffer, oldCommand, newCommand)
  buffer.data[checksumIndex] = rchecksum.blockSequence(buffer.data, checksumIndex + 1,
    buffer.curSize - checksumIndex - 1, sequence)
  return buffer
end function

function containsTraversal(name)
  value = bytes(name)
  index = 0
  while index + 1 < len(value)
    if value[index] == 46 and value[index + 1] == 46 then return true end if
    index = index + 1
  end while
  return false
end function

function hasSubdirectory(name)
  value = bytes(name)
  for each character in value
    if character == 47 then return true end if
  end for
  return false
end function

function safeDownloadName(name)
  if typeof(name) != "string" or name == "" or len(bytes(name)) >= qc.MAX_QPATH then return false end if
  value = bytes(name)
  if value[0] == 46 or value[0] == 47 or value[0] == 92 then return false end if
  return not containsTraversal(name) and hasSubdirectory(name)
end function

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

function findDownload(runtime, name)
  for each entry in runtime.downloads
    if entry.name == name then return entry.data end if
  end for
  return void
end function

function serverDataFragments(runtime, slot)
  buffer = qsz.alloc(pc.RELIABLE_BUFFER_SIZE)
  rmessages.writeServerData(buffer, runtime.spawnCount,
    runtime.server.attractLoop, runtime.gameDir, slot, runtime.levelName)
  rmessages.writeStuffText(buffer, "cmd configstrings " + runtime.spawnCount + " 0\n")
  return [qsz.dataSlice(buffer)]
end function

function configStringFragment(index, value)
  buffer = qsz.alloc(pc.RELIABLE_BUFFER_SIZE)
  rmessages.writeConfigString(buffer, index, value)
  return qsz.dataSlice(buffer)
end function

function stuffTextFragment(text)
  buffer = qsz.alloc(pc.RELIABLE_BUFFER_SIZE)
  rmessages.writeStuffText(buffer, text)
  return qsz.dataSlice(buffer)
end function

function baselineFragment(baseline)
  buffer = qsz.alloc(256)
  rmessages.writeSpawnBaseline(buffer, baseline)
  return qsz.dataSlice(buffer)
end function

function downloadFragment(data, offset, count, percent)
  buffer = qsz.alloc(pc.RELIABLE_BUFFER_SIZE)
  rmessages.writeDownload(buffer, data, offset, count, percent)
  return qsz.dataSlice(buffer)
end function

function queueServerData(runtime, slot)
  client = runtime.server.clients[slot]
  if client.state != nc.CS_CONNECTED then return false end if
  queued = pnetchan.queueReliableFragments(client.channel,
    serverDataFragments(runtime, slot))
  if queued == false then return false end if
  runtime.lastCommands[slot] = qt.zeroUserCmd()
  return true
end function

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

// Client string commands are themselves reliably acknowledged before their
// server response necessarily fits.  Retain a bounded typed retry record so
// backpressure cannot consume config/baseline/download requests.
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

function replenishCommandMsec(runtime)
  index = 0
  while index < runtime.server.maxClients
    runtime.commandMsec[index] = 1800
    index = index + 1
  end while
  return true
end function

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

function integerArgument(arguments, index)
  if index >= len(arguments) then return 0 end if
  return nconnectionless.parseDecimal(arguments[index])
end function

// CL_Disconnect in the 3.19 client transmits strlen(final), deliberately
// omitting the strcpy terminator. Accept only that one exact terminal command;
// every other clc_stringcmd still requires regular NUL framing.
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

function executeString(runtime, slot, text)
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

function applyThink(runtime, slot, command)
  runtime.commandMsec[slot] = runtime.commandMsec[slot] - command.msec
  if runtime.commandMsec[slot] < 0 then return false end if
  return runtime.callbacks.clientThink(slot, command)
end function

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
      oldest = pusercmd.readDelta(buffer, qt.zeroUserCmd())
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

function handleConnectionless(runtime, address, datagram, now)
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
