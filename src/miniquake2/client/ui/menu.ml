/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Data-driven Quake II-style main/game/video/options menus. */
package miniquake2.client.ui.menu

import miniquake2.client.ui.constants as cuic
import miniquake2.client.ui.types as cuitypes
import miniquake2.qcommon.byteio as cuimenubyteio
import miniquake2.qcommon.types as cuimenuqtypes
import miniquake2.renderer.constants as cuimenurc
import miniquake2.renderer.types as cuimenurtypes

const MAX_MENU_COMMANDS = 16

menuPlayerPreviewLightStyles = void
menuEmptyCommands = []

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

function field(id, label, value, maximumLength, command)
  if typeof(value) != "string" then value = "" end if
  return cuitypes.MenuItem(id, label, cuic.MENU_FIELD, value, 0, maximumLength,
    1, [], command, true)
end function

function label(id, text)
  return cuitypes.MenuItem(id, text, cuic.MENU_ACTION, 0.0, 0.0, 0.0, 0.0, [], "", false)
end function

function defaultPages()
  main = cuitypes.MenuPage("main", "QUAKE II", "", [
    action("game", "game", "menu:game"),
    action("multiplayer", "multiplayer", "menu:multiplayer"),
    action("options", "options", "menu:options"),
    action("video", "video", "menu:video"),
    action("quit", "quit", "menu:quit")])
  game = cuitypes.MenuPage("game", "GAME", "main", [
    action("new_easy", "easy", "newgame easy"), action("new_medium", "medium", "newgame medium"),
    action("new_hard", "hard", "newgame hard"), action("load", "load game", "menu:load"),
    action("save", "save game", "menu:save"), action("credits", "credits", "menu:credits")])
  video = cuitypes.MenuPage("video", "VIDEO", "main", [
    choice("mode", "video mode", 0, ["640x480", "800x600", "1024x768",
      "1280x720", "1600x900", "1920x1080 (Full HD)", "2560x1440",
      "3840x2160 (4K)"], "vid_mode"),
    toggle("fullscreen", "fullscreen", 0, "vid_fullscreen"),
    slider("brightness", "brightness", 1.0, 0.5, 2.0, 0.1, "vid_gamma"),
    action("apply", "apply", "vid_restart")])
  options = cuitypes.MenuPage("options", "OPTIONS", "main", [
    slider("sensitivity", "mouse speed", 3.0, 1.0, 20.0, 0.5, "sensitivity"),
    toggle("invertmouse", "invert mouse", 0, "m_invert"),
    toggle("alwaysrun", "always run", 0, "cl_run"),
    slider("volume", "sound volume", 0.7, 0.0, 1.0, 0.1, "s_volume"),
    choice("crosshair", "crosshair", 1,
      ["off", "crosshair 1", "crosshair 2", "crosshair 3"], "crosshair"),
    toggle("joystick", "controller", 1, "in_joystick"),
    action("keys", "customize controls", "menu:keys"),
    action("defaults", "reset defaults", "reset_defaults"),
    action("console", "go to console", "go_console")])
  load = cuitypes.MenuPage("load", "LOAD GAME", "game", [
    action("load0", "slot 1", "load 0"), action("load1", "slot 2", "load 1"),
    action("load2", "slot 3", "load 2")])
  save = cuitypes.MenuPage("save", "SAVE GAME", "game", [
    action("save0", "slot 1", "save 0"), action("save1", "slot 2", "save 1"),
    action("save2", "slot 3", "save 2")])
  keys = cuitypes.MenuPage("keys", "CONTROLS", "options", [
    action("forward", "bind forward", "bindcapture +forward"),
    action("back", "bind back", "bindcapture +back"),
    action("left", "bind move left", "bindcapture +moveleft"),
    action("right", "bind move right", "bindcapture +moveright"),
    action("jump", "bind jump", "bindcapture +moveup"),
    action("attack", "bind attack", "bindcapture +attack"),
    action("use", "bind use", "bindcapture +use"),
    action("inventory", "bind inventory", "bindcapture inven"),
    label("hint", "ENTER, then key; ESC cancels")])
  multiplayer = cuitypes.MenuPage("multiplayer", "MULTIPLAYER", "main", [
    action("join", "join network server", "menu:join"),
    action("start", "start network server", "menu:start"),
    action("player", "player setup", "menu:player"),
    action("downloads", "download options", "menu:downloads"),
    action("disconnect", "disconnect", "disconnect")])
  player = cuitypes.MenuPage("player", "PLAYER SETUP", "multiplayer", [
    field("name", "name", "MiniQuake2", 15, "name"),
    choice("model", "model", 0, ["male", "female", "cyborg"], "model"),
    choice("skin", "skin", 3,
      ["cipher", "claymore", "flak", "grunt", "howitzer", "major",
       "nightops", "pointman", "psycho", "rampage", "razor", "recon",
       "scout", "sniper", "viper"], "skin"),
    choice("hand", "handedness", 0, ["right", "left", "center"], "hand"),
    label("preview", "player preview")])
  join = cuitypes.MenuPage("join", "JOIN SERVER", "multiplayer", [
    action("refresh", "refresh server list", "net_refresh"),
    action("addressbook", "address book", "menu:addressbook"),
    label("server0", "no local servers found"), label("server1", ""),
    label("server2", ""), label("server3", ""), label("server4", ""),
    label("server5", ""), label("server6", ""), label("server7", "")])
  addressbook = cuitypes.MenuPage("addressbook", "ADDRESS BOOK", "join", [
    field("address0", "address 1", "127.0.0.1:27910", 63, "connect"),
    field("address1", "address 2", "", 63, "connect"),
    field("address2", "address 3", "", 63, "connect"),
    field("address3", "address 4", "", 63, "connect"),
    field("address4", "address 5", "", 63, "connect"),
    field("address5", "address 6", "", 63, "connect"),
    field("address6", "address 7", "", 63, "connect"),
    field("address7", "address 8", "", 63, "connect")])
  start = cuitypes.MenuPage("start", "START SERVER", "multiplayer", [
    choice("map", "initial map", 0,
      ["base1", "q2dm1", "q2dm2", "q2dm3", "q2dm4", "q2dm5",
       "q2dm6", "q2dm7", "q2dm8"], "sv_map"),
    choice("rules", "rules", 0, ["deathmatch", "cooperative"], "sv_rules"),
    field("hostname", "hostname", "MiniQuake2", 63, "hostname"),
    slider("maxclients", "max players", 8, 2, 8, 1, "sv_maxclients"),
    slider("timelimit", "time limit", 0, 0, 60, 5, "timelimit"),
    slider("fraglimit", "frag limit", 0, 0, 100, 5, "fraglimit"),
    action("dmoptions", "deathmatch options", "menu:dmoptions"),
    action("begin", "begin", "startserver")])
  dmoptions = cuitypes.MenuPage("dmoptions", "DEATHMATCH OPTIONS", "start", [
    toggle("health", "allow health", 1, "dm_health"),
    toggle("items", "allow powerups", 1, "dm_items"),
    toggle("armor", "allow armor", 1, "dm_armor"),
    toggle("falling", "falling damage", 1, "dm_falling"),
    toggle("weaponsstay", "weapons stay", 0, "dm_weapons_stay"),
    toggle("instantitems", "instant powerups", 0, "dm_instant_items"),
    toggle("samelevel", "stay on same level", 0, "dm_same_level"),
    choice("teamplay", "teamplay", 0, ["off", "by skin", "by model"],
      "dm_teamplay"),
    toggle("friendlyfire", "friendly fire", 1, "dm_friendly_fire"),
    toggle("spawnfarthest", "spawn farthest", 0, "dm_spawn_farthest"),
    toggle("force_respawn", "force respawn", 0, "dm_force_respawn"),
    toggle("allowexit", "allow exit", 0, "dm_allow_exit"),
    toggle("infiniteammo", "infinite ammo", 0, "dm_infinite_ammo"),
    toggle("fixedfov", "fixed FOV", 0, "dm_fixed_fov"),
    toggle("quad_drop", "quad drop", 0, "dm_quad_drop")])
  downloads = cuitypes.MenuPage("downloads", "DOWNLOAD OPTIONS", "multiplayer", [
    toggle("allow", "allow downloading", 1, "allow_download"),
    toggle("maps", "maps", 1, "allow_download_maps"),
    toggle("models", "models", 1, "allow_download_models"),
    toggle("players", "player models/skins", 1, "allow_download_players"),
    toggle("sounds", "sounds", 1, "allow_download_sounds")])
  quit = cuitypes.MenuPage("quit", "QUIT", "main", [
    action("yes", "yes", "quit"), action("no", "no", "menu:main")])
  credits = cuitypes.MenuPage("credits", "CREDITS", "game", [
    label("id", "QUAKE II BY ID SOFTWARE"),
    label("port", "MINILANG PORT"),
    label("license", "GPL-2.0-OR-LATER")])
  // Keep the original seven page slots stable for save/load callers and add
  // the newly restored branches afterwards.
  return [main, game, video, options, load, save, keys, multiplayer, quit, credits,
    player, join, addressbook, start, dmoptions, downloads]
