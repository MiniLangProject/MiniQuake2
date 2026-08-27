/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Quake II backslash-delimited userinfo/serverinfo strings. */
package miniquake2.qcommon.info

import miniquake2.qcommon.constants as qc

// Report whether component valid.
function componentValid(value)
  if len(bytes(value)) >= qc.MAX_INFO_KEY then return false end if
  data = bytes(value)
  i = 0
  while i < len(data)
    if data[i] == 92 or data[i] == 59 or data[i] == 34 then return false end if
    i = i + 1
  end while
  return true
end function

// Return the pairs value.
function pairs(info)
  data = bytes(info)
  result = []
  index = 0
  if index < len(data) and data[index] == 92 then index = index + 1 end if
  while index < len(data)
    keyStart = index
    while index < len(data) and data[index] != 92
      index = index + 1
    end while
    if index >= len(data) then return error(3240, "userinfo key has no value") end if
    key = decode(slice(data, keyStart, index - keyStart))
    index = index + 1
    valueStart = index
    while index < len(data) and data[index] != 92
      index = index + 1
    end while
    value = decode(slice(data, valueStart, index - valueStart))
    if componentValid(key) == false or componentValid(value) == false then return error(3241, "invalid userinfo component") end if
    result = result + [[key, value]]
    if index < len(data) then index = index + 1 end if
  end while
  return result
end function

// Validate state.
function validate(info)
  if typeof(info) != "string" or len(bytes(info)) >= qc.MAX_INFO_STRING then return false end if
  parsed = try(pairs(info))
  return parsed is not error
end function

// Return the value for key value.
function valueForKey(info, requestedKey)
  parsed = pairs(info)
  for each pair in parsed
    if pair[0] == requestedKey then return pair[1] end if
  end for
  return ""
end function

// Remove key.
function removeKey(info, requestedKey)
  if componentValid(requestedKey) == false then return error(3242, "invalid userinfo key") end if
  parsed = pairs(info)
  output = ""
  for each pair in parsed
    if pair[0] != requestedKey then output = output + "\\" + pair[0] + "\\" + pair[1] end if
  end for
  return output
end function

// Set value for key.
function setValueForKey(info, key, value)
  if componentValid(key) == false or componentValid(value) == false or key == "" then return error(3243, "invalid userinfo key/value") end if
  output = removeKey(info, key)
  if value != "" then output = output + "\\" + key + "\\" + value end if
  if len(bytes(output)) >= qc.MAX_INFO_STRING then return error(3244, "userinfo string length exceeded") end if
  return output
end function
