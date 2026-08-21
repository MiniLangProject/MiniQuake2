/* Asset-free protocol-34 runtime codec and command-dispatch tests. */
import miniquake2.qcommon.constants as qc
import miniquake2.qcommon.types as qt
import miniquake2.qcommon.sizebuf as qsz
import miniquake2.protocol.types as pt
import miniquake2.protocol.netchan as pnetchan
import miniquake2.network.constants as nc
import miniquake2.network.connectionless as nconnectionless
import miniquake2.network.client as nclient
import miniquake2.network.server as nserver
import miniquake2.network.runtime.types as nrtypes
import miniquake2.network.runtime.game_adapter as rgame
import miniquake2.network.runtime.messages as rmessages
import miniquake2.network.runtime.commands as rcommands

connectCalls = 0
userinfoCalls = 0
thinkCalls = 0
commandCalls = 0
beginCalls = 0
vetoCalls = 0
lastCommandText = ""

function onConnect(slot, userInfo)
  global connectCalls
  connectCalls = connectCalls + 1
  return true
end function

function onUserinfo(slot, userInfo)
  global userinfoCalls
  userinfoCalls = userinfoCalls + 1
  return true
end function

function onThink(slot, command)
  global thinkCalls
  thinkCalls = thinkCalls + 1
  return true
end function

function onCommand(slot, text)
  global commandCalls, lastCommandText
  commandCalls = commandCalls + 1
  lastCommandText = text
  return true
end function

function onBegin(slot)
  global beginCalls
  beginCalls = beginCalls + 1
  return true
end function

function vetoConnect(slot, userInfo)
  global vetoCalls
  vetoCalls = vetoCalls + 1
  return false
end function

function assertEqual(actual, expected, name)
  if actual != expected then return error(7980, name + ": expected " + expected + ", got " + actual) end if
  return true
end function

function assertTrue(value, name)
  if value != true then return error(7981, name + ": expected true") end if
  return true
end function

function makeServerRuntime()
  server = nserver.create(2, "Runtime Test", "unit1", "\\hostname\\Runtime Test", false, false)
  callbacks = rgame.create(onConnect, onUserinfo, onThink, onCommand, onBegin)
  runtime = nrtypes.createServer(server, 77, "baseq2", "Unit One", callbacks)
  runtime.configStrings[qc.CS_NAME] = "Unit One"
  return runtime
end function

function testServerMessageCodecs()
  client = nclient.create(0x1234, 5000)
  runtime = nrtypes.createClient(client)
  buffer = qsz.alloc(512)
  rmessages.writeServerData(buffer, 77, false, "baseq2", 0, "Unit One")
  rmessages.writeConfigString(buffer, qc.CS_NAME, "Unit One")
  baseline = pt.zeroEntityState()
  baseline.number = 9
  baseline.modelIndex = 3
  baseline.origin[0] = 12.5
  rmessages.writeSpawnBaseline(buffer, baseline)
  rmessages.writeStuffText(buffer, "cmd configstrings 77 0\n")
  rmessages.writeDownload(buffer, bytes([1, 2, 3, 4]), 1, 2, 50)
  rmessages.parsePayload(runtime, qsz.dataSlice(buffer))
  assertEqual(runtime.protocol, 34, "serverdata protocol")
  assertEqual(runtime.spawnCount, 77, "serverdata spawn count")
  assertEqual(runtime.configStrings[qc.CS_NAME], "Unit One", "configstring parsed")
  assertEqual(runtime.baselines[9].modelIndex, 3, "baseline parsed")
  assertEqual(runtime.baselines[9].origin[0], 12.5, "baseline coordinate parsed")
  assertEqual(runtime.stuffedTexts[0], "cmd configstrings 77 0\n", "stufftext parsed")
  assertEqual(len(runtime.downloadData), 2, "download bytes parsed")
  assertEqual(runtime.downloadData[0], 2, "download first byte")
  assertEqual(runtime.downloadPercent, 50, "download percent")
  assertTrue(try(rmessages.parsePayload(runtime, bytes([qc.SVC_CONFIGSTRING, 0]))) is error,
    "truncated configstring rejected")
  return true
end function

