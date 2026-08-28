/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Allocation gate for scalar Protocol-34 readers used in every snapshot. */
import miniquake2.qcommon.message as allocationmsg
import miniquake2.qcommon.sizebuf as allocationsz

// Assert the message allocation condition.
function allocationAssert(value, name)
  if not value then return error(2910, name) end if
  return true
end function

buffer = allocationsz.alloc(16)
buffer.curSize = 16
index = 0
while index < 16
  buffer.data[index] = index
  index = index + 1
end while

// Warm the imported functions before measuring the steady-state scalar path.
warm = 0
while warm < 100
  buffer.readCount = 0
  allocationmsg.readByte(buffer)
  allocationmsg.readShort(buffer)
  allocationmsg.readLong(buffer)
  allocationmsg.readFloat(buffer)
  warm = warm + 1
end while

before = heap_bytes_used()
iteration = 0
while iteration < 100000
  buffer.readCount = 0
  allocationmsg.readByte(buffer)
  allocationmsg.readShort(buffer)
  allocationmsg.readLong(buffer)
  allocationmsg.readFloat(buffer)
  iteration = iteration + 1
end while
growth = heap_bytes_used() - before
allocationAssert(growth < 65536,
  "scalar message readers allocated temporary aggregate state")
allocationAssert(buffer.readCount == 11, "scalar reader cursor changed")

print("qcommon_message_allocation_tests: PASS")
