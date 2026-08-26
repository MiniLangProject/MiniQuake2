/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Classic SV_Map level-string parser for map/CIN/PCX/DM2 sequences. */
package miniquake2.runtime.media_sequence

import miniquake2.qcommon.constants as mediaseqqc
import miniquake2.qcommon.cmd as mediaseqcmd
import miniquake2.qcommon.text as mediaseqtext

const MEDIA_MAP = 0
const MEDIA_CIN = 1
const MEDIA_PCX = 2
const MEDIA_DM2 = 3
const MAX_MEDIA_STEPS = 16

struct MediaStep
  kind
  name
  spawnPoint
  endOfUnit
end struct

struct MediaSequence
  specification
  steps
end struct

function endsWithInsensitive(value, suffix)
  mediaseqValue = bytes(mediaseqtext.lower(value))
  mediaseqSuffix = bytes(mediaseqtext.lower(suffix))
  if len(mediaseqSuffix) > len(mediaseqValue) then return false end if
  mediaseqOffset = len(mediaseqValue) - len(mediaseqSuffix)
  mediaseqIndex = 0
  while mediaseqIndex < len(mediaseqSuffix)
    if mediaseqValue[mediaseqOffset + mediaseqIndex] != mediaseqSuffix[mediaseqIndex] then return false end if
    mediaseqIndex = mediaseqIndex + 1
  end while
  return true
end function

function safeName(value, operation)
  if typeof(value) != "string" or value == "" or len(bytes(value)) >= mediaseqqc.MAX_QPATH then
    return error(8490, operation + " name is empty or exceeds MAX_QPATH")
  end if
  mediaseqNameBytes = bytes(value)
  mediaseqNameIndex = 0
  while mediaseqNameIndex < len(mediaseqNameBytes)
    mediaseqCharacter = mediaseqNameBytes[mediaseqNameIndex]
    if mediaseqCharacter == 0 or mediaseqCharacter == 43 or mediaseqCharacter == 36 or
        mediaseqCharacter == 47 or mediaseqCharacter == 92 or mediaseqCharacter == 58 then
      return error(8491, operation + " name contains an unsafe separator")
    end if
    if mediaseqCharacter == 46 and mediaseqNameIndex + 1 < len(mediaseqNameBytes) and
        mediaseqNameBytes[mediaseqNameIndex + 1] == 46 then
      return error(8491, operation + " name contains traversal")
    end if
    mediaseqNameIndex = mediaseqNameIndex + 1
  end while
  return value
end function

function parseStep(component)
  if typeof(component) != "string" or component == "" then return error(8492, "empty media sequence step") end if
  mediaseqComponentBytes = bytes(component)
  mediaseqDollar = -1
  mediaseqComponentIndex = 0
  while mediaseqComponentIndex < len(mediaseqComponentBytes)
    if mediaseqComponentBytes[mediaseqComponentIndex] == 36 then
      if mediaseqDollar >= 0 then return error(8493, "media step contains multiple spawn separators") end if
      mediaseqDollar = mediaseqComponentIndex
    end if
    mediaseqComponentIndex = mediaseqComponentIndex + 1
  end while
  mediaseqLevel = component
  mediaseqSpawn = ""
  if mediaseqDollar >= 0 then
    mediaseqLevel = decode(slice(mediaseqComponentBytes, 0, mediaseqDollar))
    mediaseqSpawn = decode(slice(mediaseqComponentBytes, mediaseqDollar + 1,
      len(mediaseqComponentBytes) - mediaseqDollar - 1))
    safeName(mediaseqSpawn, "spawn point")
  end if

  mediaseqEndOfUnit = false
  mediaseqLevelBytes = bytes(mediaseqLevel)
  if len(mediaseqLevelBytes) > 0 and mediaseqLevelBytes[0] == 42 then
    mediaseqEndOfUnit = true
    mediaseqLevel = decode(slice(mediaseqLevelBytes, 1, len(mediaseqLevelBytes) - 1))
  end if
  safeName(mediaseqLevel, "level")
  mediaseqKind = MEDIA_MAP
  if endsWithInsensitive(mediaseqLevel, ".cin") then mediaseqKind = MEDIA_CIN
  else if endsWithInsensitive(mediaseqLevel, ".pcx") then mediaseqKind = MEDIA_PCX
  else if endsWithInsensitive(mediaseqLevel, ".dm2") then mediaseqKind = MEDIA_DM2 end if
  if mediaseqKind != MEDIA_MAP and (mediaseqSpawn != "" or mediaseqEndOfUnit) then
    return error(8494, "media step cannot carry a spawn point or end-of-unit flag")
  end if
  return MediaStep(mediaseqKind, mediaseqLevel, mediaseqSpawn, mediaseqEndOfUnit)
