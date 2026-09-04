//! Provides miniquake2 format types facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Managed representations of Quake II on-disk records. */
package miniquake2.format.types

/// Store vec 3 data.
struct Vec3
  /// Stores the x value associated with vec3.
  x
  /// Stores the y value associated with vec3.
  y
  /// Stores the z value associated with vec3.
  z
end struct

/// Store lump data.
struct Lump
  /// Stores the offset value associated with lump.
  offset
  /// Stores the length value associated with lump.
  length
end struct

/// Store bsp plane data.
struct BspPlane
  /// Stores the normal value associated with bsp plane.
  normal
  /// Stores the distance value associated with bsp plane.
  distance
  /// Stores the type value associated with bsp plane.
  type
end struct

/// Store bsp vertex data.
struct BspVertex
  /// Stores the position value associated with bsp vertex.
  position
end struct

/// Store bsp node data.
struct BspNode
  /// Stores the plane index value associated with bsp node.
  planeIndex
  /// Stores the child0 value associated with bsp node.
  child0
  /// Stores the child1 value associated with bsp node.
  child1
  /// Stores the mins value associated with bsp node.
  mins
  /// Stores the maxs value associated with bsp node.
  maxs
  /// Stores the first face value associated with bsp node.
  firstFace
  /// Stores the num faces value associated with bsp node.
  numFaces
end struct

/// Store bsp tex info data.
struct BspTexInfo
  /// Stores the s value associated with bsp tex info.
  s
  /// Stores the t value associated with bsp tex info.
  t
  /// Stores the flags value associated with bsp tex info.
  flags
  /// Stores the value value associated with bsp tex info.
  value
  /// Stores the texture value associated with bsp tex info.
  texture
  /// Stores the next tex info value associated with bsp tex info.
  nextTexInfo
end struct

/// Store bsp face data.
struct BspFace
  /// Stores the plane index value associated with bsp face.
  planeIndex
  /// Stores the side value associated with bsp face.
  side
  /// Stores the first edge value associated with bsp face.
  firstEdge
  /// Stores the num edges value associated with bsp face.
  numEdges
  /// Stores the tex info value associated with bsp face.
  texInfo
  /// Stores the styles value associated with bsp face.
  styles
  /// Stores the light offset value associated with bsp face.
  lightOffset
end struct

/// Store bsp leaf data.
struct BspLeaf
  /// Stores the contents value associated with bsp leaf.
  contents
  /// Stores the cluster value associated with bsp leaf.
  cluster
  /// Stores the area value associated with bsp leaf.
  area
  /// Stores the mins value associated with bsp leaf.
  mins
  /// Stores the maxs value associated with bsp leaf.
  maxs
  /// Stores the first leaf face value associated with bsp leaf.
  firstLeafFace
  /// Stores the num leaf faces value associated with bsp leaf.
  numLeafFaces
  /// Stores the first leaf brush value associated with bsp leaf.
  firstLeafBrush
  /// Stores the num leaf brushes value associated with bsp leaf.
  numLeafBrushes
end struct

/// Store bsp edge data.
struct BspEdge
  /// Stores the vertex0 value associated with bsp edge.
  vertex0
  /// Stores the vertex1 value associated with bsp edge.
  vertex1
end struct

/// Store bsp model data.
struct BspModel
  /// Stores the mins value associated with bsp model.
  mins
  /// Stores the maxs value associated with bsp model.
  maxs
  /// Stores the origin value associated with bsp model.
  origin
  /// Stores the head node value associated with bsp model.
  headNode
  /// Stores the first face value associated with bsp model.
  firstFace
  /// Stores the num faces value associated with bsp model.
  numFaces
end struct

/// Store bsp brush data.
struct BspBrush
  /// Stores the first side value associated with bsp brush.
  firstSide
  /// Stores the num sides value associated with bsp brush.
  numSides
  /// Stores the contents value associated with bsp brush.
  contents
end struct

/// Store bsp brush side data.
struct BspBrushSide
  /// Stores the plane index value associated with bsp brush side.
  planeIndex
  /// Stores the tex info value associated with bsp brush side.
  texInfo
end struct

/// Store bsp area data.
struct BspArea
  /// Stores the num area portals value associated with bsp area.
  numAreaPortals
  /// Stores the first area portal value associated with bsp area.
  firstAreaPortal
end struct

/// Store bsp area portal data.
struct BspAreaPortal
  /// Stores the portal number value associated with bsp area portal.
  portalNumber
  /// Stores the other area value associated with bsp area portal.
  otherArea
end struct

/// Store bsp visibility data.
struct BspVisibility
  /// Stores the num clusters value associated with bsp visibility.
  numClusters
  /// Stores the pvs offsets value associated with bsp visibility.
  pvsOffsets
  /// Stores the phs offsets value associated with bsp visibility.
  phsOffsets
  /// Stores the data value associated with bsp visibility.
  data
end struct

