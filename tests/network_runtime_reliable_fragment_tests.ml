/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Sound/configstring/download use of the ACK-gated reliable fragment queue. */
import miniquake2.qcommon.constants as nrrfrag_qc
import miniquake2.qcommon.types as nrrfrag_qt
import miniquake2.game.constants as nrrfrag_gc
import miniquake2.protocol.constants as nrrfrag_pc
import miniquake2.protocol.netchan as nrrfrag_netchan
import miniquake2.network.constants as nrrfrag_nc
import miniquake2.network.client as nrrfrag_client
import miniquake2.network.server as nrrfrag_server
import miniquake2.network.runtime.types as nrrfrag_types
import miniquake2.network.runtime.game_adapter as nrrfrag_adapter
import miniquake2.network.runtime.messages as nrrfrag_messages
import miniquake2.network.runtime.commands as nrrfrag_commands
import miniquake2.network.runtime.sound_dispatch as nrrfrag_sound
import miniquake2.server.types as nrrfrag_stypes

// Assert the runtime fragment test condition.
function runtimeFragmentAssert(value, name)
  if not value then return error(8496, name) end if
  return true
end function

// Return the repeated text value.
function repeatedText(count, character)
  data = bytes(count)
  index = 0
  while index < count
    data[index] = character
    index = index + 1
  end while
  return decode(data)
end function

// Return the pattern value.
function pattern(count)
  output = bytes(count)
  index = 0
  while index < count
    output[index] = index & 255
    index = index + 1
  end while
  return output
end function

// Report whether connected pair.
function connectedPair()
  serverChannel = nrrfrag_netchan.setup(nrrfrag_pc.NS_SERVER, void, 0, 0)
  clientChannel = nrrfrag_netchan.setup(nrrfrag_pc.NS_CLIENT, void, 0x7788, 0)
  return [serverChannel, clientChannel]
end function

// Drain server reliable.
function drainServerReliable(serverChannel, clientRuntime, clientChannel)
  steps = 0
  while nrrfrag_netchan.pendingReliableBytes(serverChannel) > 0 and steps < 256
    packet = nrrfrag_netchan.transmit(serverChannel, bytes(), steps * 2 + 1)
    received = nrrfrag_netchan.process(clientChannel, packet, steps * 2 + 2)
    if received.accepted and len(received.payload) > 0 then
      nrrfrag_messages.parsePayload(clientRuntime, received.payload)
    end if
    acknowledgement = nrrfrag_netchan.transmit(clientChannel, bytes(), steps * 2 + 3)
    nrrfrag_netchan.process(serverChannel, acknowledgement, steps * 2 + 4)
    steps = steps + 1
  end while
  runtimeFragmentAssert(steps < 256 and
    nrrfrag_netchan.pendingReliableBytes(serverChannel) == 0,
    "reliable application queue did not drain")
  return steps
end function

server = nrrfrag_server.create(1, "Fragment", "unit",
  "\\hostname\\Fragment", false, false)
server.clients[0].state = nrrfrag_nc.CS_SPAWNED
pair = connectedPair()
server.clients[0].channel = pair[0]
runtime = nrrfrag_types.createServer(server, 12, "baseq2", "fragment",
  nrrfrag_adapter.permissive())

// The maximum bounded game sound batch is deliberately larger than one
// reliable payload when every optional Protocol-34 field is present.
sounds = []
serial = 0
while serial < 256
  sounds = sounds + [nrrfrag_stypes.PendingSoundEvent(serial, true, 1,
    nrrfrag_gc.CHAN_VOICE,
    nrrfrag_gc.CHAN_VOICE | nrrfrag_gc.CHAN_RELIABLE,
    1, 0.5, 0.5, 0.025,
    nrrfrag_qt.Vec3(serial * 1.0, 2.0, 3.0))]
  serial = serial + 1
end while
soundPlan = nrrfrag_sound.buildPlan(runtime, 0, sounds)
runtimeFragmentAssert(soundPlan is not void and soundPlan != false and
  len(soundPlan.reliableFragments) == 256,
  "reliable sound tail was rejected before fragment packing")
nrrfrag_netchan.queueReliableFragments(pair[0], soundPlan.reliableFragments)
runtimeFragmentAssert(nrrfrag_netchan.pendingReliableBytes(pair[0]) >
  nrrfrag_pc.RELIABLE_BUFFER_SIZE and len(pair[0].reliableQueue) >= 2,
  "sound tail larger than 1384 bytes was not fragmented")

