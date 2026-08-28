/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

MiniQuake2 product entry point.  The runtime diagnostics package deliberately
pulls every completed port layer into one native MiniLang linker closure.
*/

import miniquake2.runtime.diagnostics as runtimeDiagnostics
import miniquake2.runtime.application as runtimeApplication
import miniquake2.qcommon.byteio as mainByteio
import miniquake2.runtime.product_startup as productStartup
import miniquake2.runtime.crash_report as crashReport

const MINIQUAKE2_VERSION = "0.5.0-foundation"
const QUAKE2_REFERENCE_VERSION = "3.19"
const QUAKE2_PROTOCOL_VERSION = 34
const PORT_STAGE = "integrated-runtime-foundation"

// Print the small bootstrap command surface.
function printUsage()
  print "MiniQuake2 " + MINIQUAKE2_VERSION
  print "usage: MiniQuake2.exe [--data-root ROOT|--product-smoke ROOT [FRAMES]|--remote-product-smoke ROOT IPV4 [PORT] [FRAMES]|--help|--version|--diagnostics|--capabilities|--asset-smoke ROOT [MAP]|--media-audit ROOT|--campaign-session-smoke ROOT [MAPS]|--changelevel-smoke ROOT [MAP] [NEXT] [FRAMES]|--play-input-smoke ROOT [MAP] [STEPS]|--projectile-visual-smoke ROOT [MAP] [FRAMES]|--weapon-wheel-smoke ROOT [MAP] [FRAMES]|--map-preview ROOT MAP [FRAMES]|--play ROOT MAP [FRAMES]|--cinematic ROOT NAME [FRAMES] [LOOP]|--demo ROOT NAME [FRAMES]|--media-sequence ROOT SPEC [FRAMES]|--video-restart-smoke ROOT [MAP] [MODE]|--dedicated ROOT MAP [PORT] [FRAMES]|--listen ROOT MAP [FRAMES]|--connect IPV4 [PORT] [FRAMES]|--cli-smoke [TOKEN]]"
  print ""
  print "  --version             print the port and compatibility target"
  print "  --data-root ROOT      remember retail data root and launch the menu-first product"
  print "  --product-smoke ROOT [FRAMES] render the menu-first product without creating a map"
  print "  --remote-product-smoke ROOT IPV4 [PORT] [FRAMES] verify rendered Protocol-34 Join Server"
  print "  --diagnostics         print the current bootstrap contract"
  print "  --capabilities        list linked Quake II port subsystems"
  print "  --asset-smoke ROOT [MAP] validate retail PAK/BSP/MD2/WAV and one server frame"
  print "  --media-audit ROOT    validate stock startup CIN/DM2/music media without a window"
  print "  --campaign-session-smoke ROOT [MAPS] rotate one UDP session through up to 39 retail maps"
  print "  --changelevel-smoke ROOT [MAP] [NEXT] [FRAMES] verify a retail intermission and fresh successor-map load"
  print "  --play-input-smoke ROOT [MAP] [STEPS] drive real UDP movement, weapon and snapshot input"
  print "  --projectile-visual-smoke ROOT [MAP] [FRAMES] verify live Blaster snapshot/render/effect visibility"
  print "  --weapon-wheel-smoke ROOT [MAP] [FRAMES] verify retail wheel input and rendered weapon transitions"
  print "  --map-preview ROOT MAP [FRAMES] open a native OpenGL BSP38 preview"
  print "  --play ROOT MAP [FRAMES] run the interactive local vertical slice (FRAMES=0 until closed)"
  print "  --cinematic ROOT NAME [FRAMES] [LOOP] play a retail CIN (FRAMES=0 until completion, LOOP=0|1)"
  print "  --media-sequence ROOT SPEC [FRAMES] play classic CIN/PCX/map +nextserver chains"
  print "  --demo ROOT NAME [FRAMES] play a release or Protocol-34 DM2 through the product renderer"
  print "  --video-restart-smoke ROOT [MAP] [MODE] apply a live video mode without rebuilding the active BSP"
  print "  --dedicated ROOT MAP [PORT] [FRAMES] run a Protocol-34 dedicated server (FRAMES=0 runs until stopped)"
  print "  --listen ROOT MAP [FRAMES] run a headless local client/listen-server session"
  print "  --connect IPV4 [PORT] [FRAMES] run a headless Protocol-34 interoperability client"
  print "  --cli-smoke [TOKEN]   verify argument handling without game data"
  print "  --help                print this help"
