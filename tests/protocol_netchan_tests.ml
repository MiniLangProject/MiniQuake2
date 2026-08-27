/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Quake II 3.19 net_chan.c deterministic wire/state-machine tests.
*/
import miniquake2.protocol.constants as pc
import miniquake2.protocol.types as pt
import miniquake2.protocol.packet as ppacket
import miniquake2.protocol.netchan as pnetchan

// Assert the equal test condition.
function assertEqual(actual, expected, name)
  if actual != expected then return error(7910, name + ": expected " + expected + ", got " + actual) end if
  return true
end function

// Assert the true test condition.
function assertTrue(value, name)
  if value != true then return error(7911, name + ": expected true") end if
  return true
end function

// Assert the bytes test condition.
function assertBytes(actual, expected, name)
  assertEqual(len(actual), len(expected), name + " length")
  index = 0
  while index < len(expected)
    assertEqual(actual[index], expected[index], name + " byte " + index)
    index = index + 1
  end while
  return true
end function

// Verify packet framing.
function testPacketFraming()
  header = pt.PacketHeader(0x01234567, 1, 0x07654321, 1, 0xbeef, 0)
  encoded = ppacket.encodeHeader(header, true)
  assertBytes(encoded, bytes([0x67, 0x45, 0x23, 0x81, 0x21, 0x43, 0x65, 0x87, 0xef, 0xbe]), "Netchan client header C vector")
  decoded = ppacket.decodeHeader(encoded, true)
  assertEqual(decoded.sequence, 0x01234567, "header sequence")
  assertEqual(decoded.reliable, 1, "header reliable")
  assertEqual(decoded.acknowledge, 0x07654321, "header ack")
  assertEqual(decoded.reliableAcknowledged, 1, "header reliable ack")
  assertEqual(decoded.qport, 0xbeef, "header qport")
  assertTrue(try(ppacket.decodeHeader(bytes(9), true)) is error, "truncated client header rejected")
  assertTrue(try(ppacket.decodeHeader(bytes(1401), false)) is error, "oversized packet rejected")

  oob = ppacket.encodeConnectionlessText("status\n")
  assertBytes(oob, bytes([0xff, 0xff, 0xff, 0xff, 0x73, 0x74, 0x61, 0x74, 0x75, 0x73, 0x0a]), "connectionless C vector")
  assertTrue(ppacket.isConnectionless(oob), "connectionless detection")
  assertEqual(ppacket.decodeConnectionlessText(oob), "status\n", "connectionless text")
  assertTrue(try(ppacket.decodeConnectionless(bytes([0xff, 0xff, 0xff]))) is error, "truncated connectionless rejected")
  return true
end function

// Verify reliable exchange.
function testReliableExchange()
  client = pnetchan.setup(pc.NS_CLIENT, void, 0x1234, 100)
  server = pnetchan.setup(pc.NS_SERVER, void, 0, 100)
  pnetchan.queueReliable(client, bytes("REL"))
  sent = pnetchan.transmit(client, bytes("u"), 110)
  assertBytes(sent, bytes([
    0x01, 0x00, 0x00, 0x80, 0x00, 0x00, 0x00, 0x00, 0x34, 0x12,
    0x52, 0x45, 0x4c, 0x75,
  ]), "first reliable packet C vector")
  assertEqual(client.reliableSequence, 1, "client reliable sequence toggled")
  assertEqual(client.lastReliableSequence, 2, "reference post-increment reliable marker")
  assertEqual(client.message.curSize, 0, "reliable staging cleared")
  received = pnetchan.process(server, sent, 120)
  assertTrue(received.accepted, "server accepts reliable packet")
  assertBytes(received.payload, bytes("RELu"), "server payload")
  assertEqual(server.incomingReliableSequence, 1, "server reliable receive toggled")

  acknowledgement = pnetchan.transmit(server, bytes(), 130)
  assertBytes(acknowledgement, bytes([0x01, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x80]), "server acknowledgement C vector")
  acknowledged = pnetchan.process(client, acknowledgement, 140)
  assertTrue(acknowledged.accepted, "client accepts acknowledgement")
  assertEqual(client.reliableLength, 0, "matching reliable ack clears payload")
  assertTrue(pnetchan.canReliable(client), "channel can stage next reliable")

  duplicate = pnetchan.process(client, acknowledgement, 150)
  assertEqual(duplicate.accepted, false, "duplicate packet rejected")
  assertEqual(client.lastReceived, 140, "duplicate does not refresh timeout")
  return true
end function

// Verify loss and wrap.
function testLossAndWrap()
  channel = pnetchan.setup(pc.NS_CLIENT, void, 7, 0)
  pnetchan.queueReliable(channel, bytes([9]))
  first = pnetchan.transmit(channel, bytes(), 1)
  assertEqual(len(first), 11, "initial reliable wire length")
  // Reference retransmits only after a later sequence is acknowledged with the
  // wrong reliable parity, not merely because time passed.
  channel.incomingAcknowledged = 3
  channel.incomingReliableAcknowledged = 0
  assertTrue(pnetchan.needReliable(channel), "dropped reliable detected")
  resent = pnetchan.transmit(channel, bytes(), 2)
  assertEqual(len(resent), 11, "reliable retransmitted")
  assertEqual(resent[10], 9, "retransmit payload")

  assertTrue(pnetchan.sequenceNewer(0, pc.SEQUENCE_MASK), "sequence comparison wraps")
  assertEqual(pnetchan.nextSequence(pc.SEQUENCE_MASK), 0, "sequence counter wraps")
  receiver = pnetchan.setup(pc.NS_CLIENT, void, 0, 0)
  receiver.incomingSequence = pc.SEQUENCE_MASK - 1
  wrappedHeader = pt.PacketHeader(0, 0, 0, 0, 0, 0)
  wrapped = ppacket.encodeHeader(wrappedHeader, false)
  accepted = pnetchan.process(receiver, wrapped, 10)
  assertTrue(accepted.accepted, "wrapped packet accepted")
  assertEqual(accepted.dropped, 1, "drop count across wrap")

  assertTrue(try(pnetchan.process(receiver, ppacket.encodeConnectionlessText("ping"), 11)) is error, "OOB rejected by sequenced channel")
  overflow = pnetchan.setup(pc.NS_CLIENT, void, 1, 0)
  attempted = try(pnetchan.queueReliable(overflow, bytes(pc.RELIABLE_BUFFER_SIZE + 1)))
  assertTrue(attempted is error, "reliable queue overflow rejected")
  return true
end function

// Run this source file's command-line entry point.
function main(args)
  print "MiniQuake2 protocol netchan tests starting: 3"
  result = try(testPacketFraming())
  if result is error then print "FAIL packet: " + result.message; return 1 end if
  result = try(testReliableExchange())
  if result is error then print "FAIL reliable: " + result.message; return 1 end if
  result = try(testLossAndWrap())
  if result is error then print "FAIL loss/wrap: " + result.message; return 1 end if
  print "MiniQuake2 protocol netchan tests passed: 3"
  return 0
end function

