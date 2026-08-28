/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Product-root, endpoint, browser, profile and lifecycle policy tests. */
import miniquake2.runtime.product_startup as productstartup
import miniquake2.qcommon.info as productinfo
import miniquake2.network.connectionless as producttestconnectionless
import miniquake2.platform.udp as producttestudp

// Assert the product startup test condition.
function productStartupAssert(value, name)
  if not value then return error(9964, "product startup: " + name) end if
  return true
end function

productStartupEndpoint = productstartup.parseEndpoint("127.0.0.1")
productStartupAssert(productStartupEndpoint.address == "127.0.0.1" and
  productStartupEndpoint.port == 27910, "default endpoint port")
productStartupEndpoint = productstartup.parseEndpoint("192.168.1.4:27911")
productStartupAssert(productstartup.endpointText(productStartupEndpoint) ==
  "192.168.1.4:27911", "explicit endpoint round trip")
productStartupEndpoint = productstartup.parseEndpoint("localhost:27912")
productStartupAssert(productStartupEndpoint.address == "127.0.0.1" and
  productStartupEndpoint.port == 27912,
  "host name resolved to stable numeric transport endpoint")
productStartupAssert(try(productstartup.parseEndpoint("127.0.0.1:70000")) is error,
  "oversized endpoint port rejected")

// The disconnected menu owns a short-lived nonblocking socket for RCON.
productStartupRconServer = producttestudp.open("127.0.0.1", 0)
productStartupRconTransport = productstartup.createRconTransport()
productStartupRconAction = productstartup.sendRcon(productStartupRconTransport,
  "127.0.0.1:" + productStartupRconServer.port, "secret", "status", 100)
productStartupRconDatagram = void
productStartupRconAttempts = 0
while productStartupRconDatagram is void and productStartupRconAttempts < 1000
  productStartupRconDatagram = producttestudp.receive(productStartupRconServer,
    1400)
  productStartupRconAttempts = productStartupRconAttempts + 1
end while
productStartupAssert(productStartupRconDatagram is not void,
  "main-menu RCON datagram delivered")
productStartupRconRequest = producttestconnectionless.parsePacket(
  productStartupRconDatagram.data)
productStartupAssert(productStartupRconRequest.arguments[0] == "rcon" and
  productStartupRconRequest.arguments[1] == "secret" and
  productStartupRconRequest.arguments[2] == "status",
  "main-menu RCON packet intent")
producttestudp.send(productStartupRconServer,
  productStartupRconDatagram.address, productStartupRconDatagram.port,
  producttestconnectionless.printReply("server status\n"))
productStartupRconReplies = []
productStartupRconAttempts = 0
while len(productStartupRconReplies) == 0 and productStartupRconAttempts < 1000
  productStartupRconReplies = productstartup.pumpRcon(
    productStartupRconTransport, 101)
  productStartupRconAttempts = productStartupRconAttempts + 1
end while
productStartupAssert(len(productStartupRconReplies) == 1 and
  productStartupRconReplies[0] == "server status\n" and
  not productStartupRconTransport.active,
  "matching RCON print reply routed and temporary socket closed")
productstartup.closeRconTransport(productStartupRconTransport)
producttestudp.close(productStartupRconServer)

productStartupBrowser = productstartup.createBrowser()
productStartupFirst = productstartup.addBrowserEntry(productStartupBrowser,
  productstartup.Endpoint("10.0.0.2", 27910), "LAN SERVER q2dm1 1/8", 110)
productStartupAssert(productStartupFirst is not void and
  productstartup.browserEntryCount(productStartupBrowser) == 1,
  "browser stores first response")
productstartup.addBrowserEntry(productStartupBrowser,
  productstartup.Endpoint("10.0.0.2", 27910), "LAN SERVER q2dm2 2/8", 130)
productStartupAssert(productstartup.browserEntryCount(productStartupBrowser) == 1 and
  productStartupBrowser.entries[0].description == "LAN SERVER q2dm2 2/8",
  "browser deduplicates and refreshes endpoint")

