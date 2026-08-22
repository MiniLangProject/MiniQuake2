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
import miniquake2.client.state as appclientstate
import miniquake2.client.effects.handoff as appeffecthandoff
import miniquake2.client.cinematic.audio as appcinaudio
import miniquake2.client.cinematic.player as appcinplayer
import miniquake2.client.cinematic.picture as appcinpicture
import miniquake2.runtime.play_session as appplay
import miniquake2.runtime.session_persistence as apppersistence
import miniquake2.runtime.media_sequence as appmediaseq
import miniquake2.runtime.client_assets as appclientassets
import miniquake2.client.assets.registry as appassetregistry
import miniquake2.physics.vector as appphysicsvector

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

previewFileSystem = void
playAssetState = void
playClientRuntime = void

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
  if mixer is not void then appaudiomixer.stopAll(mixer) end if
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

// Product CIN lifecycle: retail FS -> Huffman frames/palette -> OpenGL raw
// stretch, with the CIN PCM stream feeding the same managed mixer/device used
// by gameplay. Escape opens/closes the existing menu and pauses/resumes both
// video time and its mixer channel without losing the current frame.
function runRetailCinematic(baseDirectory, name, frameLimit, looping)
  global previewFileSystem
  if typeof(baseDirectory) != "string" or baseDirectory == "" then return error(9922, "cinematic requires the Quake II install root") end if
  if typeof(frameLimit) != "int" or frameLimit < 0 or frameLimit > 36000 then return error(9923, "cinematic frame limit outside [0,36000]") end if
  if typeof(looping) != "bool" then return error(9924, "cinematic looping flag must be boolean") end if
  applicationCinematicFileSystemHolder = appfs.initialize(baseDirectory, "")
  previewFileSystem = applicationCinematicFileSystemHolder
  applicationCinematicPathHolder = cinematicPath(name)
  applicationCinematicDataHolder = appfs.readFile(applicationCinematicFileSystemHolder, applicationCinematicPathHolder)

  applicationCinematicWindowHolder = appwindow.create("MiniQuake2 Cinematic - " + name, 640, 480, false)
  applicationCinematicRendererHolder = appgl.createOpenGlRenderer(true)
  applicationCinematicRendererHolder.exports.Init(void, void)
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
  applicationCinematicRendererHolder.exports.Shutdown()
  appwindow.destroy(applicationCinematicWindowHolder)
  previewFileSystem = void
  return [applicationCinematicFrames, applicationCinematicStatus,
    applicationCinematicStreamFrame, applicationCinematicCompletions,
    applicationCinematicDropped, applicationCinematicPainted,
    applicationCinematicDeviceOpened]
end function

// Static intermission counterpart to runCinematic. Space/Enter emits the
// classic nextserver intent; Escape opens the same menu/quit lifecycle.
function runRetailPicture(baseDirectory, name, frameLimit)
  global previewFileSystem
  if typeof(baseDirectory) != "string" or baseDirectory == "" then return error(9927, "picture requires the Quake II install root") end if
  if typeof(frameLimit) != "int" or frameLimit < 0 or frameLimit > 36000 then return error(9928, "picture frame limit outside [0,36000]") end if
  applicationPictureFileSystemHolder = appfs.initialize(baseDirectory, "")
  previewFileSystem = applicationPictureFileSystemHolder
  applicationPicturePathHolder = picturePath(name)
  applicationPicturePlaybackHolder = appcinpicture.start(appfs.readFile(
    applicationPictureFileSystemHolder, applicationPicturePathHolder))
  applicationPictureWindowHolder = appwindow.create("MiniQuake2 Picture - " + name,
    640, 480, false)
  applicationPictureRendererHolder = appgl.createOpenGlRenderer(true)
  applicationPictureRendererHolder.exports.Init(void, void)
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
  applicationPictureRendererHolder.exports.Shutdown()
  appwindow.destroy(applicationPictureWindowHolder)
  previewFileSystem = void
  return [applicationPictureFrames, applicationPictureStatus,
    applicationPictureWidth, applicationPictureHeight, applicationPictureAdvanced]
end function

