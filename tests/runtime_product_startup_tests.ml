/* Product-root, endpoint, browser, profile and lifecycle policy tests. */
import miniquake2.runtime.product_startup as productstartup
import miniquake2.qcommon.info as productinfo

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
productStartupAssert(try(productstartup.parseEndpoint("localhost")) is error,
  "hostnames rejected by numeric native transport")
productStartupAssert(try(productstartup.parseEndpoint("127.0.0.1:70000")) is error,
  "oversized endpoint port rejected")

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
  "athena", 1, 25000)
productStartupUserInfo = productstartup.playerUserInfo(productStartupProfile)
productStartupAssert(productinfo.valueForKey(productStartupUserInfo, "name") == "Ranger" and
  productinfo.valueForKey(productStartupUserInfo, "skin") == "female/athena" and
  productinfo.valueForKey(productStartupUserInfo, "hand") == "1",
  "player profile publishes classic userinfo")
productStartupAssert(try(productstartup.playerUserInfo(
  productstartup.PlayerProfile("bad\\name", "male", "grunt", 0, 25000))) is error,
  "unsafe profile rejected")

productStartupPreferences = productstartup.MultiplayerPreferences(
  productStartupProfile,
  productstartup.DownloadPolicy(true, true, false, true, false),
  ["127.0.0.1:27910", "10.0.0.2:27911", "", "", "", "", "", ""])
productStartupPreferencesRoundTrip = productstartup.decodePreferences(
  productstartup.encodePreferences(productStartupPreferences))
productStartupAssert(productStartupPreferencesRoundTrip.profile.name == "Ranger" and
  not productStartupPreferencesRoundTrip.downloads.models and
  productStartupPreferencesRoundTrip.addresses[1] == "10.0.0.2:27911",
  "multiplayer preferences round trip")
productStartupAssert(try(productstartup.decodePreferences(
  "MiniQuake2Multiplayer 1\nname=broken")) is error,
  "truncated preferences rejected")

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
