/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Retail-data validation and one-frame dedicated runtime bootstrap. */
package miniquake2.runtime.application

import std.fs as appnativefs
import std.process as appprocess
import miniquake2.qcommon.filesystem as appfs
import miniquake2.qcommon.text as apptext
import miniquake2.format.bsp as appbsp
import miniquake2.format.md2 as appmd2
import miniquake2.format.cinematic as appcinformat
import miniquake2.audio.wav as appwav
import miniquake2.audio.device as appaudiodevice
import miniquake2.audio.mixer as appaudiomixer
import miniquake2.collision.model as appcollision
import miniquake2.game.null_game as appgame
import miniquake2.game.integration.baseq2 as appbaseq2
import miniquake2.game.constants as appgameconstants
import miniquake2.game.gameplay.constants as appgameplayconstants
import miniquake2.game.gameplay.item_rules as appgameplayitems
import miniquake2.game.gameplay.registry as appgameplayregistry
import miniquake2.game.player.transition as appplayertransition
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
import miniquake2.client.effects.constants as appeffectconstants
import miniquake2.client.cinematic.audio as appcinaudio
import miniquake2.client.cinematic.player as appcinplayer
import miniquake2.client.cinematic.picture as appcinpicture
import miniquake2.runtime.play_session as appplay
import miniquake2.runtime.campaign_playtest as appcampaignplaytest
import miniquake2.game.integration.campaign_progression as appcampaignprogression
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
import miniquake2.renderer.capture as appcapture
import miniquake2.runtime.pause_policy as apppause
import miniquake2.runtime.save_metadata as appsavemetadata
import miniquake2.native as appnative

extern function CreateDirectoryW(path as wstr, security as ptr) from "kernel32.dll" returns bool

// Store asset smoke result data.
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

// Store retail media audit data.
struct RetailMediaAudit
  attractSequence
  newGameSpecification
  idlog
  intro
  demo1
  demo2
  levelTrack
  musicPath
  musicRate
  musicChannels
  musicFrames
end struct

// Store product menu selection data.
struct ProductMenuSelection
  action
  mapName
  skill
  endpoint
  serverOptions
  playerProfile
  downloadPolicy
  frames
  productConfig
end struct

// Store the process-wide read-only retail filesystem and decoded sound cache.
// A product session visits many media and map states, but all of them address
// the same immutable PAK data. Keeping one index avoids re-reading every PAK
// and retains commonly shared WAV decodes across map and video transitions.
struct ApplicationResourceCache
  root
  filesystem
  soundNames
  sounds
  soundCount
end struct

const APPLICATION_SOUND_CACHE_CAPACITY = 512

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
applicationAutomatedProjectileAttack = false
applicationAutomatedWeaponWheel = false
applicationAutomatedChangeLevel = false
applicationAutomatedChangeLevelTriggered = false
applicationAutomatedChangeLevelReached = false
applicationAutomatedChangeLevelTarget = ""
applicationWeaponWheelCommands = 0
applicationWeaponWheelTransitions = 0
applicationWeaponWheelLastGunIndex = -1
applicationProjectileSnapshotMaximum = 0
applicationProjectileRenderMaximum = 0
applicationProjectileParticleMaximum = 0
applicationProjectileServerMaximum = 0
applicationProjectileAttackCommands = 0
applicationProjectileExportMaximum = 0
applicationProjectileVisibleMaximum = 0
applicationProjectileVisibilityDiagnostic = "unavailable"
applicationProjectileLastEngineNumber = -1
applicationLevelCapturePath = ""
applicationLevelCaptureChecksum = 0
applicationLevelCaptureError = void
applicationPersistProductConfig = true
applicationResourceCache = ApplicationResourceCache("", void,
  array(APPLICATION_SOUND_CACHE_CAPACITY, ""),
  array(APPLICATION_SOUND_CACHE_CAPACITY), 0)

// Return the shared read-only filesystem for one retail data root.
function applicationSharedFileSystem(baseDirectory)
  if typeof(baseDirectory) != "string" or baseDirectory == "" then
    return error(9912, "retail filesystem root is required")
  end if
  cache = applicationResourceCache
  if cache.filesystem is not void and
      apptext.equalInsensitive(cache.root, baseDirectory) then
    return cache.filesystem
  end if
  cache.root = baseDirectory
  cache.filesystem = appfs.initialize(baseDirectory, "")
  cache.soundNames = array(APPLICATION_SOUND_CACHE_CAPACITY, "")
  cache.sounds = array(APPLICATION_SOUND_CACHE_CAPACITY)
  cache.soundCount = 0
  return cache.filesystem
end function

// Reset decoded sounds when a direct tool path selects a different data root.
function applicationSynchronizeSoundCache(filesystem)
  cache = applicationResourceCache
  if not apptext.equalInsensitive(cache.root, filesystem.baseDirectory) then
    cache.root = filesystem.baseDirectory
    cache.filesystem = filesystem
    cache.soundNames = array(APPLICATION_SOUND_CACHE_CAPACITY, "")
    cache.sounds = array(APPLICATION_SOUND_CACHE_CAPACITY)
    cache.soundCount = 0
  end if
  return cache
end function

// Load preview file.
function loadPreviewFile(path)
  global previewFileSystem
  if previewFileSystem is void then return error(9912, "preview filesystem is not active") end if
  return appfs.readFile(previewFileSystem, path)
end function

// Report whether application renderer no result 0.
function applicationRendererNoResult0()
  return true
end function

// Report whether application renderer no result 1.
function applicationRendererNoResult1(value)
  return true
end function

// Report whether application renderer no result 2.
function applicationRendererNoResult2(first, second)
  return true
end function

// Report whether application renderer no result 3.
function applicationRendererNoResult3(first, second, third)
  return true
end function

// Return the application renderer zero 0 value.
function applicationRendererZero0()
  return 0
end function

// Report whether application renderer empty 1.
function applicationRendererEmpty1(value)
  return ""
end function

// Return the application renderer void 3 value.
function applicationRendererVoid3(first, second, third)
  return void
end function

// Return the application renderer mode value.
function applicationRendererMode(mode)
  return apprtypes.VideoModeInfo(false, 0, 0)
end function

// Return the application renderer imports value.
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

// Load play sound.
function loadPlaySound(name)
  // Normalize the virtual name, probe the root-scoped decode cache, then read,
  // validate and publish a bounded cached WAV only on a miss.
  global previewFileSystem
  if previewFileSystem is void then return void end if
  if typeof(name) != "string" or name == "" then return void end if
  applicationPlaySoundFileSystemHolder = previewFileSystem
  applicationPlaySoundPathHolder = name
  applicationPlaySoundLowerHolder = apptext.lower(applicationPlaySoundPathHolder)
  if not apptext.startsWith(applicationPlaySoundLowerHolder, "sound/") then
    applicationPlaySoundPathHolder = "sound/" + applicationPlaySoundPathHolder
  end if
  applicationPlaySoundKeyHolder = apptext.lower(applicationPlaySoundPathHolder)
  applicationPlaySoundCacheHolder = applicationSynchronizeSoundCache(
    applicationPlaySoundFileSystemHolder)
  applicationPlaySoundCacheIndexHolder = 0
  while applicationPlaySoundCacheIndexHolder <
      applicationPlaySoundCacheHolder.soundCount
    if applicationPlaySoundCacheHolder.soundNames[
        applicationPlaySoundCacheIndexHolder] == applicationPlaySoundKeyHolder then
      return applicationPlaySoundCacheHolder.sounds[
        applicationPlaySoundCacheIndexHolder]
    end if
    applicationPlaySoundCacheIndexHolder = applicationPlaySoundCacheIndexHolder + 1
  end while
  applicationPlaySoundDataHolder = try(appfs.readFile(applicationPlaySoundFileSystemHolder, applicationPlaySoundPathHolder))
  if applicationPlaySoundDataHolder is error then return void end if
  applicationPlaySoundResultHolder = try(appwav.parse(applicationPlaySoundDataHolder, applicationPlaySoundPathHolder))
  if applicationPlaySoundResultHolder is error then return void end if
  if applicationPlaySoundCacheHolder.soundCount <
      APPLICATION_SOUND_CACHE_CAPACITY then
    applicationPlaySoundCacheIndexHolder = applicationPlaySoundCacheHolder.soundCount
    applicationPlaySoundCacheHolder.soundNames[
      applicationPlaySoundCacheIndexHolder] = applicationPlaySoundKeyHolder
    applicationPlaySoundCacheHolder.sounds[
      applicationPlaySoundCacheIndexHolder] = applicationPlaySoundResultHolder
    applicationPlaySoundCacheHolder.soundCount = applicationPlaySoundCacheHolder.soundCount + 1
  end if
  return applicationPlaySoundResultHolder
end function

// Report whether note missing play asset.
function noteMissingPlayAsset(value)
  return true
end function

// Return the application remote file exists value.
function applicationRemoteFileExists(name)
  global previewFileSystem
  if previewFileSystem is void then return false end if
  return appfs.fileExists(previewFileSystem, name)
end function

// Register application remote download.
function applicationRemoteRegisterDownload(kind, name)
  // Never send `begin` until the fully downloaded precache generation has
  // successfully entered the renderer/collision registry.
  if kind == "precache" then return applicationRegisterRemoteWorld() end if
  return true
end function

// Play user info.
function playUserInfo(hand)
  if typeof(hand) != "int" or hand < 0 or hand > 2 then
    return error(9954, "play handedness must be 0, 1 or 2")
  end if
  return "\\name\\MiniQuake2\\skin\\male/grunt\\rate\\25000\\hand\\" + hand
end function

// Play profile user info.
function playProfileUserInfo(profile)
  if profile is void then return playUserInfo(0) end if
  return appstartup.playerUserInfo(profile)
end function

// Report whether missing play asset summary.
function missingPlayAssetSummary(state)
  output = ""
  for each missing in appclientassets.missingAssets(state)
    if output != "" then output = output + ";" end if
    output = output + missing.kind + ":" + missing.name + "(" + missing.reason + ")"
  end for
  return output
end function

// Resolve play model index.
function resolvePlayModelIndex(index)
  global playAssetState
  if playAssetState is void then return void end if
  return appassetregistry.resolveModelIndex(playAssetState, index)
end function

// Resolve play effect model.
function resolvePlayEffectModel(name)
  global playAssetState
  if playAssetState is void then return void end if
  return appassetregistry.resolveModelName(playAssetState, name)
end function

// Play random client effect.
function randomPlayClientEffect()
  global playEffectState
  if playEffectState is void then return 0 end if
  return appeffectstate.random(playEffectState)
end function

// Resolve play entity position.
function resolvePlayEntityPosition(number)
  global playClientRuntime
  if playClientRuntime is void or playClientRuntime.current is void then return void end if
  entity = appclientstate.currentEntity(playClientRuntime, number)
  if entity is void then return void end if
  return appqtypes.vec3(entity.origin[0], entity.origin[1], entity.origin[2])
end function

// Pump play audio.
function pumpPlayAudio(device, mixer)
  if device is void or mixer is void then return 0 end if
  submitted = 0
  // Reusable 1,024-frame blocks halve interpreted mixer dispatch overhead.
  // Eight queued blocks retain roughly 186 ms of audio at 44.1 kHz, enough to
  // absorb the measured full-graph GC tail that exhausted the former 70-116
  // ms horizons. audioQueued reaps completed headers before each refill, so a
  // finished ring slot is available even while the other seven remain queued.
  while appaudiodevice.queued(device) < 8 and submitted < 8
    samples = appaudiomixer.mixReusable(mixer, 1024)
    if appaudiodevice.submit(device, samples) == 0 then return submitted end if
    submitted = submitted + 1
  end while
  return submitted
end function

// Close play audio.
function closePlayAudio(device, mixer)
  if mixer is not void then
    appaudiomixer.stopMusic(mixer)
    appaudiomixer.stopAll(mixer)
    mixer.channels = []
  end if
  if device is not void then appaudiodevice.reset(device); appaudiodevice.close(device) end if
  return void
end function

// Report whether count available assets.
function countAvailableAssets(entries)
  count = 0
  for each entry in entries
    if entry is not void and entry.available then count = count + 1 end if
  end for
  return count
end function

// Apply play handoff.
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

// Play save paths.
function playSavePaths(baseDirectory, slot)
  if typeof(slot) != "int" or slot < 0 or slot > 2 then return error(9925, "play save slot outside [0,2]") end if
  applicationSaveDirectory = appnativefs.joinPath(baseDirectory, appfs.BASE_DIRECTORY_NAME)
  applicationSaveStem = "miniquake2_slot" + (slot + 1)
  return [appnativefs.joinPath(applicationSaveDirectory, applicationSaveStem + "_game.sav"),
    appnativefs.joinPath(applicationSaveDirectory, applicationSaveStem + "_level.sav")]
end function

// Report whether product path inside.
function productPathInside(baseDirectory, parentDirectory)
  if typeof(baseDirectory) != "string" or typeof(parentDirectory) != "string" or
      parentDirectory == "" then return false end if
  applicationProductBaseLower = apptext.lower(baseDirectory)
  applicationProductParentLower = apptext.lower(parentDirectory)
  return applicationProductBaseLower == applicationProductParentLower or
    apptext.startsWith(applicationProductBaseLower,
      applicationProductParentLower + "\\")
end function

// Keep portable installs self-contained, but never try to persist settings
// below a protected Program Files/Steam data root.  This mirrors modern
// Windows game behavior while leaving the retail assets read-only.
function productSettingsDirectoryFrom(baseDirectory, localAppData,
    programFiles, programFilesX86)
  if typeof(baseDirectory) != "string" or baseDirectory == "" then
    return error(9942, "product settings require the Quake II install root")
  end if
  applicationProductProtected = productPathInside(baseDirectory, programFiles) or
    productPathInside(baseDirectory, programFilesX86)
  if applicationProductProtected and typeof(localAppData) == "string" and
      localAppData != "" then
    return appnativefs.joinPath(localAppData, "MiniQuake2")
  end if
  return appnativefs.joinPath(baseDirectory, appfs.BASE_DIRECTORY_NAME)
end function