// Execute the exact classic `map first+nextserver` media chain. A positive
// frame limit is a deterministic preview gate per step; zero retains normal
// interactive behavior (CIN to completion, PCX until Space/Enter, map until
// window close). DM2 is parsed but remains an explicit unsupported boundary.
function runRetailMediaSequence(baseDirectory, specification, frameLimit)
  if typeof(frameLimit) != "int" or frameLimit < 0 or frameLimit > 36000 then
    return error(9929, "media sequence frame limit outside [0,36000]")
  end if
  applicationMediaSequenceHolder = appmediaseq.parse(specification)
  applicationMediaCinematics = 0
  applicationMediaPictures = 0
  applicationMediaMaps = 0
  applicationMediaCompleted = 0
  applicationMediaIndex = 0
  while applicationMediaIndex < len(applicationMediaSequenceHolder.steps)
    applicationMediaStepHolder = applicationMediaSequenceHolder.steps[applicationMediaIndex]
    if applicationMediaStepHolder.kind == appmediaseq.MEDIA_CIN then
      applicationMediaCinematicResult = runRetailCinematic(baseDirectory,
        applicationMediaStepHolder.name, frameLimit, false)
      applicationMediaCinematics = applicationMediaCinematics + 1
      if frameLimit == 0 and applicationMediaCinematicResult[1] != "completed" then
        return [applicationMediaCompleted, applicationMediaCinematics,
          applicationMediaPictures, applicationMediaMaps, "aborted"]
      end if
    else if applicationMediaStepHolder.kind == appmediaseq.MEDIA_PCX then
      applicationMediaPictureResult = runRetailPicture(baseDirectory,
        applicationMediaStepHolder.name, frameLimit)
      applicationMediaPictures = applicationMediaPictures + 1
      if frameLimit == 0 and not applicationMediaPictureResult[4] and
          applicationMediaIndex + 1 < len(applicationMediaSequenceHolder.steps) then
        return [applicationMediaCompleted, applicationMediaCinematics,
          applicationMediaPictures, applicationMediaMaps, "aborted"]
      end if
    else if applicationMediaStepHolder.kind == appmediaseq.MEDIA_MAP then
      runPlayAt(baseDirectory, applicationMediaStepHolder.name,
        applicationMediaStepHolder.spawnPoint, frameLimit)
      applicationMediaMaps = applicationMediaMaps + 1
    else
      return error(9930, "DM2 playback is not implemented in the product media sequence")
    end if
    applicationMediaCompleted = applicationMediaCompleted + 1
    applicationMediaIndex = applicationMediaIndex + 1
  end while
  return [applicationMediaCompleted, applicationMediaCinematics,
    applicationMediaPictures, applicationMediaMaps, "completed"]
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

