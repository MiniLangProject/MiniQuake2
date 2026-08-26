/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Traversal-safe CL_RequestNextDownload / CL_ParseDownload workflow. Chunks are
streamed to a resumable temporary file and renamed only after a complete
transfer, avoiding both corrupt visible assets and quadratic byte-array copies.
*/
package miniquake2.client.downloads

import std.fs as cdlfs
import miniquake2.qcommon.constants as cdlqc
import miniquake2.qcommon.filesystem as cdlqfs
import miniquake2.qcommon.byteio as cdlbio
import miniquake2.qcommon.checksum as cdlchecksum
import miniquake2.format.md2 as cdlmd2
import miniquake2.format.bsp as cdlbsp

const MAX_DOWNLOAD_REQUESTS = 4096
const MAX_DOWNLOAD_COMMANDS = 16
const MAX_DOWNLOAD_MISSING = 1024
const MAX_DOWNLOAD_FILE_BYTES = 0x7fffffff
const GENERIC_WRITE = 0x40000000
const FILE_SHARE_READ = 1
const OPEN_ALWAYS = 4
const FILE_ATTRIBUTE_NORMAL = 0x80
const FILE_END = 2
const INVALID_HANDLE_VALUE = -1
const INVALID_SET_FILE_POINTER = 0xffffffff

extern function CreateDirectoryW(path as wstr, security as ptr) from "kernel32.dll" returns bool
extern function CreateFileW(path as wstr, access as int, share as int,
  security as ptr, creation as int, flags as int, template as ptr) from "kernel32.dll" returns ptr
extern function SetFilePointer(handle as ptr, distance as int, high as ptr,
  method as int) from "kernel32.dll" returns u32
extern function WriteFile(handle as ptr, data as bytes, count as int,
  written as bytes, overlapped as ptr) from "kernel32.dll" returns bool
extern function FlushFileBuffers(handle as ptr) from "kernel32.dll" returns bool
extern function CloseHandle(handle as ptr) from "kernel32.dll" returns bool

struct DownloadPolicy
  allowDownloads
  allowMaps
  allowModels
  allowSounds
  allowImages
  allowPlayers
end struct

struct DownloadRequest
  kind
  name
end struct

struct DownloadManager
  baseDirectory
  gameDirectory
  policy
  fileExists
  readFile
  registerAsset
  requests
  requestCount
  requestIndex
  current
  finalPath
  temporaryPath
  offset
  percent
  retryCount
  awaitingChunk
  spawnCount
  expectedMapChecksum
  commands
  commandCount
  missing
  missingCount
  completedCount
  complete
end struct

function defaultPolicy()
  return DownloadPolicy(true, true, true, true, true, true)
end function

// Original menu/cvars expose no separate image switch: pics follow the global
// allow_download value. Keep this adapter as the single product/UI mapping.
function classicPolicy(allow, maps, models, players, sounds)
  return DownloadPolicy(allow, maps, models, sounds, allow, players)
end function

function ignoreRegister(kind, name)
  return true
end function

function validateGameDirectory(name)
  if typeof(name) != "string" or name == "" then return cdlqc.BASEDIRNAME end if
  if name == "." or name == ".." then return error(7680, "download game directory is unsafe") end if
  source = bytes(name)
  if len(source) >= cdlqc.MAX_QPATH then return error(7680, "download game directory exceeds limit") end if
  for each character in source
    if character < 32 or character == 47 or
        character == 58 or character == 92 then
      return error(7680, "download game directory is unsafe")
    end if
  end for
  return name
end function

