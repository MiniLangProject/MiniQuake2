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

const MINIQUAKE2_VERSION = "0.5.0-foundation"
const QUAKE2_REFERENCE_VERSION = "3.19"
const QUAKE2_PROTOCOL_VERSION = 34
const PORT_STAGE = "integrated-runtime-foundation"

// Print the small bootstrap command surface.
function printUsage()
  print "MiniQuake2 " + MINIQUAKE2_VERSION
  print "usage: MiniQuake2.exe [--data-root ROOT|--product-smoke ROOT [FRAMES]|--remote-product-smoke ROOT IPV4 [PORT] [FRAMES]|--help|--version|--diagnostics|--capabilities|--asset-smoke ROOT [MAP]|--campaign-session-smoke ROOT [MAPS]|--play-input-smoke ROOT [MAP] [STEPS]|--map-preview ROOT MAP [FRAMES]|--play ROOT MAP [FRAMES]|--cinematic ROOT NAME [FRAMES] [LOOP]|--demo ROOT NAME [FRAMES]|--media-sequence ROOT SPEC [FRAMES]|--video-restart-smoke ROOT [MAP]|--dedicated ROOT MAP [PORT] [FRAMES]|--listen ROOT MAP [FRAMES]|--connect IPV4 [PORT] [FRAMES]|--cli-smoke [TOKEN]]"
  print ""
  print "  --version             print the port and compatibility target"
  print "  --data-root ROOT      remember retail data root and launch the menu-first product"
  print "  --product-smoke ROOT [FRAMES] render the menu-first product without creating a map"
  print "  --remote-product-smoke ROOT IPV4 [PORT] [FRAMES] verify rendered Protocol-34 Join Server"
  print "  --diagnostics         print the current bootstrap contract"
  print "  --capabilities        list linked Quake II port subsystems"
  print "  --asset-smoke ROOT [MAP] validate retail PAK/BSP/MD2/WAV and one server frame"
  print "  --campaign-session-smoke ROOT [MAPS] rotate one UDP session through up to 39 retail maps"
  print "  --play-input-smoke ROOT [MAP] [STEPS] drive real UDP movement, weapon and snapshot input"
  print "  --map-preview ROOT MAP [FRAMES] open a native OpenGL BSP38 preview"
  print "  --play ROOT MAP [FRAMES] run the interactive local vertical slice (FRAMES=0 until closed)"
  print "  --cinematic ROOT NAME [FRAMES] [LOOP] play a retail CIN (FRAMES=0 until completion, LOOP=0|1)"
  print "  --media-sequence ROOT SPEC [FRAMES] play classic CIN/PCX/map +nextserver chains"
  print "  --demo ROOT NAME [FRAMES] play a release or Protocol-34 DM2 through the product renderer"
  print "  --video-restart-smoke ROOT [MAP] rebuild the live window/renderer and retail BSP resources"
  print "  --dedicated ROOT MAP [PORT] [FRAMES] run a Protocol-34 dedicated server (FRAMES=0 runs until stopped)"
  print "  --listen ROOT MAP [FRAMES] run a headless local client/listen-server session"
  print "  --connect IPV4 [PORT] [FRAMES] run a headless Protocol-34 interoperability client"
  print "  --cli-smoke [TOKEN]   verify argument handling without game data"
  print "  --help                print this help"
end function

function runDefaultProduct(root)
  result = runtimeApplication.runProduct(root, 0)
  print "MiniQuake2 product: PASS"
  print "  sessions=" + result[0] + " menu-frames=" + result[1] +
    " gameplay-frames=" + result[2]
  return 0
end function

function discoverDefaultProductRoot()
  return productStartup.discoverRetailRoot("miniquake2_data_root.txt",
    productStartup.standardRetailCandidates())
end function

function runDataRoot(args)
  if len(args) != 2 then return error(9967, "--data-root expects one Quake II install root") end if
  productStartup.persistSelectedRoot("miniquake2_data_root.txt", args[1])
  return runDefaultProduct(args[1])
end function

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

function printCapabilities()
  for each line in runtimeDiagnostics.capabilityLines()
    print line
  end for
  print "MiniQuake2 capabilities: PASS"
end function

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

function runMapPreview(args)
  if len(args) < 3 or len(args) > 4 then return error(9903, "--map-preview expects install root, map and optional frames") end if
  frameLimit = 600
  if len(args) == 4 then frameLimit = toNumber(args[3]) end if
  rendered = runtimeApplication.previewMap(args[1], args[2], frameLimit)
  print "MiniQuake2 map preview: PASS frames=" + rendered
  return 0
end function

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

function runPlay(args)
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
  if len(result) >= 15 and result[14] != "" then
    print "  missing-detail=" + result[14]
  end if
  return 0
end function

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
  return 0
end function

function runVideoRestartSmokeCommand(args)
  if len(args) < 2 or len(args) > 3 then
    return error(9911, "--video-restart-smoke expects install root and optional map")
  end if
  videoRestartMap = "base1"
  if len(args) == 3 then videoRestartMap = args[2] end if
  videoRestartResult = runtimeApplication.runRetailVideoRestartSmoke(args[1], videoRestartMap)
  print "MiniQuake2 video restart smoke: PASS"
  print "  generation=" + videoRestartResult[0] + " mode=" +
    videoRestartResult[1] + "x" + videoRestartResult[2] +
    " loading-frames=" + videoRestartResult[3] +
    " fullscreen=" + videoRestartResult[6]
  print "  visible-before=" + videoRestartResult[4] +
    " visible-after=" + videoRestartResult[5]
  return 0
end function

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
function main(args)
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
  if command == "--campaign-session-smoke" then return runCampaignSessionSmoke(args) end if
  if command == "--play-input-smoke" then return runPlayInputSmoke(args) end if
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
