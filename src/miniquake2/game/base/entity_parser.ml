/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Strict, bounds-checked counterpart of COM_Parse, ED_NewString and the
spawn-enabled portion of ED_ParseField.
*/
package miniquake2.game.base.entity_parser

import miniquake2.game.base.types as btypes
import miniquake2.qcommon.byteio as qbyteio
import miniquake2.qcommon.text as qtext

function parserError(code, offset, message)
  return error(code, "baseq2 entity text at byte " + offset + ": " + message)
end function

function isWhitespace(value)
  return value <= 32
end function

// Exact ED_NewString behavior: \n becomes a newline; every other backslash
// pair becomes one literal backslash and discards the second byte.
function ED_NewString(value)
  if typeof(value) != "string" then return error(9000, "ED_NewString: text required") end if
  source = bytes(value)
  output = bytes(len(source))
  inputIndex = 0
  outputIndex = 0
  while inputIndex < len(source)
    if source[inputIndex] == 92 and inputIndex + 1 < len(source) then
      inputIndex = inputIndex + 1
      if source[inputIndex] == 110 then output[outputIndex] = 10 else output[outputIndex] = 92 end if
    else
      output[outputIndex] = source[inputIndex]
    end if
    outputIndex = outputIndex + 1
    inputIndex = inputIndex + 1
  end while
  if outputIndex == 0 then return "" end if
  outputPrefix = slice(output, 0, outputIndex)
  return decode(outputPrefix)
end function

function createScanner(value)
  if typeof(value) != "string" then return error(9001, "entity text must be a string") end if
  data = bytes(value)
  effectiveLength = len(data)
  if effectiveLength > 0 and data[effectiveLength - 1] == 0 then effectiveLength = effectiveLength - 1 end if
  index = 0
  while index < effectiveLength
    if data[index] == 0 then return parserError(9002, index, "embedded NUL is not allowed") end if
    index = index + 1
  end while
  if effectiveLength == len(data) then return btypes.EntityScanner(data, 0) end if
  effectiveData = slice(data, 0, effectiveLength)
  return btypes.EntityScanner(effectiveData, 0)
end function

function skipTrivia(scanner)
  data = scanner.data
  while scanner.offset <= len(data)
    while scanner.offset < len(data) and isWhitespace(data[scanner.offset])
      scanner.offset = scanner.offset + 1
    end while
    if scanner.offset + 1 < len(data) and data[scanner.offset] == 47 and data[scanner.offset + 1] == 47 then
      scanner.offset = scanner.offset + 2
      while scanner.offset < len(data) and data[scanner.offset] != 10
        scanner.offset = scanner.offset + 1
      end while
      continue
    end if
    break
  end while
  return scanner.offset
end function

function nextToken(scanner)
  skipTrivia(scanner)
  data = scanner.data
  start = scanner.offset
  if start >= len(data) then return btypes.EntityToken("eof", "", start) end if
  value = data[start]
  if value == 123 then scanner.offset = start + 1; return btypes.EntityToken("open", "{", start) end if
  if value == 125 then scanner.offset = start + 1; return btypes.EntityToken("close", "}", start) end if
  if value == 34 then
    index = start + 1
    while index < len(data) and data[index] != 34
      index = index + 1
    end while
    if index >= len(data) then return parserError(9003, start, "unterminated quoted token") end if
    tokenBytes = slice(data, start + 1, index - start - 1)
    scanner.offset = index + 1
    if len(tokenBytes) == 0 then return btypes.EntityToken("word", "", start) end if
    tokenText = decode(tokenBytes)
    return btypes.EntityToken("word", tokenText, start)
  end if
  index = start
  while index < len(data) and not isWhitespace(data[index]) and data[index] != 123 and data[index] != 125
    if data[index] == 34 then return parserError(9004, index, "quote inside an unquoted token") end if
    index = index + 1
  end while
  if index == start then return parserError(9005, start, "invalid token") end if
  scanner.offset = index
  tokenBytes = slice(data, start, index - start)
  tokenText = decode(tokenBytes)
  return btypes.EntityToken("word", tokenText, start)
end function