end function

// Run default product.
function runDefaultProduct(root)
  result = runtimeApplication.runProduct(root, 0)
  print "MiniQuake2 product: PASS"
  print "  sessions=" + result[0] + " menu-frames=" + result[1] +
    " gameplay-frames=" + result[2]
  return 0
end function

// Discover default product root.
function discoverDefaultProductRoot()
  return productStartup.discoverRetailRoot("miniquake2_data_root.txt",
    productStartup.standardRetailCandidates())
end function

// Run data root.
function runDataRoot(args)
  if len(args) != 2 then return error(9967, "--data-root expects one Quake II install root") end if
  productStartup.persistSelectedRoot("miniquake2_data_root.txt", args[1])
  return runDefaultProduct(args[1])
end function

// Run product smoke.
function runProductSmoke(args)
  if len(args) < 2 or len(args) > 3 then return error(9968, "--product-smoke expects install root and optional frames") end if
  productFrames = 2
  if len(args) == 3 then productFrames = mainByteio.truncInt(toNumber(args[2])) end if
  productResult = runtimeApplication.runProduct(args[1], productFrames)
  if productResult[0] != 0 or productResult[2] != 0 then
    return error(9969, "menu-first smoke created a gameplay session")
  end if
  print "MiniQuake2 menu-first product smoke: PASS"
  print "  menu-frames=" + productResult[1] + " sessions=" + productResult[0]
  return 0
end function

// Run remote product smoke.
function runRemoteProductSmoke(args)
  if len(args) < 3 or len(args) > 5 then return error(9977, "--remote-product-smoke expects root, IPv4, optional port and frames") end if
  remotePort = 27910
  remoteFrames = 4000
  if len(args) >= 4 then remotePort = mainByteio.truncInt(toNumber(args[3])) end if
  if len(args) == 5 then remoteFrames = mainByteio.truncInt(toNumber(args[4])) end if
  remoteResult = runtimeApplication.runRemoteProductSmoke(args[1],
    args[2] + ":" + remotePort, remoteFrames)
  if remoteResult[3] == "" then return error(9978, "remote product did not register a BSP") end if
  print "MiniQuake2 remote product smoke: PASS"
  print "  frames=" + remoteResult[0] + " map=" + remoteResult[3]
  return 0
end function

// Print stable build and compatibility identifiers for scripts and humans.
function printVersion()
  print "MiniQuake2 " + MINIQUAKE2_VERSION
  print "Quake II reference: " + QUAKE2_REFERENCE_VERSION
  print "Protocol: " + QUAKE2_PROTOCOL_VERSION
  print "Language: MiniLang"
end function

// Report capabilities that must remain usable without proprietary assets.
function printDiagnostics()
  if not runtimeDiagnostics.verifyLinkClosure() then return error(9901, "MiniQuake2 runtime linker closure failed") end if
  print "MiniQuake2 diagnostics"
  print "  version=" + MINIQUAKE2_VERSION
  print "  reference=Quake II " + QUAKE2_REFERENCE_VERSION
  print "  protocol=" + QUAKE2_PROTOCOL_VERSION
  print "  stage=" + PORT_STAGE
  print "  platform=windows-x64"
  print "  retail-data=not-required"
  print "MiniQuake2 diagnostics: PASS"
end function

// Print capabilities.
function printCapabilities()
  for each line in runtimeDiagnostics.capabilityLines()
    print line
  end for
  print "MiniQuake2 capabilities: PASS"
end function

