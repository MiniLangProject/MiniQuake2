/* Two-client listen-server harness over the real nonblocking UDP sessions. */
package miniquake2.runtime.multiplayer_session

import miniquake2.network.constants as mpsnetworkconstants
import miniquake2.runtime.client_session as mpsclientsession
import miniquake2.runtime.server_session as mpsserversession
import miniquake2.platform.system as mpsplatformsystem
import miniquake2.game.null_game as mpsgameapi
import miniquake2.game.player.rules as mpsplayerrules
import miniquake2.game.integration.baseq2 as mpsbaseq2

const MODE_DEATHMATCH = "deathmatch"
const MODE_COOP = "coop"
const CLIENT_COUNT = 2

struct MultiplayerStepResult
  clientStates
  serverStates
  activeClients
  serverFrame
  packetsReceived
  packetsSent
  packetsRejected
end struct

struct MultiplayerSession
  mode
  server
  clients
  userInfos
  steps
  closed
end struct

function validateMode(mode)
  if mode != MODE_DEATHMATCH and mode != MODE_COOP then
    return error(8400, "multiplayer mode must be deathmatch or coop")
  end if
  return true
end function

function validateUserInfos(userInfos)
  if typeof(userInfos) != "array" or len(userInfos) != CLIENT_COUNT then
    return error(8401, "multiplayer session requires exactly two client userinfos")
  end if
  mpsUserInfoIndex = 0
  while mpsUserInfoIndex < CLIENT_COUNT
    if typeof(userInfos[mpsUserInfoIndex]) != "string" or userInfos[mpsUserInfoIndex] == "" then
      return error(8402, "multiplayer client userinfo is missing")
    end if
    mpsUserInfoIndex = mpsUserInfoIndex + 1
  end while
  return true
end function

function wrap(mode, server, userInfos)
  validateMode(mode)
  validateUserInfos(userInfos)
  if server is void or server.networkRuntime.server.maxClients != CLIENT_COUNT then
    return error(8403, "multiplayer server must expose exactly two slots")
  end if
  mpsWrappedClients = array(CLIENT_COUNT, void)
  mpsWrapIndex = 0
  while mpsWrapIndex < CLIENT_COUNT
    mpsWrappedClients[mpsWrapIndex] = mpsclientsession.create("127.0.0.1",
      server.socket.port, userInfos[mpsWrapIndex], 0)
    mpsWrapIndex = mpsWrapIndex + 1
  end while
  return MultiplayerSession(mode, server, mpsWrappedClients,
    [userInfos[0], userInfos[1]], 0, false)
end function

function createCore(mode, mapName, entityText, collision, userInfos)
  validateMode(mode)
  mpsDeathmatchMode = mode == MODE_DEATHMATCH
  mpsCoopMode = mode == MODE_COOP
  mpsCreatedServer = mpsserversession.createCoreMode(mapName, entityText, collision,
    "127.0.0.1", 0, CLIENT_COUNT, false, mpsDeathmatchMode, mpsCoopMode)
  return wrap(mode, mpsCreatedServer, userInfos)
end function

function createRetail(mode, baseDirectory, mapName, userInfos)
  validateMode(mode)
  mpsRetailDeathmatchMode = mode == MODE_DEATHMATCH
  mpsRetailCoopMode = mode == MODE_COOP
  mpsRetailServer = mpsserversession.createRetailMode(baseDirectory, mapName,
    "127.0.0.1", 0, CLIENT_COUNT, false, mpsRetailDeathmatchMode, mpsRetailCoopMode)
  return wrap(mode, mpsRetailServer, userInfos)
end function

function checkedClientIndex(session, clientIndex, operation)
  if session.closed then return error(8404, operation + ": multiplayer session is closed") end if
  if typeof(clientIndex) != "int" or clientIndex < 0 or clientIndex >= CLIENT_COUNT then
    return error(8405, operation + ": client index outside two-client session")
  end if
  return clientIndex
end function