end function

function create()
  return cuitypes.MenuState(defaultPages(), "main", 0, false,
    array(MAX_MENU_COMMANDS), 0)
end function

function queueCommand(menu, command)
  if menu.commandCount >= len(menu.commands) then return error(8234, "menu command queue full") end if
  menu.commands[menu.commandCount] = command
  menu.commandCount = menu.commandCount + 1
  return true
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

function setItemLabel(menu, pageId, itemId, text)
  if typeof(text) != "string" then return error(8232, "menu label must be text") end if
  for each menuLabelPage in menu.pages
    if menuLabelPage.id == pageId then
      for each menuLabelItem in menuLabelPage.items
        if menuLabelItem.id == itemId then menuLabelItem.label = text; return true end if
      end for
      return error(8233, "menu item is unavailable")
    end if
  end for
  return error(8230, "unknown menu page")
end function

function setItemValue(menu, pageId, itemId, value)
  if (typeof(value) != "int" and typeof(value) != "float") or
      value != value then return error(8232, "menu value must be finite") end if
  for each menuValuePage in menu.pages
    if menuValuePage.id == pageId then
      for each menuValueItem in menuValuePage.items
        if menuValueItem.id == itemId then
          if menuValueItem.kind != cuic.MENU_TOGGLE and
              menuValueItem.kind != cuic.MENU_SLIDER and
              menuValueItem.kind != cuic.MENU_CHOICE then
            return error(8233, "menu item has no adjustable value")
          end if
          if value < menuValueItem.minimum or value > menuValueItem.maximum then
            return error(8233, "menu item value is outside its range")
          end if
          menuValueItem.value = value
          return true
        end if
      end for
      return error(8233, "menu item is unavailable")
    end if
  end for
  return error(8230, "unknown page")