function create(baseDirectory, gameDirectory, policy, fileExists, readFile,
    registerAsset)
  if typeof(baseDirectory) != "string" or baseDirectory == "" or
      typeof(fileExists) != "function" or typeof(readFile) != "function" then
    return error(7681, "download manager callbacks or root are missing")
  end if
  if policy is void then policy = defaultPolicy() end if
  if typeof(policy) != "struct" then return error(7682, "download policy is malformed") end if
  gameDirectory = try(validateGameDirectory(gameDirectory))
  if gameDirectory is error then return gameDirectory end if
  if registerAsset is void then registerAsset = ignoreRegister end if
  if typeof(registerAsset) != "function" then return error(7683, "download registration callback is malformed") end if
  return DownloadManager(baseDirectory, gameDirectory, policy, fileExists,
    readFile, registerAsset, array(MAX_DOWNLOAD_REQUESTS, void), 0, 0, void,
    "", "", 0, 0, 0, false, 0, void, array(MAX_DOWNLOAD_COMMANDS, ""), 0,
    array(MAX_DOWNLOAD_MISSING, ""), 0, 0, false)
end function

function setGameDirectory(manager, gameDirectory)
  validated = try(validateGameDirectory(gameDirectory))
  if validated is error then return validated end if
  if manager.awaitingChunk then
    return error(7683, "cannot change game directory during download")
  end if
  manager.gameDirectory = validated
  return true
end function

function reset(manager)
  manager.requests = array(MAX_DOWNLOAD_REQUESTS, void)
  manager.requestCount = 0; manager.requestIndex = 0; manager.current = void
  manager.finalPath = ""; manager.temporaryPath = ""; manager.offset = 0
  manager.percent = 0; manager.retryCount = 0; manager.awaitingChunk = false
  manager.expectedMapChecksum = void
  manager.commands = array(MAX_DOWNLOAD_COMMANDS, ""); manager.commandCount = 0
  manager.missing = array(MAX_DOWNLOAD_MISSING, ""); manager.missingCount = 0
  manager.completedCount = 0; manager.complete = false
  return true
end function

function cancel(manager)
  manager.current = void; manager.awaitingChunk = false
  manager.commandCount = 0; manager.complete = false
  return true
end function

function policyAllows(policy, kind)
  if not policy.allowDownloads then return false end if
  if kind == "map" or kind == "sky" or kind == "texture" then return policy.allowMaps end if
  if kind == "model" or kind == "model-skin" then return policy.allowModels end if
  if kind == "sound" then return policy.allowSounds end if
  if kind == "image" then return policy.allowImages end if
  if kind == "player" then return policy.allowPlayers end if
  return false
end function

function addRequest(manager, kind, requestedName)
  if not policyAllows(manager.policy, kind) then return false end if
  canonical = try(cdlqfs.canonicalVirtualName(requestedName))
  if canonical is error or len(bytes(canonical)) >= cdlqc.MAX_OSPATH then
    return error(7684, "unsafe download request: " + requestedName)
  end if
  index = 0
  while index < manager.requestCount
    if manager.requests[index].name == canonical then return false end if
    index = index + 1
  end while
  if manager.requestCount >= MAX_DOWNLOAD_REQUESTS then
    return error(7685, "download precache plan exceeds limit")
  end if
  manager.requests[manager.requestCount] = DownloadRequest(kind, canonical)
  manager.requestCount = manager.requestCount + 1
  return true
end function

function queueCommand(manager, command)
  if manager.commandCount >= MAX_DOWNLOAD_COMMANDS then
    return error(7686, "download command queue overflow")
  end if
  manager.commands[manager.commandCount] = command
  manager.commandCount = manager.commandCount + 1
  return true
end function

function takeCommands(manager)
  output = array(manager.commandCount, "")
  index = 0
  while index < manager.commandCount
    output[index] = manager.commands[index]
    index = index + 1
  end while
  manager.commandCount = 0
  return output
end function

function noteMissing(manager, name)
  if manager.missingCount < MAX_DOWNLOAD_MISSING then
    manager.missing[manager.missingCount] = name
    manager.missingCount = manager.missingCount + 1
  end if
  return true
end function

function missingFiles(manager)
  output = array(manager.missingCount, "")
  index = 0
  while index < manager.missingCount
    output[index] = manager.missing[index]
    index = index + 1
  end while
  return output
