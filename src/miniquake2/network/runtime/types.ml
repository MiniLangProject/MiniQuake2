//! Provides miniquake2 network runtime types facilities for this project.

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

/// Store game callbacks data.
struct GameCallbacks
  /// Stores the client connect value associated with game callbacks.
  clientConnect
  /// Stores the client userinfo changed value associated with game callbacks.
  clientUserinfoChanged
  /// Stores the client think value associated with game callbacks.
  clientThink
  /// Stores the client command value associated with game callbacks.
  clientCommand
  /// Stores the client begin value associated with game callbacks.
  clientBegin
  /// Stores the client disconnect value associated with game callbacks.
  clientDisconnect
  /// Stores the client ping value associated with game callbacks.
  clientPing
end struct

/// Store download file data.
struct DownloadFile
  /// Stores the name value associated with download file.
  name
  /// Stores the data value associated with download file.
  data
end struct

/// Store download transfer data.
struct DownloadTransfer
  /// Stores the name value associated with download transfer.
  name
  /// Stores the data value associated with download transfer.
  data
  /// Stores the offset value associated with download transfer.
  offset
end struct

/// Store deferred reliable work data.
struct DeferredReliableWork
  /// Stores the kind value associated with deferred reliable work.
  kind
  /// Stores the first value associated with deferred reliable work.
  first
  /// Stores the second value associated with deferred reliable work.
  second
end struct

/// Store client runtime data.
struct ClientRuntime
  /// Stores the client value associated with client runtime.
  client
  /// Stores the protocol value associated with client runtime.
  protocol
  /// Stores the spawn count value associated with client runtime.
  spawnCount
  /// Stores the attract loop value associated with client runtime.
  attractLoop
  /// Stores the game dir value associated with client runtime.
  gameDir
  /// Stores the player number value associated with client runtime.
  playerNumber
  /// Stores the level name value associated with client runtime.
  levelName
  /// Stores the config strings value associated with client runtime.
  configStrings
  /// Stores the baselines value associated with client runtime.
  baselines
  /// Stores the stuffed texts value associated with client runtime.
  stuffedTexts
  /// Stores the download data value associated with client runtime.
  downloadData
  /// Stores the download percent value associated with client runtime.
  downloadPercent
  /// Stores the download missing value associated with client runtime.
  downloadMissing
  /// Stores the ack pending value associated with client runtime.
  ackPending
  /// Stores the parsed messages value associated with client runtime.
  parsedMessages
end struct

/// Store server runtime data.
struct ServerRuntime
  /// Stores the server value associated with server runtime.
  server
  /// Stores the spawn count value associated with server runtime.
  spawnCount
  /// Stores the game dir value associated with server runtime.
  gameDir
  /// Stores the level name value associated with server runtime.
  levelName
  /// Stores the config strings value associated with server runtime.
  configStrings
  /// Stores the baselines value associated with server runtime.
  baselines
  /// Stores the downloads value associated with server runtime.
  downloads
  /// Stores the transfers value associated with server runtime.
  transfers
  /// Stores the last commands value associated with server runtime.
  lastCommands
  /// Stores the command msec value associated with server runtime.
  commandMsec
  /// Stores the callbacks value associated with server runtime.
  callbacks
  /// Stores the ack pending value associated with server runtime.
  ackPending
  /// Stores the command log value associated with server runtime.
  commandLog
  /// Stores the deferred reliable value associated with server runtime.
  deferredReliable
  /// Stores the administration value associated with server runtime.
  administration
end struct

/// Store pump stats data.
struct PumpStats
  /// Stores the received value associated with pump stats.
  received
  /// Stores the sent value associated with pump stats.
  sent
  /// Stores the rejected value associated with pump stats.
  rejected
end struct

/// Create baselines.
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

/// Create commands.
/// @param count Number of items or units to process.
function makeCommands(count)
  values = array(count, void)
  index = 0
  while index < count
    values[index] = qt.zeroUserCmd()
    index = index + 1
  end while
  return values
end function

/// Create transfers.
/// @param count Number of items or units to process.
function makeTransfers(count)
  values = array(count, void)
  index = 0
  while index < count
    values[index] = DownloadTransfer("", bytes(), -1)
    index = index + 1
  end while
  return values
end function

/// Create deferred reliable.
/// @param count Number of items or units to process.
function makeDeferredReliable(count)
  values = array(count, void)
  index = 0
  while index < count
    values[index] = []
    index = index + 1
  end while
  return values
end function

/// Create client.
/// @param client client value consumed by this operation.
function createClient(client)
  return ClientRuntime(client, 0, 0, false, "", -1, "",
    array(qc.MAX_CONFIGSTRINGS, ""), makeBaselines(), [], bytes(), 0, false,
    false, 0)
end function

/// Create server.
/// @param server server value consumed by this operation.
/// @param spawnCount Number of spawn to process.
/// @param gameDir gameDir value consumed by this operation.
/// @param levelName levelName value consumed by this operation.
/// @param callbacks callbacks value consumed by this operation.
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

/// Return the stats value.
function stats()
  return PumpStats(0, 0, 0)
end function