// Run asset smoke.
function runAssetSmoke(args)
  if len(args) < 2 or len(args) > 3 then return error(9902, "--asset-smoke expects install root and optional map") end if
  mapName = "base1"
  if len(args) == 3 then mapName = args[2] end if
  result = runtimeApplication.assetSmoke(args[1], mapName)
  for each line in runtimeApplication.resultLines(result)
    print line
  end for
  print "MiniQuake2 asset smoke: PASS"
  return 0
end function

// Run map preview.
function runMapPreview(args)
  if len(args) < 3 or len(args) > 4 then return error(9903, "--map-preview expects install root, map and optional frames") end if
  frameLimit = 600
  if len(args) == 4 then frameLimit = toNumber(args[3]) end if
  rendered = runtimeApplication.previewMap(args[1], args[2], frameLimit)
  print "MiniQuake2 map preview: PASS frames=" + rendered
  return 0
end function

// Run campaign session smoke.
function runCampaignSessionSmoke(args)
  if len(args) < 2 or len(args) > 3 then return error(9908, "--campaign-session-smoke expects install root and optional map count") end if
  maximumMaps = len(runtimeApplication.campaignMapNames())
  if len(args) == 3 then maximumMaps = mainByteio.truncInt(toNumber(args[2])) end if
  result = runtimeApplication.runCampaignSessionSmoke(args[1], maximumMaps)
  print "MiniQuake2 campaign session smoke: PASS"
  print "  maps=" + result[0] + " changes=" + result[1] + " client-state=" + result[2] + " spawn-count=" + result[3]
  print "  steps=" + result[4] + " packets=" + result[5]
  return 0
end function

// Run change level smoke.
function runChangeLevelSmoke(args)
  if len(args) < 2 or len(args) > 5 then
    return error(9956, "--changelevel-smoke expects root, optional map, next map and frames")
  end if
  changeMap = "base1"
  changeNext = "base2"
  changeFrames = 240
  if len(args) >= 3 then changeMap = args[2] end if
  if len(args) >= 4 then changeNext = args[3] end if
  if len(args) == 5 then
    changeFrames = mainByteio.truncInt(toNumber(args[4]))
  end if
  changeResult = runtimeApplication.runChangeLevelSmoke(args[1], changeMap,
    changeNext, changeFrames)
  print "MiniQuake2 retail changelevel smoke: PASS"
  print "  from=" + changeResult[0] + " to=" + changeResult[1] +
    " successor-frames=" + changeResult[2] +
    " server-frame=" + changeResult[3] +
    " max-heap=" + changeResult[4]
  return 0
end function

// Run play input smoke.
function runPlayInputSmoke(args)
  if len(args) < 2 or len(args) > 4 then return error(9927, "--play-input-smoke expects install root, optional map and optional steps") end if
  playInputMap = "base1"
  playInputSteps = 48
  if len(args) >= 3 then playInputMap = args[2] end if
  if len(args) == 4 then playInputSteps = mainByteio.truncInt(toNumber(args[3])) end if
  playInputResult = runtimeApplication.runPlayInputSmoke(args[1], playInputMap, playInputSteps)
  print "MiniQuake2 play input smoke: PASS"
  print "  map=" + playInputResult.mapName + " steps=" + playInputResult.commandSteps +
    " snapshots=" + playInputResult.snapshots + " fire=" + playInputResult.fireCount +
    " items=" + playInputResult.itemDelta + " health=" + playInputResult.health
  print "  start=" + playInputResult.startOrigin.x + "," + playInputResult.startOrigin.y + "," + playInputResult.startOrigin.z +
    " end=" + playInputResult.endOrigin.x + "," + playInputResult.endOrigin.y + "," + playInputResult.endOrigin.z +
    " displacement2=" + playInputResult.planarDisplacement
  print "  packets=" + playInputResult.packets + " rejected=" + playInputResult.rejectedPackets
  return 0
end function