function finishPrefix(values, count)
  if count == 0 then return [] end if
  result = array(count)
  index = 0
  while index < count
    result[index] = values[index]
    index = index + 1
  end while
  return result
end function

function parseEntities(value)
  scanner = createScanner(value)
  parsed = array(16)
  parsedCount = 0
  token = nextToken(scanner)
  while token.kind != "eof"
    if token.kind != "open" then return parserError(9006, token.offset, "expected { to start an entity") end if
    pairs = array(8)
    pairCount = 0
    keyToken = nextToken(scanner)
    while keyToken.kind != "close"
      if keyToken.kind == "eof" then return parserError(9007, keyToken.offset, "EOF without closing brace") end if
      if keyToken.kind != "word" then return parserError(9008, keyToken.offset, "entity key must be text") end if
      valueToken = nextToken(scanner)
      if valueToken.kind == "eof" then return parserError(9009, valueToken.offset, "EOF without a value or closing brace") end if
      if valueToken.kind == "close" then return parserError(9010, valueToken.offset, "closing brace without field data") end if
      if valueToken.kind != "word" then return parserError(9011, valueToken.offset, "entity value must be text") end if
      // Entity lumps are commonly tens of kilobytes, but an individual entity
      // only owns a handful of fields.  Grow from eight actual pair slots
      // instead of reserving the complete lump size for every entity.
      if pairCount >= len(pairs) then
        grownPairs = array(len(pairs) * 2)
        pairGrowIndex = 0
        while pairGrowIndex < pairCount
          grownPairs[pairGrowIndex] = pairs[pairGrowIndex]
          pairGrowIndex = pairGrowIndex + 1
        end while
        pairs = grownPairs
      end if
      pairKey = keyToken.text
      pairValue = valueToken.text
      parsedPair = btypes.EntityPair(pairKey, pairValue)
      pairs[pairCount] = parsedPair
      pairCount = pairCount + 1
      keyToken = nextToken(scanner)
    end while
    finishedPairs = finishPrefix(pairs, pairCount)
    parsedEntity = btypes.ParsedEntity(finishedPairs)
    if parsedCount >= len(parsed) then
      grownParsed = array(len(parsed) * 2)
      parsedGrowIndex = 0
      while parsedGrowIndex < parsedCount
        grownParsed[parsedGrowIndex] = parsed[parsedGrowIndex]
        parsedGrowIndex = parsedGrowIndex + 1
      end while
      parsed = grownParsed
    end if
    parsed[parsedCount] = parsedEntity
    parsedCount = parsedCount + 1
    token = nextToken(scanner)
  end while
  return finishPrefix(parsed, parsedCount)
end function

// Production spawn ingestion deliberately does not retain EntityPair token
// strings.  Each field is consumed while both scanner tokens and the target
// BaseEntity are live locals, so a long sequence of retail level loads cannot
// expose an old pair through a later allocation/collection boundary.  The
// ParsedEntity API above remains available for syntax/contract inspection.
function parseMaterializedEntities(value)
  scanner = createScanner(value)
  materialized = array(16)
  materializedCount = 0
  token = nextToken(scanner)
  while token.kind != "eof"
    if token.kind != "open" then return parserError(9006, token.offset, "expected { to start an entity") end if
    entity = btypes.zeroBaseEntity()
    keyToken = nextToken(scanner)
    while keyToken.kind != "close"
      if keyToken.kind == "eof" then return parserError(9007, keyToken.offset, "EOF without closing brace") end if
      if keyToken.kind != "word" then return parserError(9008, keyToken.offset, "entity key must be text") end if
      valueToken = nextToken(scanner)
      if valueToken.kind == "eof" then return parserError(9009, valueToken.offset, "EOF without a value or closing brace") end if
      if valueToken.kind == "close" then return parserError(9010, valueToken.offset, "closing brace without field data") end if
      if valueToken.kind != "word" then return parserError(9011, valueToken.offset, "entity value must be text") end if
      fieldKey = keyToken.text
      fieldValue = valueToken.text
      ED_ParseField(entity, fieldKey, fieldValue)
      keyToken = nextToken(scanner)
    end while
    if materializedCount >= len(materialized) then
      grownMaterialized = array(len(materialized) * 2)
      materializedGrowIndex = 0
      while materializedGrowIndex < materializedCount
        grownMaterialized[materializedGrowIndex] = materialized[materializedGrowIndex]
        materializedGrowIndex = materializedGrowIndex + 1
      end while
      materialized = grownMaterialized
    end if
    materialized[materializedCount] = entity
    materializedCount = materializedCount + 1
    token = nextToken(scanner)
  end while
  return finishPrefix(materialized, materializedCount)