end function

function setItemText(menu, pageId, itemId, value)
  if typeof(value) != "string" then return error(8232, "menu field value must be text") end if
  for each menuTextPage in menu.pages
    if menuTextPage.id == pageId then
      for each menuTextItem in menuTextPage.items
        if menuTextItem.id == itemId then
          if menuTextItem.kind != cuic.MENU_FIELD then return error(8233, "menu item is not a field") end if
          if len(bytes(value)) > menuTextItem.maximum then return error(8233, "menu field value is too long") end if
          menuTextItem.value = value
          return true
        end if
      end for
      return error(8233, "menu item is unavailable")
    end if
  end for
  return error(8230, "unknown page")
end function

function setActionCommand(menu, pageId, itemId, text, command, enabled)
  if typeof(text) != "string" or typeof(command) != "string" or typeof(enabled) != "bool" then
    return error(8232, "menu action update is invalid")
  end if
  for each menuActionPage in menu.pages
    if menuActionPage.id == pageId then
      for each menuActionItem in menuActionPage.items
        if menuActionItem.id == itemId then
          if menuActionItem.kind != cuic.MENU_ACTION then return error(8233, "menu item is not an action") end if
          menuActionItem.label = text
          menuActionItem.command = command
          menuActionItem.enabled = enabled
          return true
        end if
      end for
      return error(8233, "menu item is unavailable")
    end if
  end for
  return error(8230, "unknown page")
end function

function itemById(menu, pageId, itemId)
  for each menuFindPage in menu.pages
    if menuFindPage.id == pageId then
      for each menuFindItem in menuFindPage.items
        if menuFindItem.id == itemId then return menuFindItem end if
      end for
      return void
    end if
  end for
  return void
end function

function playerSkinChoices(modelName)
  if modelName == "female" then
    return ["athena", "brianna", "cobalt", "ensign", "jezebel", "jungle",
      "lotus", "stiletto", "venus", "voodoo"]
  end if
  if modelName == "cyborg" then return ["oni911", "ps9000", "tyr574"] end if
  return ["cipher", "claymore", "flak", "grunt", "howitzer", "major",
    "nightops", "pointman", "psycho", "rampage", "razor", "recon",
    "scout", "sniper", "viper"]
end function

function synchronizePlayerSkins(menu)
  modelItem = itemById(menu, "player", "model")
  skinItem = itemById(menu, "player", "skin")
  if modelItem is void or skinItem is void then return false end if
  modelName = modelItem.choices[modelItem.value]
  skinItem.choices = playerSkinChoices(modelName)
  skinItem.minimum = 0
  skinItem.maximum = len(skinItem.choices) - 1
  skinItem.value = 0
  if modelName == "male" then skinItem.value = 3 end if
  return true
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
  queueCommand(menu, item.command + " " + item.value)
  if current.id == "player" and item.id == "model" then
    synchronizePlayerSkins(menu)
    skinItem = itemById(menu, "player", "skin")
    queueCommand(menu, "skin " + skinItem.value)
  end if
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
  if item.kind == cuic.MENU_FIELD then
    if item.value == "" then return false end if
    queueCommand(menu, item.command + " \"" + item.value + "\"")
    return true
  end if
  queueCommand(menu, item.command)
  return true
