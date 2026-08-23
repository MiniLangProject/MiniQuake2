/* Product-like UDP loopback for fragmented sound/config/download tails. */
import miniquake2.platform.system as nrfloop_system
import miniquake2.qcommon.types as nrfloop_qt
import miniquake2.game.constants as nrfloop_gc
import miniquake2.protocol.constants as nrfloop_pc
import miniquake2.protocol.netchan as nrfloop_netchan
import miniquake2.network.constants as nrfloop_nc
import miniquake2.network.runtime.commands as nrfloop_commands
import miniquake2.server.game_bridge as nrfloop_bridge
import miniquake2.runtime.play_session as nrfloop_play

function fragmentLoopAssert(value, name)
  if not value then return error(8498, name) end if
  return true
end function

function loopText(count, character)
  output = bytes(count)
  index = 0
  while index < count
    output[index] = character
    index = index + 1
  end while
  return decode(output)
end function

function loopPattern(count)
  output = bytes(count)
  index = 0
  while index < count
    output[index] = (index * 5 + 3) & 255
    index = index + 1
  end while
  return output
end function

entities = "{\n\"classname\" \"worldspawn\"\n}\n" +
  "{\n\"classname\" \"info_player_start\"\n\"origin\" \"0 0 24\"\n}\n"
session = nrfloop_play.createCore("fragment_loop", entities, void,
  "\\name\\FragmentLoop\\rate\\25000")
nrfloop_play.runUntilActive(session, 500)
serverClient = session.server.networkRuntime.server.clients[0]
serverChannel = serverClient.channel
clientChannel = session.client.integrated.network.client.channel

// Settle signon reliably so queue-size observations belong only to this test.
attempt = 0
while (nrfloop_netchan.pendingReliableBytes(serverChannel) > 0 or
    nrfloop_netchan.pendingReliableBytes(clientChannel) > 0) and attempt < 128
  nrfloop_play.step(session)
  attempt = attempt + 1
  nrfloop_system.sleep(1)
end while
fragmentLoopAssert(attempt < 128, "signon reliable queues did not settle")

imports = nrfloop_bridge.makeImports(session.server.bridgeRuntime)
soundIndex = imports.soundIndex("weapons/fragment.wav")
player = session.server.gameExport.edicts[1]
serial = 0
while serial < 256
  imports.positionedSound(nrfloop_qt.Vec3(serial * 1.0, 2.0, 3.0), player,
    nrfloop_gc.CHAN_VOICE | nrfloop_gc.CHAN_RELIABLE,
    soundIndex, 0.5, 0.5, 0.025)
  serial = serial + 1
end while

receivedSounds = 0
expectedPosition = 0
maximumSoundTail = 0
attempt = 0
while receivedSounds < 256 and attempt < 128
  result = nrfloop_play.step(session)
  pending = nrfloop_netchan.pendingReliableBytes(serverChannel)
  if pending > maximumSoundTail then maximumSoundTail = pending end if
  if result.handoff is not void then
    for each sound in result.handoff.sounds
      fragmentLoopAssert(sound.position is not void and
        sound.position.x == expectedPosition * 1.0,
        "fragmented sound ordering mismatch at " + expectedPosition)
      expectedPosition = expectedPosition + 1
      receivedSounds = receivedSounds + 1
    end for
  end if
  attempt = attempt + 1
  if receivedSounds < 256 then nrfloop_system.sleep(1) end if
end while
fragmentLoopAssert(receivedSounds == 256 and
  maximumSoundTail > nrfloop_pc.RELIABLE_BUFFER_SIZE and
  session.server.bridgeRuntime.pendingSoundCount == 0,
  "large reliable sound batch was not delivered over UDP fragments")

// Three download chunks are requested in one reliable client payload.  The
// server retains the >1384-byte response tail until successive ACKs arrive.
download = loopPattern(3000)
nrfloop_commands.registerDownload(session.server.networkRuntime,
  "maps/fragment.bin", download)
nrfloop_commands.writeStringCommand(clientChannel.message,
  "download maps/fragment.bin")
nrfloop_commands.writeStringCommand(clientChannel.message, "nextdl")
nrfloop_commands.writeStringCommand(clientChannel.message, "nextdl")
maximumDownloadTail = 0
attempt = 0
while len(session.client.integrated.network.downloadData) < len(download) and attempt < 128
  nrfloop_play.step(session)
  pending = nrfloop_netchan.pendingReliableBytes(serverChannel)
  if pending > maximumDownloadTail then maximumDownloadTail = pending end if
  attempt = attempt + 1
  if len(session.client.integrated.network.downloadData) < len(download) then
    nrfloop_system.sleep(1)
  end if
end while
fragmentLoopAssert(session.client.integrated.network.downloadData == download and
  session.client.integrated.network.downloadPercent == 100 and
  maximumDownloadTail > nrfloop_pc.RELIABLE_BUFFER_SIZE,
  "fragmented UDP download was incomplete")

// Configstring application is a signon service, so temporarily use the
// connected server slot while retaining the same live UDP/Netchan pair.
serverClient.state = nrfloop_nc.CS_CONNECTED
runtime = session.server.networkRuntime
runtime.configStrings[100] = loopText(800, 65)
runtime.configStrings[101] = loopText(800, 66)
runtime.configStrings[102] = loopText(800, 67)
spawn = runtime.spawnCount
nrfloop_commands.writeStringCommand(clientChannel.message,
  "configstrings " + spawn + " 100")
nrfloop_commands.writeStringCommand(clientChannel.message,
  "configstrings " + spawn + " 101")
nrfloop_commands.writeStringCommand(clientChannel.message,
  "configstrings " + spawn + " 102")
maximumConfigTail = 0
attempt = 0
while session.client.integrated.network.configStrings[102] == "" and attempt < 128
  nrfloop_play.step(session)
  pending = nrfloop_netchan.pendingReliableBytes(serverChannel)
  if pending > maximumConfigTail then maximumConfigTail = pending end if
  attempt = attempt + 1
  if session.client.integrated.network.configStrings[102] == "" then
    nrfloop_system.sleep(1)
  end if
end while
fragmentLoopAssert(session.client.integrated.network.configStrings[100] ==
    runtime.configStrings[100] and
  session.client.integrated.network.configStrings[101] == runtime.configStrings[101] and
  session.client.integrated.network.configStrings[102] == runtime.configStrings[102] and
  maximumConfigTail > nrfloop_pc.RELIABLE_BUFFER_SIZE,
  "fragmented UDP configstrings were incomplete or reordered")
serverClient.state = nrfloop_nc.CS_SPAWNED

nrfloop_play.shutdown(session)
fragmentLoopAssert(session.closed, "fragment loopback did not shut down cleanly")
print("network_runtime_reliable_fragment_loopback_tests: PASS")