function serverSlot(session, clientIndex)
  checkedClientIndex(session, clientIndex, "serverSlot")
  mpsSlotClient = session.clients[clientIndex]
  if mpsSlotClient is void then return -1 end if
  mpsPlayerNumber = mpsSlotClient.integrated.network.playerNumber
  if typeof(mpsPlayerNumber) != "int" or mpsPlayerNumber < 0 or
      mpsPlayerNumber >= session.server.networkRuntime.server.maxClients then return -1 end if
  return mpsPlayerNumber
end function

function player(session, clientIndex)
  mpsPlayerSlot = serverSlot(session, clientIndex)
  if mpsPlayerSlot < 0 then return void end if
  return mpsgameapi.findPlayer(mpsPlayerSlot + 1)
end function

function synchronizeScores(session)
  mpsScoreIndex = 0
  while mpsScoreIndex < CLIENT_COUNT
    mpsScoreSlot = serverSlot(session, mpsScoreIndex)
    if mpsScoreSlot >= 0 then
      mpsScorePlayer = player(session, mpsScoreIndex)
      if mpsScorePlayer is not void then
        session.server.networkRuntime.server.clients[mpsScoreSlot].score = mpsScorePlayer.respawn.score
      end if
    end if
    mpsScoreIndex = mpsScoreIndex + 1
  end while
  return true
end function

function activeClients(session)
  if session.closed then return 0 end if
  mpsActiveCount = 0
  mpsActiveIndex = 0
  while mpsActiveIndex < CLIENT_COUNT
    mpsActiveClient = session.clients[mpsActiveIndex]
    mpsActiveSlot = serverSlot(session, mpsActiveIndex)
    if mpsActiveClient is not void and not mpsActiveClient.closed and
        mpsActiveClient.integrated.network.client.state == mpsnetworkconstants.CA_ACTIVE and
        mpsActiveSlot >= 0 and
        session.server.networkRuntime.server.clients[mpsActiveSlot].state == mpsnetworkconstants.CS_SPAWNED and
        mpsActiveClient.integrated.network.client.currentFrame is not void then
      mpsActiveCount = mpsActiveCount + 1
    end if
    mpsActiveIndex = mpsActiveIndex + 1
  end while
  return mpsActiveCount
end function

function signonComplete(session)
  return activeClients(session) == CLIENT_COUNT
end function

function result(session)
  mpsClientStates = array(CLIENT_COUNT, mpsnetworkconstants.CA_DISCONNECTED)
  mpsServerStates = array(CLIENT_COUNT, mpsnetworkconstants.CS_FREE)
  mpsResultReceived = session.server.packetsReceived
  mpsResultSent = session.server.packetsSent
  mpsResultRejected = session.server.packetsRejected
  mpsResultIndex = 0
  while mpsResultIndex < CLIENT_COUNT
    mpsResultClient = session.clients[mpsResultIndex]
    if mpsResultClient is not void then
      mpsClientStates[mpsResultIndex] = mpsResultClient.integrated.network.client.state
      mpsResultReceived = mpsResultReceived + mpsResultClient.packetsReceived
      mpsResultSent = mpsResultSent + mpsResultClient.packetsSent
      mpsResultRejected = mpsResultRejected + mpsResultClient.packetsRejected
    end if
    mpsResultSlot = serverSlot(session, mpsResultIndex)
    if mpsResultSlot >= 0 then
      mpsServerStates[mpsResultIndex] = session.server.networkRuntime.server.clients[mpsResultSlot].state
    end if
    mpsResultIndex = mpsResultIndex + 1
  end while
  return MultiplayerStepResult(mpsClientStates, mpsServerStates,
    activeClients(session), session.server.frameNumber,
    mpsResultReceived, mpsResultSent, mpsResultRejected)
end function

