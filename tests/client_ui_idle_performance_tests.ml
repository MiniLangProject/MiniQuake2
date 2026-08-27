/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Idle UI polling must reuse empty command and controller state.
*/
import miniquake2.audio.mixer as uiidleMixer
import miniquake2.client.ui.commands as uiidleCommands
import miniquake2.client.ui.console as uiidleConsole
import miniquake2.client.ui.controller as uiidleController
import miniquake2.client.ui.keys as uiidleKeys
import miniquake2.client.ui.menu as uiidleMenu
import miniquake2.client.ui.screen as uiidleScreen

// Assert the ui idle test condition.
function uiIdleAssert(value, name)
  if not value then return error(8320, name) end if
  return true
end function

uiIdleInput = uiidleKeys.createInputState()
uiIdleScreenState = uiidleScreen.create(uiidleConsole.create(40), uiidleMenu.create())
uiIdleCommandState = uiidleCommands.create()
uiIdleAudioMixer = uiidleMixer.create(8000)
uiidleController.configureGamepad(false)

// Warm every idle branch before measuring so the assertion covers only the
// steady rendered-frame path and remains independent of module initialization.
uiidleCommands.drain(uiIdleCommandState, uiIdleInput, uiIdleScreenState,
  uiIdleAudioMixer)
uiidleCommands.takeForwarded(uiIdleCommandState)
uiidleController.pollGamepad(uiIdleInput, uiIdleScreenState, 0)
uiIdleHeapBefore = heap_bytes_used()
uiIdleIteration = 0
while uiIdleIteration < 20000
  uiIdleAssert(uiidleCommands.drain(uiIdleCommandState, uiIdleInput,
    uiIdleScreenState, uiIdleAudioMixer) == 0, "idle command count")
  uiIdleAssert(len(uiidleCommands.takeForwarded(uiIdleCommandState)) == 0,
    "idle forwarded queue")
  uiIdleAssert(uiidleController.pollGamepad(uiIdleInput, uiIdleScreenState,
    uiIdleIteration) == 0, "disabled controller count")
  uiIdleIteration = uiIdleIteration + 1
end while
uiIdleHeapAfter = heap_bytes_used()
uiIdleAssert(uiIdleHeapAfter - uiIdleHeapBefore <= 4096,
  "idle UI loop allocated more than one heap page")

print("MiniQuake2 client UI idle performance tests passed: 1")
