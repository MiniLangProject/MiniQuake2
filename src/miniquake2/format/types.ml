/* Managed representations of Quake II on-disk records. */
package miniquake2.format.types

struct Vec3
  x
  y
  z
end struct

struct Lump
  offset
  length
end struct

struct BspPlane
  normal
  distance
  type
end struct

struct BspVertex
  position
end struct

struct BspNode
  planeIndex
  child0
  child1
  mins
  maxs
  firstFace
  numFaces
end struct

struct BspTexInfo
  s
  t
  flags
  value
  texture
  nextTexInfo
end struct

struct BspFace
  planeIndex
  side
  firstEdge
  numEdges
  texInfo
  styles
  lightOffset
end struct

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

struct BspEdge
  vertex0
  vertex1
end struct

struct BspModel
  mins
  maxs
  origin
  headNode
  firstFace
  numFaces
end struct

struct BspBrush
  firstSide
  numSides
  contents
end struct

struct BspBrushSide
  planeIndex
  texInfo
end struct

struct BspArea
  numAreaPortals
  firstAreaPortal
end struct

struct BspAreaPortal
  portalNumber
  otherArea
end struct

struct BspVisibility
  numClusters
  pvsOffsets
  phsOffsets
  data
end struct

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

struct Md2TexCoord
  s
  t
end struct

struct Md2Triangle
  xyz
  st
end struct

struct Md2Vertex
  x
  y
  z
  normalIndex
end struct

struct Md2Frame
  scale
  translate
  name
  vertices
end struct

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

struct SpriteFrame
  width
  height
  originX
  originY
  imageName
end struct

struct SpriteModel
  name
  frames
end struct

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

struct PcxImage
  width
  height
  pixels
  palette
end struct

struct CinematicHeader
  width
  height
  sampleRate
  sampleWidth
  sampleChannels
  huffmanCounts
  frameDataOffset
end struct

struct HuffmanTree
  root
  left
  right
end struct

struct CinematicFrame
  command
  palette
  pixels
  audio
  nextOffset
end struct