end function

function handleKey(menu, key)
  if menu.active == false then return false end if
  if menu.currentPage == "quit" then
    if key == 121 or key == 89 then return queueCommand(menu, "quit") end if
    if key == 110 or key == 78 then return open(menu, "main") end if
  end if
  if key == cuic.K_UPARROW then return move(menu, -1) end if
  if key == cuic.K_DOWNARROW then return move(menu, 1) end if
  if key == cuic.K_LEFTARROW then return adjust(menu, -1) end if
  if key == cuic.K_RIGHTARROW then return adjust(menu, 1) end if
  if key == cuic.K_ENTER then return activate(menu) end if
  current = page(menu)
  if current is not void and menu.cursor >= 0 and menu.cursor < len(current.items) then
    item = current.items[menu.cursor]
    if item.kind == cuic.MENU_FIELD then
      if key == cuic.K_BACKSPACE then
        fieldBytes = bytes(item.value)
        if len(fieldBytes) > 0 then item.value = decode(slice(fieldBytes, 0, len(fieldBytes) - 1)) end if
        return true
      end if
      if key >= 32 and key <= 126 and key != 34 and key != 59 and key != 92 and
          len(bytes(item.value)) < item.maximum then
        item.value = item.value + decode(bytes([key]))
        return true
      end if
    end if
  end if
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
  if item.kind == cuic.MENU_FIELD then return item.value end if
  return ""
end function

function playerPreviewPath(menu)
  modelItem = itemById(menu, "player", "model")
  skinItem = itemById(menu, "player", "skin")
  if modelItem is void or skinItem is void then return "" end if
  return "players/" + modelItem.choices[modelItem.value] + "/" +
    skinItem.choices[skinItem.value] + "_i.pcx"
end function

function playerPreviewModelPath(menu)
  modelItem = itemById(menu, "player", "model")
  if modelItem is void then return "" end if
  return "players/" + modelItem.choices[modelItem.value] + "/tris.md2"
end function

function playerPreviewSkinPath(menu)
  modelItem = itemById(menu, "player", "model")
  skinItem = itemById(menu, "player", "skin")
  if modelItem is void or skinItem is void then return "" end if
  return "players/" + modelItem.choices[modelItem.value] + "/" +
    skinItem.choices[skinItem.value] + ".pcx"
end function

// PlayerConfig_MenuDraw renders the selected player as a full-bright alias
// model in a world-less 144x168 view. Register calls are intentionally made
// here: the renderer deduplicates current-generation resources, while a map
// registration invalidates old handles and the next menu frame reacquires them.
function drawPlayerPreview(menu, screenWidth, screenHeight, now, exports)
  global menuPlayerPreviewLightStyles
  modelPath = playerPreviewModelPath(menu)
  skinPath = playerPreviewSkinPath(menu)
  if modelPath == "" or skinPath == "" then return 0 end if
  model = try(exports.RegisterModel(modelPath))
  if model is error or model is void then return 0 end if
  skin = try(exports.RegisterSkin(skinPath))
  if skin is error or skin is void then return 0 end if

  origin = cuimenuqtypes.vec3(80.0, 0.0, 0.0)
  angles = cuimenuqtypes.vec3(0.0,
    (cuimenubyteio.truncInt(now / 10.0) % 360) * 1.0, 0.0)
  entity = cuimenurtypes.entity(model, angles, origin, 0, origin, 0, 0.0,
    0, 0, 1.0, skin, cuimenurc.RF_FULLBRIGHT)
  if menuPlayerPreviewLightStyles is void then
    menuPlayerPreviewLightStyles = cuimenurtypes.defaultLightStyles()
  end if
  frame = cuimenurtypes.refDef(screenWidth / 2, screenHeight / 2 - 72,
    144, 168, 40.0, 46.0152553484846, cuimenuqtypes.zeroVec3(),
    cuimenuqtypes.zeroVec3(), [0.0, 0.0, 0.0, 0.0], now * 0.001,
    cuimenurc.RDF_NOWORLDMODEL, void, menuPlayerPreviewLightStyles,
    [entity], [], [])
  rendered = try(exports.RenderFrame(frame))
  if rendered is error then return 0 end if
  return 1
end function

