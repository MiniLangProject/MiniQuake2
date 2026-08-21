/*
Bidirectional external-wire harness.  The peer side constructs classic
Protocol-34 bytes directly instead of calling MiniQuake2 connection/Netchan
encoders, so transport-facing regressions cannot self-confirm through the same
high-level implementation on both ends.
*/
import miniquake2.platform.system as extwire_system
import miniquake2.platform.udp as extwire_udp
import miniquake2.qcommon.byteio as extwire_byteio
import miniquake2.qcommon.cmd as extwire_cmd
import miniquake2.qcommon.constants as extwire_qconstants
import miniquake2.qcommon.message as extwire_message
import miniquake2.qcommon.sizebuf as extwire_sizebuf
import miniquake2.qcommon.types as extwire_qtypes
import miniquake2.protocol.constants as extwire_pconstants
import miniquake2.network.constants as extwire_nconstants
import miniquake2.network.client as extwire_client
import miniquake2.network.server as extwire_server
import miniquake2.network.runtime.game_adapter as extwire_adapter
import miniquake2.network.runtime.pump as extwire_pump
import miniquake2.network.runtime.types as extwire_rtypes

function externalWireAssert(value, name)
  if not value then return error(8510, name) end if
  return true
end function

function receiveExternal(socket)
  attempt = 0
  while not extwire_udp.pending(socket) and attempt < 200
    extwire_system.sleep(1)
    attempt = attempt + 1
  end while
  if not extwire_udp.pending(socket) then return error(8511, "external UDP receive timed out") end if
  return extwire_udp.receive(socket, extwire_pconstants.MAX_MSGLEN)
end function

function classicConnectionless(text)
  body = bytes(text)
  output = bytes(4 + len(body))
  extwire_byteio.putU32(output, 0, extwire_pconstants.CONNECTIONLESS_SEQUENCE)
  if len(body) > 0 then extwire_byteio.copyInto(output, 4, body, 0, len(body)) end if
  return output
end function

function classicConnectionlessText(packet)
  externalWireAssert(len(packet) >= 4 and
    extwire_byteio.u32(packet, 0) == extwire_pconstants.CONNECTIONLESS_SEQUENCE,
    "expected classic connectionless packet")
  return decode(slice(packet, 4, len(packet) - 4))
end function

function classicPacket(sequence, reliable, acknowledge, reliableAck, qport, hasQport, payload)
  headerLength = extwire_pconstants.PACKET_HEADER_SERVER
  if hasQport then headerLength = extwire_pconstants.PACKET_HEADER_CLIENT end if
  output = bytes(headerLength + len(payload))
  sequenceWord = sequence
  acknowledgeWord = acknowledge
  if reliable then sequenceWord = sequenceWord | extwire_pconstants.SEQUENCE_RELIABLE_BIT end if
  if reliableAck then acknowledgeWord = acknowledgeWord | extwire_pconstants.SEQUENCE_RELIABLE_BIT end if
  extwire_byteio.putU32(output, 0, sequenceWord)
  extwire_byteio.putU32(output, 4, acknowledgeWord)
  if hasQport then extwire_byteio.putU16(output, 8, qport) end if
  if len(payload) > 0 then
    extwire_byteio.copyInto(output, headerLength, payload, 0, len(payload))
  end if
  return output
end function

function wireSequence(packet)
  return extwire_byteio.u32(packet, 0) & extwire_pconstants.SEQUENCE_MASK
end function

function wireReliable(packet)
  if (extwire_byteio.u32(packet, 0) & extwire_pconstants.SEQUENCE_RELIABLE_BIT) != 0 then return 1 end if
  return 0
end function

function wireAcknowledge(packet)
  return extwire_byteio.u32(packet, 4) & extwire_pconstants.SEQUENCE_MASK
end function

function wireReliableAck(packet)
  if (extwire_byteio.u32(packet, 4) & extwire_pconstants.SEQUENCE_RELIABLE_BIT) != 0 then return 1 end if
  return 0
end function

function classicServerData(spawnCount, levelName)
  buffer = extwire_sizebuf.alloc(256)
  extwire_message.writeByte(buffer, extwire_qconstants.SVC_SERVERDATA)
  extwire_message.writeLong(buffer, extwire_pconstants.PROTOCOL_VERSION)
  extwire_message.writeLong(buffer, spawnCount)
  extwire_message.writeByte(buffer, 0)
  extwire_message.writeString(buffer, "baseq2")
  extwire_message.writeShort(buffer, 0)
  extwire_message.writeString(buffer, levelName)
  return extwire_sizebuf.dataSlice(buffer)
end function

