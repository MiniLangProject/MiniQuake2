/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Conversion between WinSock text endpoints and managed netadr_t values. */
package miniquake2.network.runtime.transport

import miniquake2.qcommon.types as qt
import miniquake2.network.constants as nc

// Parse octet.
function parseOctet(source, start, endIndex)
  if endIndex <= start or endIndex - start > 3 then return error(7270, "invalid IPv4 octet") end if
  value = 0
  index = start
  while index < endIndex
    character = source[index]
    if character < 48 or character > 57 then return error(7270, "invalid IPv4 octet") end if
    value = value * 10 + character - 48
    index = index + 1
  end while
  if value > 255 then return error(7270, "IPv4 octet outside range") end if
  return value
end function

// Return the from udp.
function fromUdp(address, port)
  if typeof(address) != "string" or typeof(port) != "int" or port < 0 or port > 65535 then return error(7271, "invalid UDP endpoint") end if
  source = bytes(address)
  octets = []
  start = 0
  index = 0
  while index <= len(source)
    if index == len(source) or source[index] == 46 then
      octets = octets + [parseOctet(source, start, index)]
      start = index + 1
    end if
    index = index + 1
  end while
  if len(octets) != 4 then return error(7272, "only numeric IPv4 UDP endpoints are supported") end if
  return qt.NetAddress(nc.NA_IP, octets, array(10, 0), port)
end function

// Return the host value.
function host(address)
  if address is void then return error(7273, "cannot send to a void address") end if
  if address.type == nc.NA_LOOPBACK then return "127.0.0.1" end if
  if address.type != nc.NA_IP or len(address.ip) != 4 then return error(7274, "UDP runtime currently supports IPv4 and loopback only") end if
  return address.ip[0] + "." + address.ip[1] + "." + address.ip[2] + "." + address.ip[3]
end function

