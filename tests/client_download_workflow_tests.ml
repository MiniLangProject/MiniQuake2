/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Staged, resumable and atomic Protocol-34 client download workflow. */
import std.fs as cdwtfs
import miniquake2.qcommon.constants as cdwtqc
import miniquake2.client.downloads as cdwtdownloads
import miniquake2.network.client as cdwtnclient
import miniquake2.network.runtime.types as cdwtnrtypes
import miniquake2.client.effects.state as cdwteffects
import miniquake2.client.state as cdwtstate
import miniquake2.client.runtime.dispatcher as cdwtdispatcher
import miniquake2.qcommon.checksum as cdwtchecksum

extern function RemoveDirectoryW(path as wstr) from "kernel32.dll" returns bool
import miniquake2.qcommon.byteio as cdwtbyteio
import miniquake2.format.constants as cdwtformat

downloadTestRoot = "build\\client_download_workflow"
downloadRegistered = array(32, "")
downloadRegisteredCount = 0

// Verify download path.
function downloadTestPath(name)
  return cdwtfs.joinPath(cdwtfs.joinPath(downloadTestRoot,
    cdwtqc.BASEDIRNAME), name)
end function

// Verify download exists.
function downloadTestExists(name)
  return cdwtfs.isFile(downloadTestPath(name))
end function

// Verify download read.
function downloadTestRead(name)
  return cdwtfs.readAllBytes(downloadTestPath(name))
end function

// Verify download register.
function downloadTestRegister(kind, name)
  global downloadRegisteredCount
  if downloadRegisteredCount < len(downloadRegistered) then
    downloadRegistered[downloadRegisteredCount] = kind + ":" + name
    downloadRegisteredCount = downloadRegisteredCount + 1
  end if
  return true
end function

// Reject download precache.
function downloadRejectPrecache(kind, name)
  if kind == "precache" then return error(7699, "registration rejected") end if
  return true
end function

// Assert the download test condition.
function downloadAssert(value, name)
  if not value then return error(7697, name) end if
  return true
end function

// Report whether download plan contains.
function downloadPlanContains(manager, kind, name)
  index = 0
  while index < manager.requestCount
    request = manager.requests[index]
    if request.kind == kind and request.name == name then return true end if
    index = index + 1
  end while
  return false
end function

// Write download text.
function downloadPutText(data, offset, value)
  encoded = bytes(value)
  copyBytes(data, offset, encoded, 0, len(encoded))
  return true
end function

// Return the download dependency md 2 value.
function downloadDependencyMd2()
  data = bytes(192)
  cdwtbyteio.putU32(data, 0, cdwtformat.IDALIASHEADER)
  cdwtbyteio.putI32(data, 4, cdwtformat.ALIAS_VERSION)
  cdwtbyteio.putI32(data, 8, 64); cdwtbyteio.putI32(data, 12, 64)
  cdwtbyteio.putI32(data, 16, 44)
  cdwtbyteio.putI32(data, 20, 1); cdwtbyteio.putI32(data, 24, 1)
  cdwtbyteio.putI32(data, 28, 1); cdwtbyteio.putI32(data, 32, 1)
  cdwtbyteio.putI32(data, 36, 0); cdwtbyteio.putI32(data, 40, 1)
  cdwtbyteio.putI32(data, 44, 68); cdwtbyteio.putI32(data, 48, 132)
  cdwtbyteio.putI32(data, 52, 136); cdwtbyteio.putI32(data, 56, 148)
  cdwtbyteio.putI32(data, 60, 192); cdwtbyteio.putI32(data, 64, 192)
  downloadPutText(data, 68, "models/dependency/skin.pcx")
  cdwtbyteio.putF32(data, 148, 1.0); cdwtbyteio.putF32(data, 152, 1.0)
  cdwtbyteio.putF32(data, 156, 1.0)
  downloadPutText(data, 172, "idle01")
  return data
end function

// Return the download dependency exists value.
function downloadDependencyExists(name)
  return name == "models/dependency/tris.md2"
end function

// Read download dependency.
function downloadDependencyRead(name)
  if name == "models/dependency/tris.md2" then return downloadDependencyMd2() end if
  return error(7699, "dependency fixture missing")
end function

configStrings = array(cdwtqc.MAX_CONFIGSTRINGS, "")
configStrings[cdwtqc.CS_MODELS + 1] = "maps/unit.bsp"
configStrings[cdwtqc.CS_MODELS + 2] = "models/unit/tris.md2"
configStrings[cdwtqc.CS_SOUNDS + 1] = "unit/test.wav"
configStrings[cdwtqc.CS_IMAGES + 1] = "unit_icon"
configStrings[cdwtqc.CS_PLAYERSKINS] = "Player\\female/athena"
configStrings[cdwtqc.CS_SKY] = "unit_"
manager = cdwtdownloads.create(downloadTestRoot, cdwtqc.BASEDIRNAME,
  cdwtdownloads.defaultPolicy(), downloadTestExists, downloadTestRead,
  downloadTestRegister)
