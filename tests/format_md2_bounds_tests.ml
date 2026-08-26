/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Corrupt MD2 normal bytes must not reach the fixed renderer anorms table. */
import miniquake2.format.binary as md2boundbinary
import miniquake2.format.constants as md2boundconstants
import miniquake2.format.md2 as md2boundformat

function md2boundAssert(value, name)
  if not value then return error(2309, name) end if
  return true
end function

function md2boundFixture(normalIndex)
  data = bytes(128)
  md2boundbinary.putU32(data, 0, md2boundconstants.IDALIASHEADER)
  md2boundbinary.putU32(data, 4, md2boundconstants.ALIAS_VERSION)
  md2boundbinary.putU32(data, 8, 64)
  md2boundbinary.putU32(data, 12, 64)
  md2boundbinary.putU32(data, 16, 44)
  md2boundbinary.putU32(data, 20, 0)
  md2boundbinary.putU32(data, 24, 1)
  md2boundbinary.putU32(data, 28, 1)
  md2boundbinary.putU32(data, 32, 1)
  md2boundbinary.putU32(data, 36, 0)
  md2boundbinary.putU32(data, 40, 1)
  md2boundbinary.putU32(data, 44, 68)
  md2boundbinary.putU32(data, 48, 68)
  md2boundbinary.putU32(data, 52, 72)
  md2boundbinary.putU32(data, 56, 84)
  md2boundbinary.putU32(data, 60, 128)
  md2boundbinary.putU32(data, 64, 128)
  // One triangle references the only XYZ and texture-coordinate entries.
  data[127] = normalIndex
  return data
end function

valid = md2boundformat.parse(md2boundFixture(
  md2boundconstants.NUMVERTEXNORMALS - 1), "valid-normal.md2")
md2boundAssert(valid.frames[0].vertices[0].normalIndex ==
  md2boundconstants.NUMVERTEXNORMALS - 1,
  "last stock MD2 normal index was rejected")
invalid = try(md2boundformat.parse(md2boundFixture(
  md2boundconstants.NUMVERTEXNORMALS), "invalid-normal.md2"))
md2boundAssert(invalid is error and invalid.code == 2308,
  "out-of-range MD2 normal index reached renderer state")

print("format_md2_bounds_tests: PASS")
