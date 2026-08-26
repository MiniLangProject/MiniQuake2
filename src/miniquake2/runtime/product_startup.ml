/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Persistent menu-first product startup, browser and player/server settings. */
package miniquake2.runtime.product_startup

import std.fs as productfs
import std.string as productstring
import miniquake2.qcommon.info as productinfo
import miniquake2.qcommon.text as producttext
import miniquake2.network.connectionless as productconnectionless
import miniquake2.platform.udp as productudp

const DEFAULT_PORT = 27910
const MAX_BROWSER_SERVERS = 8
const BROWSER_MSEC = 1200
const PREFERENCES_HEADER = "MiniQuake2Multiplayer 1"

struct Endpoint
  address
  port
end struct

struct ServerEntry
  endpoint
  description
  ping
  responseTime
end struct

struct ServerBrowser
  socket
  entries
  started
  deadline
  active
end struct

struct PlayerProfile
  name
  model
  skin
  hand
  rate
end struct

struct DownloadPolicy
  allow
  maps
  models
  players
  sounds
end struct

struct ServerOptions
  mapName
  hostname
  cooperative
  maxClients
  timeLimit
  fragLimit
  dmFlags
end struct

struct ProductLifecycle
  dataRoot
  phase
  connectedEndpoint
  mapName
  generation
end struct

struct MultiplayerPreferences
  profile
  downloads
  addresses
end struct

function retailRootValid(root)
  if typeof(root) != "string" or root == "" then return false end if
  base = productfs.joinPath(root, "baseq2")
  pak = productfs.joinPath(base, "pak0.pak")
  if not productfs.isDir(base) or not productfs.isFile(pak) then return false end if
  size = try(productfs.fileSize(pak))
  return size is not error and size >= 12
end function

function standardRetailCandidates()
  return [".", "..\\Quake 2", "C:\\Program Files (x86)\\Steam\\steamapps\\common\\Quake 2",
    "C:\\Program Files\\Steam\\steamapps\\common\\Quake 2",
    "C:\\GOG Games\\Quake II"]
end function

function loadSelectedRoot(path)
  if typeof(path) != "string" or path == "" or not productfs.isFile(path) then return "" end if
  value = try(productfs.readAllText(path))
  if value is error then return "" end if
  value = productstring.trim(value)
  if retailRootValid(value) then return value end if
  return ""
end function

function persistSelectedRoot(path, root)
  if typeof(path) != "string" or path == "" then return error(9944, "data-root selection path is missing") end if
  if not retailRootValid(root) then return error(9945, "selected Quake II data root has no valid baseq2/pak0.pak") end if
  temporary = path + ".tmp"
  productfs.writeAllText(temporary, root + "\n")
  verified = productstring.trim(productfs.readAllText(temporary))
  if verified != root then productfs.delete(temporary); return error(9946, "data-root selection verification failed") end if
  return productfs.moveFile(temporary, path, true)
end function

function discoverRetailRoot(selectionPath, candidates)
  selected = loadSelectedRoot(selectionPath)
  if selected != "" then return selected end if
  if typeof(candidates) != "array" then return error(9947, "retail root candidates must be an array") end if
  for each candidate in candidates
    if retailRootValid(candidate) then return candidate end if
  end for
  return error(9947, "Quake II retail data not found; use --data-root ROOT once or place baseq2 beside MiniQuake2")
end function

function parsePort(value)
  if typeof(value) != "string" or value == "" then return error(9958, "server port is empty") end if
  number = try(toNumber(value))
  if number is error or typeof(number) != "int" or number < 1 or number > 65535 then
    return error(9958, "server port outside [1,65535]")
  end if
  return number
end function

