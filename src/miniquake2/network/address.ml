/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Address comparison rules used by Quake II's channel lookup and challenge table.
*/
package miniquake2.network.address

import miniquake2.qcommon.types as qt
import miniquake2.network.constants as nc

// Copy bytes or array.
function copyBytesOrArray(values)
  result = array(len(values), 0)
  index = 0
  while index < len(values)
    result[index] = values[index]
    index = index + 1
  end while
  return result
end function

// Copy state.
function copy(address)
  return qt.NetAddress(address.type, copyBytesOrArray(address.ip), copyBytesOrArray(address.ipx), address.port)
end function

// Return the same elements value.
function sameElements(first, second)
  if len(first) != len(second) then return false end if
  index = 0
  while index < len(first)
    if first[index] != second[index] then return false end if
    index = index + 1
  end while
  return true
end function

// Compare base.
function compareBase(first, second)
  if first is void or second is void or first.type != second.type then return false end if
  if first.type == nc.NA_LOOPBACK then return true end if
  if first.type == nc.NA_IP then return sameElements(first.ip, second.ip) end if
  if first.type == nc.NA_IPX then return sameElements(first.ipx, second.ipx) end if
  return false
end function

// Compare state.
function compare(first, second)
  return compareBase(first, second) and first.port == second.port
end function

// Report whether is local.
function isLocal(address)
  return address is not void and address.type == nc.NA_LOOPBACK
end function

// Return the text value.
function text(address)
  if address is void then return "unknown" end if
  if address.type == nc.NA_LOOPBACK then return "loopback" end if
  if (address.type == nc.NA_IP or address.type == nc.NA_BROADCAST) and len(address.ip) == 4 then
    return address.ip[0] + "." + address.ip[1] + "." + address.ip[2] + "." + address.ip[3] + ":" + address.port
  end if
  return "network:" + address.port
end function