// Return the product settings directory value.
function productSettingsDirectory(baseDirectory)
  applicationLocalAppData = appprocess.environment("LOCALAPPDATA")
  applicationProgramFiles = appprocess.environment("ProgramFiles")
  applicationProgramFilesX86 = appprocess.environment("ProgramFiles(x86)")
  if typeof(applicationLocalAppData) != "string" then applicationLocalAppData = "" end if
  if typeof(applicationProgramFiles) != "string" then applicationProgramFiles = "" end if
  if typeof(applicationProgramFilesX86) != "string" then applicationProgramFilesX86 = "" end if
  applicationSettingsDirectory = productSettingsDirectoryFrom(baseDirectory,
    applicationLocalAppData, applicationProgramFiles, applicationProgramFilesX86)
  if not appnativefs.isDir(applicationSettingsDirectory) then
    if appnativefs.exists(applicationSettingsDirectory) then
      return error(9943, "product settings path is not a directory")
    end if
    if not CreateDirectoryW(applicationSettingsDirectory, 0) and
        not appnativefs.isDir(applicationSettingsDirectory) then
      return error(9944, "could not create product settings directory")
    end if
  end if
  return applicationSettingsDirectory
end function

// Play config path.
function playConfigPath(baseDirectory)
  applicationSettingsDirectory = productSettingsDirectory(baseDirectory)
  if applicationSettingsDirectory is error then return applicationSettingsDirectory end if
  return appnativefs.joinPath(applicationSettingsDirectory, "miniquake2.cfg")
end function

// Play preferences path.
function playPreferencesPath(baseDirectory)
  applicationSettingsDirectory = productSettingsDirectory(baseDirectory)
  if applicationSettingsDirectory is error then return applicationSettingsDirectory end if
  return appnativefs.joinPath(applicationSettingsDirectory,
    "miniquake2_multiplayer.cfg")
end function

// Play save metadata path.
function playSaveMetadataPath(baseDirectory, slot)
  applicationSaveMetadataPaths = playSavePaths(baseDirectory, slot)
  return applicationSaveMetadataPaths[0] + ".meta"
end function

// Play screenshot directory.
function playScreenshotDirectory(baseDirectory)
  return appnativefs.joinPath(appnativefs.joinPath(baseDirectory,
    appfs.BASE_DIRECTORY_NAME), "screenshots")
end function

// Play demo directory.
function playDemoDirectory(baseDirectory)
  return appnativefs.joinPath(appnativefs.joinPath(baseDirectory,
    appfs.BASE_DIRECTORY_NAME), "demos")
end function

// Return the ends with value.
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

// Map path.
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

// Return the cinematic path.
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

// Return the picture path.
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

// Return the demo path.
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
function runRetailCinematicOnHost(baseDirectory, name, frameLimit, looping,
    productHost, attractLoop)
  global previewFileSystem
  if typeof(baseDirectory) != "string" or baseDirectory == "" then return error(9922, "cinematic requires the Quake II install root") end if
  if typeof(frameLimit) != "int" or frameLimit < 0 or frameLimit > 36000 then return error(9923, "cinematic frame limit outside [0,36000]") end if
  if typeof(looping) != "bool" then return error(9924, "cinematic looping flag must be boolean") end if
  if typeof(attractLoop) != "bool" then return error(9924, "cinematic attract flag must be boolean") end if
  applicationCinematicFileSystemHolder = applicationSharedFileSystem(baseDirectory)
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
  // SCR_PlayCinematic assigns cl.cinematictime only after Huff1TableInit and
  // SCR_ReadNextFrame. Large ntro.cin tables must not count as dropped video.
  applicationCinematicStarted = appbyteio.truncInt(
    appsystem.milliseconds(applicationCinematicClockHolder))
  applicationCinematicPlaybackHolder.startTime = applicationCinematicStarted
  applicationCinematicFrames = 0
  applicationCinematicWasPaused = false
  applicationCinematicAttractInterrupted = false
  applicationCinematicSkipped = false
  applicationCinematicStats = array(32, 0)
  applicationCinematicConfigStrings = array(0)
  while (frameLimit == 0 or applicationCinematicFrames < frameLimit) and
      not appcinplayer.isFinished(applicationCinematicPlaybackHolder) and
      not applicationCinematicCommandStateHolder.quitRequested and
      appwindow.poll(applicationCinematicWindowHolder)
    applicationCinematicNow = appbyteio.truncInt(appsystem.milliseconds(applicationCinematicClockHolder))
    applicationCinematicInputEvents = appuicontroller.poll(applicationCinematicInputHolder,
      applicationCinematicScreenHolder, applicationCinematicNow)
    if attractLoop and appmediaseq.attractInterrupted(
        applicationCinematicInputHolder) then
      applicationCinematicAttractInterrupted = true
      break
    end if
    appuicommands.drain(applicationCinematicCommandStateHolder,
      applicationCinematicInputHolder, applicationCinematicScreenHolder,
      applicationCinematicMixerHolder)
    applicationCinematicIgnoredCommands = appuicommands.takeForwarded(
      applicationCinematicCommandStateHolder)
    applicationCinematicPaused = applicationCinematicScreenHolder.menu.active or
      not applicationCinematicInputHolder.focused
    if applicationCinematicPaused and not applicationCinematicWasPaused then
      appcinplayer.pause(applicationCinematicPlaybackHolder, applicationCinematicNow)
    else if not applicationCinematicPaused and applicationCinematicWasPaused then
      appcinplayer.resume(applicationCinematicPlaybackHolder, applicationCinematicNow)
    end if
    applicationCinematicWasPaused = applicationCinematicPaused
    if not attractLoop and not applicationCinematicPaused and
        applicationCinematicNow - applicationCinematicStarted > 1000 and
        appmediaseq.gameButtonDown(applicationCinematicInputHolder) then
      applicationCinematicSkipped = true
      break
    end if
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
  if applicationCinematicAttractInterrupted then
    applicationCinematicStatus = "interrupted"
  else if applicationCinematicSkipped then
    applicationCinematicStatus = "skipped"
  end if
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
    applicationCinematicDeviceOpened,
    applicationCinematicCommandStateHolder.quitRequested]
end function

// Run retail cinematic.
function runRetailCinematic(baseDirectory, name, frameLimit, looping)
  applicationCinematicProductHost = appproducthost.openProductHost(
    "MiniQuake2 Cinematic - " + name, 0, false, applicationRendererImports())
  applicationCinematicProductResult = try(runRetailCinematicOnHost(baseDirectory,
    name, frameLimit, looping, applicationCinematicProductHost, false))
  appproducthost.closeProductHost(applicationCinematicProductHost)
  if applicationCinematicProductResult is error then return applicationCinematicProductResult end if
  return applicationCinematicProductResult
end function

// Static intermission counterpart to runCinematic. Space/Enter emits the
// classic nextserver intent; Escape opens the same menu/quit lifecycle.
function runRetailPictureOnHost(baseDirectory, name, frameLimit, productHost)
  // Keep run retail picture on host phases explicit: validate inputs, update owned state, then publish the result.
  global previewFileSystem
  if typeof(baseDirectory) != "string" or baseDirectory == "" then return error(9927, "picture requires the Quake II install root") end if
  if typeof(frameLimit) != "int" or frameLimit < 0 or frameLimit > 36000 then return error(9928, "picture frame limit outside [0,36000]") end if
  applicationPictureFileSystemHolder = applicationSharedFileSystem(baseDirectory)
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
  applicationPictureStarted = appbyteio.truncInt(
    appsystem.milliseconds(applicationPictureClockHolder))
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
      if applicationPictureNow - applicationPictureStarted > 1000 and
          apptext.equalInsensitive(applicationPictureCommand, "nextserver") then
        applicationPictureAdvanced = true
      end if
    end for
    if applicationPictureNow - applicationPictureStarted > 1000 and
        appmediaseq.gameButtonDown(applicationPictureInputHolder) then
      applicationPictureAdvanced = true
    end if
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

// Run retail picture.
function runRetailPicture(baseDirectory, name, frameLimit)
  applicationPictureProductHost = appproducthost.openProductHost(
    "MiniQuake2 Picture - " + name, 0, false, applicationRendererImports())
  applicationPictureProductResult = try(runRetailPictureOnHost(baseDirectory,
    name, frameLimit, applicationPictureProductHost))
  appproducthost.closeProductHost(applicationPictureProductHost)
  if applicationPictureProductResult is error then return applicationPictureProductResult end if
  return applicationPictureProductResult
end function

// Submit application demo frame.
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
function runRetailDemoOnHost(baseDirectory, name, frameLimit, productHost,
    attractLoop)
  global previewFileSystem, playAssetState, playAssetBindings, playClientRuntime, playEffectState
  if typeof(baseDirectory) != "string" or baseDirectory == "" then
    return error(9949, "demo requires the Quake II install root")
  end if
  if typeof(frameLimit) != "int" or frameLimit < 0 or frameLimit > 36000 then
    return error(9950, "demo frame limit outside [0,36000]")
  end if
  if typeof(attractLoop) != "bool" then
    return error(9950, "demo attract flag must be boolean")
  end if
  applicationDemoFileSystemHolder = applicationSharedFileSystem(baseDirectory)
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
  applicationDemoAttractInterrupted = false
  applicationDemoMusicTrackValue = ""
  applicationDemoMusicOpened = false

  while (frameLimit == 0 or applicationDemoRenderedFrames < frameLimit) and
      not applicationDemoSessionHolder.finished and
      not applicationDemoCommandHolder.quitRequested and
      appwindow.poll(applicationDemoWindowHolder)
    applicationDemoStarted = appsystem.milliseconds(applicationDemoClockHolder)
    applicationDemoUiNow = appbyteio.truncInt(applicationDemoStarted)
    applicationDemoInputEvents = appuicontroller.poll(
      applicationDemoInputHolder, applicationDemoScreenHolder,
      applicationDemoUiNow)
    if attractLoop and appmediaseq.attractInterrupted(
        applicationDemoInputHolder) then
      applicationDemoAttractInterrupted = true
      break
    end if
    appuicommands.drain(applicationDemoCommandHolder, applicationDemoInputHolder,
      applicationDemoScreenHolder, applicationDemoMixerHolder)
    applicationDemoIgnoredCommands = appuicommands.takeForwarded(
      applicationDemoCommandHolder)
    applicationDemoPaused = applicationDemoScreenHolder.menu.active or
      not applicationDemoInputHolder.focused
    if applicationDemoPaused then
      appaudiomixer.pauseMusic(applicationDemoMixerHolder)
    else
      appaudiomixer.resumeMusic(applicationDemoMixerHolder)
    end if
    if not applicationDemoPaused then
      applicationDemoStepHolder = appdemosession.step(applicationDemoSessionHolder,
        applicationDemoSessionHolder.framesRead * 100)
      if applicationDemoStepHolder is void then break end if
      applyPlayHandoff(applicationDemoScreenHolder,
        applicationDemoStepHolder.handoff)

      applicationDemoNextMusicTrackValue = applicationDemoSessionHolder.runtime.network.configStrings[
        appqconstants.CS_CDTRACK]
      if applicationDemoNextMusicTrackValue != applicationDemoMusicTrackValue then
        applicationDemoMusicTrackValue = applicationDemoNextMusicTrackValue
        applicationDemoMusicSync = try(appaudiomixer.synchronizeMusicTrack(
          applicationDemoMixerHolder, applicationDemoFileSystemHolder,
          applicationDemoMusicTrackValue))
        if applicationDemoMusicSync is error then
          appuiconsole.appendLine(applicationDemoScreenHolder.console,
            "Music unavailable: " + applicationDemoMusicSync.message,
            applicationDemoUiNow)
        else if applicationDemoMixerHolder.music is not void then
          applicationDemoMusicOpened = true
        end if
      end if

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
        appeffecthandoff.applyPrepared(applicationDemoSessionHolder.runtime.effects,
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

  if applicationDemoSessionHolder.finished then applicationDemoStatus = "completed"
  else if applicationDemoAttractInterrupted then applicationDemoStatus = "interrupted" end if
  applicationDemoRegisteredModels = 0
  applicationDemoRegisteredSounds = 0
  applicationDemoMissingAssets = 0
  applicationDemoMissingAssetSummary = ""
  if applicationDemoAssetStateHolder is not void then
    applicationDemoRegisteredModels = countAvailableAssets(
      applicationDemoAssetStateHolder.modelEntries)
    applicationDemoRegisteredSounds = countAvailableAssets(
      applicationDemoAssetStateHolder.soundEntries)
    applicationDemoMissingAssets = len(appclientassets.missingAssets(
      applicationDemoAssetStateHolder))
    applicationDemoMissingAssetSummary = missingPlayAssetSummary(
      applicationDemoAssetStateHolder)
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
    applicationDemoSubmittedEntities, applicationDemoVisibleSurfaces,
    applicationDemoMusicTrackValue,
    applicationDemoMusicOpened,
    applicationDemoCommandHolder.quitRequested,
    applicationDemoMissingAssetSummary]
end function

// Run retail demo.
function runRetailDemo(baseDirectory, name, frameLimit)
  applicationDemoProductHost = appproducthost.openProductHost(
    "MiniQuake2 Demo - " + name, 3, false, applicationRendererImports())
  applicationDemoProductResult = try(runRetailDemoOnHost(baseDirectory,
    name, frameLimit, applicationDemoProductHost, false))
  appproducthost.closeProductHost(applicationDemoProductHost)
  if applicationDemoProductResult is error then return applicationDemoProductResult end if
  return applicationDemoProductResult
end function

// Qcommon_Init executes the stock d1 alias when no explicit +command was
// supplied. Keep the four-entry alias cycle data-driven so any input can hand
// control back to the persistent product menu without opening another host.
function runStockAttractLoopOnHost(baseDirectory, productHost)
  // Keep run stock attract loop on host phases explicit: validate inputs, update owned state, then publish the result.
  applicationAttractIndex = 0
  applicationAttractCompleted = 0
  while not productHost.window.closed
    applicationAttractStep = appmediaseq.stockAttractStep(
      applicationAttractIndex)
    applicationAttractStatus = "preview"
    applicationAttractQuit = false
    if applicationAttractStep.kind == appmediaseq.MEDIA_CIN then
      applicationAttractResult = runRetailCinematicOnHost(baseDirectory,
        applicationAttractStep.name, 0, false, productHost, true)
      applicationAttractStatus = applicationAttractResult[1]
      applicationAttractQuit = applicationAttractResult[7]
    else if applicationAttractStep.kind == appmediaseq.MEDIA_DM2 then
      applicationAttractResult = runRetailDemoOnHost(baseDirectory,
        applicationAttractStep.name, 0, productHost, true)
      applicationAttractStatus = applicationAttractResult[2]
      applicationAttractQuit = applicationAttractResult[11]
    else
      return error(9952, "stock attract step is not CIN or DM2")
    end if
    if applicationAttractQuit then
      return [applicationAttractCompleted, "quit", applicationAttractIndex]
    end if
    if applicationAttractStatus == "interrupted" then
      return [applicationAttractCompleted, "interrupted", applicationAttractIndex]
    end if
    if productHost.window.closed then
      return [applicationAttractCompleted, "closed", applicationAttractIndex]
    end if
    if applicationAttractStatus != "completed" then
      return [applicationAttractCompleted, applicationAttractStatus,
        applicationAttractIndex]
    end if
    applicationAttractCompleted = applicationAttractCompleted + 1
    applicationAttractIndex = appmediaseq.nextStockAttractIndex(
      applicationAttractIndex)
  end while
  return [applicationAttractCompleted, "closed", applicationAttractIndex]
