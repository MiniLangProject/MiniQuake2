/* Loopback-safe WinSock datagrams used by Quake II netchan. */
package miniquake2.platform.udp

import miniquake2.native as native

struct Datagram
  data
  address
  port
end struct

struct Socket
  handle
  address
  port
  closed
end struct

function open(address, port)
  if port < 0 or port > 65535 then return error(2910, "UDP port outside range") end if
  handle = native.udpOpenBound(port, address)
  if handle == 0 then return error(2911, "could not open UDP socket") end if
  return Socket(handle, native.udpBoundAddress(handle), native.udpBoundPort(handle), false)
end function

function close(socket)
  if socket.closed == false then native.udpClose(socket.handle); socket.closed = true end if
  return true
end function

function enableBroadcast(socket)
  if socket.closed then return error(2912, "UDP socket is closed") end if
  if native.udpEnableBroadcast(socket.handle) == 0 then
    return error(2917, "could not enable UDP broadcast")
  end if
  return true
end function

function send(socket, address, port, data)
  if socket.closed then return error(2912, "UDP socket is closed") end if
  if typeof(data) != "bytes" then return error(2913, "UDP payload must be bytes") end if
  result = native.udpSend(socket.handle, address, port, data, len(data))
  if result < 0 then return error(2914, "UDP send failed") end if
  return result
end function

function receive(socket, capacity)
  if socket.closed then return error(2915, "UDP socket is closed") end if
  if capacity <= 0 or capacity > 65535 then return error(2916, "UDP receive capacity outside range") end if
  buffer = bytes(capacity)
  count = native.udpReceive(socket.handle, buffer, capacity)
  if count < 0 then return void end if
  payload = bytes(count)
  copyBytes(payload, 0, buffer, 0, count)
  return Datagram(payload, native.udpLastAddress(), native.udpLastPort())
end function

function pending(socket)
  if socket.closed then return false end if
  return native.udpPeek(socket.handle) > 0
end function
