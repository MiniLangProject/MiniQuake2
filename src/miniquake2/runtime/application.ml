/* Retail-data validation and one-frame dedicated runtime bootstrap. */
package miniquake2.runtime.application

import std.fs as appnativefs
import miniquake2.qcommon.filesystem as appfs
import miniquake2.qcommon.text as apptext
import miniquake2.format.bsp as appbsp
import miniquake2.format.md2 as appmd2
import miniquake2.audio.wav as appwav
import miniquake2.audio.device as appaudiodevice
import miniquake2.audio.mixer as appaudiomixer
import miniquake2.collision.model as appcollision
import miniquake2.game.null_game as appgame
import miniquake2.game.constants as appgameconstants
import miniquake2.server.game_bridge as appbridge
import miniquake2.game.base.spawn as appspawn
import miniquake2.platform.window as appwindow
import miniquake2.renderer.opengl as appgl
import miniquake2.renderer.types as apprtypes
import miniquake2.qcommon.types as appqtypes
import miniquake2.qcommon.constants as appqconstants
import miniquake2.qcommon.info as appinfo
import miniquake2.runtime.server_session as appsession
import miniquake2.runtime.client_session as appclientsession
import miniquake2.platform.system as appsystem
import miniquake2.qcommon.byteio as appbyteio
import miniquake2.runtime.preview_camera as appcamera
import miniquake2.client.ui.constants as appuiconstants
import miniquake2.client.ui.keys as appuikeys
import miniquake2.client.ui.input as appuiinput
import miniquake2.client.ui.controller as appuicontroller
import miniquake2.client.ui.console as appuiconsole
import miniquake2.client.ui.menu as appuimenu
import miniquake2.client.ui.screen as appuiscreen
import miniquake2.client.ui.commands as appuicommands
import miniquake2.client.ui.config as appuiconfig
import miniquake2.client.state as appclientstate
import miniquake2.client.prediction as appprediction
import miniquake2.client.effects.handoff as appeffecthandoff
import miniquake2.client.effects.entity as appentityeffects
import miniquake2.client.effects.state as appeffectstate
import miniquake2.client.cinematic.audio as appcinaudio
import miniquake2.client.cinematic.player as appcinplayer
import miniquake2.client.cinematic.picture as appcinpicture
import miniquake2.runtime.play_session as appplay
import miniquake2.runtime.campaign_playtest as appcampaignplaytest
import miniquake2.runtime.session_persistence as apppersistence
import miniquake2.runtime.media_sequence as appmediaseq
import miniquake2.runtime.product_host as appproducthost
import miniquake2.runtime.demo_session as appdemosession
import miniquake2.runtime.client_assets as appclientassets
import miniquake2.client.assets.registry as appassetregistry
import miniquake2.physics.vector as appphysicsvector
import miniquake2.runtime.product_startup as appstartup
import miniquake2.client.runtime.handoff as appruntimehandoff
import miniquake2.client.downloads as appdownloads
import miniquake2.client.demo_recording as appdemorecording
import miniquake2.client.screenshot as appscreenshot
import miniquake2.runtime.pause_policy as apppause
import miniquake2.runtime.save_metadata as appsavemetadata
import miniquake2.native as appnative

struct AssetSmokeResult
  mapPath
  mapFaces
  mapLeafs
  parsedEdicts
  skippedEdicts
  playerFrames
  soundSamples
  pakCount
end struct

struct ProductMenuSelection
  action
  mapName
  skill
  endpoint
  serverOptions
  playerProfile
  downloadPolicy
  frames
end struct

previewFileSystem = void
playAssetState = void
playAssetBindings = void
playClientRuntime = void
playEffectState = void
applicationRemoteRegistrationSession = void
applicationRemoteRegistrationFileSystem = void
applicationRemoteRegistrationRenderer = void
applicationRemoteRegistrationWorld = void
applicationRemoteRegistrationMap = void
applicationRemoteRegistrationCollision = void
applicationRemoteRegistrationMapPath = ""
applicationRemoteRegistrationAssets = void

function loadPreviewFile(path)
  global previewFileSystem
  if previewFileSystem is void then return error(9912, "preview filesystem is not active") end if
  return appfs.readFile(previewFileSystem, path)
end function

function applicationRendererNoResult0()
  return true
end function

function applicationRendererNoResult1(value)
  return true
end function

function applicationRendererNoResult2(first, second)
  return true
end function

function applicationRendererNoResult3(first, second, third)
  return true
end function

function applicationRendererZero0()
  return 0
end function

function applicationRendererEmpty1(value)
  return ""
end function

function applicationRendererVoid3(first, second, third)
  return void
end function

function applicationRendererMode(mode)
  return apprtypes.VideoModeInfo(false, 0, 0)
end function

function applicationRendererImports()
  return apprtypes.RefImport(
    applicationRendererNoResult2, applicationRendererNoResult2,
    applicationRendererNoResult1, applicationRendererZero0,
    applicationRendererEmpty1, applicationRendererNoResult2,
    applicationRendererNoResult2, loadPreviewFile,
    applicationRendererNoResult1, applicationRendererZero0,
    applicationRendererVoid3, applicationRendererNoResult2,
    applicationRendererNoResult2, applicationRendererMode,
    applicationRendererNoResult0, applicationRendererNoResult2
  )
end function

function loadPlaySound(name)
  global previewFileSystem
  if previewFileSystem is void then return void end if
  if typeof(name) != "string" or name == "" then return void end if
  applicationPlaySoundFileSystemHolder = previewFileSystem
  applicationPlaySoundPathHolder = name
  applicationPlaySoundLowerHolder = apptext.lower(applicationPlaySoundPathHolder)
  if not apptext.startsWith(applicationPlaySoundLowerHolder, "sound/") then
    applicationPlaySoundPathHolder = "sound/" + applicationPlaySoundPathHolder
  end if
  applicationPlaySoundDataHolder = try(appfs.readFile(applicationPlaySoundFileSystemHolder, applicationPlaySoundPathHolder))
  if applicationPlaySoundDataHolder is error then return void end if
  applicationPlaySoundResultHolder = try(appwav.parse(applicationPlaySoundDataHolder, applicationPlaySoundPathHolder))
  if applicationPlaySoundResultHolder is error then return void end if
  return applicationPlaySoundResultHolder
end function

function noteMissingPlayAsset(value)
  return true
end function

function applicationRemoteFileExists(name)
  global previewFileSystem
  if previewFileSystem is void then return false end if
  return appfs.fileExists(previewFileSystem, name)
end function

function applicationRemoteRegisterDownload(kind, name)
  // Never send `begin` until the fully downloaded precache generation has
  // successfully entered the renderer/collision registry.
  if kind == "precache" then return applicationRegisterRemoteWorld() end if
  return true
end function

function playUserInfo(hand)
  if typeof(hand) != "int" or hand < 0 or hand > 2 then
    return error(9954, "play handedness must be 0, 1 or 2")
  end if
  return "\\name\\MiniQuake2\\skin\\male/grunt\\rate\\25000\\hand\\" + hand
end function

function playProfileUserInfo(profile)
  if profile is void then return playUserInfo(0) end if
  return appstartup.playerUserInfo(profile)
end function

function missingPlayAssetSummary(state)
  output = ""
  for each missing in appclientassets.missingAssets(state)
    if output != "" then output = output + ";" end if
    output = output + missing.kind + ":" + missing.name + "(" + missing.reason + ")"
  end for
  return output
end function

function resolvePlayModelIndex(index)
  global playAssetState
  if playAssetState is void then return void end if
  return appassetregistry.resolveModelIndex(playAssetState, index)
end function

function resolvePlayEffectModel(name)
  global playAssetState
  if playAssetState is void then return void end if
  return appassetregistry.resolveModelName(playAssetState, name)
end function

function randomPlayClientEffect()
  global playEffectState
  if playEffectState is void then return 0 end if
  return appeffectstate.random(playEffectState)
end function

function resolvePlayEntityPosition(number)
  global playClientRuntime
  if playClientRuntime is void or playClientRuntime.current is void then return void end if
  entity = appclientstate.findEntity(playClientRuntime.current.entities, number)
  if entity is void then return void end if
  return appqtypes.vec3(entity.origin[0], entity.origin[1], entity.origin[2])
end function

function pumpPlayAudio(device, mixer)
  if device is void or mixer is void then return 0 end if
  submitted = 0
  while appaudiodevice.queued(device) < 3 and submitted < 3
    samples = appaudiomixer.mix(mixer, 1024)
    if appaudiodevice.submit(device, samples) == 0 then return submitted end if
    submitted = submitted + 1
  end while
  return submitted
end function

function closePlayAudio(device, mixer)
  if mixer is not void then
    appaudiomixer.stopMusic(mixer)
    appaudiomixer.stopAll(mixer)
    mixer.channels = []
  end if
  if device is not void then appaudiodevice.reset(device); appaudiodevice.close(device) end if
  return void
end function

function countAvailableAssets(entries)
  count = 0
  for each entry in entries
    if entry is not void and entry.available then count = count + 1 end if
  end for
  return count
end function

function applyPlayHandoff(screen, handoff)
  if handoff is void then return false end if
  for each value in handoff.prints
    appuiconsole.appendLine(screen.console, value.text, value.time)
  end for
  for each value in handoff.centerPrints
    appuiscreen.centerPrint(screen, value.text, value.time, 2500)
  end for
  for each value in handoff.layouts
    screen.layoutText = value.text
  end for
  for each value in handoff.inventories
    applicationInventorySelected = 0
    if handoff.snapshot is not void and handoff.snapshot.playerState is not void and
        len(handoff.snapshot.playerState.stats) > appgameconstants.STAT_SELECTED_ITEM then
      applicationInventorySelected = handoff.snapshot.playerState.stats[appgameconstants.STAT_SELECTED_ITEM]
    end if
    appuiscreen.updateInventory(screen, value.values, handoff.configStrings,
      applicationInventorySelected)
  end for
  return true
end function

function playSavePaths(baseDirectory, slot)
  if typeof(slot) != "int" or slot < 0 or slot > 2 then return error(9925, "play save slot outside [0,2]") end if
  applicationSaveDirectory = appnativefs.joinPath(baseDirectory, appfs.BASE_DIRECTORY_NAME)
  applicationSaveStem = "miniquake2_slot" + (slot + 1)
  return [appnativefs.joinPath(applicationSaveDirectory, applicationSaveStem + "_game.sav"),
    appnativefs.joinPath(applicationSaveDirectory, applicationSaveStem + "_level.sav")]
end function

function playConfigPath(baseDirectory)
  if typeof(baseDirectory) != "string" or baseDirectory == "" then
    return error(9942, "product config requires the Quake II install root")
  end if
  return appnativefs.joinPath(appnativefs.joinPath(baseDirectory,
    appfs.BASE_DIRECTORY_NAME), "miniquake2.cfg")
end function

function playSaveMetadataPath(baseDirectory, slot)
  applicationSaveMetadataPaths = playSavePaths(baseDirectory, slot)
  return applicationSaveMetadataPaths[0] + ".meta"
end function

function playScreenshotDirectory(baseDirectory)
  return appnativefs.joinPath(appnativefs.joinPath(baseDirectory,
    appfs.BASE_DIRECTORY_NAME), "screenshots")
end function

function playDemoDirectory(baseDirectory)
  return appnativefs.joinPath(appnativefs.joinPath(baseDirectory,
    appfs.BASE_DIRECTORY_NAME), "demos")
end function

function endsWith(value, suffix)
  if typeof(value) != "string" or typeof(suffix) != "string" then return error(9916, "endsWith requires text") end if
  applicationEndsValueLowerHolder = apptext.lower(value)
  applicationEndsSuffixLowerHolder = apptext.lower(suffix)
  applicationEndsLeftHolder = bytes(applicationEndsValueLowerHolder)
  applicationEndsRightHolder = bytes(applicationEndsSuffixLowerHolder)
  applicationEndsLeftLength = len(applicationEndsLeftHolder)
  applicationEndsRightLength = len(applicationEndsRightHolder)
  if applicationEndsRightLength > applicationEndsLeftLength then return false end if
  applicationEndsOffset = applicationEndsLeftLength - applicationEndsRightLength
  applicationEndsIndex = 0
  while applicationEndsIndex < applicationEndsRightLength
    if applicationEndsLeftHolder[applicationEndsOffset + applicationEndsIndex] != applicationEndsRightHolder[applicationEndsIndex] then return false end if
    applicationEndsIndex = applicationEndsIndex + 1
  end while
  return true
end function

function mapPath(name)
  if typeof(name) != "string" or name == "" then return error(9917, "mapPath requires a map name") end if
  applicationMapPathValueHolder = name
  applicationMapPathLowerHolder = apptext.lower(applicationMapPathValueHolder)
  if not apptext.startsWith(applicationMapPathLowerHolder, "maps/") then
    applicationMapPathValueHolder = "maps/" + applicationMapPathValueHolder
  end if
  if not endsWith(applicationMapPathValueHolder, ".bsp") then
    applicationMapPathValueHolder = applicationMapPathValueHolder + ".bsp"
  end if
  return applicationMapPathValueHolder
end function

function cinematicPath(name)
  if typeof(name) != "string" or name == "" then return error(9921, "cinematicPath requires a cinematic name") end if
  applicationCinematicPathHolder = name
  applicationCinematicLowerHolder = apptext.lower(applicationCinematicPathHolder)
  if not apptext.startsWith(applicationCinematicLowerHolder, "video/") then
    applicationCinematicPathHolder = "video/" + applicationCinematicPathHolder
  end if
  if not endsWith(applicationCinematicPathHolder, ".cin") then
    applicationCinematicPathHolder = applicationCinematicPathHolder + ".cin"
  end if
  return applicationCinematicPathHolder
end function

function picturePath(name)
  if typeof(name) != "string" or name == "" then return error(9926, "picturePath requires a picture name") end if
  applicationPicturePathHolder = name
  applicationPictureLowerHolder = apptext.lower(applicationPicturePathHolder)
  if not apptext.startsWith(applicationPictureLowerHolder, "pics/") then
    applicationPicturePathHolder = "pics/" + applicationPicturePathHolder
  end if
  if not endsWith(applicationPicturePathHolder, ".pcx") then
    applicationPicturePathHolder = applicationPicturePathHolder + ".pcx"
  end if
  return applicationPicturePathHolder
end function

function demoPath(name)
  if typeof(name) != "string" or name == "" then return error(9948, "demoPath requires a demo name") end if
  applicationDemoPathHolder = name
  applicationDemoPathLowerHolder = apptext.lower(applicationDemoPathHolder)
  if not apptext.startsWith(applicationDemoPathLowerHolder, "demos/") then
    applicationDemoPathHolder = "demos/" + applicationDemoPathHolder
  end if
  if not endsWith(applicationDemoPathHolder, ".dm2") then
    applicationDemoPathHolder = applicationDemoPathHolder + ".dm2"
  end if
  return applicationDemoPathHolder
end function