end function

// Execute the exact classic `map first+nextserver` media chain. A positive
// frame limit is a deterministic preview gate per step; zero retains normal
// interactive behavior (CIN to completion, PCX until Space/Enter, map until
// window close). DM2 uses the isolated release-demo Protocol-26 compatibility
// path and renders through the same Protocol-34 client state and product host.
function runRetailMediaSequenceOnHostWithState(baseDirectory, specification,
    frameLimit, productHost, skill, initialConfig, playerProfile,
    initialGameplayHandover)
  global previewFileSystem
  if typeof(frameLimit) != "int" or frameLimit < 0 or frameLimit > 36000 then
    return error(9929, "media sequence frame limit outside [0,36000]")
  end if
  // A preceding map deliberately clears its gameplay filesystem before it
  // returns. The shared loading screen still needs conchars before the next
  // media step establishes its own filesystem/registration phase.
  previewFileSystem = applicationSharedFileSystem(baseDirectory)
  applicationMediaCinematics = 0
  applicationMediaPictures = 0
  applicationMediaMaps = 0
  applicationMediaDemos = 0
  applicationMediaCompleted = 0
  applicationMediaMapFrames = 0
  applicationMediaLastPlayResult = void
  applicationMediaProductConfig = initialConfig
  applicationMediaPlayerProfile = playerProfile
  applicationMediaGameplayHandover = initialGameplayHandover
  if applicationMediaPlayerProfile is void then
    applicationMediaPlayerProfile = appstartup.defaultPlayerProfile()
  end if
  applicationMediaPendingSpecification = specification
  applicationMediaTransitionCount = 0
  while applicationMediaPendingSpecification != ""
    if applicationMediaTransitionCount >= appmediaseq.MAX_MEDIA_TRANSITIONS then
      return error(9931, "campaign media transition limit exceeded")
    end if
    applicationMediaSequenceHolder = appmediaseq.parse(
      applicationMediaPendingSpecification)
    applicationMediaPendingSpecification = ""
    applicationMediaIndex = 0
    while applicationMediaIndex < len(applicationMediaSequenceHolder.steps)
      applicationMediaStepHolder = applicationMediaSequenceHolder.steps[applicationMediaIndex]
      if not appproducthost.showProductLoading(productHost,
          "loading " + applicationMediaStepHolder.name) then
        return [applicationMediaCompleted, applicationMediaCinematics,
          applicationMediaPictures, applicationMediaMaps, "aborted",
          applicationMediaDemos, applicationMediaLastPlayResult,
          applicationMediaMapFrames]
      end if
      if applicationMediaStepHolder.kind == appmediaseq.MEDIA_CIN then
        applicationMediaCinematicResult = runRetailCinematicOnHost(baseDirectory,
          applicationMediaStepHolder.name, frameLimit, false, productHost, false)
        applicationMediaCinematics = applicationMediaCinematics + 1
        if frameLimit == 0 and applicationMediaCinematicResult[1] != "completed" then
          return [applicationMediaCompleted, applicationMediaCinematics,
            applicationMediaPictures, applicationMediaMaps, "aborted",
            applicationMediaDemos, applicationMediaLastPlayResult,
            applicationMediaMapFrames]
        end if
      else if applicationMediaStepHolder.kind == appmediaseq.MEDIA_PCX then
        applicationMediaPictureResult = runRetailPictureOnHost(baseDirectory,
          applicationMediaStepHolder.name, frameLimit, productHost)
        applicationMediaPictures = applicationMediaPictures + 1
        if frameLimit == 0 and not applicationMediaPictureResult[4] and
            applicationMediaIndex + 1 < len(applicationMediaSequenceHolder.steps) then
          return [applicationMediaCompleted, applicationMediaCinematics,
            applicationMediaPictures, applicationMediaMaps, "aborted",
            applicationMediaDemos, applicationMediaLastPlayResult,
            applicationMediaMapFrames]
        end if
      else if applicationMediaStepHolder.kind == appmediaseq.MEDIA_MAP then
        // A map reached from nextserver/gamemap continues gameplay. Reopening
        // the main menu here would leave an interactive successor map paused
        // behind UI immediately after an otherwise successful level exit.
        applicationMediaLastPlayResult = runPlayAtOnHostConfiguredWithState(baseDirectory,
          applicationMediaStepHolder.name, applicationMediaStepHolder.spawnPoint,
          frameLimit, productHost, skill, false, void,
          applicationMediaPlayerProfile, applicationMediaProductConfig,
          applicationMediaGameplayHandover)
        applicationMediaMaps = applicationMediaMaps + 1
        applicationMediaMapFrames = applicationMediaMapFrames +
          applicationMediaLastPlayResult[0]
        if len(applicationMediaLastPlayResult) >= 49 then
          applicationMediaProductConfig = applicationMediaLastPlayResult[47]
          applicationMediaPlayerProfile = applicationMediaLastPlayResult[48]
        end if
        if len(applicationMediaLastPlayResult) >= 50 then
          applicationMediaGameplayHandover = applicationMediaLastPlayResult[49]
        end if
        if len(applicationMediaLastPlayResult) >= 46 and
            applicationMediaLastPlayResult[44] != "" then
          applicationMediaPendingSpecification = applicationMediaLastPlayResult[44]
          skill = applicationMediaLastPlayResult[45]
        else if applicationMediaLastPlayResult[19] or productHost.window.closed then
          return [applicationMediaCompleted + 1, applicationMediaCinematics,
            applicationMediaPictures, applicationMediaMaps, "aborted",
            applicationMediaDemos, applicationMediaLastPlayResult,
            applicationMediaMapFrames]
        end if
      else if applicationMediaStepHolder.kind == appmediaseq.MEDIA_DM2 then
        applicationMediaDemoResult = runRetailDemoOnHost(baseDirectory,
          applicationMediaStepHolder.name, frameLimit, productHost, false)
        applicationMediaDemos = applicationMediaDemos + 1
        if frameLimit == 0 and applicationMediaDemoResult[2] != "completed" then
          return [applicationMediaCompleted, applicationMediaCinematics,
            applicationMediaPictures, applicationMediaMaps, "aborted",
            applicationMediaDemos, applicationMediaLastPlayResult,
            applicationMediaMapFrames]
        end if
      else
        return error(9930, "unknown product media kind")
      end if
      applicationMediaCompleted = applicationMediaCompleted + 1
      if applicationMediaPendingSpecification != "" then
        // The map function has returned and released its BSP, collision,
        // gameplay, client and audio graphs. Follow the queued gamemap only
        // now; recursive loading retained every prior map on the native stack
        // and exhausted the process heap at the first base1 -> base2 exit.
        applicationMediaNextSequenceHolder = appmediaseq.parse(
          applicationMediaPendingSpecification)
        applicationMediaNextStepHolder = applicationMediaNextSequenceHolder.steps[0]
        applicationMediaNextIs3d = applicationMediaNextStepHolder.kind == appmediaseq.MEDIA_MAP or
          applicationMediaNextStepHolder.kind == appmediaseq.MEDIA_DM2
        if applicationMediaNextIs3d then
          previewFileSystem = applicationSharedFileSystem(baseDirectory)
          appproducthost.resetProductRenderer(productHost,
            applicationRendererImports())
        end if
        break
      end if
      if applicationMediaIndex + 1 < len(applicationMediaSequenceHolder.steps) then
        applicationMediaNextStepHolder = applicationMediaSequenceHolder.steps[
          applicationMediaIndex + 1]
        applicationMediaCurrentIs3d = applicationMediaStepHolder.kind == appmediaseq.MEDIA_MAP or
          applicationMediaStepHolder.kind == appmediaseq.MEDIA_DM2
        applicationMediaNextIs3d = applicationMediaNextStepHolder.kind == appmediaseq.MEDIA_MAP or
          applicationMediaNextStepHolder.kind == appmediaseq.MEDIA_DM2
        if applicationMediaCurrentIs3d and applicationMediaNextIs3d then
          previewFileSystem = applicationSharedFileSystem(baseDirectory)
          appproducthost.resetProductRenderer(productHost,
            applicationRendererImports())
        end if
      end if
      applicationMediaIndex = applicationMediaIndex + 1
    end while
    applicationMediaTransitionCount = applicationMediaTransitionCount + 1
  end while
  return [applicationMediaCompleted, applicationMediaCinematics,
    applicationMediaPictures, applicationMediaMaps, "completed",
    applicationMediaDemos, applicationMediaLastPlayResult,
    applicationMediaMapFrames, applicationMediaProductConfig,
    applicationMediaPlayerProfile, applicationMediaGameplayHandover]
end function

// Report whether run retail media sequence on host with settings.
function runRetailMediaSequenceOnHostWithSettings(baseDirectory, specification,
    frameLimit, productHost, skill, initialConfig, playerProfile)
  return runRetailMediaSequenceOnHostWithState(baseDirectory, specification,
    frameLimit, productHost, skill, initialConfig, playerProfile, void)
end function

// Report whether run retail media sequence on host.
function runRetailMediaSequenceOnHost(baseDirectory, specification, frameLimit,
    productHost, skill)
  return runRetailMediaSequenceOnHostWithSettings(baseDirectory, specification,
    frameLimit, productHost, skill, void, appstartup.defaultPlayerProfile())
end function

// Run retail media sequence.
function runRetailMediaSequence(baseDirectory, specification, frameLimit)
  applicationMediaProductHost = appproducthost.openProductHost("MiniQuake2", 3, false,
    applicationRendererImports())
  applicationMediaProductResult = try(runRetailMediaSequenceOnHost(baseDirectory,
    specification, frameLimit, applicationMediaProductHost, 1))
  applicationMediaProductGeneration = applicationMediaProductHost.generation
  applicationMediaProductLoadingFrames = applicationMediaProductHost.loadingFrames
  appproducthost.closeProductHost(applicationMediaProductHost)
  if applicationMediaProductResult is error then return applicationMediaProductResult end if
  // Preserve the historical public result indexes; the host-only tail carries
  // its last map result and aggregate map frames for persistent transitions.
  return [applicationMediaProductResult[0], applicationMediaProductResult[1],
    applicationMediaProductResult[2], applicationMediaProductResult[3],
    applicationMediaProductResult[4], applicationMediaProductResult[5],
    applicationMediaProductGeneration, applicationMediaProductLoadingFrames,
    applicationMediaProductResult[6], applicationMediaProductResult[7]]
end function

// Return the asset smoke value.
function assetSmoke(baseDirectory, mapName)
  if baseDirectory == "" then return error(9910, "asset smoke requires the Quake II install root containing baseq2") end if
  if mapName == "" then mapName = "base1" end if
  filesystem = applicationSharedFileSystem(baseDirectory)
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

// Return the audit retail cinematic value.
function auditRetailCinematic(filesystem, name)
  applicationAuditCinematicData = appfs.readFile(filesystem,
    cinematicPath(name))
  applicationAuditCinematicHeader = appcinformat.parseHeader(
    applicationAuditCinematicData)
  applicationAuditCinematicTables = appcinformat.buildTables(
    applicationAuditCinematicHeader)
  applicationAuditCinematicFrame = appcinformat.readFrame(
    applicationAuditCinematicData,
    applicationAuditCinematicHeader.frameDataOffset, 0,
    applicationAuditCinematicHeader, applicationAuditCinematicTables)
  applicationAuditCinematicFrameBytes = applicationAuditCinematicHeader.sampleWidth *
    applicationAuditCinematicHeader.sampleChannels
  return [name, applicationAuditCinematicHeader.width,
    applicationAuditCinematicHeader.height,
    applicationAuditCinematicHeader.sampleRate,
    len(applicationAuditCinematicFrame.audio) /
      applicationAuditCinematicFrameBytes,
    len(applicationAuditCinematicFrame.pixels)]
end function

// Return the audit retail demo value.
function auditRetailDemo(filesystem, name, randomSeed)
  applicationAuditDemo = appdemosession.create(appfs.readFile(filesystem,
    demoPath(name)), randomSeed)
  applicationAuditDemoNow = 0
  while not applicationAuditDemo.finished
    applicationAuditDemoStep = appdemosession.step(applicationAuditDemo,
      applicationAuditDemoNow)
    applicationAuditDemoNow = applicationAuditDemoNow + 100
  end while
  applicationAuditDemoTrack = applicationAuditDemo.runtime.network.configStrings[
    appqconstants.CS_CDTRACK]
  applicationAuditDemoResult = [name, applicationAuditDemo.packetsRead,
    applicationAuditDemo.framesRead,
    appdemosession.mapModelPath(applicationAuditDemo),
    applicationAuditDemoTrack]
  appdemosession.release(applicationAuditDemo)
  return applicationAuditDemoResult
end function

