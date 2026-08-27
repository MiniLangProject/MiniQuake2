/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Pure MiniLang Netchan state machine.  Transport I/O is deliberately outside:
transmit returns the exact datagram and process accepts one exact datagram.
*/
package miniquake2.protocol.netchan

import miniquake2.qcommon.sizebuf as qsz
import miniquake2.protocol.constants as pc
import miniquake2.protocol.types as pt
import miniquake2.protocol.packet as ppacket

// Return the next sequence value.
function nextSequence(sequence)
  return (sequence + 1) & pc.SEQUENCE_MASK
end function

// Modular comparison keeps the reference ordering until the 31-bit counter
// wraps, then preserves the same stale/duplicate protection across the wrap.
function sequenceNewer(candidate, current)
  difference = (candidate - current) & pc.SEQUENCE_MASK
  return difference != 0 and difference < 0x40000000
end function

// Return the sequence at least value.
function sequenceAtLeast(candidate, current)
  return candidate == current or sequenceNewer(candidate, current)
end function

// Return the setup value.
function setup(sock, remoteAddress, qport, now)
  if sock != pc.NS_CLIENT and sock != pc.NS_SERVER then return error(7070, "Netchan socket side is invalid") end if
  if typeof(qport) != "int" or qport < 0 or qport > 0xffff then return error(7071, "Netchan qport outside unsigned-short range") end if
  if typeof(now) != "int" then return error(7072, "Netchan time must be integer milliseconds") end if
  message = qsz.allocOverflowing(pc.RELIABLE_BUFFER_SIZE)
  return pt.NetChannel(false, sock, 0, now, 0, remoteAddress, qport,
    0, 0, 0, 0, 1, 0, 0, -1, message, 0, bytes(), [], 0)
end function

// Report whether can reliable.
function canReliable(channel)
  return channel.reliableLength == 0 and len(channel.reliableQueue) == 0
end function

// Validate reliable queue.
function validateReliableQueue(channel)
  if typeof(channel.reliableQueue) != "array" or
      typeof(channel.reliableQueuedBytes) != "int" or
      channel.reliableQueuedBytes < 0 or
      len(channel.reliableQueue) > pc.MAX_RELIABLE_QUEUE_FRAGMENTS then
    return error(7082, "Netchan reliable fragment queue metadata is corrupt")
  end if
  total = 0
  for each fragment in channel.reliableQueue
    if typeof(fragment) != "bytes" or len(fragment) <= 0 or
        len(fragment) > pc.RELIABLE_BUFFER_SIZE then
      return error(7083, "Netchan reliable fragment queue contains a malformed payload")
    end if
    total = total + len(fragment)
  end for
  if total != channel.reliableQueuedBytes or total > pc.MAX_RELIABLE_QUEUE_BYTES then
    return error(7082, "Netchan reliable fragment queue metadata is corrupt")
  end if
  return total
end function

// Report whether pending reliable bytes.
function pendingReliableBytes(channel)
  validateReliableQueue(channel)
  return channel.reliableLength + channel.reliableQueuedBytes + channel.message.curSize
end function

// Return the need reliable value.
function needReliable(channel)
  // Quake stores lastReliableSequence after incrementing outgoingSequence.
  // Equality therefore already proves that the peer received a packet after
  // the reliable-bearing datagram.  Waiting for a strictly newer ACK adds a
  // second idle round and can starve crossed signon fragment epochs.
  if sequenceAtLeast(channel.incomingAcknowledged, channel.lastReliableSequence) and
      channel.incomingReliableAcknowledged != channel.reliableSequence then return true end if
  return channel.reliableLength == 0 and
    (len(channel.reliableQueue) > 0 or channel.message.curSize > 0)
end function

// Queue reliable.
function queueReliable(channel, payload)
  if typeof(payload) != "bytes" then return error(7073, "reliable payload must be bytes") end if
  if len(payload) > pc.RELIABLE_BUFFER_SIZE then return error(7073, "reliable payload exceeds one Protocol-34 packet") end if
  validateReliableQueue(channel)
  if channel.message.overflowed then return error(7076, "Netchan outgoing reliable message overflow") end if
  if len(payload) > channel.message.maxSize - channel.message.curSize then
    queued = queueReliableFragments(channel, [payload])
    if queued == false then return error(7084, "Netchan reliable fragment queue is full") end if
    return channel
  end if
  qsz.writeBytes(channel.message, payload)
  return channel
end function