end function

function parse(specification)
  if typeof(specification) != "string" or specification == "" or
      len(bytes(specification)) >= mediaseqqc.MAX_STRING_CHARS then
    return error(8495, "media sequence specification is invalid")
  end if
  mediaseqSpecificationBytes = bytes(specification)
  mediaseqSteps = []
  mediaseqStart = 0
  mediaseqScan = 0
  while mediaseqScan <= len(mediaseqSpecificationBytes)
    if mediaseqScan == len(mediaseqSpecificationBytes) or
        mediaseqSpecificationBytes[mediaseqScan] == 43 then
      if mediaseqScan == mediaseqStart then return error(8492, "empty media sequence step") end if
      mediaseqComponent = decode(slice(mediaseqSpecificationBytes,
        mediaseqStart, mediaseqScan - mediaseqStart))
      mediaseqSteps = mediaseqSteps + [parseStep(mediaseqComponent)]
      if len(mediaseqSteps) > MAX_MEDIA_STEPS then return error(8496, "media sequence has too many steps") end if
      mediaseqStart = mediaseqScan + 1
    end if
    mediaseqScan = mediaseqScan + 1
  end while
  return MediaSequence(specification, mediaseqSteps)
end function

function kindName(kind)
  if kind == MEDIA_MAP then return "map" end if
  if kind == MEDIA_CIN then return "cin" end if
  if kind == MEDIA_PCX then return "pcx" end if
  if kind == MEDIA_DM2 then return "dm2" end if
  return error(8497, "unknown media step kind")
end function

// The game module queues `gamemap "spec"` through AddCommandString after
// intermission exit. Validate the complete first command before removing it;
// unrelated server-console work remains untouched for its own policy layer.
function takeQueuedGameMap(commandSystem)
  if commandSystem is void or typeof(commandSystem.buffer) != "string" then
    return error(8498, "server command buffer is invalid")
  end if
  if commandSystem.buffer == "" then return "" end if
  mediaseqQueuedParts = mediaseqcmd.splitFirst(commandSystem.buffer)
  mediaseqQueuedArguments = mediaseqcmd.tokenize(mediaseqQueuedParts[0])
  if len(mediaseqQueuedArguments) == 0 then
    commandSystem.buffer = mediaseqQueuedParts[1]
    return ""
  end if
  if not mediaseqtext.equalInsensitive(mediaseqQueuedArguments[0], "gamemap") then return "" end if
  if len(mediaseqQueuedArguments) != 2 then return error(8498, "queued gamemap command is malformed") end if
  mediaseqQueuedSpecification = mediaseqQueuedArguments[1]
  parse(mediaseqQueuedSpecification)
  commandSystem.buffer = mediaseqQueuedParts[1]
  return mediaseqQueuedSpecification
end function

// Single-player death uses the original game-DLL AddCommandString boundary to
// ask the client host for its load-game menu. Keep that request out of the UI
// module itself, validate it exactly, and preserve unrelated console commands.
function takeQueuedLoadMenu(commandSystem)
  if commandSystem is void or typeof(commandSystem.buffer) != "string" then
    return error(8498, "server command buffer is invalid")
  end if
  if commandSystem.buffer == "" then return false end if
  mediaseqLoadParts = mediaseqcmd.splitFirst(commandSystem.buffer)
  mediaseqLoadArguments = mediaseqcmd.tokenize(mediaseqLoadParts[0])
  if len(mediaseqLoadArguments) == 0 then
    commandSystem.buffer = mediaseqLoadParts[1]
    return false
  end if
  if not mediaseqtext.equalInsensitive(mediaseqLoadArguments[0], "menu_loadgame") then
    return false
  end if
  if len(mediaseqLoadArguments) != 1 then
    return error(8498, "queued load-menu command is malformed")
  end if
  commandSystem.buffer = mediaseqLoadParts[1]
  return true
end function