// Product CIN lifecycle: retail FS -> Huffman frames/palette -> OpenGL raw
// stretch, with the CIN PCM stream feeding the same managed mixer/device used
// by gameplay. Escape opens/closes the existing menu and pauses/resumes both
// video time and its mixer channel without losing the current frame.
function runRetailCinematicOnHost(baseDirectory, name, frameLimit, looping, productHost)
  global previewFileSystem
  if typeof(baseDirectory) != "string" or baseDirectory == "" then return error(9922, "cinematic requires the Quake II install root") end if
  if typeof(frameLimit) != "int" or frameLimit < 0 or frameLimit > 36000 then return error(9923, "cinematic frame limit outside [0,36000]") end if
  if typeof(looping) != "bool" then return error(9924, "cinematic looping flag must be boolean") end if
  applicationCinematicFileSystemHolder = appfs.initialize(baseDirectory, "")
  previewFileSystem = applicationCinematicFileSystemHolder
  appproducthost.showProductLoading(productHost, "loading " + name)
  applicationCinematicPathHolder = cinematicPath(name)
  applicationCinematicDataHolder = appfs.readFile(applicationCinematicFileSystemHolder, applicationCinematicPathHolder)

  applicationCinematicWindowHolder = productHost.window
  applicationCinematicRendererHolder = productHost.renderer
  applicationCinematicMixerHolder = appaudiomixer.create(44100)
  appaudiomixer.setMasterVolume(applicationCinematicMixerHolder, 0.7)
  applicationCinematicMixerHandoffHolder = appcinaudio.mixerHandoff(applicationCinematicMixerHolder)
  applicationCinematicDeviceResultHolder = try(appaudiodevice.open(44100, 2, 16))
  applicationCinematicDeviceHolder = void
  if applicationCinematicDeviceResultHolder is not error then
    applicationCinematicDeviceHolder = applicationCinematicDeviceResultHolder
  end if
  applicationCinematicDeviceOpened = applicationCinematicDeviceHolder is not void

  applicationCinematicInputHolder = appuikeys.createInputState()
  applicationCinematicScreenHolder = appuiscreen.create(appuiconsole.create(80), appuimenu.create())
  applicationCinematicCommandStateHolder = appuicommands.create()
  applicationCinematicClockHolder = appsystem.createClock()
  applicationCinematicStarted = appbyteio.truncInt(appsystem.milliseconds(applicationCinematicClockHolder))
  applicationCinematicPlaybackHolder = appcinplayer.start(applicationCinematicDataHolder,
    applicationCinematicStarted, looping, applicationCinematicMixerHandoffHolder.callbacks)
  applicationCinematicFrames = 0
  applicationCinematicWasPaused = false
  applicationCinematicStats = array(32, 0)
  applicationCinematicConfigStrings = array(0)
  while (frameLimit == 0 or applicationCinematicFrames < frameLimit) and
      not appcinplayer.isFinished(applicationCinematicPlaybackHolder) and
      not applicationCinematicCommandStateHolder.quitRequested and
      appwindow.poll(applicationCinematicWindowHolder)
    applicationCinematicNow = appbyteio.truncInt(appsystem.milliseconds(applicationCinematicClockHolder))
    appuicontroller.poll(applicationCinematicInputHolder,
      applicationCinematicScreenHolder, applicationCinematicNow)
    appuicommands.drain(applicationCinematicCommandStateHolder,
      applicationCinematicInputHolder, applicationCinematicScreenHolder,
      applicationCinematicMixerHolder)
    applicationCinematicIgnoredCommands = appuicommands.takeForwarded(
      applicationCinematicCommandStateHolder)
    applicationCinematicPaused = applicationCinematicScreenHolder.menu.active
    if applicationCinematicPaused and not applicationCinematicWasPaused then
      appcinplayer.pause(applicationCinematicPlaybackHolder, applicationCinematicNow)
    else if not applicationCinematicPaused and applicationCinematicWasPaused then
      appcinplayer.resume(applicationCinematicPlaybackHolder, applicationCinematicNow)
    end if
    applicationCinematicWasPaused = applicationCinematicPaused
    if not applicationCinematicPaused then
      appcinplayer.update(applicationCinematicPlaybackHolder, applicationCinematicNow)
    end if

    applicationCinematicRendererHolder.exports.BeginFrame(0.0)
    appcinplayer.draw(applicationCinematicPlaybackHolder,
      applicationCinematicWindowHolder.width, applicationCinematicWindowHolder.height,
      applicationCinematicRendererHolder.exports)
    if applicationCinematicPaused then
      appuiscreen.draw(applicationCinematicScreenHolder, applicationCinematicNow,
        applicationCinematicWindowHolder.width, applicationCinematicWindowHolder.height,
        applicationCinematicStats, applicationCinematicConfigStrings,
        0, -1,
        applicationCinematicRendererHolder.exports)
    end if
    applicationCinematicRendererHolder.exports.EndFrame()
    pumpPlayAudio(applicationCinematicDeviceHolder, applicationCinematicMixerHolder)
    applicationCinematicFrames = applicationCinematicFrames + 1
    appsystem.sleep(8)
  end while

  applicationCinematicStatus = applicationCinematicPlaybackHolder.status
  applicationCinematicStreamFrame = applicationCinematicPlaybackHolder.frameNumber
  applicationCinematicCompletions = applicationCinematicPlaybackHolder.completions
  applicationCinematicDropped = applicationCinematicPlaybackHolder.droppedFrames
  applicationCinematicPainted = applicationCinematicMixerHolder.paintedFrames
  appcinplayer.stop(applicationCinematicPlaybackHolder)
  appcinplayer.draw(applicationCinematicPlaybackHolder,
    applicationCinematicWindowHolder.width, applicationCinematicWindowHolder.height,
    applicationCinematicRendererHolder.exports)
  closePlayAudio(applicationCinematicDeviceHolder, applicationCinematicMixerHolder)
  previewFileSystem = void
  return [applicationCinematicFrames, applicationCinematicStatus,
    applicationCinematicStreamFrame, applicationCinematicCompletions,
    applicationCinematicDropped, applicationCinematicPainted,
    applicationCinematicDeviceOpened]
end function

function runRetailCinematic(baseDirectory, name, frameLimit, looping)
  applicationCinematicProductHost = appproducthost.openProductHost(
    "MiniQuake2 Cinematic - " + name, 0, false, applicationRendererImports())
  applicationCinematicProductResult = try(runRetailCinematicOnHost(baseDirectory,
    name, frameLimit, looping, applicationCinematicProductHost))
  appproducthost.closeProductHost(applicationCinematicProductHost)
  if applicationCinematicProductResult is error then return applicationCinematicProductResult end if
  return applicationCinematicProductResult
end function

// Static intermission counterpart to runCinematic. Space/Enter emits the
// classic nextserver intent; Escape opens the same menu/quit lifecycle.
function runRetailPictureOnHost(baseDirectory, name, frameLimit, productHost)
  global previewFileSystem
  if typeof(baseDirectory) != "string" or baseDirectory == "" then return error(9927, "picture requires the Quake II install root") end if
  if typeof(frameLimit) != "int" or frameLimit < 0 or frameLimit > 36000 then return error(9928, "picture frame limit outside [0,36000]") end if
  applicationPictureFileSystemHolder = appfs.initialize(baseDirectory, "")
  previewFileSystem = applicationPictureFileSystemHolder
  appproducthost.showProductLoading(productHost, "loading " + name)
  applicationPicturePathHolder = picturePath(name)
  applicationPicturePlaybackHolder = appcinpicture.start(appfs.readFile(
    applicationPictureFileSystemHolder, applicationPicturePathHolder))
  applicationPictureWindowHolder = productHost.window
  applicationPictureRendererHolder = productHost.renderer
  applicationPictureMixerHolder = appaudiomixer.create(44100)
  appaudiomixer.setMasterVolume(applicationPictureMixerHolder, 0.7)
  applicationPictureInputHolder = appuikeys.createInputState()
  appuikeys.bind(applicationPictureInputHolder, appuiconstants.K_SPACE, "nextserver")
  appuikeys.bind(applicationPictureInputHolder, appuiconstants.K_ENTER, "nextserver")
  applicationPictureScreenHolder = appuiscreen.create(appuiconsole.create(80), appuimenu.create())
  applicationPictureCommandHolder = appuicommands.create()
  applicationPictureClockHolder = appsystem.createClock()
  applicationPictureFrames = 0
  applicationPictureAdvanced = false
  applicationPictureStats = array(32, 0)
  applicationPictureConfigStrings = array(0)
  while (frameLimit == 0 or applicationPictureFrames < frameLimit) and
      not applicationPictureAdvanced and not applicationPictureCommandHolder.quitRequested and
      appwindow.poll(applicationPictureWindowHolder)
    applicationPictureNow = appbyteio.truncInt(appsystem.milliseconds(applicationPictureClockHolder))
    appuicontroller.poll(applicationPictureInputHolder,
      applicationPictureScreenHolder, applicationPictureNow)
    appuicommands.drain(applicationPictureCommandHolder, applicationPictureInputHolder,
      applicationPictureScreenHolder, applicationPictureMixerHolder)
    applicationPictureForwarded = appuicommands.takeForwarded(applicationPictureCommandHolder)
    for each applicationPictureCommand in applicationPictureForwarded
      if apptext.equalInsensitive(applicationPictureCommand, "nextserver") then
        applicationPictureAdvanced = true
      end if
    end for
    applicationPictureRendererHolder.exports.BeginFrame(0.0)
    if applicationPictureScreenHolder.menu.active then
      if applicationPicturePlaybackHolder.paletteActive then
        applicationPictureRendererHolder.exports.CinematicSetPalette(void)
        applicationPicturePlaybackHolder.paletteActive = false
      end if
    else
      appcinpicture.draw(applicationPicturePlaybackHolder,
        applicationPictureWindowHolder.width, applicationPictureWindowHolder.height,
        applicationPictureRendererHolder.exports)
    end if
    appuiscreen.draw(applicationPictureScreenHolder, applicationPictureNow,
      applicationPictureWindowHolder.width, applicationPictureWindowHolder.height,
      applicationPictureStats, applicationPictureConfigStrings,
      0, -1,
      applicationPictureRendererHolder.exports)
    applicationPictureRendererHolder.exports.EndFrame()
    applicationPictureFrames = applicationPictureFrames + 1
    appsystem.sleep(8)
  end while
  applicationPictureStatus = applicationPicturePlaybackHolder.status
  applicationPictureWidth = applicationPicturePlaybackHolder.image.width
  applicationPictureHeight = applicationPicturePlaybackHolder.image.height
  appcinpicture.stop(applicationPicturePlaybackHolder)
  appcinpicture.draw(applicationPicturePlaybackHolder,
    applicationPictureWindowHolder.width, applicationPictureWindowHolder.height,
    applicationPictureRendererHolder.exports)
  previewFileSystem = void
  return [applicationPictureFrames, applicationPictureStatus,
    applicationPictureWidth, applicationPictureHeight, applicationPictureAdvanced]
end function

function runRetailPicture(baseDirectory, name, frameLimit)
  applicationPictureProductHost = appproducthost.openProductHost(
    "MiniQuake2 Picture - " + name, 0, false, applicationRendererImports())
  applicationPictureProductResult = try(runRetailPictureOnHost(baseDirectory,
    name, frameLimit, applicationPictureProductHost))
  appproducthost.closeProductHost(applicationPictureProductHost)
  if applicationPictureProductResult is error then return applicationPictureProductResult end if
  return applicationPictureProductResult
end function

function applicationSubmitDemoFrame(renderer, world, frame, screen, now,
    window, stats, configStrings)
  renderer.exports.RenderFrame(frame)
  applicationDemoSubmitStats = appgl.submitClassicWorld(renderer, world, frame)
  appuiscreen.draw(screen, now, window.width, window.height,
    stats, configStrings, 0, -1, renderer.exports)
  return applicationDemoSubmitStats
end function

// Product DM2 lifecycle. Release demos are Protocol 26 streams; DemoSession
// owns that isolated compatibility mode while all live networking remains 34.
// Configstrings drive the same BSP/model/sound registration and frame/effect
// handoff used by a connected game.
function runRetailDemoOnHost(baseDirectory, name, frameLimit, productHost)
  global previewFileSystem, playAssetState, playAssetBindings, playClientRuntime, playEffectState
  if typeof(baseDirectory) != "string" or baseDirectory == "" then
    return error(9949, "demo requires the Quake II install root")
  end if
  if typeof(frameLimit) != "int" or frameLimit < 0 or frameLimit > 36000 then
    return error(9950, "demo frame limit outside [0,36000]")
  end if
  applicationDemoFileSystemHolder = appfs.initialize(baseDirectory, "")
  previewFileSystem = applicationDemoFileSystemHolder
  appproducthost.showProductLoading(productHost, "loading " + name)
  applicationDemoFilePathHolder = demoPath(name)
  applicationDemoSessionHolder = appdemosession.create(appfs.readFile(
    applicationDemoFileSystemHolder, applicationDemoFilePathHolder), 19)
  applicationDemoWindowHolder = productHost.window
  applicationDemoRendererHolder = productHost.renderer
  applicationDemoWorldHolder = void
  applicationDemoMapHolder = void
  applicationDemoMapPathHolder = ""
  applicationDemoAssetStateHolder = void
  playClientRuntime = applicationDemoSessionHolder.runtime.client
  playEffectState = applicationDemoSessionHolder.runtime.effects

  applicationDemoMixerHolder = appaudiomixer.create(44100)
  appaudiomixer.setMasterVolume(applicationDemoMixerHolder, 0.7)
  applicationDemoDeviceResult = try(appaudiodevice.open(44100, 2, 16))
  applicationDemoDeviceHolder = void
  if applicationDemoDeviceResult is not error then
    applicationDemoDeviceHolder = applicationDemoDeviceResult
  end if
  applicationDemoInputHolder = appuikeys.createInputState()
  applicationDemoScreenHolder = appuiscreen.create(appuiconsole.create(80), appuimenu.create())
  applicationDemoCommandHolder = appuicommands.create()
  applicationDemoClockHolder = appsystem.createClock()
  applicationDemoRenderedFrames = 0
  applicationDemoLastWorldStats = void
  applicationDemoStatus = "preview"

  while (frameLimit == 0 or applicationDemoRenderedFrames < frameLimit) and
      not applicationDemoSessionHolder.finished and
      not applicationDemoCommandHolder.quitRequested and
      appwindow.poll(applicationDemoWindowHolder)
    applicationDemoStarted = appsystem.milliseconds(applicationDemoClockHolder)
    applicationDemoUiNow = appbyteio.truncInt(applicationDemoStarted)
    appuicontroller.poll(applicationDemoInputHolder, applicationDemoScreenHolder,
      applicationDemoUiNow)
    appuicommands.drain(applicationDemoCommandHolder, applicationDemoInputHolder,
      applicationDemoScreenHolder, applicationDemoMixerHolder)
    applicationDemoIgnoredCommands = appuicommands.takeForwarded(
      applicationDemoCommandHolder)
    if not applicationDemoScreenHolder.menu.active then
      applicationDemoStepHolder = appdemosession.step(applicationDemoSessionHolder,
        applicationDemoSessionHolder.framesRead * 100)
      if applicationDemoStepHolder is void then break end if
      applyPlayHandoff(applicationDemoScreenHolder,
        applicationDemoStepHolder.handoff)

      applicationDemoNextMapPath = appdemosession.mapModelPath(
        applicationDemoSessionHolder)
      if applicationDemoNextMapPath != "" and
          applicationDemoNextMapPath != applicationDemoMapPathHolder then
        if applicationDemoWorldHolder is not void then
          appgl.releaseClassicWorld(applicationDemoRendererHolder,
            applicationDemoWorldHolder)
        end if
        applicationDemoMapPathHolder = mapPath(applicationDemoNextMapPath)
        // BeginRegistration releases the previous step's renderer-owned BSP
        // before parsing the replacement map. Two expanded retail maps can
        // otherwise coexist transiently and exhaust the bounded product heap.
        applicationDemoRendererHolder.exports.BeginRegistration(
          applicationDemoMapPathHolder)
        applicationDemoMapHolder = appbsp.parse(appfs.readFile(
          applicationDemoFileSystemHolder, applicationDemoMapPathHolder),
          applicationDemoMapPathHolder)
        appgl.adoptClassicMapModel(applicationDemoRendererHolder,
          applicationDemoMapHolder, applicationDemoMapPathHolder)
        applicationDemoWorldHolder = appgl.prepareClassicWorld(
          applicationDemoRendererHolder, applicationDemoMapHolder,
          loadPreviewFile, apprtypes.defaultLightStyles(), 0, 1.0)
        applicationDemoAssetStateHolder = appclientassets.createForRenderer(
          applicationDemoRendererHolder.exports, loadPlaySound, noteMissingPlayAsset)
        playAssetState = applicationDemoAssetStateHolder
        appclientassets.registerConfigStrings(applicationDemoAssetStateHolder,
          applicationDemoSessionHolder.runtime.network.configStrings,
          applicationDemoMapPathHolder)
        playAssetBindings = appclientassets.bindings(applicationDemoAssetStateHolder)
        applicationDemoRendererHolder.exports.EndRegistration()
      end if

      if applicationDemoStepHolder.frames > 0 then
        if applicationDemoWorldHolder is void or
            applicationDemoAssetStateHolder is void then
          return error(9951, "demo snapshot arrived before map registration")
        end if
        appclientassets.refreshConfigStrings(applicationDemoAssetStateHolder,
          applicationDemoSessionHolder.runtime.network.configStrings)
        applicationDemoFrameHolder = appclientstate.buildRefDef(
          applicationDemoSessionHolder.runtime.client, 1.0,
          applicationDemoWindowHolder.width, applicationDemoWindowHolder.height,
          playAssetBindings,
          applicationDemoSessionHolder.runtime.network.playerNumber + 1,
          randomPlayClientEffect)
        applicationDemoAxesHolder = appphysicsvector.angleVectors(
          applicationDemoFrameHolder.viewAngles)
        appclientassets.attachMixer(applicationDemoAssetStateHolder,
          applicationDemoSessionHolder.runtime.effects,
          applicationDemoMixerHolder, resolvePlayEntityPosition,
          applicationDemoFrameHolder.viewOrigin, applicationDemoAxesHolder[1])
        appclientassets.setMixerListenerEntity(
          applicationDemoSessionHolder.runtime.network.playerNumber + 1)
        appclientassets.syncEntityLoops(applicationDemoMixerHolder,
          applicationDemoSessionHolder.runtime.client.current)
        appentityeffects.emit(applicationDemoSessionHolder.runtime.effects,
          applicationDemoSessionHolder.runtime.client.current,
          applicationDemoSessionHolder.runtime.client.previous, 1.0,
          applicationDemoSessionHolder.runtime.client.serverTime,
          applicationDemoSessionHolder.runtime.network.playerNumber + 1,
          applicationDemoFrameHolder)
        appeffecthandoff.apply(applicationDemoSessionHolder.runtime.effects,
          applicationDemoFrameHolder,
          applicationDemoSessionHolder.runtime.client.serverTime,
          resolvePlayEffectModel)
        applicationDemoRendererHolder.exports.BeginFrame(0.0)
        applicationDemoSubmitResult = try(applicationSubmitDemoFrame(
          applicationDemoRendererHolder, applicationDemoWorldHolder,
          applicationDemoFrameHolder, applicationDemoScreenHolder,
          applicationDemoUiNow, applicationDemoWindowHolder,
          applicationDemoSessionHolder.runtime.client.current.playerState.stats,
          applicationDemoSessionHolder.runtime.network.configStrings))
        applicationDemoEndFrameResult = try(
          applicationDemoRendererHolder.exports.EndFrame())
        if applicationDemoSubmitResult is error then
          return applicationDemoSubmitResult
        end if
        if applicationDemoEndFrameResult is error then
          return applicationDemoEndFrameResult
        end if
        applicationDemoLastWorldStats = applicationDemoSubmitResult
        pumpPlayAudio(applicationDemoDeviceHolder, applicationDemoMixerHolder)
        applicationDemoRenderedFrames = applicationDemoRenderedFrames + 1
        if frameLimit == 0 then
          applicationDemoElapsed = appsystem.milliseconds(applicationDemoClockHolder) -
            applicationDemoStarted
          if applicationDemoElapsed < 100 then
            appsystem.sleep(appbyteio.truncInt(100 - applicationDemoElapsed))
          end if
        end if
      end if
    else
      appsystem.sleep(8)
    end if
  end while

  if applicationDemoSessionHolder.finished then applicationDemoStatus = "completed" end if
  applicationDemoRegisteredModels = 0
  applicationDemoRegisteredSounds = 0
  applicationDemoMissingAssets = 0
  if applicationDemoAssetStateHolder is not void then
    applicationDemoRegisteredModels = countAvailableAssets(
      applicationDemoAssetStateHolder.modelEntries)
    applicationDemoRegisteredSounds = countAvailableAssets(
      applicationDemoAssetStateHolder.soundEntries)
    applicationDemoMissingAssets = len(appclientassets.missingAssets(
      applicationDemoAssetStateHolder))
  end if
  applicationDemoSubmittedEntities = applicationDemoRendererHolder.state.submittedEntities
  applicationDemoVisibleSurfaces = 0
  if applicationDemoLastWorldStats is not void then
    applicationDemoVisibleSurfaces = applicationDemoLastWorldStats.visibleSurfaces
  end if
  closePlayAudio(applicationDemoDeviceHolder, applicationDemoMixerHolder)
  appclientassets.releaseBindings()
  if applicationDemoWorldHolder is not void then
    appgl.releaseClassicWorld(applicationDemoRendererHolder,
      applicationDemoWorldHolder)
  end if
  applicationDemoPacketsRead = applicationDemoSessionHolder.packetsRead
  // These explicit root clears are required even when the compiler inlines a
  // media step into the sequence loop. The next BSP must not retain the
  // previous expanded map, snapshot history or client asset registry.
  applicationDemoMapHolder = void
  applicationDemoWorldHolder = void
  applicationDemoAssetStateHolder = void
  appdemosession.release(applicationDemoSessionHolder)
  applicationDemoSessionHolder = void
  applicationDemoFileSystemHolder = void
  previewFileSystem = void
  playAssetState = void
  playAssetBindings = void
  playClientRuntime = void
  playEffectState = void
  return [applicationDemoRenderedFrames,
    applicationDemoPacketsRead, applicationDemoStatus,
    applicationDemoMapPathHolder, applicationDemoRegisteredModels,
    applicationDemoRegisteredSounds, applicationDemoMissingAssets,
    applicationDemoSubmittedEntities, applicationDemoVisibleSurfaces]