end function

function persistenceRoot(manager, name)
  directory = manager.gameDirectory
  if len(bytes(name)) >= 8 and decode(slice(bytes(name), 0, 8)) == "players/" then
    directory = cdlqc.BASEDIRNAME
  end if
  return cdlfs.joinPath(manager.baseDirectory, directory)
end function

function persistentPath(manager, name)
  return cdlfs.joinPath(persistenceRoot(manager, name), name)
end function

// COM_StripExtension(downloadname) + ".tmp". Matching the retail temporary
// name preserves resume compatibility with interrupted original-client
// downloads while the final rename still occurs inside the same directory.
function temporaryPath(finalPath)
  source = bytes(finalPath); separator = -1; extension = -1; index = 0
  while index < len(source)
    if source[index] == 47 or source[index] == 92 then
      separator = index; extension = -1
    else if source[index] == 46 then extension = index
    end if
    index = index + 1
  end while
  if extension > separator then
    return textSlice(finalPath, 0, extension) + ".tmp"
  end if
  return finalPath + ".tmp"
end function

function ensureParentDirectory(path)
  source = bytes(path)
  index = 0
  while index < len(source)
    if source[index] == 47 or source[index] == 92 then
      if index > 2 then
        prefix = decode(slice(source, 0, index))
        if not cdlfs.isDir(prefix) then
          ignored = CreateDirectoryW(prefix, 0)
          if not cdlfs.isDir(prefix) then
            return error(7687, "failed to create download directory")
          end if
        end if
      end if
    end if
    index = index + 1
  end while
  return true
end function

function appendChunk(path, data)
  parent = try(ensureParentDirectory(path))
  if parent is error then return parent end if
  handle = CreateFileW(path, GENERIC_WRITE, FILE_SHARE_READ, 0, OPEN_ALWAYS,
    FILE_ATTRIBUTE_NORMAL, 0)
  if handle == INVALID_HANDLE_VALUE then return error(7688, "failed to open download temporary file") end if
  position = SetFilePointer(handle, 0, 0, FILE_END)
  if position == INVALID_SET_FILE_POINTER then
    CloseHandle(handle)
    return error(7689, "failed to seek download temporary file")
  end if
  written = bytes(4)
  ok = WriteFile(handle, data, len(data), written, 0)
  if ok then ok = cdlbio.u32(written, 0) == len(data) end if
  if ok then ok = FlushFileBuffers(handle) end if
  CloseHandle(handle)
  if not ok then return error(7689, "failed to append download chunk") end if
  return true
end function

function textSlice(value, start, count)
  if count <= 0 then return "" end if
  return decode(slice(bytes(value), start, count))
end function

function playerIdentity(value)
  if typeof(value) != "string" or value == "" then return void end if
  source = bytes(value); identityStart = 0; slash = -1
  index = 0
  while index < len(source)
    if source[index] == 92 then identityStart = index + 1 end if
    index = index + 1
  end while
  index = identityStart
  while index < len(source) and slash < 0
    if source[index] == 47 or source[index] == 92 then slash = index end if
    index = index + 1
  end while
  if slash <= identityStart or slash + 1 >= len(source) then return void end if
  model = textSlice(value, identityStart, slash - identityStart)
  skin = textSlice(value, slash + 1, len(source) - slash - 1)
  probe = try(cdlqfs.canonicalVirtualName("players/" + model + "/" + skin + ".pcx"))
  if probe is error then return void end if
  return [model, skin]
end function

