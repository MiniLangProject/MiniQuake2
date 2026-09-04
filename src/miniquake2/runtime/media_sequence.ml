//! Provides miniquake2 runtime media sequence facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Classic SV_Map level-string parser for map/CIN/PCX/DM2 sequences. */
package miniquake2.runtime.media_sequence

import miniquake2.qcommon.constants as mediaseqqc
import miniquake2.qcommon.cmd as mediaseqcmd
import miniquake2.qcommon.text as mediaseqtext

/// Defines the media map constant used by the miniquake2 runtime media sequence module.
const MEDIA_MAP = 0
/// Defines the media cin constant used by the miniquake2 runtime media sequence module.
const MEDIA_CIN = 1
/// Defines the media pcx constant used by the miniquake2 runtime media sequence module.
const MEDIA_PCX = 2
/// Defines the media dm2 constant used by the miniquake2 runtime media sequence module.
const MEDIA_DM2 = 3
/// Defines the max media steps constant used by the miniquake2 runtime media sequence module.
const MAX_MEDIA_STEPS = 16
/// Defines the max media transitions constant used by the miniquake2 runtime media sequence module.
const MAX_MEDIA_TRANSITIONS = 64
/// Defines the stock attract steps constant used by the miniquake2 runtime media sequence module.
const STOCK_ATTRACT_STEPS = 4

/// Store media step data.
struct MediaStep
  /// Stores the kind value associated with media step.
  kind
  /// Stores the name value associated with media step.
  name
  /// Stores the spawn point value associated with media step.
  spawnPoint
  /// Stores the end of unit value associated with media step.
  endOfUnit
end struct

/// Store media sequence data.
struct MediaSequence
  /// Stores the specification value associated with media sequence.
  specification
  /// Stores the steps value associated with media sequence.
  steps
end struct

/// Store the persistence operations attached to a gamemap transition.
struct GameMapPolicy
  /// Stores the archive current value associated with game map policy.
  archiveCurrent
  /// Stores the wipe unit value associated with game map policy.
  wipeUnit
  /// Stores the autosave successor value associated with game map policy.
  autosaveSuccessor
end struct

/// Store deterministic timedemo throughput data.
struct TimedemoMetrics
  /// Stores the frames value associated with timedemo metrics.
  frames
  /// Stores the elapsed msec value associated with timedemo metrics.
  elapsedMsec
  /// Stores the frames per second value associated with timedemo metrics.
  framesPerSecond
end struct

/// Compute the same frames/time report exposed by Quake II's timedemo path.
/// @param frames frames value consumed by this operation.
/// @param elapsedMsec elapsedMsec value consumed by this operation.
function timedemoMetrics(frames, elapsedMsec)
  if typeof(frames) != "int" or frames < 0 or
      (typeof(elapsedMsec) != "int" and typeof(elapsedMsec) != "float") or
      elapsedMsec < 0 then return error(8503, "timedemo metrics are invalid") end if
  fps = 0.0
  if elapsedMsec > 0 then fps = frames * 1000.0 / elapsedMsec end if
  return TimedemoMetrics(frames, elapsedMsec, fps)
end function

/// Match SV_GameMap_f: archive the outgoing level inside a unit, wipe the
/// current-unit archive at `*`, and autosave the successfully spawned successor.
/// @param step step value consumed by this operation.
/// @param singlePlayer singlePlayer value consumed by this operation.
function gameMapPolicy(step, singlePlayer)
  if typeof(step) != "struct" or typeof(singlePlayer) != "bool" then
    return error(8501, "gamemap policy inputs are invalid")
  end if
  return GameMapPolicy(singlePlayer and not step.endOfUnit,
    singlePlayer and step.endOfUnit, singlePlayer)
end function

/// Preserve the original ZOID cooperative end-screen loop back to base1.
/// @param step step value consumed by this operation.
/// @param cooperative cooperative value consumed by this operation.
function cooperativePictureSuccessor(step, cooperative)
  if typeof(step) != "struct" or typeof(cooperative) != "bool" then
    return error(8502, "cooperative picture policy inputs are invalid")
  end if
  if cooperative and step.kind == MEDIA_PCX and
      mediaseqtext.equalInsensitive(step.name, "victory.pcx") then
    return "*base1"
  end if
  return ""
