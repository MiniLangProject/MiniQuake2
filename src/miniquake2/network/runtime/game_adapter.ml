/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Function-valued adapter between the network runtime and game_export_t. */
package miniquake2.network.runtime.game_adapter

import miniquake2.game.constants as gc
import miniquake2.network.runtime.types as nrtypes
import miniquake2.qcommon.cmd as rqcmd

activeGameExport = void
activeCommandSystem = void

// Connect allow.
function allowConnect(slot, userInfo)
  return true
end function

// Ignore userinfo.
function ignoreUserinfo(slot, userInfo)
  return true
end function

// Ignore think.
function ignoreThink(slot, command)
  return true
end function

// Ignore command.
function ignoreCommand(slot, commandText)
  return true
end function

// Ignore begin.
function ignoreBegin(slot)
  return true
end function

// Ignore disconnect.
function ignoreDisconnect(slot)
  return true
end function

// Ignore ping.
function ignorePing(slot, ping)
  return true
end function

// Create state.
function create(clientConnect, clientUserinfoChanged, clientThink, clientCommand, clientBegin)
  if typeof(clientConnect) != "function" or typeof(clientUserinfoChanged) != "function" or
      typeof(clientThink) != "function" or typeof(clientCommand) != "function" or typeof(clientBegin) != "function" then
    return error(7210, "game callback adapter requires five function values")
  end if
  return nrtypes.GameCallbacks(clientConnect, clientUserinfoChanged, clientThink,
    clientCommand, clientBegin, ignoreDisconnect, ignorePing)
end function

// Create with disconnect.
function createWithDisconnect(clientConnect, clientUserinfoChanged, clientThink, clientCommand, clientBegin, clientDisconnect)
  if typeof(clientDisconnect) != "function" then
    return error(7210, "game callback adapter requires clientDisconnect")
  end if
  callbacks = create(clientConnect, clientUserinfoChanged, clientThink, clientCommand, clientBegin)
  callbacks.clientDisconnect = clientDisconnect
  return callbacks
end function

// Return the permissive value.
function permissive()
  return create(allowConnect, ignoreUserinfo, ignoreThink, ignoreCommand, ignoreBegin)
end function

// Return the game entity value.
function gameEntity(slot, operation)
  global activeGameExport
  if activeGameExport is void then return error(7211, operation + ": no game export is installed") end if
  if typeof(slot) != "int" or slot < 0 then return error(7212, operation + ": client edict outside game export") end if
  index = slot + 1
  if index >= activeGameExport.maxEdicts or index >= len(activeGameExport.edicts) then
    return error(7212, operation + ": client edict outside game export")
  end if
  return activeGameExport.edicts[index]
end function

// Export client connect.
function exportClientConnect(slot, userInfo)
  global activeGameExport
  return activeGameExport.clientConnect(gameEntity(slot, "ClientConnect"), userInfo)
end function

// Export client userinfo changed.
function exportClientUserinfoChanged(slot, userInfo)
  global activeGameExport
  return activeGameExport.clientUserinfoChanged(gameEntity(slot, "ClientUserinfoChanged"), userInfo)
end function

// Export client think.
function exportClientThink(slot, command)
  global activeGameExport
  return activeGameExport.clientThink(gameEntity(slot, "ClientThink"), command)
end function

// Export client command.
function exportClientCommand(slot, commandText)
  global activeGameExport, activeCommandSystem
  // game_export_t obtains argc/argv through game_import_t, as in the C ABI.
  // Preserve the exact command for the duration of ClientCommand.  The
  // former adapter discarded commandText, leaving every GameImport argc/argv
  // call empty even though the Protocol-34 string command reached the server.
  if activeCommandSystem is not void then
    commandSystem = activeCommandSystem
    commandSystem.arguments = rqcmd.tokenize(commandText)
    commandSystem.argumentTail = rqcmd.argumentTail(commandText)
  end if
  return activeGameExport.clientCommand(gameEntity(slot, "ClientCommand"))
end function

// Export client begin.
function exportClientBegin(slot)
  global activeGameExport
  return activeGameExport.clientBegin(gameEntity(slot, "ClientBegin"))
end function

// Export client disconnect.
function exportClientDisconnect(slot)
  global activeGameExport
  return activeGameExport.clientDisconnect(gameEntity(slot, "ClientDisconnect"))
end function

// Export client ping.
function exportClientPing(slot, ping)
  entity = gameEntity(slot, "ClientPing")
  if entity.client is void then return error(7216, "ClientPing: edict has no game client") end if
  entity.client.ping = ping
  return true
end function

// Install game export.
function installGameExport(gameExport)
  global activeGameExport, activeCommandSystem
  if typeof(gameExport) != "struct" or gameExport.apiVersion != gc.GAME_API_VERSION then
    return error(7213, "runtime requires Game API version 3")
  end if
  if typeof(gameExport.clientConnect) != "function" or typeof(gameExport.clientUserinfoChanged) != "function" or
      typeof(gameExport.clientThink) != "function" or typeof(gameExport.clientCommand) != "function" or
      typeof(gameExport.clientBegin) != "function" then
    return error(7214, "game export is missing client callbacks")
  end if
  activeGameExport = gameExport
  activeCommandSystem = void
  callbacks = createWithDisconnect(exportClientConnect, exportClientUserinfoChanged,
    exportClientThink, exportClientCommand, exportClientBegin, exportClientDisconnect)
  callbacks.clientPing = exportClientPing
  return callbacks
end function

// Install game export with commands.
function installGameExportWithCommands(gameExport, commandSystem)
  global activeCommandSystem
  callbacks = installGameExport(gameExport)
  if typeof(commandSystem) != "struct" then
    return error(7215, "runtime Game API adapter requires a command system")
  end if
  activeCommandSystem = commandSystem
  return callbacks
end function
