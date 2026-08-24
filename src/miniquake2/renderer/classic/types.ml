/* Renderer-independent records produced by the classic BSP scene pass. */
package miniquake2.renderer.classic.types

import miniquake2.format.types as ft

struct ClassicImage
  name
  width
  height
  indexedPixels
  palette
  rgbaPixels
  flags
  animationName
end struct

struct SurfaceVertex
  position
  s
  t
  lightS
  lightT
end struct

struct ClassicSurface
  index
  face
  plane
  texInfo
  image
  animationImages
  category
  alpha
  textureMins
  extents
  lightWidth
  lightHeight
  vertices
  samples
  styles
  dlightBits
  lightmap
  cachedLight
end struct

struct ClassicPointLight
  red
  green
  blue
end struct

struct TextureChain
  imageName
  surfaces
end struct

struct SpriteVertex
  position
  s
  t
end struct

struct SpriteDraw
  frameIndex
  imageName
  vertices
  alpha
  blend
  alphaTest
end struct

struct ClassicScene
  surfaces
  textureChains
  transparentSurfaces
  skySurfaces
  warpSurfaces
  noDrawSurfaces
  sprites
end struct

// CPU-side OpenGL resource description.  `id` is assigned by the backend,
// while the pixel payload remains here so context loss/re-upload is possible
// without reparsing the BSP or WAL.
struct ClassicTexture
  id
  name
  width
  height
  rgbaPixels
  role
  generation
  uploaded
  released
end struct

// One BSP polygon prepared as an exact triangle list.  Opaque surfaces carry
// a lightmap; sky, turbulent and translucent surfaces deliberately do not.
struct ClassicWorldDraw
  surface
  baseTexture
  baseTextures
  lightmapTexture
  vertices
  triangleCount
  mins
  maxs
end struct

struct ClassicSkyBox
  name
  rotate
  axis
  textures
  active
end struct

// One BSP inline model (*n), sharing its parent world's texture resources.
struct ClassicBrushModel
  modelIndex
  model
  draws
end struct

struct ClassicBrushSubmission
  entity
  brushModel
  plan
  dynamicLightmaps
end struct

struct ClassicBrushLightmap
  draw
  rgbaPixels
  dirty
end struct

struct ClassicBrushFramePlan
  submissions
  culledEntities
  surfaces
  triangles
  dirtyLightmaps
end struct

struct ClassicTransparentDraw
  draw
  entity
  alpha
  distanceSquared
end struct

struct ClassicWorld
  name
  generation
  map
  scene
  textures
  draws
  brushModels
  skyBox
  modulate
  released
  pointNodeStack
  pointFarChildStack
  pointMidXStack
  pointMidYStack
  pointMidZStack
  pointEndXStack
  pointEndYStack
  pointEndZStack
end struct

struct ClassicVisibilitySelection
  draws
  viewLeaf
  viewCluster
  pvsCulled
  areaCulled
  frustumCulled
  backfaceCulled
end struct

// Visible surfaces split into Quake II's ordered world passes.  Transparent
// draws are sorted back-to-front for the current view.
struct ClassicSpecialPassPlan
  opaqueDraws
  warpDraws
  skyDraws
  transparentDraws
end struct

struct ClassicSubmitStats
  surfaces
  triangles
  baseVertices
  lightmapVertices
  uploadedTextures
  visibleSurfaces
  culledSurfaces
  viewLeaf
  viewCluster
  opaqueSurfaces
  warpSurfaces
  skySurfaces
  transparentSurfaces
  passOrder
  brushEntities
  brushSurfaces
  brushTriangles
  brushCulledEntities
  brushDirtyLightmaps
  transparentDraws
end struct

function fallbackImage(name)
  return ClassicImage(name, 64, 64, bytes(0), bytes(0), bytes(0), 0, "")
end function

function surfaceVertex(position, s, t, lightS, lightT)
  return SurfaceVertex(ft.Vec3(position.x, position.y, position.z), s, t, lightS, lightT)
end function