end function

/// Return the ends with insensitive value.
/// @param value Value consumed or transformed by the operation.
/// @param suffix suffix value consumed by this operation.
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

/// Return the safe name.
/// @param value Value consumed or transformed by the operation.
/// @param operation operation value consumed by this operation.
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

/// Parse step.
/// @param component component value consumed by this operation.
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
  if mediaseqKind != MEDIA_MAP and mediaseqSpawn != "" then
    return error(8494, "media step cannot carry a spawn point")
  end if
  return MediaStep(mediaseqKind, mediaseqLevel, mediaseqSpawn, mediaseqEndOfUnit)
end function

/// Stock Quake II 3.19 obtains these four entries from the d1..d4 aliases in
/// baseq2/default.cfg. There is no demos.lst lookup in the original client.
/// @param index Zero-based index of the affected item.
function stockAttractStep(index)
  if typeof(index) != "int" or index < 0 or index >= STOCK_ATTRACT_STEPS then
    return error(8499, "stock attract index outside [0,3]")
  end if
  if index == 0 or index == 2 then return parseStep("idlog.cin") end if
  if index == 1 then return parseStep("demo1.dm2") end if
  return parseStep("demo2.dm2")
end function

/// Return the next stock attract index.
/// @param index Zero-based index of the affected item.
function nextStockAttractIndex(index)
  stockAttractStep(index)
  return (index + 1) % STOCK_ATTRACT_STEPS
end function

/// The stock New Game alias is `map *ntro.cin+base1`. The leading star is
/// legal for every SV_Map media kind and marks a new unit/save epoch before
/// SV_Map strips it and classifies the .cin extension.
function stockNewGameSpecification()
  return "*ntro.cin+base1"
end function

/// Return the game button down value.
/// @param input input value consumed by this operation.
function gameButtonDown(input)
  if input is void or typeof(input.keys) != "array" or
      typeof(input.controllerButtons) != "int" then
    return error(8500, "media input state is invalid")
  end if
  if input.destination != 0 or not input.focused then return false end if
  if input.controllerButtons != 0 then return true end if
  mediaseqKeyIndex = 0
  while mediaseqKeyIndex < len(input.keys)
    if input.keys[mediaseqKeyIndex] then return true end if
    mediaseqKeyIndex = mediaseqKeyIndex + 1
  end while
  return false
end function

/// keys.c maps any press during cl.attractloop to Escape. Grave/Escape may
/// already have changed key_dest before this check, while ordinary buttons are
/// represented by the held-key table.
/// @param input input value consumed by this operation.
function attractInterrupted(input)
  if input is void or typeof(input.focused) != "bool" then
    return error(8500, "media input state is invalid")
  end if
  if not input.focused then return false end if
  if input.destination != 0 then return true end if
  return gameButtonDown(input)
end function

/// Parses parse for the miniquake2 runtime media sequence workflow.
/// @param specification specification value consumed by this operation.
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

/// Return the kind name.
/// @param kind kind value consumed by this operation.
function kindName(kind)
  if kind == MEDIA_MAP then return "map" end if
  if kind == MEDIA_CIN then return "cin" end if
  if kind == MEDIA_PCX then return "pcx" end if
  if kind == MEDIA_DM2 then return "dm2" end if
  return error(8497, "unknown media step kind")
end function

/// The game module queues `gamemap "spec"` through AddCommandString after
/// intermission exit. Validate the complete first command before removing it;
/// unrelated server-console work remains untouched for its own policy layer.
/// @param commandSystem commandSystem value consumed by this operation.
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

/// Single-player death uses the original game-DLL AddCommandString boundary to
/// ask the client host for its load-game menu. Keep that request out of the UI
/// module itself, validate it exactly, and preserve unrelated console commands.
/// @param commandSystem commandSystem value consumed by this operation.
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