/// Store bsp map data.
struct BspMap
  /// Stores the name value associated with bsp map.
  name
  /// Stores the data value associated with bsp map.
  data
  /// Stores the lumps value associated with bsp map.
  lumps
  /// Stores the entity text value associated with bsp map.
  entityText
  /// Stores the planes value associated with bsp map.
  planes
  /// Stores the vertices value associated with bsp map.
  vertices
  /// Stores the visibility value associated with bsp map.
  visibility
  /// Stores the nodes value associated with bsp map.
  nodes
  /// Stores the tex info value associated with bsp map.
  texInfo
  /// Stores the faces value associated with bsp map.
  faces
  /// Stores the lighting value associated with bsp map.
  lighting
  /// Stores the leafs value associated with bsp map.
  leafs
  /// Stores the leaf faces value associated with bsp map.
  leafFaces
  /// Stores the leaf brushes value associated with bsp map.
  leafBrushes
  /// Stores the edges value associated with bsp map.
  edges
  /// Stores the surface edges value associated with bsp map.
  surfaceEdges
  /// Stores the models value associated with bsp map.
  models
  /// Stores the brushes value associated with bsp map.
  brushes
  /// Stores the brush sides value associated with bsp map.
  brushSides
  /// Stores the areas value associated with bsp map.
  areas
  /// Stores the area portals value associated with bsp map.
  areaPortals
end struct

/// Store md 2 tex coord data.
struct Md2TexCoord
  /// Stores the s value associated with md2 tex coord.
  s
  /// Stores the t value associated with md2 tex coord.
  t
end struct

/// Store md 2 triangle data.
struct Md2Triangle
  /// Stores the xyz value associated with md2 triangle.
  xyz
  /// Stores the st value associated with md2 triangle.
  st
end struct

/// Store md 2 vertex data.
struct Md2Vertex
  /// Stores the x value associated with md2 vertex.
  x
  /// Stores the y value associated with md2 vertex.
  y
  /// Stores the z value associated with md2 vertex.
  z
  /// Stores the normal index value associated with md2 vertex.
  normalIndex
end struct

/// Store md 2 frame data.
struct Md2Frame
  /// Stores the scale value associated with md2 frame.
  scale
  /// Stores the translate value associated with md2 frame.
  translate
  /// Stores the name value associated with md2 frame.
  name
  /// Stores the vertices value associated with md2 frame.
  vertices
end struct

/// Store md 2 model data.
struct Md2Model
  /// Stores the name value associated with md2 model.
  name
  /// Stores the skin width value associated with md2 model.
  skinWidth
  /// Stores the skin height value associated with md2 model.
  skinHeight
  /// Stores the skins value associated with md2 model.
  skins
  /// Stores the tex coords value associated with md2 model.
  texCoords
  /// Stores the triangles value associated with md2 model.
  triangles
  /// Stores the frames value associated with md2 model.
  frames
  /// Stores the gl commands value associated with md2 model.
  glCommands
  /// Stores the raw data value associated with md2 model.
  rawData
end struct

/// Store sprite frame data.
struct SpriteFrame
  /// Stores the width value associated with sprite frame.
  width
  /// Stores the height value associated with sprite frame.
  height
  /// Stores the origin x value associated with sprite frame.
  originX
  /// Stores the origin y value associated with sprite frame.
  originY
  /// Stores the image name value associated with sprite frame.
  imageName
end struct

/// Store sprite model data.
struct SpriteModel
  /// Stores the name value associated with sprite model.
  name
  /// Stores the frames value associated with sprite model.
  frames
end struct

/// Store wal texture data.
struct WalTexture
  /// Stores the name value associated with wal texture.
  name
  /// Stores the width value associated with wal texture.
  width
  /// Stores the height value associated with wal texture.
  height
  /// Stores the mip offsets value associated with wal texture.
  mipOffsets
  /// Stores the mip pixels value associated with wal texture.
  mipPixels
  /// Stores the animation name value associated with wal texture.
  animationName
  /// Stores the flags value associated with wal texture.
  flags
  /// Stores the contents value associated with wal texture.
  contents
  /// Stores the value value associated with wal texture.
  value
end struct

/// Store pcx image data.
struct PcxImage
  /// Stores the width value associated with pcx image.
  width
  /// Stores the height value associated with pcx image.
  height
  /// Stores the pixels value associated with pcx image.
  pixels
  /// Stores the palette value associated with pcx image.
  palette
end struct

/// Store cinematic header data.
struct CinematicHeader
  /// Stores the width value associated with cinematic header.
  width
  /// Stores the height value associated with cinematic header.
  height
  /// Stores the sample rate value associated with cinematic header.
  sampleRate
  /// Stores the sample width value associated with cinematic header.
  sampleWidth
  /// Stores the sample channels value associated with cinematic header.
  sampleChannels
  /// Stores the huffman counts value associated with cinematic header.
  huffmanCounts
  /// Stores the frame data offset value associated with cinematic header.
  frameDataOffset
end struct

/// Store huffman tree data.
struct HuffmanTree
  /// Stores the root value associated with huffman tree.
  root
  /// Stores the left value associated with huffman tree.
  left
  /// Stores the right value associated with huffman tree.
  right
end struct

/// Store cinematic frame data.
struct CinematicFrame
  /// Stores the command value associated with cinematic frame.
  command
  /// Stores the palette value associated with cinematic frame.
  palette
  /// Stores the pixels value associated with cinematic frame.
  pixels
  /// Stores the audio value associated with cinematic frame.
  audio
  /// Stores the next offset value associated with cinematic frame.
  nextOffset
end struct
