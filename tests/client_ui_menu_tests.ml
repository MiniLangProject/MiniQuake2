/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Data-driven Main/Game/Video/Options menu lifecycle tests. */
import miniquake2.client.ui.constants as cuic
import miniquake2.client.ui.menu as cuimenu
import miniquake2.renderer.recording as recording
import miniquake2.renderer.constants as uiMenuRendererConstants

function uiMenuAssertEqual(actual, expected, name)
  if actual != expected then return error(8270, name + ": expected " + expected + ", got " + actual) end if
  return true
end function

uiMenuState = cuimenu.create()
uiMenuAssertEqual(len(uiMenuState.pages), 16, "default page count")
cuimenu.open(uiMenuState, "main")
cuimenu.handleKey(uiMenuState, cuic.K_DOWNARROW)
uiMenuAssertEqual(uiMenuState.cursor, 1, "cursor movement")
cuimenu.handleKey(uiMenuState, cuic.K_ENTER)
uiMenuAssertEqual(uiMenuState.currentPage, "multiplayer", "multiplayer submenu activation")
cuimenu.handleKey(uiMenuState, cuic.K_DOWNARROW)
cuimenu.handleKey(uiMenuState, cuic.K_DOWNARROW)
cuimenu.handleKey(uiMenuState, cuic.K_ENTER)
uiMenuAssertEqual(uiMenuState.currentPage, "player", "player setup submenu activation")
cuimenu.handleKey(uiMenuState, cuic.K_BACKSPACE)
cuimenu.handleKey(uiMenuState, 50)
uiMenuAssertEqual(cuimenu.itemValue(cuimenu.itemById(uiMenuState, "player", "name")),
  "MiniQuake2", "player name field edit")
cuimenu.handleKey(uiMenuState, cuic.K_DOWNARROW)
cuimenu.handleKey(uiMenuState, cuic.K_RIGHTARROW)
uiMenuModelCommands = cuimenu.drainCommands(uiMenuState)
uiMenuAssertEqual(uiMenuModelCommands[0], "model 1", "player model choice command")
uiMenuAssertEqual(uiMenuModelCommands[1], "skin 0", "model synchronizes a valid skin")
uiMenuAssertEqual(cuimenu.playerPreviewPath(uiMenuState),
  "players/female/athena_i.pcx", "player preview follows model and skin")
uiMenuAssertEqual(cuimenu.playerPreviewModelPath(uiMenuState),
  "players/female/tris.md2", "player preview model follows model choice")
uiMenuAssertEqual(cuimenu.playerPreviewSkinPath(uiMenuState),
  "players/female/athena.pcx", "player preview skin follows skin choice")
cuimenu.handleKey(uiMenuState, cuic.K_DOWNARROW)
cuimenu.handleKey(uiMenuState, cuic.K_DOWNARROW)
cuimenu.handleKey(uiMenuState, cuic.K_RIGHTARROW)
uiMenuAssertEqual(cuimenu.drainCommands(uiMenuState)[0], "hand 1",
  "handedness choice command")
uiMenuAssertEqual(cuimenu.setItemValue(uiMenuState, "player", "hand", 2),
  true, "player setup value synchronization")
uiMenuAssertEqual(uiMenuState.pages[10].items[3].value, 2,
  "player setup value retained")
cuimenu.handleKey(uiMenuState, cuic.K_ESCAPE)
uiMenuAssertEqual(uiMenuState.currentPage, "multiplayer",
  "player setup parent navigation")
cuimenu.handleKey(uiMenuState, cuic.K_ESCAPE)
cuimenu.handleKey(uiMenuState, cuic.K_DOWNARROW)
cuimenu.handleKey(uiMenuState, cuic.K_DOWNARROW)
cuimenu.handleKey(uiMenuState, cuic.K_DOWNARROW)
cuimenu.handleKey(uiMenuState, cuic.K_ENTER)
uiMenuAssertEqual(uiMenuState.currentPage, "video", "submenu activation")
cuimenu.handleKey(uiMenuState, cuic.K_DOWNARROW)
cuimenu.handleKey(uiMenuState, cuic.K_RIGHTARROW)
uiMenuCommands = cuimenu.drainCommands(uiMenuState)
uiMenuAssertEqual(uiMenuCommands[0], "vid_fullscreen 1", "toggle command")
cuimenu.handleKey(uiMenuState, cuic.K_ESCAPE)
uiMenuAssertEqual(uiMenuState.currentPage, "main", "parent navigation")
cuimenu.open(uiMenuState, "options")
cuimenu.handleKey(uiMenuState, cuic.K_DOWNARROW)
cuimenu.handleKey(uiMenuState, cuic.K_ENTER)
uiMenuAssertEqual(cuimenu.drainCommands(uiMenuState)[0], "m_invert 1",
  "invert mouse toggle command")