end function

function runRetailDemo(baseDirectory, name, frameLimit)
  applicationDemoProductHost = appproducthost.openProductHost(
    "MiniQuake2 Demo - " + name, 3, false, applicationRendererImports())
  applicationDemoProductResult = try(runRetailDemoOnHost(baseDirectory,
    name, frameLimit, applicationDemoProductHost))
  appproducthost.closeProductHost(applicationDemoProductHost)
  if applicationDemoProductResult is error then return applicationDemoProductResult end if
  return applicationDemoProductResult
end function

// Execute the exact classic `map first+nextserver` media chain. A positive
// frame limit is a deterministic preview gate per step; zero retains normal
// interactive behavior (CIN to completion, PCX until Space/Enter, map until
// window close). DM2 uses the isolated release-demo Protocol-26 compatibility
// path and renders through the same Protocol-34 client state and product host.
function runRetailMediaSequenceOnHost(baseDirectory, specification, frameLimit,
    productHost, skill)
  if typeof(frameLimit) != "int" or frameLimit < 0 or frameLimit > 36000 then
    return error(9929, "media sequence frame limit outside [0,36000]")
  end if
  applicationMediaSequenceHolder = appmediaseq.parse(specification)
  applicationMediaCinematics = 0
  applicationMediaPictures = 0
  applicationMediaMaps = 0
  applicationMediaDemos = 0
  applicationMediaCompleted = 0
  applicationMediaIndex = 0
  while applicationMediaIndex < len(applicationMediaSequenceHolder.steps)
    applicationMediaStepHolder = applicationMediaSequenceHolder.steps[applicationMediaIndex]
    if not appproducthost.showProductLoading(productHost,
        "loading " + applicationMediaStepHolder.name) then
      return [applicationMediaCompleted, applicationMediaCinematics,
        applicationMediaPictures, applicationMediaMaps, "aborted",
        applicationMediaDemos]
    end if
    if applicationMediaStepHolder.kind == appmediaseq.MEDIA_CIN then
      applicationMediaCinematicResult = runRetailCinematicOnHost(baseDirectory,
        applicationMediaStepHolder.name, frameLimit, false, productHost)
      applicationMediaCinematics = applicationMediaCinematics + 1
      if frameLimit == 0 and applicationMediaCinematicResult[1] != "completed" then
        return [applicationMediaCompleted, applicationMediaCinematics,
          applicationMediaPictures, applicationMediaMaps, "aborted",
          applicationMediaDemos]
      end if
    else if applicationMediaStepHolder.kind == appmediaseq.MEDIA_PCX then
      applicationMediaPictureResult = runRetailPictureOnHost(baseDirectory,
        applicationMediaStepHolder.name, frameLimit, productHost)
      applicationMediaPictures = applicationMediaPictures + 1
      if frameLimit == 0 and not applicationMediaPictureResult[4] and
          applicationMediaIndex + 1 < len(applicationMediaSequenceHolder.steps) then
        return [applicationMediaCompleted, applicationMediaCinematics,
          applicationMediaPictures, applicationMediaMaps, "aborted",
          applicationMediaDemos]
      end if
    else if applicationMediaStepHolder.kind == appmediaseq.MEDIA_MAP then
      runPlayAtOnHost(baseDirectory, applicationMediaStepHolder.name,
        applicationMediaStepHolder.spawnPoint, frameLimit, productHost, skill)
      applicationMediaMaps = applicationMediaMaps + 1
    else if applicationMediaStepHolder.kind == appmediaseq.MEDIA_DM2 then
      applicationMediaDemoResult = runRetailDemoOnHost(baseDirectory,
        applicationMediaStepHolder.name, frameLimit, productHost)
      applicationMediaDemos = applicationMediaDemos + 1
      if frameLimit == 0 and applicationMediaDemoResult[2] != "completed" then
        return [applicationMediaCompleted, applicationMediaCinematics,
          applicationMediaPictures, applicationMediaMaps, "aborted",
          applicationMediaDemos]
      end if
    else
      return error(9930, "unknown product media kind")
    end if
    if applicationMediaIndex + 1 < len(applicationMediaSequenceHolder.steps) then
      applicationMediaNextStepHolder = applicationMediaSequenceHolder.steps[
        applicationMediaIndex + 1]
      applicationMediaCurrentIs3d = applicationMediaStepHolder.kind == appmediaseq.MEDIA_MAP or
        applicationMediaStepHolder.kind == appmediaseq.MEDIA_DM2
      applicationMediaNextIs3d = applicationMediaNextStepHolder.kind == appmediaseq.MEDIA_MAP or
        applicationMediaNextStepHolder.kind == appmediaseq.MEDIA_DM2
      if applicationMediaCurrentIs3d and applicationMediaNextIs3d then
        appproducthost.resetProductRenderer(productHost,
          applicationRendererImports())
      end if
    end if
    applicationMediaCompleted = applicationMediaCompleted + 1
    applicationMediaIndex = applicationMediaIndex + 1
  end while
  return [applicationMediaCompleted, applicationMediaCinematics,
    applicationMediaPictures, applicationMediaMaps, "completed",
    applicationMediaDemos]
end function

function runRetailMediaSequence(baseDirectory, specification, frameLimit)
  applicationMediaProductHost = appproducthost.openProductHost("MiniQuake2", 3, false,
    applicationRendererImports())
  applicationMediaProductResult = try(runRetailMediaSequenceOnHost(baseDirectory,
    specification, frameLimit, applicationMediaProductHost, 1))
  applicationMediaProductGeneration = applicationMediaProductHost.generation
  applicationMediaProductLoadingFrames = applicationMediaProductHost.loadingFrames
  appproducthost.closeProductHost(applicationMediaProductHost)
  if applicationMediaProductResult is error then return applicationMediaProductResult end if
  return applicationMediaProductResult + [applicationMediaProductGeneration,
    applicationMediaProductLoadingFrames]
end function

function assetSmoke(baseDirectory, mapName)
  if baseDirectory == "" then return error(9910, "asset smoke requires the Quake II install root containing baseq2") end if
  if mapName == "" then mapName = "base1" end if
  filesystem = appfs.initialize(baseDirectory, "")
  path = mapPath(mapName)
  map = appbsp.parse(appfs.readFile(filesystem, path), path)
  collision = appcollision.create(map)
  player = appmd2.parse(appfs.readFile(filesystem, "players/male/tris.md2"), "players/male/tris.md2")
  menuSound = appwav.parse(appfs.readFile(filesystem, "sound/misc/menu1.wav"), "sound/misc/menu1.wav")

  server = appbridge.createRuntime(1)
  server.collision = collision
  imports = appbridge.makeImports(server)
  game = appgame.GetGameApi(imports)
  server.game = game
  game.init()
  game.spawnEntities(mapName, map.entityText, "")
  game.runFrame()
  baseEdicts = appgame.baseEdicts()
  spawnResult = appgame.spawnResult()
  parsed = len(baseEdicts)
  game.shutdown()

  pakCount = 0
  for each searchPath in filesystem.searchPaths
    if searchPath.pack is not void then pakCount = pakCount + 1 end if
  end for
  return AssetSmokeResult(path, len(map.faces), len(map.leafs), parsed, spawnResult.skippedEntityCount, len(player.frames), menuSound.sampleCount, pakCount)
end function

function resultLines(result)
  return [
    "map=" + result.mapPath,
    "faces=" + result.mapFaces,
    "leafs=" + result.mapLeafs,
    "edicts=" + result.parsedEdicts,
    "skipped-edicts=" + result.skippedEdicts,
    "player-frames=" + result.playerFrames,
    "sound-samples=" + result.soundSamples,
    "pak-count=" + result.pakCount,
  ]
end function

// Canonical classic baseq2 single-player BSP set.  The read-only Python gate
// discovers every PAK map dynamically; this stable order is the product-level
// repeated-session stress matrix and deliberately excludes q2dm maps.
function campaignMapNames()
  return [
    "base1", "base2", "base3", "biggun", "boss1", "boss2", "bunk1",
    "city1", "city2", "city3", "command", "cool1", "fact1", "fact2",
    "fact3", "hangar1", "hangar2", "jail1", "jail2", "jail3", "jail4",
    "jail5", "lab", "mine1", "mine2", "mine3", "mine4", "mintro",
    "power1", "power2", "security", "space", "strike", "train", "ware1",
    "ware2", "waste1", "waste2", "waste3",
  ]
end function

function settleCampaignSession(session, maximumSteps)
  campaignReliableSettleStepCount = 0
  client = session.server.networkRuntime.server.clients[0]
  while campaignReliableSettleStepCount < maximumSteps
    pending = client.channel is void
    if not pending then
      pending = client.channel.reliableLength != 0 or
        client.channel.reliableQueuedBytes != 0 or
        len(client.channel.reliableQueue) != 0 or
        client.channel.message.curSize != 0
    end if
    if not pending then return campaignReliableSettleStepCount end if
    appplay.step(session)
    campaignReliableSettleStepCount = campaignReliableSettleStepCount + 1
    appsystem.sleep(1)
  end while
  return error(9915, "campaign session reliable channel did not settle")
end function

function campaignSignonError(session, mapName)
  serverClient = session.server.networkRuntime.server.clients[0]
  clientNetwork = session.client.integrated.network.client
  serverReliable = -1
  serverQueued = -1
  serverMessage = -1
  serverSequenceState = "<none>"
  clientReliable = -1
  clientQueued = -1
  clientMessage = -1
  clientSequenceState = "<none>"
  lastStuffed = "<none>"
  lastCommand = "<none>"
  if serverClient.channel is not void then
    serverReliable = serverClient.channel.reliableLength
    serverQueued = serverClient.channel.reliableQueuedBytes
    serverMessage = serverClient.channel.message.curSize
    serverSequenceState = "inSeq=" + serverClient.channel.incomingSequence +
      ",inAck=" + serverClient.channel.incomingAcknowledged +
      ",inRelAck=" + serverClient.channel.incomingReliableAcknowledged +
      ",inRelSeq=" + serverClient.channel.incomingReliableSequence +
      ",outSeq=" + serverClient.channel.outgoingSequence +
      ",relSeq=" + serverClient.channel.reliableSequence +
      ",lastRel=" + serverClient.channel.lastReliableSequence +
      ",firstRel=" + serverClient.channel.firstReliableSequence
  end if
  if clientNetwork.channel is not void then
    clientReliable = clientNetwork.channel.reliableLength
    clientQueued = clientNetwork.channel.reliableQueuedBytes
    clientMessage = clientNetwork.channel.message.curSize
    clientSequenceState = "inSeq=" + clientNetwork.channel.incomingSequence +
      ",inAck=" + clientNetwork.channel.incomingAcknowledged +
      ",inRelAck=" + clientNetwork.channel.incomingReliableAcknowledged +
      ",inRelSeq=" + clientNetwork.channel.incomingReliableSequence +
      ",outSeq=" + clientNetwork.channel.outgoingSequence +
      ",relSeq=" + clientNetwork.channel.reliableSequence +
      ",lastRel=" + clientNetwork.channel.lastReliableSequence +
      ",firstRel=" + clientNetwork.channel.firstReliableSequence
  end if
  stuffedTexts = session.client.integrated.network.stuffedTexts
  if len(stuffedTexts) > 0 then lastStuffed = stuffedTexts[len(stuffedTexts) - 1] end if
  commandLog = session.server.networkRuntime.commandLog
  if len(commandLog) > 0 then lastCommand = commandLog[len(commandLog) - 1][1] end if
  return error(9920, "campaign signon failed: map=" + mapName +
    " clientState=" + clientNetwork.state + " serverState=" + serverClient.state +
    " serverReliable=" + serverReliable + " serverQueued=" + serverQueued +
    " serverMessage=" + serverMessage + " clientReliable=" + clientReliable +
    " clientQueued=" + clientQueued + " clientMessage=" + clientMessage +
    " serverChannel={" + serverSequenceState + "}" +
    " clientChannel={" + clientSequenceState + "}" +
    " spawn=" + session.server.networkRuntime.spawnCount +
    " clientSpawn=" + session.client.integrated.network.spawnCount +
    " signonSpawn=" + session.client.signonSpawnCount +
    " commandIndex=" + session.client.commandIndex +
    " stuffed=" + len(stuffedTexts) + " lastStuffed=" + lastStuffed +
    " commandLog=" + len(commandLog) + " lastCommand=" + lastCommand +
    " deferred=" + len(session.server.networkRuntime.deferredReliable[0]) +
    " steps=" + session.steps + " serverFrame=" + session.server.frameNumber +
    " packets=" + (session.client.packetsReceived + session.server.packetsReceived) +
    " rejected=" + (session.client.packetsRejected + session.server.packetsRejected))
end function

// Reuse one real UDP client/server session across multiple user-owned retail
// maps.  This is intentionally headless: renderer registration is separately
// covered by --play, while this gate isolates level lifetime and re-signon.
function runCampaignSessionSmoke(baseDirectory, maximumMaps)
  maps = campaignMapNames()
  if baseDirectory == "" then return error(9916, "campaign session requires the Quake II install root") end if
  if maximumMaps < 1 or maximumMaps > len(maps) then return error(9917, "campaign map count outside matrix") end if
  session = appplay.createRetail(baseDirectory, maps[0],
    "\\name\\CampaignSmoke\\skin\\male/grunt\\rate\\25000")
  appplay.runUntilActive(session, 512)
  settleCampaignSession(session, 512)
  completed = 1
  changes = 0
  while completed < maximumMaps
    result = appplay.changeMapRetail(session, baseDirectory, maps[completed])
    if not result.changed or result.deferred then return error(9918, "campaign map change did not commit: " + maps[completed]) end if
    signon = try(appplay.runUntilActive(session, 512))
    // Preserve the original failure and stack.  Replacing it with channel
    // diagnostics hid gameplay/renderer lifetime failures as signon stalls.
    if signon is error then return signon end if
    settleCampaignSession(session, 512)
    if session.server.mapName != maps[completed] or not appplay.signonComplete(session) then
      return error(9919, "campaign map did not reach active: " + maps[completed])
    end if
    completed = completed + 1
    changes = changes + 1
  end while
  state = session.client.integrated.network.client.state
  spawnCount = session.server.networkRuntime.spawnCount
  steps = session.steps
  packets = session.client.packetsReceived + session.server.packetsReceived
  appplay.shutdown(session)
  return [completed, changes, state, spawnCount, steps, packets]
end function

