//! Provides miniquake2 qcommon filesystem facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Quake II PAK and loose-file search paths with traversal-safe virtual names. */
package miniquake2.qcommon.filesystem

import miniquake2.qcommon.types as qt
import miniquake2.qcommon.byteio as bio
import miniquake2.qcommon.text as text
import std.fs as fs

/// Defines the max files in pack constant used by the miniquake2 qcommon filesystem module.
const MAX_FILES_IN_PACK = 4096
/// Defines the pack lookup size constant used by the miniquake2 qcommon filesystem module.
const PACK_LOOKUP_SIZE = 8192
/// Defines the base directory name constant used by the miniquake2 qcommon filesystem module.
const BASE_DIRECTORY_NAME = "baseq2"

/// Invokes the native CreateFileW entry point used by the miniquake2 qcommon filesystem module.
/// @param path Path of the file or directory used by the operation.
/// @param access access value consumed by this operation.
/// @param share share value consumed by this operation.
/// @param security security value consumed by this operation.
/// @param creation creation value consumed by this operation.
/// @param flags Bit flags controlling the operation.
/// @param template template value consumed by this operation.
/// @returns Native ptr result produced by the call.
extern function CreateFileW(path as wstr, access as int, share as int,
  security as ptr, creation as int, flags as int,
  template as ptr) from "kernel32.dll" returns ptr
/// Invokes the native GetFileSizeEx entry point used by the miniquake2 qcommon filesystem module.
/// @param handle Native or runtime handle used by the operation.
/// @param size Size in the units required by the operation.
/// @returns Native bool result produced by the call.
extern function GetFileSizeEx(handle as ptr,
  size as bytes) from "kernel32.dll" returns bool
/// Invokes the native ReadFile entry point used by the miniquake2 qcommon filesystem module.
/// @param handle Native or runtime handle used by the operation.
/// @param buffer Buffer that receives or supplies the operation data.
/// @param count Number of items or units to process.
/// @param bytesRead bytesRead value consumed by this operation.
/// @param overlapped overlapped value consumed by this operation.
/// @returns Native bool result produced by the call.
extern function ReadFile(handle as ptr, buffer as bytes, count as int,
  bytesRead as bytes, overlapped as ptr) from "kernel32.dll" returns bool
/// Invokes the native CloseHandle entry point used by the miniquake2 qcommon filesystem module.
/// @param handle Native or runtime handle used by the operation.
/// @returns Native bool result produced by the call.
extern function CloseHandle(handle as ptr) from "kernel32.dll" returns bool

/// Return the deterministic open-addressing slot for a canonical PAK name.
/// @param name Name of the affected item.
function inline packLookupSlot(name)
  source = bytes(name)
  hash = 2166136261
  index = 0
  while index < len(source)
    hash = ((hash ^ source[index]) * 16777619) & 0x7fffffff
    index = index + 1
  end while
  return hash & (PACK_LOOKUP_SIZE - 1)
end function

/// Report whether virtual name valid.
/// @param name Name of the affected item.
function virtualNameValid(name)
  return try(canonicalVirtualName(name)) is not error
end function

/// Normalize virtual name.
/// @param name Name of the affected item.
function normalizeVirtualName(name)
  data = bytes(text.lower(name))
  i = 0
  while i < len(data)
    if data[i] == 92 then data[i] = 47 end if
    i = i + 1
  end while
  return decode(data)
end function

/// Resolve dot segments inside the virtual root. Historical retail PAKs contain
/// names such as models/monsters/tank/../ctank/skin.pcx; they are safe once
/// canonicalized, while attempts to walk above the virtual root remain errors.
/// @param name Name of the affected item.
function canonicalVirtualName(name)
  // Keep canonical virtual name phases explicit: validate inputs, update owned state, then publish the result.
  normalized = normalizeVirtualName(name)
  data = bytes(normalized)
  if len(data) == 0 or data[0] == 47 then return error(3237, "invalid virtual path") end if
  i = 0
  while i < len(data)
    if data[i] == 0 or data[i] == 58 then return error(3237, "invalid virtual path") end if
    i = i + 1
  end while
  output = bytes(len(data))
  segmentStarts = array(len(data) + 1)
  segmentCount = 0
  outputCount = 0
  start = 0
  i = 0
  while i <= len(data)
    if i == len(data) or data[i] == 47 then
      count = i - start
      if count > 0 then
        parent = count == 2 and data[start] == 46 and data[start + 1] == 46
        current = count == 1 and data[start] == 46
        if parent then
          if segmentCount == 0 then return error(3237, "virtual path escapes root") end if
          segmentCount = segmentCount - 1
          outputCount = segmentStarts[segmentCount]
        else if current == false then
          segmentStarts[segmentCount] = outputCount
          if outputCount > 0 then output[outputCount] = 47; outputCount = outputCount + 1 end if
          copyBytes(output, outputCount, data, start, count)
          outputCount = outputCount + count
          segmentCount = segmentCount + 1
        end if
      end if
      start = i + 1
    end if
    i = i + 1
  end while
  if segmentCount == 0 then return error(3237, "invalid virtual path") end if
  return decode(slice(output, 0, outputCount))
