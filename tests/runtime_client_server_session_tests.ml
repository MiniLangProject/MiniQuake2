/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Full synthetic signon and snapshot flow over real loopback UDP sockets. */
import miniquake2.network.constants as tcsnc
import miniquake2.runtime.client_session as tclient
import miniquake2.runtime.server_session as tserver

// Assert the equal test condition.
function assertEqual(actual, expected, name)
  if actual != expected then return error(9995, name + ": values differ") end if
  return true
end function

// Assert the true test condition.
function assertTrue(value, name)
  if value != true then return error(9996, name + ": expected true") end if
  return true
end function

// Run this source file's command-line entry point.
function main(args)
  print "MiniQuake2 client/server session tests starting: 1"
  text = "{ \"classname\" \"worldspawn\" } " +
    "{ \"classname\" \"info_player_start\" \"origin\" \"0 0 24\" } " +
    "{ \"classname\" \"monster_soldier\" \"origin\" \"64 0 24\" }"
  server = tserver.createCore("synthetic", text, void, "127.0.0.1", 0, 1, true)
  client = tclient.create("127.0.0.1", server.socket.port, "\\name\\Loopback", 0)
  iteration = 0
  while iteration < 40 and client.integrated.network.client.state != tcsnc.CA_ACTIVE
    tclient.step(client)
    tserver.step(server)
    tclient.step(client)
    iteration = iteration + 1
  end while
  assertEqual(client.integrated.network.client.state, tcsnc.CA_ACTIVE, "client reached active state")
  assertTrue(client.integrated.client.current is not void, "client accepted snapshot")
  assertTrue(server.networkRuntime.server.clients[0].state == tcsnc.CS_SPAWNED, "server spawned client")
  assertTrue(client.packetsReceived > 0 and server.packetsReceived > 0, "bidirectional datagrams")
  tclient.shutdown(client)
  tserver.shutdown(server)
  print "MiniQuake2 client/server session tests passed: 1"
  return 0
end function
