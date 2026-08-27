/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Managed representations of Quake II on-disk records. */
package miniquake2.format.types

// Store vec 3 data.
struct Vec3
  x
  y
  z
end struct

// Store lump data.
struct Lump
  offset
  length
end struct

// Store bsp plane data.
struct BspPlane
  normal
  distance
  type
end struct

// Store bsp vertex data.
struct BspVertex
  position
end struct

// Store bsp node data.
struct BspNode
  planeIndex
  child0
  child1
  mins
  maxs
  firstFace
  numFaces
end struct

// Store bsp tex info data.
struct BspTexInfo
  s
  t
  flags
  value
  texture
  nextTexInfo
end struct

// Store bsp face data.
struct BspFace
  planeIndex
  side
  firstEdge
  numEdges
  texInfo
  styles
  lightOffset
end struct

// Store bsp leaf data.
struct BspLeaf
  contents
  cluster
  area
  mins
  maxs
  firstLeafFace
  numLeafFaces
  firstLeafBrush
  numLeafBrushes
end struct

// Store bsp edge data.
struct BspEdge
  vertex0
  vertex1
end struct

// Store bsp model data.
struct BspModel
  mins
  maxs
  origin
  headNode
  firstFace
  numFaces
end struct

// Store bsp brush data.
struct BspBrush
  firstSide
  numSides
  contents
end struct

// Store bsp brush side data.
struct BspBrushSide
  planeIndex
  texInfo
end struct

// Store bsp area data.
struct BspArea
  numAreaPortals
  firstAreaPortal
end struct

// Store bsp area portal data.
struct BspAreaPortal
  portalNumber
  otherArea
end struct

// Store bsp visibility data.
struct BspVisibility
  numClusters
  pvsOffsets
  phsOffsets
  data
end struct

// Store bsp map data.
struct BspMap
  name
  data
  lumps
  entityText
  planes
  vertices
  visibility
  nodes
  texInfo
  faces
  lighting
  leafs
  leafFaces
  leafBrushes
  edges
  surfaceEdges
  models
  brushes
  brushSides
  areas
  areaPortals
end struct

// Store md 2 tex coord data.
struct Md2TexCoord
  s
  t
end struct

// Store md 2 triangle data.
struct Md2Triangle
  xyz
  st
end struct

// Store md 2 vertex data.
struct Md2Vertex
  x
  y
  z
  normalIndex
end struct

// Store md 2 frame data.
struct Md2Frame
  scale
  translate
  name
  vertices
end struct

// Store md 2 model data.
struct Md2Model
  name
  skinWidth
  skinHeight
  skins
  texCoords
  triangles
  frames
  glCommands
  rawData
end struct

// Store sprite frame data.
struct SpriteFrame
  width
  height
  originX
  originY
  imageName
end struct

// Store sprite model data.
struct SpriteModel
  name
  frames
end struct

// Store wal texture data.
struct WalTexture
  name
  width
  height
  mipOffsets
  mipPixels
  animationName
  flags
  contents
  value
end struct

// Store pcx image data.
struct PcxImage
  width
  height
  pixels
  palette
end struct

// Store cinematic header data.
struct CinematicHeader
  width
  height
  sampleRate
  sampleWidth
  sampleChannels
  huffmanCounts
  frameDataOffset
end struct

// Store huffman tree data.
struct HuffmanTree
  root
  left
  right
end struct

// Store cinematic frame data.
struct CinematicFrame
  command
  palette
  pixels
  audio
  nextOffset
end struct
