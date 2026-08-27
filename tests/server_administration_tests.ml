/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Server administration, IP filtering, RCON and master lifecycle contracts. */
import std.fs as admintestfs
import miniquake2.qcommon.types as admintestqt
import miniquake2.protocol.packet as admintestpacket
import miniquake2.network.constants as admintestnc
import miniquake2.network.connectionless as admintestconnectionless
import miniquake2.network.server as admintestserver
import miniquake2.network.runtime.types as admintestrtypes
import miniquake2.network.runtime.commands as admintestcommands
import miniquake2.network.runtime.game_adapter as admintestgame
import miniquake2.server.administration as admintestadmin
import miniquake2.platform.udp as admintestudp
import miniquake2.platform.system as admintestsystem
import miniquake2.network.runtime.pump as admintestpump

// Assert the admin test condition.
function adminAssert(value, message)
  if not value then return error(9988, message) end if
  return true
end function

// Report whether admin equal.
function adminEqual(actual, expected, message)
  if actual != expected then
    return error(9989, message + ": expected " + expected + ", got " + actual)
  end if
  return true
end function

// Report whether admin contains.
function adminContains(value, wanted)
  source = bytes(value)
  needle = bytes(wanted)
  if len(needle) == 0 then return true end if
  start = 0
  while start + len(needle) <= len(source)
    matched = true
    index = 0
    while index < len(needle)
      if source[start + index] != needle[index] then matched = false; break end if
      index = index + 1
    end while
    if matched then return true end if
    start = start + 1
  end while
  return false
end function

// Return the admin ip value.
function adminIp(a, b, c, d, port)
  return admintestqt.NetAddress(admintestnc.NA_IP, [a, b, c, d],
    array(10, 0), port)
end function

// Create admin runtime.
function makeAdminRuntime(dedicated)
  server = admintestserver.create(4, "Admin Test", "base1",
    "\\hostname\\Admin Test\\mapname\\base1", dedicated, false)
  return admintestrtypes.createServer(server, 1, "baseq2", "base1",
    admintestgame.permissive())
end function

// Verify filters and persistence.
function testFiltersAndPersistence()
  state = admintestadmin.create()
  adminEqual(admintestadmin.addIp(state, "192.246.40"), "", "addip")
  adminAssert(admintestadmin.filterPacket(state,
    adminIp(192, 246, 40, 77, 27910)), "class-C filter did not ban match")
  adminAssert(not admintestadmin.filterPacket(state,
    adminIp(192, 246, 41, 77, 27910)), "class-C filter banned non-match")
  admintestadmin.setFilterBan(state, "0")
  adminAssert(not admintestadmin.filterPacket(state,
    adminIp(192, 246, 40, 77, 27910)), "allowlist rejected match")
  adminAssert(admintestadmin.filterPacket(state,
    adminIp(203, 0, 113, 8, 27910)), "allowlist admitted non-match")
  adminAssert(try(admintestadmin.parseFilter("192..40")) is error,
    "malformed filter accepted")
  adminEqual(admintestadmin.removeIp(state, "192.246.40"), "Removed.\n",
    "removeip")

  path = "build\\server_administration_listip_test.cfg"
  temporary = path + ".tmp"
  if admintestfs.exists(path) then admintestfs.delete(path) end if
  if admintestfs.exists(temporary) then admintestfs.delete(temporary) end if
  admintestadmin.addIp(state, "198.51.100.23")
  admintestadmin.setFilterBan(state, "1")
  admintestadmin.setWritePath(state, path)
  writeResult = admintestadmin.writeIp(state)
  adminAssert(adminContains(writeResult, "Writing"), "writeip did not report success")
  persisted = admintestfs.readAllText(path)
  adminAssert(adminContains(persisted, "set filterban 1") and
    adminContains(persisted, "sv addip 198.51.100.23"),
    "writeip content is not executable Quake II config")
  admintestfs.delete(path)
  return true
end function

