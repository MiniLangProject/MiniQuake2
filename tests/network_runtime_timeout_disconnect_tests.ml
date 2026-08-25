/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

SV_CheckTimeouts / SV_DropClient Game API callback parity tests.
*/
import miniquake2.network.constants as nc
import miniquake2.network.server as nserver
import miniquake2.network.runtime.types as nrtypes
import miniquake2.network.runtime.game_adapter as rgame
import miniquake2.network.runtime.pump as rpump

disconnectSlots = []

function recordDisconnect(slot)
  global disconnectSlots
  disconnectSlots = disconnectSlots + [slot]
  return true
end function

function assertEqual(actual, expected, name)
  if actual != expected then return error(7930, name + ": expected " + expected + ", got " + actual) end if
  return true
end function

function main(args)
  global disconnectSlots
  callbacks = rgame.createWithDisconnect(rgame.allowConnect, rgame.ignoreUserinfo,
    rgame.ignoreThink, rgame.ignoreCommand, rgame.ignoreBegin, recordDisconnect)
  server = nserver.create(3, "Timeout", "base1", "\\hostname\\Timeout", false, false)
  runtime = nrtypes.createServer(server, 1, "baseq2", "Timeout Test", callbacks)
  server.timeoutMsec = 1000

  // Only spawned clients own Game API state.  A merely connected client is
  // reclaimed without ClientDisconnect, exactly like Quake II 3.19.
  server.clients[0].state = nc.CS_SPAWNED
  server.clients[0].name = "Spawned"
  server.clients[0].lastMessage = 1
  server.clients[1].state = nc.CS_CONNECTED
  server.clients[1].name = "Connecting"
  server.clients[1].lastMessage = 1

  runtime.transfers[0] = nrtypes.DownloadTransfer("maps/base1.bsp", bytes([1, 2]), 1)
  runtime.deferredReliable[0] = [nrtypes.DeferredReliableWork(1, 1, 1)]
  runtime.ackPending[0] = true

  dropped = rpump.expireTimedOutClients(runtime, 1002)
  assertEqual(dropped, [0, 1], "timed-out slots")
  assertEqual(disconnectSlots, [0], "spawned Game API disconnect")
  assertEqual(server.clients[0].state, nc.CS_FREE, "spawned slot reclaimed")
  assertEqual(server.clients[1].state, nc.CS_FREE, "connected slot reclaimed")
  assertEqual(runtime.transfers[0].offset, -1, "download cleared")
  assertEqual(runtime.deferredReliable[0], [], "reliable work cleared")
  assertEqual(runtime.ackPending[0], false, "pending acknowledgement cleared")

  // No callback is repeated after the slot has already become free.
  assertEqual(rpump.expireTimedOutClients(runtime, 2003), [], "no repeated timeout")
  assertEqual(disconnectSlots, [0], "disconnect callback exactly once")
  print "network_runtime_timeout_disconnect_tests: PASS"
  return 0
end function
