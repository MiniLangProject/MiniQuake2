/* Deterministic keyboard/mouse InputEvent to Protocol-34 UserCmd tests. */
import miniquake2.client.ui.constants as cuic
import miniquake2.client.ui.keys as cuikeys
import miniquake2.client.ui.input as cuiinput
import miniquake2.client.ui.console as cuiconsole
import miniquake2.client.ui.controller as cuicontroller
import miniquake2.client.ui.menu as cuimenu
import miniquake2.client.ui.screen as cuiscreen
import miniquake2.platform.window as pwindow

function uiInputAssertEqual(actual, expected, name)
  if actual != expected then return error(8250, name + ": expected " + expected + ", got " + actual) end if
  return true
end function

function uiInputAssertNear(actual, expected, tolerance, name)
  difference = actual - expected
  if difference < 0.0 then difference = -difference end if
  if difference > tolerance then return error(8251, name + ": values differ") end if
  return true
end function

uiInputState = cuikeys.createInputState()
cuikeys.bind(uiInputState, 119, "+forward")
cuikeys.bind(uiInputState, cuic.K_MOUSE1, "+attack")
cuikeys.bind(uiInputState, cuic.K_MWHEELUP, "weapnext")

uiDefaultBindings = cuikeys.bindDefaultGame(cuikeys.createInputState())
uiInputAssertEqual(cuikeys.bindingFor(uiDefaultBindings, cuic.K_MWHEELUP),
  "weapnext", "default wheel next weapon")
uiInputAssertEqual(cuikeys.bindingFor(uiDefaultBindings, cuic.K_MWHEELDOWN),
  "weapprev", "default wheel previous weapon")
uiInputAssertEqual(cuikeys.bindingFor(uiDefaultBindings, 55),
  "use Rocket Launcher", "default rocket number key")
uiInputAssertEqual(cuikeys.bindingFor(uiDefaultBindings, 48),
  "use BFG10K", "default BFG number key")

// Set-1 scan 17 is W. Holding it yields the stock 200 u/s move.
cuikeys.handleEvent(uiInputState, pwindow.InputEvent(cuic.EVENT_SCAN_KEY, 17, 1), 1000)
uiInputState.lightLevel = 58
uiInputCmd1 = cuiinput.createUserCmd(uiInputState, 50)
uiInputAssertEqual(uiInputCmd1.msec, 50, "command msec")
uiInputAssertEqual(uiInputCmd1.forwardMove, 200.0, "forward move")
uiInputAssertEqual(uiInputCmd1.buttons & cuic.BUTTON_ANY, cuic.BUTTON_ANY, "any-key bit")
uiInputAssertEqual(uiInputCmd1.lightLevel, 58, "renderer light level copied to UserCmd")

cuikeys.handleEvent(uiInputState, pwindow.InputEvent(cuic.EVENT_MOUSE_BUTTON, 0, 1), 1050)
cuiinput.setImpulse(uiInputState, 7)
cuiinput.addMouseDelta(uiInputState, 10.0, -5.0)
uiInputCmd2 = cuiinput.createUserCmd(uiInputState, 50)
uiInputAssertEqual(uiInputCmd2.buttons & cuic.BUTTON_ATTACK, cuic.BUTTON_ATTACK, "attack bit")
uiInputAssertEqual(uiInputCmd2.impulse, 7, "one-shot impulse")
uiInputAssertNear(uiInputState.viewAngles[1], -0.66, 0.0001, "mouse yaw")
uiInputAssertNear(uiInputState.viewAngles[0], -0.33, 0.0001, "mouse pitch")
uiInputCmd3 = cuiinput.createUserCmd(uiInputState, 400)
uiInputAssertEqual(uiInputCmd3.msec, 200, "frame msec clamp")
uiInputAssertEqual(uiInputCmd3.impulse, 0, "impulse cleared")

// Packed negative wheel delta is 255; positive is next weapon.
cuikeys.handleEvent(uiInputState, pwindow.InputEvent(cuic.EVENT_MOUSE_WHEEL, 0, 1), 1100)
uiInputCommands = cuikeys.drainCommands(uiInputState)
uiInputAssertEqual(uiInputCommands[len(uiInputCommands) - 1], "weapnext", "wheel binding")

// Losing focus releases every held +binding and prevents stuck movement.
cuikeys.handleEvent(uiInputState, pwindow.InputEvent(cuic.EVENT_FOCUS, 0, 0), 1200)
uiInputCmd4 = cuiinput.createUserCmd(uiInputState, 16)
uiInputAssertEqual(uiInputCmd4.forwardMove, 0.0, "focus release")
cuikeys.drainCommands(uiInputState)
uiInputAssertEqual(cuikeys.scanKey(72), cuic.K_UPARROW, "navigation scan map")
uiInputAssertEqual(cuikeys.scanKey(30), 97, "letter scan map")

