/* Key-destination router joining platform events to console, menu and game input. */
package miniquake2.client.ui.controller

import miniquake2.client.ui.constants as cuic
import miniquake2.client.ui.console as cuiconsole
import miniquake2.client.ui.input as cuiinput
import miniquake2.client.ui.keys as cuikeys
import miniquake2.client.ui.menu as cuimenu
import miniquake2.native as native
import miniquake2.platform.window as pwindow

function beginMessage(input, team)
  input.message = ""
  input.messageTeam = team
  cuikeys.setDestination(input, cuic.KEY_MESSAGE)
  return true
end function

function finishMessage(input)
  if input.message != "" then
    command = "say "
    if input.messageTeam then command = "say_team " end if
    input.commands = input.commands + [command + input.message]
  end if
  input.message = ""
  cuikeys.setDestination(input, cuic.KEY_GAME)
  return true
end function

function editMessage(input, key)
  data = bytes(input.message)
  if key == cuic.K_ENTER then return finishMessage(input) end if
  if key == cuic.K_ESCAPE then input.message = ""; cuikeys.setDestination(input, cuic.KEY_GAME); return true end if
  if key == cuic.K_BACKSPACE then
    if len(data) > 0 then input.message = decode(slice(data, 0, len(data) - 1)) end if
    return true
  end if
  if key >= 32 and key <= 126 and len(data) < 255 then input.message = input.message + decode(bytes([key])); return true end if
  return false
end function

function openMenu(input, screen)
  cuimenu.open(screen.menu, "main")
  cuikeys.setDestination(input, cuic.KEY_MENU)
  return true
end function

function handleEvent(input, screen, event, time)
  if event.type == cuic.EVENT_FOCUS then return cuikeys.handleEvent(input, event, time) end if
  key = cuikeys.eventKey(event)
  if key == 0 then return false end if
  down = event.value != 0
  if event.type == cuic.EVENT_MOUSE_WHEEL then down = true end if

  // Binding capture owns the next press before console/menu/game routing.
  // Releases still pass through the normal stuck-key prevention path.
  if input.captureCommand != "" and down then
    return cuikeys.handleEvent(input, event, time)
  end if

  // Always pass releases through, even if a menu opened while a +binding was
  // held. This is the original client's stuck-key prevention invariant.
  if down == false then return cuikeys.handleEvent(input, event, time) end if

  // Grave toggles the console independent of bindings.
  if key == 96 then
    if input.destination == cuic.KEY_CONSOLE then cuikeys.setDestination(input, cuic.KEY_GAME); screen.console.visibleFraction = 0.0
    else cuikeys.setDestination(input, cuic.KEY_CONSOLE); screen.console.visibleFraction = 0.5
    end if
    return true
  end if

  if input.destination == cuic.KEY_GAME then
    if key == cuic.K_ESCAPE then return openMenu(input, screen) end if
    return cuikeys.handleEvent(input, event, time)
  end if
  if input.destination == cuic.KEY_CONSOLE then
    if key == cuic.K_ESCAPE then cuikeys.setDestination(input, cuic.KEY_GAME); screen.console.visibleFraction = 0.0; return true end if
    return cuiconsole.editKey(screen.console, key)
  end if
  if input.destination == cuic.KEY_MESSAGE then return editMessage(input, key) end if
  if input.destination == cuic.KEY_MENU then
    handled = cuimenu.handleKey(screen.menu, key)
    if screen.menu.active == false then cuikeys.setDestination(input, cuic.KEY_GAME) end if
    return handled
  end if
  return false
end function

function poll(input, screen, time)
  count = 0
  // The Win32 bridge exposes relative motion as accumulated axes while
  // buttons, wheel and keys are discrete platform.window InputEvents.
  cuiinput.addMouseDelta(input, native.winMouseDx(), native.winMouseDy())
  event = pwindow.popInputEvent()
  while event is not void
    handleEvent(input, screen, event, time)
    count = count + 1
    event = pwindow.popInputEvent()
  end while
  return count
end function