function buildPrecachePlan(manager, configStrings)
  if typeof(configStrings) != "array" or len(configStrings) < cdlqc.MAX_CONFIGSTRINGS then
    return error(7690, "download precache configstrings are incomplete")
  end if
  reset(manager)
  checksumText = configStrings[cdlqc.CS_MAPCHECKSUM]
  if checksumText != "" then
    expected = try(toNumber(checksumText))
    if expected is error or typeof(expected) != "int" then
      return error(7690, "download map checksum is malformed")
    end if
    if expected < 0 then expected = expected + 4294967296 end if
    if expected < 0 or expected > 0xffffffff then
      return error(7690, "download map checksum is outside u32 range")
    end if
    manager.expectedMapChecksum = expected
  end if
  mapName = configStrings[cdlqc.CS_MODELS + 1]
  if mapName != "" then addRequest(manager, "map", mapName) end if
  index = 2
  while index < cdlqc.MAX_MODELS
    name = configStrings[cdlqc.CS_MODELS + index]
    if name != "" and bytes(name)[0] != 42 and bytes(name)[0] != 35 then
      addRequest(manager, "model", name)
    end if
    index = index + 1
  end while
  index = 1
  while index < cdlqc.MAX_SOUNDS
    name = configStrings[cdlqc.CS_SOUNDS + index]
    if name != "" and bytes(name)[0] != 42 then
      addRequest(manager, "sound", "sound/" + name)
    end if
    index = index + 1
  end while
  index = 1
  while index < cdlqc.MAX_IMAGES
    name = configStrings[cdlqc.CS_IMAGES + index]
    if name != "" then addRequest(manager, "image", "pics/" + name + ".pcx") end if
    index = index + 1
  end while
  index = 0
  while index < cdlqc.MAX_CLIENTS
    identity = playerIdentity(configStrings[cdlqc.CS_PLAYERSKINS + index])
    if identity is not void then
      model = identity[0]; skin = identity[1]
      addRequest(manager, "player", "players/" + model + "/tris.md2")
      addRequest(manager, "player", "players/" + model + "/weapon.md2")
      addRequest(manager, "player", "players/" + model + "/weapon.pcx")
      addRequest(manager, "player", "players/" + model + "/" + skin + ".pcx")
      addRequest(manager, "player", "players/" + model + "/" + skin + "_i.pcx")
    end if
    index = index + 1
  end while
  sky = configStrings[cdlqc.CS_SKY]
  if sky != "" then
    suffixes = ["rt", "bk", "lf", "ft", "up", "dn"]
    for each suffix in suffixes
      addRequest(manager, "sky", "env/" + sky + suffix + ".tga")
      addRequest(manager, "sky", "env/" + sky + suffix + ".pcx")
    end for
  end if
  return manager.requestCount
end function

function discoverDependencies(manager, request)
  data = try(manager.readFile(request.name))
  if data is error or typeof(data) != "bytes" then return false end if
  if request.kind == "model" then
    model = try(cdlmd2.parse(data, request.name))
    if model is error then return false end if
    for each skin in model.skins
      addRequest(manager, "model-skin", skin)
    end for
    return true
  end if
  if request.kind == "map" then
    if manager.expectedMapChecksum is not void and
        cdlchecksum.blockChecksum(data, 0, len(data)) !=
        manager.expectedMapChecksum then
      return error(7698, "local map checksum differs from server")
    end if
    map = try(cdlbsp.parse(data, request.name))
    if map is error then return false end if
    for each info in map.texInfo
      if info.texture != "" then
        addRequest(manager, "texture", "textures/" + info.texture + ".wal")
      end if
    end for
    return true
  end if
  return false
end function

function advance(manager)
  manager.current = void; manager.awaitingChunk = false
  while manager.requestIndex < manager.requestCount
    request = manager.requests[manager.requestIndex]
    exists = try(manager.fileExists(request.name))
    if exists is not error and exists then
      discovered = try(discoverDependencies(manager, request))
      if discovered is error then return discovered end if
      manager.requestIndex = manager.requestIndex + 1
      continue
    end if
    manager.current = request
    manager.finalPath = persistentPath(manager, request.name)
    manager.temporaryPath = temporaryPath(manager.finalPath)
    parent = try(ensureParentDirectory(manager.temporaryPath))
    if parent is error then return parent end if
    manager.offset = 0
    if cdlfs.isFile(manager.temporaryPath) then
      size = try(cdlfs.fileSize(manager.temporaryPath))
      if size is not error and size >= 0 and size <= MAX_DOWNLOAD_FILE_BYTES then
        manager.offset = size
      end if
    end if
    manager.percent = 0; manager.retryCount = 0; manager.awaitingChunk = true
    command = "download " + request.name
    if manager.offset > 0 then command = command + " " + manager.offset end if
    queueCommand(manager, command)
    return request
  end while
  manager.current = void
  registered = try(manager.registerAsset("precache", ""))
  if registered is error then return registered end if
  manager.complete = true
  queueCommand(manager, "begin " + manager.spawnCount)
  return void