function runPlayInputSmoke(baseDirectory, mapName, commandSteps)
  if typeof(baseDirectory) != "string" or baseDirectory == "" then
    return error(9921, "play input smoke requires the Quake II install root")
  end if
  if typeof(mapName) != "string" or mapName == "" then return error(9922, "play input smoke map is missing") end if
  appPhysicalInputSession = appplay.createRetailAtSkill(baseDirectory, mapName, "",
    "\\name\\InputSmoke\\skin\\male/grunt\\rate\\25000", 0)
  appplay.runUntilActive(appPhysicalInputSession, 512)
  appPhysicalInputReport = appcampaignplaytest.drive(appPhysicalInputSession, commandSteps)
  appplay.shutdown(appPhysicalInputSession)
  if appPhysicalInputReport.planarDisplacement <= 64.0 then return error(9923, "play input smoke did not move") end if
  if appPhysicalInputReport.fireCount < 1 then return error(9924, "play input smoke did not fire") end if
  if appPhysicalInputReport.snapshots < 1 then return error(9925, "play input smoke did not receive snapshots") end if
  if appPhysicalInputReport.rejectedPackets != 0 then return error(9926, "play input smoke rejected packets") end if
  return appPhysicalInputReport
end function

function previewMap(baseDirectory, mapName, frameLimit)
  global previewFileSystem
  if frameLimit < 1 or frameLimit > 36000 then return error(9911, "preview frame limit outside [1,36000]") end if
  filesystem = appfs.initialize(baseDirectory, "")
  previewFileSystem = filesystem
  path = mapPath(mapName)
  map = appbsp.parse(appfs.readFile(filesystem, path), path)
  spawned = appspawn.SpawnEntities(mapName, map.entityText, "")
  viewOrigin = appqtypes.zeroVec3()
  viewAngles = appqtypes.zeroVec3()
  for each baseEdict in spawned.edicts
    if baseEdict.component.className == "info_player_start" then
      origin = baseEdict.component.origin
      angles = baseEdict.component.angles
      viewOrigin = appqtypes.Vec3(origin[0], origin[1], origin[2] + 22.0)
      viewAngles = appqtypes.Vec3(angles[0], angles[1], angles[2])
      break
    end if
  end for
  window = appwindow.create("MiniQuake2 BSP38 Preview - " + mapName, 1280, 720, false)
  renderer = appgl.createOpenGlRenderer(true)
  renderer.exports.Init(void, void)
  renderer.exports.BeginRegistration(path)
  world = appgl.prepareClassicWorld(renderer, map, loadPreviewFile, apprtypes.defaultLightStyles(), 0, 1.0)
  renderer.exports.EndRegistration()
  camera = appcamera.create(viewOrigin, viewAngles)
  input = appuikeys.createInputState()
  input.viewAngles = [viewAngles.x, viewAngles.y, viewAngles.z]
  appuikeys.bind(input, 119, "+forward")
  appuikeys.bind(input, 115, "+back")
  appuikeys.bind(input, 97, "+moveleft")
  appuikeys.bind(input, 100, "+moveright")
  appuikeys.bind(input, appuiconstants.K_SPACE, "+moveup")
  appuikeys.bind(input, 99, "+movedown")
  appuikeys.bind(input, appuiconstants.K_SHIFT, "+speed")
  screen = appuiscreen.create(appuiconsole.create(80), appuimenu.create())
  appwindow.setMouseCapture(true)
  clock = appsystem.createClock()
  lastTime = appsystem.milliseconds(clock)
  frames = 0
  zero = appqtypes.zeroVec3()
  while frames < frameLimit and appwindow.poll(window)
    started = appsystem.milliseconds(clock)
    frameMsec = started - lastTime
    lastTime = started
    if frameMsec < 1 then frameMsec = 1 end if
    if frameMsec > 200 then frameMsec = 200 end if
    appuicontroller.poll(input, screen, started)
    command = appuiinput.createUserCmd(input, frameMsec)
    appcamera.applyUserCmd(camera, command, input.viewAngles, frameMsec)
    frame = apprtypes.defaultRefDef(window.width, window.height)
    frame.viewOrigin = camera.origin
    frame.viewAngles = camera.angles
    frame.time = started / 1000.0
    renderer.exports.BeginFrame(0.0)
    renderer.exports.RenderFrame(frame)
    appgl.submitClassicWorld(renderer, world, frame)
    renderer.exports.EndFrame()
    frames = frames + 1
    elapsed = appsystem.milliseconds(clock) - started
    if elapsed < 8 then appsystem.sleep(appbyteio.truncInt(8 - elapsed)) end if
  end while
  appwindow.setMouseCapture(false)
  appgl.releaseClassicWorld(renderer, world)
  renderer.exports.Shutdown()
  appwindow.destroy(window)
  previewFileSystem = void
  return frames
end function

// Native product acceptance for the same host-restart path used by the live
// Video menu. The network/game session deliberately does not participate:
// the gate isolates destruction, mode recreation and complete BSP resource
// registration on the replacement Renderer API generation.
function runRetailVideoRestartSmoke(baseDirectory, mapName)
  global previewFileSystem
  if typeof(baseDirectory) != "string" or baseDirectory == "" then
    return error(9938, "video restart smoke requires the Quake II install root")
  end if
  applicationVideoSmokeFileSystem = appfs.initialize(baseDirectory, "")
  previewFileSystem = applicationVideoSmokeFileSystem
  applicationVideoSmokePath = mapPath(mapName)
  applicationVideoSmokeMap = appbsp.parse(appfs.readFile(
    applicationVideoSmokeFileSystem, applicationVideoSmokePath), applicationVideoSmokePath)
  applicationVideoSmokeHost = appproducthost.openProductHost(
    "MiniQuake2 Video Restart", 0, false, applicationRendererImports())
  appproducthost.showProductLoading(applicationVideoSmokeHost, "loading " + mapName)

  applicationVideoSmokeRenderer = applicationVideoSmokeHost.renderer
  applicationVideoSmokeRenderer.exports.BeginRegistration(applicationVideoSmokePath)
  appgl.adoptClassicMapModel(applicationVideoSmokeRenderer,
    applicationVideoSmokeMap, applicationVideoSmokePath)
  applicationVideoSmokeWorld = appgl.prepareClassicWorld(applicationVideoSmokeRenderer,
    applicationVideoSmokeMap, loadPreviewFile, apprtypes.defaultLightStyles(), 0, 1.0)
  applicationVideoSmokeRenderer.exports.EndRegistration()
  applicationVideoSmokeFrame = apprtypes.defaultRefDef(
    applicationVideoSmokeHost.window.width, applicationVideoSmokeHost.window.height)
  applicationVideoSmokeRenderer.exports.BeginFrame(0.0)
  applicationVideoSmokeRenderer.exports.RenderFrame(applicationVideoSmokeFrame)
  applicationVideoSmokeBefore = appgl.submitClassicWorld(applicationVideoSmokeRenderer,
    applicationVideoSmokeWorld, applicationVideoSmokeFrame)
  applicationVideoSmokeRenderer.exports.EndFrame()
  appgl.releaseClassicWorld(applicationVideoSmokeRenderer, applicationVideoSmokeWorld)

  appproducthost.restartProductHost(applicationVideoSmokeHost,
    "MiniQuake2 Video Restart", 3, true, applicationRendererImports())
  appproducthost.showProductLoading(applicationVideoSmokeHost, "loading " + mapName)
  applicationVideoSmokeRenderer = applicationVideoSmokeHost.renderer
  applicationVideoSmokeRenderer.exports.BeginRegistration(applicationVideoSmokePath)
  appgl.adoptClassicMapModel(applicationVideoSmokeRenderer,
    applicationVideoSmokeMap, applicationVideoSmokePath)
  applicationVideoSmokeWorld = appgl.prepareClassicWorld(applicationVideoSmokeRenderer,
    applicationVideoSmokeMap, loadPreviewFile, apprtypes.defaultLightStyles(), 0, 1.0)
  applicationVideoSmokeRenderer.exports.EndRegistration()
  applicationVideoSmokeFrame = apprtypes.defaultRefDef(
    applicationVideoSmokeHost.window.width, applicationVideoSmokeHost.window.height)
  applicationVideoSmokeRenderer.exports.BeginFrame(0.0)
  applicationVideoSmokeRenderer.exports.RenderFrame(applicationVideoSmokeFrame)
  applicationVideoSmokeAfter = appgl.submitClassicWorld(applicationVideoSmokeRenderer,
    applicationVideoSmokeWorld, applicationVideoSmokeFrame)
  applicationVideoSmokeRenderer.exports.EndFrame()

  applicationVideoSmokeGeneration = applicationVideoSmokeHost.generation
  applicationVideoSmokeWidth = applicationVideoSmokeHost.window.width
  applicationVideoSmokeHeight = applicationVideoSmokeHost.window.height
  applicationVideoSmokeLoadingFrames = applicationVideoSmokeHost.loadingFrames
  applicationVideoSmokeBeforeVisible = applicationVideoSmokeBefore.visibleSurfaces
  applicationVideoSmokeAfterVisible = applicationVideoSmokeAfter.visibleSurfaces
  applicationVideoSmokeFullScreen = applicationVideoSmokeHost.fullScreen
  appgl.releaseClassicWorld(applicationVideoSmokeRenderer, applicationVideoSmokeWorld)
  appproducthost.closeProductHost(applicationVideoSmokeHost)
  previewFileSystem = void
  if applicationVideoSmokeGeneration != 2 or applicationVideoSmokeWidth != 1280 or
      applicationVideoSmokeHeight != 720 or applicationVideoSmokeLoadingFrames != 2 or
      not applicationVideoSmokeFullScreen then
    return error(9939, "video restart host lifecycle mismatch")
  end if
  if applicationVideoSmokeBeforeVisible != applicationVideoSmokeAfterVisible then
    return error(9940, "video restart changed deterministic BSP visibility")
  end if
  return [applicationVideoSmokeGeneration, applicationVideoSmokeWidth,
    applicationVideoSmokeHeight, applicationVideoSmokeLoadingFrames,
    applicationVideoSmokeBeforeVisible, applicationVideoSmokeAfterVisible,
    applicationVideoSmokeFullScreen]
end function

function productAddressBook(menu)
  applicationProductAddresses = []
  applicationProductAddressIndex = 0
  while applicationProductAddressIndex < 8
    applicationProductAddressItem = appuimenu.itemById(menu, "addressbook",
      "address" + applicationProductAddressIndex)
    if applicationProductAddressItem is not void and
        applicationProductAddressItem.value != "" then
      applicationProductAddresses = applicationProductAddresses + [
        applicationProductAddressItem.value]
    end if
    applicationProductAddressIndex = applicationProductAddressIndex + 1
  end while
  return applicationProductAddresses
end function

function updateProductBrowserMenu(menu, browser)
  applicationProductBrowserCount = appstartup.browserEntryCount(browser)
  applicationProductBrowserIndex = 0
  while applicationProductBrowserIndex < 8
    applicationProductServerId = "server" + applicationProductBrowserIndex
    if applicationProductBrowserIndex < applicationProductBrowserCount then
      applicationProductServer = browser.entries[applicationProductBrowserIndex]
      applicationProductEndpoint = appstartup.endpointText(
        applicationProductServer.endpoint)
      appuimenu.setActionCommand(menu, "join", applicationProductServerId,
        applicationProductServer.description + " " +
        applicationProductServer.ping + "ms", "connect " +
        applicationProductEndpoint, true)
    else
      applicationProductEmptyLabel = ""
      if applicationProductBrowserIndex == 0 then
        applicationProductEmptyLabel = "no local servers found"
      end if
      appuimenu.setActionCommand(menu, "join", applicationProductServerId,
        applicationProductEmptyLabel, "", false)
    end if
    applicationProductBrowserIndex = applicationProductBrowserIndex + 1
  end while
  return applicationProductBrowserCount
end function

