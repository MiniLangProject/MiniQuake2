/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Quake II 3.19 game server commands, packet filters and operator policy.
*/
package miniquake2.server.administration

import std.fs as adminfs
import miniquake2.qcommon.types as adminqtypes
import miniquake2.qcommon.text as admintext
import miniquake2.network.constants as adminnc

const MAX_IP_FILTERS = 1024
const MAX_RCON_PASSWORD_BYTES = 128
const MIN_RCON_PASSWORD_BYTES = 8
const DEFAULT_MASTER_PORT = 27900

activeAdministration = void

struct IpFilter
  mask
  compare
end struct

struct Administration
  filters
  filterBan
  rconPassword
  masters
  masterPingPending
  writePath
  lastOutput
  rconAccepted
  rconRejected
end struct

function create()
  return Administration([], true, "", [], false, "", "", 0, 0)
end function

function activate(state)
  global activeAdministration
  if typeof(state) != "struct" then return error(7606, "invalid administration state") end if
  activeAdministration = state
  return state
end function

function active()
  global activeAdministration
  if activeAdministration is void then activeAdministration = create() end if
  return activeAdministration
end function

function decimalOctet(source, start, endIndex)
  if start >= endIndex or endIndex - start > 3 then
    return error(7600, "bad filter address")
  end if
  value = 0
  index = start
  while index < endIndex
    character = source[index]
    if character < 48 or character > 57 then
      return error(7600, "bad filter address")
    end if
    value = value * 10 + character - 48
    index = index + 1
  end while
  if value > 255 then return error(7600, "bad filter address") end if
  return value
end function

// StringToFilter intentionally retains the original zero-octet wildcard
// rule.  Consequently "192.0" describes 192.*.*.*, exactly as baseq2 3.19.
function parseFilter(value)
  if typeof(value) != "string" or value == "" then
    return error(7600, "bad filter address")
  end if
  source = bytes(value)
  if source[len(source) - 1] == 46 then return error(7600, "bad filter address") end if
  compare = array(4, 0)
  mask = array(4, 0)
  component = 0
  start = 0
  index = 0
  while index <= len(source)
    if index == len(source) or source[index] == 46 then
      if component >= 4 then return error(7600, "bad filter address") end if
      octet = decimalOctet(source, start, index)
      compare[component] = octet
      if octet != 0 then mask[component] = 255 end if
      component = component + 1
      start = index + 1
    end if
    index = index + 1
  end while
  if component < 1 or component > 4 then
    return error(7600, "bad filter address")
  end if
  return IpFilter(mask, compare)
end function

function sameFilter(first, second)
  index = 0
  while index < 4
    if first.mask[index] != second.mask[index] or
        first.compare[index] != second.compare[index] then return false end if
    index = index + 1
  end while
  return true
end function

function filterText(filter)
  return filter.compare[0] + "." + filter.compare[1] + "." +
    filter.compare[2] + "." + filter.compare[3]
end function

function addIp(state, value)
  filter = try(parseFilter(value))
  if filter is error then return "Bad filter address: " + value + "\n" end if
  if len(state.filters) >= MAX_IP_FILTERS then return "IP filter list is full\n" end if
  state.filters = state.filters + [filter]
  return ""
end function

function removeIp(state, value)
  filter = try(parseFilter(value))
  if filter is error then return "Bad filter address: " + value + "\n" end if
  found = -1
  index = 0
  while index < len(state.filters)
    if sameFilter(state.filters[index], filter) then found = index; break end if
    index = index + 1
  end while
  if found < 0 then return "Didn't find " + value + ".\n" end if
  output = array(len(state.filters) - 1, void)
  sourceIndex = 0
  outputIndex = 0
  while sourceIndex < len(state.filters)
    if sourceIndex != found then
      output[outputIndex] = state.filters[sourceIndex]
      outputIndex = outputIndex + 1
    end if
    sourceIndex = sourceIndex + 1
  end while
  state.filters = output
  return "Removed.\n"
end function

function listIp(state)
  output = "Filter list:\n"
  for each filter in state.filters
    output = output + filterText(filter) + "\n"
  end for
  return output
end function

function configText(state)
  value = 0
  if state.filterBan then value = 1 end if
  output = "set filterban " + value + "\n"
  for each filter in state.filters
    output = output + "sv addip " + filterText(filter) + "\n"
  end for
  return output
end function

function setWritePath(state, path)
  if typeof(path) != "string" then return error(7601, "listip path must be text") end if
  state.writePath = path
  return path
end function

// Use an adjacent verified temporary file so a failed write never truncates
// the active access-control policy.
function writeIp(state)
  if state.writePath == "" then return "Couldn't open listip.cfg\n" end if
  value = configText(state)
  temporary = state.writePath + ".tmp"
  written = try(adminfs.writeAllText(temporary, value))
  if written is error then return "Couldn't open " + state.writePath + "\n" end if
  verified = try(adminfs.readAllText(temporary))
  if verified is error or verified != value then
    if adminfs.exists(temporary) then adminfs.delete(temporary) end if
    return "Couldn't verify " + state.writePath + "\n"
  end if
  moved = try(adminfs.moveFile(temporary, state.writePath, true))
  if moved is error then
    if adminfs.exists(temporary) then adminfs.delete(temporary) end if
    return "Couldn't open " + state.writePath + "\n"
  end if
  return "Writing " + state.writePath + ".\n"
end function