function drawText(exports, x, y, text)
  data = bytes(text)
  index = 0
  while index < len(data)
    exports.DrawChar(x + index * 8, y, data[index]); index = index + 1
  end while
end function

function drawAltText(exports, x, y, text)
  data = bytes(text)
  index = 0
  while index < len(data)
    exports.DrawChar(x + index * 8, y, data[index] | 128); index = index + 1
  end while
end function

function bannerName(pageId)
  if pageId == "game" then return "m_banner_game" end if
  if pageId == "multiplayer" then return "m_banner_multiplayer" end if
  if pageId == "options" then return "m_banner_options" end if
  if pageId == "video" then return "m_banner_video" end if
  if pageId == "load" then return "m_banner_load_game" end if
  if pageId == "save" then return "m_banner_save_game" end if
  if pageId == "keys" then return "m_banner_customize" end if
  return ""
end function

function mainCursorName(now)
  cursorFrame = cuimenubyteio.truncInt(now / 100.0) % 15
  return "m_cursor" + cursorFrame
end function

function menuCursorGlyph(now)
  cursorFrame = cuimenubyteio.truncInt(now / 250.0) % 2
  return 12 + cursorFrame
end function

function drawMain(menu, screenWidth, screenHeight, now, exports)
  names = ["m_main_game", "m_main_multiplayer", "m_main_options",
    "m_main_video", "m_main_quit"]
  widest = 0
  index = 0
  while index < len(names)
    size = exports.DrawGetPicSize(names[index])
    if size.width > widest then widest = size.width end if
    index = index + 1
  end while
  yStart = screenHeight / 2 - 110
  xOffset = (screenWidth - widest + 70) / 2
  index = 0
  while index < len(names)
    name = names[index]
    if index == menu.cursor then name = name + "_sel" end if
    exports.DrawPic(xOffset, yStart + index * 40 + 13, name)
    index = index + 1
  end while
  exports.DrawPic(xOffset - 25, yStart + menu.cursor * 40 + 11,
    mainCursorName(now))
  plaqueSize = exports.DrawGetPicSize("m_main_plaque")
  plaqueX = xOffset - 30 - plaqueSize.width
  exports.DrawPic(plaqueX, yStart, "m_main_plaque")
  exports.DrawPic(plaqueX, yStart + plaqueSize.height + 5, "m_main_logo")
  return len(names) + 1
end function

function draw(menu, screenWidth, screenHeight, now, exports)
  if menu.active == false then return 0 end if
  current = page(menu)
  if current is void then return error(8231, "active menu page missing") end if
  exports.DrawFadeScreen()
  if current.id == "main" then return drawMain(menu, screenWidth, screenHeight, now, exports) end if
  if current.id == "quit" then
    quitSize = exports.DrawGetPicSize("quit")
    exports.DrawPic((screenWidth - quitSize.width) / 2,
      (screenHeight - quitSize.height) / 2, "quit")
    return 1
  end if
  x = screenWidth / 2 - 120
  y = screenHeight / 2 - (len(current.items) + 2) * 8
  banner = bannerName(current.id)
  if banner != "" then
    bannerSize = exports.DrawGetPicSize(banner)
    exports.DrawPic(screenWidth / 2 - bannerSize.width / 2,
      screenHeight / 2 - 110, banner)
  else
    drawText(exports, screenWidth / 2 - len(bytes(current.title)) * 4, y, current.title)
  end if
  y = y + 24
  index = 0
  while index < len(current.items)
    item = current.items[index]
    value = itemValue(item)
    if index == menu.cursor then exports.DrawChar(x, y, menuCursorGlyph(now)) end if
    if item.enabled then drawText(exports, x + 16, y, item.label)
    else drawAltText(exports, x + 16, y, item.label)
    end if
    if value != "" then drawText(exports, x + 168, y, value) end if
    y = y + 16; index = index + 1
  end while
  if current.id == "player" then
    drawPlayerPreview(menu, screenWidth, screenHeight, now, exports)
  end if
  return len(current.items) + 1
end function

function drainCommands(menu)
  // Keep the public state record compatible with callers which replace the
  // historic dynamic command array directly (tests, embedders and restored
  // state). Product input uses commandCount and the fixed reusable buffer.
  if menu.commandCount == 0 and len(menu.commands) > 0 and
      typeof(menu.commands[0]) == "string" then
    output = menu.commands
    menu.commands = array(MAX_MENU_COMMANDS)
    return output
  end if
  if menu.commandCount == 0 then return menuEmptyCommands end if
  output = array(menu.commandCount)
  index = 0
  while index < menu.commandCount
    output[index] = menu.commands[index]
    index = index + 1
  end while
  menu.commandCount = 0
  return output
end function
