/* Original client menu/console pause policy for an authoritative listen server. */
package miniquake2.runtime.pause_policy

import miniquake2.client.ui.constants as pauseconstants

function shouldPause(maxClients, serverActive, destination)
  if typeof(maxClients) != "int" or maxClients < 1 then
    return error(8496, "pause maxClients must be positive")
  end if
  if typeof(serverActive) != "bool" then
    return error(8497, "pause server state must be boolean")
  end if
  if destination < pauseconstants.KEY_GAME or destination > pauseconstants.KEY_MENU then
    return error(8498, "pause key destination is invalid")
  end if
  if not serverActive or maxClients != 1 then return false end if
  return destination == pauseconstants.KEY_MENU or
    destination == pauseconstants.KEY_CONSOLE
end function
