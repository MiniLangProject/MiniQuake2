/* Map transition defers active downloads and preserves final-chunk ordering. */
import miniquake2.protocol.constants as nrmd_pc
import miniquake2.protocol.netchan as nrmd_netchan
import miniquake2.network.constants as nrmd_nc
import miniquake2.network.client as nrmd_client
import miniquake2.network.server as nrmd_server
import miniquake2.network.runtime.types as nrmd_types
import miniquake2.network.runtime.game_adapter as nrmd_adapter
import miniquake2.network.runtime.messages as nrmd_messages
import miniquake2.network.runtime.commands as nrmd_commands
import miniquake2.network.runtime.lifecycle as nrmd_lifecycle

function mapDownloadAssert(value, name)
  if not value then return error(8497, name) end if
  return true
end function

function downloadPattern(count)
  output = bytes(count)
  index = 0
  while index < count
    output[index] = (index * 3) & 255
    index = index + 1
  end while
  return output
end function

server = nrmd_server.create(1, "MapDownload", "old",
  "\\hostname\\MapDownload\\mapname\\old", false, false)
server.clients[0].state = nrmd_nc.CS_SPAWNED
serverChannel = nrmd_netchan.setup(nrmd_pc.NS_SERVER, void, 0, 0)
clientChannel = nrmd_netchan.setup(nrmd_pc.NS_CLIENT, void, 0x3344, 0)
server.clients[0].channel = serverChannel
runtime = nrmd_types.createServer(server, 4, "baseq2", "old",
  nrmd_adapter.permissive())
download = downloadPattern(1500)
nrmd_commands.registerDownload(runtime, "maps/change.bin", download)
nrmd_commands.beginDownload(runtime, 0, "maps/change.bin", 0)
mapDownloadAssert(runtime.transfers[0].offset == 1024,
  "download did not retain its active offset")

deferred = nrmd_lifecycle.prepareServerLevel(runtime, "new")
mapDownloadAssert(not deferred.ready and deferred.deferred and
  deferred.reason == "download-active" and runtime.spawnCount == 4 and
  runtime.levelName == "old" and server.clients[0].state == nrmd_nc.CS_SPAWNED,
  "active download did not atomically defer map transition")

nrmd_commands.queueDownloadChunk(runtime, 0)
mapDownloadAssert(runtime.transfers[0].offset < 0 and
  nrmd_netchan.pendingReliableBytes(serverChannel) > 1500,
  "final download chunk was not retained before transition")
ready = nrmd_lifecycle.prepareServerLevel(runtime, "new")
mapDownloadAssert(ready.ready and not ready.deferred,
  "completed download kept map transition deferred")
nrmd_lifecycle.commitServerLevel(runtime, ready)
mapDownloadAssert(runtime.spawnCount == 5 and runtime.levelName == "new" and
  server.clients[0].state == nrmd_nc.CS_CONNECTED,
  "map transition did not commit after final chunk staging")

client = nrmd_client.create(0x3344, 5000)
client.state = nrmd_nc.CA_ACTIVE
client.channel = clientChannel
clientRuntime = nrmd_types.createClient(client)
steps = 0
while nrmd_netchan.pendingReliableBytes(serverChannel) > 0 and steps < 32
  packet = nrmd_netchan.transmit(serverChannel, bytes(), steps * 4 + 1)
  received = nrmd_netchan.process(clientChannel, packet, steps * 4 + 2)
  if received.accepted and len(received.payload) > 0 then
    nrmd_messages.parsePayload(clientRuntime, received.payload)
  end if
  acknowledgement = nrmd_netchan.transmit(clientChannel, bytes(), steps * 4 + 3)
  nrmd_netchan.process(serverChannel, acknowledgement, steps * 4 + 4)
  steps = steps + 1
end while
mapDownloadAssert(clientRuntime.downloadData == download and
  len(clientRuntime.stuffedTexts) == 2 and
  clientRuntime.stuffedTexts[0] == "changing\n" and
  clientRuntime.stuffedTexts[1] == "reconnect\n",
  "map transition overtook or discarded final download chunks")

print("network_runtime_map_download_deferral_tests: PASS")