// Deterministic, headless retail gate for the media paths that otherwise need
// interactive windows. It decodes one real frame from both stock CIN files,
// replays both release DM2 streams through their Protocol-26 compatibility
// dispatcher, publishes base1's worldspawn CD track through Game API v3, and
// opens the matching OGG through the production Vorbis bridge.
function runRetailMediaAudit(baseDirectory)
  if not appstartup.retailRootValid(baseDirectory) then
    return error(9953, "retail media audit requires a Quake II root")
  end if
  applicationAuditFileSystem = applicationSharedFileSystem(baseDirectory)
  applicationAuditAttract = ""
  applicationAuditAttractIndex = 0
  while applicationAuditAttractIndex < appmediaseq.STOCK_ATTRACT_STEPS
    if applicationAuditAttract != "" then
      applicationAuditAttract = applicationAuditAttract + " -> "
    end if
    applicationAuditAttract = applicationAuditAttract +
      appmediaseq.stockAttractStep(applicationAuditAttractIndex).name
    applicationAuditAttractIndex = applicationAuditAttractIndex + 1
  end while

  applicationAuditIdlog = auditRetailCinematic(applicationAuditFileSystem,
    "idlog.cin")
  applicationAuditIntro = auditRetailCinematic(applicationAuditFileSystem,
    "ntro.cin")
  applicationAuditDemo1 = auditRetailDemo(applicationAuditFileSystem,
    "demo1.dm2", 31901)
  applicationAuditDemo2 = auditRetailDemo(applicationAuditFileSystem,
    "demo2.dm2", 31902)

  applicationAuditMapPath = mapPath("base1")
  applicationAuditMapBytes = appfs.readFile(applicationAuditFileSystem,
    applicationAuditMapPath)
  applicationAuditMap = appbsp.parse(applicationAuditMapBytes,
    applicationAuditMapPath)
  applicationAuditBridge = appbridge.createRuntime(1)
  applicationAuditBridge.collision = appcollision.create(applicationAuditMap)
  applicationAuditGame = appgame.GetGameApi(
    appbridge.makeImports(applicationAuditBridge))
  applicationAuditBridge.game = applicationAuditGame
  applicationAuditGame.init()
  applicationAuditGame.spawnEntities("base1", applicationAuditMap.entityText, "")
  applicationAuditLevelTrack = applicationAuditBridge.configStrings[
    appqconstants.CS_CDTRACK]

  applicationAuditMixer = appaudiomixer.create(44100)
  applicationAuditMusicOpen = appaudiomixer.synchronizeMusicTrack(
    applicationAuditMixer, applicationAuditFileSystem,
    applicationAuditLevelTrack)
  if not applicationAuditMusicOpen or applicationAuditMixer.music is void or
      not applicationAuditMixer.music.playing then
    return error(9953, "retail level OGG did not open")
  end if
  applicationAuditMusicPath = appfs.musicTrackPath(applicationAuditFileSystem,
    applicationAuditMixer.music.number)
  applicationAuditMusicRate = applicationAuditMixer.music.rate
  applicationAuditMusicChannels = applicationAuditMixer.music.channels
  applicationAuditMusicFrames = applicationAuditMixer.music.frames
  appaudiomixer.stopMusic(applicationAuditMixer)
  applicationAuditGame.shutdown()

  return RetailMediaAudit(applicationAuditAttract,
    appmediaseq.stockNewGameSpecification(),
    applicationAuditIdlog, applicationAuditIntro,
    applicationAuditDemo1, applicationAuditDemo2,
    applicationAuditLevelTrack, applicationAuditMusicPath,
    applicationAuditMusicRate, applicationAuditMusicChannels,
    applicationAuditMusicFrames)
end function

// Return the result lines value.
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

// Return the settle campaign session value.
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

// Return the campaign signon error value.
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

// Run play input smoke.
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
  if appPhysicalInputReport.planarDisplacement <= 64.0 then
    return error(9923, "play input smoke did not move: start=" +
      appPhysicalInputReport.startOrigin.x + "," +
      appPhysicalInputReport.startOrigin.y + "," +
      appPhysicalInputReport.startOrigin.z + " end=" +
      appPhysicalInputReport.endOrigin.x + "," +
      appPhysicalInputReport.endOrigin.y + "," +
      appPhysicalInputReport.endOrigin.z + " health=" +
      appPhysicalInputReport.health + " fire=" +
      appPhysicalInputReport.fireCount + " snapshots=" +
      appPhysicalInputReport.snapshots)
  end if
  if appPhysicalInputReport.fireCount < 1 then return error(9924, "play input smoke did not fire") end if
  if appPhysicalInputReport.snapshots < 1 then return error(9925, "play input smoke did not receive snapshots") end if
  if appPhysicalInputReport.rejectedPackets != 0 then return error(9926, "play input smoke rejected packets") end if
  return appPhysicalInputReport
end function

// Map preview.
function previewMap(baseDirectory, mapName, frameLimit)
  // Keep preview map phases explicit: validate inputs, update owned state, then publish the result.
  global previewFileSystem
  if frameLimit < 1 or frameLimit > 36000 then return error(9911, "preview frame limit outside [1,36000]") end if
  filesystem = applicationSharedFileSystem(baseDirectory)
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
    if applicationAutomatedProjectileAttack then
      appuikeys.setAction(input, "attack", frames >= 16 and frames < frameLimit - 16)
    end if
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

// Native product acceptance for the same mode-apply path used by the live
// Video menu. The network/game session deliberately does not participate:
// the gate isolates the Win32 mode change and verifies that the registered
// BSP remains usable on the same renderer generation.
function runRetailVideoRestartSmokeForMode(baseDirectory, mapName,
    targetVideoMode)
  global previewFileSystem
  if typeof(baseDirectory) != "string" or baseDirectory == "" then
    return error(9938, "video restart smoke requires the Quake II install root")
  end if
  applicationVideoSmokeFileSystem = applicationSharedFileSystem(baseDirectory)
  previewFileSystem = applicationVideoSmokeFileSystem
  applicationVideoSmokePath = mapPath(mapName)
  applicationVideoSmokeMap = appbsp.parse(appfs.readFile(
    applicationVideoSmokeFileSystem, applicationVideoSmokePath), applicationVideoSmokePath)
  applicationVideoSmokeHost = appproducthost.openProductHost(
    "MiniQuake2 Video Restart", 0, false, applicationRendererImports())
  applicationVideoSmokeRequestedDimensions = appproducthost.productHostDimensions(
    targetVideoMode)
  applicationVideoSmokeRequestedWidth = applicationVideoSmokeRequestedDimensions[0]
  applicationVideoSmokeRequestedHeight = applicationVideoSmokeRequestedDimensions[1]
  applicationVideoSmokeOriginalDesktopWidth = appnative.winDesktopWidth()
  applicationVideoSmokeOriginalDesktopHeight = appnative.winDesktopHeight()
  applicationVideoSmokeExclusiveAvailable = appnative.winTestDisplayMode(
    applicationVideoSmokeRequestedWidth,
    applicationVideoSmokeRequestedHeight, 32, 0) != 0
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
  applicationVideoSmokeRetainedAssets = appgl.classicRegistrationAssets(
    applicationVideoSmokeRenderer)
  applicationVideoSmokePreviousRendererGeneration = applicationVideoSmokeHost.rendererGeneration

  // Matching Win32 desktop metrics prove that supported exclusive modes use
  // ChangeDisplaySettingsW. Unsupported fixed menu modes must instead keep
  // the current desktop and create a safe borderless fullscreen host.
  applicationVideoSmokeSwitchClock = appsystem.createClock()
  appproducthost.restartProductHost(applicationVideoSmokeHost,
    "MiniQuake2 Video Restart", targetVideoMode, true,
    applicationRendererImports())
  applicationVideoSmokeSwitchMilliseconds = appbyteio.truncInt(
    appsystem.milliseconds(applicationVideoSmokeSwitchClock))
  applicationVideoSmokeAppliedWidth = applicationVideoSmokeHost.window.width
  applicationVideoSmokeAppliedHeight = applicationVideoSmokeHost.window.height
  applicationVideoSmokeDesktopWidth = appnative.winDesktopWidth()
  applicationVideoSmokeDesktopHeight = appnative.winDesktopHeight()
  applicationVideoSmokeFallback = not applicationVideoSmokeExclusiveAvailable
  if applicationVideoSmokeExclusiveAvailable then
    if applicationVideoSmokeAppliedWidth != applicationVideoSmokeRequestedWidth or
        applicationVideoSmokeAppliedHeight != applicationVideoSmokeRequestedHeight or
        applicationVideoSmokeDesktopWidth != applicationVideoSmokeRequestedWidth or
        applicationVideoSmokeDesktopHeight != applicationVideoSmokeRequestedHeight then
      appproducthost.closeProductHost(applicationVideoSmokeHost)
      previewFileSystem = void
      return error(9945, "exclusive fullscreen did not apply its Win32 display mode" +
        " requested=" + applicationVideoSmokeRequestedWidth + "x" +
          applicationVideoSmokeRequestedHeight +
        " client=" + applicationVideoSmokeAppliedWidth + "x" +
          applicationVideoSmokeAppliedHeight +
        " desktop=" + applicationVideoSmokeDesktopWidth + "x" +
          applicationVideoSmokeDesktopHeight)
    end if
  else
    if applicationVideoSmokeAppliedWidth != applicationVideoSmokeOriginalDesktopWidth or
        applicationVideoSmokeAppliedHeight != applicationVideoSmokeOriginalDesktopHeight or
        applicationVideoSmokeDesktopWidth != applicationVideoSmokeOriginalDesktopWidth or
        applicationVideoSmokeDesktopHeight != applicationVideoSmokeOriginalDesktopHeight then
      appproducthost.closeProductHost(applicationVideoSmokeHost)
      previewFileSystem = void
      return error(9945, "unsupported fullscreen mode did not use desktop fallback")
    end if
  end if

  applicationVideoSmokeRenderer = applicationVideoSmokeHost.renderer
  if applicationVideoSmokeHost.rendererGeneration !=
      applicationVideoSmokePreviousRendererGeneration then
    applicationVideoSmokeWorld = appgl.restoreClassicRegistration(
      applicationVideoSmokeRenderer, applicationVideoSmokeWorld,
      applicationVideoSmokeRetainedAssets)
  end if
  applicationVideoSmokeFrame = apprtypes.defaultRefDef(
    applicationVideoSmokeHost.window.width, applicationVideoSmokeHost.window.height)
  applicationVideoSmokeRenderer.exports.BeginFrame(0.0)
  applicationVideoSmokeRenderer.exports.RenderFrame(applicationVideoSmokeFrame)
  applicationVideoSmokeAfter = appgl.submitClassicWorld(applicationVideoSmokeRenderer,
    applicationVideoSmokeWorld, applicationVideoSmokeFrame)
  applicationVideoSmokeRenderer.exports.EndFrame()

  applicationVideoSmokeGeneration = applicationVideoSmokeHost.generation
  applicationVideoSmokeRendererGeneration = applicationVideoSmokeHost.rendererGeneration
  applicationVideoSmokeWidth = applicationVideoSmokeHost.window.width
  applicationVideoSmokeHeight = applicationVideoSmokeHost.window.height
  applicationVideoSmokeLoadingFrames = applicationVideoSmokeHost.loadingFrames
  applicationVideoSmokeBeforeVisible = applicationVideoSmokeBefore.visibleSurfaces
  applicationVideoSmokeAfterVisible = applicationVideoSmokeAfter.visibleSurfaces
  applicationVideoSmokeFullScreen = applicationVideoSmokeHost.fullScreen
  appgl.releaseClassicWorld(applicationVideoSmokeRenderer, applicationVideoSmokeWorld)
  appproducthost.closeProductHost(applicationVideoSmokeHost)
  previewFileSystem = void
  if applicationVideoSmokeGeneration != 2 or
      applicationVideoSmokeRendererGeneration !=
        applicationVideoSmokePreviousRendererGeneration or
      applicationVideoSmokeWidth != applicationVideoSmokeAppliedWidth or
      applicationVideoSmokeHeight != applicationVideoSmokeAppliedHeight or
      applicationVideoSmokeLoadingFrames != 1 or
      not applicationVideoSmokeFullScreen then
    return error(9939, "video restart host lifecycle mismatch" +
      " generation=" + applicationVideoSmokeGeneration +
      " renderer-generation=" + applicationVideoSmokeRendererGeneration +
      " previous-renderer-generation=" +
        applicationVideoSmokePreviousRendererGeneration +
      " mode=" + applicationVideoSmokeWidth + "x" +
        applicationVideoSmokeHeight +
      " applied=" + applicationVideoSmokeAppliedWidth + "x" +
        applicationVideoSmokeAppliedHeight +
      " loading-frames=" + applicationVideoSmokeLoadingFrames +
      " fullscreen=" + applicationVideoSmokeFullScreen)
  end if
  if applicationVideoSmokeBeforeVisible != applicationVideoSmokeAfterVisible then
    return error(9940, "video restart changed deterministic BSP visibility")
  end if
  return [applicationVideoSmokeGeneration, applicationVideoSmokeWidth,
    applicationVideoSmokeHeight, applicationVideoSmokeLoadingFrames,
    applicationVideoSmokeBeforeVisible, applicationVideoSmokeAfterVisible,
    applicationVideoSmokeFullScreen, applicationVideoSmokeFallback,
    applicationVideoSmokeRequestedWidth, applicationVideoSmokeRequestedHeight,
    applicationVideoSmokeSwitchMilliseconds,
    applicationVideoSmokeRendererGeneration]
end function

// Run retail video restart smoke.
function runRetailVideoRestartSmoke(baseDirectory, mapName)
  return runRetailVideoRestartSmokeForMode(baseDirectory, mapName, 5)
end function

// Return the product address book value.
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

// Update product browser menu.
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

