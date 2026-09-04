/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Regression: renderer factories must survive the complete product link graph. */
import miniquake2.runtime.diagnostics as productdiagnostics
import miniquake2.runtime.application as productapplication
import miniquake2.renderer.opengl as productopengl
import miniquake2.client.ui.commands as productcommands
import miniquake2.client.state as productclientstate
import miniquake2.protocol.types as productprotocoltypes
import miniquake2.server.snapshot as productsnapshot
import miniquake2.qcommon.types as productqtypes
import miniquake2.renderer.types as productrendertypes
import std.fs as productfs

// Assert the true test condition.
function assertTrue(value, label)
  if not value then return error(9981, label) end if
end function

// Build one pusher snapshot entity.
function pusherEntity(number, x, yaw)
  entity = productprotocoltypes.zeroEntityState()
  entity.number = number
  entity.modelIndex = 2
  entity.origin[0] = x
  entity.angles[1] = yaw
  return entity
end function

// Run this source file's command-line entry point.
function main(args)
  assertTrue(productdiagnostics.verifyLinkClosure(), "product linker closure")
  assertTrue(typeof(productapplication.previewMap) == "function", "application preview link")
  protectedSettings = productapplication.productSettingsDirectoryFrom(
    "C:\\Program Files (x86)\\Steam\\steamapps\\common\\Quake 2",
    "C:\\Users\\Tester\\AppData\\Local", "C:\\Program Files",
    "C:\\Program Files (x86)")
  portableSettings = productapplication.productSettingsDirectoryFrom(
    "D:\\Games\\Quake 2", "C:\\Users\\Tester\\AppData\\Local",
    "C:\\Program Files", "C:\\Program Files (x86)")
  assertTrue(protectedSettings ==
    "C:\\Users\\Tester\\AppData\\Local\\MiniQuake2",
    "protected retail root uses per-user settings")
  assertTrue(portableSettings == "D:\\Games\\Quake 2\\baseq2",
    "portable retail root keeps local settings")
  writableSettings = productapplication.productSettingsDirectory(
    "C:\\Program Files (x86)\\Steam\\steamapps\\common\\Quake 2")
  savePaths = productapplication.playSavePaths(
    "C:\\Program Files (x86)\\Steam\\steamapps\\common\\Quake 2", 1)
  currentPaths = productapplication.playCurrentArchivePaths(
    "C:\\Program Files (x86)\\Steam\\steamapps\\common\\Quake 2")
  assertTrue(savePaths[0] == productfs.joinPath(writableSettings,
      "miniquake2_slot2_game.sav") and
    savePaths[1] == productfs.joinPath(writableSettings,
      "miniquake2_slot2_level.sav") and
    currentPaths[0] == productfs.joinPath(writableSettings,
      "miniquake2_current_game.sav") and
    productapplication.playScreenshotDirectory(
      "C:\\Program Files (x86)\\Steam\\steamapps\\common\\Quake 2") ==
      productfs.joinPath(writableSettings, "screenshots") and
    productapplication.playDemoDirectory(
      "C:\\Program Files (x86)\\Steam\\steamapps\\common\\Quake 2") ==
      productfs.joinPath(writableSettings, "demos"),
    "all writable product data avoids the protected retail root")
  activeCommands = productcommands.create()
  activeCommands.serverMap = "q2dm3"
  activeCommands.serverRules = 0
  activeCommands.serverMaxClients = 8
  activeCommands.startServerRequested = true
  activeSelection = productapplication.takeActiveProductSelection(
    activeCommands, "profile", "config")
  assertTrue(activeSelection.action == "server" and
    activeSelection.mapName == "q2dm3" and
    activeSelection.serverOptions.maxClients == 8 and
    not activeCommands.startServerRequested,
    "active single-player menu hands start-server to the product loop")
  activeCommands.connectAddress = "127.0.0.1:27910"
  activeSelection = productapplication.takeActiveProductSelection(
    activeCommands, "profile", "config")
  assertTrue(activeSelection.action == "connect" and
    activeSelection.endpoint == "127.0.0.1:27910" and
    activeCommands.connectAddress == "",
    "active single-player menu hands connect to the product loop")
  pusherClient = productclientstate.create()
  pusherPlayer = productprotocoltypes.zeroPlayerState()
  productclientstate.acceptSnapshot(pusherClient, productsnapshot.SnapshotFrame(
    20, -1, 0, bytes([]), pusherPlayer, [pusherEntity(7, 0.0, 0.0)]))
  productclientstate.acceptSnapshot(pusherClient, productsnapshot.SnapshotFrame(
    21, 20, 0, bytes([]), pusherPlayer, [pusherEntity(7, 8.0, 0.0)]))
  stoppedOffset = productapplication.applicationPusherSnapshotOffset(
    pusherClient, 7, 0.0, productqtypes.vec3(20.0, 0.0, 0.0))
  assertTrue(stoppedOffset.x == -8.0 and stoppedOffset.y == 0.0 and
    stoppedOffset.z == 0.0,
    "stopped elevator derives rider offset from snapshots, not live velocity")
  finishedOffset = productapplication.applicationPusherSnapshotOffset(
    pusherClient, 7, 1.0, productqtypes.vec3(20.0, 0.0, 0.0))
  assertTrue(finishedOffset.x == 0.0 and finishedOffset.y == 0.0 and
    finishedOffset.z == 0.0, "pusher correction converges at current snapshot")
  // CL_CheckPredictionError already interpolates the full endpoint delta of a
  // rider carried by a translating pusher. The host must not add it twice at
  // any presentation phase between the two 10-Hz snapshots.
  phaseIndex = 0
  pusherPhases = [0.0, 0.25, 0.5, 0.75, 1.0]
  while phaseIndex < len(pusherPhases)
    phaseOffset = productapplication.applicationPusherPredictionOffset(
      pusherClient, 7, pusherPhases[phaseIndex],
      productqtypes.vec3(20.0, 0.0, 0.0))
    assertTrue(phaseOffset.x == 0.0 and phaseOffset.y == 0.0 and
      phaseOffset.z == 0.0,
      "translating elevator was corrected twice during interpolation")
    phaseIndex = phaseIndex + 1
  end while

  // Linear vertical lifts are the case most sensitive to a residual camera
  // bob. Their translation belongs exclusively to prediction-error easing;
  // the pusher correction must remain exactly zero at every render phase.
  verticalClient = productclientstate.create()
  verticalPrevious = pusherEntity(8, 0.0, 0.0)
  verticalCurrent = pusherEntity(8, 0.0, 0.0)
  verticalPrevious.origin[2] = 0.0
  verticalCurrent.origin[2] = 12.0
  productclientstate.acceptSnapshot(verticalClient, productsnapshot.SnapshotFrame(
    40, -1, 0, bytes([]), pusherPlayer, [verticalPrevious]))
  productclientstate.acceptSnapshot(verticalClient, productsnapshot.SnapshotFrame(
    41, 40, 0, bytes([]), pusherPlayer, [verticalCurrent]))
  verticalResidual = productapplication.applicationPusherPredictionOffset(
    verticalClient, 8, 0.5, productqtypes.vec3(0.0, 0.0, 32.0))
  assertTrue(verticalResidual.x == 0.0 and verticalResidual.y == 0.0 and
    verticalResidual.z == 0.0,
    "vertical lift does not retain a floating-point pusher residual")

  // A lost or delayed snapshot holds the already completed interpolation
  // phase. Resetting that phase from the unrelated usercmd timer would make
  // a static console image and an elevator camera jump back one snapshot.
  assertTrue(productapplication.applicationPresentationFraction(850, 800) ==
      0.5 and productapplication.applicationPresentationFraction(1050, 800) ==
      1.0 and productapplication.applicationPresentationFraction(1150, 800) ==
      1.0, "late snapshots hold the final presentation phase")
  cachedPresentation = productrendertypes.defaultRefDef(640, 480)
  rebuiltPresentation = productrendertypes.defaultRefDef(800, 600)
  frozenPresentation = productapplication.applicationResolvePresentationFrame(
    true, cachedPresentation, rebuiltPresentation)
  resumedPresentation = productapplication.applicationResolvePresentationFrame(
    false, cachedPresentation, rebuiltPresentation)
  assertTrue(nativeRawValue(frozenPresentation) == nativeRawValue(cachedPresentation) and
    nativeRawValue(resumedPresentation) == nativeRawValue(rebuiltPresentation),
    "console presentation uses one cached refdef until gameplay resumes")

  rotatingClient = productclientstate.create()
  productclientstate.acceptSnapshot(rotatingClient, productsnapshot.SnapshotFrame(
    30, -1, 0, bytes([]), pusherPlayer, [pusherEntity(7, 0.0, 0.0)]))
  productclientstate.acceptSnapshot(rotatingClient, productsnapshot.SnapshotFrame(
    31, 30, 0, bytes([]), pusherPlayer, [pusherEntity(7, 0.0, 90.0)]))
  rotatingOffset = productapplication.applicationPusherSnapshotOffset(
    rotatingClient, 7, 0.0, productqtypes.vec3(0.0, 10.0, 0.0))
  assertTrue(rotatingOffset.x != 0.0 or rotatingOffset.y != 0.0,
    "rotating pusher applies angular rider correction")
  rotatingResidual = productapplication.applicationPusherPredictionOffset(
    rotatingClient, 7, 0.5, productqtypes.vec3(0.0, 10.0, 0.0))
  assertTrue(rotatingResidual.x != 0.0 or rotatingResidual.y != 0.0,
    "rotating pusher retains nonlinear arc correction")
  renderer = productopengl.createOpenGlRenderer(false)
  assertTrue(typeof(renderer) == "struct", "product-graph renderer binding")
  assertTrue(typeof(renderer.state) == "struct", "product-graph renderer state")
  assertTrue(typeof(renderer.exports) == "struct", "product-graph renderer exports")
  renderer.exports.Init(void, void)
  renderer.exports.Shutdown()
  print "MiniQuake2 runtime renderer product-graph tests passed: 1"
  return 0
end function
