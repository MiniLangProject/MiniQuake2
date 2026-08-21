/* Quake II PAK and loose-file search paths with traversal-safe virtual names. */
package miniquake2.qcommon.filesystem

import miniquake2.qcommon.types as qt
import miniquake2.qcommon.byteio as bio
import miniquake2.qcommon.text as text
import std.fs as fs

const MAX_FILES_IN_PACK = 4096
const BASE_DIRECTORY_NAME = "baseq2"

function virtualNameValid(name)
  return try(canonicalVirtualName(name)) is not error
end function

function normalizeVirtualName(name)
  data = bytes(text.lower(name))
  i = 0
  while i < len(data)
    if data[i] == 92 then data[i] = 47 end if
    i = i + 1
  end while
  return decode(data)
end function

// Resolve dot segments inside the virtual root. Historical retail PAKs contain
// names such as models/monsters/tank/../ctank/skin.pcx; they are safe once
// canonicalized, while attempts to walk above the virtual root remain errors.
function canonicalVirtualName(name)
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

function parsePack(data, filename)
  if len(data) < 12 then return error(3230, filename + ": PACK header truncated") end if
  if bio.u32(data, 0) != 0x4b434150 then return error(3231, filename + ": PACK ident mismatch") end if
  directoryOffset = bio.i32(data, 4)
  directoryLength = bio.i32(data, 8)
  if directoryOffset < 0 or directoryLength < 0 or directoryLength % 64 != 0 or directoryOffset > len(data) or directoryLength > len(data) - directoryOffset then return error(3232, filename + ": invalid PACK directory") end if
  count = directoryLength / 64
  if count > MAX_FILES_IN_PACK then return error(3233, filename + ": too many PACK files") end if
  files = array(count)
  i = 0
  while i < count
    at = directoryOffset + i * 64
    name = try(canonicalVirtualName(text.fixedString(data, at, 56)))
    offset = bio.i32(data, at + 56)
    length = bio.i32(data, at + 60)
    if name is error or offset < 0 or length < 0 or offset > len(data) or length > len(data) - offset then return error(3234, filename + ": invalid PACK entry") end if
    files[i] = qt.PackFile(name, offset, length)
    i = i + 1
  end while
  return qt.PackArchive(filename, data, files)
end function

function loadPack(filename)
  return parsePack(fs.readAllBytes(filename), filename)
end function

function findPackFile(pack, name)
  wanted = try(canonicalVirtualName(name))
  if wanted is error then return void end if
  for each entry in pack.files
    if entry.name == wanted then return entry end if
  end for
  return void
end function

function create(baseDirectory, gameDirectory)
  return qt.FileSystem(baseDirectory, gameDirectory, [], [])
end function

function addDirectory(system, directory)
  system.searchPaths = [qt.SearchPath(directory, void)] + system.searchPaths
  return true
end function

function addPack(system, filename)
  pack = loadPack(filename)
  system.searchPaths = [qt.SearchPath("", pack)] + system.searchPaths
  return pack
end function

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

function initialize(baseDirectory, gameDirectory)
  system = create(baseDirectory, gameDirectory)
  addGameDirectory(system, fs.joinPath(baseDirectory, BASE_DIRECTORY_NAME))
  if gameDirectory != "" and text.equalInsensitive(gameDirectory, BASE_DIRECTORY_NAME) == false then addGameDirectory(system, fs.joinPath(baseDirectory, gameDirectory)) end if
  return system
end function

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

function fileExists(system, name)
  result = try(readFile(system, name))
  return result is not error
end function
