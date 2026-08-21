/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Deterministic baseq2 BSP entity ingestion. Unknown classes are represented by
structured diagnostics and skipped; syntax and typed-field corruption fail.
*/
package miniquake2.game.base.spawn

import miniquake2.game.base.entity_parser as bparser
import miniquake2.game.base.spawn_registry as bregistry
import miniquake2.game.base.types as btypes
import std.string as bspawntext

function appendDiagnostic(diagnostics, message)
  return diagnostics + [message]
end function

function incrementSkipped(skippedClasses, className)
  for each entry in skippedClasses
    if entry.className == className then
      entry.count = entry.count + 1
      return skippedClasses
    end if
  end for
  return skippedClasses + [btypes.SkippedClassCount(className, 1)]
end function

function SpawnEntitiesWithRegistry(mapName, entityString, spawnPoint, registry)
  if typeof(mapName) != "string" or len(bytes(mapName)) == 0 then return error(9070, "SpawnEntities: empty map name") end if
  if typeof(spawnPoint) != "string" then return error(9071, "SpawnEntities: spawn point must be text") end if
  if typeof(registry) != "struct" then return error(9072, "SpawnEntities: spawn registry required") end if
  materializedEntities = bparser.parseMaterializedEntities(entityString)
  if len(materializedEntities) == 0 then return error(9073, "SpawnEntities: entity text has no worldspawn") end if

  liveEdicts = array(len(materializedEntities))
  liveCount = 0
  skippedCount = 0
  skippedClasses = []
  diagnostics = []
  sourceIndex = 0
  for each component in materializedEntities
    if sourceIndex == 0 and component.className != "worldspawn" then return error(9074, "SpawnEntities: first entity must be worldspawn") end if
    if sourceIndex > 0 and component.className == "worldspawn" then return error(9075, "SpawnEntities: duplicate worldspawn") end if

    for each fieldName in component.unknownFields
      diagnostics = appendDiagnostic(diagnostics, fieldName + " is not a field (source entity " + sourceIndex + ")")
    end for

    entry = bregistry.find(registry, component.className)
    if entry is void then
      label = component.className
      if label == "" then label = "<missing classname>" end if
      diagnostics = appendDiagnostic(diagnostics, label + " does not have a spawn function (source entity " + sourceIndex + ")")
      skippedCount = skippedCount + 1
      skippedClasses = incrementSkipped(skippedClasses, label)
    else
      callbackDiagnostic = entry.spawn(component)
      if typeof(callbackDiagnostic) != "string" then return error(9076, "SpawnEntities: spawn callback returned an invalid result for " + component.className) end if
      if callbackDiagnostic != "" then diagnostics = appendDiagnostic(diagnostics, callbackDiagnostic + " (source entity " + sourceIndex + ")") end if
      // Like ED_CallSpawn + G_FreeEdict, purely editor/compiler entities do
      // not consume a live edict number.  This is what lets large retail BSP
      // entity lumps exceed MAX_EDICTS while their live set remains bounded.
      if bspawntext.startsWith(component.spawnKind, "consumed:") != true then
        componentHolder = component
        liveBaseEdict = btypes.makeBaseEdict(liveCount, sourceIndex, componentHolder)
        // Keep the component visible across both the BaseEdict construction
        // and its transfer into the compact live array.
        liveBaseEdict.component = componentHolder
        liveEdicts[liveCount] = liveBaseEdict
        liveCount = liveCount + 1
      end if
    end if
    sourceIndex = sourceIndex + 1
  end for
  edicts = bparser.finishPrefix(liveEdicts, liveCount)
  if len(edicts) == 0 or edicts[0].component.spawnKind != "worldspawn" then return error(9077, "SpawnEntities: worldspawn did not spawn") end if
  return btypes.SpawnResult(mapName, spawnPoint, edicts, diagnostics, len(materializedEntities), skippedCount, skippedClasses)
end function

function SpawnEntities(mapName, entityString, spawnPoint)
  return SpawnEntitiesWithRegistry(mapName, entityString, spawnPoint, bregistry.defaultRegistry())
end function

function spawnEntitiesLogged(mapName, entityString, spawnPoint, logger)
  if typeof(logger) != "function" then return error(9078, "SpawnEntities: logger must be a function") end if
  result = SpawnEntities(mapName, entityString, spawnPoint)
  for each diagnostic in result.diagnostics
    logger(diagnostic)
  end for
  return result
end function