// Verify connect filter and rcon.
function testConnectFilterAndRcon()
  runtime = makeAdminRuntime(true)
  remote = adminIp(203, 0, 113, 19, 30000)
  admintestadmin.addIp(runtime.administration, "203.0.113.19")
  blocked = admintestcommands.handleConnectionless(runtime, remote,
    admintestconnectionless.connect(7, 123, "\\name\\Blocked"), 1)
  adminEqual(blocked.message, "ip-filter", "connect IP filter boundary")
  adminEqual(admintestserver.connectedCount(runtime.server), 0,
    "filtered connect consumed a client slot")

  adminAssert(try(admintestadmin.setRconPassword(runtime.administration,
    "short")) is error, "weak RCON password accepted")
  admintestadmin.setRconPassword(runtime.administration, "correcthorse")
  rejected = admintestcommands.handleConnectionless(runtime, remote,
    admintestconnectionless.frameText("rcon wrong sv test"), 2)
  adminEqual(rejected.message, "rcon-rejected", "bad RCON password")
  rejectedText = admintestpacket.decodeConnectionlessText(rejected.actions[0].data)
  adminAssert(not adminContains(rejectedText, "wrong"), "RCON response leaked password")

  accepted = admintestcommands.handleConnectionless(runtime, remote,
    admintestconnectionless.frameText("rcon correcthorse sv test"), 3)
  adminEqual(accepted.message, "rcon", "valid RCON dispatch")
  acceptedPacket = admintestconnectionless.parsePacket(accepted.actions[0].data)
  adminAssert(adminContains(acceptedPacket.remainder, "Svcmd_Test_f()"),
    "RCON did not execute sv test")
  adminEqual(runtime.administration.rconAccepted, 1, "RCON accepted audit count")
  adminEqual(runtime.administration.rconRejected, 1, "RCON rejected audit count")

  filterIndex = 1
  while filterIndex <= 120
    admintestadmin.addIp(runtime.administration,
      "10.20.30." + filterIndex)
    filterIndex = filterIndex + 1
  end while
  bounded = admintestcommands.handleConnectionless(runtime, remote,
    admintestconnectionless.frameText("rcon correcthorse sv listip"), 4)
  adminAssert(len(bounded.actions[0].data) <= 1034,
    "RCON redirected output exceeded the 1024-byte stock boundary")
  return true
end function

// Verify masters.
function testMasters()
  runtime = makeAdminRuntime(true)
  output = admintestcommands.executeOperator(runtime,
    "setmaster 198.51.100.2:27950 203.0.113.4")
  adminAssert(adminContains(output, "198.51.100.2:27950") and
    adminContains(output, "203.0.113.4:27900"), "setmaster output")
  adminEqual(len(runtime.administration.masters), 2, "master count")
  adminAssert(runtime.server.publicServer, "setmaster did not publish server")
  adminEqual(len(admintestserver.masterPingActions(
    runtime.administration.masters)), 2, "master ping count")
  heartbeat = admintestserver.heartbeatActions(runtime.server,
    runtime.administration.masters, 0)
  adminEqual(len(heartbeat), 2, "forced master heartbeat count")
  adminEqual(admintestconnectionless.parsePacket(heartbeat[0].data).command,
    "heartbeat", "master heartbeat payload")
  shutdown = admintestserver.shutdownActions(runtime.server,
    runtime.administration.masters)
  adminEqual(len(shutdown), 2, "master shutdown count")
  adminEqual(admintestconnectionless.parsePacket(shutdown[0].data).command,
    "shutdown", "master shutdown payload")

  listenRuntime = makeAdminRuntime(false)
  listenOutput = admintestcommands.executeOperator(listenRuntime,
    "setmaster 198.51.100.2")
  adminAssert(adminContains(listenOutput, "Only dedicated"),
    "listen server accepted master configuration")
  return true
end function

// Verify master udp lifecycle.
function testMasterUdpLifecycle()
  masterSocket = admintestudp.open("127.0.0.1", 0)
  serverSocket = admintestudp.open("127.0.0.1", 0)
  runtime = makeAdminRuntime(true)
  admintestcommands.executeOperator(runtime,
    "setmaster 127.0.0.1:" + masterSocket.port)
  stats = admintestpump.pumpServer(runtime, serverSocket, 0, 4)
  adminEqual(stats.sent, 2, "master UDP ping/heartbeat sends")
  if not admintestudp.pending(masterSocket) then admintestsystem.sleep(1) end if
  commands = []
  while admintestudp.pending(masterSocket)
    packet = admintestudp.receive(masterSocket, 1400)
    commands = commands + [admintestconnectionless.parsePacket(packet.data).command]
  end while
  adminEqual(len(commands), 2, "master UDP ping/heartbeat receives")
  adminAssert((commands[0] == "ping" and commands[1] == "heartbeat") or
    (commands[0] == "heartbeat" and commands[1] == "ping"),
    "master UDP lifecycle payloads")

  shutdownStats = admintestpump.shutdownServer(runtime, serverSocket)
  adminEqual(shutdownStats.sent, 1, "master UDP shutdown send")
  if not admintestudp.pending(masterSocket) then admintestsystem.sleep(1) end if
  shutdownPacket = admintestudp.receive(masterSocket, 1400)
  adminEqual(admintestconnectionless.parsePacket(shutdownPacket.data).command,
    "shutdown", "master UDP shutdown receive")
  admintestudp.close(serverSocket)
  admintestudp.close(masterSocket)
  return true
end function

testFiltersAndPersistence()
testConnectFilterAndRcon()
testMasters()
testMasterUdpLifecycle()
print "server_administration_tests: PASS"