// Run play.
function runPlay(args)
  // Keep run play phases explicit: validate inputs, update owned state, then publish the result.
  if len(args) < 3 or len(args) > 4 then return error(9907, "--play expects install root, map and optional frames") end if
  frames = 0
  if len(args) == 4 then frames = mainByteio.truncInt(toNumber(args[3])) end if
  result = runtimeApplication.runPlay(args[1], args[2], frames)
  print "MiniQuake2 interactive vertical slice: PASS"
  print "  frames=" + result[0] + " client-state=" + result[1] + " server-frame=" + result[2]
  print "  models=" + result[3] + " sounds=" + result[4] + " missing-assets=" + result[5] +
    " submitted-entities=" + result[6]
  print "  world-visible=" + result[7] + " world-culled=" + result[8] + " view-cluster=" + result[9]
  if len(result) >= 14 then
    print "  timing-ms client=" + result[10] + " world=" + result[11] +
      " entities=" + result[12] + " hud=" + result[13]
  end if
  if len(result) >= 18 then
    print "  timing-ms present=" + result[15] + " audio=" + result[16] +
      " frame=" + result[17]
  end if
  if len(result) >= 24 then
    print "  audio-buffers submitted=" + result[20] +
      " completed=" + result[21] + " underruns=" + result[22] +
      " capacity=" + result[23]
  end if
  if len(result) >= 26 then
    print "  max-frame-ms=" + result[24] +
      " first-audio-underrun-frame=" + result[25]
  end if
  if len(result) >= 29 then
    print "  heap-bytes current=" + result[26] + " maximum=" + result[27] +
      " observed-collections=" + result[28]
  end if
  if len(result) >= 37 then
    print "  max-frame-detail index=" + result[29] + " input=" + result[30] +
      " client=" + result[31] + " world=" + result[32] + " entities=" + result[33] +
      " hud=" + result[34] + " present=" + result[35] + " audio=" + result[36]
  end if
  if len(result) >= 43 then
    print "  heap-growth input=" + result[37] + " client=" + result[38] +
      " world=" + result[39] + " entities=" + result[40] + " hud=" + result[41] +
      " audio=" + result[42]
  end if
  if len(result) >= 44 then
    print "  timing-ms input-total=" + result[43]
  end if
  if len(result) >= 15 and result[14] != "" then
    print "  missing-detail=" + result[14]
  end if
  return 0
end function

// Run projectile visual smoke.
function runProjectileVisualSmoke(args)
  if len(args) < 2 or len(args) > 4 then
    return error(9930, "--projectile-visual-smoke expects install root, optional map and optional frames")
  end if
  mapName = "base1"
  frames = 360
  if len(args) >= 3 then mapName = args[2] end if
  if len(args) == 4 then frames = mainByteio.truncInt(toNumber(args[3])) end if
  result = runtimeApplication.runProjectileVisualSmoke(args[1], mapName, frames)
  if result[1] < 1 then return error(9931, "Automated blaster attack produced no network command") end if
  if result[2] < 1 then return error(9932, "Blaster projectile was not spawned by the game") end if
  if result[4] < 1 then return error(9933, "Blaster projectile did not survive its spawn frame; linked=" + result[2] + " freed=" + result[3]) end if
  if result[5] < 1 then return error(9934, "Blaster projectile was not published as an export edict") end if
  if result[6] < 1 then return error(9935, "Blaster projectile was removed by server visibility filtering: " + result[10]) end if
  if result[7] < 1 then return error(9936, "Blaster projectile was lost during snapshot transport; attack=" + result[1] + " linked=" + result[2] + " freed=" + result[3] + " server=" + result[4] + " export=" + result[5] + " visible=" + result[6]) end if
  if result[8] < 1 then return error(9937, "Blaster projectile never reached the render frame") end if
  if result[9] < 1 then return error(9938, "Blaster projectile emitted no visible particles") end if
  print "MiniQuake2 projectile visual smoke: PASS"
  print "  attack-commands=" + result[1] + " linked=" + result[2] +
    " freed=" + result[3] + " server-max=" + result[4] +
    " export-max=" + result[5] + " visible-max=" + result[6] +
    " snapshot-max=" + result[7] + " render-max=" + result[8] +
    " particle-max=" + result[9]
  return 0
end function