function runProductMenuOnHost(baseDirectory, productHost, frameLimit,
    initialProfile)
  global previewFileSystem
  previewFileSystem = appfs.initialize(baseDirectory, "")
  applicationProductWindow = productHost.window
  applicationProductRenderer = productHost.renderer
  applicationProductInput = appuikeys.createInputState()
  appuikeys.bindDefaultGame(applicationProductInput)
  applicationProductScreen = appuiscreen.create(appuiconsole.create(80),
    appuimenu.create())
  applicationProductCommands = appuicommands.create()
  applicationProductCommands.videoMode = productHost.videoMode
  applicationProductCommands.fullScreen = productHost.fullScreen
  applicationProductMixer = appaudiomixer.create(44100)
  appaudiomixer.setMasterVolume(applicationProductMixer, 0.7)
  applicationProductAudioResult = try(appaudiodevice.open(44100, 2, 16))
  applicationProductDevice = void
  if applicationProductAudioResult is not error then
    applicationProductDevice = applicationProductAudioResult
  end if
  applicationProductPreferencesPath = appnativefs.joinPath(
    appnativefs.joinPath(baseDirectory, appfs.BASE_DIRECTORY_NAME),
    "miniquake2_multiplayer.cfg")
  applicationProductPreferencesResult = try(appstartup.loadPreferences(
    applicationProductPreferencesPath))
  applicationProductPreferences = appstartup.defaultPreferences()
  if applicationProductPreferencesResult is not error then
    applicationProductPreferences = applicationProductPreferencesResult
  end if
  applicationProductProfile = initialProfile
  if applicationProductProfile is void then
    applicationProductProfile = applicationProductPreferences.profile
  end if
  applicationProductCommands.playerName = applicationProductProfile.name
  applicationProductCommands.playerModel = applicationProductProfile.model
  applicationProductCommands.playerSkin = applicationProductProfile.skin
  applicationProductInput.config.hand = applicationProductProfile.hand
  applicationProductCommands.allowDownload = applicationProductPreferences.downloads.allow
  applicationProductCommands.allowDownloadMaps = applicationProductPreferences.downloads.maps
  applicationProductCommands.allowDownloadModels = applicationProductPreferences.downloads.models
  applicationProductCommands.allowDownloadPlayers = applicationProductPreferences.downloads.players
  applicationProductCommands.allowDownloadSounds = applicationProductPreferences.downloads.sounds
  appuimenu.setItemText(applicationProductScreen.menu, "player", "name",
    applicationProductProfile.name)
  applicationProductModelIndex = 0
  if applicationProductProfile.model == "female" then applicationProductModelIndex = 1
  else if applicationProductProfile.model == "cyborg" then applicationProductModelIndex = 2 end if
  appuimenu.setItemValue(applicationProductScreen.menu, "player", "model",
    applicationProductModelIndex)
  appuimenu.synchronizePlayerSkins(applicationProductScreen.menu)
  applicationProductSkinItem = appuimenu.itemById(applicationProductScreen.menu,
    "player", "skin")
  applicationProductSkinIndex = 0
  while applicationProductSkinIndex < len(applicationProductSkinItem.choices) and
      applicationProductSkinItem.choices[applicationProductSkinIndex] !=
      applicationProductProfile.skin
    applicationProductSkinIndex = applicationProductSkinIndex + 1
  end while
  if applicationProductSkinIndex < len(applicationProductSkinItem.choices) then
    appuimenu.setItemValue(applicationProductScreen.menu, "player", "skin",
      applicationProductSkinIndex)
  end if
  appuimenu.setItemValue(applicationProductScreen.menu, "player", "hand",
    applicationProductProfile.hand)
  applicationProductAddressIndex = 0
  while applicationProductAddressIndex < 8
    appuimenu.setItemText(applicationProductScreen.menu, "addressbook",
      "address" + applicationProductAddressIndex,
      applicationProductPreferences.addresses[applicationProductAddressIndex])
    applicationProductAddressIndex = applicationProductAddressIndex + 1
  end while
  applicationProductDownloadAllow = 0
  if applicationProductCommands.allowDownload then applicationProductDownloadAllow = 1 end if
  appuimenu.setItemValue(applicationProductScreen.menu, "downloads", "allow",
    applicationProductDownloadAllow)
  applicationProductDownloadMaps = 0
  if applicationProductCommands.allowDownloadMaps then applicationProductDownloadMaps = 1 end if
  appuimenu.setItemValue(applicationProductScreen.menu, "downloads", "maps",
    applicationProductDownloadMaps)
  applicationProductDownloadModels = 0
  if applicationProductCommands.allowDownloadModels then applicationProductDownloadModels = 1 end if
  appuimenu.setItemValue(applicationProductScreen.menu, "downloads", "models",
    applicationProductDownloadModels)
  applicationProductDownloadPlayers = 0
  if applicationProductCommands.allowDownloadPlayers then applicationProductDownloadPlayers = 1 end if
  appuimenu.setItemValue(applicationProductScreen.menu, "downloads", "players",
    applicationProductDownloadPlayers)
  applicationProductDownloadSounds = 0
  if applicationProductCommands.allowDownloadSounds then applicationProductDownloadSounds = 1 end if
  appuimenu.setItemValue(applicationProductScreen.menu, "downloads", "sounds",
    applicationProductDownloadSounds)
  applicationProductConfigPath = playConfigPath(baseDirectory)
  applicationProductConfigLoad = try(appuiconfig.loadProductConfig(
    applicationProductConfigPath))
  if applicationProductConfigLoad is not error and
      applicationProductConfigLoad is not void then
    appuiconfig.applyProductConfig(applicationProductConfigLoad,
      applicationProductInput, applicationProductCommands,
      applicationProductMixer, applicationProductScreen)
    applicationProductProfile.hand = applicationProductInput.config.hand
    appuimenu.setItemValue(applicationProductScreen.menu, "player", "hand",
      applicationProductProfile.hand)
  end if
  appuicontroller.configureGamepad(
    applicationProductCommands.joystickEnabled)
  applicationProductJoystickValue = 0
  if applicationProductCommands.joystickEnabled then
    applicationProductJoystickValue = 1
  end if
  appuimenu.setItemValue(applicationProductScreen.menu, "options",
    "joystick", applicationProductJoystickValue)
  appproducthost.applyProductGamma(productHost,
    applicationProductCommands.brightness, appnative.winHasFocus() != 0)
  appuimenu.open(applicationProductScreen.menu, "main")
  appuikeys.setDestination(applicationProductInput, appuiconstants.KEY_MENU)
  appwindow.setMouseCapture(false)
  applicationProductBrowser = appstartup.createBrowser()
  applicationProductClock = appsystem.createClock()
  applicationProductFrames = 0
  applicationProductAction = ""
  applicationProductMap = ""
  applicationProductSkill = 1
  applicationProductEndpoint = ""
  applicationProductServerOptions = void
  appwindow.setTitle(applicationProductWindow, "MiniQuake2 - Main Menu - FPS --")
  applicationProductFpsStart = appsystem.milliseconds(applicationProductClock)
  applicationProductFpsFrames = 0
  while (frameLimit == 0 or applicationProductFrames < frameLimit) and
      applicationProductAction == "" and appwindow.poll(applicationProductWindow)
    applicationProductNow = appsystem.milliseconds(applicationProductClock)
    appuicontroller.poll(applicationProductInput, applicationProductScreen,
      applicationProductNow)
    appuicommands.drain(applicationProductCommands, applicationProductInput,
      applicationProductScreen, applicationProductMixer)
    appuicontroller.configureGamepad(
      applicationProductCommands.joystickEnabled)
    appproducthost.applyProductGamma(productHost,
      applicationProductCommands.brightness, appnative.winHasFocus() != 0)
    if appuicommands.takePlayerDirty(applicationProductCommands) then
      applicationProductProfile = appuicommands.playerProfile(
        applicationProductCommands, applicationProductInput)
    end if
    applicationProductNewGame = appuicommands.takeNewGameSkill(
      applicationProductCommands)
    if applicationProductNewGame >= 0 then
      applicationProductAction = "local"
      applicationProductMap = "base1"
      applicationProductSkill = applicationProductNewGame
    end if
    if appuicommands.takeStartServer(applicationProductCommands) then
      applicationProductAction = "server"
      applicationProductServerOptions = appuicommands.serverOptions(
        applicationProductCommands)
      applicationProductMap = applicationProductServerOptions.mapName
    end if
    applicationProductConnect = appuicommands.takeConnectAddress(
      applicationProductCommands)
    if applicationProductConnect != "" then
      applicationProductAction = "connect"
      applicationProductEndpoint = applicationProductConnect
    end if
    if applicationProductCommands.quitRequested then
      applicationProductAction = "quit"
    end if
    if appuicommands.takeRefreshServers(applicationProductCommands) then
      applicationProductBrowserStart = try(appstartup.startBrowser(
        applicationProductBrowser,
        productAddressBook(applicationProductScreen.menu),
        appbyteio.truncInt(applicationProductNow)))
    end if
    if applicationProductBrowser.active then
      applicationProductBrowserPumped = try(appstartup.pumpBrowser(
        applicationProductBrowser, appbyteio.truncInt(applicationProductNow)))
      updateProductBrowserMenu(applicationProductScreen.menu,
        applicationProductBrowser)
    end if
    if appuicommands.takeConfigDirty(applicationProductCommands) then
      applicationProductConfigSave = try(appuiconfig.saveProductConfig(
        applicationProductConfigPath, appuiconfig.captureProductConfig(
          applicationProductInput, applicationProductCommands,
          applicationProductMixer, applicationProductScreen)))
    end if
    applicationProductRenderer.exports.BeginFrame(0.0)
    appuimenu.draw(applicationProductScreen.menu, applicationProductWindow.width,
      applicationProductWindow.height, applicationProductNow,
      applicationProductRenderer.exports)
    applicationProductRenderer.exports.EndFrame()
    pumpPlayAudio(applicationProductDevice, applicationProductMixer)
    applicationProductFrames = applicationProductFrames + 1
    applicationProductFpsFrames = applicationProductFpsFrames + 1
    applicationProductFpsElapsed = applicationProductNow - applicationProductFpsStart
    if applicationProductFpsElapsed >= 1000 then
      applicationProductMeasuredFps = appbyteio.truncInt(
        applicationProductFpsFrames * 1000 / applicationProductFpsElapsed)
      appwindow.setTitle(applicationProductWindow,
        "MiniQuake2 - Main Menu - FPS " + applicationProductMeasuredFps)
      applicationProductFpsStart = applicationProductNow
      applicationProductFpsFrames = 0
    end if
    appsystem.sleep(0)
  end while
  appstartup.closeBrowser(applicationProductBrowser)
  applicationProductSavedPreferences = try(appstartup.savePreferences(
    applicationProductPreferencesPath, appstartup.MultiplayerPreferences(
      applicationProductProfile,
      appuicommands.downloadPolicy(applicationProductCommands),
      productAddressBook(applicationProductScreen.menu))))
  closePlayAudio(applicationProductDevice, applicationProductMixer)
  if applicationProductAction == "" then applicationProductAction = "quit" end if
  return ProductMenuSelection(applicationProductAction, applicationProductMap,
    applicationProductSkill, applicationProductEndpoint,
    applicationProductServerOptions, applicationProductProfile,
    appuicommands.downloadPolicy(applicationProductCommands),
    applicationProductFrames)
end function

