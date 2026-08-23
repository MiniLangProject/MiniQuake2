/* Console/notify, HUD, inventory and centerprint composition tests. */
import miniquake2.client.ui.console as cuiconsole
import miniquake2.client.ui.menu as cuimenu
import miniquake2.client.ui.screen as cuiscreen
import miniquake2.client.ui.types as cuitypes
import miniquake2.qcommon.constants as qc
import miniquake2.renderer.recording as recording

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

uiScreenMenu = cuimenu.create()
uiScreenState = cuiscreen.create(uiScreenConsole, uiScreenMenu)
uiScreenState.layoutText = "xl 8 yt 8 string hud"
uiScreenState.inventory = [cuitypes.InventoryItem(1, "Blaster", 1), cuitypes.InventoryItem(2, "Shells", 20)]
uiScreenState.selectedInventory = 2
uiScreenState.showInventory = true
cuiscreen.centerPrint(uiScreenState, "MISSION\nSTART", 1000, 2500)

uiScreenStats = array(32, 0)
uiScreenConfig = array(qc.MAX_CONFIGSTRINGS, "")
uiScreenConfig[qc.CS_STATUSBAR] = "xv 0 yb -24 hnum"
uiScreenStats[1] = 100
uiScreenRenderer = recording.createRecordingRenderer()
uiScreenRenderer.exports.Init(void, void)
uiScreenCount = cuiscreen.draw(uiScreenState, 1200, 640, 480, uiScreenStats, uiScreenConfig, uiScreenRenderer.exports)
uiScreenAssertEqual(uiScreenCount > 4, true, "composed draw count")
uiScreenTrace = recording.commandTrace(uiScreenRenderer)
uiScreenAssertEqual(len(bytes(uiScreenTrace)) > 0, true, "renderer function-value handoff")

// Notify lines expire deterministically; centerprint disappears at duration.
uiScreenState.showInventory = false
uiScreenState.layoutText = ""
uiScreenConfig[qc.CS_STATUSBAR] = ""
uiScreenAssertEqual(cuiscreen.draw(uiScreenState, 5000, 640, 480, uiScreenStats, uiScreenConfig, uiScreenRenderer.exports), 0, "expired overlays")
uiScreenConsole.visibleFraction = 0.5
uiScreenAssertEqual(cuiconsole.draw(uiScreenConsole, 640, 480, uiScreenRenderer.exports) > 0, true, "full console draw")
uiScreenRenderer.exports.Shutdown()
print("MiniQuake2 client UI console/screen tests passed: 1")
