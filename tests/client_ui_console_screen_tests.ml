/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Console/notify, HUD, inventory and centerprint composition tests. */
import miniquake2.client.ui.console as cuiconsole
import miniquake2.client.ui.menu as cuimenu
import miniquake2.client.ui.screen as cuiscreen
import miniquake2.client.ui.types as cuitypes
import miniquake2.client.ui.keys as cuiscreenkeys
import miniquake2.qcommon.constants as qc
import miniquake2.renderer.recording as recording

// Assert the ui screen equal test condition.
function uiScreenAssertEqual(actual, expected, name)
  if actual != expected then return error(8260, name + ": expected " + expected + ", got " + actual) end if
  return true
end function

uiScreenConsole = cuiconsole.create(8)
cuiconsole.appendText(uiScreenConsole, "abcdefghijk\nready", 1000)
uiScreenAssertEqual(len(uiScreenConsole.lines), 3, "wrapped console lines")
uiScreenAssertEqual(uiScreenConsole.lines[0].text, "abcdefgh", "wrapped line contents")
for each uiScreenByte in bytes("map base1")
  cuiconsole.editKey(uiScreenConsole, uiScreenByte)
end for
cuiconsole.editKey(uiScreenConsole, 13)
uiScreenAssertEqual(cuiconsole.drainCommands(uiScreenConsole)[0], "map base1", "console command submit")
cuiconsole.editKey(uiScreenConsole, 128)
uiScreenAssertEqual(uiScreenConsole.input, "map base1", "console history recall")

uiScreenHistoryIndex = 0
while uiScreenHistoryIndex < 40
  uiScreenConsole.input = "cmd" + uiScreenHistoryIndex
  uiScreenConsole.cursor = len(bytes(uiScreenConsole.input))
  cuiconsole.editKey(uiScreenConsole, 13)
  cuiconsole.drainCommands(uiScreenConsole)
  uiScreenHistoryIndex = uiScreenHistoryIndex + 1
end while
uiScreenAssertEqual(len(uiScreenConsole.history), 32,
  "console retains stock 32-entry history bound")
uiScreenAssertEqual(uiScreenConsole.history[0], "cmd8",
  "console history drops oldest command at stock bound")
uiScreenAssertEqual(uiScreenConsole.history[31], "cmd39",
  "console history retains newest command")

uiScreenMenu = cuimenu.create()
uiScreenState = cuiscreen.create(uiScreenConsole, uiScreenMenu)
uiScreenCrosshairPosition = cuiscreen.crosshairPosition(640, 480, 24, 24)
uiScreenAssertEqual(uiScreenCrosshairPosition[0], 308, "crosshair centered x")
uiScreenAssertEqual(uiScreenCrosshairPosition[1], 228, "crosshair centered y")
uiScreenState.layoutText = "xl 8 yt 8 string hud"
uiScreenState.inventory = [cuitypes.InventoryItem(1, "Blaster", 1, "1"), cuitypes.InventoryItem(2, "Shells", 20, "2")]
uiScreenState.selectedInventory = 2
uiScreenState.showInventory = true
uiScreenInput = cuiscreenkeys.createInputState()
cuiscreenkeys.bind(uiScreenInput, 49, "use Blaster")
cuiscreen.updateInventoryHotkeys(uiScreenState, uiScreenInput)
uiScreenAssertEqual(uiScreenState.inventory[0].hotkey, "1",
  "inventory resolves use-item hotkey")
cuiscreen.centerPrint(uiScreenState, "MISSION\nSTART", 1000, 2500)

uiScreenStats = array(32, 0)
uiScreenConfig = array(qc.MAX_CONFIGSTRINGS, "")
uiScreenConfig[qc.CS_STATUSBAR] = "xv 0 yb -24 hnum"
uiScreenStats[1] = 100
uiScreenRenderer = recording.createRecordingRenderer()
uiScreenRenderer.exports.Init(void, void)
uiScreenCount = cuiscreen.draw(uiScreenState, 1200, 640, 480, uiScreenStats,
  uiScreenConfig, 12, 0, uiScreenRenderer.exports)
uiScreenAssertEqual(uiScreenCount > 4, true, "composed draw count")
uiScreenTrace = recording.commandTrace(uiScreenRenderer)
uiScreenAssertEqual(len(bytes(uiScreenTrace)) > 0, true, "renderer function-value handoff")

// Notify lines expire deterministically; centerprint disappears at duration.
uiScreenState.showInventory = false
uiScreenState.layoutText = ""
uiScreenConfig[qc.CS_STATUSBAR] = ""
uiScreenAssertEqual(cuiscreen.draw(uiScreenState, 5000, 640, 480, uiScreenStats,
  uiScreenConfig, 50, 0, uiScreenRenderer.exports), 0, "expired overlays")
// Truncated or hostile Protocol-34 layout strings must be isolated at the UI
// boundary instead of terminating a multiplayer client.
uiScreenState.layoutText = "if"
uiScreenConfig[qc.CS_STATUSBAR] = "if"
uiScreenMalformedDraw = try(cuiscreen.draw(uiScreenState, 5100, 640, 480,
  uiScreenStats, uiScreenConfig, 51, 0, uiScreenRenderer.exports))
uiScreenAssertEqual(uiScreenMalformedDraw is error, false,
  "malformed multiplayer layouts do not escape screen draw")
uiScreenAssertEqual(len(uiScreenState.statusbarTokens), 0,
  "malformed statusbar disabled after one report")
uiScreenAssertEqual(len(uiScreenState.layoutTokens), 0,
  "malformed transient layout disabled after one report")
uiScreenConsole.visibleFraction = 0.5
uiScreenAssertEqual(cuiconsole.draw(uiScreenConsole, 640, 480, uiScreenRenderer.exports) > 0, true, "full console draw")
uiScreenRenderer.exports.Shutdown()
print("MiniQuake2 client UI console/screen tests passed: 1")