function parseEndpoint(value)
  if typeof(value) != "string" or value == "" or len(bytes(value)) > 63 then
    return error(9957, "server endpoint is invalid")
  end if
  source = bytes(value)
  separator = -1
  index = 0
  while index < len(source)
    if source[index] == 58 then
      if separator >= 0 then return error(9957, "server endpoint has multiple port separators") end if
      separator = index
    end if
    index = index + 1
  end while
  address = value
  port = DEFAULT_PORT
  if separator >= 0 then
    if separator == 0 or separator == len(source) - 1 then return error(9957, "server endpoint is incomplete") end if
    address = decode(slice(source, 0, separator))
    port = parsePort(decode(slice(source, separator + 1, len(source) - separator - 1)))
  end if
  // NET_StringToSockaddr accepts both dotted IPv4 and DNS host names. Resolve
  // once at the product boundary so the managed transport continues to own a
  // stable numeric endpoint for sender comparisons and Netchan state.
  resolvedAddress = try(productudp.resolveName(address))
  if resolvedAddress is error then
    return error(9957, "server host name could not be resolved")
  end if
  octets = productstring.split(resolvedAddress, ".")
  if typeof(octets) != "array" or len(octets) != 4 then return error(9957, "server address must be numeric IPv4") end if
  for each octet in octets
    parsed = try(toNumber(octet))
    if parsed is error or typeof(parsed) != "int" or parsed < 0 or parsed > 255 then
      return error(9957, "server address contains an invalid IPv4 octet")
    end if
  end for
  return Endpoint(resolvedAddress, port)
end function

function endpointText(endpoint)
  return endpoint.address + ":" + endpoint.port
end function

function createBrowser()
  return ServerBrowser(void, array(MAX_BROWSER_SERVERS), 0, 0, false)
end function

function browserEntryCount(browser)
  count = 0
  while count < len(browser.entries) and browser.entries[count] is not void
    count = count + 1
  end while
  return count
end function

function addBrowserEntry(browser, endpoint, description, now)
  count = browserEntryCount(browser)
  text = endpointText(endpoint)
  index = 0
  while index < count
    if endpointText(browser.entries[index].endpoint) == text then
      browser.entries[index].description = description
      browser.entries[index].ping = now - browser.started
      browser.entries[index].responseTime = now
      return browser.entries[index]
    end if
    index = index + 1
  end while
  if count >= MAX_BROWSER_SERVERS then return false end if
  entry = ServerEntry(endpoint, description, now - browser.started, now)
  browser.entries[count] = entry
  return entry
end function

function startBrowser(browser, addresses, now)
  if browser.active then productudp.close(browser.socket) end if
  browser.entries = array(MAX_BROWSER_SERVERS)
  browser.socket = productudp.open("0.0.0.0", 0)
  broadcastEnabled = try(productudp.enableBroadcast(browser.socket))
  browser.started = now
  browser.deadline = now + BROWSER_MSEC
  browser.active = true
  requested = []
  // A broadcast probe mirrors the classic local-server scan. Explicit
  // address-book targets remain available when a host policy rejects it.
  if broadcastEnabled is not error then
    requested = requested + ["255.255.255.255:27910"]
  end if
  if typeof(addresses) == "array" then requested = requested + addresses end if
  for each address in requested
    parsed = try(parseEndpoint(address))
    if parsed is not error then
      sent = try(productudp.send(browser.socket, parsed.address, parsed.port,
        productconnectionless.info()))
    end if
  end for
  return true
end function

function pumpBrowser(browser, now)
  if not browser.active then return 0 end if
  received = 0
  datagram = productudp.receive(browser.socket, 1400)
  while datagram is not void
    packet = try(productconnectionless.parsePacket(datagram.data))
    if packet is not error and packet.command == "info" then
      description = productstring.trim(packet.remainder)
      if description == "" then description = datagram.address + ":" + datagram.port end if
      addBrowserEntry(browser, Endpoint(datagram.address, datagram.port), description, now)
      received = received + 1
    end if
    datagram = productudp.receive(browser.socket, 1400)
  end while
  if now >= browser.deadline then productudp.close(browser.socket); browser.active = false end if
  return received
end function

function closeBrowser(browser)
  if browser.active then productudp.close(browser.socket); browser.active = false; return true end if
  return false
end function

function defaultPlayerProfile()
  return PlayerProfile("MiniQuake2", "male", "grunt", 0, 25000)
end function

function playerProfileValid(profile)
  return typeof(profile) == "struct" and productinfo.componentValid(profile.name) and
    profile.name != "" and len(bytes(profile.name)) <= 15 and
    productinfo.componentValid(profile.model) and profile.model != "" and
    productinfo.componentValid(profile.skin) and profile.skin != "" and
    typeof(profile.hand) == "int" and profile.hand >= 0 and profile.hand <= 2 and
    typeof(profile.rate) == "int" and profile.rate >= 2500 and profile.rate <= 100000
