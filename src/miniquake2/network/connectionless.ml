/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Connectionless command parsing and exact protocol-34 request builders.
*/
package miniquake2.network.connectionless

import miniquake2.qcommon.cmd as qcmd
import miniquake2.protocol.constants as pc
import miniquake2.protocol.packet as ppacket
import miniquake2.network.types as nt

// Parse decimal.
function parseDecimal(value)
  if typeof(value) != "string" then return error(7100, "decimal token must be a string") end if
  source = bytes(value)
  index = 0
  sign = 1
  if index < len(source) and source[index] == 45 then
    sign = -1
    index = index + 1
  else if index < len(source) and source[index] == 43 then
    index = index + 1
  end if
  result = 0
  digits = 0
  while index < len(source) and source[index] >= 48 and source[index] <= 57
    if result > 214748364 then return error(7101, "decimal token exceeds signed integer range") end if
    result = result * 10 + source[index] - 48
    digits = digits + 1
    index = index + 1
  end while
  if digits == 0 then return 0 end if
  result = result * sign
  if result < -2147483648 or result > 2147483647 then return error(7101, "decimal token exceeds signed integer range") end if
  return result
end function

// Split payload.
function splitPayload(payload)
  endIndex = len(payload)
  index = 0
  while index < len(payload)
    if payload[index] == 0 then endIndex = index; break end if
    index = index + 1
  end while
  payload = slice(payload, 0, endIndex)
  lineEnd = len(payload)
  index = 0
  while index < len(payload)
    if payload[index] == 10 then lineEnd = index; break end if
    index = index + 1
  end while
  line = decode(slice(payload, 0, lineEnd))
  remainder = ""
  if lineEnd < len(payload) then remainder = decode(slice(payload, lineEnd + 1, len(payload) - lineEnd - 1)) end if
  return [line, remainder]
end function

// Parse packet.
function parsePacket(datagram)
  payload = ppacket.decodeConnectionless(datagram)
  parts = splitPayload(payload)
  arguments = qcmd.tokenize(parts[0])
  if len(arguments) == 0 then return error(7102, "empty connectionless command") end if
  return nt.ConnectionlessRequest(arguments[0], arguments, parts[0], parts[1])
end function

// Return the frame text value.
function frameText(text)
  return ppacket.encodeConnectionlessText(text)
end function

// Return challenge.
function getChallenge()
  return frameText("getchallenge\n")
end function

// Connect state.
function connect(qport, challenge, userInfo)
  if typeof(qport) != "int" or qport < 0 or qport > 0xffff then return error(7103, "connect qport outside unsigned-short range") end if
  if typeof(challenge) != "int" then return error(7104, "connect challenge must be an integer") end if
  if typeof(userInfo) != "string" or len(bytes(userInfo)) >= 512 then return error(7105, "connect userinfo is invalid") end if
  return frameText("connect " + pc.PROTOCOL_VERSION + " " + qport + " " + challenge + " \"" + userInfo + "\"\n")
end function

// Return the ping value.
function ping()
  return frameText("ping")
end function

// Return the status value.
function status()
  return frameText("status")
end function

// Return the info value.
function info()
  return frameText("info " + pc.PROTOCOL_VERSION)
end function

// Return the acknowledgement value.
function acknowledgement()
  return frameText("ack")
end function

// Return the challenge value.
function challenge(value)
  return frameText("challenge " + value)
end function

// Connect client.
function clientConnect()
  return frameText("client_connect")
end function

// Print reply.
function printReply(text)
  return frameText("print\n" + text)
end function

// Return the info reply value.
function infoReply(text)
  return frameText("info\n" + text)
end function

// Return the heartbeat value.
function heartbeat(statusText)
  return frameText("heartbeat\n" + statusText)
end function

// Shut down state.
function shutdown()
  return frameText("shutdown")
end function

// Return the truncate text value.
function truncateText(value, maximumBytes)
  data = bytes(value)
  if len(data) <= maximumBytes then return value end if
  return decode(slice(data, 0, maximumBytes))
end function

// Pad left.
function padLeft(value, width)
  output = value
  while len(bytes(output)) < width
    output = " " + output
  end while
  return output
end function