function miniClientAgainstClassicWire()
  classicSocket = extwire_udp.open("127.0.0.1", 0)
  miniSocket = extwire_udp.open("127.0.0.1", 0)
  classicAddress = extwire_qtypes.NetAddress(extwire_nconstants.NA_IP,
    [127, 0, 0, 1], array(10, 0), classicSocket.port)
  qport = 0x4567
  client = extwire_client.create(qport, 5000)
  extwire_client.beginConnect(client, "classic-wire", classicAddress,
    "\\name\\MiniExternal\\rate\\25000", 0)
  runtime = extwire_rtypes.createClient(client)

  extwire_pump.pumpClient(runtime, miniSocket, 0, 16)
  getChallenge = receiveExternal(classicSocket)
  externalWireAssert(classicConnectionlessText(getChallenge.data) == "getchallenge\n",
    "Mini client getchallenge differs from classic framing")

  extwire_udp.send(classicSocket, "127.0.0.1", miniSocket.port,
    classicConnectionless("challenge 31337"))
  extwire_pump.pumpClient(runtime, miniSocket, 1, 16)
  connect = receiveExternal(classicSocket)
  connectText = classicConnectionlessText(connect.data)
  externalWireAssert(connectText == "connect 34 17767 31337 \"\\name\\MiniExternal\\rate\\25000\"\n",
    "Mini client connect request differs from classic Protocol-34 text")

  extwire_udp.send(classicSocket, "127.0.0.1", miniSocket.port,
    classicConnectionless("client_connect"))
  extwire_pump.pumpClient(runtime, miniSocket, 2, 16)
  newPacket = receiveExternal(classicSocket).data
  externalWireAssert(wireSequence(newPacket) == 1 and wireReliable(newPacket) == 1 and
    wireAcknowledge(newPacket) == 0 and extwire_byteio.u16(newPacket, 8) == qport and
    slice(newPacket, 10, len(newPacket) - 10) == bytes([extwire_qconstants.CLC_STRINGCMD, 110, 101, 119, 0]),
    "Mini client reliable new command differs from classic wire")

  serverPayload = classicServerData(77, "Classic Wire 3.20")
  extwire_udp.send(classicSocket, "127.0.0.1", miniSocket.port,
    classicPacket(1, true, 1, true, 0, false, serverPayload))
  extwire_pump.pumpClient(runtime, miniSocket, 3, 16)
  clientAck = receiveExternal(classicSocket).data
  externalWireAssert(runtime.protocol == 34 and runtime.spawnCount == 77 and
    runtime.levelName == "Classic Wire 3.20" and client.channel.reliableLength == 0,
    "Mini client did not accept classic serverdata")
  externalWireAssert(wireAcknowledge(clientAck) == 1 and wireReliableAck(clientAck) == 1,
    "Mini client did not ACK classic reliable serverdata")

  extwire_udp.close(miniSocket)
  extwire_udp.close(classicSocket)
  return true
end function

function classicWireClientAgainstMiniServer()
  miniSocket = extwire_udp.open("127.0.0.1", 0)
  classicSocket = extwire_udp.open("127.0.0.1", 0)
  server = extwire_server.create(1, "MiniExternal", "interop",
    "\\hostname\\MiniExternal", true, false)
  runtime = extwire_rtypes.createServer(server, 88, "baseq2", "Mini Wire",
    extwire_adapter.permissive())
  qport = 0x2345

  extwire_udp.send(classicSocket, "127.0.0.1", miniSocket.port,
    classicConnectionless("getchallenge\n"))
  extwire_pump.pumpServer(runtime, miniSocket, 10, 16)
  challengePacket = receiveExternal(classicSocket).data
  challengeTokens = extwire_cmd.tokenize(classicConnectionlessText(challengePacket))
  externalWireAssert(len(challengeTokens) == 2 and challengeTokens[0] == "challenge",
    "Mini server challenge differs from classic framing")
  challenge = toNumber(challengeTokens[1])

  connectText = "connect 34 " + qport + " " + challenge +
    " \"\\name\\ClassicExternal\\rate\\25000\"\n"
  extwire_udp.send(classicSocket, "127.0.0.1", miniSocket.port,
    classicConnectionless(connectText))
  extwire_pump.pumpServer(runtime, miniSocket, 11, 16)
  first = receiveExternal(classicSocket).data
  second = receiveExternal(classicSocket).data
  connectionReply = first
  idlePacket = second
  if extwire_byteio.u32(second, 0) == extwire_pconstants.CONNECTIONLESS_SEQUENCE then
    connectionReply = second
    idlePacket = first
  end if
  externalWireAssert(classicConnectionlessText(connectionReply) == "client_connect" and
    wireSequence(idlePacket) == 1 and wireReliable(idlePacket) == 0,
    "Mini server connect acceptance differs from classic wire")

  newPayload = bytes([extwire_qconstants.CLC_STRINGCMD, 110, 101, 119, 0])
  extwire_udp.send(classicSocket, "127.0.0.1", miniSocket.port,
    classicPacket(1, true, 1, false, qport, true, newPayload))
  extwire_pump.pumpServer(runtime, miniSocket, 12, 16)
  serverData = receiveExternal(classicSocket).data
  externalWireAssert(wireSequence(serverData) == 2 and wireReliable(serverData) == 1 and
    wireAcknowledge(serverData) == 1 and wireReliableAck(serverData) == 1,
    "Mini server reliable header differs from classic Netchan")
  payload = slice(serverData, 8, len(serverData) - 8)
  externalWireAssert(payload[0] == extwire_qconstants.SVC_SERVERDATA and
    extwire_byteio.u32(payload, 1) == 34,
    "Mini serverdata body differs from classic Protocol-34 wire")

  extwire_udp.send(classicSocket, "127.0.0.1", miniSocket.port,
    classicPacket(2, false, 2, true, qport, true, bytes()))
  extwire_pump.pumpServer(runtime, miniSocket, 13, 16)
  externalWireAssert(runtime.server.clients[0].channel.reliableLength == 0 and
    runtime.server.clients[0].state == extwire_nconstants.CS_CONNECTED,
    "Mini server did not consume classic reliable ACK")

  extwire_udp.close(classicSocket)
  extwire_udp.close(miniSocket)
  return true
end function

miniClientAgainstClassicWire()
classicWireClientAgainstMiniServer()
print("network_external_wire_interop_tests: PASS (bidirectional Protocol-34 UDP)")