// Run weapon wheel smoke.
function runWeaponWheelSmoke(args)
  if len(args) < 2 or len(args) > 4 then
    return error(9947, "--weapon-wheel-smoke expects install root, optional map and optional frames")
  end if
  wheelMap = "base1"
  wheelFrames = 900
  if len(args) >= 3 then wheelMap = args[2] end if
  if len(args) == 4 then wheelFrames = mainByteio.truncInt(toNumber(args[3])) end if
  wheelResult = runtimeApplication.runWeaponWheelSmoke(args[1], wheelMap,
    wheelFrames)
  if wheelResult[1] != 3 then
    return error(9948, "wheel burst produced " + wheelResult[1] +
      " reliable weapon commands instead of 3")
  end if
  if wheelResult[2] < 3 or wheelResult[3] <= 0 then
    return error(9949, "retail wheel commands did not complete three rendered weapon transitions")
  end if
  print "MiniQuake2 weapon wheel smoke: PASS"
  print "  map=" + wheelMap + " commands=" + wheelResult[1] +
    " gun-transitions=" + wheelResult[2] + " final-gun-index=" + wheelResult[3]
  return 0
end function

// Run cinematic.
function runCinematic(args)
  if len(args) < 3 or len(args) > 5 then return error(9909, "--cinematic expects install root, name, optional frames and optional loop flag") end if
  frames = 0
  looping = false
  if len(args) >= 4 then frames = mainByteio.truncInt(toNumber(args[3])) end if
  if len(args) == 5 then looping = mainByteio.truncInt(toNumber(args[4])) != 0 end if
  result = runtimeApplication.runRetailCinematic(args[1], args[2], frames, looping)
  print "MiniQuake2 cinematic: PASS"
  print "  render-frames=" + result[0] + " status=" + result[1] + " stream-frame=" + result[2]
  print "  completions=" + result[3] + " dropped=" + result[4] + " mixed-frames=" + result[5] +
    " audio-device=" + result[6]
  return 0
end function

// Run media sequence.
function runMediaSequence(args)
  if len(args) < 3 or len(args) > 4 then return error(9910, "--media-sequence expects install root, level specification and optional frames") end if
  frames = 0
  if len(args) == 4 then frames = mainByteio.truncInt(toNumber(args[3])) end if
  result = runtimeApplication.runRetailMediaSequence(args[1], args[2], frames)
  print "MiniQuake2 media sequence: PASS"
  print "  steps=" + result[0] + " cinematics=" + result[1] +
    " pictures=" + result[2] + " maps=" + result[3] + " demos=" + result[5] +
    " status=" + result[4]
  print "  host-generation=" + result[6] + " loading-frames=" + result[7]
  return 0
end function

// Run demo.
function runDemo(args)
  if len(args) < 3 or len(args) > 4 then
    return error(9912, "--demo expects install root, name and optional frames")
  end if
  demoFrames = 0
  if len(args) == 4 then demoFrames = mainByteio.truncInt(toNumber(args[3])) end if
  demoResult = runtimeApplication.runRetailDemo(args[1], args[2], demoFrames)
  print "MiniQuake2 demo playback: PASS"
  print "  frames=" + demoResult[0] + " packets=" + demoResult[1] +
    " status=" + demoResult[2] + " map=" + demoResult[3]
  print "  models=" + demoResult[4] + " sounds=" + demoResult[5] +
    " missing-assets=" + demoResult[6] + " submitted-entities=" + demoResult[7] +
    " visible-surfaces=" + demoResult[8]
  print "  cdtrack=" + demoResult[9] + " ogg-active=" + demoResult[10]
  if len(demoResult) >= 15 then
    print "  elapsed-msec=" + demoResult[13] + " fps=" + demoResult[14]
  end if
  if demoResult[12] != "" then print "  missing-detail=" + demoResult[12] end if
  return 0
end function