end function

function beginPrecache(manager, configStrings, spawnCount)
  if typeof(spawnCount) != "int" or spawnCount < 0 then
    return error(7691, "download precache spawn count is invalid")
  end if
  planned = try(buildPrecachePlan(manager, configStrings))
  if planned is error then return planned end if
  manager.spawnCount = spawnCount
  return advance(manager)
end function

function requestFile(manager, kind, name, spawnCount)
  reset(manager); manager.spawnCount = spawnCount
  added = try(addRequest(manager, kind, name))
  if added is error then return added end if
  return advance(manager)
end function

function finishCurrent(manager)
  if not cdlfs.isFile(manager.temporaryPath) then
    emptyWritten = try(appendChunk(manager.temporaryPath, bytes()))
    if emptyWritten is error then return emptyWritten end if
  end if
  if manager.current.kind == "map" and manager.expectedMapChecksum is not void then
    temporaryData = cdlfs.readAllBytes(manager.temporaryPath)
    if cdlchecksum.blockChecksum(temporaryData, 0, len(temporaryData)) !=
        manager.expectedMapChecksum then
      cdlfs.delete(manager.temporaryPath)
      return error(7698, "downloaded map checksum differs from server")
    end if
  end if
  if cdlfs.isFile(manager.finalPath) then
    cdlfs.delete(manager.temporaryPath)
  else
    moved = cdlfs.moveFile(manager.temporaryPath, manager.finalPath, false)
    if moved is error or moved == false then return error(7692, "download atomic rename failed") end if
  end if
  registered = try(manager.registerAsset(manager.current.kind,
    manager.current.name))
  if registered is error then return registered end if
  manager.completedCount = manager.completedCount + 1
  discovered = try(discoverDependencies(manager, manager.current))
  if discovered is error then return discovered end if
  manager.requestIndex = manager.requestIndex + 1
  manager.awaitingChunk = false; manager.current = void
  return advance(manager)
end function

function acceptChunk(manager, data, percent, missing)
  if not manager.awaitingChunk or manager.current is void then
    return error(7693, "unsolicited download chunk")
  end if
  if typeof(percent) != "int" or percent < 0 or percent > 100 or
      typeof(missing) != "bool" or typeof(data) != "bytes" then
    return error(7694, "download chunk metadata is invalid")
  end if
  if missing then
    if manager.offset > 0 and manager.retryCount == 0 then
      cdlfs.delete(manager.temporaryPath)
      manager.offset = 0; manager.percent = 0; manager.retryCount = 1
      queueCommand(manager, "download " + manager.current.name)
      return manager.current
    end if
    noteMissing(manager, manager.current.name)
    manager.requestIndex = manager.requestIndex + 1
    manager.awaitingChunk = false; manager.current = void
    return advance(manager)
  end if
  if percent < manager.percent then return error(7695, "download percent regressed") end if
  if manager.offset > MAX_DOWNLOAD_FILE_BYTES - len(data) then
    return error(7696, "download exceeds file size limit")
  end if
  appended = try(appendChunk(manager.temporaryPath, data))
  if appended is error then return appended end if
  manager.offset = manager.offset + len(data); manager.percent = percent
  if percent < 100 then
    queueCommand(manager, "nextdl")
    return manager.current
  end if
  return finishCurrent(manager)
end function
