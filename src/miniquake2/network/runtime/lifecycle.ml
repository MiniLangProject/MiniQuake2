/* Atomic Protocol-34 per-level reset while preserving live Netchans. */
package miniquake2.network.runtime.lifecycle

import miniquake2.qcommon.constants as nrlifecycleqc
import miniquake2.qcommon.info as nrlifecycleinfo
import miniquake2.qcommon.sizebuf as nrlifecycleqsz
import miniquake2.network.constants as nrlifecyclenc
import miniquake2.network.runtime.messages as nrlifecyclemessages
import miniquake2.network.runtime.types as nrlifecyclertypes

struct ServerLevelPlan
  ready
  deferred
  spawnCount
  levelName
  serverInfo
  payload
  slots
  reason
end struct

function transitionPayload()
  buffer = nrlifecycleqsz.alloc(64)
  nrlifecyclemessages.writeStuffText(buffer, "changing\n")
  nrlifecyclemessages.writeStuffText(buffer, "reconnect\n")
  return nrlifecycleqsz.dataSlice(buffer)
end function

function prepareServerLevel(runtime, levelName)
  if typeof(levelName) != "string" or levelName == "" or
      len(bytes(levelName)) >= nrlifecycleqc.MAX_QPATH then
    return error(7290, "map transition level name is invalid")
  end if
  nextSpawn = runtime.spawnCount + 1
  if nextSpawn <= runtime.spawnCount or nextSpawn > 0x7fffffff then
    return error(7291, "map transition spawn count exhausted")
  end if
  nextInfo = nrlifecycleinfo.setValueForKey(runtime.server.serverInfo, "mapname", levelName)
  payload = transitionPayload()
  slots = []
  slot = 0
  while slot < runtime.server.maxClients
    transfer = runtime.transfers[slot]
    // Preserve an active download generation.  The caller retries the map
    // transition after its final chunk has been staged; Netchan ordering then
    // guarantees that chunk precedes changing/reconnect on the same channel.
    if transfer is not void and transfer.offset >= 0 then
      return ServerLevelPlan(false, true, nextSpawn, levelName, nextInfo,
        payload, slots, "download-active")
    end if
    client = runtime.server.clients[slot]
    if client.state == nrlifecyclenc.CS_CONNECTED or client.state == nrlifecyclenc.CS_SPAWNED then
      if client.channel is void or client.channel.fatalError or client.channel.message.overflowed then
        return error(7292, "map transition client Netchan is corrupt")
      end if
      if len(payload) > client.channel.message.maxSize - client.channel.message.curSize then
        return ServerLevelPlan(false, true, nextSpawn, levelName, nextInfo,
          payload, slots, "reliable-backpressure")
      end if
      slots = slots + [slot]
    end if
    slot = slot + 1
  end while
  return ServerLevelPlan(true, false, nextSpawn, levelName, nextInfo,
    payload, slots, "ready")
end function

function commitServerLevel(runtime, plan)
  if typeof(plan) != "struct" or not plan.ready or plan.deferred then
    return error(7293, "map transition plan is not committable")
  end if
  // Recheck the small mutable boundary before changing any runtime field.
  for each slot in plan.slots
    client = runtime.server.clients[slot]
    if (client.state != nrlifecyclenc.CS_CONNECTED and client.state != nrlifecyclenc.CS_SPAWNED) or
        client.channel is void or client.channel.fatalError or client.channel.message.overflowed or
        len(plan.payload) > client.channel.message.maxSize - client.channel.message.curSize then
      return error(7294, "map transition plan became stale")
    end if
  end for

  runtime.spawnCount = plan.spawnCount
  runtime.levelName = plan.levelName
  runtime.server.mapName = plan.levelName
  runtime.server.serverInfo = plan.serverInfo
  runtime.configStrings = array(nrlifecycleqc.MAX_CONFIGSTRINGS, "")
  runtime.baselines = nrlifecyclertypes.makeBaselines()
  runtime.transfers = nrlifecyclertypes.makeTransfers(runtime.server.maxClients)
  runtime.lastCommands = nrlifecyclertypes.makeCommands(runtime.server.maxClients)
  runtime.commandMsec = array(runtime.server.maxClients, 1800)
  runtime.commandLog = []
  runtime.deferredReliable = nrlifecyclertypes.makeDeferredReliable(
    runtime.server.maxClients)

  slot = 0
  while slot < runtime.server.maxClients
    runtime.ackPending[slot] = false
    client = runtime.server.clients[slot]
    if client.state == nrlifecyclenc.CS_CONNECTED or client.state == nrlifecyclenc.CS_SPAWNED then
      client.state = nrlifecyclenc.CS_CONNECTED
      client.frames = array(nrlifecyclenc.UPDATE_BACKUP, void)
      client.lastFrame = -1
      client.suppressCount = 0
      nrlifecycleqsz.writeBytes(client.channel.message, plan.payload)
    end if
    slot = slot + 1
  end while
  return true
end function

function resetClientLevel(runtime)
  runtime.configStrings = array(nrlifecycleqc.MAX_CONFIGSTRINGS, "")
  runtime.baselines = nrlifecyclertypes.makeBaselines()
  runtime.downloadData = bytes()
  runtime.downloadPercent = 0
  runtime.downloadMissing = false
  runtime.client.frames = array(nrlifecyclenc.UPDATE_BACKUP, void)
  runtime.client.currentFrame = void
  if runtime.client.state >= nrlifecyclenc.CA_CONNECTED then runtime.client.state = nrlifecyclenc.CA_CONNECTED end if
  return true
end function