count = cdwtdownloads.buildPrecachePlan(manager, configStrings)
mappedPolicy = cdwtdownloads.classicPolicy(true, true, false, true, false)
downloadAssert(mappedPolicy.allowImages and mappedPolicy.allowPlayers and
  not mappedPolicy.allowModels and not mappedPolicy.allowSounds,
  "classic five-cvar policy mapping")
downloadAssert(count == 21, "precache stage request count")
downloadAssert(downloadPlanContains(manager, "map", "maps/unit.bsp"),
  "map stage")
downloadAssert(downloadPlanContains(manager, "model", "models/unit/tris.md2"),
  "model stage")
downloadAssert(downloadPlanContains(manager, "sound", "sound/unit/test.wav"),
  "sound stage")
downloadAssert(downloadPlanContains(manager, "image", "pics/unit_icon.pcx"),
  "image stage")
downloadAssert(downloadPlanContains(manager, "player",
  "players/female/athena_i.pcx"), "player stage")
downloadAssert(downloadPlanContains(manager, "sky", "env/unit_rt.tga"),
  "sky stage")
unsafe = try(cdwtdownloads.addRequest(manager, "map", "../escape.bsp"))
downloadAssert(unsafe is error, "traversal request rejected")

modelsOnly = cdwtdownloads.DownloadPolicy(true, false, true, false, false, false)
dependencyManager = cdwtdownloads.create(downloadTestRoot,
  cdwtqc.BASEDIRNAME, modelsOnly, downloadDependencyExists,
  downloadDependencyRead, downloadTestRegister)
cdwtdownloads.requestFile(dependencyManager, "model",
  "models/dependency/tris.md2", 5)
dependencyCommands = cdwtdownloads.takeCommands(dependencyManager)
downloadAssert(dependencyManager.requestCount == 2 and
  dependencyManager.current.kind == "model-skin" and
  dependencyCommands == ["download models/dependency/skin.pcx"],
  "MD2 skin dependency is staged before begin")

mapPath = downloadTestPath("maps/streamed.bsp")
tempPath = cdwtdownloads.temporaryPath(mapPath)
cdwtfs.delete(mapPath); cdwtfs.delete(tempPath)
mapsOnly = cdwtdownloads.DownloadPolicy(true, true, false, false, false, false)
stream = cdwtdownloads.create(downloadTestRoot, cdwtqc.BASEDIRNAME, mapsOnly,
  downloadTestExists, downloadTestRead, downloadTestRegister)
cdwtdownloads.requestFile(stream, "map", "maps/streamed.bsp", 42)
commands = cdwtdownloads.takeCommands(stream)
downloadAssert(len(commands) == 1 and commands[0] ==
  "download maps/streamed.bsp", "initial download command")
cdwtdownloads.acceptChunk(stream, bytes([1, 2, 3]), 50, false)
downloadAssert(not cdwtfs.isFile(mapPath) and cdwtfs.isFile(tempPath),
  "partial asset remains temporary")
commands = cdwtdownloads.takeCommands(stream)
downloadAssert(len(commands) == 1 and commands[0] == "nextdl",
  "next block request")
cdwtdownloads.acceptChunk(stream, bytes([4, 5]), 100, false)
downloadAssert(cdwtfs.readAllBytes(mapPath) == bytes([1, 2, 3, 4, 5]) and
  not cdwtfs.exists(tempPath), "complete asset atomically published")
commands = cdwtdownloads.takeCommands(stream)
downloadAssert(len(commands) == 1 and commands[0] == "begin 42" and
  stream.complete and stream.completedCount == 1,
  "completed manual queue begins spawn")

resumePath = downloadTestPath("maps/resume.bsp")
resumeTemp = cdwtdownloads.temporaryPath(resumePath)
cdwtfs.delete(resumePath); cdwtfs.delete(resumeTemp)
// Reuse the workflow's directory hierarchy created by the streamed file.
cdwtfs.writeAllBytes(resumeTemp, bytes([9, 8]))
resume = cdwtdownloads.create(downloadTestRoot, cdwtqc.BASEDIRNAME, mapsOnly,
  downloadTestExists, downloadTestRead, downloadTestRegister)
cdwtdownloads.requestFile(resume, "map", "maps/resume.bsp", 7)
commands = cdwtdownloads.takeCommands(resume)
downloadAssert(commands[0] == "download maps/resume.bsp 2",
  "partial file resume offset")