// Queue complete application payload fragments without splitting the bytes of
// an svc/clc command.  The operation is failure-atomic: capacity is checked on
// detached queue/buffer state, then committed in one small mutation boundary.
// A false result is bounded backpressure; malformed state/input is an error.
function queueReliableFragments(channel, fragments)
  // Keep queue reliable fragments phases explicit: validate inputs, update owned state, then publish the result.
  if typeof(fragments) != "array" then return error(7085, "reliable fragments must be an array") end if
  validateReliableQueue(channel)
  if channel.message.overflowed then return error(7076, "Netchan outgoing reliable message overflow") end if

  planned = []
  plannedBytes = 0
  for each queued in channel.reliableQueue
    planned = planned + [queued]
    plannedBytes = plannedBytes + len(queued)
  end for
  staging = qsz.alloc(pc.RELIABLE_BUFFER_SIZE)
  if channel.message.curSize > 0 then qsz.writeBytes(staging, qsz.dataSlice(channel.message)) end if

  for each fragment in fragments
    if typeof(fragment) != "bytes" or len(fragment) <= 0 then
      return error(7086, "reliable fragment is empty or malformed")
    end if
    if len(fragment) > pc.RELIABLE_BUFFER_SIZE then
      return error(7087, "reliable application fragment exceeds packet capacity")
    end if
    if staging.curSize + len(fragment) > pc.RELIABLE_BUFFER_SIZE then
      planned = planned + [qsz.dataSlice(staging)]
      plannedBytes = plannedBytes + staging.curSize
      qsz.clear(staging)
    end if
    qsz.writeBytes(staging, fragment)
  end for
  if staging.curSize > 0 then
    planned = planned + [qsz.dataSlice(staging)]
    plannedBytes = plannedBytes + staging.curSize
  end if
  if len(planned) > pc.MAX_RELIABLE_QUEUE_FRAGMENTS or
      plannedBytes > pc.MAX_RELIABLE_QUEUE_BYTES then return false end if

  channel.reliableQueue = planned
  channel.reliableQueuedBytes = plannedBytes
  qsz.clear(channel.message)
  return channel
end function

// Report whether can queue reliable fragments.
function canQueueReliableFragments(channel, fragments)
  if typeof(fragments) != "array" then return error(7085, "reliable fragments must be an array") end if
  // Evaluate the exact packer against a detached holder so callers can
  // preflight batches spanning several recipients without any partial queue.
  holder = pt.NetChannel(channel.fatalError, channel.sock, channel.dropped,
    channel.lastReceived, channel.lastSent, channel.remoteAddress, channel.qport,
    channel.incomingSequence, channel.incomingAcknowledged,
    channel.incomingReliableAcknowledged, channel.incomingReliableSequence,
    channel.outgoingSequence, channel.reliableSequence,
    channel.lastReliableSequence, channel.firstReliableSequence,
    qsz.allocOverflowing(pc.RELIABLE_BUFFER_SIZE),
    channel.reliableLength, channel.reliableBuffer, [], channel.reliableQueuedBytes)
  for each queued in channel.reliableQueue
    holder.reliableQueue = holder.reliableQueue + [queued]
  end for
  if channel.message.curSize > 0 then qsz.writeBytes(holder.message, qsz.dataSlice(channel.message)) end if
  return queueReliableFragments(holder, fragments) != false
end function

// Return the promote reliable value.
function promoteReliable(channel)
  if channel.reliableLength != 0 then return false end if
  if len(channel.reliableQueue) > 0 then
    channel.reliableBuffer = channel.reliableQueue[0]
    channel.reliableLength = len(channel.reliableBuffer)
    remaining = []
    index = 1
    while index < len(channel.reliableQueue)
      remaining = remaining + [channel.reliableQueue[index]]
      index = index + 1
    end while
    channel.reliableQueue = remaining
    channel.reliableQueuedBytes = channel.reliableQueuedBytes - channel.reliableLength
  else if channel.message.curSize > 0 then
    channel.reliableBuffer = qsz.dataSlice(channel.message)
    channel.reliableLength = channel.message.curSize
    qsz.clear(channel.message)
  else
    return false
  end if
  channel.reliableSequence = channel.reliableSequence ^ 1
  channel.firstReliableSequence = -1
  return true
end function

