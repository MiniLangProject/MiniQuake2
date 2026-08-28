/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Regression: renderer factories must survive the complete product link graph. */
import miniquake2.runtime.diagnostics as productdiagnostics
import miniquake2.runtime.application as productapplication
import miniquake2.renderer.opengl as productopengl
import miniquake2.client.ui.commands as productcommands
import std.fs as productfs

// Assert the true test condition.
function assertTrue(value, label)
  if not value then return error(9981, label) end if
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
  renderer = productopengl.createOpenGlRenderer(false)
  assertTrue(typeof(renderer) == "struct", "product-graph renderer binding")
  assertTrue(typeof(renderer.state) == "struct", "product-graph renderer state")
  assertTrue(typeof(renderer.exports) == "struct", "product-graph renderer exports")
  renderer.exports.Init(void, void)
  renderer.exports.Shutdown()
  print "MiniQuake2 runtime renderer product-graph tests passed: 1"
  return 0
end function
