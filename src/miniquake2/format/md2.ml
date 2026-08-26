/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Quake II MD2 (IDP2, version 8) loader. */
package miniquake2.format.md2

import miniquake2.format.constants as fc
import miniquake2.format.types as ft
import miniquake2.format.binary as fbio

function checkedSection(data, offset, count, stride, name)
  if offset < 0 or count < 0 or stride < 0 or offset > len(data) or count * stride > len(data) - offset then
    return error(2300, "MD2 " + name + " section outside file")
  end if
  return true
end function

function parse(data, name)
  if len(data) < 68 then return error(2301, "MD2 header is truncated") end if
  if fbio.u32(data, 0) != fc.IDALIASHEADER then return error(2302, "MD2 ident mismatch") end if
  if fbio.i32(data, 4) != fc.ALIAS_VERSION then return error(2303, "unsupported MD2 version") end if
  skinWidth = fbio.i32(data, 8)
  skinHeight = fbio.i32(data, 12)
  frameSize = fbio.i32(data, 16)
  numSkins = fbio.i32(data, 20)
  numXyz = fbio.i32(data, 24)
  numSt = fbio.i32(data, 28)
  numTris = fbio.i32(data, 32)
  numGlCommands = fbio.i32(data, 36)
  numFrames = fbio.i32(data, 40)
  ofsSkins = fbio.i32(data, 44)
  ofsSt = fbio.i32(data, 48)
  ofsTris = fbio.i32(data, 52)
  ofsFrames = fbio.i32(data, 56)
  ofsGlCommands = fbio.i32(data, 60)
  ofsEnd = fbio.i32(data, 64)
  if skinWidth <= 0 or skinHeight <= 0 then return error(2304, "invalid MD2 skin dimensions") end if
  if numSkins < 0 or numSkins > fc.MAX_MD2SKINS or numXyz <= 0 or numXyz > fc.MAX_VERTS or numTris <= 0 or numTris > fc.MAX_TRIANGLES or numFrames <= 0 or numFrames > fc.MAX_FRAMES then
    return error(2305, "MD2 count outside format limits")
  end if
  if numSt < 0 or numGlCommands < 0 or frameSize < 40 + numXyz * 4 or ofsEnd < 68 or ofsEnd > len(data) then
    return error(2306, "invalid MD2 layout")
  end if
  checkedSection(data, ofsSkins, numSkins, 64, "skins")
  checkedSection(data, ofsSt, numSt, 4, "texture coordinates")
  checkedSection(data, ofsTris, numTris, 12, "triangles")
  checkedSection(data, ofsFrames, numFrames, frameSize, "frames")
  checkedSection(data, ofsGlCommands, numGlCommands, 4, "gl commands")

  skins = array(numSkins)
  i = 0
  while i < numSkins
    skins[i] = fbio.fixedString(data, ofsSkins + i * 64, 64)
    i = i + 1
  end while
  texCoords = array(numSt)
  i = 0
  while i < numSt
    texCoords[i] = ft.Md2TexCoord(fbio.i16(data, ofsSt + i * 4), fbio.i16(data, ofsSt + i * 4 + 2))
    i = i + 1
  end while
  triangles = array(numTris)
  i = 0
  while i < numTris
    at = ofsTris + i * 12
    xyz = [fbio.u16(data, at), fbio.u16(data, at + 2), fbio.u16(data, at + 4)]
    st = [fbio.u16(data, at + 6), fbio.u16(data, at + 8), fbio.u16(data, at + 10)]
    triangles[i] = ft.Md2Triangle(xyz, st)
    j = 0
    while j < 3
      if triangles[i].xyz[j] >= numXyz or triangles[i].st[j] >= numSt then return error(2307, "MD2 triangle index outside table") end if
      j = j + 1
    end while
    i = i + 1
  end while
  frames = array(numFrames)
  i = 0
  while i < numFrames
    at = ofsFrames + i * frameSize
    scale = ft.Vec3(fbio.f32(data, at), fbio.f32(data, at + 4), fbio.f32(data, at + 8))
    translate = ft.Vec3(fbio.f32(data, at + 12), fbio.f32(data, at + 16), fbio.f32(data, at + 20))
    vertices = array(numXyz)
    j = 0
    while j < numXyz
      vertexAt = at + 40 + j * 4
      vertices[j] = ft.Md2Vertex(data[vertexAt], data[vertexAt + 1], data[vertexAt + 2], data[vertexAt + 3])
      j = j + 1
    end while
    frameName = fbio.fixedString(data, at + 24, 16)
    frames[i] = ft.Md2Frame(scale, translate, frameName, vertices)
    i = i + 1
  end while
  glCommands = array(numGlCommands)
  i = 0
  while i < numGlCommands
    glCommands[i] = fbio.u32(data, ofsGlCommands + i * 4)
    i = i + 1
  end while
  return ft.Md2Model(name, skinWidth, skinHeight, skins, texCoords, triangles,
    frames, glCommands, data)
end function