function testCommandsAndMove()
  global userinfoCalls, thinkCalls, commandCalls, beginCalls
  runtime = makeServerRuntime()
  client = runtime.server.clients[0]
  client.state = nc.CS_SPAWNED
  client.channel = pnetchan.setup(1,
    qt.NetAddress(nc.NA_IP, [127, 0, 0, 1], array(10, 0), 30000), 0x1234, 0)
  runtime.server.clients[0] = client

  payload = qsz.alloc(512)
  rcommands.writeUserInfo(payload, "\\name\\Marine")
  rcommands.writeStringCommand(payload, "say integration")
  oldest = qt.UserCmd(10, 0, [1, 2, 3], 100, 0, 0, 0, 10)
  oldCommand = qt.UserCmd(11, 1, [2, 3, 4], 110, 2, 0, 0, 11)
  newCommand = qt.UserCmd(12, 1, [3, 4, 5], 120, 3, 1, 0, 12)
  goldenMove = qsz.alloc(128)
  rcommands.writeMove(goldenMove, 19, 4, oldest, oldCommand, newCommand)
  assertEqual(goldenMove.data[0], qc.CLC_MOVE, "C golden move opcode")
  assertEqual(goldenMove.data[1], 0x22, "C golden COM_BlockSequenceCRCByte")
  rcommands.writeMove(payload, 19, 4, oldest, oldCommand, newCommand)
  rcommands.parseClientPayload(runtime, 0, qsz.dataSlice(payload), 19, 2, false)
  assertEqual(userinfoCalls, 1, "userinfo callback")
  assertEqual(runtime.server.clients[0].name, "Marine", "userinfo name update")
  assertEqual(commandCalls, 1, "game command callback")
  assertEqual(thinkCalls, 3, "dropped command recovery callbacks")
  assertEqual(runtime.lastCommands[0].forwardMove, 120, "last command retained")
  corruptMove = qsz.dataSlice(goldenMove)
  corruptMove[len(corruptMove) - 1] = corruptMove[len(corruptMove) - 1] ^ 1
  assertTrue(try(rcommands.parseClientPayload(runtime, 0, corruptMove, 19, 0, false)) is error,
    "corrupt move checksum rejected")

  rcommands.executeString(runtime, 0, "begin 77")
  assertEqual(beginCalls, 0, "already spawned begin ignored")
  runtime.server.clients[0].state = nc.CS_CONNECTED
  rcommands.executeString(runtime, 0, "begin 77")
  assertEqual(beginCalls, 1, "begin callback")
  return true
end function

function testConnectVeto()
  global vetoCalls
  server = nserver.create(1, "Veto", "unit1", "\\hostname\\Veto", false, false)
  callbacks = rgame.create(vetoConnect, onUserinfo, onThink, onCommand, onBegin)
  runtime = nrtypes.createServer(server, 1, "baseq2", "Veto", callbacks)
  address = qt.NetAddress(nc.NA_IP, [10, 1, 2, 3], array(10, 0), 31000)
  challenge = rcommands.handleConnectionless(runtime, address, nconnectionless.getChallenge(), 1)
  connectPacket = nconnectionless.connect(0x2222, challenge.payload, "\\name\\Rejected")
  refused = rcommands.handleConnectionless(runtime, address, connectPacket, 2)
  assertTrue(not refused.accepted, "game veto rejects connect")
  assertEqual(refused.message, "game-veto", "game veto result")
  assertEqual(runtime.server.clients[0].state, nc.CS_FREE, "veto releases slot")
  assertEqual(vetoCalls, 1, "connect veto callback")
  return true
end function

function testDownloads()
  runtime = makeServerRuntime()
  client = runtime.server.clients[0]
  client.state = nc.CS_CONNECTED
  client.channel = pnetchan.setup(1,
    qt.NetAddress(nc.NA_IP, [127, 0, 0, 1], array(10, 0), 30000), 0x1234, 0)
  runtime.server.clients[0] = client
  data = bytes(1030)
  index = 0
  while index < len(data)
    data[index] = index & 255
    index = index + 1
  end while
  rcommands.registerDownload(runtime, "maps/unit.bsp", data)
  assertTrue(rcommands.beginDownload(runtime, 0, "maps/unit.bsp", 0), "download starts")
  assertTrue(runtime.transfers[0].offset >= 0, "download remains after first chunk")
  rcommands.queueDownloadChunk(runtime, 0)
  assertEqual(runtime.transfers[0].offset, -1, "download completes")
  assertTrue(try(rcommands.registerDownload(runtime, "../secret", bytes([1]))) is error,
    "unsafe download rejected")
  return true
end function

testServerMessageCodecs()
testCommandsAndMove()
testDownloads()
testConnectVeto()
print "network_runtime_messages_tests: PASS"