// Own the menu-only product state until one typed transition is selected.
// Config, preferences, audio and renderer resources are finalized here so a
// subsequent local/remote session starts without retaining menu temporaries.
function runProductMenuOnHost(baseDirectory, productHost, frameLimit,
    initialProfile)
  global previewFileSystem
  previewFileSystem = applicationSharedFileSystem(baseDirectory)
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
  applicationProductPreferencesPath = playPreferencesPath(baseDirectory)
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
    if applicationProductCommands.videoMode != productHost.videoMode or
        applicationProductCommands.fullScreen != productHost.fullScreen then
      applicationProductCommands.videoRestartRequested = true
    end if
    applicationProductProfile.hand = applicationProductInput.config.hand
    appuimenu.setItemValue(applicationProductScreen.menu, "player", "hand",
      applicationProductProfile.hand)
  end if
  appuimenu.setItemValue(applicationProductScreen.menu, "video", "mode",
    applicationProductCommands.videoMode)
  applicationProductFullscreenValue = 0
  if applicationProductCommands.fullScreen then
    applicationProductFullscreenValue = 1
  end if
  appuimenu.setItemValue(applicationProductScreen.menu, "video", "fullscreen",
    applicationProductFullscreenValue)
  appuimenu.setItemValue(applicationProductScreen.menu, "video", "brightness",
    applicationProductCommands.brightness)
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
    if applicationProductCommands.videoRestartRequested then
      applicationProductCommands.videoRestartRequested = false
      applicationProductVideoRestartResult = try(
        appproducthost.restartProductHost(productHost,
          "MiniQuake2 - Main Menu", applicationProductCommands.videoMode,
          applicationProductCommands.fullScreen, applicationRendererImports()))
      if applicationProductVideoRestartResult is error then
        appuiconsole.appendLine(applicationProductScreen.console,
          "Video restart failed: " + applicationProductVideoRestartResult.message,
          appbyteio.truncInt(applicationProductNow))
        if productHost.closed then
          applicationProductAction = "quit"
          continue
        end if
        // restartProductHost reconstructed the last known-good host. Reflect
        // that rollback in both the menu and the persisted configuration.
        applicationProductCommands.videoMode = productHost.videoMode
        applicationProductCommands.fullScreen = productHost.fullScreen
        applicationProductCommands.configDirty = true
        appuimenu.setItemValue(applicationProductScreen.menu, "video", "mode",
          applicationProductCommands.videoMode)
        applicationProductRestoredFullscreen = 0
        if applicationProductCommands.fullScreen then
          applicationProductRestoredFullscreen = 1
        end if
        appuimenu.setItemValue(applicationProductScreen.menu, "video",
          "fullscreen", applicationProductRestoredFullscreen)
      end if
      applicationProductWindow = productHost.window
      applicationProductRenderer = productHost.renderer
      appwindow.setMouseCapture(false)
      appwindow.setTitle(applicationProductWindow,
        "MiniQuake2 - Main Menu - FPS --")
      appuiconsole.appendLine(applicationProductScreen.console,
        "Video restarted: " + applicationProductWindow.width + "x" +
          applicationProductWindow.height,
        appbyteio.truncInt(applicationProductNow))
    end if
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
    // A key captured by the controls menu mutates InputState directly instead
    // of going through the command-state dirty flag.  Persist it before the
    // menu loop hands off to a freshly constructed local/remote game input.
    applicationProductConfigChanged = appuicommands.takeConfigDirty(
      applicationProductCommands) or
      applicationProductInput.capturedKey >= 0
    if applicationProductConfigChanged then
      applicationProductConfigSave = try(appuiconfig.saveProductConfig(
        applicationProductConfigPath, appuiconfig.captureProductConfig(
          applicationProductInput, applicationProductCommands,
          applicationProductMixer, applicationProductScreen)))
      if applicationProductConfigSave is error then
        appuiconsole.appendLine(applicationProductScreen.console,
          "Config save failed: " + applicationProductConfigSave.message,
          appbyteio.truncInt(applicationProductNow))
      end if
      applicationProductInput.capturedKey = -1
    end if
    applicationProductRenderer.exports.BeginFrame(0.0)
    if applicationProductInput.destination == appuiconstants.KEY_CONSOLE then
      appuiconsole.draw(applicationProductScreen.console,
        applicationProductWindow.width, applicationProductWindow.height,
        applicationProductRenderer.exports)
    else
      appuimenu.draw(applicationProductScreen.menu,
        applicationProductWindow.width, applicationProductWindow.height,
        applicationProductNow, applicationProductRenderer.exports)
    end if
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
  // The next state receives the live snapshot directly. Disk remains the
  // atomic restart fallback, not the transport between states in one process.
  applicationProductFinalConfig = appuiconfig.captureProductConfig(
    applicationProductInput, applicationProductCommands,
    applicationProductMixer, applicationProductScreen)
  applicationProductFinalConfigSave = try(appuiconfig.saveProductConfig(
    applicationProductConfigPath, applicationProductFinalConfig))
  closePlayAudio(applicationProductDevice, applicationProductMixer)
  if applicationProductAction == "" then applicationProductAction = "quit" end if
  return ProductMenuSelection(applicationProductAction, applicationProductMap,
    applicationProductSkill, applicationProductEndpoint,
    applicationProductServerOptions, applicationProductProfile,
    appuicommands.downloadPolicy(applicationProductCommands),
    applicationProductFrames, applicationProductFinalConfig)
end function

