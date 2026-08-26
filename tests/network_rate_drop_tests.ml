/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Quake II 3.19 SV_UserinfoChanged / SV_RateDrop parity tests. */
import miniquake2.qcommon.types as ratetest_qtypes
import miniquake2.qcommon.sizebuf as ratetest_sizebuf
import miniquake2.qcommon.message as ratetest_message
import miniquake2.protocol.types as ratetest_protocoltypes
import miniquake2.network.constants as ratetest_constants
import miniquake2.network.server as ratetest_server
import miniquake2.network.snapshot as ratetest_snapshot

function rateAssert(value, message)
  if not value then return error(7965, message) end if
  return true
end function

function rateAddress(kind)
  return ratetest_qtypes.NetAddress(kind, [192, 0, 2, 8],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 27910)
end function

function rateBaselines()
  result = array(1024, void)
  index = 0
  while index < len(result)
    result[index] = ratetest_protocoltypes.zeroEntityState()
    index = index + 1
  end while
  return result
end function

function rateReadBuffer(data)
  buffer = ratetest_sizebuf.alloc(len(data))
  ratetest_sizebuf.writeBytes(buffer, data)
  ratetest_message.beginReading(buffer)
  return buffer
end function

server = ratetest_server.create(1, "Rate", "base1", "\\hostname\\Rate", false, false)
client = server.clients[0]
client.state = ratetest_constants.CS_SPAWNED
client.address = rateAddress(ratetest_constants.NA_IP)

rateAssert(ratetest_server.clientRate("\\name\\Default") == 5000,
  "missing rate did not use stock 5000 default")
rateAssert(ratetest_server.clientRate("\\rate\\99") == 100,
  "low rate was not clamped to 100")
rateAssert(ratetest_server.clientRate("\\rate\\20000") == 15000,
  "high rate was not clamped to 15000")
rateAssert(ratetest_server.clientRate("\\rate\\invalid") == 100,
  "atoi-compatible invalid rate was not clamped from zero")
ratetest_server.applyUserInfo(client, "\\name\\Remote\\rate\\100")
rateAssert(client.name == "Remote" and client.rate == 100,
  "userinfo did not refresh transport name and rate")

frameNumber = 0
while frameNumber < ratetest_constants.RATE_MESSAGES
  ratetest_server.recordClientMessage(server, 0, frameNumber, 20)
  frameNumber = frameNumber + 1
end while

// A strict total > rate comparison zeros one rolling slot per skipped tick.
frameNumber = 10
while frameNumber < 15
  rateAssert(ratetest_server.rateDrop(server, 0, frameNumber),
    "over-rate remote frame was not suppressed")
  frameNumber = frameNumber + 1
end while
rateAssert(client.suppressCount == 5,
  "suppressed frame count was not accumulated")
rateAssert(not ratetest_server.rateDrop(server, 0, 15),
  "exact-rate window should be transmitted")

// The next successful frame carries and then clears the accumulated count.
frame = ratetest_snapshot.createFrame(15, bytes(),
  ratetest_protocoltypes.zeroPlayerState(), [])
wire = ratetest_sizebuf.alloc(256)
ratetest_server.writeClientFrame(server, 0, frame, rateBaselines(), wire)
decoded = ratetest_snapshot.readFrame(rateReadBuffer(
  ratetest_sizebuf.dataSlice(wire)), array(ratetest_constants.UPDATE_BACKUP, void),
  rateBaselines())
rateAssert(decoded.suppressCount == 5 and client.suppressCount == 0,
  "successful svc_frame did not publish and reset suppressCount")

// Stock SV_RateDrop never limits an in-process loopback client.
client.address = rateAddress(ratetest_constants.NA_LOOPBACK)
client.rate = 100
frameNumber = 0
while frameNumber < ratetest_constants.RATE_MESSAGES
  client.messageSizes[frameNumber] = 1400
  frameNumber = frameNumber + 1
end while
rateAssert(not ratetest_server.rateDrop(server, 0, 20) and
  client.messageSizes[0] == 1400 and client.suppressCount == 0,
  "loopback client was rate limited")

print("network_rate_drop_tests: PASS")