function runPlayAtOnHostConfigured(baseDirectory, mapName, spawnPoint, frameLimit,
    productHost, skill, menuAtStart, serverOptions, playerProfile)
  global previewFileSystem, playAssetState, playAssetBindings, playClientRuntime, playEffectState
  if frameLimit < 0 or frameLimit > 36000 then return error(9913, "play frame limit outside [0,36000]") end if
  filesystem = appfs.initialize(baseDirectory, "")
  previewFileSystem = filesystem
  appproducthost.showProductLoading(productHost, "loading " + mapName)
  applicationCurrentMapName = mapName
  path = mapPath(applicationCurrentMapName)
  window = productHost.window
  renderer = productHost.renderer
  // Drop any CIN/DM2/previous-map registration before expanding the next BSP.
  // Registration remains open until all world and client assets are ready.
  renderer.exports.BeginRegistration(path)
  applicationMapBytes = appfs.readFile(filesystem, path)
  map = appbsp.parse(applicationMapBytes, path)
  collision = appcollision.create(map)
  applicationInitialUserInfo = playProfileUserInfo(playerProfile)
  session = void
  if serverOptions is void then
    session = appplay.createCoreAtSkill(applicationCurrentMapName, map.entityText,
      collision, spawnPoint, applicationInitialUserInfo, skill)
  else
    applicationServerDeathmatch = not serverOptions.cooperative
    applicationConfiguredServer = appsession.createCoreModeAtSkill(
      applicationCurrentMapName, map.entityText, collision, spawnPoint,
      "0.0.0.0", appstartup.DEFAULT_PORT, serverOptions.maxClients, false,
      applicationServerDeathmatch, serverOptions.cooperative, skill)
    // The exported game API exposes the same owned context through the
    // module accessor; configure it after construction and before signon.
    applicationConfiguredContext = appgame.playerContext()
    applicationConfiguredContext.dmFlags = serverOptions.dmFlags
    applicationConfiguredContext.timeLimit = serverOptions.timeLimit
    applicationConfiguredContext.fragLimit = serverOptions.fragLimit
    applicationConfiguredServer.networkRuntime.server.hostname = serverOptions.hostname
    applicationConfiguredServer.networkRuntime.server.serverInfo = appinfo.setValueForKey(
      applicationConfiguredServer.networkRuntime.server.serverInfo,
      "hostname", serverOptions.hostname)
    session = appplay.wrap(applicationConfiguredServer, applicationInitialUserInfo)
  end if
  appsession.setMapChecksum(session.server, applicationMapBytes)
  appplay.runUntilActive(session, 256)

  appgl.adoptClassicMapModel(renderer, map, path)
  world = appgl.prepareClassicWorld(renderer, map, loadPreviewFile, apprtypes.defaultLightStyles(), 0, 1.0)
  assetState = appclientassets.createForRenderer(renderer.exports, loadPlaySound, noteMissingPlayAsset)
  playAssetState = assetState
  playClientRuntime = session.client.integrated.client
  playEffectState = session.client.integrated.effects
  appclientassets.registerConfigStrings(assetState,
    session.client.integrated.network.configStrings, applicationCurrentMapName)
  playAssetBindings = appclientassets.bindings(assetState)
  renderer.exports.EndRegistration()

  audioMixer = appaudiomixer.create(44100)
  appaudiomixer.setMasterVolume(audioMixer, 0.7)
  audioResult = try(appaudiodevice.open(44100, 2, 16))
  audioDevice = void
  if audioResult is not error then audioDevice = audioResult end if
  applicationMusicTrackValue = session.client.integrated.network.configStrings[
    appqconstants.CS_CDTRACK]
  applicationMusicStart = try(appaudiomixer.synchronizeMusicTrack(audioMixer,
    filesystem, applicationMusicTrackValue))
  applicationDemoRecording = appdemorecording.create(
    session.client.integrated, playDemoDirectory(baseDirectory))
  applicationScreenshotState = appscreenshot.create(
    playScreenshotDirectory(baseDirectory))
  applicationPendingSaveMetadataSlot = -1

  input = appuikeys.createInputState()
  playerState = session.client.integrated.client.current.playerState
  input.viewAngles = appprediction.localInputAngles(playerState)
  appuikeys.bindDefaultGame(input)
  screen = appuiscreen.create(appuiconsole.create(80), appuimenu.create())
  commandState = appuicommands.create()
  if playerProfile is not void then
    commandState.playerName = playerProfile.name
    commandState.playerModel = playerProfile.model
    commandState.playerSkin = playerProfile.skin
    input.config.hand = playerProfile.hand
  end if
  commandState.videoMode = productHost.videoMode
  commandState.fullScreen = productHost.fullScreen
  applicationConfigPath = playConfigPath(baseDirectory)
  applicationConfigLoad = try(appuiconfig.loadProductConfig(applicationConfigPath))
  if applicationConfigLoad is error then
    appuiconsole.appendLine(screen.console,
      "Config ignored: " + applicationConfigLoad.message, 0)
  else if applicationConfigLoad is not void then
    appuiconfig.applyProductConfig(applicationConfigLoad, input, commandState,
      audioMixer, screen)
    if commandState.videoMode != productHost.videoMode or
        commandState.fullScreen != productHost.fullScreen then
      commandState.videoRestartRequested = true
    end if
  end if
  appuicontroller.configureGamepad(commandState.joystickEnabled)
  appproducthost.applyProductGamma(productHost, commandState.brightness,
    appnative.winHasFocus() != 0)
  appgl.setHandedness(renderer, input.config.hand)
  applicationPublishedHand = 0
  appuimenu.setItemValue(screen.menu, "options", "sensitivity",
    input.config.sensitivity)
  applicationInvertMouseValue = 0
  if input.config.mousePitch < 0.0 then applicationInvertMouseValue = 1 end if
  appuimenu.setItemValue(screen.menu, "options", "invertmouse",
    applicationInvertMouseValue)
  applicationAlwaysRunValue = 0
  if input.config.alwaysRun then applicationAlwaysRunValue = 1 end if
  appuimenu.setItemValue(screen.menu, "options", "alwaysrun",
    applicationAlwaysRunValue)
  appuimenu.setItemValue(screen.menu, "options", "volume",
    audioMixer.masterVolume)
  appuimenu.setItemValue(screen.menu, "options", "crosshair", screen.crosshair)
  applicationJoystickValue = 0
  if commandState.joystickEnabled then applicationJoystickValue = 1 end if
  appuimenu.setItemValue(screen.menu, "options", "joystick",
    applicationJoystickValue)
  appuimenu.setItemValue(screen.menu, "video", "mode", commandState.videoMode)
  applicationFullscreenValue = 0
  if commandState.fullScreen then applicationFullscreenValue = 1 end if
  appuimenu.setItemValue(screen.menu, "video", "fullscreen",
    applicationFullscreenValue)
  appuimenu.setItemValue(screen.menu, "video", "brightness",
    commandState.brightness)
  appuimenu.setItemValue(screen.menu, "player", "hand", input.config.hand)
  appuimenu.setItemText(screen.menu, "player", "name", commandState.playerName)
  applicationPlayerModelIndex = 0
  if commandState.playerModel == "female" then applicationPlayerModelIndex = 1
  else if commandState.playerModel == "cyborg" then applicationPlayerModelIndex = 2 end if
  appuimenu.setItemValue(screen.menu, "player", "model", applicationPlayerModelIndex)
  appuimenu.synchronizePlayerSkins(screen.menu)
  applicationPlayerSkinItem = appuimenu.itemById(screen.menu, "player", "skin")
  applicationPlayerSkinIndex = 0
  while applicationPlayerSkinIndex < len(applicationPlayerSkinItem.choices) and
      applicationPlayerSkinItem.choices[applicationPlayerSkinIndex] != commandState.playerSkin
    applicationPlayerSkinIndex = applicationPlayerSkinIndex + 1
  end while
  if applicationPlayerSkinIndex < len(applicationPlayerSkinItem.choices) then
    appuimenu.setItemValue(screen.menu, "player", "skin", applicationPlayerSkinIndex)
  end if
  saveCheckpoints = array(3)
  applicationPersistentSlot = 0
  while applicationPersistentSlot < len(saveCheckpoints)
    applicationPersistentPaths = playSavePaths(baseDirectory, applicationPersistentSlot)
    applicationPersistentResult = try(apppersistence.loadSessionCheckpoint(
      applicationPersistentPaths[0], applicationPersistentPaths[1],
      session.server.gameExport.maxEdicts))
    if applicationPersistentResult is not error then
      saveCheckpoints[applicationPersistentSlot] = applicationPersistentResult
      applicationPersistentLabel = "slot " +
        (applicationPersistentSlot + 1) + " - " +
        applicationPersistentResult.mapName
      applicationPersistentMetadataPath = playSaveMetadataPath(baseDirectory,
        applicationPersistentSlot)
      if appnativefs.isFile(applicationPersistentMetadataPath) then
        applicationPersistentMetadata = try(appsavemetadata.decode(
          appnativefs.readAllText(applicationPersistentMetadataPath)))
        if applicationPersistentMetadata is not error then
          applicationPersistentLabel = applicationPersistentLabel + " " +
            applicationPersistentMetadata.timestamp
        end if
      end if
      appuimenu.setItemLabel(screen.menu, "load", "load" + applicationPersistentSlot,
        applicationPersistentLabel)
    end if
    applicationPersistentSlot = applicationPersistentSlot + 1
  end while
  // Interactive product runs enter through the Quake II main menu. Bounded
  // frame runs remain game-directed so automated retail gates need no input.
  if menuAtStart and frameLimit == 0 then
    appuimenu.open(screen.menu, "main")
    appuikeys.setDestination(input, appuiconstants.KEY_MENU)
  end if
  appwindow.setMouseCapture(input.destination == appuiconstants.KEY_GAME)
  clock = appsystem.createClock()
  networkTime = appsystem.milliseconds(clock)
  inputTime = networkTime
  frames = 0
  applicationFpsWindowStart = networkTime
  applicationFpsFrameCount = 0
  applicationPerfClient = 0
  applicationPerfWorld = 0
  applicationPerfEntities = 0
  applicationPerfHud = 0
  applicationPerfPresent = 0
  applicationPerfAudio = 0
  applicationPerfFrame = 0
  appwindow.setTitle(window, "MiniQuake2 - " + applicationCurrentMapName +
    " - FPS --")
  latest = void
  lastWorldStats = void
  applicationPendingMediaSpecification = ""
  applicationNextSkill = skill
  applicationDisconnectRequested = false
  while (frameLimit == 0 or frames < frameLimit) and not commandState.quitRequested and
      not applicationDisconnectRequested and
      applicationPendingMediaSpecification == "" and
      appwindow.poll(window)
    started = appsystem.milliseconds(clock)
    appclientstate.setPredictionRealTime(session.client.integrated.client,
      started)
    appuicontroller.poll(input, screen, started)
    applicationInputMsec = started - inputTime
    inputTime = started
    if applicationInputMsec < 1 then applicationInputMsec = 1 end if
    if applicationInputMsec > 200 then applicationInputMsec = 200 end if
    appuiinput.sampleView(input, appbyteio.truncInt(applicationInputMsec))
    appwindow.setMouseCapture(input.destination == appuiconstants.KEY_GAME)
    appuicommands.drain(commandState, input, screen, audioMixer)
    appuicontroller.configureGamepad(commandState.joystickEnabled)
    applicationWindowActive = appnative.winHasFocus() != 0
    appproducthost.applyProductGamma(productHost, commandState.brightness,
      applicationWindowActive)
    applicationSinglePlayerPaused = apppause.shouldPause(
      session.server.networkRuntime.server.maxClients, true,
      input.destination)
    appsession.setPaused(session.server, applicationSinglePlayerPaused)
    if applicationSinglePlayerPaused or not applicationWindowActive then
      appaudiomixer.pauseMusic(audioMixer)
    else
      appaudiomixer.resumeMusic(audioMixer)
    end if
    if appuicommands.takePlayerDirty(commandState) then
      applicationUpdatedProfile = appuicommands.playerProfile(commandState, input)
      applicationUpdatedUserInfo = try(appstartup.playerUserInfo(applicationUpdatedProfile))
      if applicationUpdatedUserInfo is error then
        appuiconsole.appendLine(screen.console,
          "Player setup rejected: " + applicationUpdatedUserInfo.message,
          appbyteio.truncInt(started))
      else
        applicationProfileSent = try(appplay.setUserInfo(session,
          applicationUpdatedUserInfo))
      end if
    end if
    if appuicommands.takeDisconnect(commandState) then
      applicationDisconnectRequested = true
      continue
    end if
    if input.config.hand != applicationPublishedHand then
      appgl.setHandedness(renderer, input.config.hand)
      appuimenu.setItemValue(screen.menu, "player", "hand", input.config.hand)
      if appplay.setUserInfo(session, playUserInfo(input.config.hand)) then
        applicationPublishedHand = input.config.hand
      end if
    end if
    applicationConfigChanged = appuicommands.takeConfigDirty(commandState) or
      input.capturedKey >= 0
    if applicationConfigChanged then
      applicationConfigSave = try(appuiconfig.saveProductConfig(applicationConfigPath,
        appuiconfig.captureProductConfig(input, commandState, audioMixer, screen)))
      if applicationConfigSave is error then
        appuiconsole.appendLine(screen.console,
          "Config save failed: " + applicationConfigSave.message,
          appbyteio.truncInt(started))
      end if
      input.capturedKey = -1
    end if
    applicationNewGameSkill = appuicommands.takeNewGameSkill(commandState)
    if applicationNewGameSkill >= 0 then
      applicationNextSkill = applicationNewGameSkill
      applicationPendingMediaSpecification = "*base1"
      screen.menu.active = false
      appuikeys.setDestination(input, appuiconstants.KEY_GAME)
    end if
    applicationForwardedCommands = appuicommands.takeForwarded(commandState)
    for each applicationForwardedCommand in applicationForwardedCommands
      applicationForwardedResult = try(appclientsession.sendStringCommand(session.client,
        applicationForwardedCommand, appbyteio.truncInt(started)))
    end for
    applicationRecordName = appuicommands.takeRecordName(commandState)
    if applicationRecordName != "" then
      applicationRecordResult = try(appdemorecording.start(
        applicationDemoRecording, applicationRecordName))
      if applicationRecordResult is error then
        appuiconsole.appendLine(screen.console,
          "Record failed: " + applicationRecordResult.message,
          appbyteio.truncInt(started))
      else
        appuiconsole.appendLine(screen.console,
          "Recording " + applicationRecordName,
          appbyteio.truncInt(started))
      end if
    end if
    if appuicommands.takeStopRecording(commandState) then
      applicationStopRecordResult = try(appdemorecording.stop(
        applicationDemoRecording))
      if applicationStopRecordResult is error then
        appuiconsole.appendLine(screen.console,
          "Stop failed: " + applicationStopRecordResult.message,
          appbyteio.truncInt(started))
      else
        appuiconsole.appendLine(screen.console,
          "Stopped demo: " + applicationStopRecordResult,
          appbyteio.truncInt(started))
      end if
    end if
    applicationScreenshotRequested = appuicommands.takeScreenshot(commandState)
    applicationSaveSlot = appuicommands.takeSaveSlot(commandState)
    if applicationSaveSlot >= 0 then
      applicationSavePaths = playSavePaths(baseDirectory, applicationSaveSlot)
      applicationSaveResult = try(apppersistence.savePlaySession(session,
        applicationSavePaths[0], applicationSavePaths[1]))
      if applicationSaveResult is error then
        appuiconsole.appendLine(screen.console, "Save failed: " + applicationSaveResult.message,
          appbyteio.truncInt(started))
      else
        saveCheckpoints[applicationSaveSlot] = applicationSaveResult
        appuimenu.setItemLabel(screen.menu, "load", "load" + applicationSaveSlot,
          "slot " + (applicationSaveSlot + 1) + " - " + applicationSaveResult.mapName)
        appuiconsole.appendLine(screen.console, "Saved slot " + (applicationSaveSlot + 1),
          appbyteio.truncInt(started))
        applicationPendingSaveMetadataSlot = applicationSaveSlot
      end if
    end if
    applicationLoadSlot = appuicommands.takeLoadSlot(commandState)
    if applicationLoadSlot >= 0 then
      applicationLoadCheckpoint = saveCheckpoints[applicationLoadSlot]
      if applicationLoadCheckpoint is void then
        appuiconsole.appendLine(screen.console, "No in-session save in slot " +
          (applicationLoadSlot + 1), appbyteio.truncInt(started))
      else
        if applicationLoadCheckpoint.mapName != applicationCurrentMapName then
          appproducthost.showProductLoading(productHost,
            "loading " + applicationLoadCheckpoint.mapName)
        end if
        applicationLoadResult = try(apppersistence.restorePlaySessionRetail(session,
          applicationLoadCheckpoint, baseDirectory, 512))
        if applicationLoadResult is error then
          appuiconsole.appendLine(screen.console, "Load failed: " + applicationLoadResult.message,
            appbyteio.truncInt(started))
        else
          if applicationLoadResult.reSignon then
            appgl.releaseClassicWorld(renderer, world)
            applicationCurrentMapName = applicationLoadCheckpoint.mapName
            path = mapPath(applicationCurrentMapName)
            applicationRestoredMapBytes = appfs.readFile(filesystem, path)
            map = appbsp.parse(applicationRestoredMapBytes, path)
            appsession.setMapChecksum(session.server,
              applicationRestoredMapBytes)
            renderer.exports.BeginRegistration(path)
            appgl.adoptClassicMapModel(renderer, map, path)
            world = appgl.prepareClassicWorld(renderer, map, loadPreviewFile,
              apprtypes.defaultLightStyles(), 0, 1.0)
            assetState = appclientassets.createForRenderer(renderer.exports,
              loadPlaySound, noteMissingPlayAsset)
            playAssetState = assetState
            appclientassets.registerConfigStrings(assetState,
              session.client.integrated.network.configStrings,
              applicationCurrentMapName)
            playAssetBindings = appclientassets.bindings(assetState)
            renderer.exports.EndRegistration()
            applicationRestoredPlayerState = session.client.integrated.client.current.playerState
            input.viewAngles = appprediction.localInputAngles(
              applicationRestoredPlayerState)
          end if
          appuiconsole.appendLine(screen.console, "Loaded slot " + (applicationLoadSlot + 1),
            appbyteio.truncInt(started))
          screen.menu.active = false
          appuikeys.setDestination(input, appuiconstants.KEY_GAME)
        end if
      end if
    end if
    if commandState.videoRestartRequested then
      commandState.videoRestartRequested = false
      appgl.releaseClassicWorld(renderer, world)
      world = void
      applicationVideoRestartResult = try(appproducthost.restartProductHost(productHost,
        "MiniQuake2 - " + applicationCurrentMapName, commandState.videoMode,
        commandState.fullScreen, applicationRendererImports()))
      if applicationVideoRestartResult is error then
        appuiconsole.appendLine(screen.console,
          "Video restart failed: " + applicationVideoRestartResult.message,
          appbyteio.truncInt(started))
        commandState.quitRequested = true
        continue
      end if
      window = productHost.window
      renderer = productHost.renderer
      appgl.setHandedness(renderer, input.config.hand)
      appproducthost.showProductLoading(productHost,
        "loading " + applicationCurrentMapName)
      renderer.exports.BeginRegistration(path)
      appgl.adoptClassicMapModel(renderer, map, path)
      world = appgl.prepareClassicWorld(renderer, map, loadPreviewFile,
        apprtypes.defaultLightStyles(), 0, 1.0)
      assetState = appclientassets.createForRenderer(renderer.exports,
        loadPlaySound, noteMissingPlayAsset)
      playAssetState = assetState
      appclientassets.registerConfigStrings(assetState,
        session.client.integrated.network.configStrings, applicationCurrentMapName)
      playAssetBindings = appclientassets.bindings(assetState)
      renderer.exports.EndRegistration()
      appwindow.setMouseCapture(input.destination == appuiconstants.KEY_GAME)
      appuiconsole.appendLine(screen.console,
        "Video restarted: " + window.width + "x" + window.height,
        appbyteio.truncInt(started))
    end if
    networkMsec = started - networkTime
    if networkMsec >= 100 then
      if networkMsec > 200 then networkMsec = 200 end if
      command = appuiinput.createSampledUserCmd(input,
        appbyteio.truncInt(networkMsec))
      appplay.predictLocal(session, command)
      appplay.setUserCmd(session, command)
      stepResult = appplay.step(session)
      latest = stepResult.handoff
      applyPlayHandoff(screen, latest)
      appclientassets.refreshConfigStrings(assetState,
        session.client.integrated.network.configStrings)
      if appmediaseq.takeQueuedLoadMenu(session.server.bridgeRuntime.commands) then
        appuimenu.open(screen.menu, "load")
        appuikeys.setDestination(input, appuiconstants.KEY_MENU)
      end if
      if applicationPendingMediaSpecification == "" then
        applicationPendingMediaSpecification = appmediaseq.takeQueuedGameMap(
          session.server.bridgeRuntime.commands)
      end if
      networkTime = started
    end if

    applicationNextMusicTrackValue = session.client.integrated.network.configStrings[
      appqconstants.CS_CDTRACK]
    if applicationNextMusicTrackValue != applicationMusicTrackValue then
      applicationMusicTrackValue = applicationNextMusicTrackValue
      applicationMusicSync = try(appaudiomixer.synchronizeMusicTrack(
        audioMixer, filesystem, applicationMusicTrackValue))
      if applicationMusicSync is error then
        appuiconsole.appendLine(screen.console,
          "Music unavailable: " + applicationMusicSync.message,
          appbyteio.truncInt(started))
      end if
    end if

    applicationPerfStart = appsystem.milliseconds(clock)
    fraction = (started - networkTime) / 100.0
    if fraction < 0.0 then fraction = 0.0 end if
    if fraction > 1.0 then fraction = 1.0 end if
    applicationPredictionMsec = started - networkTime
    if applicationPredictionMsec > 0 then
      if applicationPredictionMsec > 200 then applicationPredictionMsec = 200 end if
      applicationPreviewCommand = appuiinput.previewUserCmd(input,
        appbyteio.truncInt(applicationPredictionMsec))
      appplay.predictLocal(session, applicationPreviewCommand)
    end if
    frame = appclientstate.buildPredictedRefDef(
      session.client.integrated.client, fraction,
      window.width, window.height, playAssetBindings,
      session.client.integrated.network.playerNumber + 1,
      randomPlayClientEffect)
    if audioDevice is not void then
      viewAxes = appphysicsvector.angleVectors(frame.viewAngles)
      appclientassets.attachMixer(assetState, session.client.integrated.effects,
        audioMixer, resolvePlayEntityPosition, frame.viewOrigin, viewAxes[1])
      appclientassets.setMixerListenerEntity(
        session.client.integrated.network.playerNumber + 1)
      appclientassets.syncEntityLoops(audioMixer,
        session.client.integrated.client.current)
    end if
    // Effects are timestamped by the ClientSession clock while packets are
    // dispatched.  Keep advances on that same monotonic epoch; the render
    // clock above intentionally starts only after signon has completed.
    effectNow = appbyteio.truncInt(appsystem.milliseconds(session.client.clock))
    appentityeffects.emit(session.client.integrated.effects,
      session.client.integrated.client.current,
      session.client.integrated.client.previous, fraction, effectNow,
      session.client.integrated.network.playerNumber + 1, frame)
    appeffecthandoff.apply(session.client.integrated.effects, frame, effectNow, resolvePlayEffectModel)
    applicationPerfWorldStart = appsystem.milliseconds(clock)
    applicationPerfClient = applicationPerfClient +
      applicationPerfWorldStart - applicationPerfStart
    renderer.exports.BeginFrame(0.0)
    lastWorldStats = appgl.submitClassicWorld(renderer, world, frame)
    applicationPerfEntityStart = appsystem.milliseconds(clock)
    applicationPerfWorld = applicationPerfWorld +
      applicationPerfEntityStart - applicationPerfWorldStart
    renderer.exports.RenderFrame(frame)
    input.lightLevel = appgl.lightLevel(renderer)
    applicationPerfHudStart = appsystem.milliseconds(clock)
    applicationPerfEntities = applicationPerfEntities +
      applicationPerfHudStart - applicationPerfEntityStart
    appuiscreen.draw(screen, started, window.width, window.height,
      session.client.integrated.client.current.playerState.stats,
      session.client.integrated.network.configStrings,
      session.client.integrated.client.current.number,
      session.client.integrated.network.playerNumber, renderer.exports)
    if applicationPendingSaveMetadataSlot >= 0 then
      applicationSaveCapture = try(appscreenshot.capture(
        applicationScreenshotState, window.width, window.height))
      if applicationSaveCapture is error then
        appuiconsole.appendLine(screen.console,
          "Save preview failed: " + applicationSaveCapture.message,
          appbyteio.truncInt(started))
      else
        applicationSaveCaptureIndex = (applicationScreenshotState.nextIndex +
          9999) % 10000
        applicationSaveCaptureName = appscreenshot.fileName(
          applicationSaveCaptureIndex)
        applicationSaveTimestamp = appsavemetadata.currentTimestamp()
        applicationSaveMetadataResult = try(appsavemetadata.save(
          playSaveMetadataPath(baseDirectory,
            applicationPendingSaveMetadataSlot),
          appsavemetadata.SaveSlotMetadata(applicationCurrentMapName,
            session.server.frameNumber, applicationSaveTimestamp,
            applicationSaveCaptureName)))
        if applicationSaveMetadataResult is error then
          appuiconsole.appendLine(screen.console,
            "Save metadata failed: " + applicationSaveMetadataResult.message,
            appbyteio.truncInt(started))
        else
          appuimenu.setItemLabel(screen.menu, "load", "load" +
            applicationPendingSaveMetadataSlot, "slot " +
            (applicationPendingSaveMetadataSlot + 1) + " - " +
            applicationCurrentMapName + " " + applicationSaveTimestamp)
        end if
      end if
      applicationPendingSaveMetadataSlot = -1
    end if
    if applicationScreenshotRequested then
      applicationScreenshotResult = try(appscreenshot.capture(
        applicationScreenshotState, window.width, window.height))
      if applicationScreenshotResult is error then
        appuiconsole.appendLine(screen.console,
          "Screenshot failed: " + applicationScreenshotResult.message,
          appbyteio.truncInt(started))
      else
        appuiconsole.appendLine(screen.console,
          "Wrote " + applicationScreenshotResult,
          appbyteio.truncInt(started))
      end if
    end if
    applicationPerfHud = applicationPerfHud +
      appsystem.milliseconds(clock) - applicationPerfHudStart
    applicationPerfPresentStart = appsystem.milliseconds(clock)
    renderer.exports.EndFrame()
    applicationPerfAudioStart = appsystem.milliseconds(clock)
    applicationPerfPresent = applicationPerfPresent +
      applicationPerfAudioStart - applicationPerfPresentStart
    pumpPlayAudio(audioDevice, audioMixer)
    applicationPerfAudio = applicationPerfAudio +
      appsystem.milliseconds(clock) - applicationPerfAudioStart
    frames = frames + 1
    applicationFpsFrameCount = applicationFpsFrameCount + 1
    applicationFpsNow = appsystem.milliseconds(clock)
    applicationFpsElapsed = applicationFpsNow - applicationFpsWindowStart
    if applicationFpsElapsed >= 1000 then
      applicationMeasuredFps = appbyteio.truncInt(
        applicationFpsFrameCount * 1000 / applicationFpsElapsed)
      appwindow.setTitle(window, "MiniQuake2 - " + applicationCurrentMapName +
        " - FPS " + applicationMeasuredFps)
      applicationFpsWindowStart = applicationFpsNow
      applicationFpsFrameCount = 0
    end if
    elapsed = appsystem.milliseconds(clock) - started
    applicationPerfFrame = applicationPerfFrame + elapsed
    // Win32 Sleep(1..7) can round up to a full scheduler tick when no
    // high-resolution timer period is active. That turned an intended
    // 125-fps ceiling into roughly 50 fps on otherwise fast frames. Yield
    // without adding a coarse delay; the 10-Hz game/network cadence remains
    // governed by networkTime above.
    if elapsed < 8 then appsystem.sleep(0) end if
  end while

  appwindow.setMouseCapture(false)
  applicationDemoShutdown = try(appdemorecording.shutdown(
    applicationDemoRecording))
  closePlayAudio(audioDevice, audioMixer)
  appclientassets.releaseBindings()
  if world is not void then appgl.releaseClassicWorld(renderer, world) end if
  clientState = session.client.integrated.network.client.state
  serverFrame = session.server.frameNumber
  registeredModels = countAvailableAssets(assetState.modelEntries)
  registeredSounds = countAvailableAssets(assetState.soundEntries)
  missingAssets = len(appclientassets.missingAssets(assetState))
  missingAssetSummary = missingPlayAssetSummary(assetState)
  submittedEntities = renderer.state.submittedEntities
  visibleSurfaces = 0
  culledSurfaces = 0
  viewCluster = -1
  if lastWorldStats is not void then
    visibleSurfaces = lastWorldStats.visibleSurfaces
    culledSurfaces = lastWorldStats.culledSurfaces
    viewCluster = lastWorldStats.viewCluster
  end if
  appplay.shutdown(session)
  previewFileSystem = void
  playAssetState = void
  playAssetBindings = void
  playClientRuntime = void
  playEffectState = void
  if applicationPendingMediaSpecification != "" then
    runRetailMediaSequenceOnHost(baseDirectory, applicationPendingMediaSpecification,
      frameLimit, productHost, applicationNextSkill)
  end if
  return [frames, clientState, serverFrame, registeredModels,
    registeredSounds, missingAssets, submittedEntities,
    visibleSurfaces, culledSurfaces, viewCluster,
    applicationPerfClient, applicationPerfWorld, applicationPerfEntities,
    applicationPerfHud, missingAssetSummary, applicationPerfPresent,
    applicationPerfAudio, applicationPerfFrame, applicationDisconnectRequested,
    commandState.quitRequested]
