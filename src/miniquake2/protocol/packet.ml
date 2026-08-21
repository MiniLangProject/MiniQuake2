/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Protocol-34 packet header and connectionless (-1 sequence) framing.
*/
package miniquake2.protocol.packet

import miniquake2.qcommon.byteio as qbio
import miniquake2.protocol.constants as pc
import miniquake2.protocol.types as pt

function validSequence(value)
  return typeof(value) == "int" and value >= 0 and value <= pc.SEQUENCE_MASK
end function

function encodeHeader(header, includeQport)
  if not validSequence(header.sequence) or not validSequence(header.acknowledge) then return error(7050, "packet sequence outside 31-bit range") end if
  if header.reliable != 0 and header.reliable != 1 then return error(7051, "packet reliable flag is not a bit") end if
  if header.reliableAcknowledged != 0 and header.reliableAcknowledged != 1 then return error(7052, "packet reliable acknowledgement is not a bit") end if
  headerLength = pc.PACKET_HEADER_SERVER
  if includeQport then headerLength = pc.PACKET_HEADER_CLIENT end if
  output = bytes(headerLength)
  sequenceWord = header.sequence
  acknowledgeWord = header.acknowledge
  if header.reliable == 1 then sequenceWord = sequenceWord | pc.SEQUENCE_RELIABLE_BIT end if
  if header.reliableAcknowledged == 1 then acknowledgeWord = acknowledgeWord | pc.SEQUENCE_RELIABLE_BIT end if
  qbio.putU32(output, 0, sequenceWord)
  qbio.putU32(output, 4, acknowledgeWord)
  if includeQport then
    if typeof(header.qport) != "int" or header.qport < 0 or header.qport > 0xffff then return error(7053, "qport outside unsigned-short range") end if
    qbio.putU16(output, 8, header.qport)
  end if
  return output
end function

function decodeHeader(data, hasQport)
  if typeof(data) != "bytes" then return error(7054, "packet must be bytes") end if
  required = pc.PACKET_HEADER_SERVER
  if hasQport then required = pc.PACKET_HEADER_CLIENT end if
  if len(data) < required then return error(7055, "sequenced packet header is truncated") end if
  if len(data) > pc.MAX_MSGLEN then return error(7056, "sequenced packet exceeds MAX_MSGLEN") end if
  sequenceWord = qbio.u32(data, 0)
  acknowledgeWord = qbio.u32(data, 4)
  if sequenceWord == pc.CONNECTIONLESS_SEQUENCE then return error(7057, "connectionless packet has no sequenced header") end if
  reliable = 0
  reliableAcknowledged = 0
  if (sequenceWord & pc.SEQUENCE_RELIABLE_BIT) != 0 then reliable = 1 end if
  if (acknowledgeWord & pc.SEQUENCE_RELIABLE_BIT) != 0 then reliableAcknowledged = 1 end if
  qport = -1
  if hasQport then qport = qbio.u16(data, 8) end if
  return pt.PacketHeader(sequenceWord & pc.SEQUENCE_MASK, reliable,
    acknowledgeWord & pc.SEQUENCE_MASK, reliableAcknowledged, qport, required)
end function

function decodePacket(data, hasQport)
  header = decodeHeader(data, hasQport)
  return pt.Packet(header, slice(data, header.headerBytes, len(data) - header.headerBytes))
end function

function join(headerBytes, first, second)
  if typeof(headerBytes) != "bytes" or typeof(first) != "bytes" or typeof(second) != "bytes" then return error(7058, "packet sections must be bytes") end if
  total = len(headerBytes) + len(first) + len(second)
  if total > pc.MAX_MSGLEN then return error(7059, "packet sections exceed MAX_MSGLEN") end if
  output = bytes(total)
  qbio.copyInto(output, 0, headerBytes, 0, len(headerBytes))
  qbio.copyInto(output, len(headerBytes), first, 0, len(first))
  qbio.copyInto(output, len(headerBytes) + len(first), second, 0, len(second))
  return output
end function

function isConnectionless(data)
  return typeof(data) == "bytes" and len(data) >= 4 and qbio.u32(data, 0) == pc.CONNECTIONLESS_SEQUENCE
end function

function encodeConnectionless(payload)
  if typeof(payload) != "bytes" then return error(7060, "connectionless payload must be bytes") end if
  if len(payload) > pc.MAX_MSGLEN - 4 then return error(7061, "connectionless payload exceeds MAX_MSGLEN") end if
  output = bytes(len(payload) + 4)
  qbio.putU32(output, 0, pc.CONNECTIONLESS_SEQUENCE)
  qbio.copyInto(output, 4, payload, 0, len(payload))
  return output
end function

function encodeConnectionlessText(text)
  if typeof(text) != "string" then return error(7062, "connectionless text must be a string") end if
  return encodeConnectionless(bytes(text))
end function

function decodeConnectionless(data)
  if typeof(data) != "bytes" or len(data) < 4 then return error(7063, "connectionless packet is truncated") end if
  if len(data) > pc.MAX_MSGLEN then return error(7064, "connectionless packet exceeds MAX_MSGLEN") end if
  if qbio.u32(data, 0) != pc.CONNECTIONLESS_SEQUENCE then return error(7065, "packet is not connectionless") end if
  return slice(data, 4, len(data) - 4)
end function

function decodeConnectionlessText(data)
  payload = decodeConnectionless(data)
  endIndex = len(payload)
  index = 0
  while index < len(payload)
    if payload[index] == 0 then endIndex = index; break end if
    index = index + 1
  end while
  return decode(slice(payload, 0, endIndex))
end function
