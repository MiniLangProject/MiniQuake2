/* Data-driven Main/Game/Video/Options menu lifecycle tests. */
import miniquake2.client.ui.constants as cuic
import miniquake2.client.ui.menu as cuimenu
import miniquake2.renderer.recording as recording

function uiMenuAssertEqual(actual, expected, name)
  if actual != expected then return error(8270, name + ": expected " + expected + ", got " + actual) end if
  return true
end function

uiMenuState = cuimenu.create()
uiMenuAssertEqual(len(uiMenuState.pages), 7, "default page count")
cuimenu.open(uiMenuState, "main")
cuimenu.handleKey(uiMenuState, cuic.K_DOWNARROW)
uiMenuAssertEqual(uiMenuState.cursor, 1, "cursor movement")
cuimenu.handleKey(uiMenuState, cuic.K_ENTER)
uiMenuAssertEqual(uiMenuState.currentPage, "video", "submenu activation")
cuimenu.handleKey(uiMenuState, cuic.K_DOWNARROW)
cuimenu.handleKey(uiMenuState, cuic.K_RIGHTARROW)
uiMenuCommands = cuimenu.drainCommands(uiMenuState)
uiMenuAssertEqual(uiMenuCommands[0], "vid_fullscreen 1", "toggle command")
cuimenu.handleKey(uiMenuState, cuic.K_ESCAPE)
uiMenuAssertEqual(uiMenuState.currentPage, "main", "parent navigation")
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
uiMenuAssertEqual(cuimenu.draw(uiMenuState, 640, 480, uiMenuRenderer.exports), 5, "main menu draw count")
uiMenuAssertEqual(len(bytes(recording.commandTrace(uiMenuRenderer))) > 0, true, "menu renderer callback trace")
uiMenuRenderer.exports.Shutdown()
uiMenuAssertEqual(typeof(try(cuimenu.open(uiMenuState, "missing"))), "error", "unknown page rejected")
print("MiniQuake2 client UI menu tests passed: 1")