end function

function parseNumber(value, fieldName)
  if typeof(value) != "string" or len(bytes(value)) == 0 then return error(9012, fieldName + ": numeric text required") end if
  source = bytes(value)
  // ED_ParseField used atof/atoi.  Keep their useful prefix semantics (some
  // retail maps contain values such as ".1.25") while still rejecting text
  // that has no numeric prefix at all.
  index = 0
  while index < len(source) and isWhitespace(source[index])
    index = index + 1
  end while
  start = index
  if index < len(source) and (source[index] == 43 or source[index] == 45) then index = index + 1 end if
  digitCount = 0
  while index < len(source) and source[index] >= 48 and source[index] <= 57
    index = index + 1
    digitCount = digitCount + 1
  end while
  if index < len(source) and source[index] == 46 then
    index = index + 1
    while index < len(source) and source[index] >= 48 and source[index] <= 57
      index = index + 1
      digitCount = digitCount + 1
    end while
  end if
  if digitCount == 0 then return error(9013, fieldName + ": invalid numeric value " + value) end if
  exponentStart = index
  if index < len(source) and (source[index] == 69 or source[index] == 101) then
    index = index + 1
    if index < len(source) and (source[index] == 43 or source[index] == 45) then index = index + 1 end if
    exponentDigits = 0
    while index < len(source) and source[index] >= 48 and source[index] <= 57
      index = index + 1
      exponentDigits = exponentDigits + 1
    end while
    if exponentDigits == 0 then index = exponentStart end if
  end if
  normalized = decode(slice(source, start, index - start))
  normalizedBytes = bytes(normalized)
  if normalizedBytes[0] == 43 then
    normalized = decode(slice(normalizedBytes, 1, len(normalizedBytes) - 1))
    normalizedBytes = bytes(normalized)
  end if
  if normalizedBytes[0] == 46 then
    normalized = "0" + normalized
  else if len(normalizedBytes) > 1 and normalizedBytes[0] == 45 and normalizedBytes[1] == 46 then
    normalized = "-0" + decode(slice(normalizedBytes, 1, len(normalizedBytes) - 1))
  end if
  converted = try(toNumber(normalized))
  if converted is error then return error(9013, fieldName + ": invalid numeric value " + value) end if
  if typeof(converted) != "int" and typeof(converted) != "float" then return error(9013, fieldName + ": invalid numeric value " + value) end if
  return converted
end function

function parseInteger(value, fieldName)
  converted = parseNumber(value, fieldName)
  return qbyteio.truncInt(converted)
end function

function parseVector(value, fieldName)
  source = bytes(value)
  result = [0.0, 0.0, 0.0]
  component = 0
  index = 0
  while index < len(source)
    while index < len(source) and isWhitespace(source[index])
      index = index + 1
    end while
    if index >= len(source) then break end if
    if component >= 3 then return error(9014, fieldName + ": vector has more than three components") end if
    start = index
    while index < len(source) and not isWhitespace(source[index])
      index = index + 1
    end while
    part = decode(slice(source, start, index - start))
    result[component] = parseNumber(part, fieldName)
    component = component + 1
  end while
  if component != 3 then return error(9015, fieldName + ": vector must contain exactly three components") end if
  return result
end function

function appendUnknown(entity, key)
  entity.unknownFields = entity.unknownFields + [key]
  return false
end function