// Construct and drive one authoritative local/listen session inside an
// existing product host. Loading, signon and renderer warm-up finish before
// audio starts; every exit path returns a complete transition/diagnostic value.
function runPlayAtOnHostConfiguredWithState(baseDirectory, mapName, spawnPoint,
    frameLimit, productHost, skill, menuAtStart, serverOptions, playerProfile,
    initialConfig, initialGameplayHandover)
  global previewFileSystem, playAssetState, playAssetBindings, playClientRuntime, playEffectState
  global applicationProjectileAttackCommands, applicationProjectileServerMaximum
  global applicationProjectileExportMaximum, applicationProjectileVisibleMaximum
  global applicationProjectileVisibilityDiagnostic
  global applicationProjectileLastEngineNumber
  global applicationProjectileSnapshotMaximum, applicationProjectileRenderMaximum
  global applicationProjectileParticleMaximum
  global applicationAutomatedWeaponWheel, applicationWeaponWheelCommands
  global applicationWeaponWheelTransitions, applicationWeaponWheelLastGunIndex
  global applicationAutomatedChangeLevel, applicationAutomatedChangeLevelTriggered
  global applicationAutomatedChangeLevelReached, applicationAutomatedChangeLevelTarget
  global applicationLevelCapturePath, applicationLevelCaptureChecksum
  global applicationLevelCaptureError, applicationPersistProductConfig
  if frameLimit < 0 or frameLimit > 36000 then return error(9913, "play frame limit outside [0,36000]") end if
  // Loading owns several large graphs at once and already collects at explicit
  // phase boundaries. Restore the release horizon in case a prior persistent
  // session left the lower steady-state threshold active.
  gc_set_limit(1536 * 1024 * 1024)
  filesystem = applicationSharedFileSystem(baseDirectory)
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
  // Reuse parser/collision construction temporaries in the following server
  // and renderer phases instead of carrying their high-water mark forward.
  gc_collect()
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
  applicationMapBytes = void
  appplay.runUntilActive(session, 256)
  if initialGameplayHandover is not void then
    applicationGameplayRestore = try(appplayertransition.restore(
      appgame.playerContext(), appgame.baseRuntime(), 0,
      initialGameplayHandover))
    if applicationGameplayRestore is error then
      // No renderer/world/audio graph exists yet. Close both active lifecycle
      // owners and reject the successor instead of running with partial state.
      applicationGameplayRestoreRegistration = try(renderer.exports.EndRegistration())
      applicationGameplayRestoreShutdown = try(appplay.shutdown(session))
      previewFileSystem = void
      return applicationGameplayRestore
    end if
  end if
  // Signon builds and discards several full snapshots/configstring messages.
  // Collect them before allocating the equally large render world.
  gc_collect()

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

  // Exercise the exact visible start frame while loading. Besides textures,
  // the native alias path creates frame-pair/interpolation geometry caches on
  // first use; leaving that work lazy produced a reproducible 200-300-ms
  // RenderFrame stall on gameplay frame one.
  applicationWarmBucket = 0
  while applicationWarmBucket <= 8
    applicationWarmFraction = applicationWarmBucket / 8.0
    applicationWarmFrame = appclientstate.buildPredictedRefDef(
      session.client.integrated.client, applicationWarmFraction,
      window.width, window.height, playAssetBindings,
      session.client.integrated.network.playerNumber + 1,
      randomPlayClientEffect)
    applicationWarmEffectNow = appbyteio.truncInt(
      appsystem.milliseconds(session.client.clock))
    appentityeffects.emit(session.client.integrated.effects,
      session.client.integrated.client.current,
      session.client.integrated.client.previous, applicationWarmFraction,
      applicationWarmEffectNow,
      session.client.integrated.network.playerNumber + 1,
      applicationWarmFrame)
    appeffecthandoff.applyPrepared(session.client.integrated.effects,
      applicationWarmFrame, applicationWarmEffectNow,
      resolvePlayEffectModel)
    renderer.exports.BeginFrame(0.0)
    applicationWarmWorldStats = appgl.submitClassicWorld(renderer, world,
      applicationWarmFrame)
    renderer.exports.RenderFrame(applicationWarmFrame)
    renderer.exports.EndFrame()
    // Present the warm frames at the same cadence as gameplay so DWM creates
    // and drains its swapchain before the measured/audio-active loop starts.
    appsystem.sleep(8)
    applicationWarmBucket = applicationWarmBucket + 1
  end while
  // EndFrame flushes asynchronously. Wait here, still under the loading
  // screen, so the driver cannot defer the warm-up command queue to a later
  // gameplay swap and turn it into a presentation hitch.
  appnative.glFinish()
  applicationWarmFrame = void
  applicationWarmWorldStats = void

  // BSP parsing, collision construction and renderer registration create a
  // large amount of short-lived conversion data. Reclaim it while the loading
  // screen is still visible and before the audio device starts. Otherwise the
  // first automatic full-graph collection lands in active gameplay and causes
  // a simultaneous video and sound hitch even though the steady-state frame
  // loop is fast.
  gc_collect()
  // Dense stock maps can allocate hundreds of MiB of short-lived protocol and
  // render snapshots in only a few seconds. Waiting for the 1.5-GiB loading
  // horizon forced multi-second heap-commit stalls on fact2/ware1/ware2. A
  // 256-MiB gameplay horizon reclaims those snapshots while the eight-buffer
  // audio queue still covers the measured collection tail.
  gc_set_limit(256 * 1024 * 1024)

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
  applicationConfigLoad = try(appuiconfig.selectProductConfig(
    applicationConfigPath, initialConfig))
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
  applicationCurrentPlayerProfile = appuicommands.playerProfile(
    commandState, input)
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
  applicationPerfInput = 0
  applicationMaximumFrameMsec = 0.0
  applicationMaximumFrameIndex = -1
  applicationMaximumInputMsec = 0.0
  applicationMaximumClientMsec = 0.0
  applicationMaximumWorldMsec = 0.0
  applicationMaximumEntitiesMsec = 0.0
  applicationMaximumHudMsec = 0.0
  applicationMaximumPresentMsec = 0.0
  applicationMaximumAudioMsec = 0.0
  applicationFirstAudioUnderrunFrame = -1
  applicationObservedAudioUnderruns = 0
  applicationHeapLast = heap_bytes_used()
  applicationHeapMaximum = applicationHeapLast
  applicationHeapCollections = 0
  applicationHeapInputGrowth = 0
  applicationHeapClientGrowth = 0
  applicationHeapWorldGrowth = 0
  applicationHeapEntitiesGrowth = 0
  applicationHeapHudGrowth = 0
  applicationHeapAudioGrowth = 0
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
    applicationHeapFrameStart = heap_bytes_used()
    appclientstate.setPredictionRealTime(session.client.integrated.client,
      started)
    appuicontroller.poll(input, screen, started)
    // Retail acceptance hook for the exact wheel -> binding -> reliable
    // command -> Game API -> client gun-model path. Widely spaced events let
    // the stock lowering/activation animation complete between directions.
    if applicationAutomatedWeaponWheel then
      if frames == 16 then
        applicationWeaponGiveResult = try(appclientsession.sendStringCommand(
          session.client, "give all", appbyteio.truncInt(started)))
      else if frames == 128 or frames == 384 then
        applicationWeaponWheelValue = 255
        if frames == 384 then applicationWeaponWheelValue = 1 end if
        appuicontroller.handleEvent(input, screen,
          appwindow.InputEvent(appuiconstants.EVENT_MOUSE_WHEEL, 0,
            applicationWeaponWheelValue), appbyteio.truncInt(started))
      else if frames == 640 then
        applicationWeaponWheelBurst = 0
        while applicationWeaponWheelBurst < 128
          appuicontroller.handleEvent(input, screen,
            appwindow.InputEvent(appuiconstants.EVENT_MOUSE_WHEEL, 0, 255),
            appbyteio.truncInt(started))
          applicationWeaponWheelBurst = applicationWeaponWheelBurst + 1
        end while
      end if
    end if
    // Exercise the retail target_changelevel -> intermission -> queued gamemap
    // boundary without retaining this map's native stack frame. This is the
    // exact base1 exit path, including its authored base2$base1 spawn point.
    if applicationAutomatedChangeLevel and
        not applicationAutomatedChangeLevelTriggered and frames == 32 then
      applicationAutomatedChangeLevelTriggered = true
      // Seed every stock cross-level client field before the real authored
      // transition. runChangeLevelSmoke validates the successor's owned copy.
      applicationHandoverSeedContext = appgame.playerContext()
      applicationHandoverSeedRuntime = appgame.baseRuntime()
      applicationHandoverSeedPlayer = applicationHandoverSeedContext.players[0]
      applicationHandoverSeedRocket = appgameplayitems.findByPickupName(
        applicationHandoverSeedContext.registry, "Rocket Launcher")
      applicationHandoverSeedShotgun = appgameplayitems.findByPickupName(
        applicationHandoverSeedContext.registry, "Shotgun")
      applicationHandoverSeedRockets = appgameplayitems.findByPickupName(
        applicationHandoverSeedContext.registry, "Rockets")
      applicationHandoverSeedPlayer.health = 73
      applicationHandoverSeedPlayer.maxHealth = 125
      applicationHandoverSeedPlayer.persistent.health = 73
      applicationHandoverSeedPlayer.persistent.maxHealth = 125
      applicationHandoverSeedPlayer.gameplay.health = 73
      applicationHandoverSeedPlayer.gameplay.maxHealth = 125
      applicationHandoverSeedPlayer.gameplay.inventory.counts[
        applicationHandoverSeedRocket.index] = 1
      applicationHandoverSeedPlayer.gameplay.inventory.counts[
        applicationHandoverSeedShotgun.index] = 1
      applicationHandoverSeedPlayer.gameplay.inventory.counts[
        applicationHandoverSeedRockets.index] = 37
      applicationHandoverSeedPlayer.gameplay.inventory.maxBullets = 311
      applicationHandoverSeedPlayer.gameplay.inventory.maxShells = 122
      applicationHandoverSeedPlayer.gameplay.inventory.maxRockets = 77
      applicationHandoverSeedPlayer.gameplay.inventory.maxGrenades = 66
      applicationHandoverSeedPlayer.gameplay.inventory.maxCells = 333
      applicationHandoverSeedPlayer.gameplay.inventory.maxSlugs = 88
      applicationHandoverSeedPlayer.gameplay.inventory.selectedItem = applicationHandoverSeedRocket.index
      applicationHandoverSeedPlayer.persistent.selectedItem = applicationHandoverSeedRocket.index
      applicationHandoverSeedPlayer.gameplay.currentWeapon = applicationHandoverSeedRocket
      applicationHandoverSeedPlayer.gameplay.lastWeapon = applicationHandoverSeedShotgun
      applicationHandoverSeedPlayer.flags = applicationHandoverSeedPlayer.flags |
        appgameplayconstants.FL_GODMODE | appgameplayconstants.FL_NOTARGET |
        appgameplayconstants.FL_POWER_ARMOR
      applicationHandoverSeedPlayer.gameplay.flags = applicationHandoverSeedPlayer.flags
      applicationHandoverSeedPlayer.gameplay.powerCubes = 0x15
      applicationHandoverSeedPlayer.persistent.score = 9
      applicationHandoverSeedPlayer.respawn.score = 17
      applicationHandoverSeedRuntime.world.serverFlags = 0x2a
      applicationAutomatedChangeLevelResult = appcampaignprogression.driveToMap(
        applicationHandoverSeedRuntime, applicationHandoverSeedContext,
        applicationAutomatedChangeLevelTarget)
      // The authored target chain may legitimately update game help while it
      // opens intermission. Seed after that chain to test the map boundary.
      applicationHandoverSeedRuntime.world.helpMessage1 = "handover help one"
      applicationHandoverSeedRuntime.world.helpMessage2 = "handover help two"
      applicationHandoverSeedRuntime.world.helpChanged = 3
      applicationAutomatedChangeLevelReached = applicationAutomatedChangeLevelResult.reached
      if applicationAutomatedChangeLevelReached then
        applicationAutomatedChangeLevelContext = appgame.playerContext()
        applicationAutomatedChangeLevelContext.exitIntermission = true
      else
        // Leave through the normal teardown path; the smoke wrapper reports
        // the failed transition after audio, renderer and session cleanup.
        commandState.quitRequested = true
      end if
    end if
    // Product-only acceptance hook: drive the same bound action that a real
    // mouse button uses, before sampling view/buttons into the network cmd.
    if applicationAutomatedProjectileAttack then
      appuikeys.setAction(input, "attack", frames >= 16 and frames < frameLimit - 16)
    end if
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
        applicationCurrentPlayerProfile = applicationUpdatedProfile
      end if
    end if
    if appuicommands.takeDisconnect(commandState) then
      applicationDisconnectRequested = true
      continue
    end if
    if input.config.hand != applicationPublishedHand then
      appgl.setHandedness(renderer, input.config.hand)
      appuimenu.setItemValue(screen.menu, "player", "hand", input.config.hand)
      applicationCurrentPlayerProfile.hand = input.config.hand
      applicationHandUserInfo = appstartup.playerUserInfo(
        applicationCurrentPlayerProfile)
      if appplay.setUserInfo(session, applicationHandUserInfo) then
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
      if applicationAutomatedWeaponWheel and
          (applicationForwardedCommand == "weapnext" or
           applicationForwardedCommand == "weapprev") then
        applicationWeaponWheelCommands = applicationWeaponWheelCommands + 1
      end if
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
      // The common mode-change path keeps the native OpenGL context as well as
      // the game session and level. Retain the immutable CPU registration graph
      // for the uncommon destroy/recreate fallback; even there, only GPU names
      // and uploads need rebuilding, never the BSP, model, sound or client data.
      applicationVideoRetainedAssets = appgl.classicRegistrationAssets(renderer)
      applicationVideoPreviousRendererGeneration = productHost.rendererGeneration
      applicationVideoRestartResult = try(appproducthost.restartProductHost(productHost,
        "MiniQuake2 - " + applicationCurrentMapName, commandState.videoMode,
        commandState.fullScreen, applicationRendererImports()))
      if applicationVideoRestartResult is error then
        appuiconsole.appendLine(screen.console,
          "Video restart failed: " + applicationVideoRestartResult.message,
          appbyteio.truncInt(started))
        if productHost.closed then
          commandState.quitRequested = true
          continue
        end if
        commandState.videoMode = productHost.videoMode
        commandState.fullScreen = productHost.fullScreen
        commandState.configDirty = true
        appuimenu.setItemValue(screen.menu, "video", "mode",
          commandState.videoMode)
        applicationRestoredFullscreen = 0
        if commandState.fullScreen then applicationRestoredFullscreen = 1 end if
        appuimenu.setItemValue(screen.menu, "video", "fullscreen",
          applicationRestoredFullscreen)
      end if
      window = productHost.window
      renderer = productHost.renderer
      appgl.setHandedness(renderer, input.config.hand)
      if productHost.rendererGeneration !=
          applicationVideoPreviousRendererGeneration then
        applicationVideoRegistrationRestore = try(appgl.restoreClassicRegistration(
          renderer, world, applicationVideoRetainedAssets))
        if applicationVideoRegistrationRestore is error then
          appuiconsole.appendLine(screen.console,
            "Video resource restore failed: " +
              applicationVideoRegistrationRestore.message,
            appbyteio.truncInt(started))
          commandState.quitRequested = true
          continue
        end if
      end if
      appwindow.setMouseCapture(input.destination == appuiconstants.KEY_GAME)
      appuiconsole.appendLine(screen.console,
        "Video mode applied: " + window.width + "x" + window.height,
        appbyteio.truncInt(started))
    end if
    networkMsec = started - networkTime
    if networkMsec >= 100 then
      if networkMsec > 200 then networkMsec = 200 end if
      command = appuiinput.createSampledUserCmd(input,
        appbyteio.truncInt(networkMsec))
      if applicationAutomatedProjectileAttack and
          (command.buttons & appuiconstants.BUTTON_ATTACK) != 0 then
        applicationProjectileAttackCommands = applicationProjectileAttackCommands + 1
      end if
      appplay.predictLocal(session, command)
      appplay.setUserCmd(session, command)
      stepResult = appplay.step(session)
      if applicationAutomatedProjectileAttack then
        applicationProjectileRuntime = appgame.baseRuntime()
        applicationProjectileServerCount = len(applicationProjectileRuntime.weaponContext.projectiles)
        if applicationProjectileServerCount > applicationProjectileServerMaximum then
          applicationProjectileServerMaximum = applicationProjectileServerCount
        end if
        applicationProjectileExportCount = 0
        for each applicationServerProjectile in applicationProjectileRuntime.weaponContext.projectiles
          applicationProjectileEngineNumber = applicationServerProjectile.engineNumber
          if applicationServerProjectile.inUse and applicationProjectileEngineNumber > 0 and
              applicationProjectileEngineNumber < session.server.gameExport.numEdicts then
            applicationProjectileLastEngineNumber = applicationProjectileEngineNumber
            applicationProjectileEdict = session.server.gameExport.edicts[
              applicationProjectileEngineNumber]
            if applicationProjectileEdict.inUse and
                (applicationProjectileEdict.state.effects &
                 (appeffectconstants.EF_BLASTER |
                  appeffectconstants.EF_HYPERBLASTER)) != 0 then
              applicationProjectileExportCount = applicationProjectileExportCount + 1
              applicationProjectileViewerEdict = session.server.gameExport.edicts[1]
              applicationProjectileViewerLeafNumber = appcollision.pointLeafNumber(
                session.server.collision,
                appsession.clientViewOrigin(applicationProjectileViewerEdict), 0)
              applicationProjectileViewerLeaf = session.server.collision.map.leafs[
                applicationProjectileViewerLeafNumber]
              applicationProjectileFirstCluster = -1
              if applicationProjectileEdict.numClusters > 0 then
                applicationProjectileFirstCluster = applicationProjectileEdict.clusterNumbers[0]
              end if
              applicationProjectileAreasConnected = true
              if applicationProjectileEdict.areaNumber != 0 then
                applicationProjectileAreasConnected = appcollision.areasConnected(
                  session.server.collision, applicationProjectileViewerLeaf.area,
                  applicationProjectileEdict.areaNumber)
              end if
              applicationProjectileOwnerNumber = -1
              if applicationProjectileEdict.owner is not void then
                applicationProjectileOwnerNumber = applicationProjectileEdict.owner.state.number
              end if
              applicationProjectileVisibilityDiagnostic = "entity=" +
                applicationProjectileEngineNumber + " viewer-leaf=" +
                applicationProjectileViewerLeafNumber + " viewer-area=" +
                applicationProjectileViewerLeaf.area + " viewer-cluster=" +
                applicationProjectileViewerLeaf.cluster + " entity-area=" +
                applicationProjectileEdict.areaNumber + " entity-area2=" +
                applicationProjectileEdict.areaNumber2 + " clusters=" +
                applicationProjectileEdict.numClusters + " first-cluster=" +
                applicationProjectileFirstCluster + " areas-connected=" +
                applicationProjectileAreasConnected + " owner=" +
                applicationProjectileOwnerNumber + " viewer-origin=" +
                applicationProjectileViewerEdict.state.origin.x + "," +
                applicationProjectileViewerEdict.state.origin.y + "," +
                applicationProjectileViewerEdict.state.origin.z +
                " projectile-origin=" + applicationProjectileEdict.state.origin.x +
                "," + applicationProjectileEdict.state.origin.y + "," +
                applicationProjectileEdict.state.origin.z + " velocity=" +
                applicationServerProjectile.velocity.x + "," +
                applicationServerProjectile.velocity.y + "," +
                applicationServerProjectile.velocity.z
            end if
          end if
        end for
        if applicationProjectileExportCount > applicationProjectileExportMaximum then
          applicationProjectileExportMaximum = applicationProjectileExportCount
        end if
        applicationProjectileViewer = session.server.gameExport.edicts[1]
        applicationProjectileVisibleStates = appsession.packetEntitiesForClient(
          session.server, applicationProjectileViewer)
        applicationProjectileVisibleCount = 0
        for each applicationProjectileVisibleState in applicationProjectileVisibleStates
          if applicationProjectileVisibleState.number ==
              applicationProjectileLastEngineNumber or
              (applicationProjectileVisibleState.effects &
              (appeffectconstants.EF_BLASTER |
               appeffectconstants.EF_HYPERBLASTER)) != 0 then
            applicationProjectileVisibleCount = applicationProjectileVisibleCount + 1
          end if
        end for
        if applicationProjectileLastEngineNumber > 0 and
            applicationProjectileLastEngineNumber < session.server.gameExport.numEdicts then
          applicationProjectilePublishedEdict = session.server.gameExport.edicts[
            applicationProjectileLastEngineNumber]
          applicationProjectileDirectVisible = appsession.entityVisible(session.server,
            applicationProjectileViewer, applicationProjectilePublishedEdict)
          applicationProjectileVisibilityDiagnostic = applicationProjectileVisibilityDiagnostic + " export-number=" +
            applicationProjectilePublishedEdict.state.number + " server-flags=" +
            applicationProjectilePublishedEdict.serverFlags + " model=" +
            applicationProjectilePublishedEdict.state.modelIndex + " effects=" +
            applicationProjectilePublishedEdict.state.effects + " visible-states=" +
            len(applicationProjectileVisibleStates) + " direct-visible=" +
            applicationProjectileDirectVisible
        end if
        if applicationProjectileVisibleCount > applicationProjectileVisibleMaximum then
          applicationProjectileVisibleMaximum = applicationProjectileVisibleCount
        end if
      end if
      latest = stepResult.handoff
      applyPlayHandoff(screen, latest)
      appclientassets.refreshConfigStrings(assetState,
        session.client.integrated.network.configStrings)
      if applicationAutomatedWeaponWheel then
        applicationWeaponGunIndex = session.client.integrated.client.current.playerState.gunIndex
        if applicationWeaponGunIndex > 0 then
          if applicationWeaponWheelLastGunIndex > 0 and
              applicationWeaponGunIndex != applicationWeaponWheelLastGunIndex then
            applicationWeaponWheelTransitions = applicationWeaponWheelTransitions + 1
          end if
          applicationWeaponWheelLastGunIndex = applicationWeaponGunIndex
        end if
      end if
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
    applicationPerfInput = applicationPerfInput + applicationPerfStart - started
    applicationHeapAfterInput = heap_bytes_used()
    if applicationHeapAfterInput > applicationHeapFrameStart then
      applicationHeapInputGrowth = applicationHeapInputGrowth +
        applicationHeapAfterInput - applicationHeapFrameStart
    end if
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
    appeffecthandoff.applyPrepared(session.client.integrated.effects, frame,
      effectNow, resolvePlayEffectModel)
    if applicationAutomatedProjectileAttack then
      applicationProjectileSnapshots = 0
      for each applicationProjectileState in session.client.integrated.client.current.entities
        if applicationProjectileState.number == applicationProjectileLastEngineNumber or
            (applicationProjectileState.effects &
            (appeffectconstants.EF_BLASTER |
             appeffectconstants.EF_HYPERBLASTER)) != 0 then
          applicationProjectileSnapshots = applicationProjectileSnapshots + 1
        end if
      end for
      if applicationProjectileSnapshots > applicationProjectileSnapshotMaximum then
        applicationProjectileSnapshotMaximum = applicationProjectileSnapshots
      end if
      applicationProjectileRenders = 0
      for each applicationProjectileEntity in frame.entities
        if applicationProjectileEntity.model is not void and
            applicationProjectileEntity.model.name ==
              "models/objects/laser/tris.md2" then
          applicationProjectileRenders = applicationProjectileRenders + 1
        end if
      end for
      if applicationProjectileRenders > applicationProjectileRenderMaximum then
        applicationProjectileRenderMaximum = applicationProjectileRenders
      end if
      if frame.numParticles > applicationProjectileParticleMaximum then
        applicationProjectileParticleMaximum = frame.numParticles
      end if
    end if
    applicationPerfWorldStart = appsystem.milliseconds(clock)
    applicationPerfClient = applicationPerfClient +
      applicationPerfWorldStart - applicationPerfStart
    applicationHeapAfterClient = heap_bytes_used()
    if applicationHeapAfterClient > applicationHeapAfterInput then
      applicationHeapClientGrowth = applicationHeapClientGrowth +
        applicationHeapAfterClient - applicationHeapAfterInput
    end if
    renderer.exports.BeginFrame(0.0)
    lastWorldStats = appgl.submitClassicWorld(renderer, world, frame)
    applicationPerfEntityStart = appsystem.milliseconds(clock)
    applicationPerfWorld = applicationPerfWorld +
      applicationPerfEntityStart - applicationPerfWorldStart
    applicationHeapAfterWorld = heap_bytes_used()
    if applicationHeapAfterWorld > applicationHeapAfterClient then
      applicationHeapWorldGrowth = applicationHeapWorldGrowth +
        applicationHeapAfterWorld - applicationHeapAfterClient
    end if
    renderer.exports.RenderFrame(frame)
    input.lightLevel = appgl.lightLevel(renderer)
    applicationPerfHudStart = appsystem.milliseconds(clock)
    applicationPerfEntities = applicationPerfEntities +
      applicationPerfHudStart - applicationPerfEntityStart
    applicationHeapAfterEntities = heap_bytes_used()
    if applicationHeapAfterEntities > applicationHeapAfterWorld then
      applicationHeapEntitiesGrowth = applicationHeapEntitiesGrowth +
        applicationHeapAfterEntities - applicationHeapAfterWorld
    end if
    appuiscreen.draw(screen, started, window.width, window.height,
      session.client.integrated.client.current.playerState.stats,
      session.client.integrated.network.configStrings,
      session.client.integrated.client.current.number,
      session.client.integrated.network.playerNumber, renderer.exports)
    // Gallery captures use the complete product framebuffer after world,
    // entities, view weapon and HUD submission. Capture the final requested
    // frame before the swap so the artifact matches an on-screen level start.
    if applicationLevelCapturePath != "" and frameLimit > 0 and
        frames + 1 >= frameLimit then
      applicationLevelCaptureImage = try(
        appcapture.readOpenGlFrame(window.width, window.height))
      if applicationLevelCaptureImage is error then
        applicationLevelCaptureError = applicationLevelCaptureImage
      else
        applicationLevelCaptureWrite = try(appcapture.writeTga(
          applicationLevelCapturePath, applicationLevelCaptureImage))
        if applicationLevelCaptureWrite is error then
          applicationLevelCaptureError = applicationLevelCaptureWrite
        else
          applicationLevelCaptureChecksum = appcapture.rgbaChecksum(
            applicationLevelCaptureImage)
        end if
      end if
      applicationLevelCapturePath = ""
    end if
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
    applicationHeapAfterHud = heap_bytes_used()
    if applicationHeapAfterHud > applicationHeapAfterEntities then
      applicationHeapHudGrowth = applicationHeapHudGrowth +
        applicationHeapAfterHud - applicationHeapAfterEntities
    end if
    applicationPerfPresentStart = appsystem.milliseconds(clock)
    renderer.exports.EndFrame()
    applicationPerfAudioStart = appsystem.milliseconds(clock)
    applicationPerfPresent = applicationPerfPresent +
      applicationPerfAudioStart - applicationPerfPresentStart
    // The first few frames can still create one-off HUD/effect resources.
    // Start the queue after that warm-up so playback begins continuously;
    // pending sounds retain their mixer timestamps and are not discarded.
    if frames >= 4 then pumpPlayAudio(audioDevice, audioMixer) end if
    if audioDevice is not void then
      applicationObservedAudioUnderruns = appaudiodevice.underruns(audioDevice)
      if applicationObservedAudioUnderruns > 0 and
          applicationFirstAudioUnderrunFrame < 0 then
        applicationFirstAudioUnderrunFrame = frames
      end if
    end if
    applicationPerfAudio = applicationPerfAudio +
      appsystem.milliseconds(clock) - applicationPerfAudioStart
    applicationHeapAfterAudio = heap_bytes_used()
    if applicationHeapAfterAudio > applicationHeapAfterHud then
      applicationHeapAudioGrowth = applicationHeapAudioGrowth +
        applicationHeapAfterAudio - applicationHeapAfterHud
    end if
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
    if elapsed > applicationMaximumFrameMsec then
      applicationMaximumFrameMsec = elapsed
      applicationMaximumFrameIndex = frames - 1
      applicationMaximumInputMsec = applicationPerfStart - started
      applicationMaximumClientMsec = applicationPerfWorldStart - applicationPerfStart
      applicationMaximumWorldMsec = applicationPerfEntityStart - applicationPerfWorldStart
      applicationMaximumEntitiesMsec = applicationPerfHudStart - applicationPerfEntityStart
      applicationMaximumHudMsec = applicationPerfPresentStart - applicationPerfHudStart
      applicationMaximumPresentMsec = applicationPerfAudioStart - applicationPerfPresentStart
      applicationMaximumAudioMsec = applicationFpsNow - applicationPerfAudioStart
    end if
    applicationPerfFrame = applicationPerfFrame + elapsed
    applicationHeapNow = heap_bytes_used()
    if applicationHeapNow < applicationHeapLast then
      applicationHeapCollections = applicationHeapCollections + 1
    end if
    if applicationHeapNow > applicationHeapMaximum then
      applicationHeapMaximum = applicationHeapNow
    end if
    applicationHeapLast = applicationHeapNow
    // The 10-Hz game/network cadence is independent from presentation. Keep a
    // modern 250-Hz ceiling so fast GPUs are no longer artificially limited to
    // 125 FPS, while repeated Sleep(0) yields still prevent an unbounded DWM
    // swap queue and avoid coarse Win32 timer oversleep.
    applicationFrameDeadline = started + 4.0
    while appsystem.milliseconds(clock) < applicationFrameDeadline
      appsystem.sleep(0)
    end while
  end while

  appwindow.setMouseCapture(false)
  applicationDemoShutdown = try(appdemorecording.shutdown(
    applicationDemoRecording))
  applicationAudioSubmitted = 0
  applicationAudioCompleted = 0
  applicationAudioUnderruns = 0
  applicationAudioCapacity = 0
  if audioDevice is not void then
    applicationAudioSubmitted = appaudiodevice.submitted(audioDevice)
    applicationAudioCompleted = appaudiodevice.completed(audioDevice)
    applicationAudioUnderruns = appaudiodevice.underruns(audioDevice)
    applicationAudioCapacity = appaudiodevice.capacity(audioDevice)
  end if
  // Capture at every state boundary, even when no dirty flag survived the
  // final frame. The successor map consumes this object before consulting
  // disk, while the atomic file is retained for process restart recovery.
  applicationFinalProductConfig = appuiconfig.captureProductConfig(
    input, commandState, audioMixer, screen)
  applicationFinalProductConfigSave = true
  if applicationPersistProductConfig then
    applicationFinalProductConfigSave = try(appuiconfig.saveProductConfig(
      applicationConfigPath, applicationFinalProductConfig))
  end if
  // The old and new sessions must never share mutable inventory storage. The
  // typed handover owns its arrays before shutdown releases this Game API.
  applicationFinalGameplayHandover = try(appplayertransition.capture(
    appgame.playerContext(), appgame.baseRuntime(), 0))
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
  if applicationFinalGameplayHandover is error then
    return applicationFinalGameplayHandover
  end if
  if applicationLevelCaptureError is error then
    return applicationLevelCaptureError
  end if
  return [frames, clientState, serverFrame, registeredModels,
    registeredSounds, missingAssets, submittedEntities,
    visibleSurfaces, culledSurfaces, viewCluster,
    applicationPerfClient, applicationPerfWorld, applicationPerfEntities,
    applicationPerfHud, missingAssetSummary, applicationPerfPresent,
    applicationPerfAudio, applicationPerfFrame, applicationDisconnectRequested,
    commandState.quitRequested, applicationAudioSubmitted,
    applicationAudioCompleted, applicationAudioUnderruns,
    applicationAudioCapacity, applicationMaximumFrameMsec,
    applicationFirstAudioUnderrunFrame, applicationHeapLast,
    applicationHeapMaximum, applicationHeapCollections,
    applicationMaximumFrameIndex, applicationMaximumInputMsec,
    applicationMaximumClientMsec, applicationMaximumWorldMsec,
    applicationMaximumEntitiesMsec, applicationMaximumHudMsec,
    applicationMaximumPresentMsec, applicationMaximumAudioMsec,
    applicationHeapInputGrowth, applicationHeapClientGrowth,
    applicationHeapWorldGrowth, applicationHeapEntitiesGrowth,
    applicationHeapHudGrowth, applicationHeapAudioGrowth,
    applicationPerfInput, applicationPendingMediaSpecification,
    applicationNextSkill, applicationCurrentMapName,
    applicationFinalProductConfig, applicationCurrentPlayerProfile,
    applicationFinalGameplayHandover]
