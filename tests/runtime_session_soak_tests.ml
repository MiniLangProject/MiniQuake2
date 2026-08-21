/* Product-shaped unpaced UDP/Game-API lifetime and throughput gate. */
import miniquake2.network.constants as soaktestnc
import miniquake2.qcommon.byteio as soaktestbyteio
import miniquake2.runtime.soak as soaktest

function soakAssert(value, message)
  if not value then return error(9936, message) end if
  return true
end function

function verify(result, expectedFrames, label)
  soakAssert(result.frames == expectedFrames, label + " frame count")
  soakAssert(result.clientState == soaktestnc.CA_ACTIVE, label + " client state")
  soakAssert(result.serverFrame >= expectedFrames, label + " server progress")
  soakAssert(result.spawnCount == 1, label + " spawn count")
  soakAssert(result.packetsReceived > expectedFrames, label + " receive progress")
  soakAssert(result.packetsSent > expectedFrames, label + " send progress")
  soakAssert(result.packetsRejected == 0, label + " rejected packets")
  // The first Winsock use in a fresh process may retain up to three process-wide
  // provider handles. A second complete session below must remain within the
  // same bound instead of growing per session.
  soakAssert(result.handleDelta >= 0 and result.handleDelta <= 3,
    label + " process handle growth: " + result.handleDelta)
  // The stock server advances at 10 Hz. Require at least twice real-time in
  // the unpaced full UDP/Game-API graph; higher subsystem budgets are profiled
  // separately instead of hiding lifetime failures behind a desktop-specific
  // aggregate target.
  soakAssert(result.framesPerSecond >= 20, label + " throughput below 20 frames/s")
  return true
end function

function main(args)
  if len(args) == 0 then
    entities = "{\n\"classname\" \"worldspawn\"\n}\n" +
      "{\n\"classname\" \"info_player_start\"\n\"origin\" \"0 0 24\"\n}\n"
    frames = 5000
    result = soaktest.runCore("soak", entities, void, frames)
    verify(result, frames, "synthetic")
    repeated = soaktest.runCore("soak-repeat", entities, void, frames)
    verify(repeated, frames, "synthetic repeat")
    soakAssert(repeated.handleDelta == 0, "second session retained process handles")
    print "runtime_session_soak_tests: PASS (synthetic)"
    print "  frames=" + result.frames + " elapsed-ms=" + result.elapsedMilliseconds +
      " fps=" + result.framesPerSecond + " packets=" + result.packetsReceived +
      "/" + result.packetsSent + " handles=" + result.handleDelta +
      "/" + repeated.handleDelta
    return 0
  end if
  if len(args) < 1 or len(args) > 3 then
    return error(9937, "expected retail root, optional map and optional frame count")
  end if
  mapName = "base1"
  if len(args) >= 2 then mapName = args[1] end if
  frames = 100000
  if len(args) == 3 then frames = soaktestbyteio.truncInt(toNumber(args[2])) end if
  result = soaktest.runRetail(args[0], mapName, frames)
  verify(result, frames, "retail")
  print "runtime_session_soak_tests: PASS (retail)"
  print "  map=" + mapName + " frames=" + result.frames +
    " elapsed-ms=" + result.elapsedMilliseconds + " fps=" + result.framesPerSecond
  print "  server-frame=" + result.serverFrame + " packets=" + result.packetsReceived +
    "/" + result.packetsSent + " rejected=" + result.packetsRejected +
    " handles=" + result.handleDelta
  return 0
end function
