//! Provides miniquake2 runtime product startup facilities for this project.

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
import miniquake2.network.client as productnetworkclient
import miniquake2.network.runtime.transport as producttransport
import miniquake2.platform.udp as productudp

/// Defines the default port constant used by the miniquake2 runtime product startup module.
const DEFAULT_PORT = 27910
/// Defines the max browser servers constant used by the miniquake2 runtime product startup module.
const MAX_BROWSER_SERVERS = 8
/// Defines the browser msec constant used by the miniquake2 runtime product startup module.
const BROWSER_MSEC = 1200
/// Defines the preferences header constant used by the miniquake2 runtime product startup module.
const PREFERENCES_HEADER = "MiniQuake2Multiplayer 2"
/// Defines the preferences legacy header constant used by the miniquake2 runtime product startup module.
const PREFERENCES_LEGACY_HEADER = "MiniQuake2Multiplayer 1"

/// Store endpoint data.
struct Endpoint
  /// Stores the address value associated with endpoint.
  address
  /// Stores the port value associated with endpoint.
  port
end struct

/// Store server entry data.
struct ServerEntry
  /// Stores the endpoint value associated with server entry.
  endpoint
  /// Stores the description value associated with server entry.
  description
  /// Stores the ping value associated with server entry.
  ping
  /// Stores the response time value associated with server entry.
  responseTime
end struct

/// Store server browser data.
struct ServerBrowser
  /// Stores the socket value associated with server browser.
  socket
  /// Stores the entries value associated with server browser.
  entries
  /// Stores the started value associated with server browser.
  started
  /// Stores the deadline value associated with server browser.
  deadline
  /// Stores the active value associated with server browser.
  active
end struct

/// Store a short-lived main-menu RCON exchange.
struct RconTransport
  /// Stores the socket value associated with rcon transport.
  socket
  /// Stores the endpoint value associated with rcon transport.
  endpoint
  /// Stores the deadline value associated with rcon transport.
  deadline
  /// Stores the active value associated with rcon transport.
  active
end struct

/// Store player profile data.
struct PlayerProfile
  /// Stores the name value associated with player profile.
  name
  /// Stores the model value associated with player profile.
  model
  /// Stores the skin value associated with player profile.
  skin
  /// Stores the hand value associated with player profile.
  hand
  /// Stores the rate value associated with player profile.
  rate
  /// Stores the password value associated with player profile.
  password
  /// Stores the spectator value associated with player profile.
  spectator
  /// Stores the fov value associated with player profile.
  fov
end struct

/// Store download policy data.
struct DownloadPolicy
  /// Stores the allow value associated with download policy.
  allow
  /// Stores the maps value associated with download policy.
  maps
  /// Stores the models value associated with download policy.
  models
  /// Stores the players value associated with download policy.
  players
  /// Stores the sounds value associated with download policy.
  sounds
end struct

/// Store server options data.
struct ServerOptions
  /// Stores the map name value associated with server options.
  mapName
  /// Stores the hostname value associated with server options.
  hostname
  /// Stores the cooperative value associated with server options.
  cooperative
  /// Stores the max clients value associated with server options.
  maxClients
  /// Stores the time limit value associated with server options.
  timeLimit
  /// Stores the frag limit value associated with server options.
  fragLimit
  /// Stores the dm flags value associated with server options.
  dmFlags
end struct

/// Store product lifecycle data.
struct ProductLifecycle
  /// Stores the data root value associated with product lifecycle.
  dataRoot
  /// Stores the phase value associated with product lifecycle.
  phase
  /// Stores the connected endpoint value associated with product lifecycle.
  connectedEndpoint
  /// Stores the map name value associated with product lifecycle.
  mapName
  /// Stores the generation value associated with product lifecycle.
  generation
end struct

/// Store multiplayer preferences data.
struct MultiplayerPreferences
  /// Stores the profile value associated with multiplayer preferences.
  profile
  /// Stores the downloads value associated with multiplayer preferences.
  downloads
  /// Stores the addresses value associated with multiplayer preferences.
  addresses
end struct

/// Report whether retail root valid.
/// @param root root value consumed by this operation.
function retailRootValid(root)
  if typeof(root) != "string" or root == "" then return false end if
  base = productfs.joinPath(root, "baseq2")
  pak = productfs.joinPath(base, "pak0.pak")
  if not productfs.isDir(base) or not productfs.isFile(pak) then return false end if
  size = try(productfs.fileSize(pak))
  return size is not error and size >= 12