function step(session)
  if session.closed then return error(8404, "step: multiplayer session is closed") end if
  mpsStepIndex = 0
  while mpsStepIndex < CLIENT_COUNT
    mpsStepClient = session.clients[mpsStepIndex]
    if mpsStepClient is not void and not mpsStepClient.closed then mpsclientsession.step(mpsStepClient) end if
    mpsStepIndex = mpsStepIndex + 1
  end while
  mpsserversession.step(session.server)
  mpsPollIndex = 0
  while mpsPollIndex < CLIENT_COUNT
    mpsPollClient = session.clients[mpsPollIndex]
    if mpsPollClient is not void and not mpsPollClient.closed then mpsclientsession.poll(mpsPollClient) end if
    mpsPollIndex = mpsPollIndex + 1
  end while
  synchronizeScores(session)
  session.steps = session.steps + 1
  return result(session)
end function

function runUntilActive(session, maximumSteps)
  if typeof(maximumSteps) != "int" or maximumSteps < 1 then
    return error(8406, "multiplayer signon step limit must be positive")
  end if
  mpsActivationSteps = 0
  mpsActivationResult = result(session)
  while mpsActivationSteps < maximumSteps and not signonComplete(session)
    mpsActivationResult = step(session)
    mpsActivationSteps = mpsActivationSteps + 1
    if not signonComplete(session) then mpsplatformsystem.sleep(1) end if
  end while
  if not signonComplete(session) then return error(8407, "two-client signon did not complete") end if
  return mpsActivationResult
end function

function queueUserCmd(session, clientIndex, command)
  checkedClientIndex(session, clientIndex, "queueUserCmd")
  mpsCommandClient = session.clients[clientIndex]
  if mpsCommandClient is void or mpsCommandClient.closed then return error(8408, "client is disconnected") end if
  return mpsclientsession.queueUserCmd(mpsCommandClient, command)
end function

function snapshotHasEntity(session, clientIndex, entityNumber)
  checkedClientIndex(session, clientIndex, "snapshotHasEntity")
  mpsSnapshotClient = session.clients[clientIndex]
  if mpsSnapshotClient is void or mpsSnapshotClient.integrated.network.client.currentFrame is void then return false end if
  for each mpsSnapshotEntity in mpsSnapshotClient.integrated.network.client.currentFrame.entities
    if mpsSnapshotEntity.number == entityNumber then return true end if
  end for
  return false
end function

function kill(session, victimIndex, attackerIndex, damage, meansOfDeath)
  if session.mode != MODE_DEATHMATCH then return error(8409, "kill helper requires deathmatch mode") end if
  mpsVictimPlayer = player(session, victimIndex)
  mpsAttackerPlayer = player(session, attackerIndex)
  if mpsVictimPlayer is void or mpsAttackerPlayer is void then return error(8410, "kill helper requires two spawned players") end if
  if typeof(damage) != "int" or damage < 1 or typeof(meansOfDeath) != "int" then
    return error(8411, "kill helper damage or means-of-death is invalid")
  end if
  mpsDeathContext = mpsgameapi.playerContext()
  mpsDeathPoint = [mpsVictimPlayer.edict.state.origin.x,
    mpsVictimPlayer.edict.state.origin.y, mpsVictimPlayer.edict.state.origin.z]
  mpsVictimPlayer.health = mpsVictimPlayer.health - damage
  mpsVictimPlayer.gameplay.health = mpsVictimPlayer.health
  mpsDeathResult = mpsplayerrules.player_die(mpsDeathContext, mpsVictimPlayer,
    mpsAttackerPlayer, mpsAttackerPlayer, damage, mpsDeathPoint, meansOfDeath)
  synchronizeScores(session)
  return mpsDeathResult
end function

function touchItem(session, clientIndex, className)
  if session.mode != MODE_COOP then return error(8412, "coop item helper requires coop mode") end if
  if typeof(className) != "string" or className == "" then return error(8413, "coop item classname is missing") end if
  mpsItemPlayer = player(session, clientIndex)
  if mpsItemPlayer is void then return error(8414, "coop item helper requires a spawned player") end if
  mpsItemRuntime = mpsgameapi.baseRuntime()
  mpsItemEntity = mpsbaseq2.findItemByClass(mpsItemRuntime, className)
  if mpsItemEntity is void then return error(8415, "coop item is absent from the map") end if
  return mpsbaseq2.touchItem(mpsItemRuntime, mpsItemEntity,
    mpsItemPlayer, mpsgameapi.playerContext())
