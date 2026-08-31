/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Renderer-independent records produced by the classic BSP scene pass. */
package miniquake2.renderer.classic.types

import miniquake2.format.types as ft

// Store classic image data.
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

// Store surface vertex data.
struct SurfaceVertex
  position
  s
  t
  lightS
  lightT
end struct

// Store classic surface data.
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

// Store classic point light data.
struct ClassicPointLight
  red
  green
  blue
  spotX
  spotY
  spotZ
  validSpot
end struct

// Store texture chain data.
struct TextureChain
  imageName
  surfaces
end struct

// Store sprite vertex data.
struct SpriteVertex
  position
  s
  t
end struct

// Store sprite draw data.
struct SpriteDraw
  frameIndex
  imageName
  vertices
  alpha
  blend
  alphaTest
end struct

// Store classic scene data.
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
  lightmapX
  lightmapY
  vertices
  triangleCount
  mins
  maxs
  centerX
  centerY
  centerZ
  extentX
  extentY
  extentZ
  planeNormalX
  planeNormalY
  planeNormalZ
  planeDistance
  planeSide
end struct

// Store classic sky box data.
struct ClassicSkyBox
  name
  rotate
  axis
  textures
  active
end struct

// Per-view projected portal extents for Quake II's six environment faces.
// Keeping four fixed arrays mirrors ref_gl's skymins/skymaxs layout and lets
// the backend skip hidden cube regions instead of exposing depth seams.
struct ClassicSkyBounds
  minimumS
  minimumT
  maximumS
  maximumT
end struct

// One BSP inline model (*n), sharing its parent world's texture resources.
struct ClassicBrushModel
  modelIndex
  model
  draws
  selectionScratch
  specialScratch
  localLightScratch
  lightmapScratch
end struct

// Capacity-sized arrays reused while splitting visible surfaces into passes.
struct ClassicSpecialPassScratch
  opaqueDraws
  warpDraws
  skyDraws
  transparentDraws
end struct

// Store classic brush submission data.
struct ClassicBrushSubmission
  entity
  brushModel
  plan
  dynamicLightmaps
end struct

// Store classic brush lightmap data.
struct ClassicBrushLightmap
  draw
  rgbaPixels
  dirty
end struct

// Store classic brush frame plan data.
struct ClassicBrushFramePlan
  submissions
  submissionCount
  culledEntities
  surfaces
  triangles
  dirtyLightmaps
end struct

// Store classic transparent draw data.
struct ClassicTransparentDraw
  draw
  entity
  alpha
  distanceSquared
end struct

// Store classic world data.
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
  specialScratch
  alphaDrawByFaceScratch
  alphaMarkedScratch
  alphaOutputScratch
end struct

// Store classic visibility selection data.
struct ClassicVisibilitySelection
  draws
  count
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
  opaqueCount
  warpCount
  skyCount
  transparentCount
end struct

// Store classic submit stats data.
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

// Return the fallback image value.
function fallbackImage(name)
  return ClassicImage(name, 64, 64, bytes(0), bytes(0), bytes(0), 0, "")
end function

// Return the surface vertex value.
function surfaceVertex(position, s, t, lightS, lightT)
  return SurfaceVertex(ft.Vec3(position.x, position.y, position.z), s, t, lightS, lightT)
end function