// The controls menu captures the next discrete press before destination
// routing and replaces the previous binding for that command.
cuikeys.bind(uiInputState, 119, "+forward")
cuikeys.beginBindingCapture(uiInputState, "+forward")
uiCaptureScreen = cuiscreen.create(cuiconsole.create(40), cuimenu.create())
cuimenu.open(uiCaptureScreen.menu, "keys")
cuikeys.setDestination(uiInputState, cuic.KEY_MENU)
cuicontroller.handleEvent(uiInputState, uiCaptureScreen,
  pwindow.InputEvent(cuic.EVENT_KEY, 114, 1), 1250)
uiInputAssertEqual(uiInputState.capturedKey, 114, "captured key")
uiInputAssertEqual(cuikeys.bindingFor(uiInputState, 114), "+forward", "captured binding")
uiInputAssertEqual(cuikeys.bindingFor(uiInputState, 119), "", "old command binding replaced")
cuikeys.beginBindingCapture(uiInputState, "+attack")
cuicontroller.handleEvent(uiInputState, uiCaptureScreen,
  pwindow.InputEvent(cuic.EVENT_KEY, cuic.K_ESCAPE, 1), 1251)
uiInputAssertEqual(uiInputState.capturedKey, -2, "capture escape cancellation")
uiInputAssertEqual(uiInputState.captureCommand, "", "capture cancellation cleared")

// The rendered view samples mouse input immediately while the prediction
// preview remains side-effect free until the network command consumes it.
uiPredictionInput = cuikeys.createInputState()
cuikeys.bind(uiPredictionInput, 119, "+forward")
cuikeys.handleEvent(uiPredictionInput,
  pwindow.InputEvent(cuic.EVENT_SCAN_KEY, 17, 1), 1260)
cuiinput.addMouseDelta(uiPredictionInput, 10.0, -5.0)
cuiinput.sampleView(uiPredictionInput, 16)
uiInputAssertNear(uiPredictionInput.viewAngles[1], -0.66, 0.0001,
  "render-frame mouse yaw")
uiPredictionPreview = cuiinput.previewUserCmd(uiPredictionInput, 40)
uiPredictionPreviewAgain = cuiinput.previewUserCmd(uiPredictionInput, 40)
uiInputAssertEqual(uiPredictionPreview.forwardMove, 200.0,
  "prediction preview movement")
uiInputAssertEqual(uiPredictionPreviewAgain.angles[1],
  uiPredictionPreview.angles[1], "prediction preview has no side effects")
uiPredictionSent = cuiinput.createSampledUserCmd(uiPredictionInput, 40)
uiInputAssertEqual(uiPredictionSent.angles[1], uiPredictionPreview.angles[1],
  "sampled command preserves immediate view")

// A negative m_pitch is the original Quake II convention for inverted mouse.
uiInvertedInput = cuikeys.createInputState()
uiInvertedInput.config.mousePitch = -uiInvertedInput.config.mousePitch
cuiinput.addMouseDelta(uiInvertedInput, 0.0, -5.0)
cuiinput.sampleView(uiInvertedInput, 16)
uiInputAssertNear(uiInvertedInput.viewAngles[0], 0.33, 0.0001,
  "negative mouse pitch inverts vertical look")

// Destination router edits the console, opens/closes the menu and submits chat.
uiInputScreen = cuiscreen.create(cuiconsole.create(40), cuimenu.create())
cuicontroller.handleEvent(uiInputState, uiInputScreen, pwindow.InputEvent(cuic.EVENT_KEY, 96, 1), 1300)
uiInputAssertEqual(uiInputState.destination, cuic.KEY_CONSOLE, "console destination")
cuicontroller.handleEvent(uiInputState, uiInputScreen, pwindow.InputEvent(cuic.EVENT_KEY, 120, 1), 1301)
uiInputAssertEqual(uiInputScreen.console.input, "x", "console destination edit")
cuicontroller.handleEvent(uiInputState, uiInputScreen, pwindow.InputEvent(cuic.EVENT_KEY, cuic.K_ESCAPE, 1), 1302)
cuicontroller.handleEvent(uiInputState, uiInputScreen, pwindow.InputEvent(cuic.EVENT_KEY, cuic.K_ESCAPE, 1), 1303)
uiInputAssertEqual(uiInputState.destination, cuic.KEY_MENU, "menu destination")
cuicontroller.handleEvent(uiInputState, uiInputScreen, pwindow.InputEvent(cuic.EVENT_KEY, cuic.K_ESCAPE, 1), 1304)
uiInputAssertEqual(uiInputState.destination, cuic.KEY_GAME, "menu close destination")
cuicontroller.beginMessage(uiInputState, true)
cuicontroller.handleEvent(uiInputState, uiInputScreen, pwindow.InputEvent(cuic.EVENT_KEY, 103, 1), 1305)
cuicontroller.handleEvent(uiInputState, uiInputScreen, pwindow.InputEvent(cuic.EVENT_KEY, 103, 0), 1306)
cuicontroller.handleEvent(uiInputState, uiInputScreen, pwindow.InputEvent(cuic.EVENT_KEY, cuic.K_ENTER, 1), 1307)
uiInputAssertEqual(cuikeys.drainCommands(uiInputState)[0], "say_team g", "message command")
print("MiniQuake2 client UI input tests passed: 1")
