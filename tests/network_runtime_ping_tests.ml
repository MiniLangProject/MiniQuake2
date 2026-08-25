/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

SV_CalcPings / frame_latency protocol-runtime parity tests.
*/
import miniquake2.qcommon.sizebuf as qsz
import miniquake2.protocol.types as pt
import miniquake2.network.constants as nc
import miniquake2.network.server as nserver
import miniquake2.network.snapshot as nsnapshot
import miniquake2.network.runtime.types as nrtypes
import miniquake2.network.runtime.game_adapter as rgame
import miniquake2.network.runtime.pump as rpump

pingUpdates = []

function recordPing(slot, ping)
  global pingUpdates
  pingUpdates = pingUpdates + [[slot, ping]]
  return true
end function

function assertEqual(actual, expected, name)
  if actual != expected then return error(7931, name + ": expected " + expected + ", got " + actual) end if
  return true
end function

function writeFrameAt(runtime, frameNumber, now)
  runtime.server.realTime = now
  frame = nsnapshot.createFrame(frameNumber, bytes(), pt.zeroPlayerState(), [])
  buffer = qsz.alloc(256)
  nserver.writeClientFrame(runtime.server, 0, frame, runtime.baselines, buffer)
  return true
end function

function main(args)
  global pingUpdates
  callbacks = rgame.permissive()
  callbacks.clientPing = recordPing
  server = nserver.create(2, "Ping", "base1", "\\hostname\\Ping", false, false)
  runtime = nrtypes.createServer(server, 1, "baseq2", "Ping Test", callbacks)
  server.clients[0].state = nc.CS_SPAWNED
  server.clients[1].state = nc.CS_CONNECTED

  writeFrameAt(runtime, 10, 1000)
  server.realTime = 1150
  nserver.acknowledgeFrame(server, 0, 10)
  assertEqual(server.clients[0].frameLatencies[10 & 15], 150, "first RTT sample")
  rpump.calculatePings(runtime)
  assertEqual(server.clients[0].ping, 150, "single-sample ping")
  assertEqual(pingUpdates, [[0, 150]], "spawned ping callback only")

  writeFrameAt(runtime, 11, 1200)
  server.realTime = 1300
  nserver.acknowledgeFrame(server, 0, 11)
  rpump.calculatePings(runtime)
  assertEqual(server.clients[0].ping, 125, "two-sample average")
  assertEqual(pingUpdates[1], [0, 125], "averaged Game API update")

  // The stock clc_move path does not replace a sample when the same
  // lastframe is acknowledged repeatedly.
  server.realTime = 1500
  nserver.acknowledgeFrame(server, 0, 11)
  rpump.calculatePings(runtime)
  assertEqual(server.clients[0].frameLatencies[11 & 15], 100, "duplicate ACK ignored")
  assertEqual(server.clients[0].ping, 125, "duplicate ACK keeps average")

  print "network_runtime_ping_tests: PASS"
  return 0
end function