// Configstring commands are queued as complete svc records.  Multiple
// requests may build a tail larger than one packet without overflowing the
// old sizebuf or losing their continuation stufftexts.
pair = connectedPair()
server.clients[0].channel = pair[0]
server.clients[0].state = nrrfrag_nc.CS_CONNECTED
runtime.configStrings[0] = repeatedText(800, 65)
runtime.configStrings[1] = repeatedText(800, 66)
runtime.configStrings[2] = repeatedText(800, 67)
nrrfrag_commands.queueConfigStrings(runtime, 0, runtime.spawnCount, 0)
nrrfrag_commands.queueConfigStrings(runtime, 0, runtime.spawnCount, 1)
nrrfrag_commands.queueConfigStrings(runtime, 0, runtime.spawnCount, 2)
runtimeFragmentAssert(nrrfrag_netchan.pendingReliableBytes(pair[0]) >
  nrrfrag_pc.RELIABLE_BUFFER_SIZE, "configstring tail did not enter fragment queue")
client = nrrfrag_client.create(0x7788, 5000)
client.state = nrrfrag_nc.CA_ACTIVE
client.channel = pair[1]
clientRuntime = nrrfrag_types.createClient(client)
drainServerReliable(pair[0], clientRuntime, pair[1])
runtimeFragmentAssert(clientRuntime.configStrings[0] == runtime.configStrings[0] and
  clientRuntime.configStrings[1] == runtime.configStrings[1] and
  clientRuntime.configStrings[2] == runtime.configStrings[2],
  "fragmented configstrings changed content or ordering")

// Several nextdl requests received in one reliable client packet stage a
// multi-packet server tail.  Transfer offset advances only after each chunk
// was accepted by the queue.
pair = connectedPair()
server.clients[0].channel = pair[0]
download = pattern(3000)
nrrfrag_commands.registerDownload(runtime, "maps/fragment.bin", download)
runtimeFragmentAssert(nrrfrag_commands.beginDownload(runtime, 0,
  "maps/fragment.bin", 0), "download did not begin")
nrrfrag_commands.queueDownloadChunk(runtime, 0)
nrrfrag_commands.queueDownloadChunk(runtime, 0)
runtimeFragmentAssert(nrrfrag_netchan.pendingReliableBytes(pair[0]) >
  nrrfrag_pc.RELIABLE_BUFFER_SIZE and runtime.transfers[0].offset < 0,
  "download tail was not fully retained before transfer completion")
client.channel = pair[1]
clientRuntime = nrrfrag_types.createClient(client)
drainServerReliable(pair[0], clientRuntime, pair[1])
runtimeFragmentAssert(clientRuntime.downloadData == download and
  clientRuntime.downloadPercent == 100,
  "fragmented download was incomplete or reordered")

// Full bounded queues report backpressure without changing transfer offsets.
pair = connectedPair()
server.clients[0].channel = pair[0]
full = array(nrrfrag_pc.MAX_RELIABLE_QUEUE_FRAGMENTS,
  bytes(nrrfrag_pc.RELIABLE_BUFFER_SIZE))
nrrfrag_netchan.queueReliableFragments(pair[0], full)
runtime.transfers[0] = nrrfrag_types.DownloadTransfer("maps/fragment.bin", download, 0)
beforeOffset = runtime.transfers[0].offset
runtimeFragmentAssert(nrrfrag_commands.queueDownloadChunk(runtime, 0) == false and
  runtime.transfers[0].offset == beforeOffset and
  len(pair[0].reliableQueue) == nrrfrag_pc.MAX_RELIABLE_QUEUE_FRAGMENTS,
  "download backpressure consumed data or queue entries")
server.clients[0].state = nrrfrag_nc.CS_SPAWNED
soundDeferred = nrrfrag_sound.buildPlan(runtime, 0, sounds)
runtimeFragmentAssert(soundDeferred == false and runtime.transfers[0].offset == beforeOffset,
  "sound backpressure was not atomic")

// A reliably received nextdl command must not disappear merely because its
// response queue is full.  One bounded work record survives until an ACK
// releases capacity, then advances the transfer exactly once.
runtimeFragmentAssert(nrrfrag_commands.executeString(runtime, 0, "nextdl") and
  len(runtime.deferredReliable[0]) == 1 and runtime.transfers[0].offset == beforeOffset,
  "backpressured nextdl request was not retained")
releasedPacket = nrrfrag_netchan.transmit(pair[0], bytes(), 1000)
nrrfrag_netchan.process(pair[1], releasedPacket, 1001)
releasedAck = nrrfrag_netchan.transmit(pair[1], bytes(), 1002)
nrrfrag_netchan.process(pair[0], releasedAck, 1003)
nrrfrag_commands.retryDeferredReliable(runtime, 0)
runtimeFragmentAssert(len(runtime.deferredReliable[0]) == 0 and
  runtime.transfers[0].offset == 1024 and
  len(pair[0].reliableQueue) == nrrfrag_pc.MAX_RELIABLE_QUEUE_FRAGMENTS,
  "deferred nextdl did not resume exactly once after ACK capacity")

print("network_runtime_reliable_fragment_tests: PASS")