function matches(filter, address)
  if address is void or address.type != adminnc.NA_IP or len(address.ip) != 4 then
    return false
  end if
  index = 0
  while index < 4
    if (address.ip[index] & filter.mask[index]) != filter.compare[index] then
      return false
    end if
    index = index + 1
  end while
  return true
end function

// True means the connect must be rejected, mirroring SV_FilterPacket.
function filterPacket(state, address)
  if address is void or address.type == adminnc.NA_LOOPBACK then return false end if
  matched = false
  for each filter in state.filters
    if matches(filter, address) then matched = true; break end if
  end for
  if matched then return state.filterBan end if
  return not state.filterBan
end function

function setFilterBan(state, value)
  if value == "0" then state.filterBan = false; return true end if
  if value == "1" then state.filterBan = true; return true end if
  return error(7602, "filterban must be 0 or 1")
end function

function printablePassword(value)
  data = bytes(value)
  index = 0
  while index < len(data)
    if data[index] < 33 or data[index] > 126 then return false end if
    index = index + 1
  end while
  return true
end function

// Empty disables RCON like 3.19. Non-empty secrets get a modern minimum and
// must remain one printable command token; this avoids ambiguous wire parsing.
function setRconPassword(state, value)
  if typeof(value) != "string" then return error(7603, "rcon password must be text") end if
  count = len(bytes(value))
  if count == 0 then state.rconPassword = ""; return true end if
  if count < MIN_RCON_PASSWORD_BYTES or count > MAX_RCON_PASSWORD_BYTES or
      not printablePassword(value) then
    return error(7604, "rcon password must contain 8..128 printable non-space bytes")
  end if
  state.rconPassword = value
  return true
end function

function constantTimeEqual(first, second)
  firstData = bytes(first)
  secondData = bytes(second)
  difference = len(firstData) ^ len(secondData)
  maximum = len(firstData)
  if len(secondData) > maximum then maximum = len(secondData) end if
  index = 0
  while index < maximum
    firstByte = 0
    secondByte = 0
    if index < len(firstData) then firstByte = firstData[index] end if
    if index < len(secondData) then secondByte = secondData[index] end if
    difference = difference | (firstByte ^ secondByte)
    index = index + 1
  end while
  return difference == 0
end function

function rconValid(state, supplied)
  if state.rconPassword == "" then return false end if
  return constantTimeEqual(state.rconPassword, supplied)
end function

function parseEndpoint(value)
  if typeof(value) != "string" or value == "" then return error(7605, "bad master address") end if
  source = bytes(value)
  colon = len(source)
  index = 0
  while index < len(source)
    if source[index] == 58 then
      if colon != len(source) then return error(7605, "bad master address") end if
      colon = index
    end if
    index = index + 1
  end while
  port = DEFAULT_MASTER_PORT
  if colon < len(source) then
    // Ports are wider than octets, so parse this token independently.
    port = 0
    index = colon + 1
    if index >= len(source) then return error(7605, "bad master address") end if
    while index < len(source)
      if source[index] < 48 or source[index] > 57 then return error(7605, "bad master address") end if
      port = port * 10 + source[index] - 48
      if port > 65535 then return error(7605, "bad master address") end if
      index = index + 1
    end while
    if port == 0 then port = DEFAULT_MASTER_PORT end if
  end if
  hostEnd = colon
  compare = array(4, 0)
  component = 0
  start = 0
  index = 0
  while index <= hostEnd
    if index == hostEnd or source[index] == 46 then
      if component >= 4 then return error(7605, "bad master address") end if
      compare[component] = decimalOctet(source, start, index)
      component = component + 1
      start = index + 1
    end if
    index = index + 1
  end while
  if component != 4 then return error(7605, "bad master address") end if
  return adminqtypes.NetAddress(adminnc.NA_IP, compare, array(10, 0), port)
end function

function configureMasters(state, arguments, startIndex)
  masters = []
  index = startIndex
  while index < len(arguments) and len(masters) < adminnc.MAX_MASTERS
    endpoint = try(parseEndpoint(arguments[index]))
    if endpoint is error then return error(7605, "bad master address: " + arguments[index]) end if
    masters = masters + [endpoint]
    index = index + 1
  end while
  state.masters = masters
  state.masterPingPending = len(masters) > 0
  output = ""
  for each master in masters
    output = output + "Master server at " + master.ip[0] + "." + master.ip[1] +
      "." + master.ip[2] + "." + master.ip[3] + ":" + master.port + "\n"
  end for
  return output
end function

function takeMasterPing(state)
  if not state.masterPingPending then return false end if
  state.masterPingPending = false
  return true
end function

function serverCommand(state, arguments)
  if len(arguments) < 2 then
    state.lastOutput = "Unknown server command \"\"\n"
    return state.lastOutput
  end if
  command = arguments[1]
  if admintext.equalInsensitive(command, "test") then state.lastOutput = "Svcmd_Test_f()\n"
  else if admintext.equalInsensitive(command, "addip") then
    if len(arguments) < 3 then state.lastOutput = "Usage:  sv addip <ip-mask>\n"
    else state.lastOutput = addIp(state, arguments[2])
    end if
  else if admintext.equalInsensitive(command, "removeip") then
    if len(arguments) < 3 then state.lastOutput = "Usage:  sv removeip <ip-mask>\n"
    else state.lastOutput = removeIp(state, arguments[2])
    end if
  else if admintext.equalInsensitive(command, "listip") then state.lastOutput = listIp(state)
  else if admintext.equalInsensitive(command, "writeip") then state.lastOutput = writeIp(state)
  else state.lastOutput = "Unknown server command \"" + command + "\"\n"
  end if
  return state.lastOutput
end function