end function

function runPlayAtOnHost(baseDirectory, mapName, spawnPoint, frameLimit,
    productHost, skill)
  return runPlayAtOnHostConfigured(baseDirectory, mapName, spawnPoint, frameLimit,
    productHost, skill, true, void, appstartup.defaultPlayerProfile())
end function

function runPlayAt(baseDirectory, mapName, spawnPoint, frameLimit)
  applicationPlayProductHost = appproducthost.openProductHost("MiniQuake2 - " + mapName,
    3, false, applicationRendererImports())
  applicationPlayProductResult = try(runPlayAtOnHost(baseDirectory, mapName,
    spawnPoint, frameLimit, applicationPlayProductHost, 1))
  // Preserve the primary render error while still unwinding the concrete GL
  // lifecycle. An error between BeginFrame and EndFrame otherwise makes
  // Shutdown replace the useful failure with "Shutdown called inside a frame".
  if applicationPlayProductResult is error and
      applicationPlayProductHost.renderer.state.core.state.frameOpen then
    applicationPlayEndFrameResult = try(
      applicationPlayProductHost.renderer.exports.EndFrame())
  end if
  applicationPlayCloseResult = try(
    appproducthost.closeProductHost(applicationPlayProductHost))
  if applicationPlayProductResult is error then return applicationPlayProductResult end if
  if applicationPlayCloseResult is error then return applicationPlayCloseResult end if
  return applicationPlayProductResult
end function

function runPlay(baseDirectory, mapName, frameLimit)
  return runPlayAt(baseDirectory, mapName, "", frameLimit)
end function

function remoteMapModelPath(session)
  applicationRemoteMapIndex = appqconstants.CS_MODELS + 1
  applicationRemoteConfigStrings = session.integrated.network.configStrings
  if applicationRemoteMapIndex < 0 or
      applicationRemoteMapIndex >= len(applicationRemoteConfigStrings) then
    return ""
  end if
  applicationRemoteMapName = applicationRemoteConfigStrings[
    applicationRemoteMapIndex]
  if typeof(applicationRemoteMapName) != "string" then return "" end if
  return applicationRemoteMapName
end function

function applicationRegisterRemoteWorld()
  global previewFileSystem, playAssetState, playAssetBindings
  global applicationRemoteRegistrationSession
  global applicationRemoteRegistrationFileSystem
  global applicationRemoteRegistrationRenderer
  global applicationRemoteRegistrationWorld
  global applicationRemoteRegistrationMap
  global applicationRemoteRegistrationCollision
  global applicationRemoteRegistrationMapPath
  global applicationRemoteRegistrationAssets
  if applicationRemoteRegistrationSession is void or
      applicationRemoteRegistrationFileSystem is void or
      applicationRemoteRegistrationRenderer is void then
    return error(9967, "remote precache registration context is unavailable")
  end if
  applicationRemoteRegisterPath = remoteMapModelPath(
    applicationRemoteRegistrationSession)
  if applicationRemoteRegisterPath == "" or not appfs.fileExists(
      applicationRemoteRegistrationFileSystem, applicationRemoteRegisterPath) then
    return error(9968, "remote precache BSP is not visible in the VFS")
  end if
  if applicationRemoteRegistrationMapPath == applicationRemoteRegisterPath and
      applicationRemoteRegistrationWorld is not void and
      applicationRemoteRegistrationAssets is not void then return true end if
  if applicationRemoteRegistrationWorld is not void then
    appgl.releaseClassicWorld(applicationRemoteRegistrationRenderer,
      applicationRemoteRegistrationWorld)
  end if
  applicationRemoteRegistrationRenderer.exports.BeginRegistration(
    applicationRemoteRegisterPath)
  applicationRemoteRegisterBytes = appfs.readFile(
    applicationRemoteRegistrationFileSystem, applicationRemoteRegisterPath)
  applicationRemoteRegistrationMap = appbsp.parse(applicationRemoteRegisterBytes,
    applicationRemoteRegisterPath)
  applicationRemoteRegistrationCollision = appcollision.create(
    applicationRemoteRegistrationMap)
  appgl.adoptClassicMapModel(applicationRemoteRegistrationRenderer,
    applicationRemoteRegistrationMap, applicationRemoteRegisterPath)
  applicationRemoteRegistrationWorld = appgl.prepareClassicWorld(
    applicationRemoteRegistrationRenderer, applicationRemoteRegistrationMap,
    loadPreviewFile, apprtypes.defaultLightStyles(), 0, 1.0)
  applicationRemoteRegistrationAssets = appclientassets.createForRenderer(
    applicationRemoteRegistrationRenderer.exports, loadPlaySound,
    noteMissingPlayAsset)
  playAssetState = applicationRemoteRegistrationAssets
  appclientassets.registerConfigStrings(applicationRemoteRegistrationAssets,
    applicationRemoteRegistrationSession.integrated.network.configStrings,
    applicationRemoteRegisterPath)
  playAssetBindings = appclientassets.bindings(
    applicationRemoteRegistrationAssets)
  applicationRemoteRegistrationRenderer.exports.EndRegistration()
  applicationRemoteRegistrationMapPath = applicationRemoteRegisterPath
  return true
end function

