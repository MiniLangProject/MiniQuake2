/* Function-valued adapter between the network runtime and game_export_t. */
package miniquake2.network.runtime.game_adapter

import miniquake2.game.constants as gc
import miniquake2.network.runtime.types as nrtypes

activeGameExport = void

function allowConnect(slot, userInfo)
  return true
end function

function ignoreUserinfo(slot, userInfo)
  return true
end function

function ignoreThink(slot, command)
  return true
end function

function ignoreCommand(slot, commandText)
  return true
end function

function ignoreBegin(slot)
  return true
end function

function ignoreDisconnect(slot)
  return true
end function

function create(clientConnect, clientUserinfoChanged, clientThink, clientCommand, clientBegin)
  if typeof(clientConnect) != "function" or typeof(clientUserinfoChanged) != "function" or
      typeof(clientThink) != "function" or typeof(clientCommand) != "function" or typeof(clientBegin) != "function" then
    return error(7210, "game callback adapter requires five function values")
  end if
  return nrtypes.GameCallbacks(clientConnect, clientUserinfoChanged, clientThink, clientCommand, clientBegin, ignoreDisconnect)
end function

function createWithDisconnect(clientConnect, clientUserinfoChanged, clientThink, clientCommand, clientBegin, clientDisconnect)
  if typeof(clientDisconnect) != "function" then
    return error(7210, "game callback adapter requires clientDisconnect")
  end if
  callbacks = create(clientConnect, clientUserinfoChanged, clientThink, clientCommand, clientBegin)
  callbacks.clientDisconnect = clientDisconnect
  return callbacks
end function

function permissive()
  return create(allowConnect, ignoreUserinfo, ignoreThink, ignoreCommand, ignoreBegin)
end function

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

function exportClientConnect(slot, userInfo)
  global activeGameExport
  return activeGameExport.clientConnect(gameEntity(slot, "ClientConnect"), userInfo)
end function

function exportClientUserinfoChanged(slot, userInfo)
  global activeGameExport
  return activeGameExport.clientUserinfoChanged(gameEntity(slot, "ClientUserinfoChanged"), userInfo)
end function

function exportClientThink(slot, command)
  global activeGameExport
  return activeGameExport.clientThink(gameEntity(slot, "ClientThink"), command)
end function

function exportClientCommand(slot, commandText)
  global activeGameExport
  // game_export_t obtains argc/argv through game_import_t, as in the C ABI.
  return activeGameExport.clientCommand(gameEntity(slot, "ClientCommand"))
end function

function exportClientBegin(slot)
  global activeGameExport
  return activeGameExport.clientBegin(gameEntity(slot, "ClientBegin"))
end function

function exportClientDisconnect(slot)
  global activeGameExport
  return activeGameExport.clientDisconnect(gameEntity(slot, "ClientDisconnect"))
end function

function installGameExport(gameExport)
  global activeGameExport
  if typeof(gameExport) != "struct" or gameExport.apiVersion != gc.GAME_API_VERSION then
    return error(7213, "runtime requires Game API version 3")
  end if
  if typeof(gameExport.clientConnect) != "function" or typeof(gameExport.clientUserinfoChanged) != "function" or
      typeof(gameExport.clientThink) != "function" or typeof(gameExport.clientCommand) != "function" or
      typeof(gameExport.clientBegin) != "function" then
    return error(7214, "game export is missing client callbacks")
  end if
  activeGameExport = gameExport
  return createWithDisconnect(exportClientConnect, exportClientUserinfoChanged, exportClientThink,
    exportClientCommand, exportClientBegin, exportClientDisconnect)
end function
