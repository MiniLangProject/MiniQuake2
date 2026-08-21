/* Strict server-message writers and client dispatch for protocol 34. */
package miniquake2.network.runtime.messages

import miniquake2.qcommon.constants as qc
import miniquake2.qcommon.byteio as qbio
import miniquake2.qcommon.message as qmsg
import miniquake2.qcommon.sizebuf as qsz
import miniquake2.protocol.constants as pc
import miniquake2.protocol.types as pt
import miniquake2.protocol.checked as pchecked
import miniquake2.protocol.entity_delta as pentity
import miniquake2.network.constants as nc
import miniquake2.network.client as nclient
import miniquake2.network.runtime.types as nrtypes

function readingBuffer(data)
  if typeof(data) != "bytes" or len(data) > pc.MAX_MSGLEN then return error(7220, "server payload outside MAX_MSGLEN") end if
  buffer = qsz.alloc(len(data))
  qsz.writeBytes(buffer, data)
  qmsg.beginReading(buffer)
  return buffer
end function

function readString(buffer, operation, maximum)
  if typeof(maximum) != "int" or maximum < 1 then return error(7221, operation + ": invalid string limit") end if
  start = buffer.readCount
  index = start
  while index < buffer.curSize and buffer.data[index] != 0 and index - start < maximum
    index = index + 1
  end while
  if index >= buffer.curSize then return error(7222, operation + ": unterminated string") end if
  if index - start >= maximum and buffer.data[index] != 0 then return error(7223, operation + ": string exceeds limit") end if
  output = decode(slice(buffer.data, start, index - start))
  buffer.readCount = index + 1
  return output
end function

function appendBytes(first, second)
  output = bytes(len(first) + len(second))
  if len(first) > 0 then qbio.copyInto(output, 0, first, 0, len(first)) end if
  if len(second) > 0 then qbio.copyInto(output, len(first), second, 0, len(second)) end if
  return output
end function

function writeServerData(buffer, spawnCount, attractLoop, gameDir, playerNumber, levelName)
  if typeof(spawnCount) != "int" or typeof(playerNumber) != "int" then return error(7236, "serverdata numeric fields must be integers") end if
  if typeof(gameDir) != "string" or len(bytes(gameDir)) >= qc.MAX_QPATH or
      typeof(levelName) != "string" or len(bytes(levelName)) >= qc.MAX_STRING_CHARS then
    return error(7237, "serverdata string exceeds protocol limit")
  end if
  qmsg.writeByte(buffer, qc.SVC_SERVERDATA)
  qmsg.writeLong(buffer, qc.PROTOCOL_VERSION)
  qmsg.writeLong(buffer, spawnCount)
  attractValue = 0
  if attractLoop then attractValue = 1 end if
  qmsg.writeByte(buffer, attractValue)
  qmsg.writeString(buffer, gameDir)
  qmsg.writeShort(buffer, playerNumber)
  qmsg.writeString(buffer, levelName)
  return buffer
end function

function writeConfigString(buffer, index, value)
  if typeof(index) != "int" or index < 0 or index >= qc.MAX_CONFIGSTRINGS then return error(7224, "configstring index outside range") end if
  if typeof(value) != "string" or len(bytes(value)) >= qc.MAX_STRING_CHARS then return error(7225, "configstring is invalid") end if
  qmsg.writeByte(buffer, qc.SVC_CONFIGSTRING)
  qmsg.writeShort(buffer, index)
  qmsg.writeString(buffer, value)
  return buffer
end function

function writeSpawnBaseline(buffer, state)
  if state.number <= 0 or state.number >= pc.MAX_EDICTS then return error(7226, "baseline entity number outside range") end if
  qmsg.writeByte(buffer, qc.SVC_SPAWNBASELINE)
  pentity.writeDelta(buffer, pt.zeroEntityState(), state, true, true)
  return buffer
end function

function writeStuffText(buffer, text)
  if typeof(text) != "string" or len(bytes(text)) >= qc.MAX_STRING_CHARS then return error(7227, "stufftext is invalid") end if
  qmsg.writeByte(buffer, qc.SVC_STUFFTEXT)
  qmsg.writeString(buffer, text)
  return buffer
end function

function writeDownload(buffer, data, offset, count, percent)
  if count < -1 or count > 1024 or percent < 0 or percent > 100 then return error(7228, "download chunk metadata is invalid") end if
  if count >= 0 then qbio.requireRange(data, offset, count) end if
  qmsg.writeByte(buffer, qc.SVC_DOWNLOAD)
  qmsg.writeShort(buffer, count)
  qmsg.writeByte(buffer, percent)
  if count > 0 then qsz.write(buffer, data, offset, count) end if
  return buffer