function runRemoteProductOnHost(baseDirectory, endpoint, productHost,
    playerProfile, downloadPolicy, frameLimit)
  if typeof(frameLimit) != "int" or frameLimit < 0 or frameLimit > 36000 then
    return error(9976, "remote product frame limit outside [0,36000]")
  end if
  global previewFileSystem, playAssetState, playAssetBindings, playClientRuntime, playEffectState
  global applicationRemoteRegistrationSession
  global applicationRemoteRegistrationFileSystem
  global applicationRemoteRegistrationRenderer
  global applicationRemoteRegistrationWorld
  global applicationRemoteRegistrationMap
  global applicationRemoteRegistrationCollision
  global applicationRemoteRegistrationMapPath
  global applicationRemoteRegistrationAssets
  applicationRemoteEndpoint = appstartup.parseEndpoint(endpoint)
  applicationRemoteFileSystem = appfs.initialize(baseDirectory, "")
  previewFileSystem = applicationRemoteFileSystem
  applicationRemoteUserInfo = appstartup.playerUserInfo(playerProfile)
  applicationRemoteSession = appclientsession.create(
    applicationRemoteEndpoint.address, applicationRemoteEndpoint.port,
    applicationRemoteUserInfo, 0)
  applicationRemoteDownloadPolicy = appdownloads.DownloadPolicy(
    downloadPolicy.allow, downloadPolicy.maps, downloadPolicy.models,
    downloadPolicy.sounds, downloadPolicy.allow, downloadPolicy.players)
  applicationRemoteDownloads = appdownloads.create(baseDirectory, "",
    applicationRemoteDownloadPolicy, applicationRemoteFileExists,
    loadPreviewFile, applicationRemoteRegisterDownload)
  appclientsession.configureDownloads(applicationRemoteSession,
    applicationRemoteDownloads)
  applicationRemoteWindow = productHost.window
  applicationRemoteRenderer = productHost.renderer
  applicationRemoteRegistrationSession = applicationRemoteSession
  applicationRemoteRegistrationFileSystem = applicationRemoteFileSystem
  applicationRemoteRegistrationRenderer = applicationRemoteRenderer
  applicationRemoteRegistrationWorld = void
  applicationRemoteRegistrationMap = void
  applicationRemoteRegistrationCollision = void
  applicationRemoteRegistrationMapPath = ""
  applicationRemoteRegistrationAssets = void
  applicationRemoteWorld = void
  applicationRemoteMap = void
  applicationRemoteCollision = void
  applicationRemoteMapPath = ""
  applicationRemoteAssets = void
  playClientRuntime = applicationRemoteSession.integrated.client
  playEffectState = applicationRemoteSession.integrated.effects
  applicationRemoteMixer = appaudiomixer.create(44100)
  appaudiomixer.setMasterVolume(applicationRemoteMixer, 0.7)
  applicationRemoteDeviceResult = try(appaudiodevice.open(44100, 2, 16))
  applicationRemoteDevice = void
  if applicationRemoteDeviceResult is not error then
    applicationRemoteDevice = applicationRemoteDeviceResult
  end if
  applicationRemoteMusicTrack = ""
  applicationRemoteDemoRecording = appdemorecording.create(
    applicationRemoteSession.integrated, playDemoDirectory(baseDirectory))
  applicationRemoteScreenshotState = appscreenshot.create(
    playScreenshotDirectory(baseDirectory))
  applicationRemoteInput = appuikeys.createInputState()
  appuikeys.bindDefaultGame(applicationRemoteInput)
  applicationRemoteInput.config.hand = playerProfile.hand
  applicationRemoteScreen = appuiscreen.create(appuiconsole.create(80),
    appuimenu.create())
  applicationRemoteCommands = appuicommands.create()
  applicationRemoteCommands.playerName = playerProfile.name
  applicationRemoteCommands.playerModel = playerProfile.model
  applicationRemoteCommands.playerSkin = playerProfile.skin
  applicationRemoteCommands.videoMode = productHost.videoMode
  applicationRemoteCommands.fullScreen = productHost.fullScreen
  applicationRemoteConfigPath = playConfigPath(baseDirectory)
  applicationRemoteConfigLoad = try(appuiconfig.loadProductConfig(
    applicationRemoteConfigPath))
  if applicationRemoteConfigLoad is not error and
      applicationRemoteConfigLoad is not void then
    appuiconfig.applyProductConfig(applicationRemoteConfigLoad,
      applicationRemoteInput, applicationRemoteCommands,
      applicationRemoteMixer, applicationRemoteScreen)
  end if
  appuicontroller.configureGamepad(
    applicationRemoteCommands.joystickEnabled)
  applicationRemoteJoystickValue = 0
  if applicationRemoteCommands.joystickEnabled then
    applicationRemoteJoystickValue = 1
  end if
  appuimenu.setItemValue(applicationRemoteScreen.menu, "options", "joystick",
    applicationRemoteJoystickValue)
  appproducthost.applyProductGamma(productHost,
    applicationRemoteCommands.brightness, appnative.winHasFocus() != 0)
  appuimenu.setItemValue(applicationRemoteScreen.menu, "player", "hand",
    playerProfile.hand)
  appuimenu.setItemText(applicationRemoteScreen.menu, "player", "name",
    playerProfile.name)
  applicationRemoteClock = appsystem.createClock()
  applicationRemoteNetworkTime = appsystem.milliseconds(applicationRemoteClock)
  applicationRemoteInputTime = applicationRemoteNetworkTime
  applicationRemoteFrames = 0
  applicationRemoteDisconnect = false
  applicationRemoteBoundedComplete = false
  applicationRemoteViewInitialized = false
  applicationRemoteLastWorldStats = void
  appwindow.setTitle(applicationRemoteWindow,
    "MiniQuake2 - connecting " + endpoint + " - FPS --")
  applicationRemoteFpsStart = applicationRemoteNetworkTime
  applicationRemoteFpsFrames = 0
  while (frameLimit == 0 or applicationRemoteFrames < frameLimit) and
      not applicationRemoteBoundedComplete and
      not applicationRemoteDisconnect and
      not applicationRemoteCommands.quitRequested and
      applicationRemoteSession.integrated.network.client.state !=
        miniquake2.network.constants.CA_DISCONNECTED and
      appwindow.poll(applicationRemoteWindow)
    applicationRemoteStarted = appsystem.milliseconds(applicationRemoteClock)
    appclientstate.setPredictionRealTime(
      applicationRemoteSession.integrated.client, applicationRemoteStarted)
    appuicontroller.poll(applicationRemoteInput, applicationRemoteScreen,
      applicationRemoteStarted)
    applicationRemoteInputMsec = applicationRemoteStarted -
      applicationRemoteInputTime
    applicationRemoteInputTime = applicationRemoteStarted
    if applicationRemoteInputMsec < 1 then applicationRemoteInputMsec = 1 end if
    if applicationRemoteInputMsec > 200 then applicationRemoteInputMsec = 200 end if
    appuiinput.sampleView(applicationRemoteInput,
      appbyteio.truncInt(applicationRemoteInputMsec))
    appwindow.setMouseCapture(applicationRemoteInput.destination ==
      appuiconstants.KEY_GAME)
    appuicommands.drain(applicationRemoteCommands, applicationRemoteInput,
      applicationRemoteScreen, applicationRemoteMixer)
    appuicontroller.configureGamepad(
      applicationRemoteCommands.joystickEnabled)
    applicationRemoteWindowActive = appnative.winHasFocus() != 0
    appproducthost.applyProductGamma(productHost,
      applicationRemoteCommands.brightness, applicationRemoteWindowActive)
    if applicationRemoteWindowActive then
      appaudiomixer.resumeMusic(applicationRemoteMixer)
    else
      appaudiomixer.pauseMusic(applicationRemoteMixer)
    end if
    if appuicommands.takeConfigDirty(applicationRemoteCommands) then
      applicationRemoteConfigSave = try(appuiconfig.saveProductConfig(
        applicationRemoteConfigPath, appuiconfig.captureProductConfig(
          applicationRemoteInput, applicationRemoteCommands,
          applicationRemoteMixer, applicationRemoteScreen)))
    end if
    if appuicommands.takePlayerDirty(applicationRemoteCommands) then
      applicationRemoteProfile = appuicommands.playerProfile(
        applicationRemoteCommands, applicationRemoteInput)
      applicationRemoteUserInfo = appstartup.playerUserInfo(
        applicationRemoteProfile)
      applicationRemoteNow = appbyteio.truncInt(appsystem.milliseconds(
        applicationRemoteSession.clock))
      applicationRemoteUserInfoSent = try(appclientsession.sendUserInfo(
        applicationRemoteSession, applicationRemoteUserInfo,
        applicationRemoteNow))
    end if
    if appuicommands.takeDisconnect(applicationRemoteCommands) then
      applicationRemoteDisconnect = true
      continue
    end if
    applicationRemoteForwarded = appuicommands.takeForwarded(
      applicationRemoteCommands)
    applicationRemoteCommandNow = appbyteio.truncInt(appsystem.milliseconds(
      applicationRemoteSession.clock))
    for each applicationRemoteForwardedCommand in applicationRemoteForwarded
      applicationRemoteForwardResult = try(appclientsession.sendStringCommand(
        applicationRemoteSession, applicationRemoteForwardedCommand,
        applicationRemoteCommandNow))
    end for
    applicationRemoteRecordName = appuicommands.takeRecordName(
      applicationRemoteCommands)
    if applicationRemoteRecordName != "" then
      applicationRemoteRecordResult = try(appdemorecording.start(
        applicationRemoteDemoRecording, applicationRemoteRecordName))
      if applicationRemoteRecordResult is error then
        appuiconsole.appendLine(applicationRemoteScreen.console,
          "Record failed: " + applicationRemoteRecordResult.message,
          appbyteio.truncInt(applicationRemoteStarted))
      end if
    end if
    if appuicommands.takeStopRecording(applicationRemoteCommands) then
      applicationRemoteStopResult = try(appdemorecording.stop(
        applicationRemoteDemoRecording))
      if applicationRemoteStopResult is error then
        appuiconsole.appendLine(applicationRemoteScreen.console,
          "Stop failed: " + applicationRemoteStopResult.message,
          appbyteio.truncInt(applicationRemoteStarted))
      else
        appuiconsole.appendLine(applicationRemoteScreen.console,
          "Stopped demo: " + applicationRemoteStopResult,
          appbyteio.truncInt(applicationRemoteStarted))
      end if
    end if
    applicationRemoteScreenshotRequested = appuicommands.takeScreenshot(
      applicationRemoteCommands)

    applicationRemoteNetworkMsec = applicationRemoteStarted -
      applicationRemoteNetworkTime
    if applicationRemoteNetworkMsec >= 100 then
      if applicationRemoteNetworkMsec > 200 then applicationRemoteNetworkMsec = 200 end if
      applicationRemoteCommand = appuiinput.createSampledUserCmd(
        applicationRemoteInput, appbyteio.truncInt(applicationRemoteNetworkMsec))
      appclientsession.setUserCmd(applicationRemoteSession,
        applicationRemoteCommand)
      applicationRemoteStep = try(appclientsession.step(
        applicationRemoteSession))
      applicationRemoteNetworkTime = applicationRemoteStarted
    else
      applicationRemotePoll = try(appclientsession.poll(
        applicationRemoteSession))
    end if
    applicationRemoteHandoff = appruntimehandoff.takeLatest(
      applicationRemoteSession.integrated)
    if applicationRemoteHandoff is not void then
      applyPlayHandoff(applicationRemoteScreen, applicationRemoteHandoff)
    end if
    applicationRemoteNextMusicTrack = applicationRemoteSession.integrated.network.configStrings[
      appqconstants.CS_CDTRACK]
    if applicationRemoteNextMusicTrack != applicationRemoteMusicTrack then
      applicationRemoteMusicTrack = applicationRemoteNextMusicTrack
      applicationRemoteMusicSync = try(
        appaudiomixer.synchronizeMusicTrack(applicationRemoteMixer,
          applicationRemoteFileSystem, applicationRemoteMusicTrack))
    end if

    applicationRemoteNextMapPath = remoteMapModelPath(applicationRemoteSession)
    if applicationRemoteRegistrationMapPath != "" and
        applicationRemoteRegistrationMapPath != applicationRemoteMapPath then
      applicationRemoteMapPath = applicationRemoteRegistrationMapPath
      applicationRemoteWorld = applicationRemoteRegistrationWorld
      applicationRemoteMap = applicationRemoteRegistrationMap
      applicationRemoteCollision = applicationRemoteRegistrationCollision
      applicationRemoteAssets = applicationRemoteRegistrationAssets
      applicationRemoteViewInitialized = false
      appwindow.setTitle(applicationRemoteWindow,
        "MiniQuake2 - " + applicationRemoteMapPath + " - FPS --")
    end if
    if applicationRemoteNextMapPath != "" and
        applicationRemoteNextMapPath != applicationRemoteMapPath and
        appfs.fileExists(applicationRemoteFileSystem,
          applicationRemoteNextMapPath) then
      if applicationRemoteWorld is not void then
        appgl.releaseClassicWorld(applicationRemoteRenderer,
          applicationRemoteWorld)
      end if
      applicationRemoteMapPath = applicationRemoteNextMapPath
      applicationRemoteRenderer.exports.BeginRegistration(
        applicationRemoteMapPath)
      applicationRemoteMap = appbsp.parse(appfs.readFile(
        applicationRemoteFileSystem, applicationRemoteMapPath),
        applicationRemoteMapPath)
      applicationRemoteCollision = appcollision.create(applicationRemoteMap)
      appgl.adoptClassicMapModel(applicationRemoteRenderer,
        applicationRemoteMap, applicationRemoteMapPath)
      applicationRemoteWorld = appgl.prepareClassicWorld(
        applicationRemoteRenderer, applicationRemoteMap, loadPreviewFile,
        apprtypes.defaultLightStyles(), 0, 1.0)
      applicationRemoteAssets = appclientassets.createForRenderer(
        applicationRemoteRenderer.exports, loadPlaySound,
        noteMissingPlayAsset)
      playAssetState = applicationRemoteAssets
      appclientassets.registerConfigStrings(applicationRemoteAssets,
        applicationRemoteSession.integrated.network.configStrings,
        applicationRemoteMapPath)
      playAssetBindings = appclientassets.bindings(applicationRemoteAssets)
      applicationRemoteRenderer.exports.EndRegistration()
      applicationRemoteRegistrationWorld = applicationRemoteWorld
      applicationRemoteRegistrationMap = applicationRemoteMap
      applicationRemoteRegistrationCollision = applicationRemoteCollision
      applicationRemoteRegistrationMapPath = applicationRemoteMapPath
      applicationRemoteRegistrationAssets = applicationRemoteAssets
      applicationRemoteViewInitialized = false
      appwindow.setTitle(applicationRemoteWindow,
        "MiniQuake2 - " + applicationRemoteMapPath + " - FPS --")
    end if

    applicationRemoteCurrent = applicationRemoteSession.integrated.client.current
    if applicationRemoteCurrent is not void and not applicationRemoteViewInitialized then
      applicationRemoteInput.viewAngles = appprediction.localInputAngles(
        applicationRemoteCurrent.playerState)
      applicationRemoteViewInitialized = true
    end if
    if applicationRemoteWorld is not void and applicationRemoteAssets is not void and
        applicationRemoteCurrent is not void then
      applicationRemotePredictionMsec = applicationRemoteStarted -
        applicationRemoteNetworkTime
      if applicationRemotePredictionMsec < 0 then applicationRemotePredictionMsec = 0 end if
      if applicationRemotePredictionMsec > 200 then applicationRemotePredictionMsec = 200 end if
      applicationRemotePreviewCommand = appuiinput.previewUserCmd(
        applicationRemoteInput,
        appbyteio.truncInt(applicationRemotePredictionMsec))
      applicationRemotePredict = try(appclientsession.predictRemote(
        applicationRemoteSession, applicationRemotePreviewCommand,
        applicationRemoteCollision))
      applicationRemoteFraction = applicationRemotePredictionMsec / 100.0
      if applicationRemoteFraction > 1.0 then applicationRemoteFraction = 1.0 end if
      applicationRemoteFrame = appclientstate.buildPredictedRefDef(
        applicationRemoteSession.integrated.client, applicationRemoteFraction,
        applicationRemoteWindow.width, applicationRemoteWindow.height,
        playAssetBindings,
        applicationRemoteSession.integrated.network.playerNumber + 1,
        randomPlayClientEffect)
      if applicationRemoteDevice is not void then
        applicationRemoteAxes = appphysicsvector.angleVectors(
          applicationRemoteFrame.viewAngles)
        appclientassets.attachMixer(applicationRemoteAssets,
          applicationRemoteSession.integrated.effects,
          applicationRemoteMixer, resolvePlayEntityPosition,
          applicationRemoteFrame.viewOrigin, applicationRemoteAxes[1])
        appclientassets.setMixerListenerEntity(
          applicationRemoteSession.integrated.network.playerNumber + 1)
        appclientassets.syncEntityLoops(applicationRemoteMixer,
          applicationRemoteCurrent)
      end if
      applicationRemoteEffectNow = appbyteio.truncInt(appsystem.milliseconds(
        applicationRemoteSession.clock))
      appentityeffects.emit(applicationRemoteSession.integrated.effects,
        applicationRemoteCurrent,
        applicationRemoteSession.integrated.client.previous,
        applicationRemoteFraction, applicationRemoteEffectNow,
        applicationRemoteSession.integrated.network.playerNumber + 1,
        applicationRemoteFrame)
      appeffecthandoff.apply(applicationRemoteSession.integrated.effects,
        applicationRemoteFrame, applicationRemoteEffectNow,
        resolvePlayEffectModel)
      applicationRemoteRenderer.exports.BeginFrame(0.0)
      applicationRemoteLastWorldStats = appgl.submitClassicWorld(
        applicationRemoteRenderer, applicationRemoteWorld,
        applicationRemoteFrame)
      applicationRemoteRenderer.exports.RenderFrame(applicationRemoteFrame)
      applicationRemoteInput.lightLevel = appgl.lightLevel(
        applicationRemoteRenderer)
      appuiscreen.draw(applicationRemoteScreen, applicationRemoteStarted,
        applicationRemoteWindow.width, applicationRemoteWindow.height,
        applicationRemoteCurrent.playerState.stats,
        applicationRemoteSession.integrated.network.configStrings,
        applicationRemoteCurrent.number,
        applicationRemoteSession.integrated.network.playerNumber,
        applicationRemoteRenderer.exports)
      if applicationRemoteScreenshotRequested then
        applicationRemoteScreenshotResult = try(appscreenshot.capture(
          applicationRemoteScreenshotState, applicationRemoteWindow.width,
          applicationRemoteWindow.height))
        if applicationRemoteScreenshotResult is error then
          appuiconsole.appendLine(applicationRemoteScreen.console,
            "Screenshot failed: " + applicationRemoteScreenshotResult.message,
            appbyteio.truncInt(applicationRemoteStarted))
        else
          appuiconsole.appendLine(applicationRemoteScreen.console,
            "Wrote " + applicationRemoteScreenshotResult,
            appbyteio.truncInt(applicationRemoteStarted))
        end if
      end if
      applicationRemoteRenderer.exports.EndFrame()
      pumpPlayAudio(applicationRemoteDevice, applicationRemoteMixer)
      if frameLimit > 0 then applicationRemoteBoundedComplete = true end if
    else
      applicationRemoteRenderer.exports.BeginFrame(0.0)
      applicationRemoteRenderer.exports.DrawFadeScreen()
      appproducthost.productHostDrawText(applicationRemoteRenderer.exports,
        applicationRemoteWindow.width / 2 - 80,
        applicationRemoteWindow.height / 2,
        "connecting " + endpoint)
      if applicationRemoteScreen.menu.active then
        appuimenu.draw(applicationRemoteScreen.menu,
          applicationRemoteWindow.width, applicationRemoteWindow.height,
          applicationRemoteStarted, applicationRemoteRenderer.exports)
      end if
      applicationRemoteRenderer.exports.EndFrame()
    end if
    applicationRemoteFrames = applicationRemoteFrames + 1
    applicationRemoteFpsFrames = applicationRemoteFpsFrames + 1
    applicationRemoteFpsElapsed = applicationRemoteStarted - applicationRemoteFpsStart
    if applicationRemoteFpsElapsed >= 1000 then
      applicationRemoteMeasuredFps = appbyteio.truncInt(
        applicationRemoteFpsFrames * 1000 / applicationRemoteFpsElapsed)
      applicationRemoteTitleMap = applicationRemoteMapPath
      if applicationRemoteTitleMap == "" then applicationRemoteTitleMap = endpoint end if
      appwindow.setTitle(applicationRemoteWindow, "MiniQuake2 - " +
        applicationRemoteTitleMap + " - FPS " + applicationRemoteMeasuredFps)
      applicationRemoteFpsStart = applicationRemoteStarted
      applicationRemoteFpsFrames = 0
    end if
    if applicationRemoteWorld is void then appsystem.sleep(1) end if
    appsystem.sleep(0)
  end while
  appwindow.setMouseCapture(false)
  applicationRemoteDemoShutdown = try(appdemorecording.shutdown(
    applicationRemoteDemoRecording))
  closePlayAudio(applicationRemoteDevice, applicationRemoteMixer)
  appclientassets.releaseBindings()
  if applicationRemoteWorld is not void then
    appgl.releaseClassicWorld(applicationRemoteRenderer,
      applicationRemoteWorld)
  end if
  appclientsession.shutdown(applicationRemoteSession)
  previewFileSystem = void
  playAssetState = void
  playAssetBindings = void
  playClientRuntime = void
  playEffectState = void
  applicationRemoteRegistrationSession = void
  applicationRemoteRegistrationFileSystem = void
  applicationRemoteRegistrationRenderer = void
  applicationRemoteRegistrationWorld = void
  applicationRemoteRegistrationMap = void
  applicationRemoteRegistrationCollision = void
  applicationRemoteRegistrationMapPath = ""
  applicationRemoteRegistrationAssets = void
  return [applicationRemoteFrames, applicationRemoteDisconnect,
    applicationRemoteCommands.quitRequested, applicationRemoteMapPath]
end function

function runRemoteProductSmoke(baseDirectory, endpoint, frameLimit)
  applicationRemoteSmokeHost = appproducthost.openProductHost(
    "MiniQuake2 Remote Smoke", 3, false, applicationRendererImports())
  applicationRemoteSmokeResult = try(runRemoteProductOnHost(baseDirectory,
    endpoint, applicationRemoteSmokeHost, appstartup.defaultPlayerProfile(),
    appstartup.defaultDownloadPolicy(), frameLimit))
  appproducthost.closeProductHost(applicationRemoteSmokeHost)
  if applicationRemoteSmokeResult is error then return applicationRemoteSmokeResult end if
  return applicationRemoteSmokeResult
end function

function runProduct(baseDirectory, frameLimit)
  if not appstartup.retailRootValid(baseDirectory) then
    return error(9965, "MiniQuake2 product requires a Quake II root containing baseq2/pak0.pak")
  end if
  if typeof(frameLimit) != "int" or frameLimit < 0 or frameLimit > 36000 then
    return error(9966, "product frame limit outside [0,36000]")
  end if
  applicationProductPersistRoot = try(appstartup.persistSelectedRoot(
    "miniquake2_data_root.txt", baseDirectory))
  applicationPersistentHost = appproducthost.openProductHost("MiniQuake2",
    3, false, applicationRendererImports())
  applicationPersistentProfile = void
  applicationPersistentRuns = 0
  applicationPersistentMenuFrames = 0
  applicationPersistentGameplayFrames = 0
  applicationPersistentDone = false
  while not applicationPersistentDone
    applicationPersistentSelection = runProductMenuOnHost(baseDirectory,
      applicationPersistentHost, frameLimit, applicationPersistentProfile)
    applicationPersistentMenuFrames = applicationPersistentMenuFrames +
      applicationPersistentSelection.frames
    applicationPersistentProfile = applicationPersistentSelection.playerProfile
    if applicationPersistentSelection.action == "quit" then
      applicationPersistentDone = true
      continue
    end if
    if applicationPersistentSelection.action == "connect" then
      // The protocol client owns a clean connect/disconnect lifecycle today;
      // retain the product host and return to the Join page after a bounded
      // interoperability attempt instead of constructing a local map first.
      applicationPersistentEndpoint = appstartup.parseEndpoint(
        applicationPersistentSelection.endpoint)
      appproducthost.showProductLoading(applicationPersistentHost,
        "connecting " + applicationPersistentSelection.endpoint)
      applicationPersistentConnect = try(runRemoteProductOnHost(
        baseDirectory, applicationPersistentSelection.endpoint,
        applicationPersistentHost, applicationPersistentProfile,
        applicationPersistentSelection.downloadPolicy, 0))
      if applicationPersistentConnect is error then
        appproducthost.closeProductHost(applicationPersistentHost)
        return applicationPersistentConnect
      end if
      applicationPersistentRuns = applicationPersistentRuns + 1
      applicationPersistentGameplayFrames = applicationPersistentGameplayFrames +
        applicationPersistentConnect[0]
      if applicationPersistentConnect[2] then applicationPersistentDone = true end if
      continue
    end if
    applicationPersistentServerOptions = void
    if applicationPersistentSelection.action == "server" then
      applicationPersistentServerOptions = applicationPersistentSelection.serverOptions
    end if
    applicationPersistentPlayResult = try(runPlayAtOnHostConfigured(
      baseDirectory, applicationPersistentSelection.mapName, "", 0,
      applicationPersistentHost, applicationPersistentSelection.skill,
      false, applicationPersistentServerOptions,
      applicationPersistentProfile))
    if applicationPersistentPlayResult is error then
      appproducthost.closeProductHost(applicationPersistentHost)
      return applicationPersistentPlayResult
    end if
    applicationPersistentRuns = applicationPersistentRuns + 1
    applicationPersistentGameplayFrames = applicationPersistentGameplayFrames +
      applicationPersistentPlayResult[0]
    if len(applicationPersistentPlayResult) < 19 or
        not applicationPersistentPlayResult[18] then
      applicationPersistentDone = true
    end if
  end while
  appproducthost.closeProductHost(applicationPersistentHost)
  previewFileSystem = void
  return [applicationPersistentRuns, applicationPersistentMenuFrames,
    applicationPersistentGameplayFrames]
end function

function runDedicated(baseDirectory, mapName, port, frameLimit)
  session = appsession.createRetail(baseDirectory, mapName, "0.0.0.0", port, 4, true)
  print "MiniQuake2 dedicated server listening: " + session.socket.address + ":" + session.socket.port
  print "  map=" + mapName + " protocol=34 maxclients=4"
  frames = appsession.run(session, frameLimit)
  appsession.shutdown(session)
  return [frames, session.packetsReceived, session.packetsSent, session.packetsRejected]
end function

function runHeadlessClient(address, port, frameLimit)
  session = appclientsession.create(address, port, "\\name\\MiniQuake2\\skin\\male/grunt\\rate\\25000", 0)
  print "MiniQuake2 Protocol-34 client connecting: " + address + ":" + port
  frames = appclientsession.run(session, frameLimit)
  state = session.integrated.network.client.state
  parsed = session.integrated.parsedPackets
  appclientsession.shutdown(session)
  return [frames, state, parsed, session.packetsReceived, session.packetsSent, session.packetsRejected]
end function

function runListen(baseDirectory, mapName, frameLimit)
  server = appsession.createRetail(baseDirectory, mapName, "127.0.0.1", 0, 1, false)
  client = appclientsession.create("127.0.0.1", server.socket.port,
    "\\name\\MiniQuake2\\skin\\male/grunt\\rate\\25000", 0)
  clock = appsystem.createClock()
  frames = 0
  while frames < frameLimit
    started = appsystem.milliseconds(clock)
    appclientsession.step(client)
    appsession.step(server)
    appclientsession.step(client)
    frames = frames + 1
    elapsed = appsystem.milliseconds(clock) - started
    if elapsed < 100 then appsystem.sleep(appbyteio.truncInt(100 - elapsed)) end if
  end while
  state = client.integrated.network.client.state
  snapshots = client.integrated.parsedPackets
  appclientsession.shutdown(client)
  appsession.shutdown(server)
  return [frames, state, snapshots]
end function
