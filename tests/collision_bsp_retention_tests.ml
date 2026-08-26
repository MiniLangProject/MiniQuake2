/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* BSP38 nested-record lifetime regression under aggressive managed GC. */
import miniquake2.format.constants as bspretconstants
import miniquake2.format.binary as bspretbinary
import miniquake2.format.bsp as bspretparser
import miniquake2.qcommon.byteio as bspretbyteio
import miniquake2.qcommon.filesystem as bspretfilesystem
import miniquake2.format.types as bsprettypes
import miniquake2.collision.model as bspretcollision

function retentionAssert(value, message)
  if not value then return error(9896, message) end if
  return true
end function

function setLump(data, index, offset, length)
  bspretbinary.putU32(data, 8 + index * 8, offset)
  bspretbinary.putU32(data, 12 + index * 8, length)
  return true
end function

function writePlane(data, offset, x, y, z, distance, planeType)
  bspretbyteio.putF32(data, offset, x)
  bspretbyteio.putF32(data, offset + 4, y)
  bspretbyteio.putF32(data, offset + 8, z)
  bspretbyteio.putF32(data, offset + 12, distance)
  bspretbinary.putU32(data, offset + 16, planeType)
  return true
end function

function writeShortVec(data, offset, x, y, z)
  bspretbinary.putU16(data, offset, x)
  bspretbinary.putU16(data, offset + 2, y)
  bspretbinary.putU16(data, offset + 4, z)
  return true
end function

function writeFloatVec(data, offset, x, y, z)
  bspretbyteio.putF32(data, offset, x)
  bspretbyteio.putF32(data, offset + 4, y)
  bspretbyteio.putF32(data, offset + 8, z)
  return true
end function

function syntheticBspBytes()
  headerBytes = 8 + bspretconstants.HEADER_LUMPS * 8
  planeOffset = headerBytes
  nodeOffset = planeOffset + 7 * 20
  texInfoOffset = nodeOffset + 28
  leafOffset = texInfoOffset + 76
  leafBrushOffset = leafOffset + 2 * 28
  modelOffset = leafBrushOffset + 2
  brushOffset = modelOffset + 48
  brushSideOffset = brushOffset + 12
  areaOffset = brushSideOffset + 6 * 4
  areaPortalOffset = areaOffset + 3 * 8
  totalBytes = areaPortalOffset + 2 * 8
  data = bytes(totalBytes)
  bspretbinary.putU32(data, 0, bspretconstants.IDBSPHEADER)
  bspretbinary.putU32(data, 4, bspretconstants.BSP_VERSION)
  lumpIndex = 0
  while lumpIndex < bspretconstants.HEADER_LUMPS
    setLump(data, lumpIndex, headerBytes, 0)
    lumpIndex = lumpIndex + 1
  end while
  setLump(data, bspretconstants.LUMP_PLANES, planeOffset, 7 * 20)
  setLump(data, bspretconstants.LUMP_NODES, nodeOffset, 28)
  setLump(data, bspretconstants.LUMP_TEXINFO, texInfoOffset, 76)
  setLump(data, bspretconstants.LUMP_LEAFS, leafOffset, 2 * 28)
  setLump(data, bspretconstants.LUMP_LEAFBRUSHES, leafBrushOffset, 2)
  setLump(data, bspretconstants.LUMP_MODELS, modelOffset, 48)
  setLump(data, bspretconstants.LUMP_BRUSHES, brushOffset, 12)
  setLump(data, bspretconstants.LUMP_BRUSHSIDES, brushSideOffset, 6 * 4)
  setLump(data, bspretconstants.LUMP_AREAS, areaOffset, 3 * 8)
  setLump(data, bspretconstants.LUMP_AREAPORTALS, areaPortalOffset, 2 * 8)

  writePlane(data, planeOffset, 1.0, 0.0, 0.0, 0.0, 0)
  writePlane(data, planeOffset + 20, 1.0, 0.0, 0.0, 1.0, 0)
  writePlane(data, planeOffset + 40, -1.0, 0.0, 0.0, 1.0, 3)
  writePlane(data, planeOffset + 60, 0.0, 1.0, 0.0, 1.0, 1)
  writePlane(data, planeOffset + 80, 0.0, -1.0, 0.0, 1.0, 4)
  writePlane(data, planeOffset + 100, 0.0, 0.0, 1.0, 1.0, 2)
  writePlane(data, planeOffset + 120, 0.0, 0.0, -1.0, 1.0, 5)

  bspretbinary.putU32(data, nodeOffset, 0)
  bspretbinary.putU32(data, nodeOffset + 4, -1)
  bspretbinary.putU32(data, nodeOffset + 8, -2)
  writeShortVec(data, nodeOffset + 12, -16, -16, -16)
  writeShortVec(data, nodeOffset + 18, 16, 16, 16)

  // front leaf: empty; back leaf: solid and owns the six-sided brush
  bspretbinary.putU32(data, leafOffset, 0)
  bspretbinary.putU16(data, leafOffset + 4, 0)
  bspretbinary.putU16(data, leafOffset + 6, 1)
  writeShortVec(data, leafOffset + 8, 0, -16, -16)
  writeShortVec(data, leafOffset + 14, 16, 16, 16)
  bspretbinary.putU32(data, leafOffset + 28, bspretconstants.CONTENTS_SOLID)
  bspretbinary.putU16(data, leafOffset + 32, -1)
  bspretbinary.putU16(data, leafOffset + 34, 2)
  writeShortVec(data, leafOffset + 36, -16, -16, -16)
  writeShortVec(data, leafOffset + 42, 0, 16, 16)
  bspretbinary.putU16(data, leafOffset + 52, 0)
  bspretbinary.putU16(data, leafOffset + 54, 1)
  bspretbinary.putU16(data, leafBrushOffset, 0)

  writeFloatVec(data, modelOffset, -16.0, -16.0, -16.0)
  writeFloatVec(data, modelOffset + 12, 16.0, 16.0, 16.0)
  writeFloatVec(data, modelOffset + 24, 0.0, 0.0, 0.0)
  bspretbinary.putU32(data, modelOffset + 36, 0)

  bspretbinary.putU32(data, brushOffset, 0)
  bspretbinary.putU32(data, brushOffset + 4, 6)
  bspretbinary.putU32(data, brushOffset + 8, bspretconstants.CONTENTS_SOLID)
  side = 0
  while side < 6
    bspretbinary.putU16(data, brushSideOffset + side * 4, side + 1)
    bspretbinary.putU16(data, brushSideOffset + side * 4 + 2, 0)
    side = side + 1
  end while

  bspretbinary.putU32(data, areaOffset + 8, 1)
  bspretbinary.putU32(data, areaOffset + 16, 1)
  bspretbinary.putU32(data, areaOffset + 20, 1)
  bspretbinary.putU32(data, areaPortalOffset, 0)
  bspretbinary.putU32(data, areaPortalOffset + 4, 2)
  bspretbinary.putU32(data, areaPortalOffset + 8, 0)
  bspretbinary.putU32(data, areaPortalOffset + 12, 1)
  return data