// Return the transmit value.
function transmit(channel, unreliable, now)
  if typeof(unreliable) != "bytes" then return error(7074, "unreliable payload must be bytes") end if
  if typeof(now) != "int" then return error(7075, "Netchan time must be integer milliseconds") end if
  if channel.message.overflowed then
    channel.fatalError = true
    return error(7076, "Netchan outgoing reliable message overflow")
  end if
  if channel.reliableLength < 0 or channel.reliableLength > pc.RELIABLE_BUFFER_SIZE or channel.reliableLength > len(channel.reliableBuffer) then
    channel.fatalError = true
    return error(7080, "Netchan reliable holding buffer is corrupt")
  end if
  queuedState = try(validateReliableQueue(channel))
  if queuedState is error then channel.fatalError = true; return queuedState end if

  sendReliable = needReliable(channel)
  if channel.reliableLength == 0 then promoteReliable(channel) end if

  reliableFlag = 0
  if sendReliable then reliableFlag = 1 end if
  headerValue = pt.PacketHeader(channel.outgoingSequence, reliableFlag,
    channel.incomingSequence, channel.incomingReliableSequence, channel.qport, 0)
  includeQport = channel.sock == pc.NS_CLIENT
  headerBytes = ppacket.encodeHeader(headerValue, includeQport)
  channel.outgoingSequence = nextSequence(channel.outgoingSequence)
  channel.lastSent = now

  reliablePayload = bytes()
  if sendReliable then
    reliablePayload = slice(channel.reliableBuffer, 0, channel.reliableLength)
    if channel.firstReliableSequence < 0 then
      channel.firstReliableSequence = headerValue.sequence
    end if
    // The 3.19 code records outgoing_sequence after incrementing it.
    channel.lastReliableSequence = channel.outgoingSequence
  end if
  unreliablePayload = bytes()
  if len(headerBytes) + len(reliablePayload) + len(unreliable) <= pc.MAX_MSGLEN then
    unreliablePayload = unreliable
  end if
  return ppacket.join(headerBytes, reliablePayload, unreliablePayload)
end function

// Process state.
function process(channel, datagram, now)
  if typeof(datagram) != "bytes" then return error(7077, "Netchan datagram must be bytes") end if
  if typeof(now) != "int" then return error(7081, "Netchan receive time must be integer milliseconds") end if
  if ppacket.isConnectionless(datagram) then return error(7078, "connectionless datagram cannot enter Netchan_Process") end if
  hasQport = channel.sock == pc.NS_SERVER
  decoded = ppacket.decodePacket(datagram, hasQport)
  header = decoded.header

  if not sequenceNewer(header.sequence, channel.incomingSequence) then
    return pt.ProcessedPacket(false, bytes(), header, 0, "stale-or-duplicate")
  end if

  dropped = ((header.sequence - channel.incomingSequence) & pc.SEQUENCE_MASK) - 1
  // A parity bit alone is ambiguous after the next reliable epoch toggles
  // back to an older value.  ACK acceptance is anchored to the first wire
  // sequence of this payload, not the latest retransmit marker: a delayed ACK
  // for the original send remains valid after one or more retransmissions.
  if channel.reliableLength > 0 and channel.firstReliableSequence >= 0 and
      header.reliableAcknowledged == channel.reliableSequence and
      sequenceAtLeast(header.acknowledge, channel.firstReliableSequence) then
    channel.reliableLength = 0
    channel.reliableBuffer = bytes()
    channel.firstReliableSequence = -1
  end if
  channel.dropped = dropped
  channel.incomingSequence = header.sequence
  channel.incomingAcknowledged = header.acknowledge
  channel.incomingReliableAcknowledged = header.reliableAcknowledged
  if header.reliable == 1 then channel.incomingReliableSequence = channel.incomingReliableSequence ^ 1 end if
  channel.lastReceived = now
  return pt.ProcessedPacket(true, decoded.payload, header, dropped, "accepted")
end function

// Return the out of band value.
function outOfBand(payload)
  return ppacket.encodeConnectionless(payload)
end function

// Print out of band.
function outOfBandPrint(text)
  return ppacket.encodeConnectionlessText(text)
end function

// Return the netchan setup value.
function Netchan_Setup(sock, remoteAddress, qport, now)
  return setup(sock, remoteAddress, qport, now)
end function

// Report whether netchan can reliable.
function Netchan_CanReliable(channel)
  return canReliable(channel)
end function

// Return the netchan need reliable value.
function Netchan_NeedReliable(channel)
  return needReliable(channel)
end function

// Return the netchan transmit value.
function Netchan_Transmit(channel, length, data, now)
  if typeof(length) != "int" or length < 0 or typeof(data) != "bytes" or length > len(data) then return error(7079, "invalid Netchan_Transmit payload range") end if
  return transmit(channel, slice(data, 0, length), now)
end function

// Process netchan.
function Netchan_Process(channel, datagram, now)
  return process(channel, datagram, now)
end function

// Return the netchan out of band value.
function Netchan_OutOfBand(data)
  return outOfBand(data)
end function

// Print netchan out of band.
function Netchan_OutOfBandPrint(text)
  return outOfBandPrint(text)
end function
