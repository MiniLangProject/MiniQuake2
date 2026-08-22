/* Deterministic Protocol-34 DM2 playback session. */
package miniquake2.runtime.demo_session

import miniquake2.qcommon.constants as demortqc
import miniquake2.network.constants as demortnc
import miniquake2.network.client as demortclient
import miniquake2.network.runtime.types as demortnetworktypes
import miniquake2.client.demo as demortdemo
import miniquake2.client.effects.state as demorteffects
import miniquake2.client.runtime.dispatcher as demortdispatcher
import miniquake2.client.runtime.handoff as demorthandoff
import miniquake2.client.state as demortstate

struct DemoSession
  runtime
  player
  packetsRead
  framesRead
  finished
end struct

struct DemoStep
  packets
  frames
  handoff
  finished
end struct

function create(data, randomSeed)
  if typeof(randomSeed) != "int" then
    return error(9943, "demo session random seed must be an integer")
  end if
  demoSessionDecodedHolder = demortdemo.decodeDemo(data)
  demoSessionNetworkClientHolder = demortclient.create(0, 5000)
  demoSessionNetworkClientHolder.state = demortnc.CA_CONNECTED
  demoSessionRuntimeHolder = demortdispatcher.create(
    demortnetworktypes.createClient(demoSessionNetworkClientHolder),
    demortstate.create(), demorteffects.createSilent(randomSeed))
  demortdispatcher.setLegacyDemoCompatibility(demoSessionRuntimeHolder, true)
  demoSessionPlayerHolder = demortdemo.player(demoSessionDecodedHolder)
  return DemoSession(demoSessionRuntimeHolder, demoSessionPlayerHolder,
    0, 0, demoSessionPlayerHolder.finished)
end function

// DM2 records contain setup/config packets between rendered snapshots. Consume
// exactly as many packets as necessary to publish one new atomic frame.
function step(session, now)
  if typeof(session) != "struct" or typeof(now) != "int" then
    return error(9944, "demo step requires a session and integer time")
  end if
  if session.finished then return void end if
  demoSessionStepStartPackets = session.packetsRead
  while not session.player.finished
    demoSessionDispatchResult = demortdispatcher.nextDemo(session.runtime,
      session.player, now)
    if demoSessionDispatchResult is void then
      session.finished = true
      break
    end if
    session.packetsRead = session.packetsRead + 1
    if demoSessionDispatchResult.frames > 0 then
      session.framesRead = session.framesRead + demoSessionDispatchResult.frames
      demoSessionFrameHandoff = demorthandoff.commit(session.runtime, now)
      session.finished = session.player.finished
      return DemoStep(session.packetsRead - demoSessionStepStartPackets,
        demoSessionDispatchResult.frames, demoSessionFrameHandoff,
        session.finished)
    end if
  end while
  session.finished = session.player.finished
  return DemoStep(session.packetsRead - demoSessionStepStartPackets,
    0, void, session.finished)
end function

function mapModelPath(session)
  if typeof(session) != "struct" or typeof(session.runtime.network.configStrings) != "array" then
    return error(9945, "demo session configstrings are unavailable")
  end if
  demoSessionMapIndex = demortqc.CS_MODELS + 1
  if demoSessionMapIndex >= len(session.runtime.network.configStrings) then return "" end if
  demoSessionMapPathHolder = session.runtime.network.configStrings[demoSessionMapIndex]
  if typeof(demoSessionMapPathHolder) != "string" then return "" end if
  return demoSessionMapPathHolder
end function

function levelName(session)
  if typeof(session) != "struct" or typeof(session.runtime.network.levelName) != "string" then
    return ""
  end if
  return session.runtime.network.levelName
end function

function release(session)
  if typeof(session) != "struct" then return false end if
  demortdispatcher.releaseResolver()
  session.runtime = void
  session.player = void
  session.finished = true
  return true
end function
