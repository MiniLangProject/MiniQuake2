/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Real nonblocking UDP loopback handshake through Protocol 34 and Netchan. */
import miniquake2.platform.system as psystem
import miniquake2.platform.udp as pudp
import miniquake2.qcommon.types as qt
import miniquake2.network.constants as nc
import miniquake2.network.client as nclient
import miniquake2.network.server as nserver
import miniquake2.network.runtime.types as nrtypes
import miniquake2.network.runtime.game_adapter as rgame
import miniquake2.network.runtime.commands as rcommands
import miniquake2.network.runtime.pump as rpump

function assertEqual(actual, expected, name)
  if actual != expected then return error(7990, name + ": expected " + expected + ", got " + actual) end if
  return true
end function

function assertTrue(value, name)
  if value != true then return error(7991, name + ": expected true") end if
  return true
end function

serverSocket = pudp.open("127.0.0.1", 0)
clientSocket = pudp.open("127.0.0.1", 0)
serverAddress = qt.NetAddress(nc.NA_IP, [127, 0, 0, 1], array(10, 0), serverSocket.port)
client = nclient.create(0x3456, 5000)
nclient.beginConnect(client, "127.0.0.1", serverAddress, "\\name\\Loopback", 0)
clientRuntime = nrtypes.createClient(client)
server = nserver.create(2, "Loopback", "unit1", "\\hostname\\Loopback", false, false)
serverRuntime = nrtypes.createServer(server, 42, "baseq2", "Loopback Unit", rgame.permissive())
serverRuntime.configStrings[0] = "Loopback Unit"
baseline = serverRuntime.baselines[5]
baseline.modelIndex = 1
serverRuntime.baselines[5] = baseline

now = 0
attempt = 0
while client.state < nc.CA_CONNECTED and attempt < 100
  rpump.pumpPair(clientRuntime, serverRuntime, clientSocket, serverSocket, now, 32)
  psystem.sleep(1)
  now = now + 1
  attempt = attempt + 1
end while
assertEqual(client.state, nc.CA_CONNECTED, "loopback client connected")

attempt = 0
while clientRuntime.protocol != 34 and attempt < 100
  rpump.pumpPair(clientRuntime, serverRuntime, clientSocket, serverSocket, now, 32)
  psystem.sleep(1)
  now = now + 1
  attempt = attempt + 1
end while
assertEqual(clientRuntime.protocol, 34, "serverdata reached client")
assertEqual(clientRuntime.spawnCount, 42, "spawn count reached client")
assertTrue(len(clientRuntime.stuffedTexts) > 0, "configstring request supplied")

rcommands.writeStringCommand(client.channel.message, "configstrings 42 0")
attempt = 0
while clientRuntime.configStrings[0] == "" and attempt < 100
  rpump.pumpPair(clientRuntime, serverRuntime, clientSocket, serverSocket, now, 32)
  psystem.sleep(1)
  now = now + 1
  attempt = attempt + 1
end while
assertEqual(clientRuntime.configStrings[0], "Loopback Unit", "configstring over Netchan")

rcommands.writeStringCommand(client.channel.message, "baselines 42 0")
attempt = 0
while clientRuntime.baselines[5].modelIndex == 0 and attempt < 100
  rpump.pumpPair(clientRuntime, serverRuntime, clientSocket, serverSocket, now, 32)
  psystem.sleep(1)
  now = now + 1
  attempt = attempt + 1
end while
assertEqual(clientRuntime.baselines[5].modelIndex, 1, "baseline over Netchan")

pudp.close(clientSocket)
pudp.close(serverSocket)
print "network_runtime_loopback_tests: PASS"
