/* Game-independent real UDP gate through the integrated client dispatcher. */
import miniquake2.platform.system as nrfudp_system
import miniquake2.platform.udp as nrfudp_udp
import miniquake2.qcommon.types as nrfudp_qt
import miniquake2.game.constants as nrfudp_gc
import miniquake2.protocol.constants as nrfudp_pc
import miniquake2.protocol.netchan as nrfudp_netchan
import miniquake2.network.constants as nrfudp_nc
import miniquake2.network.client as nrfudp_client
import miniquake2.network.server as nrfudp_server
import miniquake2.network.runtime.types as nrfudp_types
import miniquake2.network.runtime.game_adapter as nrfudp_adapter
import miniquake2.network.runtime.commands as nrfudp_commands
import miniquake2.network.runtime.pump as nrfudp_pump
import miniquake2.network.runtime.sound_dispatch as nrfudp_sound
import miniquake2.client.state as nrfudp_cstate
import miniquake2.client.effects.state as nrfudp_effects
import miniquake2.client.runtime.dispatcher as nrfudp_dispatcher
import miniquake2.server.types as nrfudp_stypes

function fragmentUdpAssert(value, name)
  if not value then return error(8499, name) end if
  return true
end function

function udpText(count, character)
  output = bytes(count)
  index = 0
  while index < count
    output[index] = character
    index = index + 1
  end while
  return decode(output)
end function

function udpPattern(count)
  output = bytes(count)
  index = 0
  while index < count
    output[index] = (index * 7 + 1) & 255
    index = index + 1
  end while
  return output
end function

serverSocket = nrfudp_udp.open("127.0.0.1", 0)
clientSocket = nrfudp_udp.open("127.0.0.1", 0)
serverAddress = nrfudp_qt.NetAddress(nrfudp_nc.NA_IP, [127, 0, 0, 1],
  array(10, 0), serverSocket.port)
client = nrfudp_client.create(0x6677, 5000)
nrfudp_client.beginConnect(client, "127.0.0.1", serverAddress,
  "\\name\\FragmentUdp", 0)
clientRuntime = nrfudp_types.createClient(client)
integrated = nrfudp_dispatcher.create(clientRuntime,
  nrfudp_cstate.create(), nrfudp_effects.createSilent(41))
server = nrfudp_server.create(1, "FragmentUdp", "unit",
  "\\hostname\\FragmentUdp", false, false)
serverRuntime = nrfudp_types.createServer(server, 21, "baseq2", "Fragment UDP",
  nrfudp_adapter.permissive())

now = 0
attempt = 0
while (client.state < nrfudp_nc.CA_CONNECTED or clientRuntime.protocol != 34) and attempt < 256
  nrfudp_pump.pumpIntegratedClient(integrated, clientSocket, now, 64)
  nrfudp_pump.pumpServer(serverRuntime, serverSocket, now, 64)
  nrfudp_pump.pumpIntegratedClient(integrated, clientSocket, now, 64)
  now = now + 1
  attempt = attempt + 1
  if clientRuntime.protocol != 34 then nrfudp_system.sleep(1) end if
end while
fragmentUdpAssert(client.state >= nrfudp_nc.CA_CONNECTED and
  clientRuntime.protocol == 34, "integrated UDP handshake/serverdata failed")
serverClient = server.clients[0]
serverClient.state = nrfudp_nc.CS_SPAWNED
serverChannel = serverClient.channel

sounds = []
serial = 0
while serial < 256
  sounds = sounds + [nrfudp_stypes.PendingSoundEvent(serial, true, 1,
    nrfudp_gc.CHAN_VOICE,
    nrfudp_gc.CHAN_VOICE | nrfudp_gc.CHAN_RELIABLE,
    1, 0.5, 0.5, 0.025, nrfudp_qt.Vec3(serial * 1.0, 2.0, 3.0))]
  serial = serial + 1
end while
soundResult = nrfudp_sound.dispatchRouted(serverRuntime, serverSocket,
  sounds, [sounds], now)
