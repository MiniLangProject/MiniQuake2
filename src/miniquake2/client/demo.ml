/* Quake II .dm2 packet stream recorder/player (length-prefixed messages). */
package miniquake2.client.demo

import miniquake2.qcommon.constants as qc
import miniquake2.qcommon.byteio as demobio

struct Demo
  packets
end struct

struct DemoPlayer
  demo
  index
  finished
end struct

function create()
  return Demo([])
end function

function append(demo, packet)
  if typeof(packet) != "bytes" or len(packet) <= 0 or len(packet) > qc.MAX_MSGLEN then return error(7700, "demo packet outside protocol message limit") end if
  demo.packets = demo.packets + [bytes(packet)]
end function

function encodeDemo(demo)
  total = 4
  for each packet in demo.packets
    total = total + 4 + len(packet)
  end for
  output = bytes(total)
  offset = 0
  for each packet in demo.packets
    demobio.putI32(output, offset, len(packet)); offset = offset + 4
    demobio.copyInto(output, offset, packet, 0, len(packet)); offset = offset + len(packet)
  end for
  demobio.putI32(output, offset, -1)
  return output
end function

function decodeDemo(data)
  if typeof(data) != "bytes" or len(data) < 4 then return error(7701, "demo stream truncated") end if
  demo = create()
  offset = 0
  terminated = false
  while offset + 4 <= len(data)
    packetLength = demobio.i32(data, offset); offset = offset + 4
    if packetLength == -1 then terminated = true; break end if
    if packetLength <= 0 or packetLength > qc.MAX_MSGLEN then return error(7702, "demo packet length outside protocol limit") end if
    if packetLength > len(data) - offset then return error(7703, "demo packet truncated") end if
    append(demo, slice(data, offset, packetLength)); offset = offset + packetLength
  end while
  if not terminated then return error(7704, "demo end marker missing") end if
  if offset != len(data) then return error(7705, "trailing data after demo end marker") end if
  return demo
end function

function player(demo)
  return DemoPlayer(demo, 0, len(demo.packets) == 0)
end function

function nextPacket(player)
  if player.index >= len(player.demo.packets) then player.finished = true; return void end if
  packet = player.demo.packets[player.index]
  player.index = player.index + 1
  if player.index >= len(player.demo.packets) then player.finished = true end if
  return packet
end function
