/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Unpaced product-session soak used by the G10 lifetime/performance gate.  The
normal listen and dedicated loops deliberately preserve Quake II's 10 Hz host
cadence; this runner removes only that wall-clock sleep while keeping the real
UDP, Netchan, Game API, snapshot and client-dispatch path intact.
*/
package miniquake2.runtime.soak

import miniquake2.network.constants as soaknc
import miniquake2.platform.system as soaksystem
import miniquake2.qcommon.types as soakqt
import miniquake2.runtime.media_sequence as soakmedia
import miniquake2.runtime.play_session as soakplay

struct SessionSoakResult
  frames
  elapsedMilliseconds
  framesPerSecond
  clientState
  serverFrame
  spawnCount
  packetsReceived
  packetsSent
  packetsRejected
  handleDelta
  queuedMapCommands
  queuedLoadMenus
  commandBufferBytes
end struct

function commandForFrame(frame)
  forwardMove = 200
  sideMove = 0
  buttons = 0
  if (frame & 127) >= 64 then forwardMove = -200 end if
  if (frame & 255) >= 128 then sideMove = 120 end if
  if (frame % 20) == 0 then buttons = 1 end if
  yaw = (frame * 97) & 65535
  if yaw > 32767 then yaw = yaw - 65536 end if
  return soakqt.UserCmd(100, buttons, [0, yaw, 0],
    forwardMove, sideMove, 0, 0, 0)
end function

function runOwned(session, frameLimit, handlesBefore)
  if typeof(frameLimit) != "int" or frameLimit < 1 or frameLimit > 1000000 then
    return error(9930, "session soak frame count outside [1,1000000]")
  end if
  soakplay.runUntilActive(session, 512)
  clock = soaksystem.createClock()
  started = soaksystem.milliseconds(clock)
  frame = 0
  previousServerFrame = session.server.frameNumber
  lastResult = void
  queuedMapCommands = 0
  queuedLoadMenus = 0
  while frame < frameLimit
    soakplay.setUserCmd(session, commandForFrame(frame))
    lastResult = soakplay.step(session)
    if not lastResult.signonComplete or lastResult.clientState != soaknc.CA_ACTIVE then
      return error(9931, "session soak lost active state at frame " + frame)
    end if
    if lastResult.serverFrame != previousServerFrame + 1 then
      return error(9932, "session soak server frame discontinuity at frame " + frame)
    end if
    if lastResult.packetsRejected != 0 then
      return error(9933, "session soak rejected a packet at frame " + frame)
    end if
    previousServerFrame = lastResult.serverFrame
    // The interactive product host consumes AddCommandString `gamemap`
    // requests after every network frame. This fixed-map lifetime runner has
    // no media executor, but must still validate and drain that engine-owned
    // command boundary. Otherwise repeatedly crossing a changelevel trigger
    // measures an unconsumed test-harness queue instead of session lifetime.
    if soakmedia.takeQueuedLoadMenu(session.server.bridgeRuntime.commands) then
      queuedLoadMenus = queuedLoadMenus + 1
    end if
    queuedMap = soakmedia.takeQueuedGameMap(session.server.bridgeRuntime.commands)
    if queuedMap != "" then queuedMapCommands = queuedMapCommands + 1 end if
    if session.server.bridgeRuntime.commands.buffer != "" then
      return error(9938, "session soak left an unsupported server command queued")
    end if
    while soakplay.takeFrame(session) is not void
    end while
    frame = frame + 1
    if (frame % 10000) == 0 or frame == frameLimit then
      elapsedSample = soaksystem.milliseconds(clock) - started
      if elapsedSample < 1 then elapsedSample = 1 end if
      print "MiniQuake2 session soak progress: frames=" + frame +
        " elapsed-ms=" + elapsedSample + " fps=" + (frame * 1000 / elapsedSample) +
        " packets=" + (session.client.packetsReceived + session.server.packetsReceived) +
        "/" + (session.client.packetsSent + session.server.packetsSent) +
        " bridge-logs=" + len(session.server.bridgeRuntime.logs) +
        " command-log=" + len(session.server.networkRuntime.commandLog) +
        " pending-sounds=" + len(session.server.bridgeRuntime.pendingSounds) +
        " map-commands=" + queuedMapCommands + " load-menus=" + queuedLoadMenus
    end if
  end while
  elapsed = soaksystem.milliseconds(clock) - started
  if elapsed < 1 then elapsed = 1 end if
  clientState = lastResult.clientState
  serverFrame = lastResult.serverFrame
  spawnCount = session.server.networkRuntime.spawnCount
  received = session.client.packetsReceived + session.server.packetsReceived
  sent = session.client.packetsSent + session.server.packetsSent
  rejected = session.client.packetsRejected + session.server.packetsRejected
  soakplay.shutdown(session)
  handlesAfter = soaksystem.handleCount()
  commandBufferBytes = len(bytes(session.server.bridgeRuntime.commands.buffer))
  return SessionSoakResult(frameLimit, elapsed, frameLimit * 1000 / elapsed,
    clientState, serverFrame, spawnCount, received, sent, rejected,
    handlesAfter - handlesBefore, queuedMapCommands, queuedLoadMenus,
    commandBufferBytes)
end function

function runCore(mapName, entityText, collision, frameLimit)
  handlesBefore = soaksystem.handleCount()
  session = soakplay.createCore(mapName, entityText, collision,
    "\\name\\Soak\\skin\\male/grunt\\rate\\25000")
  return runOwned(session, frameLimit, handlesBefore)
end function

function runRetail(baseDirectory, mapName, frameLimit)
  if typeof(baseDirectory) != "string" or baseDirectory == "" then
    return error(9934, "retail session soak requires an install root")
  end if
  if typeof(mapName) != "string" or mapName == "" then
    return error(9935, "retail session soak requires a map")
  end if
  handlesBefore = soaksystem.handleCount()
  session = soakplay.createRetail(baseDirectory, mapName,
    "\\name\\Soak\\skin\\male/grunt\\rate\\25000")
  return runOwned(session, frameLimit, handlesBefore)
end function