end function

/// Return the standard retail candidates value.
function standardRetailCandidates()
  return [".", "..\\Quake 2", "C:\\Program Files (x86)\\Steam\\steamapps\\common\\Quake 2",
    "C:\\Program Files\\Steam\\steamapps\\common\\Quake 2",
    "C:\\GOG Games\\Quake II"]
end function

/// Load selected root.
/// @param path Path of the file or directory used by the operation.
function loadSelectedRoot(path)
  if typeof(path) != "string" or path == "" or not productfs.isFile(path) then return "" end if
  value = try(productfs.readAllText(path))
  if value is error then return "" end if
  value = productstring.trim(value)
  if retailRootValid(value) then return value end if
  return ""
end function

/// Persist selected root.
/// @param path Path of the file or directory used by the operation.
/// @param root root value consumed by this operation.
function persistSelectedRoot(path, root)
  if typeof(path) != "string" or path == "" then return error(9944, "data-root selection path is missing") end if
  if not retailRootValid(root) then return error(9945, "selected Quake II data root has no valid baseq2/pak0.pak") end if
  temporary = path + ".tmp"
  productfs.writeAllText(temporary, root + "\n")
  verified = productstring.trim(productfs.readAllText(temporary))
  if verified != root then productfs.delete(temporary); return error(9946, "data-root selection verification failed") end if
  return productfs.moveFile(temporary, path, true)
end function

/// Discover retail root.
/// @param selectionPath Path associated with selection.
/// @param candidates candidates value consumed by this operation.
function discoverRetailRoot(selectionPath, candidates)
  selected = loadSelectedRoot(selectionPath)
  if selected != "" then return selected end if
  if typeof(candidates) != "array" then return error(9947, "retail root candidates must be an array") end if
  for each candidate in candidates
    if retailRootValid(candidate) then return candidate end if
  end for
  return error(9947, "Quake II retail data not found; use --data-root ROOT once or place baseq2 beside MiniQuake2")
end function

/// Parse port.
/// @param value Value consumed or transformed by the operation.
function parsePort(value)
  if typeof(value) != "string" or value == "" then return error(9958, "server port is empty") end if
  number = try(toNumber(value))
  if number is error or typeof(number) != "int" or number < 1 or number > 65535 then
    return error(9958, "server port outside [1,65535]")
  end if
  return number
end function

/// Parse endpoint.
/// @param value Value consumed or transformed by the operation.
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

/// Return the endpoint text value.
/// @param endpoint endpoint value consumed by this operation.
function endpointText(endpoint)
  return endpoint.address + ":" + endpoint.port
end function

/// Create browser.
function createBrowser()
  return ServerBrowser(void, array(MAX_BROWSER_SERVERS), 0, 0, false)
end function

/// Return the browser entry count.
/// @param browser browser value consumed by this operation.
function browserEntryCount(browser)
  count = 0
  while count < len(browser.entries) and browser.entries[count] is not void
    count = count + 1
  end while
  return count
end function

/// Add browser entry.
/// @param browser browser value consumed by this operation.
/// @param endpoint endpoint value consumed by this operation.
/// @param description description value consumed by this operation.
/// @param now now value consumed by this operation.
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

/// Start browser.
/// @param browser browser value consumed by this operation.
/// @param addresses addresses value consumed by this operation.
/// @param now now value consumed by this operation.
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

/// Pump browser.
/// @param browser browser value consumed by this operation.
/// @param now now value consumed by this operation.
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

/// Close browser.
/// @param browser browser value consumed by this operation.
function closeBrowser(browser)
  if browser.active then productudp.close(browser.socket); browser.active = false; return true end if
  return false
end function

/// Create a disconnected-console RCON transport without retaining a socket.
function createRconTransport()
  return RconTransport(void, void, 0, false)
end function

/// Send one validated connectionless RCON request from a temporary UDP socket.
/// @param transport transport value consumed by this operation.
/// @param endpointTextValue endpointTextValue value consumed by this operation.
/// @param password password value consumed by this operation.
/// @param command command value consumed by this operation.
/// @param now now value consumed by this operation.
function sendRcon(transport, endpointTextValue, password, command, now)
  if typeof(transport) != "struct" or typeof(now) != "int" then
    return error(9976, "rcon transport inputs are invalid")
  end if
  endpoint = parseEndpoint(endpointTextValue)
  address = producttransport.fromUdp(endpoint.address, endpoint.port)
  client = productnetworkclient.create(0, 1000)
  action = productnetworkclient.rconAction(client, address, password, command)
  if transport.socket is void or transport.socket.closed then
    transport.socket = productudp.open("0.0.0.0", 0)
  end if
  productudp.send(transport.socket, endpoint.address, endpoint.port, action.data)
  transport.endpoint = endpoint
  transport.deadline = now + BROWSER_MSEC
  transport.active = true
  return action
