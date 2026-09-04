//! Provides miniquake2 client demo facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Quake II .dm2 packet stream recorder/player (length-prefixed messages). */
package miniquake2.client.demo

import miniquake2.qcommon.constants as qc
import miniquake2.qcommon.byteio as demobio

/// Store demo data.
struct Demo
  /// Stores the packets value associated with demo.
  packets
  /// Stores the waiting for full frame value associated with demo.
  waitingForFullFrame
  /// Stores the streaming value associated with demo.
  streaming
  /// Stores the stream head value associated with demo.
  streamHead
  /// Stores the stream tail value associated with demo.
  streamTail
  /// Stores the stream count value associated with demo.
  streamCount
end struct

/// Store demo packet node data.
struct DemoPacketNode
  /// Stores the packet value associated with demo packet node.
  packet
  /// Stores the next value associated with demo packet node.
  next
end struct

/// Store demo player data.
struct DemoPlayer
  /// Stores the demo value associated with demo player.
  demo
  /// Stores the index value associated with demo player.
  index
  /// Stores the finished value associated with demo player.
  finished
end struct

/// Creates create for the miniquake2 client demo module.
function create()
  return Demo([], false, false, void, void, 0)
end function

/// Begin live recording.
/// @param demo demo value consumed by this operation.
function beginLiveRecording(demo)
  if demo is void then return error(7706, "demo recorder is missing") end if
  demo.waitingForFullFrame = true
  demo.streaming = true
  return true
end function

/// Append streaming.
/// @param demo demo value consumed by this operation.
/// @param packet packet value consumed by this operation.
function appendStreaming(demo, packet)
  if typeof(packet) != "bytes" or len(packet) <= 0 or len(packet) > qc.MAX_MSGLEN then
    return error(7700, "demo packet outside protocol message limit")
  end if
  node = DemoPacketNode(bytes(packet), void)
  if demo.streamTail is void then demo.streamHead = node
  else demo.streamTail.next = node
  end if
  demo.streamTail = node
  demo.streamCount = demo.streamCount + 1
  return true
end function

/// Return the packet count.
/// @param demo demo value consumed by this operation.
function packetCount(demo)
  if demo is void then return 0 end if
  return len(demo.packets) + demo.streamCount
end function

/// CL_Record_f writes setup state immediately, then waits for a non-delta
/// snapshot so the first recorded gameplay frame never references history from
/// before recording began. Pure config/sound messages remain safe meanwhile.
/// @param demo demo value consumed by this operation.
/// @param packet packet value consumed by this operation.
/// @param frameCount Number of frame to process.
/// @param deltaNumber deltaNumber value consumed by this operation.
function appendLive(demo, packet, frameCount, deltaNumber)
  if not demo.waitingForFullFrame then
    if demo.streaming then return appendStreaming(demo, packet) end if
    return append(demo, packet)
  end if
  if frameCount == 0 then return appendStreaming(demo, packet) end if
  if deltaNumber <= 0 then
    demo.waitingForFullFrame = false
    return appendStreaming(demo, packet)
  end if
  return false
end function

/// Append state.
/// @param demo demo value consumed by this operation.
/// @param packet packet value consumed by this operation.
function append(demo, packet)
  if typeof(packet) != "bytes" or len(packet) <= 0 or len(packet) > qc.MAX_MSGLEN then return error(7700, "demo packet outside protocol message limit") end if
  demo.packets = demo.packets + [bytes(packet)]
end function

/// Encode demo.
/// @param demo demo value consumed by this operation.
function encodeDemo(demo)
  total = 4
  for each packet in demo.packets
    total = total + 4 + len(packet)
  end for
  node = demo.streamHead
  while node is not void
    total = total + 4 + len(node.packet)
    node = node.next
  end while
  output = bytes(total)
  offset = 0
  for each packet in demo.packets
    demobio.putI32(output, offset, len(packet)); offset = offset + 4
    demobio.copyInto(output, offset, packet, 0, len(packet)); offset = offset + len(packet)
  end for
  node = demo.streamHead
  while node is not void
    packet = node.packet
    demobio.putI32(output, offset, len(packet)); offset = offset + 4
    demobio.copyInto(output, offset, packet, 0, len(packet)); offset = offset + len(packet)
    node = node.next
  end while
  demobio.putI32(output, offset, -1)
  return output
end function

/// Decode demo.
/// @param data Input data consumed by the operation.
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
  demo.waitingForFullFrame = false
  return demo
end function

/// Materialize state.
/// @param demo demo value consumed by this operation.
function materialize(demo)
  if demo.streamCount == 0 then return demo.packets end if
  output = array(packetCount(demo), void)
  index = 0
  for each packet in demo.packets
    output[index] = packet
    index = index + 1
  end for
  node = demo.streamHead
  while node is not void
    output[index] = node.packet
    index = index + 1
    node = node.next
  end while
  demo.packets = output
  demo.streamHead = void
  demo.streamTail = void
  demo.streamCount = 0
  demo.streaming = false
  return output
end function

/// Return the player value.
/// @param demo demo value consumed by this operation.
function player(demo)
  materialize(demo)
  return DemoPlayer(demo, 0, len(demo.packets) == 0)
end function

/// Return the next packet value.
/// @param player player value consumed by this operation.
function nextPacket(player)
  if player.index >= len(player.demo.packets) then player.finished = true; return void end if
  packet = player.demo.packets[player.index]
  player.index = player.index + 1
  if player.index >= len(player.demo.packets) then player.finished = true end if
  return packet
end function