// Returns true for a recognized field and false for the original diagnostic
// path ("... is not a field"). Utility keys beginning with _ are ignored.
function ED_ParseField(entity, key, value)
  if typeof(entity) != "struct" then return error(9016, "ED_ParseField: BaseEntity required") end if
  if typeof(key) != "string" or typeof(value) != "string" then return error(9017, "ED_ParseField: text key/value required") end if
  if len(bytes(key)) == 0 then return error(9018, "ED_ParseField: empty key") end if
  if bytes(key)[0] == 95 then return true end if
  name = qtext.lower(key)
  if name == "classname" then entity.className = ED_NewString(value)
  else if name == "model" then entity.model = ED_NewString(value)
  else if name == "spawnflags" then entity.spawnFlags = parseInteger(value, name)
  else if name == "origin" then entity.origin = parseVector(value, name)
  else if name == "angles" then entity.angles = parseVector(value, name)
  else if name == "angle" then entity.angles = [0.0, parseNumber(value, name), 0.0]
  else if name == "target" then entity.target = ED_NewString(value)
  else if name == "targetname" then entity.targetName = ED_NewString(value)
  else if name == "killtarget" then entity.killTarget = ED_NewString(value)
  else if name == "team" then entity.team = ED_NewString(value)
  else if name == "pathtarget" then entity.pathTarget = ED_NewString(value)
  else if name == "deathtarget" then entity.deathTarget = ED_NewString(value)
  else if name == "combattarget" then entity.combatTarget = ED_NewString(value)
  else if name == "message" then entity.message = ED_NewString(value)
  else if name == "map" then entity.map = ED_NewString(value)
  else if name == "speed" then entity.speed = parseNumber(value, name)
  else if name == "accel" then entity.accel = parseNumber(value, name)
  else if name == "decel" then entity.decel = parseNumber(value, name)
  else if name == "wait" then entity.wait = parseNumber(value, name)
  else if name == "delay" then entity.delay = parseNumber(value, name)
  else if name == "random" then entity.random = parseNumber(value, name)
  else if name == "style" then entity.style = parseInteger(value, name)
  else if name == "count" then entity.count = parseInteger(value, name)
  else if name == "health" then entity.health = parseInteger(value, name)
  else if name == "sounds" then entity.sounds = parseInteger(value, name)
  else if name == "light" then return true
  else if name == "dmg" then entity.damage = parseInteger(value, name)
  else if name == "mass" then entity.mass = parseInteger(value, name)
  else if name == "volume" then entity.volume = parseNumber(value, name)
  else if name == "attenuation" then entity.attenuation = parseNumber(value, name)
  else if name == "move_origin" then entity.moveOrigin = parseVector(value, name)
  else if name == "move_angles" then entity.moveAngles = parseVector(value, name)
  else if name == "lip" then entity.spawnTemp.lip = parseInteger(value, name)
  else if name == "distance" then entity.spawnTemp.distance = parseInteger(value, name)
  else if name == "height" then entity.spawnTemp.height = parseInteger(value, name)
  else if name == "noise" then entity.spawnTemp.noise = ED_NewString(value)
  else if name == "pausetime" then entity.spawnTemp.pauseTime = parseNumber(value, name)
  else if name == "item" then entity.spawnTemp.item = ED_NewString(value)
  else if name == "gravity" then entity.spawnTemp.gravity = ED_NewString(value)
  else if name == "sky" then entity.spawnTemp.sky = ED_NewString(value)
  else if name == "skyrotate" then entity.spawnTemp.skyRotate = parseNumber(value, name)
  else if name == "skyaxis" then entity.spawnTemp.skyAxis = parseVector(value, name)
  else if name == "minyaw" then entity.spawnTemp.minYaw = parseNumber(value, name)
  else if name == "maxyaw" then entity.spawnTemp.maxYaw = parseNumber(value, name)
  else if name == "minpitch" then entity.spawnTemp.minPitch = parseNumber(value, name)
  else if name == "maxpitch" then entity.spawnTemp.maxPitch = parseNumber(value, name)
  else if name == "nextmap" then entity.spawnTemp.nextMap = ED_NewString(value)
  else return appendUnknown(entity, key)
  end if
  return true
end function

function materialize(parsed)
  entity = btypes.zeroBaseEntity()
  for each pair in parsed.pairs
    pairKey = pair.key
    pairValue = pair.value
    ED_ParseField(entity, pairKey, pairValue)
  end for
  return entity
end function