// Run media audit.
function runMediaAudit(args)
  if len(args) != 2 then
    return error(9953, "--media-audit expects one Quake II install root")
  end if
  mediaAudit = runtimeApplication.runRetailMediaAudit(args[1])
  print "MiniQuake2 retail media audit: PASS"
  print "  startup=" + mediaAudit.attractSequence
  print "  newgame=" + mediaAudit.newGameSpecification
  print "  idlog=" + mediaAudit.idlog[1] + "x" + mediaAudit.idlog[2] +
    " rate=" + mediaAudit.idlog[3] + " first-audio=" + mediaAudit.idlog[4]
  print "  ntro=" + mediaAudit.intro[1] + "x" + mediaAudit.intro[2] +
    " rate=" + mediaAudit.intro[3] + " first-audio=" + mediaAudit.intro[4]
  print "  demo1 packets=" + mediaAudit.demo1[1] + " frames=" +
    mediaAudit.demo1[2] + " map=" + mediaAudit.demo1[3] +
    " cdtrack=" + mediaAudit.demo1[4]
  print "  demo2 packets=" + mediaAudit.demo2[1] + " frames=" +
    mediaAudit.demo2[2] + " map=" + mediaAudit.demo2[3] +
    " cdtrack=" + mediaAudit.demo2[4]
  print "  base1-cdtrack=" + mediaAudit.levelTrack + " ogg=" +
    mediaAudit.musicPath + " rate=" + mediaAudit.musicRate +
    " channels=" + mediaAudit.musicChannels +
    " frames=" + mediaAudit.musicFrames
  return 0
end function

// Run video restart smoke command.
function runVideoRestartSmokeCommand(args)
  if len(args) < 2 or len(args) > 4 then
    return error(9911, "--video-restart-smoke expects install root, optional map and mode")
  end if
  videoRestartMap = "base1"
  if len(args) >= 3 then videoRestartMap = args[2] end if
  videoRestartMode = 5
  if len(args) == 4 then
    videoRestartModeValue = toNumber(args[3])
    videoRestartMode = mainByteio.truncInt(videoRestartModeValue)
    if videoRestartModeValue != videoRestartMode or videoRestartMode < 0 or
        videoRestartMode > 7 then
      return error(9911, "--video-restart-smoke mode must be in [0,7]")
    end if
  end if
  videoRestartResult = runtimeApplication.runRetailVideoRestartSmokeForMode(
    args[1], videoRestartMap, videoRestartMode)
  print "MiniQuake2 video restart smoke: PASS"
  print "  generation=" + videoRestartResult[0] + " mode=" +
    videoRestartResult[1] + "x" + videoRestartResult[2] +
    " loading-frames=" + videoRestartResult[3] +
    " fullscreen=" + videoRestartResult[6] +
    " fallback=" + videoRestartResult[7] + " requested=" +
    videoRestartResult[8] + "x" + videoRestartResult[9] +
    " switch-ms=" + videoRestartResult[10] +
    " renderer-generation=" + videoRestartResult[11]
  print "  visible-before=" + videoRestartResult[4] +
    " visible-after=" + videoRestartResult[5]
  return 0
end function

// Run dedicated.
function runDedicated(args)
  if len(args) < 3 or len(args) > 5 then return error(9904, "--dedicated expects install root, map, optional port and optional frames") end if
  port = 27910
  frames = 0
  if len(args) >= 4 then port = mainByteio.truncInt(toNumber(args[3])) end if
  if len(args) == 5 then frames = mainByteio.truncInt(toNumber(args[4])) end if
  result = runtimeApplication.runDedicated(args[1], args[2], port, frames)
  print "MiniQuake2 dedicated server: PASS"
  print "  frames=" + result[0] + " received=" + result[1] + " sent=" + result[2] + " rejected=" + result[3]
  return 0
end function

// Run headless client.
function runHeadlessClient(args)
  if len(args) < 2 or len(args) > 4 then return error(9905, "--connect expects numeric IPv4, optional port and optional frames") end if
  port = 27910
  frames = 600
  if len(args) >= 3 then port = mainByteio.truncInt(toNumber(args[2])) end if
  if len(args) == 4 then frames = mainByteio.truncInt(toNumber(args[3])) end if
  result = runtimeApplication.runHeadlessClient(args[1], port, frames)
  print "MiniQuake2 Protocol-34 client: PASS"
  print "  frames=" + result[0] + " state=" + result[1] + " parsed=" + result[2]
  print "  received=" + result[3] + " sent=" + result[4] + " rejected=" + result[5]
  return 0
