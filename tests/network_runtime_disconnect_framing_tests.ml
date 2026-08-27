/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Quake-II-3.19 final disconnect framing and strict malformed guards. */
import miniquake2.qcommon.message as ndfqmsg
import miniquake2.qcommon.sizebuf as ndfqsz
import miniquake2.network.runtime.commands as ndfcommands

// Return the disconnect buffer value.
function disconnectBuffer(data)
  buffer = ndfqsz.alloc(len(data))
  ndfqsz.writeBytes(buffer, data)
  ndfqmsg.beginReading(buffer)
  return buffer
end function

// Assert the disconnect test condition.
function disconnectAssert(value, name)
  if not value then return error(7270, name) end if
  return true
end function

// CL_Disconnect sends strlen(final), so the only legal unterminated command is
// an exact terminal "disconnect" token.
reference = disconnectBuffer(bytes("disconnect"))
disconnectAssert(ndfcommands.readClientStringCommand(reference) == "disconnect",
  "reference final disconnect rejected")
disconnectAssert(reference.readCount == reference.curSize, "disconnect was not consumed exactly")

regular = disconnectBuffer(bytes([115, 97, 121, 32, 104, 105, 0]))
disconnectAssert(ndfcommands.readClientStringCommand(regular) == "say hi",
  "regular terminated command rejected")
disconnectAssert(try(ndfcommands.readClientStringCommand(disconnectBuffer(bytes("quit")))) is error,
  "arbitrary unterminated command accepted")
disconnectAssert(try(ndfcommands.readClientStringCommand(disconnectBuffer(bytes("disconnectx")))) is error,
  "disconnect prefix extension accepted")
disconnectAssert(try(ndfcommands.readClientStringCommand(disconnectBuffer(bytes("xdisconnect")))) is error,
  "disconnect suffix extension accepted")
print("network_runtime_disconnect_framing_tests: PASS")
