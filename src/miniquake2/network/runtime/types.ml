/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Owned state for the transport-facing protocol-34 runtime.  The lower network
and protocol packages stay pure; this layer owns handshake payload state,
downloads and game callback function values.
*/
package miniquake2.network.runtime.types

import miniquake2.qcommon.constants as qc
import miniquake2.qcommon.types as qt
import miniquake2.protocol.constants as pc
import miniquake2.protocol.types as pt
import miniquake2.server.administration as nradmin

// Store game callbacks data.
struct GameCallbacks
  clientConnect
  clientUserinfoChanged
  clientThink
  clientCommand
  clientBegin
  clientDisconnect
  clientPing
end struct

// Store download file data.
struct DownloadFile
  name
  data
end struct

// Store download transfer data.
struct DownloadTransfer
  name
  data
  offset
end struct

// Store deferred reliable work data.
struct DeferredReliableWork
  kind
  first
  second
end struct

// Store client runtime data.
struct ClientRuntime
  client
  protocol
  spawnCount
  attractLoop
  gameDir
  playerNumber
  levelName
  configStrings
  baselines
  stuffedTexts
  downloadData
  downloadPercent
  downloadMissing
  ackPending
  parsedMessages
end struct

// Store server runtime data.
struct ServerRuntime
  server
  spawnCount
  gameDir
  levelName
  configStrings
  baselines
  downloads
  transfers
  lastCommands
  commandMsec
  callbacks
  ackPending
  commandLog
  deferredReliable
  administration
end struct

// Store pump stats data.
struct PumpStats
  received
  sent
  rejected
end struct

// Create baselines.
function makeBaselines()
  values = array(pc.MAX_EDICTS, void)
  index = 0
  while index < pc.MAX_EDICTS
    state = pt.zeroEntityState()
    state.number = index
    values[index] = state
    index = index + 1
  end while
  return values
end function

// Create commands.
function makeCommands(count)
  values = array(count, void)
  index = 0
  while index < count
    values[index] = qt.zeroUserCmd()
    index = index + 1
  end while
  return values
end function

// Create transfers.
function makeTransfers(count)
  values = array(count, void)
  index = 0
  while index < count
    values[index] = DownloadTransfer("", bytes(), -1)
    index = index + 1
  end while
  return values
end function

// Create deferred reliable.
function makeDeferredReliable(count)
  values = array(count, void)
  index = 0
  while index < count
    values[index] = []
    index = index + 1
  end while
  return values
end function

// Create client.
function createClient(client)
  return ClientRuntime(client, 0, 0, false, "", -1, "",
    array(qc.MAX_CONFIGSTRINGS, ""), makeBaselines(), [], bytes(), 0, false,
    false, 0)
end function

// Create server.
function createServer(server, spawnCount, gameDir, levelName, callbacks)
  if typeof(spawnCount) != "int" then return error(7200, "runtime spawn count must be an integer") end if
  if typeof(gameDir) != "string" or typeof(levelName) != "string" then return error(7201, "runtime server strings must be text") end if
  if len(bytes(gameDir)) >= qc.MAX_QPATH or len(bytes(levelName)) >= qc.MAX_STRING_CHARS then
    return error(7202, "runtime server string exceeds protocol limit")
  end if
  count = server.maxClients
  return ServerRuntime(server, spawnCount, gameDir, levelName,
    array(qc.MAX_CONFIGSTRINGS, ""), makeBaselines(), [], makeTransfers(count),
    makeCommands(count), array(count, 1800), callbacks, array(count, false), [],
    makeDeferredReliable(count), nradmin.create())
end function

// Return the stats value.
function stats()
  return PumpStats(0, 0, 0)
end function