end function

// Run listen.
function runListen(args)
  if len(args) < 3 or len(args) > 4 then return error(9906, "--listen expects install root, map and optional frames") end if
  frames = 600
  if len(args) == 4 then frames = mainByteio.truncInt(toNumber(args[3])) end if
  result = runtimeApplication.runListen(args[1], args[2], frames)
  print "MiniQuake2 listen session: PASS"
  print "  frames=" + result[0] + " client-state=" + result[1] + " parsed=" + result[2]
  return 0
end function

// Exercise argv transport with an optional caller-provided token.
function runCliSmoke(args)
  token = "ready"
  if len(args) == 2 then token = args[1] end if
  if len(args) > 2 then
    print "MiniQuake2: --cli-smoke accepts at most one token"
    return 2
  end if
  print "MiniQuake2 CLI smoke: PASS"
  print "  argc=" + len(args)
  print "  token=" + token
  print "  protocol=" + QUAKE2_PROTOCOL_VERSION
  return 0
end function

// Dispatch the asset-free bootstrap commands.
function dispatchMain(args)
  // Keep main phases explicit: validate inputs, update owned state, then publish the result.
  if len(args) == 0 then
    productRoot = try(discoverDefaultProductRoot())
    if productRoot is error then
      print "MiniQuake2: " + productRoot.message
      print "Run MiniQuake2.exe --data-root \"C:\\path\\to\\Quake 2\" once."
      return 2
    end if
    return runDefaultProduct(productRoot)
  end if

  command = args[0]
  if command == "--help" and len(args) == 1 then printUsage(); return 0 end if
  if command == "--data-root" then return runDataRoot(args) end if
  if command == "--product-smoke" then return runProductSmoke(args) end if
  if command == "--remote-product-smoke" then return runRemoteProductSmoke(args) end if
  if command == "--version" and len(args) == 1 then printVersion(); return 0 end if
  if command == "--diagnostics" and len(args) == 1 then printDiagnostics(); return 0 end if
  if command == "--capabilities" and len(args) == 1 then printCapabilities(); return 0 end if
  if command == "--asset-smoke" then return runAssetSmoke(args) end if
  if command == "--media-audit" then return runMediaAudit(args) end if
  if command == "--campaign-session-smoke" then return runCampaignSessionSmoke(args) end if
  if command == "--changelevel-smoke" then return runChangeLevelSmoke(args) end if
  if command == "--play-input-smoke" then return runPlayInputSmoke(args) end if
  if command == "--projectile-visual-smoke" then return runProjectileVisualSmoke(args) end if
  if command == "--weapon-wheel-smoke" then return runWeaponWheelSmoke(args) end if
  if command == "--map-preview" then return runMapPreview(args) end if
  if command == "--play" then return runPlay(args) end if
  if command == "--cinematic" then return runCinematic(args) end if
  if command == "--media-sequence" then return runMediaSequence(args) end if
  if command == "--demo" then return runDemo(args) end if
  if command == "--video-restart-smoke" then return runVideoRestartSmokeCommand(args) end if
  if command == "--dedicated" then return runDedicated(args) end if
  if command == "--connect" then return runHeadlessClient(args) end if
  if command == "--listen" then return runListen(args) end if
  if command == "--cli-smoke" then return runCliSmoke(args) end if

  print "MiniQuake2: unknown or malformed command " + command
  printUsage()
  return 2
end function

// Catch every propagated MiniLang error at the process boundary. Keeping the
// original error value preserves its source file, line and function for the
// persistent report and the copyable Windows crash dialog.
function main(args)
  result = try(dispatchMain(args))
  if result is error then return crashReport.handle(result, MINIQUAKE2_VERSION) end if
  return result
end function