end function

function disconnectClient(session, clientIndex)
  checkedClientIndex(session, clientIndex, "disconnectClient")
  mpsDisconnectClient = session.clients[clientIndex]
  if mpsDisconnectClient is void then return false end if
  mpsDisconnectSlot = serverSlot(session, clientIndex)
  if not mpsDisconnectClient.closed then mpsclientsession.shutdown(mpsDisconnectClient) end if
  mpsDisconnectAttempts = 0
  while mpsDisconnectSlot >= 0 and
      session.server.networkRuntime.server.clients[mpsDisconnectSlot].state != mpsnetworkconstants.CS_FREE and
      mpsDisconnectAttempts < 32
    mpsserversession.step(session.server)
    mpsOtherIndex = 0
    while mpsOtherIndex < CLIENT_COUNT
      mpsOtherClient = session.clients[mpsOtherIndex]
      if mpsOtherIndex != clientIndex and mpsOtherClient is not void and not mpsOtherClient.closed then
        mpsclientsession.poll(mpsOtherClient)
      end if
      mpsOtherIndex = mpsOtherIndex + 1
    end while
    mpsDisconnectAttempts = mpsDisconnectAttempts + 1
    if session.server.networkRuntime.server.clients[mpsDisconnectSlot].state != mpsnetworkconstants.CS_FREE then
      mpsplatformsystem.sleep(1)
    end if
  end while
  mpsDisconnected = mpsDisconnectSlot < 0 or
    session.server.networkRuntime.server.clients[mpsDisconnectSlot].state == mpsnetworkconstants.CS_FREE
  return mpsDisconnected
end function

function reconnectClient(session, clientIndex, userInfo)
  checkedClientIndex(session, clientIndex, "reconnectClient")
  mpsReconnectPrevious = session.clients[clientIndex]
  if mpsReconnectPrevious is not void and not mpsReconnectPrevious.closed then
    return error(8416, "client must be disconnected before reconnect")
  end if
  if typeof(userInfo) != "string" or userInfo == "" then return error(8402, "multiplayer client userinfo is missing") end if
  mpsReconnectClient = mpsclientsession.create("127.0.0.1", session.server.socket.port, userInfo, 0)
  session.clients[clientIndex] = mpsReconnectClient
  session.userInfos[clientIndex] = userInfo
  return mpsReconnectClient
end function

function shutdown(session)
  if session.closed then return false end if
  mpsShutdownIndex = 0
  while mpsShutdownIndex < CLIENT_COUNT
    mpsShutdownClient = session.clients[mpsShutdownIndex]
    if mpsShutdownClient is not void and not mpsShutdownClient.closed then mpsclientsession.shutdown(mpsShutdownClient) end if
    mpsShutdownIndex = mpsShutdownIndex + 1
  end while
  mpsDrainAttempts = 0
  mpsPendingSlots = true
  while mpsPendingSlots and mpsDrainAttempts < 32
    mpsPendingSlots = false
    mpsDrainSlot = 0
    while mpsDrainSlot < session.server.networkRuntime.server.maxClients
      if session.server.networkRuntime.server.clients[mpsDrainSlot].state != mpsnetworkconstants.CS_FREE then mpsPendingSlots = true end if
      mpsDrainSlot = mpsDrainSlot + 1
    end while
    if mpsPendingSlots then
      mpsserversession.step(session.server)
      mpsDrainAttempts = mpsDrainAttempts + 1
      if mpsPendingSlots then mpsplatformsystem.sleep(1) end if
    end if
  end while
  mpsserversession.shutdown(session.server)
  session.closed = true
  return true
end function