end function

function parseServerData(runtime, buffer)
  version = pchecked.readLong(buffer, "serverdata protocol")
  if version != qc.PROTOCOL_VERSION then return error(7229, "server uses unsupported protocol " + version) end if
  spawnCount = pchecked.readLong(buffer, "serverdata spawn count")
  attract = pchecked.readByte(buffer, "serverdata attract loop")
  if attract != 0 and attract != 1 then return error(7230, "serverdata attract loop is not boolean") end if
  gameDir = readString(buffer, "serverdata game directory", qc.MAX_QPATH)
  playerNumber = pchecked.readShort(buffer, "serverdata player number")
  levelName = readString(buffer, "serverdata level name", qc.MAX_STRING_CHARS)
  // Commit only after the complete variable-length command validated.
  runtime.protocol = version
  runtime.spawnCount = spawnCount
  runtime.attractLoop = attract == 1
  runtime.gameDir = gameDir
  runtime.playerNumber = playerNumber
  runtime.levelName = levelName
  runtime.configStrings = array(qc.MAX_CONFIGSTRINGS, "")
  runtime.baselines = nrtypes.makeBaselines()
  runtime.stuffedTexts = []
  runtime.downloadData = bytes()
  runtime.downloadPercent = 0
  runtime.downloadMissing = false
  runtime.client.frames = array(nc.UPDATE_BACKUP, void)
  runtime.client.currentFrame = void
  if runtime.client.state >= nc.CA_CONNECTED then runtime.client.state = nc.CA_CONNECTED end if
  return true
end function

function parsePayload(runtime, payload)
  buffer = readingBuffer(payload)
  while buffer.readCount < buffer.curSize
    opcode = pchecked.readByte(buffer, "server command")
    if opcode == qc.SVC_NOP then
      // no payload
    else if opcode == qc.SVC_SERVERDATA then
      parseServerData(runtime, buffer)
    else if opcode == qc.SVC_CONFIGSTRING then
      index = pchecked.readShort(buffer, "configstring index")
      if index < 0 or index >= qc.MAX_CONFIGSTRINGS then return error(7231, "configstring index outside range") end if
      runtime.configStrings[index] = readString(buffer, "configstring value", qc.MAX_STRING_CHARS)
    else if opcode == qc.SVC_SPAWNBASELINE then
      header = pentity.readHeader(buffer)
      if header.endMarker or header.remove or header.number <= 0 then return error(7232, "invalid spawnbaseline header") end if
      runtime.baselines[header.number] = pentity.readDelta(buffer, pt.zeroEntityState(), header)
    else if opcode == qc.SVC_STUFFTEXT then
      runtime.stuffedTexts = runtime.stuffedTexts + [readString(buffer, "stufftext", qc.MAX_STRING_CHARS)]
    else if opcode == qc.SVC_DOWNLOAD then
      count = pchecked.readShort(buffer, "download size")
      percent = pchecked.readByte(buffer, "download percent")
      if percent < 0 or percent > 100 then return error(7233, "download percent outside range") end if
      if count == -1 then
        runtime.downloadMissing = true
        runtime.downloadData = bytes()
      else
        if count < 0 or count > 1024 then return error(7234, "download chunk size outside range") end if
        runtime.downloadData = appendBytes(runtime.downloadData, pchecked.readBytes(buffer, count, "download data"))
        runtime.downloadMissing = false
      end if
      runtime.downloadPercent = percent
    else if opcode == qc.SVC_FRAME then
      nclient.parseFrame(runtime.client, buffer, runtime.baselines)
    else if opcode == qc.SVC_DISCONNECT then
      runtime.client.state = nc.CA_DISCONNECTED
      runtime.client.channel = void
    else if opcode == qc.SVC_RECONNECT then
      runtime.client.state = nc.CA_CONNECTING
      runtime.client.channel = void
      runtime.client.connectTime = -99999
      runtime.client.frames = array(nc.UPDATE_BACKUP, void)
      runtime.client.currentFrame = void
      runtime.configStrings = array(qc.MAX_CONFIGSTRINGS, "")
      runtime.baselines = nrtypes.makeBaselines()
      runtime.stuffedTexts = []
      runtime.downloadData = bytes()
      runtime.downloadPercent = 0
      runtime.downloadMissing = false
      runtime.ackPending = false
    else
      return error(7235, "unsupported or malformed server command " + opcode)
    end if
    runtime.parsedMessages = runtime.parsedMessages + 1
  end while
  return runtime.parsedMessages
end function