end function

function playerUserInfo(profile)
  if not playerProfileValid(profile) then return error(9959, "player profile is invalid") end if
  value = ""
  value = productinfo.setValueForKey(value, "name", profile.name)
  value = productinfo.setValueForKey(value, "skin", profile.model + "/" + profile.skin)
  value = productinfo.setValueForKey(value, "rate", profile.rate + "")
  value = productinfo.setValueForKey(value, "hand", profile.hand + "")
  return value
end function

function defaultDownloadPolicy()
  return DownloadPolicy(true, true, true, true, true)
end function

function defaultPreferences()
  return MultiplayerPreferences(defaultPlayerProfile(),
    defaultDownloadPolicy(), ["127.0.0.1:27910", "", "", "", "", "", "", ""])
end function

function preferenceTextSafe(value, maximum)
  if typeof(value) != "string" or len(bytes(value)) > maximum then return false end if
  for each preferenceByte in bytes(value)
    if preferenceByte < 32 or preferenceByte == 127 then return false end if
  end for
  return true
end function

function preferencesValid(preferences)
  if typeof(preferences) != "struct" or
      not playerProfileValid(preferences.profile) or
      not preferenceTextSafe(preferences.profile.name, 15) or
      not preferenceTextSafe(preferences.profile.model, 31) or
      not preferenceTextSafe(preferences.profile.skin, 31) or
      typeof(preferences.downloads) != "struct" or
      typeof(preferences.downloads.allow) != "bool" or
      typeof(preferences.downloads.maps) != "bool" or
      typeof(preferences.downloads.models) != "bool" or
      typeof(preferences.downloads.players) != "bool" or
      typeof(preferences.downloads.sounds) != "bool" or
      typeof(preferences.addresses) != "array" or
      len(preferences.addresses) != 8 then return false end if
  for each preferenceAddress in preferences.addresses
    if not preferenceTextSafe(preferenceAddress, 63) then return false end if
    if preferenceAddress != "" and try(parseEndpoint(preferenceAddress)) is error then
      return false
    end if
  end for
  return true
end function

function preferenceBool(value)
  if value then return 1 end if
  return 0
end function

function encodePreferences(preferences)
  if not preferencesValid(preferences) then return error(9970, "multiplayer preferences are invalid") end if
  value = PREFERENCES_HEADER + "\n" +
    "name=" + preferences.profile.name + "\n" +
    "model=" + preferences.profile.model + "\n" +
    "skin=" + preferences.profile.skin + "\n" +
    "hand=" + preferences.profile.hand + "\n" +
    "rate=" + preferences.profile.rate + "\n" +
    "download=" + preferenceBool(preferences.downloads.allow) + "\n" +
    "download_maps=" + preferenceBool(preferences.downloads.maps) + "\n" +
    "download_models=" + preferenceBool(preferences.downloads.models) + "\n" +
    "download_players=" + preferenceBool(preferences.downloads.players) + "\n" +
    "download_sounds=" + preferenceBool(preferences.downloads.sounds)
  preferenceAddressIndex = 0
  while preferenceAddressIndex < 8
    value = value + "\naddress" + preferenceAddressIndex + "=" +
      preferences.addresses[preferenceAddressIndex]
    preferenceAddressIndex = preferenceAddressIndex + 1
  end while
  return value
end function

function preferenceLine(lines, index, prefix)
  if index < 0 or index >= len(lines) or
      not producttext.startsWith(lines[index], prefix) then
    return error(9971, "multiplayer preference line is missing")
  end if
  count = len(bytes(lines[index])) - len(bytes(prefix))
  if count == 0 then return "" end if
  return decode(slice(bytes(lines[index]), len(bytes(prefix)), count))
end function

function preferenceInteger(value, minimum, maximum)
  parsed = try(toNumber(value))
  if parsed is error or typeof(parsed) != "int" or parsed < minimum or
      parsed > maximum then return error(9972, "multiplayer preference number is invalid") end if
  return parsed
end function

function preferenceBoolean(value)
  return preferenceInteger(value, 0, 1) != 0
end function

