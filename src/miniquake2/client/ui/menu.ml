/* Data-driven Quake II-style main/game/video/options menus. */
package miniquake2.client.ui.menu

import miniquake2.client.ui.constants as cuic
import miniquake2.client.ui.types as cuitypes

function action(id, label, command)
  return cuitypes.MenuItem(id, label, cuic.MENU_ACTION, 0.0, 0.0, 0.0, 0.0, [], command, true)
end function

function toggle(id, label, value, command)
  return cuitypes.MenuItem(id, label, cuic.MENU_TOGGLE, value, 0.0, 1.0, 1.0, ["off", "on"], command, true)
end function

function slider(id, label, value, minimum, maximum, step, command)
  return cuitypes.MenuItem(id, label, cuic.MENU_SLIDER, value, minimum, maximum, step, [], command, true)
end function

function choice(id, label, value, choices, command)
  return cuitypes.MenuItem(id, label, cuic.MENU_CHOICE, value, 0.0, len(choices) - 1, 1.0, choices, command, true)
end function

function label(id, text)
  return cuitypes.MenuItem(id, text, cuic.MENU_ACTION, 0.0, 0.0, 0.0, 0.0, [], "", false)
end function

function defaultPages()
  main = cuitypes.MenuPage("main", "QUAKE II", "", [
    action("game", "game", "menu:game"), action("video", "video", "menu:video"),
    action("options", "options", "menu:options"), action("quit", "quit", "quit")])
  game = cuitypes.MenuPage("game", "GAME", "main", [
    action("new_easy", "easy", "newgame easy"), action("new_medium", "medium", "newgame medium"),
    action("new_hard", "hard", "newgame hard"), action("load", "load game", "menu:load"),
    action("save", "save game", "menu:save")])
  video = cuitypes.MenuPage("video", "VIDEO", "main", [
    choice("mode", "video mode", 0, ["640x480", "800x600", "1024x768", "1280x720"], "vid_mode"),
    toggle("fullscreen", "fullscreen", 0, "vid_fullscreen"),
    slider("brightness", "brightness", 1.0, 0.5, 2.0, 0.1, "vid_gamma"),
    action("apply", "apply", "vid_restart")])
  options = cuitypes.MenuPage("options", "OPTIONS", "main", [
    slider("sensitivity", "mouse speed", 3.0, 1.0, 20.0, 0.5, "sensitivity"),
    toggle("alwaysrun", "always run", 0, "cl_run"),
    slider("volume", "sound volume", 0.7, 0.0, 1.0, 0.1, "s_volume"),
    action("keys", "customize controls", "menu:keys")])
  load = cuitypes.MenuPage("load", "LOAD GAME", "game", [
    action("load0", "slot 1", "load 0"), action("load1", "slot 2", "load 1"),
    action("load2", "slot 3", "load 2")])
  save = cuitypes.MenuPage("save", "SAVE GAME", "game", [
    action("save0", "slot 1", "save 0"), action("save1", "slot 2", "save 1"),
    action("save2", "slot 3", "save 2")])
  keys = cuitypes.MenuPage("keys", "CONTROLS", "options", [
    label("move", "WASD move / mouse look"), label("jump", "SPACE jump"),
    label("attack", "MOUSE1 attack"), label("use", "E use"),
    label("inventory", "I inventory"), label("console", "` console")])
  return [main, game, video, options, load, save, keys]
end function

function create()
  return cuitypes.MenuState(defaultPages(), "main", 0, false, [])
end function

function page(menu)
  for each value in menu.pages
    if value.id == menu.currentPage then return value end if
  end for
  return void
end function

function open(menu, id)
  for each value in menu.pages
    if value.id == id then menu.currentPage = id; menu.cursor = 0; menu.active = true; return true end if
  end for
  return error(8230, "unknown menu page")
end function

function move(menu, direction)
  current = page(menu)
  if current is void or len(current.items) == 0 then return false end if
  menu.cursor = menu.cursor + direction
  if menu.cursor < 0 then menu.cursor = len(current.items) - 1 end if
  if menu.cursor >= len(current.items) then menu.cursor = 0 end if
  return true
end function

function adjust(menu, direction)
  current = page(menu)
  if current is void or menu.cursor < 0 or menu.cursor >= len(current.items) then return false end if
  item = current.items[menu.cursor]
  if item.kind == cuic.MENU_TOGGLE then item.value = 1.0 - item.value
  else if item.kind == cuic.MENU_SLIDER or item.kind == cuic.MENU_CHOICE then
    item.value = item.value + item.step * direction
    if item.value < item.minimum then item.value = item.minimum end if
    if item.value > item.maximum then item.value = item.maximum end if
  else return false
  end if
  menu.commands = menu.commands + [item.command + " " + item.value]
  return true
end function

function activate(menu)
  current = page(menu)
  if current is void or menu.cursor < 0 or menu.cursor >= len(current.items) then return false end if
  item = current.items[menu.cursor]
  if item.enabled == false then return false end if
  data = bytes(item.command)
  if len(data) > 5 and decode(slice(data, 0, 5)) == "menu:" then return open(menu, decode(slice(data, 5, len(data) - 5))) end if
  if item.kind == cuic.MENU_TOGGLE or item.kind == cuic.MENU_SLIDER or item.kind == cuic.MENU_CHOICE then return adjust(menu, 1) end if
  menu.commands = menu.commands + [item.command]
  return true
end function

function handleKey(menu, key)
  if menu.active == false then return false end if
  if key == cuic.K_UPARROW then return move(menu, -1) end if
  if key == cuic.K_DOWNARROW then return move(menu, 1) end if
  if key == cuic.K_LEFTARROW then return adjust(menu, -1) end if
  if key == cuic.K_RIGHTARROW then return adjust(menu, 1) end if
  if key == cuic.K_ENTER then return activate(menu) end if
  if key == cuic.K_ESCAPE then
    current = page(menu)
    if current is not void and current.parent != "" then return open(menu, current.parent) end if
    menu.active = false; return true
  end if
  return false
end function

function itemValue(item)
  if item.kind == cuic.MENU_TOGGLE or item.kind == cuic.MENU_CHOICE then return item.choices[item.value] end if
  if item.kind == cuic.MENU_SLIDER then return item.value + "" end if
  return ""
end function

function drawText(exports, x, y, text)
  data = bytes(text)
  index = 0
  while index < len(data)
    exports.DrawChar(x + index * 8, y, data[index]); index = index + 1
  end while
end function

function draw(menu, screenWidth, screenHeight, exports)
  if menu.active == false then return 0 end if
  current = page(menu)
  if current is void then return error(8231, "active menu page missing") end if
  exports.DrawFadeScreen()
  x = screenWidth / 2 - 120
  y = screenHeight / 2 - (len(current.items) + 2) * 8
  drawText(exports, screenWidth / 2 - len(bytes(current.title)) * 4, y, current.title)
  y = y + 24
  index = 0
  while index < len(current.items)
    item = current.items[index]
    prefix = "  "
    if index == menu.cursor then prefix = "> " end if
    value = itemValue(item)
    drawText(exports, x, y, prefix + item.label)
    if value != "" then drawText(exports, x + 168, y, value) end if
    y = y + 16; index = index + 1
  end while
  return len(current.items) + 1
end function

function drainCommands(menu)
  output = menu.commands
  menu.commands = []
  return output
end function