end function

// Report whether run play at on host configured with config.
function runPlayAtOnHostConfiguredWithConfig(baseDirectory, mapName, spawnPoint,
    frameLimit, productHost, skill, menuAtStart, serverOptions, playerProfile,
    initialConfig)
  return runPlayAtOnHostConfiguredWithState(baseDirectory, mapName, spawnPoint,
    frameLimit, productHost, skill, menuAtStart, serverOptions, playerProfile,
    initialConfig, void)
end function

// Report whether run play at on host configured.
function runPlayAtOnHostConfigured(baseDirectory, mapName, spawnPoint, frameLimit,
    productHost, skill, menuAtStart, serverOptions, playerProfile)
  return runPlayAtOnHostConfiguredWithConfig(baseDirectory, mapName, spawnPoint,
    frameLimit, productHost, skill, menuAtStart, serverOptions, playerProfile,
    void)
end function

// Report whether run play at on host.
function runPlayAtOnHost(baseDirectory, mapName, spawnPoint, frameLimit,
    productHost, skill)
  return runPlayAtOnHostConfigured(baseDirectory, mapName, spawnPoint, frameLimit,
    productHost, skill, true, void, appstartup.defaultPlayerProfile())
end function

// Run play at.
function runPlayAt(baseDirectory, mapName, spawnPoint, frameLimit)
  applicationPlayProductHost = appproducthost.openProductHost("MiniQuake2 - " + mapName,
    3, false, applicationRendererImports())
  applicationPlayProductResult = try(runPlayAtOnHost(baseDirectory, mapName,
    spawnPoint, frameLimit, applicationPlayProductHost, 1))
  if applicationPlayProductResult is not error and
      len(applicationPlayProductResult) >= 50 and
      applicationPlayProductResult[44] != "" then
    applicationPlayMediaResult = try(runRetailMediaSequenceOnHostWithState(baseDirectory,
      applicationPlayProductResult[44], frameLimit,
      applicationPlayProductHost, applicationPlayProductResult[45],
      applicationPlayProductResult[47], applicationPlayProductResult[48],
      applicationPlayProductResult[49]))
    if applicationPlayMediaResult is error then
      applicationPlayProductResult = applicationPlayMediaResult
    else if applicationPlayMediaResult[6] is not void then
      applicationPlayProductResult = applicationPlayMediaResult[6]
    end if
  end if
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

// Run play.
function runPlay(baseDirectory, mapName, frameLimit)
  return runPlayAt(baseDirectory, mapName, "", frameLimit)
end function

// Render one deterministic 1920x1080 product frame at an authored campaign
// spawn without reading or overwriting the player's persistent configuration.
function captureLevelStart(baseDirectory, mapName, outputPath, frameLimit)
  global applicationLevelCapturePath, applicationLevelCaptureChecksum
  global applicationLevelCaptureError, applicationPersistProductConfig
  if typeof(outputPath) != "string" or outputPath == "" then
    return error(9980, "level capture output path is required")
  end if
  if frameLimit < 1 or frameLimit > 1000 then
    return error(9981, "level capture frame count outside [1,1000]")
  end if
  applicationLevelCaptureHost = appproducthost.openProductHost(
    "MiniQuake2 level capture - " + mapName, 5, false,
    applicationRendererImports())
  applicationLevelCaptureConfig = appuiconfig.ProductConfig(
    3.0, false, false, 0, 0.7, 5, false, 1.0, 1, false, [], false)
  applicationLevelCapturePath = outputPath
  applicationLevelCaptureChecksum = 0
  applicationLevelCaptureError = void
  applicationPersistProductConfig = false
  applicationLevelCaptureResult = try(runPlayAtOnHostConfiguredWithConfig(
    baseDirectory, mapName, "", frameLimit, applicationLevelCaptureHost, 1,
    false, void, appstartup.defaultPlayerProfile(),
    applicationLevelCaptureConfig))
  applicationPersistProductConfig = true
  applicationLevelCapturePath = ""
  if applicationLevelCaptureResult is error and
      applicationLevelCaptureHost.renderer.state.core.state.frameOpen then
    applicationLevelCaptureEndFrame = try(
      applicationLevelCaptureHost.renderer.exports.EndFrame())
  end if
  applicationLevelCaptureClose = try(
    appproducthost.closeProductHost(applicationLevelCaptureHost))
  if applicationLevelCaptureResult is error then
    return applicationLevelCaptureResult
  end if
  if applicationLevelCaptureClose is error then
    return applicationLevelCaptureClose
  end if
  return [applicationLevelCaptureResult[0], applicationLevelCaptureChecksum,
    1920, 1080, applicationLevelCaptureResult[5]]
end function

