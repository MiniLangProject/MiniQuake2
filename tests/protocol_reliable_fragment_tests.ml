/* ACK-gated Protocol-34 reliable application-fragment queue tests. */
import miniquake2.protocol.constants as prfrag_pc
import miniquake2.protocol.netchan as prfrag_netchan

function fragmentAssert(value, name)
  if not value then return error(8495, name) end if
  return true
end function

function filled(count, value)
  output = bytes(count)
  index = 0
  while index < count
    output[index] = value
    index = index + 1
  end while
  return output
end function

function payload(packet, headerBytes)
  return slice(packet, headerBytes, len(packet) - headerBytes)
end function

client = prfrag_netchan.setup(prfrag_pc.NS_CLIENT, void, 0x5566, 0)
server = prfrag_netchan.setup(prfrag_pc.NS_SERVER, void, 0, 0)
firstFragment = filled(1000, 17)
secondFragment = filled(700, 34)
thirdFragment = filled(900, 51)
queued = prfrag_netchan.queueReliableFragments(client,
  [firstFragment, secondFragment, thirdFragment])
fragmentAssert(queued != false and len(client.reliableQueue) == 3 and
  client.reliableQueuedBytes == 2600 and client.message.curSize == 0,
  "large reliable tail was not retained as complete fragments")

first = prfrag_netchan.transmit(client, bytes(), 1)
fragmentAssert(payload(first, prfrag_pc.PACKET_HEADER_CLIENT) == firstFragment and
  client.reliableLength == 1000 and len(client.reliableQueue) == 2,
  "first fragment was not promoted")
premature = prfrag_netchan.transmit(client, bytes(), 2)
fragmentAssert(len(premature) == prfrag_pc.PACKET_HEADER_CLIENT and
  client.reliableLength == 1000 and len(client.reliableQueue) == 2,
  "second fragment advanced before ACK")
receivedFirst = prfrag_netchan.process(server, first, 3)
fragmentAssert(receivedFirst.accepted and receivedFirst.payload == firstFragment,
  "first fragment did not decode")
firstAck = prfrag_netchan.transmit(server, bytes(), 4)
prfrag_netchan.process(client, firstAck, 5)
fragmentAssert(client.reliableLength == 0 and len(client.reliableQueue) == 2,
  "first ACK did not release only the holding fragment")

// Drop the first transmission of fragment two.  Later empty packets advance
// the remote ACK far enough for the classic Quake-II parity test to request a
// byte-identical retransmit, without dequeuing fragment three.
droppedSecond = prfrag_netchan.transmit(client, bytes(), 6)
fragmentAssert(payload(droppedSecond, prfrag_pc.PACKET_HEADER_CLIENT) == secondFragment,
  "second fragment was not selected")
emptyOne = prfrag_netchan.transmit(client, bytes(), 7)
emptyTwo = prfrag_netchan.transmit(client, bytes(), 8)
prfrag_netchan.process(server, emptyOne, 9)
prfrag_netchan.process(server, emptyTwo, 10)
lossAck = prfrag_netchan.transmit(server, bytes(), 11)
prfrag_netchan.process(client, lossAck, 12)
fragmentAssert(prfrag_netchan.needReliable(client),
  "dropped fragment was not detected from ACK parity")
resentSecond = prfrag_netchan.transmit(client, bytes(), 13)
fragmentAssert(payload(resentSecond, prfrag_pc.PACKET_HEADER_CLIENT) == secondFragment and
  len(client.reliableQueue) == 1, "retransmit changed or skipped the holding fragment")
receivedSecond = prfrag_netchan.process(server, resentSecond, 14)
fragmentAssert(receivedSecond.accepted and receivedSecond.payload == secondFragment,
  "retransmitted fragment was rejected")
duplicate = prfrag_netchan.process(server, resentSecond, 15)
fragmentAssert(not duplicate.accepted and duplicate.reason == "stale-or-duplicate",
  "duplicate reliable fragment was delivered twice")

secondAck = prfrag_netchan.transmit(server, bytes(), 16)
prfrag_netchan.process(client, secondAck, 17)
third = prfrag_netchan.transmit(client, bytes(), 18)
fragmentAssert(payload(third, prfrag_pc.PACKET_HEADER_CLIENT) == thirdFragment and
  len(client.reliableQueue) == 0, "final fragment ordering mismatch")
receivedThird = prfrag_netchan.process(server, third, 19)
thirdAck = prfrag_netchan.transmit(server, bytes(), 20)
prfrag_netchan.process(client, thirdAck, 21)
fragmentAssert(receivedThird.accepted and receivedThird.payload == thirdFragment and
  client.reliableLength == 0 and prfrag_netchan.pendingReliableBytes(client) == 0,
  "fragment queue did not drain after the final ACK")

// Malformed and bounded-backpressure paths must leave existing queue bytes
// untouched.  A corrupted internal queue is fatal before any packet is sent.
bounded = prfrag_netchan.setup(prfrag_pc.NS_SERVER, void, 0, 0)
many = array(prfrag_pc.MAX_RELIABLE_QUEUE_FRAGMENTS,
  bytes(prfrag_pc.RELIABLE_BUFFER_SIZE))
prfrag_netchan.queueReliableFragments(bounded, many)
beforeCount = len(bounded.reliableQueue)
beforeBytes = bounded.reliableQueuedBytes
fragmentAssert(prfrag_netchan.queueReliableFragments(bounded, [bytes([8])]) == false and
  len(bounded.reliableQueue) == beforeCount and bounded.reliableQueuedBytes == beforeBytes,
  "queue backpressure lost pending fragments")
fragmentAssert(try(prfrag_netchan.queueReliableFragments(bounded,
  [bytes([9]), "malformed"])) is error and len(bounded.reliableQueue) == beforeCount and
  bounded.reliableQueuedBytes == beforeBytes,
  "malformed fragment partially committed")
fragmentAssert(try(prfrag_netchan.queueReliableFragments(bounded,
  [bytes(prfrag_pc.RELIABLE_BUFFER_SIZE + 1)])) is error and
  len(bounded.reliableQueue) == beforeCount,
  "oversized application fragment was accepted")
bounded.reliableQueuedBytes = bounded.reliableQueuedBytes + 1
fragmentAssert(try(prfrag_netchan.transmit(bounded, bytes(), 22)) is error and
  bounded.fatalError, "corrupt fragment queue was transmitted")

print("protocol_reliable_fragment_tests: PASS")