cuimenu.handleKey(uiMenuState, cuic.K_DOWNARROW)
cuimenu.handleKey(uiMenuState, cuic.K_DOWNARROW)
cuimenu.handleKey(uiMenuState, cuic.K_DOWNARROW)
cuimenu.handleKey(uiMenuState, cuic.K_RIGHTARROW)
uiMenuAssertEqual(cuimenu.drainCommands(uiMenuState)[0], "crosshair 2",
  "crosshair choice command")
uiMenuState.cursor = 7
cuimenu.handleKey(uiMenuState, cuic.K_ENTER)
uiMenuAssertEqual(cuimenu.drainCommands(uiMenuState)[0], "reset_defaults",
  "reset defaults action command")
uiMenuState.cursor = 8
cuimenu.handleKey(uiMenuState, cuic.K_ENTER)
uiMenuAssertEqual(cuimenu.drainCommands(uiMenuState)[0], "go_console",
  "go to console action command")
cuimenu.open(uiMenuState, "load")
cuimenu.handleKey(uiMenuState, cuic.K_ENTER)
uiMenuAssertEqual(cuimenu.drainCommands(uiMenuState)[0], "load 0", "load slot command")
uiMenuAssertEqual(cuimenu.setItemLabel(uiMenuState, "load", "load0", "slot 1 - base1"),
  true, "persistent slot label update")
uiMenuAssertEqual(uiMenuState.pages[4].items[0].label, "slot 1 - base1",
  "persistent slot label retained")
cuimenu.open(uiMenuState, "keys")
uiMenuAssertEqual(cuimenu.activate(uiMenuState), true, "control binding action")
uiMenuAssertEqual(cuimenu.drainCommands(uiMenuState)[0], "bindcapture +forward",
  "control capture command")
cuimenu.open(uiMenuState, "main")

uiMenuRenderer = recording.createRecordingRenderer()
uiMenuRenderer.exports.Init(void, void)
uiMenuAssertEqual(cuimenu.mainCursorName(135.51), "m_cursor1",
  "fractional runtime clock uses integer cursor frame")
uiMenuAssertEqual(cuimenu.mainCursorName(1499.99), "m_cursor14",
  "cursor animation last frame")
uiMenuAssertEqual(cuimenu.mainCursorName(1500.0), "m_cursor0",
  "cursor animation wraps")
uiMenuAssertEqual(cuimenu.menuCursorGlyph(249.99), 12,
  "submenu cursor accepts fractional runtime clock")
uiMenuAssertEqual(cuimenu.menuCursorGlyph(250.0), 13,
  "submenu cursor advances")
uiMenuAssertEqual(cuimenu.menuCursorGlyph(500.0), 12,
  "submenu cursor wraps")
uiMenuAssertEqual(cuimenu.draw(uiMenuState, 640, 480, 1400,
  uiMenuRenderer.exports), 6, "main menu draw count")
cuimenu.open(uiMenuState, "game")
uiMenuAssertEqual(cuimenu.draw(uiMenuState, 640, 480, 135.51,
  uiMenuRenderer.exports), 7, "game menu fractional-clock draw count")
cuimenu.open(uiMenuState, "player")
uiMenuAssertEqual(cuimenu.draw(uiMenuState, 640, 480, 1400.0,
  uiMenuRenderer.exports), 6, "player setup 3-D draw count")
uiMenuPreviewFrame = uiMenuRenderer.state.lastRefDef
uiMenuAssertEqual(uiMenuPreviewFrame.x, 320, "player preview viewport x")
uiMenuAssertEqual(uiMenuPreviewFrame.y, 168, "player preview viewport y")
uiMenuAssertEqual(uiMenuPreviewFrame.width, 144, "player preview viewport width")
uiMenuAssertEqual(uiMenuPreviewFrame.height, 168, "player preview viewport height")
uiMenuAssertEqual(uiMenuPreviewFrame.rdFlags,
  uiMenuRendererConstants.RDF_NOWORLDMODEL, "player preview world suppression")
uiMenuAssertEqual(uiMenuPreviewFrame.numEntities, 1, "player preview entity count")
uiMenuAssertEqual(uiMenuPreviewFrame.entities[0].model.name,
  "players/female/tris.md2", "player preview registered model")
uiMenuAssertEqual(uiMenuPreviewFrame.entities[0].skin.name,
  "players/female/athena.pcx", "player preview registered skin")
uiMenuAssertEqual(uiMenuPreviewFrame.entities[0].flags,
  uiMenuRendererConstants.RF_FULLBRIGHT, "player preview full-bright flag")
uiMenuAssertEqual(uiMenuPreviewFrame.entities[0].angles.y, 140.0,
  "player preview rotation")
uiMenuAssertEqual(len(bytes(recording.commandTrace(uiMenuRenderer))) > 0, true, "menu renderer callback trace")
uiMenuRenderer.exports.Shutdown()
uiMenuAssertEqual(typeof(try(cuimenu.open(uiMenuState, "missing"))), "error", "unknown page rejected")
print("MiniQuake2 client UI menu tests passed: 1")