cdwtdownloads.acceptChunk(resume, bytes(), 0, true)
commands = cdwtdownloads.takeCommands(resume)
downloadAssert(commands[0] == "download maps/resume.bsp" and
  not cdwtfs.exists(resumeTemp), "resume rejection retries from zero")
cdwtdownloads.acceptChunk(resume, bytes([7, 6, 5]), 100, false)
downloadAssert(cdwtfs.readAllBytes(resumePath) == bytes([7, 6, 5]),
  "retry payload persisted without stale prefix")

soundOnly = cdwtdownloads.DownloadPolicy(true, false, false, true, false, false)
missing = cdwtdownloads.create(downloadTestRoot, cdwtqc.BASEDIRNAME, soundOnly,
  downloadTestExists, downloadTestRead, downloadTestRegister)
cdwtdownloads.requestFile(missing, "sound", "sound/unit/missing.wav", 9)
cdwtdownloads.takeCommands(missing)
cdwtdownloads.acceptChunk(missing, bytes(), 0, true)
downloadAssert(cdwtdownloads.missingFiles(missing) ==
  ["sound/unit/missing.wav"] and missing.complete,
  "missing asset recorded and stage advances")
downloadAssert(downloadRegisteredCount >= 3,
  "asset and final precache registration callbacks")

registrationFailure = cdwtdownloads.create(downloadTestRoot,
  cdwtqc.BASEDIRNAME,
  cdwtdownloads.DownloadPolicy(false, false, false, false, false, false),
  downloadTestExists, downloadTestRead, downloadRejectPrecache)
registrationFailureResult = try(cdwtdownloads.requestFile(
  registrationFailure, "map", "maps/not-requested.bsp", 10))
downloadAssert(registrationFailureResult is error and
  not registrationFailure.complete and
  len(cdwtdownloads.takeCommands(registrationFailure)) == 0,
  "failed final registration cannot publish completion or begin")

dispatchPath = downloadTestPath("maps/dispatch.bsp")
cdwtfs.delete(dispatchPath); cdwtfs.delete(cdwtdownloads.temporaryPath(dispatchPath))
dispatchManager = cdwtdownloads.create(downloadTestRoot, cdwtqc.BASEDIRNAME,
  mapsOnly, downloadTestExists, downloadTestRead, downloadTestRegister)
cdwtdownloads.requestFile(dispatchManager, "map", "maps/dispatch.bsp", 11)
cdwtdownloads.takeCommands(dispatchManager)
network = cdwtnrtypes.createClient(cdwtnclient.create(4, 5000))
integrated = cdwtdispatcher.create(network, cdwtstate.create(),
  cdwteffects.createSilent(1))
cdwtdispatcher.setDownloadManager(integrated, dispatchManager)
dispatchResult = cdwtdispatcher.dispatch(integrated,
  bytes([cdwtqc.SVC_DOWNLOAD, 3, 0, 100, 21, 22, 23]), 1, 10)
downloadAssert(dispatchResult.accepted and
  cdwtfs.readAllBytes(dispatchPath) == bytes([21, 22, 23]) and
  len(integrated.network.downloadData) == 0,
  "dispatcher streams validated download exactly once")

checksumPath = downloadTestPath("maps/checksum.bsp")
checksumTemp = cdwtdownloads.temporaryPath(checksumPath)
cdwtfs.delete(checksumPath); cdwtfs.delete(checksumTemp)
checksumConfig = array(cdwtqc.MAX_CONFIGSTRINGS, "")
checksumConfig[cdwtqc.CS_MODELS + 1] = "maps/checksum.bsp"
checksumConfig[cdwtqc.CS_MAPCHECKSUM] = (cdwtchecksum.blockChecksum(
  bytes([31, 32]), 0, 2) + 1) + ""
checksumManager = cdwtdownloads.create(downloadTestRoot, cdwtqc.BASEDIRNAME,
  mapsOnly, downloadTestExists, downloadTestRead, downloadTestRegister)
cdwtdownloads.beginPrecache(checksumManager, checksumConfig, 1)
cdwtdownloads.takeCommands(checksumManager)
checksumFailure = try(cdwtdownloads.acceptChunk(checksumManager,
  bytes([31, 32]), 100, false))
downloadAssert(checksumFailure is error and not cdwtfs.exists(checksumPath) and
  not cdwtfs.exists(checksumTemp),
  "server map checksum gates atomic publication")

// Build hygiene: downloaded fixtures are proprietary-looking by extension
// and must never survive the test run inside a baseq2 tree.
cdwtfs.delete(mapPath)
cdwtfs.delete(resumePath)
cdwtfs.delete(dispatchPath)
RemoveDirectoryW(downloadTestRoot + "\\baseq2\\maps")
RemoveDirectoryW(downloadTestRoot + "\\baseq2")
RemoveDirectoryW(downloadTestRoot)

print("client_download_workflow_tests: PASS")
