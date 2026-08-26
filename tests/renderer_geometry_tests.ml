/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Asset-free geometry expansion tests for parsed BSP38/MD2 records. */
import miniquake2.format.types as ft
import miniquake2.renderer.geometry as rgeom

function assertEqual(actual, expected, name)
  if actual != expected then return error(7970, name + ": expected " + expected + ", got " + actual) end if
end function

function testBspFan()
  vertices = [
    ft.BspVertex(ft.Vec3(0.0, 0.0, 0.0)),
    ft.BspVertex(ft.Vec3(8.0, 0.0, 0.0)),
    ft.BspVertex(ft.Vec3(8.0, 8.0, 0.0)),
    ft.BspVertex(ft.Vec3(0.0, 8.0, 0.0)),
  ]
  edges = [ft.BspEdge(0, 1), ft.BspEdge(1, 2), ft.BspEdge(2, 3), ft.BspEdge(3, 0)]
  texInfo = ft.BspTexInfo([1.0, 0.0, 0.0, 0.0], [0.0, 1.0, 0.0, 0.0], 0, 0, "test", -1)
  face = ft.BspFace(0, 0, 0, 4, 0, bytes(4), -1)
  model = ft.BspModel(ft.Vec3(0.0, 0.0, 0.0), ft.Vec3(8.0, 8.0, 0.0), ft.Vec3(0.0, 0.0, 0.0), 0, 0, 1)
  map = ft.BspMap("maps/square.bsp", bytes([]), [], "", [], vertices, void, [], [texInfo], [face], bytes([]), [], [], [], edges, [0, 1, 2, 3], [model], [], [], [], [])
  mesh = rgeom.bspModelMesh(map, 0)
  assertEqual(mesh.triangleCount, 2, "quad fan triangle count")
  assertEqual(len(mesh.vertices), 6, "quad fan vertices")
  assertEqual(mesh.vertices[2].position.x, 8.0, "fan corner")
  assertEqual(mesh.vertices[2].t, 8.0, "texture projection")
end function

function testMd2Interpolation()
  scale = ft.Vec3(1.0, 1.0, 1.0)
  zero = ft.Vec3(0.0, 0.0, 0.0)
  first = ft.Md2Frame(scale, zero, "first", [ft.Md2Vertex(0, 0, 0, 0), ft.Md2Vertex(8, 0, 0, 0), ft.Md2Vertex(0, 8, 0, 0)])
  second = ft.Md2Frame(scale, zero, "second", [ft.Md2Vertex(4, 0, 0, 0), ft.Md2Vertex(12, 0, 0, 0), ft.Md2Vertex(4, 8, 0, 0)])
  triangle = ft.Md2Triangle([0, 1, 2], [0, 1, 2])
  model = ft.Md2Model("models/test/tris.md2", 8, 8, [], [ft.Md2TexCoord(0, 0), ft.Md2TexCoord(8, 0), ft.Md2TexCoord(0, 8)], [triangle], [first, second], [], bytes(0))
  mesh = rgeom.md2FrameMesh(model, 1, 0, 0.5)
  assertEqual(mesh.triangleCount, 1, "MD2 triangle count")
  assertEqual(mesh.vertices[0].position.x, 2.0, "MD2 lerp")
  assertEqual(mesh.vertices[1].s, 1.0, "MD2 normalized s")
  assertEqual(typeof(try(rgeom.md2FrameMesh(model, 4, 0, 0.0))), "error", "MD2 bad frame rejected")
end function

testBspFan()
testMd2Interpolation()
print("MiniQuake2 renderer geometry tests passed: 2")