end function

/// Parse pack.
/// @param data Input data consumed by the operation.
/// @param filename filename value consumed by this operation.
function parsePack(data, filename)
  if len(data) < 12 then return error(3230, filename + ": PACK header truncated") end if
  if bio.u32(data, 0) != 0x4b434150 then return error(3231, filename + ": PACK ident mismatch") end if
  directoryOffset = bio.i32(data, 4)
  directoryLength = bio.i32(data, 8)
  if directoryOffset < 0 or directoryLength < 0 or directoryLength % 64 != 0 or directoryOffset > len(data) or directoryLength > len(data) - directoryOffset then return error(3232, filename + ": invalid PACK directory") end if
  count = directoryLength / 64
  if count > MAX_FILES_IN_PACK then return error(3233, filename + ": too many PACK files") end if
  files = array(count)
  lookup = array(PACK_LOOKUP_SIZE, -1)
  i = 0
  while i < count
    at = directoryOffset + i * 64
    name = try(canonicalVirtualName(text.fixedString(data, at, 56)))
    offset = bio.i32(data, at + 56)
    length = bio.i32(data, at + 60)
    if name is error or offset < 0 or length < 0 or offset > len(data) or length > len(data) - offset then return error(3234, filename + ": invalid PACK entry") end if
    files[i] = qt.PackFile(name, offset, length)
    slot = packLookupSlot(name)
    probes = 0
    while lookup[slot] >= 0 and probes < PACK_LOOKUP_SIZE
      slot = (slot + 1) & (PACK_LOOKUP_SIZE - 1)
      probes = probes + 1
    end while
    if probes >= PACK_LOOKUP_SIZE then return error(3233, filename + ": PACK lookup table exhausted") end if
    lookup[slot] = i
    i = i + 1
  end while
  return qt.PackArchive(filename, data, files, lookup)
end function

/// Load pack.
/// @param filename filename value consumed by this operation.
function loadPack(filename)
  // PAKs are the largest startup reads (pak0 is roughly 184 MB). std.fs uses
  // a deliberately conservative 4-KiB streaming buffer, which is appropriate
  // for general files but makes this known local, bounded archive pay tens of
  // thousands of MiniLang loop iterations and copies. Read the validated PAK
  // into its final backing array in one native operation instead.
  handle = CreateFileW(filename, fs.Access.GENERIC_READ,
    fs.Share.FILE_SHARE_READ, 0, fs.Creation.OPEN_EXISTING,
    fs.FileAttr.FILE_ATTRIBUTE_NORMAL, 0)
  if handle == fs.INVALID_HANDLE_VALUE then
    return error(3230, filename + ": PACK open failed")
  end if
  sizeBytes = bytes(8)
  if not GetFileSizeEx(handle, sizeBytes) then
    CloseHandle(handle)
    return error(3230, filename + ": PACK size failed")
  end if
  size = bio.u32(sizeBytes, 0)
  if bio.u32(sizeBytes, 4) != 0 or size > 0x7fffffff then
    CloseHandle(handle)
    return error(3230, filename + ": PACK is too large")
  end if
  data = bytes(size)
  bytesRead = bytes(4)
  readResult = true
  if size > 0 then readResult = ReadFile(handle, data, size, bytesRead, 0) end if
  CloseHandle(handle)
  if not readResult or bio.u32(bytesRead, 0) != size then
    return error(3230, filename + ": PACK read was incomplete")
  end if
  return parsePack(data, filename)
end function

/// Find pack file.
/// @param pack pack value consumed by this operation.
/// @param name Name of the affected item.
function findPackFile(pack, name)
  wanted = try(canonicalVirtualName(name))
  if wanted is error then return void end if
  slot = packLookupSlot(wanted)
  probes = 0
  while probes < len(pack.lookup)
    entryIndex = pack.lookup[slot]
    if entryIndex < 0 then return void end if
    entry = pack.files[entryIndex]
    if entry.name == wanted then return entry end if
    slot = (slot + 1) & (len(pack.lookup) - 1)
    probes = probes + 1
  end while
  return void
