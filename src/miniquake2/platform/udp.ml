/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Loopback-safe WinSock datagrams used by Quake II netchan. */
package miniquake2.platform.udp

import miniquake2.native as native

// Store datagram data.
struct Datagram
  data
  address
  port
end struct

// Store socket data.
struct Socket
  handle
  address
  port
  closed
end struct

// Open state.
function open(address, port)
  if port < 0 or port > 65535 then return error(2910, "UDP port outside range") end if
  handle = native.udpOpenBound(port, address)
  if handle == 0 then return error(2911, "could not open UDP socket") end if
  return Socket(handle, native.udpBoundAddress(handle), native.udpBoundPort(handle), false)
end function

// Close state.
function close(socket)
  if socket.closed == false then native.udpClose(socket.handle); socket.closed = true end if
  return true
end function

// Return the enable broadcast value.
function enableBroadcast(socket)
  if socket.closed then return error(2912, "UDP socket is closed") end if
  if native.udpEnableBroadcast(socket.handle) == 0 then
    return error(2917, "could not enable UDP broadcast")
  end if
  return true
end function

// Resolve name.
function resolveName(name)
  if typeof(name) != "string" or name == "" then
    return error(2918, "UDP host name is empty")
  end if
  value = native.udpResolveName(name)
  if value == "" then
    return error(2918, "could not resolve UDP host name")
  end if
  return value
end function

// Send state.
function send(socket, address, port, data)
  if socket.closed then return error(2912, "UDP socket is closed") end if
  if typeof(data) != "bytes" then return error(2913, "UDP payload must be bytes") end if
  result = native.udpSend(socket.handle, address, port, data, len(data))
  if result < 0 then return error(2914, "UDP send failed") end if
  return result
end function

// Receive state.
function receive(socket, capacity)
  if socket.closed then return error(2915, "UDP socket is closed") end if
  if capacity <= 0 or capacity > 65535 then return error(2916, "UDP receive capacity outside range") end if
  buffer = bytes(capacity)
  count = native.udpReceive(socket.handle, buffer, capacity)
  // The native bridge maps WSAEWOULDBLOCK to zero. Protocol 34 never uses an
  // empty datagram, so zero is the nonblocking "no packet" sentinel here.
  if count < 0 then
    return error(2919, "UDP receive failed (native error " +
      native.udpLastError() + ")")
  end if
  if count == 0 then return void end if
  payload = bytes(count)
  copyBytes(payload, 0, buffer, 0, count)
  return Datagram(payload, native.udpLastAddress(), native.udpLastPort())
end function

// Report whether pending.
function pending(socket)
  if socket.closed then return false end if
  return native.udpPeek(socket.handle) > 0
end function