end function

function validateRetainedMap(model, label)
  retentionAssert(typeof(model) == "struct" and typeof(model.map) == "struct", label + ": collision model lost")
  map = model.map
  for each plane in map.planes
    retentionAssert(typeof(plane) == "struct" and typeof(plane.normal) == "struct",
      label + ": plane normal lost")
  end for
  for each node in map.nodes
    retentionAssert(typeof(node) == "struct" and typeof(node.mins) == "struct" and typeof(node.maxs) == "struct",
      label + ": node bounds lost")
  end for
  for each brushSide in map.brushSides
    retentionAssert(typeof(brushSide) == "struct", label + ": brush side lost")
  end for
  for each modelRecord in map.models
    retentionAssert(typeof(modelRecord) == "struct" and typeof(modelRecord.mins) == "struct" and
      typeof(modelRecord.maxs) == "struct" and typeof(modelRecord.origin) == "struct",
      label + ": inline model vectors lost")
  end for
  headNode = 0
  if len(map.models) > 0 then headNode = map.models[0].headNode end if
  point = bsprettypes.Vec3(0.0, 0.0, 0.0)
  leafNumber = bspretcollision.pointLeafNumber(model, point, headNode)
  retentionAssert(leafNumber >= 0 and leafNumber < len(map.leafs), label + ": invalid collision leaf")
  mins = bsprettypes.Vec3(0.0, 0.0, 0.0)
  maxs = bsprettypes.Vec3(0.0, 0.0, 0.0)
  finish = bsprettypes.Vec3(2.0, 0.0, 0.0)
  trace = bspretcollision.boxTrace(model, point, finish, mins, maxs, headNode, bspretconstants.CONTENTS_SOLID)
  retentionAssert(trace.fraction >= 0.0 and trace.fraction <= 1.0, label + ": invalid collision trace")
  return true
end function

function syntheticRetentionSoak()
  retained = array(96)
  iteration = 0
  while iteration < 768
    data = syntheticBspBytes()
    map = bspretparser.parse(data, "synthetic-retained-" + iteration)
    model = bspretcollision.create(map)
    slot = iteration % len(retained)
    retained[slot] = model
    validateRetainedMap(model, "synthetic current")
    if iteration >= len(retained) then
      olderSlot = (iteration + 1) % len(retained)
      validateRetainedMap(retained[olderSlot], "synthetic retained")
    end if
    iteration = iteration + 1
  end while
  for each retainedModel in retained
    validateRetainedMap(retainedModel, "synthetic final")
  end for
  return true
end function

function retailMapNames()
  return [
    "base1", "base2", "base3", "biggun", "boss1", "boss2", "bunk1", "city1", "city2", "city3",
    "command", "cool1", "fact1", "fact2", "fact3", "hangar1", "hangar2", "jail1", "jail2", "jail3",
    "jail4", "jail5", "lab", "mine1", "mine2", "mine3", "mine4", "mintro", "power1", "power2",
    "q2dm1", "q2dm2", "q2dm3", "q2dm4", "q2dm5", "q2dm6", "q2dm7", "q2dm8", "security", "space",
    "strike", "train", "ware1", "ware2", "waste1", "waste2", "waste3"
  ]
end function

function retailRetentionSoak(root)
  filesystem = bspretfilesystem.initialize(root, "")
  retained = array(4, void)
  names = retailMapNames()
  index = 0
  while index < len(names)
    path = "maps/" + names[index] + ".bsp"
    fileData = bspretfilesystem.readFile(filesystem, path)
    map = bspretparser.parse(fileData, path)
    model = bspretcollision.create(map)
    retained[index % len(retained)] = model
    windowIndex = 0
    while windowIndex < len(retained)
      if retained[windowIndex] is not void then validateRetainedMap(retained[windowIndex], names[index] + " retained window") end if
      windowIndex = windowIndex + 1
    end while
    index = index + 1
  end while
  return true
end function

function main(args)
  syntheticRetentionSoak()
  if len(args) == 1 then
    retailRetentionSoak(args[0])
    print "collision_bsp_retention_tests: PASS (synthetic + retail 47-map)"
  else
    if len(args) != 0 then return error(9897, "expected optional Quake II install root") end if
    print "collision_bsp_retention_tests: PASS (synthetic)"
  end if
  return 0
end function