function decodePreferences(text)
  if typeof(text) != "string" or len(bytes(text)) > 4096 then return error(9973, "multiplayer preferences are empty or too large") end if
  lines = productstring.split(productstring.trim(text), "\n")
  if typeof(lines) != "array" or len(lines) != 19 or lines[0] != PREFERENCES_HEADER then
    return error(9973, "multiplayer preference header or line count is invalid")
  end if
  profile = PlayerProfile(preferenceLine(lines, 1, "name="),
    preferenceLine(lines, 2, "model="), preferenceLine(lines, 3, "skin="),
    preferenceInteger(preferenceLine(lines, 4, "hand="), 0, 2),
    preferenceInteger(preferenceLine(lines, 5, "rate="), 2500, 100000))
  downloads = DownloadPolicy(
    preferenceBoolean(preferenceLine(lines, 6, "download=")),
    preferenceBoolean(preferenceLine(lines, 7, "download_maps=")),
    preferenceBoolean(preferenceLine(lines, 8, "download_models=")),
    preferenceBoolean(preferenceLine(lines, 9, "download_players=")),
    preferenceBoolean(preferenceLine(lines, 10, "download_sounds=")))
  addresses = array(8, "")
  preferenceDecodeIndex = 0
  while preferenceDecodeIndex < 8
    addresses[preferenceDecodeIndex] = preferenceLine(lines,
      11 + preferenceDecodeIndex, "address" + preferenceDecodeIndex + "=")
    preferenceDecodeIndex = preferenceDecodeIndex + 1
  end while
  preferences = MultiplayerPreferences(profile, downloads, addresses)
  if not preferencesValid(preferences) then return error(9970, "multiplayer preferences are invalid") end if
  return preferences
end function

function loadPreferences(path)
  if typeof(path) != "string" or path == "" then return error(9974, "multiplayer preference path is missing") end if
  if not productfs.isFile(path) then return defaultPreferences() end if
  return decodePreferences(productfs.readAllText(path))
end function

function savePreferences(path, preferences)
  if typeof(path) != "string" or path == "" then return error(9974, "multiplayer preference path is missing") end if
  encoded = encodePreferences(preferences)
  temporary = path + ".tmp"
  productfs.writeAllText(temporary, encoded)
  verified = decodePreferences(productfs.readAllText(temporary))
  if not preferencesValid(verified) then productfs.delete(temporary); return error(9975, "multiplayer preference verification failed") end if
  return productfs.moveFile(temporary, path, true)
end function

function defaultServerOptions()
  return ServerOptions("q2dm1", "MiniQuake2", false, 8, 0, 0, 0)
end function

function createLifecycle(dataRoot)
  if not retailRootValid(dataRoot) then return error(9960, "product lifecycle requires valid retail data") end if
  return ProductLifecycle(dataRoot, "menu", "", "", 1)
end function

function beginLocal(lifecycle, mapName)
  if lifecycle.phase != "menu" and lifecycle.phase != "disconnected" then return error(9961, "local session transition requires menu state") end if
  lifecycle.phase = "loading"
  lifecycle.connectedEndpoint = "loopback"
  lifecycle.mapName = mapName
  lifecycle.generation = lifecycle.generation + 1
  return true
end function

function beginConnect(lifecycle, endpoint)
  if lifecycle.phase != "menu" and lifecycle.phase != "disconnected" then return error(9961, "connect transition requires menu state") end if
  parsed = parseEndpoint(endpoint)
  lifecycle.phase = "connecting"
  lifecycle.connectedEndpoint = endpointText(parsed)
  lifecycle.mapName = ""
  lifecycle.generation = lifecycle.generation + 1
  return true
end function

function activate(lifecycle, mapName)
  if lifecycle.phase != "loading" and lifecycle.phase != "connecting" then return error(9962, "activation requires a pending session") end if
  lifecycle.phase = "active"
  lifecycle.mapName = mapName
  return true
end function

function disconnect(lifecycle)
  if lifecycle.phase == "menu" or lifecycle.phase == "disconnected" then return false end if
  lifecycle.phase = "disconnected"
  lifecycle.connectedEndpoint = ""
  lifecycle.mapName = ""
  return true
end function

function returnToMenu(lifecycle)
  if lifecycle.phase != "disconnected" then return error(9963, "menu return requires disconnected state") end if
  lifecycle.phase = "menu"
  return true
end function