// Run change level smoke.
function runChangeLevelSmoke(baseDirectory, mapName, nextMap, frameLimit)
  // Keep run change level smoke phases explicit: validate inputs, update owned state, then publish the result.
  global applicationAutomatedChangeLevel, applicationAutomatedChangeLevelTriggered
  global applicationAutomatedChangeLevelReached, applicationAutomatedChangeLevelTarget
  if frameLimit < 180 then frameLimit = 180 end if
  applicationAutomatedChangeLevel = true
  applicationAutomatedChangeLevelTriggered = false
  applicationAutomatedChangeLevelReached = false
  applicationAutomatedChangeLevelTarget = nextMap
  applicationChangeLevelSmokeResult = try(runPlayAt(baseDirectory, mapName,
    "", frameLimit))
  applicationAutomatedChangeLevel = false
  applicationAutomatedChangeLevelTarget = ""
  if applicationChangeLevelSmokeResult is error then
    return applicationChangeLevelSmokeResult
  end if
  if not applicationAutomatedChangeLevelTriggered or
      not applicationAutomatedChangeLevelReached then
    return error(9933, "retail changelevel automation did not execute")
  end if
  if len(applicationChangeLevelSmokeResult) < 47 or
      applicationChangeLevelSmokeResult[46] != nextMap then
    return error(9934, "retail changelevel did not enter " + nextMap)
  end if
  if len(applicationChangeLevelSmokeResult) < 50 then
    return error(9935, "retail changelevel did not return gameplay handover")
  end if
  applicationChangeLevelHandover = applicationChangeLevelSmokeResult[49]
  if applicationChangeLevelHandover.health != 73 or
      applicationChangeLevelHandover.maxHealth != 125 or
      applicationChangeLevelHandover.maxBullets != 311 or
      applicationChangeLevelHandover.maxShells != 122 or
      applicationChangeLevelHandover.maxRockets != 77 or
      applicationChangeLevelHandover.maxGrenades != 66 or
      applicationChangeLevelHandover.maxCells != 333 or
      applicationChangeLevelHandover.maxSlugs != 88 or
      applicationChangeLevelHandover.powerCubes != 0x15 or
      applicationChangeLevelHandover.persistentScore != 9 or
      applicationChangeLevelHandover.respawnScore != 17 or
      applicationChangeLevelHandover.serverFlags != 0x2a then
    return error(9936, "retail successor lost scalar gameplay state")
  end if
  applicationChangeLevelRegistry = appgameplayregistry.baseq2Registry()
  applicationChangeLevelRocket = appgameplayitems.findByPickupName(
    applicationChangeLevelRegistry, "Rocket Launcher")
  applicationChangeLevelShotgun = appgameplayitems.findByPickupName(
    applicationChangeLevelRegistry, "Shotgun")
  applicationChangeLevelRockets = appgameplayitems.findByPickupName(
    applicationChangeLevelRegistry, "Rockets")
  if applicationChangeLevelHandover.inventoryCounts[
      applicationChangeLevelRocket.index] != 1 or
      applicationChangeLevelHandover.inventoryCounts[
      applicationChangeLevelRockets.index] != 37 or
      applicationChangeLevelHandover.selectedItem !=
      applicationChangeLevelRocket.index or
      applicationChangeLevelHandover.currentWeaponIndex !=
      applicationChangeLevelRocket.index or
      applicationChangeLevelHandover.lastWeaponIndex !=
      applicationChangeLevelShotgun.index or
      (applicationChangeLevelHandover.savedFlags &
        (appgameplayconstants.FL_GODMODE | appgameplayconstants.FL_NOTARGET |
          appgameplayconstants.FL_POWER_ARMOR)) !=
        (appgameplayconstants.FL_GODMODE | appgameplayconstants.FL_NOTARGET |
          appgameplayconstants.FL_POWER_ARMOR) then
    return error(9937, "retail successor lost inventory, weapon or flag state" +
      " rocket=" + applicationChangeLevelHandover.inventoryCounts[
        applicationChangeLevelRocket.index] +
      " rockets=" + applicationChangeLevelHandover.inventoryCounts[
        applicationChangeLevelRockets.index] +
      " selected=" + applicationChangeLevelHandover.selectedItem +
      " current=" + applicationChangeLevelHandover.currentWeaponIndex +
      " last=" + applicationChangeLevelHandover.lastWeaponIndex +
      " flags=" + applicationChangeLevelHandover.savedFlags)
  end if
  return [mapName, nextMap, applicationChangeLevelSmokeResult[0],
    applicationChangeLevelSmokeResult[2],
    applicationChangeLevelSmokeResult[27]]
end function

// Run projectile visual smoke.
function runProjectileVisualSmoke(baseDirectory, mapName, frameLimit)
  global applicationAutomatedProjectileAttack, applicationProjectileSnapshotMaximum, applicationProjectileRenderMaximum, applicationProjectileParticleMaximum, applicationProjectileServerMaximum, applicationProjectileAttackCommands, applicationProjectileExportMaximum, applicationProjectileVisibleMaximum, applicationProjectileVisibilityDiagnostic, applicationProjectileLastEngineNumber
  if frameLimit < 240 then frameLimit = 240 end if
  applicationProjectileSnapshotMaximum = 0
  applicationProjectileRenderMaximum = 0
  applicationProjectileParticleMaximum = 0
  applicationProjectileServerMaximum = 0
  applicationProjectileAttackCommands = 0
  applicationProjectileExportMaximum = 0
  applicationProjectileVisibleMaximum = 0
  applicationProjectileVisibilityDiagnostic = "unavailable"
  applicationProjectileLastEngineNumber = -1
  applicationAutomatedProjectileAttack = true
  applicationProjectileResult = try(runPlayAt(baseDirectory, mapName, "", frameLimit))
  applicationAutomatedProjectileAttack = false
  if applicationProjectileResult is error then return applicationProjectileResult end if
  return [applicationProjectileResult, applicationProjectileAttackCommands,
    appbaseq2.projectileLinkCount(), appbaseq2.projectileFreeCount(),
    applicationProjectileServerMaximum, applicationProjectileExportMaximum,
    applicationProjectileVisibleMaximum,
    applicationProjectileSnapshotMaximum,
    applicationProjectileRenderMaximum, applicationProjectileParticleMaximum,
    applicationProjectileVisibilityDiagnostic]
end function

// Run weapon wheel smoke.
function runWeaponWheelSmoke(baseDirectory, mapName, frameLimit)
  global applicationAutomatedWeaponWheel, applicationWeaponWheelCommands
  global applicationWeaponWheelTransitions, applicationWeaponWheelLastGunIndex
  if frameLimit < 900 then frameLimit = 900 end if
  applicationWeaponWheelCommands = 0
  applicationWeaponWheelTransitions = 0
  applicationWeaponWheelLastGunIndex = -1
  applicationAutomatedWeaponWheel = true
  applicationWeaponWheelResult = try(runPlayAt(baseDirectory, mapName, "", frameLimit))
  applicationAutomatedWeaponWheel = false
  if applicationWeaponWheelResult is error then return applicationWeaponWheelResult end if
  return [applicationWeaponWheelResult, applicationWeaponWheelCommands,
    applicationWeaponWheelTransitions, applicationWeaponWheelLastGunIndex]
end function

// Map remote model path.
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

// Register application remote world.
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

// Drive a remote Protocol-34 client with independent render, UserCmd and
// snapshot clocks. Registration is committed only after downloads, checksum
// validation and all client assets complete successfully.
function runRemoteProductOnHost(baseDirectory, endpoint, productHost,
    playerProfile, downloadPolicy, frameLimit)
  // Keep run remote product on host phases explicit: validate inputs, update owned state, then publish the result.
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
  applicationRemoteFileSystem = applicationSharedFileSystem(baseDirectory)
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
  applicationRemoteCommandTime = applicationRemoteNetworkTime
  applicationRemoteObservedFrame = -1
  applicationRemoteInputTime = applicationRemoteNetworkTime
  applicationRemoteFrames = 0
  applicationRemoteDisconnect = false
  applicationRemoteFailure = void
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
    applicationRemoteConfigChanged = appuicommands.takeConfigDirty(
      applicationRemoteCommands) or
      applicationRemoteInput.capturedKey >= 0
    if applicationRemoteConfigChanged then
      applicationRemoteConfigSave = try(appuiconfig.saveProductConfig(
        applicationRemoteConfigPath, appuiconfig.captureProductConfig(
          applicationRemoteInput, applicationRemoteCommands,
          applicationRemoteMixer, applicationRemoteScreen)))
      if applicationRemoteConfigSave is error then
        appuiconsole.appendLine(applicationRemoteScreen.console,
          "Config save failed: " + applicationRemoteConfigSave.message,
          appbyteio.truncInt(applicationRemoteStarted))
      end if
      applicationRemoteInput.capturedKey = -1
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
      applicationRemoteCommandTime
    applicationRemoteNetworkResult = void
    if appclientsession.movementDue(applicationRemoteCommandTime,
        applicationRemoteStarted) then
      if applicationRemoteNetworkMsec > 200 then applicationRemoteNetworkMsec = 200 end if
      applicationRemoteCommand = appuiinput.createSampledUserCmd(
        applicationRemoteInput, appbyteio.truncInt(applicationRemoteNetworkMsec))
      appclientsession.setUserCmd(applicationRemoteSession,
        applicationRemoteCommand)
      applicationRemoteNetworkResult = try(appclientsession.step(
        applicationRemoteSession))
      applicationRemoteCommandTime = applicationRemoteStarted
    else
      applicationRemoteNetworkResult = try(appclientsession.poll(
        applicationRemoteSession))
    end if
    if applicationRemoteNetworkResult is error then
      applicationRemoteFailure = applicationRemoteNetworkResult
      applicationRemoteDisconnect = true
      continue
    end if
    applicationRemoteReceivedFrame = applicationRemoteSession.integrated.client.current
    if applicationRemoteReceivedFrame is not void and
        applicationRemoteReceivedFrame.number != applicationRemoteObservedFrame then
      applicationRemoteObservedFrame = applicationRemoteReceivedFrame.number
      applicationRemoteNetworkTime = applicationRemoteStarted
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
    if applicationRemoteDownloads.complete and
        applicationRemoteNextMapPath != "" and
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
      if applicationRemotePredict is error then
        applicationRemoteFailure = applicationRemotePredict
        applicationRemoteDisconnect = true
        continue
      end if
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
      appeffecthandoff.applyPrepared(applicationRemoteSession.integrated.effects,
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
  if applicationRemoteFailure is not void then
    return applicationRemoteFailure
  end if
  return [applicationRemoteFrames, applicationRemoteDisconnect,
    applicationRemoteCommands.quitRequested, applicationRemoteMapPath]
end function

// Run remote product smoke.
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

// Run product.
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
  applicationPersistentAttract = void
  if frameLimit == 0 then
    applicationPersistentAttract = try(runStockAttractLoopOnHost(
      baseDirectory, applicationPersistentHost))
    if applicationPersistentAttract is error then
      applicationPersistentAttractClose = try(
        appproducthost.closeProductHost(applicationPersistentHost))
      return applicationPersistentAttract
    end if
    if applicationPersistentAttract[1] == "quit" or
        applicationPersistentAttract[1] == "closed" then
      applicationPersistentDone = true
    end if
  end if
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
        // A failure after BeginFrame must not be hidden by Shutdown's
        // frame-open contract error.  Finish the incomplete presentation only
        // for lifecycle unwinding, then preserve the original failure.
        if applicationPersistentHost.renderer.state.core.state.frameOpen then
          applicationPersistentConnectEndFrame = try(
            applicationPersistentHost.renderer.exports.EndFrame())
        end if
        applicationPersistentConnectClose = try(
          appproducthost.closeProductHost(applicationPersistentHost))
        return applicationPersistentConnect
      end if
      applicationPersistentRuns = applicationPersistentRuns + 1
      applicationPersistentGameplayFrames = applicationPersistentGameplayFrames +
        applicationPersistentConnect[0]
      if applicationPersistentConnect[2] then applicationPersistentDone = true end if
      continue
    end if
    if applicationPersistentSelection.action == "local" then
      applicationPersistentNewGame = appmediaseq.parse(
        appmediaseq.stockNewGameSpecification())
      applicationPersistentIntro = try(runRetailCinematicOnHost(
        baseDirectory, applicationPersistentNewGame.steps[0].name,
        0, false, applicationPersistentHost, false))
      if applicationPersistentIntro is error then
        if applicationPersistentHost.renderer.state.core.state.frameOpen then
          applicationPersistentIntroEndFrame = try(
            applicationPersistentHost.renderer.exports.EndFrame())
        end if
        applicationPersistentIntroClose = try(
          appproducthost.closeProductHost(applicationPersistentHost))
        return applicationPersistentIntro
      end if
      if applicationPersistentIntro[7] or
          applicationPersistentHost.window.closed then
        applicationPersistentDone = true
        continue
      end if
      applicationPersistentSelection.mapName = applicationPersistentNewGame.steps[1].name
    end if
    applicationPersistentServerOptions = void
    if applicationPersistentSelection.action == "server" then
      applicationPersistentServerOptions = applicationPersistentSelection.serverOptions
    end if
    applicationPersistentPlayResult = try(runPlayAtOnHostConfiguredWithConfig(
      baseDirectory, applicationPersistentSelection.mapName, "", 0,
      applicationPersistentHost, applicationPersistentSelection.skill,
      false, applicationPersistentServerOptions,
      applicationPersistentProfile,
      applicationPersistentSelection.productConfig))
    if applicationPersistentPlayResult is error then
      if applicationPersistentHost.renderer.state.core.state.frameOpen then
        applicationPersistentPlayEndFrame = try(
          applicationPersistentHost.renderer.exports.EndFrame())
      end if
      applicationPersistentPlayClose = try(
        appproducthost.closeProductHost(applicationPersistentHost))
      return applicationPersistentPlayResult
    end if
    applicationPersistentRuns = applicationPersistentRuns + 1
    applicationPersistentGameplayFrames = applicationPersistentGameplayFrames +
      applicationPersistentPlayResult[0]
    if len(applicationPersistentPlayResult) >= 49 then
      applicationPersistentProfile = applicationPersistentPlayResult[48]
    end if
    if len(applicationPersistentPlayResult) >= 50 and
        applicationPersistentPlayResult[44] != "" then
      applicationPersistentMediaResult = try(runRetailMediaSequenceOnHostWithState(
        baseDirectory, applicationPersistentPlayResult[44], 0,
        applicationPersistentHost, applicationPersistentPlayResult[45],
        applicationPersistentPlayResult[47], applicationPersistentPlayResult[48],
        applicationPersistentPlayResult[49]))
      if applicationPersistentMediaResult is error then
        if applicationPersistentHost.renderer.state.core.state.frameOpen then
          applicationPersistentMediaEndFrame = try(
            applicationPersistentHost.renderer.exports.EndFrame())
        end if
        applicationPersistentMediaClose = try(
          appproducthost.closeProductHost(applicationPersistentHost))
        return applicationPersistentMediaResult
      end if
      applicationPersistentRuns = applicationPersistentRuns +
        applicationPersistentMediaResult[3]
      applicationPersistentGameplayFrames = applicationPersistentGameplayFrames +
        applicationPersistentMediaResult[7]
      if applicationPersistentMediaResult[6] is not void then
        applicationPersistentPlayResult = applicationPersistentMediaResult[6]
      end if
      if len(applicationPersistentMediaResult) >= 10 then
        applicationPersistentProfile = applicationPersistentMediaResult[9]
      end if
    end if
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

// Run dedicated.
function runDedicated(baseDirectory, mapName, port, frameLimit)
  session = appsession.createRetail(baseDirectory, mapName, "0.0.0.0", port, 4, true)
  print "MiniQuake2 dedicated server listening: " + session.socket.address + ":" + session.socket.port
  print "  map=" + mapName + " protocol=34 maxclients=4"
  frames = appsession.run(session, frameLimit)
  appsession.shutdown(session)
  return [frames, session.packetsReceived, session.packetsSent, session.packetsRejected]
end function

// Run headless client.
function runHeadlessClient(address, port, frameLimit)
  session = appclientsession.create(address, port, "\\name\\MiniQuake2\\skin\\male/grunt\\rate\\25000", 0)
  print "MiniQuake2 Protocol-34 client connecting: " + address + ":" + port
  frames = appclientsession.run(session, frameLimit)
  state = session.integrated.network.client.state
  parsed = session.integrated.parsedPackets
  appclientsession.shutdown(session)
  return [frames, state, parsed, session.packetsReceived, session.packetsSent, session.packetsRejected]
end function

// Run listen.
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