end function

/// Pump matching print replies without blocking the menu presentation loop.
/// @param transport transport value consumed by this operation.
/// @param now now value consumed by this operation.
function pumpRcon(transport, now)
  if typeof(transport) != "struct" or typeof(now) != "int" then
    return error(9976, "rcon pump inputs are invalid")
  end if
  replies = []
  if not transport.active or transport.socket is void then return replies end if
  datagram = productudp.receive(transport.socket, 1400)
  while datagram is not void
    if datagram.address == transport.endpoint.address and
        datagram.port == transport.endpoint.port then
      packet = try(productconnectionless.parsePacket(datagram.data))
      if packet is not error and packet.command == "print" then
        replies = replies + [packet.remainder]
      end if
    end if
    datagram = productudp.receive(transport.socket, 1400)
  end while
  if len(replies) > 0 or now >= transport.deadline then
    productudp.close(transport.socket)
    transport.active = false
  end if
  return replies
end function

/// Close an outstanding main-menu RCON exchange.
/// @param transport transport value consumed by this operation.
function closeRconTransport(transport)
  if transport.socket is not void and not transport.socket.closed then
    productudp.close(transport.socket)
  end if
  transport.active = false
  return true
end function

/// Return the default player profile value.
function defaultPlayerProfile()
  return PlayerProfile("MiniQuake2", "male", "grunt", 0, 25000, "", false, 90)
end function

/// Report whether player profile valid.
/// @param profile profile value consumed by this operation.
function playerProfileValid(profile)
  return typeof(profile) == "struct" and productinfo.componentValid(profile.name) and
    profile.name != "" and len(bytes(profile.name)) <= 15 and
    productinfo.componentValid(profile.model) and profile.model != "" and
    productinfo.componentValid(profile.skin) and profile.skin != "" and
    typeof(profile.hand) == "int" and profile.hand >= 0 and profile.hand <= 2 and
    typeof(profile.rate) == "int" and profile.rate >= 2500 and profile.rate <= 100000 and
    productinfo.componentValid(profile.password) and len(bytes(profile.password)) <= 63 and
    typeof(profile.spectator) == "bool" and typeof(profile.fov) == "int" and
    profile.fov >= 1 and profile.fov <= 160
end function

/// Return the player user info value.
/// @param profile profile value consumed by this operation.
function playerUserInfo(profile)
  if not playerProfileValid(profile) then return error(9959, "player profile is invalid") end if
  value = ""
  value = productinfo.setValueForKey(value, "name", profile.name)
  value = productinfo.setValueForKey(value, "skin", profile.model + "/" + profile.skin)
  value = productinfo.setValueForKey(value, "rate", profile.rate + "")
  value = productinfo.setValueForKey(value, "hand", profile.hand + "")
  value = productinfo.setValueForKey(value, "password", profile.password)
  playerSpectator = 0
  if profile.spectator then playerSpectator = 1 end if
  value = productinfo.setValueForKey(value, "spectator", playerSpectator + "")
  value = productinfo.setValueForKey(value, "fov", profile.fov + "")
  return value
end function

/// Return the default download policy value.
function defaultDownloadPolicy()
  return DownloadPolicy(true, true, true, true, true)
end function

/// Return the default preferences value.
function defaultPreferences()
  return MultiplayerPreferences(defaultPlayerProfile(),
    defaultDownloadPolicy(), ["127.0.0.1:27910", "", "", "", "", "", "", ""])
end function

/// Return the preference text safe value.
/// @param value Value consumed or transformed by the operation.
/// @param maximum maximum value consumed by this operation.
function preferenceTextSafe(value, maximum)
  if typeof(value) != "string" or len(bytes(value)) > maximum then return false end if
  for each preferenceByte in bytes(value)
    if preferenceByte < 32 or preferenceByte == 127 then return false end if
  end for
  return true
end function