productStartupProfile = productstartup.PlayerProfile("Ranger", "female",
  "athena", 1, 25000, "secret", true, 110)
productStartupUserInfo = productstartup.playerUserInfo(productStartupProfile)
productStartupAssert(productinfo.valueForKey(productStartupUserInfo, "name") == "Ranger" and
  productinfo.valueForKey(productStartupUserInfo, "skin") == "female/athena" and
  productinfo.valueForKey(productStartupUserInfo, "hand") == "1" and
  productinfo.valueForKey(productStartupUserInfo, "password") == "secret" and
  productinfo.valueForKey(productStartupUserInfo, "spectator") == "1" and
  productinfo.valueForKey(productStartupUserInfo, "fov") == "110",
  "player profile publishes classic userinfo")
productStartupAssert(try(productstartup.playerUserInfo(
  productstartup.PlayerProfile("bad\\name", "male", "grunt", 0, 25000,
    "", false, 90))) is error,
  "unsafe profile rejected")

productStartupPreferences = productstartup.MultiplayerPreferences(
  productStartupProfile,
  productstartup.DownloadPolicy(true, true, false, true, false),
  ["127.0.0.1:27910", "10.0.0.2:27911", "", "", "", "", "", ""])
productStartupPreferencesRoundTrip = productstartup.decodePreferences(
  productstartup.encodePreferences(productStartupPreferences))
productStartupAssert(productStartupPreferencesRoundTrip.profile.name == "Ranger" and
  productStartupPreferencesRoundTrip.profile.password == "secret" and
  productStartupPreferencesRoundTrip.profile.spectator and
  productStartupPreferencesRoundTrip.profile.fov == 110 and
  not productStartupPreferencesRoundTrip.downloads.models and
  productStartupPreferencesRoundTrip.addresses[1] == "10.0.0.2:27911",
  "multiplayer preferences round trip")
productStartupAssert(try(productstartup.decodePreferences(
  "MiniQuake2Multiplayer 1\nname=broken")) is error,
  "truncated preferences rejected")

productStartupLegacyPreferences = productstartup.decodePreferences(
  "MiniQuake2Multiplayer 1\nname=Legacy\nmodel=male\nskin=grunt\nhand=0\nrate=25000\ndownload=1\ndownload_maps=1\ndownload_models=1\ndownload_players=1\ndownload_sounds=1\naddress0=127.0.0.1:27910\naddress1=\naddress2=\naddress3=\naddress4=\naddress5=\naddress6=\naddress7=")
productStartupAssert(productStartupLegacyPreferences.profile.password == "" and
  not productStartupLegacyPreferences.profile.spectator and
  productStartupLegacyPreferences.profile.fov == 90,
  "legacy preferences receive classic userinfo defaults")

productStartupLifecycle = productstartup.ProductLifecycle("test", "menu", "", "", 1)
productstartup.beginLocal(productStartupLifecycle, "base1")
productStartupAssert(productStartupLifecycle.phase == "loading" and
  productStartupLifecycle.connectedEndpoint == "loopback", "menu to local loading")
productstartup.activate(productStartupLifecycle, "base1")
productStartupAssert(productStartupLifecycle.phase == "active", "loading to active")
productstartup.disconnect(productStartupLifecycle)
productstartup.returnToMenu(productStartupLifecycle)
productStartupAssert(productStartupLifecycle.phase == "menu" and
  productStartupLifecycle.connectedEndpoint == "", "clean disconnect to menu")
productstartup.beginConnect(productStartupLifecycle, "127.0.0.1:27910")
productStartupAssert(productStartupLifecycle.phase == "connecting" and
  productStartupLifecycle.connectedEndpoint == "127.0.0.1:27910",
  "menu to remote connecting")

productStartupAssert(try(productstartup.discoverRetailRoot("missing-selection.txt",
  ["missing-root-a", "missing-root-b"])) is error,
  "missing retail roots produce actionable failure")
print "runtime_product_startup_tests: PASS"
