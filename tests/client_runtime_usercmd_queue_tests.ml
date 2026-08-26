/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* ClientSession UI command queue and exact cmd-2/cmd-1/cmd wire order. */
import miniquake2.platform.system as csutime
import miniquake2.platform.udp as csuudp
import miniquake2.qcommon.constants as csuqc
import miniquake2.qcommon.message as csuqmsg
import miniquake2.qcommon.sizebuf as csuqsz
import miniquake2.qcommon.types as csuqt
import miniquake2.protocol.constants as csupc
import miniquake2.protocol.netchan as csunetchan
import miniquake2.protocol.packet as csupacket
import miniquake2.protocol.usercmd as csuusercmd
import miniquake2.network.constants as csunc
import miniquake2.runtime.client_session as csusession

function cmdAssert(value, name)
  if not value then return error(8375, name) end if
  return true
end function

function receivePayload(socket)
  attempt = 0
  while not csuudp.pending(socket) and attempt < 100
    csutime.sleep(1)
    attempt = attempt + 1
  end while
  cmdAssert(csuudp.pending(socket), "client move datagram did not arrive")
  datagram = csuudp.receive(socket, csupc.MAX_MSGLEN)
  return csupacket.decodePacket(datagram.data, true).payload
end function

function decodeTriplet(payload)
  buffer = csuqsz.alloc(len(payload))
  csuqsz.writeBytes(buffer, payload)
  csuqmsg.beginReading(buffer)
  cmdAssert(csuqmsg.readByte(buffer) == csuqc.CLC_MOVE, "payload is not clc_move")
  checksum = csuqmsg.readByte(buffer)
  lastFrame = csuqmsg.readLong(buffer)
  oldest = csuusercmd.readDelta(buffer, csuqt.zeroUserCmd())
  previous = csuusercmd.readDelta(buffer, oldest)
  current = csuusercmd.readDelta(buffer, previous)
  cmdAssert(buffer.readCount == buffer.curSize, "clc_move was not consumed exactly")
  return [oldest, previous, current, checksum, lastFrame]
end function

cmdAssert(not csusession.movementDue(100, 110) and
  csusession.movementDue(100, 111),
  "classic 90-Hz client command pacing")

serverSocket = csuudp.open("127.0.0.1", 0)
session = csusession.create("127.0.0.1", serverSocket.port, "\\name\\CmdQueue", 0)
session.integrated.network.client.state = csunc.CA_ACTIVE
session.integrated.network.client.channel = csunetchan.setup(csupc.NS_CLIENT,
  session.integrated.network.client.serverAddress, session.integrated.network.client.qport, 0)
pendingArrayIdentity = nativeRawValue(session.pendingCommands)
pendingZeroIdentity = nativeRawValue(session.pendingCommands[0])
historyArrayIdentity = nativeRawValue(session.commandHistory)
historyOneIdentity = nativeRawValue(session.commandHistory[1])
previousIdentity = nativeRawValue(session.previousCommand)
lastIdentity = nativeRawValue(session.lastCommand)
moveBufferIdentity = nativeRawValue(session.moveBuffer)

first = csuqt.UserCmd(11, 1, [101, 102, 103], 111, 112, 113, 2, 3)
second = csuqt.UserCmd(22, 4, [201, 202, 203], 221.75, 222.5, 223.25, 5, 6)
third = csuqt.UserCmd(33, 7, [301, 302, 303], 331, 332, 333, 8, 9)
csusession.setUserCmd(session, first)
csusession.queueUserCmd(session, second)
csusession.queueUserCmd(session, third)
first.forwardMove = 999
cmdAssert(csusession.pendingUserCmds(session) == 3, "queue length mismatch")

csusession.sendMove(session, 10)
wire1 = decodeTriplet(receivePayload(serverSocket))
cmdAssert(wire1[0].msec == 0 and wire1[1].msec == 0 and wire1[2].forwardMove == 111,
  "first move triplet mismatch")

csusession.sendMove(session, 11)
wire2 = decodeTriplet(receivePayload(serverSocket))
cmdAssert(wire2[0].msec == 0 and wire2[1].forwardMove == 111 and wire2[2].forwardMove == 221,
  "second move triplet mismatch")

csusession.sendMove(session, 12)
wire3 = decodeTriplet(receivePayload(serverSocket))
cmdAssert(wire3[0].forwardMove == 111 and wire3[1].forwardMove == 221 and
  wire3[2].forwardMove == 331, "third move triplet mismatch")
cmdAssert(session.previousCommand.forwardMove == 221 and session.lastCommand.forwardMove == 331,
  "client history did not shift")
cmdAssert(csusession.pendingUserCmds(session) == 0, "queue did not drain")

predictionScratch = session.predictionCommandScratch
predictionScratchIdentity = nativeRawValue(predictionScratch)
preview = csuqt.UserCmd(8, 0, [0, 0, 0], 440, 0, 0, 0, 0)
predictionCount = csusession.fillPredictionCommands(session, preview,
  predictionScratch)
cmdAssert(predictionCount == 4,
  "prediction scratch did not include three unacked commands and preview")
preview.forwardMove = 441
cmdAssert(predictionScratch[predictionCount - 1].forwardMove == 441,
  "prediction preview should be consumed without a deep copy")
predictionCount = csusession.fillPredictionCommands(session, preview,
  session.predictionCommandScratch)
cmdAssert(nativeRawValue(session.predictionCommandScratch) ==
    predictionScratchIdentity and predictionCount == 4,
  "remote session retains prediction command scratch identity")

// The old headless behavior remains the deterministic fallback.
csusession.sendMove(session, 13)
wire4 = decodeTriplet(receivePayload(serverSocket))
cmdAssert(wire4[0].forwardMove == 221 and wire4[1].forwardMove == 331 and
  wire4[2].msec == 100 and wire4[2].forwardMove == 0, "headless fallback mismatch")
cmdAssert(nativeRawValue(session.pendingCommands) == pendingArrayIdentity and
    nativeRawValue(session.pendingCommands[0]) == pendingZeroIdentity and
    nativeRawValue(session.commandHistory) == historyArrayIdentity and
    nativeRawValue(session.commandHistory[1]) == historyOneIdentity and
    nativeRawValue(session.previousCommand) == previousIdentity and
    nativeRawValue(session.lastCommand) == lastIdentity and
    nativeRawValue(session.moveBuffer) == moveBufferIdentity,
  "90-Hz usercmd path replaced session-owned scratch storage")

csusession.resetMapInput(session)
cmdAssert(nativeRawValue(session.pendingCommands) == pendingArrayIdentity and
    nativeRawValue(session.pendingCommands[0]) == pendingZeroIdentity and
    nativeRawValue(session.commandHistory) == historyArrayIdentity and
    nativeRawValue(session.commandHistory[1]) == historyOneIdentity and
    nativeRawValue(session.previousCommand) == previousIdentity and
    nativeRawValue(session.lastCommand) == lastIdentity,
  "map input reset replaced reusable command storage")

csusession.shutdown(session)
attempt = 0
while not csuudp.pending(serverSocket) and attempt < 100
  csutime.sleep(1)
  attempt = attempt + 1
end while
cmdAssert(csuudp.pending(serverSocket), "disconnect datagrams did not arrive")
csuudp.close(serverSocket)
print("client_runtime_usercmd_queue_tests: PASS")