end function

/// Creates create for the miniquake2 qcommon filesystem module.
/// @param baseDirectory baseDirectory value consumed by this operation.
/// @param gameDirectory gameDirectory value consumed by this operation.
function create(baseDirectory, gameDirectory)
  return qt.FileSystem(baseDirectory, gameDirectory, [], [])
end function

/// Add directory.
/// @param system system value consumed by this operation.
/// @param directory directory value consumed by this operation.
function addDirectory(system, directory)
  system.searchPaths = [qt.SearchPath(directory, void)] + system.searchPaths
  return true
end function

/// Add pack.
/// @param system system value consumed by this operation.
/// @param filename filename value consumed by this operation.
function addPack(system, filename)
  pack = loadPack(filename)
  system.searchPaths = [qt.SearchPath("", pack)] + system.searchPaths
  return pack
end function

/// Add game directory.
/// @param system system value consumed by this operation.
/// @param directory directory value consumed by this operation.
function addGameDirectory(system, directory)
  addDirectory(system, directory)
  i = 0
  while i < 100
    filename = fs.joinPath(directory, "pak" + i + ".pak")
    if fs.exists(filename) == false then break end if
    addPack(system, filename)
    i = i + 1
  end while
  return i
end function

/// Performs the initialize operation for the miniquake2 qcommon filesystem module.
/// @param baseDirectory baseDirectory value consumed by this operation.
/// @param gameDirectory gameDirectory value consumed by this operation.
function initialize(baseDirectory, gameDirectory)
  system = create(baseDirectory, gameDirectory)
  addGameDirectory(system, fs.joinPath(baseDirectory, BASE_DIRECTORY_NAME))
  if gameDirectory != "" and text.equalInsensitive(gameDirectory, BASE_DIRECTORY_NAME) == false then addGameDirectory(system, fs.joinPath(baseDirectory, gameDirectory)) end if
  return system
end function

/// Read file.
/// @param system system value consumed by this operation.
/// @param name Name of the affected item.
function readFile(system, name)
  normalized = try(canonicalVirtualName(name))
  if normalized is error then return error(3235, "invalid virtual path") end if
  for each searchPath in system.searchPaths
    if searchPath.pack is not void then
      entry = findPackFile(searchPath.pack, normalized)
      if entry is not void then return slice(searchPath.pack.data, entry.offset, entry.length) end if
    else
      path = fs.joinPath(searchPath.directory, normalized)
      if fs.isFile(path) then return fs.readAllBytes(path) end if
    end if
  end for
  return error(3236, "file not found: " + name)
end function

/// Return the file exists value.
/// @param system system value consumed by this operation.
/// @param name Name of the affected item.
function fileExists(system, name)
  result = try(readFile(system, name))
  return result is not error
end function

/// Return the music track name.
/// @param track track value consumed by this operation.
function musicTrackName(track)
  if typeof(track) != "int" or track < 1 or track > 99 then
    return error(3238, "music track outside [1,99]")
  end if
  number = "" + track
  if track < 10 then number = "0" + number end if
  return "track" + number + ".ogg"
end function

/// Prefer loose files so the native Vorbis bridge owns compressed retail data
/// without retaining a multi-megabyte MiniLang byte array for the whole level.
/// The 2023 Steam release stores the original soundtrack below
/// rerelease/baseq2/music while classic source ports commonly use
/// baseq2/music. PAK-contained replacements remain available through readFile.
/// @param system system value consumed by this operation.
/// @param track track value consumed by this operation.
function musicTrackPath(system, track)
  filename = musicTrackName(track)
  gameDirectory = system.gameDirectory
  if gameDirectory == "" then gameDirectory = BASE_DIRECTORY_NAME end if
  classic = fs.joinPath(fs.joinPath(fs.joinPath(system.baseDirectory,
    gameDirectory), "music"), filename)
  if fs.isFile(classic) then return classic end if
  rerelease = fs.joinPath(fs.joinPath(fs.joinPath(fs.joinPath(
    system.baseDirectory, "rerelease"), gameDirectory), "music"), filename)
  if fs.isFile(rerelease) then return rerelease end if
  return ""
end function

/// Read music track.
/// @param system system value consumed by this operation.
/// @param track track value consumed by this operation.
function readMusicTrack(system, track)
  filename = musicTrackName(track)
  packed = try(readFile(system, "music/" + filename))
  if packed is not error then return packed end if
  path = musicTrackPath(system, track)
  if path != "" then return fs.readAllBytes(path) end if
  return error(3239, "music/" + filename + " not found below baseq2 or rerelease/baseq2")
end function