function runPlayAt(baseDirectory, mapName, spawnPoint, frameLimit)
  global previewFileSystem, playAssetState, playClientRuntime
  if frameLimit < 0 or frameLimit > 36000 then return error(9913, "play frame limit outside [0,36000]") end if
  filesystem = appfs.initialize(baseDirectory, "")
  previewFileSystem = filesystem
  path = mapPath(mapName)
  map = appbsp.parse(appfs.readFile(filesystem, path), path)
  session = appplay.createCoreAt(mapName, map.entityText, appcollision.create(map), spawnPoint,
    "\\name\\MiniQuake2\\skin\\male/grunt\\rate\\25000")
  appplay.runUntilActive(session, 256)

  window = appwindow.create("MiniQuake2 - " + mapName, 1280, 720, false)
  renderer = appgl.getRefAPI(applicationRendererImports(), true)
  renderer.exports.Init(void, void)
  renderer.exports.BeginRegistration(path)
  appgl.adoptClassicMapModel(renderer, map, path)
  world = appgl.prepareClassicWorld(renderer, map, loadPreviewFile, apprtypes.defaultLightStyles(), 0, 1.0)
  assetState = appclientassets.createForRenderer(renderer.exports, loadPlaySound, noteMissingPlayAsset)
  playAssetState = assetState
  playClientRuntime = session.client.integrated.client
  appclientassets.registerConfigStrings(assetState,
    session.client.integrated.network.configStrings, mapName)
  renderer.exports.EndRegistration()

  audioMixer = appaudiomixer.create(44100)
  appaudiomixer.setMasterVolume(audioMixer, 0.7)
  audioResult = try(appaudiodevice.open(44100, 2, 16))
  audioDevice = void
  if audioResult is not error then audioDevice = audioResult end if

  input = appuikeys.createInputState()
  playerState = session.client.integrated.client.current.playerState
  input.viewAngles = [playerState.viewAngles[0], playerState.viewAngles[1], playerState.viewAngles[2]]
  appuikeys.bind(input, 119, "+forward")
  appuikeys.bind(input, 115, "+back")
  appuikeys.bind(input, 97, "+moveleft")
  appuikeys.bind(input, 100, "+moveright")
  appuikeys.bind(input, appuiconstants.K_SPACE, "+moveup")
  appuikeys.bind(input, 99, "+movedown")
  appuikeys.bind(input, appuiconstants.K_SHIFT, "+speed")
  appuikeys.bind(input, appuiconstants.K_MOUSE1, "+attack")
  appuikeys.bind(input, 101, "+use")
  appuikeys.bind(input, 105, "inven")
  screen = appuiscreen.create(appuiconsole.create(80), appuimenu.create())
  commandState = appuicommands.create()
  saveCheckpoints = array(3)
  appwindow.setMouseCapture(true)
  clock = appsystem.createClock()
  networkTime = appsystem.milliseconds(clock)
  frames = 0
  latest = void
  lastWorldStats = void
  applicationPendingMediaSpecification = ""
  while (frameLimit == 0 or frames < frameLimit) and not commandState.quitRequested and
      applicationPendingMediaSpecification == "" and
      appwindow.poll(window)
    started = appsystem.milliseconds(clock)
    appuicontroller.poll(input, screen, started)
    appwindow.setMouseCapture(input.destination == appuiconstants.KEY_GAME)
    appuicommands.drain(commandState, input, screen, audioMixer)
    applicationForwardedCommands = appuicommands.takeForwarded(commandState)
    for each applicationForwardedCommand in applicationForwardedCommands
      applicationForwardedResult = try(appclientsession.sendStringCommand(session.client,
        applicationForwardedCommand, appbyteio.truncInt(started)))
    end for
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
        appuiconsole.appendLine(screen.console, "Saved slot " + (applicationSaveSlot + 1),
          appbyteio.truncInt(started))
      end if
    end if
    applicationLoadSlot = appuicommands.takeLoadSlot(commandState)
    if applicationLoadSlot >= 0 then
      applicationLoadCheckpoint = saveCheckpoints[applicationLoadSlot]
      if applicationLoadCheckpoint is void then
        appuiconsole.appendLine(screen.console, "No in-session save in slot " +
          (applicationLoadSlot + 1), appbyteio.truncInt(started))
      else
        applicationLoadResult = try(apppersistence.restorePlaySession(session,
          applicationLoadCheckpoint))
        if applicationLoadResult is error then
          appuiconsole.appendLine(screen.console, "Load failed: " + applicationLoadResult.message,
            appbyteio.truncInt(started))
        else
          appuiconsole.appendLine(screen.console, "Loaded slot " + (applicationLoadSlot + 1),
            appbyteio.truncInt(started))
          screen.menu.active = false
          appuikeys.setDestination(input, appuiconstants.KEY_GAME)
        end if
      end if
    end if
    if commandState.videoRestartRequested then
      appuiconsole.appendLine(screen.console,
        "Video mode changes are staged for the next window creation.",
        appbyteio.truncInt(started))
      commandState.videoRestartRequested = false
    end if
    networkMsec = started - networkTime
    if networkMsec >= 100 then
      if networkMsec > 200 then networkMsec = 200 end if
      command = appuiinput.createUserCmd(input, appbyteio.truncInt(networkMsec))
      appplay.setUserCmd(session, command)
      stepResult = appplay.step(session)
      latest = stepResult.handoff
      applyPlayHandoff(screen, latest)
      applicationPendingMediaSpecification = appmediaseq.takeQueuedGameMap(
        session.server.bridgeRuntime.commands)
      networkTime = started
    end if

    fraction = (started - networkTime) / 100.0
    if fraction < 0.0 then fraction = 0.0 end if
    if fraction > 1.0 then fraction = 1.0 end if
    frame = appclientstate.buildRefDef(session.client.integrated.client, fraction,
      window.width, window.height, resolvePlayModelIndex)
    if audioDevice is not void then
      viewAxes = appphysicsvector.angleVectors(frame.viewAngles)
      appclientassets.attachMixer(assetState, session.client.integrated.effects,
        audioMixer, resolvePlayEntityPosition, frame.viewOrigin, viewAxes[1])
    end if
    // Effects are timestamped by the ClientSession clock while packets are
    // dispatched.  Keep advances on that same monotonic epoch; the render
    // clock above intentionally starts only after signon has completed.
    effectNow = appbyteio.truncInt(appsystem.milliseconds(session.client.clock))
    appeffecthandoff.apply(session.client.integrated.effects, frame, effectNow, resolvePlayEffectModel)
    renderer.exports.BeginFrame(0.0)
    renderer.exports.RenderFrame(frame)
    lastWorldStats = appgl.submitClassicWorld(renderer, world, frame)
    appuiscreen.draw(screen, started, window.width, window.height,
      session.client.integrated.client.current.playerState.stats,
      session.client.integrated.network.configStrings, renderer.exports)
    renderer.exports.EndFrame()
    pumpPlayAudio(audioDevice, audioMixer)
    frames = frames + 1
    elapsed = appsystem.milliseconds(clock) - started
    if elapsed < 8 then appsystem.sleep(appbyteio.truncInt(8 - elapsed)) end if
  end while

  appwindow.setMouseCapture(false)
  closePlayAudio(audioDevice, audioMixer)
  appgl.releaseClassicWorld(renderer, world)
  renderer.exports.Shutdown()
  appwindow.destroy(window)
  clientState = session.client.integrated.network.client.state
  serverFrame = session.server.frameNumber
  registeredModels = countAvailableAssets(assetState.modelEntries)
  registeredSounds = countAvailableAssets(assetState.soundEntries)
  missingAssets = len(appclientassets.missingAssets(assetState))
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
  playClientRuntime = void
  if applicationPendingMediaSpecification != "" then
    runRetailMediaSequence(baseDirectory, applicationPendingMediaSpecification, frameLimit)
  end if
  return [frames, clientState, serverFrame, registeredModels,
    registeredSounds, missingAssets, submittedEntities,
    visibleSurfaces, culledSurfaces, viewCluster]
end function

function runPlay(baseDirectory, mapName, frameLimit)
  return runPlayAt(baseDirectory, mapName, "", frameLimit)
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