/// Report whether preferences valid.
/// @param preferences preferences value consumed by this operation.
function preferencesValid(preferences)
  if typeof(preferences) != "struct" or
      not playerProfileValid(preferences.profile) or
      not preferenceTextSafe(preferences.profile.name, 15) or
      not preferenceTextSafe(preferences.profile.model, 31) or
      not preferenceTextSafe(preferences.profile.skin, 31) or
      not preferenceTextSafe(preferences.profile.password, 63) or
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

/// Return the preference bool value.
/// @param value Value consumed or transformed by the operation.
function preferenceBool(value)
  if value then return 1 end if
  return 0
end function

/// Encode preferences.
/// @param preferences preferences value consumed by this operation.
function encodePreferences(preferences)
  if not preferencesValid(preferences) then return error(9970, "multiplayer preferences are invalid") end if
  value = PREFERENCES_HEADER + "\n" +
    "name=" + preferences.profile.name + "\n" +
    "model=" + preferences.profile.model + "\n" +
    "skin=" + preferences.profile.skin + "\n" +
    "hand=" + preferences.profile.hand + "\n" +
    "rate=" + preferences.profile.rate + "\n" +
    "password=" + preferences.profile.password + "\n" +
    "spectator=" + preferenceBool(preferences.profile.spectator) + "\n" +
    "fov=" + preferences.profile.fov + "\n" +
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

/// Return the preference line value.
/// @param lines lines value consumed by this operation.
/// @param index Zero-based index of the affected item.
/// @param prefix prefix value consumed by this operation.
function preferenceLine(lines, index, prefix)
  if index < 0 or index >= len(lines) or
      not producttext.startsWith(lines[index], prefix) then
    return error(9971, "multiplayer preference line is missing")
  end if
  count = len(bytes(lines[index])) - len(bytes(prefix))
  if count == 0 then return "" end if
  return decode(slice(bytes(lines[index]), len(bytes(prefix)), count))
end function

/// Return the preference integer value.
/// @param value Value consumed or transformed by the operation.
/// @param minimum minimum value consumed by this operation.
/// @param maximum maximum value consumed by this operation.
function preferenceInteger(value, minimum, maximum)
  parsed = try(toNumber(value))
  if parsed is error or typeof(parsed) != "int" or parsed < minimum or
      parsed > maximum then return error(9972, "multiplayer preference number is invalid") end if
  return parsed
end function

/// Return the preference boolean value.
/// @param value Value consumed or transformed by the operation.
function preferenceBoolean(value)
  return preferenceInteger(value, 0, 1) != 0
end function

/// Decode preferences.
/// @param text Text consumed by the operation.
function decodePreferences(text)
  if typeof(text) != "string" or len(bytes(text)) > 4096 then return error(9973, "multiplayer preferences are empty or too large") end if
  lines = productstring.split(productstring.trim(text), "\n")
  if typeof(lines) != "array" or
      ((len(lines) != 22 or lines[0] != PREFERENCES_HEADER) and
       (len(lines) != 19 or lines[0] != PREFERENCES_LEGACY_HEADER)) then
    return error(9973, "multiplayer preference header or line count is invalid")
  end if
  preferenceVersion2 = lines[0] == PREFERENCES_HEADER
  preferencePassword = ""
  preferenceSpectator = false
  preferenceFov = 90
  preferenceDownloadStart = 6
  if preferenceVersion2 then
    preferencePassword = preferenceLine(lines, 6, "password=")
    preferenceSpectator = preferenceBoolean(preferenceLine(lines, 7, "spectator="))
    preferenceFov = preferenceInteger(preferenceLine(lines, 8, "fov="), 1, 160)
    preferenceDownloadStart = 9
  end if
  profile = PlayerProfile(preferenceLine(lines, 1, "name="),
    preferenceLine(lines, 2, "model="), preferenceLine(lines, 3, "skin="),
    preferenceInteger(preferenceLine(lines, 4, "hand="), 0, 2),
    preferenceInteger(preferenceLine(lines, 5, "rate="), 2500, 100000),
    preferencePassword, preferenceSpectator, preferenceFov)
  downloads = DownloadPolicy(
    preferenceBoolean(preferenceLine(lines, preferenceDownloadStart, "download=")),
    preferenceBoolean(preferenceLine(lines, preferenceDownloadStart + 1, "download_maps=")),
    preferenceBoolean(preferenceLine(lines, preferenceDownloadStart + 2, "download_models=")),
    preferenceBoolean(preferenceLine(lines, preferenceDownloadStart + 3, "download_players=")),
    preferenceBoolean(preferenceLine(lines, preferenceDownloadStart + 4, "download_sounds=")))
  addresses = array(8, "")
  preferenceDecodeIndex = 0
  while preferenceDecodeIndex < 8
    addresses[preferenceDecodeIndex] = preferenceLine(lines,
      preferenceDownloadStart + 5 + preferenceDecodeIndex,
      "address" + preferenceDecodeIndex + "=")
    preferenceDecodeIndex = preferenceDecodeIndex + 1
  end while
  preferences = MultiplayerPreferences(profile, downloads, addresses)
  if not preferencesValid(preferences) then return error(9970, "multiplayer preferences are invalid") end if
  return preferences
