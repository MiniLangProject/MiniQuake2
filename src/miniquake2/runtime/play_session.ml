/* Narrow listen-server vertical slice for later application integration. */
package miniquake2.runtime.play_session

import miniquake2.qcommon.byteio as plbyteio
import miniquake2.network.constants as plnc
import miniquake2.client.runtime.handoff as plhandoff
import miniquake2.runtime.client_session as plclient
import miniquake2.runtime.server_session as plserver
import miniquake2.platform.system as plsystem

struct StepResult
  clientState
  serverFrame
  signonComplete
  handoff
  packetsReceived
  packetsSent
  packetsRejected
end struct

struct PlaySession
  server
  client
  clock
  steps
  closed
end struct

function wrap(server, userInfo)
  if server is void then return error(8390, "play session server is missing") end if
  if typeof(userInfo) != "string" or userInfo == "" then return error(8391, "play session userinfo is missing") end if
  client = plclient.create("127.0.0.1", server.socket.port, userInfo, 0)
  return PlaySession(server, client, plsystem.createClock(), 0, false)
end function

function createCore(mapName, entityText, collision, userInfo)
  server = plserver.createCoreAt(mapName, entityText, collision, "", "127.0.0.1", 0, 1, false)
  return wrap(server, userInfo)
end function

function createCoreAt(mapName, entityText, collision, spawnPoint, userInfo)
  server = plserver.createCoreAt(mapName, entityText, collision, spawnPoint,
    "127.0.0.1", 0, 1, false)
  return wrap(server, userInfo)
end function

function createCoreAtSkill(mapName, entityText, collision, spawnPoint, userInfo, skill)
  playSkillServer = plserver.createCoreAtSkill(mapName, entityText, collision,
    spawnPoint, "127.0.0.1", 0, 1, false, skill)
  return wrap(playSkillServer, userInfo)
end function

function createRetail(baseDirectory, mapName, userInfo)
  server = plserver.createRetailAt(baseDirectory, mapName, "", "127.0.0.1", 0, 1, false)
  return wrap(server, userInfo)
end function

function createRetailAt(baseDirectory, mapName, spawnPoint, userInfo)
  server = plserver.createRetailAt(baseDirectory, mapName, spawnPoint,
    "127.0.0.1", 0, 1, false)
  return wrap(server, userInfo)
end function

function createRetailAtSkill(baseDirectory, mapName, spawnPoint, userInfo, skill)
  playSkillRetailServer = plserver.createRetailAtSkill(baseDirectory, mapName,
    spawnPoint, "127.0.0.1", 0, 1, false, skill)
  return wrap(playSkillRetailServer, userInfo)
end function

function signonComplete(session)
  if session.closed then return false end if
  serverClient = session.server.networkRuntime.server.clients[0]
  return session.client.integrated.network.client.state == plnc.CA_ACTIVE and
    serverClient.state == plnc.CS_SPAWNED and session.client.integrated.client.current is not void
end function

function queueUserCmd(session, command)
  if session.closed then return error(8392, "play session is closed") end if
  return plclient.queueUserCmd(session.client, command)
end function

function setUserCmd(session, command)
  if session.closed then return error(8392, "play session is closed") end if
  return plclient.setUserCmd(session.client, command)
end function

function pendingUserCmds(session)
  if session.closed then return 0 end if
  return plclient.pendingUserCmds(session.client)
end function

function changeMapCore(session, mapName, entityText, collision)
  if session.closed then return error(8392, "play session is closed") end if
  return plserver.changeMapCore(session.server, mapName, entityText, collision)
end function

function changeMapRetail(session, baseDirectory, mapName)
  if session.closed then return error(8392, "play session is closed") end if
  return plserver.changeMapRetail(session.server, baseDirectory, mapName)
end function

function step(session)
  if session.closed then return error(8392, "play session is closed") end if
  plclient.step(session.client)
  plserver.step(session.server)
  plclient.poll(session.client)
  session.steps = session.steps + 1
  now = plbyteio.truncInt(plsystem.milliseconds(session.clock))
  // pumpIntegratedClient normally commits after each accepted packet. This
  // fallback also covers tests or callers that injected a snapshot directly.
  plhandoff.commit(session.client.integrated, now)
  handoff = plhandoff.take(session.client.integrated)
  return StepResult(session.client.integrated.network.client.state,
    session.server.frameNumber, signonComplete(session), handoff,
    session.client.packetsReceived + session.server.packetsReceived,
    session.client.packetsSent + session.server.packetsSent,
    session.client.packetsRejected + session.server.packetsRejected)
end function

function takeFrame(session)
  if session.closed then return void end if
  return plhandoff.take(session.client.integrated)
end function

function takeLatestFrame(session)
  if session.closed then return void end if
  return plhandoff.takeLatest(session.client.integrated)
end function

function runUntilActive(session, maximumSteps)
  if typeof(maximumSteps) != "int" or maximumSteps < 1 then return error(8393, "play session step limit must be positive") end if
  playSessionActivationStepCount = 0
  playSessionActivationLastResult = void
  while playSessionActivationStepCount < maximumSteps and not signonComplete(session)
    playSessionActivationLastResult = step(session)
    playSessionActivationStepCount = playSessionActivationStepCount + 1
    if not signonComplete(session) then plsystem.sleep(1) end if
  end while
  if not signonComplete(session) then return error(8394, "play session signon did not complete") end if
  return playSessionActivationLastResult
end function

function shutdown(session)
  if session.closed then return false end if
  if not session.client.closed then plclient.shutdown(session.client) end if
  // Consume the client's three disconnect packets before releasing the listen
  // socket. UDP delivery can become visible one scheduler tick after send, so
  // keep the bounded drain alive until the slot is free.
  if not session.server.closed then
    attempts = 0
    serverClient = session.server.networkRuntime.server.clients[0]
    while serverClient.state != plnc.CS_FREE and attempts < 16
      ignored = try(plserver.step(session.server))
      attempts = attempts + 1
      if serverClient.state != plnc.CS_FREE then plsystem.sleep(1) end if
    end while
    plserver.shutdown(session.server)
  end if
  session.closed = true
  return true
end function