fragmentUdpAssert(soundResult.delivered and
  nrfudp_netchan.pendingReliableBytes(serverChannel) > nrfudp_pc.RELIABLE_BUFFER_SIZE,
  "large sound tail was not staged over UDP")
attempt = 0
while len(integrated.effects.soundEvents) < 256 and attempt < 256
  nrfudp_pump.pumpIntegratedClient(integrated, clientSocket, now, 64)
  nrfudp_pump.pumpServer(serverRuntime, serverSocket, now, 64)
  now = now + 1
  attempt = attempt + 1
  if len(integrated.effects.soundEvents) < 256 then nrfudp_system.sleep(1) end if
end while
fragmentUdpAssert(len(integrated.effects.soundEvents) == 256,
  "integrated dispatcher did not receive all fragmented sounds")
index = 0
while index < len(integrated.effects.soundEvents)
  event = integrated.effects.soundEvents[index]
  fragmentUdpAssert(event.position is not void and event.position.x == index * 1.0,
    "UDP sound fragment ordering mismatch at " + index)
  index = index + 1
end while

// Direct runtime service producers still traverse real Netchan/UDP and the
// same transactional product dispatcher on the receive side.
serverClient.state = nrfudp_nc.CS_CONNECTED
serverRuntime.configStrings[100] = udpText(800, 65)
serverRuntime.configStrings[101] = udpText(800, 66)
serverRuntime.configStrings[102] = udpText(800, 67)
nrfudp_commands.queueConfigStrings(serverRuntime, 0, serverRuntime.spawnCount, 100)
nrfudp_commands.queueConfigStrings(serverRuntime, 0, serverRuntime.spawnCount, 101)
nrfudp_commands.queueConfigStrings(serverRuntime, 0, serverRuntime.spawnCount, 102)
fragmentUdpAssert(nrfudp_netchan.pendingReliableBytes(serverChannel) >
  nrfudp_pc.RELIABLE_BUFFER_SIZE, "UDP configstring tail did not fragment")
attempt = 0
while clientRuntime.configStrings[102] == "" and attempt < 256
  nrfudp_pump.pumpServer(serverRuntime, serverSocket, now, 64)
  nrfudp_pump.pumpIntegratedClient(integrated, clientSocket, now, 64)
  now = now + 1
  attempt = attempt + 1
  if clientRuntime.configStrings[102] == "" then nrfudp_system.sleep(1) end if
end while
fragmentUdpAssert(clientRuntime.configStrings[100] == serverRuntime.configStrings[100] and
  clientRuntime.configStrings[101] == serverRuntime.configStrings[101] and
  clientRuntime.configStrings[102] == serverRuntime.configStrings[102],
  "UDP configstring fragments were incomplete")

download = udpPattern(3000)
nrfudp_commands.registerDownload(serverRuntime, "maps/fragment.bin", download)
nrfudp_commands.beginDownload(serverRuntime, 0, "maps/fragment.bin", 0)
nrfudp_commands.queueDownloadChunk(serverRuntime, 0)
nrfudp_commands.queueDownloadChunk(serverRuntime, 0)
fragmentUdpAssert(nrfudp_netchan.pendingReliableBytes(serverChannel) >
  nrfudp_pc.RELIABLE_BUFFER_SIZE, "UDP download tail did not fragment")
attempt = 0
while len(clientRuntime.downloadData) < len(download) and attempt < 256
  nrfudp_pump.pumpServer(serverRuntime, serverSocket, now, 64)
  nrfudp_pump.pumpIntegratedClient(integrated, clientSocket, now, 64)
  now = now + 1
  attempt = attempt + 1
  if len(clientRuntime.downloadData) < len(download) then nrfudp_system.sleep(1) end if
end while
fragmentUdpAssert(clientRuntime.downloadData == download and
  clientRuntime.downloadPercent == 100, "UDP download fragments were incomplete")

nrfudp_udp.close(clientSocket)
nrfudp_udp.close(serverSocket)
print("network_runtime_reliable_fragment_udp_tests: PASS")