end function

/// Load preferences.
/// @param path Path of the file or directory used by the operation.
function loadPreferences(path)
  if typeof(path) != "string" or path == "" then return error(9974, "multiplayer preference path is missing") end if
  if not productfs.isFile(path) then return defaultPreferences() end if
  return decodePreferences(productfs.readAllText(path))
end function

/// Save preferences.
/// @param path Path of the file or directory used by the operation.
/// @param preferences preferences value consumed by this operation.
function savePreferences(path, preferences)
  if typeof(path) != "string" or path == "" then return error(9974, "multiplayer preference path is missing") end if
  encoded = encodePreferences(preferences)
  temporary = path + ".tmp"
  productfs.writeAllText(temporary, encoded)
  verified = decodePreferences(productfs.readAllText(temporary))
  if not preferencesValid(verified) then productfs.delete(temporary); return error(9975, "multiplayer preference verification failed") end if
  return productfs.moveFile(temporary, path, true)
end function

/// Return the default server options value.
function defaultServerOptions()
  return ServerOptions("q2dm1", "MiniQuake2", false, 8, 0, 0, 0)
end function

/// Create lifecycle.
/// @param dataRoot dataRoot value consumed by this operation.
function createLifecycle(dataRoot)
  if not retailRootValid(dataRoot) then return error(9960, "product lifecycle requires valid retail data") end if
  return ProductLifecycle(dataRoot, "menu", "", "", 1)
end function

/// Begin local.
/// @param lifecycle lifecycle value consumed by this operation.
/// @param mapName mapName value consumed by this operation.
function beginLocal(lifecycle, mapName)
  if lifecycle.phase != "menu" and lifecycle.phase != "disconnected" then return error(9961, "local session transition requires menu state") end if
  lifecycle.phase = "loading"
  lifecycle.connectedEndpoint = "loopback"
  lifecycle.mapName = mapName
  lifecycle.generation = lifecycle.generation + 1
  return true
end function

/// Begin connect.
/// @param lifecycle lifecycle value consumed by this operation.
/// @param endpoint endpoint value consumed by this operation.
function beginConnect(lifecycle, endpoint)
  if lifecycle.phase != "menu" and lifecycle.phase != "disconnected" then return error(9961, "connect transition requires menu state") end if
  parsed = parseEndpoint(endpoint)
  lifecycle.phase = "connecting"
  lifecycle.connectedEndpoint = endpointText(parsed)
  lifecycle.mapName = ""
  lifecycle.generation = lifecycle.generation + 1
  return true
end function

/// Performs the activate operation for the miniquake2 runtime product startup module.
/// @param lifecycle lifecycle value consumed by this operation.
/// @param mapName mapName value consumed by this operation.
function activate(lifecycle, mapName)
  if lifecycle.phase != "loading" and lifecycle.phase != "connecting" then return error(9962, "activation requires a pending session") end if
  lifecycle.phase = "active"
  lifecycle.mapName = mapName
  return true
end function

/// Return the disconnect value.
/// @param lifecycle lifecycle value consumed by this operation.
function disconnect(lifecycle)
  if lifecycle.phase == "menu" or lifecycle.phase == "disconnected" then return false end if
  lifecycle.phase = "disconnected"
  lifecycle.connectedEndpoint = ""
  lifecycle.mapName = ""
  return true
end function

/// Return to menu.
/// @param lifecycle lifecycle value consumed by this operation.
function returnToMenu(lifecycle)
  if lifecycle.phase != "disconnected" then return error(9963, "menu return requires disconnected state") end if
  lifecycle.phase = "menu"
  return true
end function
