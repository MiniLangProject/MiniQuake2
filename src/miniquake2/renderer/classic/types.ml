//! Provides miniquake2 renderer classic types facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Renderer-independent records produced by the classic BSP scene pass. */
package miniquake2.renderer.classic.types

import miniquake2.format.types as ft

/// Store classic image data.
struct ClassicImage
  /// Stores the name value associated with classic image.
  name
  /// Stores the width value associated with classic image.
  width
  /// Stores the height value associated with classic image.
  height
  /// Stores the indexed pixels value associated with classic image.
  indexedPixels
  /// Stores the palette value associated with classic image.
  palette
  /// Stores the rgba pixels value associated with classic image.
  rgbaPixels
  /// Stores the flags value associated with classic image.
  flags
  /// Stores the animation name value associated with classic image.
  animationName
end struct

/// Store surface vertex data.
struct SurfaceVertex
  /// Stores the position value associated with surface vertex.
  position
  /// Stores the s value associated with surface vertex.
  s
  /// Stores the t value associated with surface vertex.
  t
  /// Stores the light s value associated with surface vertex.
  lightS
  /// Stores the light t value associated with surface vertex.
  lightT
end struct

/// Store classic surface data.
struct ClassicSurface
  /// Stores the index value associated with classic surface.
  index
  /// Stores the face value associated with classic surface.
  face
  /// Stores the plane value associated with classic surface.
  plane
  /// Stores the tex info value associated with classic surface.
  texInfo
  /// Stores the image value associated with classic surface.
  image
  /// Stores the animation images value associated with classic surface.
  animationImages
  /// Stores the category value associated with classic surface.
  category
  /// Stores the alpha value associated with classic surface.
  alpha
  /// Stores the texture mins value associated with classic surface.
  textureMins
  /// Stores the extents value associated with classic surface.
  extents
  /// Stores the light width value associated with classic surface.
  lightWidth
  /// Stores the light height value associated with classic surface.
  lightHeight
  /// Stores the vertices value associated with classic surface.
  vertices
  /// Stores the samples value associated with classic surface.
  samples
  /// Stores the styles value associated with classic surface.
  styles
  /// Stores the dlight bits value associated with classic surface.
  dlightBits
  /// Stores the lightmap value associated with classic surface.
  lightmap
  /// Stores the cached light value associated with classic surface.
  cachedLight
end struct

/// Store classic point light data.
struct ClassicPointLight
  /// Stores the red value associated with classic point light.
  red
  /// Stores the green value associated with classic point light.
  green
  /// Stores the blue value associated with classic point light.
  blue
  /// Stores the spot x value associated with classic point light.
  spotX
  /// Stores the spot y value associated with classic point light.
  spotY
  /// Stores the spot z value associated with classic point light.
  spotZ
  /// Stores the valid spot value associated with classic point light.
  validSpot
end struct

/// Store texture chain data.
struct TextureChain
  /// Stores the image name value associated with texture chain.
  imageName
  /// Stores the surfaces value associated with texture chain.
  surfaces
end struct

/// Store sprite vertex data.
struct SpriteVertex
  /// Stores the position value associated with sprite vertex.
  position
  /// Stores the s value associated with sprite vertex.
  s
  /// Stores the t value associated with sprite vertex.
  t
end struct

/// Store sprite draw data.
struct SpriteDraw
  /// Stores the frame index value associated with sprite draw.
  frameIndex
  /// Stores the image name value associated with sprite draw.
  imageName
  /// Stores the vertices value associated with sprite draw.
  vertices
  /// Stores the alpha value associated with sprite draw.
  alpha
  /// Stores the blend value associated with sprite draw.
  blend
  /// Stores the alpha test value associated with sprite draw.
  alphaTest
end struct

/// Store classic scene data.
struct ClassicScene
  /// Stores the surfaces value associated with classic scene.
  surfaces
  /// Stores the texture chains value associated with classic scene.
  textureChains
  /// Stores the transparent surfaces value associated with classic scene.
  transparentSurfaces
  /// Stores the sky surfaces value associated with classic scene.
  skySurfaces
  /// Stores the warp surfaces value associated with classic scene.
  warpSurfaces
  /// Stores the no draw surfaces value associated with classic scene.
  noDrawSurfaces
  /// Stores the sprites value associated with classic scene.
  sprites
end struct

/// CPU-side OpenGL resource description.  `id` is assigned by the backend,
/// while the pixel payload remains here so context loss/re-upload is possible
/// without reparsing the BSP or WAL.
struct ClassicTexture
  /// Stores the id value associated with classic texture.
  id
  /// Stores the name value associated with classic texture.
  name
  /// Stores the width value associated with classic texture.
  width
  /// Stores the height value associated with classic texture.
  height
  /// Stores the rgba pixels value associated with classic texture.
  rgbaPixels
  /// Stores the role value associated with classic texture.
  role
  /// Stores the generation value associated with classic texture.
  generation
  /// Stores the uploaded value associated with classic texture.
  uploaded
  /// Stores the released value associated with classic texture.
  released
end struct

/// One BSP polygon prepared as an exact triangle list.  Opaque surfaces carry
/// a lightmap; sky, turbulent and translucent surfaces deliberately do not.
struct ClassicWorldDraw
  /// Stores the surface value associated with classic world draw.
  surface
  /// Stores the base texture value associated with classic world draw.
  baseTexture
  /// Stores the base textures value associated with classic world draw.
  baseTextures
  /// Stores the lightmap texture value associated with classic world draw.
  lightmapTexture
  /// Stores the lightmap x value associated with classic world draw.
  lightmapX
  /// Stores the lightmap y value associated with classic world draw.
  lightmapY
  /// Stores the vertices value associated with classic world draw.
  vertices
  /// Stores the triangle count value associated with classic world draw.
  triangleCount
  /// Stores the mins value associated with classic world draw.
  mins
  /// Stores the maxs value associated with classic world draw.
  maxs
  /// Stores the center x value associated with classic world draw.
  centerX
  /// Stores the center y value associated with classic world draw.
  centerY
  /// Stores the center z value associated with classic world draw.
  centerZ
  /// Stores the extent x value associated with classic world draw.
  extentX
  /// Stores the extent y value associated with classic world draw.
  extentY
  /// Stores the extent z value associated with classic world draw.
  extentZ
  /// Stores the plane normal x value associated with classic world draw.
  planeNormalX
  /// Stores the plane normal y value associated with classic world draw.
  planeNormalY
  /// Stores the plane normal z value associated with classic world draw.
  planeNormalZ
  /// Stores the plane distance value associated with classic world draw.
  planeDistance
  /// Stores the plane side value associated with classic world draw.
  planeSide
end struct

/// Store classic sky box data.
struct ClassicSkyBox
  /// Stores the name value associated with classic sky box.
  name
  /// Stores the rotate value associated with classic sky box.
  rotate
  /// Stores the axis value associated with classic sky box.
  axis
  /// Stores the textures value associated with classic sky box.
  textures
  /// Stores the active value associated with classic sky box.
  active
end struct

/// Per-view projected portal extents for Quake II's six environment faces.
/// Keeping four fixed arrays mirrors ref_gl's skymins/skymaxs layout and lets
/// the backend skip hidden cube regions instead of exposing depth seams.
struct ClassicSkyBounds
  /// Stores the minimum s value associated with classic sky bounds.
  minimumS
  /// Stores the minimum t value associated with classic sky bounds.
  minimumT
  /// Stores the maximum s value associated with classic sky bounds.
  maximumS
  /// Stores the maximum t value associated with classic sky bounds.
  maximumT
end struct

/// One BSP inline model (*n), sharing its parent world's texture resources.
struct ClassicBrushModel
  /// Stores the model index value associated with classic brush model.
  modelIndex
  /// Stores the model value associated with classic brush model.
  model
  /// Stores the draws value associated with classic brush model.
  draws
  /// Stores the selection scratch value associated with classic brush model.
  selectionScratch
  /// Stores the special scratch value associated with classic brush model.
  specialScratch
  /// Stores the local light scratch value associated with classic brush model.
  localLightScratch
  /// Stores the lightmap scratch value associated with classic brush model.
  lightmapScratch
end struct

/// Capacity-sized arrays reused while splitting visible surfaces into passes.
struct ClassicSpecialPassScratch
  /// Stores the opaque draws value associated with classic special pass scratch.
  opaqueDraws
  /// Stores the warp draws value associated with classic special pass scratch.
  warpDraws
  /// Stores the sky draws value associated with classic special pass scratch.
  skyDraws
  /// Stores the transparent draws value associated with classic special pass scratch.
  transparentDraws
end struct

/// Store classic brush submission data.
struct ClassicBrushSubmission
  /// Stores the entity value associated with classic brush submission.
  entity
  /// Stores the brush model value associated with classic brush submission.
  brushModel
  /// Stores the plan value associated with classic brush submission.
  plan
  /// Stores the dynamic lightmaps value associated with classic brush submission.
  dynamicLightmaps
end struct

/// Store classic brush lightmap data.
struct ClassicBrushLightmap
  /// Stores the draw value associated with classic brush lightmap.
  draw
  /// Stores the rgba pixels value associated with classic brush lightmap.
  rgbaPixels
  /// Stores the dirty value associated with classic brush lightmap.
  dirty
end struct

/// Store classic brush frame plan data.
struct ClassicBrushFramePlan
  /// Stores the submissions value associated with classic brush frame plan.
  submissions
  /// Stores the submission count value associated with classic brush frame plan.
  submissionCount
  /// Stores the culled entities value associated with classic brush frame plan.
  culledEntities
  /// Stores the surfaces value associated with classic brush frame plan.
  surfaces
  /// Stores the triangles value associated with classic brush frame plan.
  triangles
  /// Stores the dirty lightmaps value associated with classic brush frame plan.
  dirtyLightmaps
end struct

/// Store classic transparent draw data.
struct ClassicTransparentDraw
  /// Stores the draw value associated with classic transparent draw.
  draw
  /// Stores the entity value associated with classic transparent draw.
  entity
  /// Stores the alpha value associated with classic transparent draw.
  alpha
  /// Stores the distance squared value associated with classic transparent draw.
  distanceSquared
end struct

/// Store classic world data.
struct ClassicWorld
  /// Stores the name value associated with classic world.
  name
  /// Stores the generation value associated with classic world.
  generation
  /// Stores the map value associated with classic world.
  map
  /// Stores the scene value associated with classic world.
  scene
  /// Stores the textures value associated with classic world.
  textures
  /// Stores the draws value associated with classic world.
  draws
  /// Stores the brush models value associated with classic world.
  brushModels
  /// Stores the sky box value associated with classic world.
  skyBox
  /// Stores the modulate value associated with classic world.
  modulate
  /// Stores the released value associated with classic world.
  released
  /// Stores the point node stack value associated with classic world.
  pointNodeStack
  /// Stores the point far child stack value associated with classic world.
  pointFarChildStack
  /// Stores the point mid xstack value associated with classic world.
  pointMidXStack
  /// Stores the point mid ystack value associated with classic world.
  pointMidYStack
  /// Stores the point mid zstack value associated with classic world.
  pointMidZStack
  /// Stores the point end xstack value associated with classic world.
  pointEndXStack
  /// Stores the point end ystack value associated with classic world.
  pointEndYStack
  /// Stores the point end zstack value associated with classic world.
  pointEndZStack
  /// Stores the special scratch value associated with classic world.
  specialScratch
  /// Stores the alpha draw by face scratch value associated with classic world.
  alphaDrawByFaceScratch
  /// Stores the alpha marked scratch value associated with classic world.
  alphaMarkedScratch
  /// Stores the alpha output scratch value associated with classic world.
  alphaOutputScratch
end struct

/// Store classic visibility selection data.
struct ClassicVisibilitySelection
  /// Stores the draws value associated with classic visibility selection.
  draws
  /// Stores the count value associated with classic visibility selection.
  count
  /// Stores the view leaf value associated with classic visibility selection.
  viewLeaf
  /// Stores the view cluster value associated with classic visibility selection.
  viewCluster
  /// Stores the pvs culled value associated with classic visibility selection.
  pvsCulled
  /// Stores the area culled value associated with classic visibility selection.
  areaCulled
  /// Stores the frustum culled value associated with classic visibility selection.
  frustumCulled
  /// Stores the backface culled value associated with classic visibility selection.
  backfaceCulled
end struct

/// Visible surfaces split into Quake II's ordered world passes.  Transparent
/// draws are sorted back-to-front for the current view.
struct ClassicSpecialPassPlan
  /// Stores the opaque draws value associated with classic special pass plan.
  opaqueDraws
  /// Stores the warp draws value associated with classic special pass plan.
  warpDraws
  /// Stores the sky draws value associated with classic special pass plan.
  skyDraws
  /// Stores the transparent draws value associated with classic special pass plan.
  transparentDraws
  /// Stores the opaque count value associated with classic special pass plan.
  opaqueCount
  /// Stores the warp count value associated with classic special pass plan.
  warpCount
  /// Stores the sky count value associated with classic special pass plan.
  skyCount
  /// Stores the transparent count value associated with classic special pass plan.
  transparentCount
end struct

/// Store classic submit stats data.
struct ClassicSubmitStats
  /// Stores the surfaces value associated with classic submit stats.
  surfaces
  /// Stores the triangles value associated with classic submit stats.
  triangles
  /// Stores the base vertices value associated with classic submit stats.
  baseVertices
  /// Stores the lightmap vertices value associated with classic submit stats.
  lightmapVertices
  /// Stores the uploaded textures value associated with classic submit stats.
  uploadedTextures
  /// Stores the visible surfaces value associated with classic submit stats.
  visibleSurfaces
  /// Stores the culled surfaces value associated with classic submit stats.
  culledSurfaces
  /// Stores the view leaf value associated with classic submit stats.
  viewLeaf
  /// Stores the view cluster value associated with classic submit stats.
  viewCluster
  /// Stores the opaque surfaces value associated with classic submit stats.
  opaqueSurfaces
  /// Stores the warp surfaces value associated with classic submit stats.
  warpSurfaces
  /// Stores the sky surfaces value associated with classic submit stats.
  skySurfaces
  /// Stores the transparent surfaces value associated with classic submit stats.
  transparentSurfaces
  /// Stores the pass order value associated with classic submit stats.
  passOrder
  /// Stores the brush entities value associated with classic submit stats.
  brushEntities
  /// Stores the brush surfaces value associated with classic submit stats.
  brushSurfaces
  /// Stores the brush triangles value associated with classic submit stats.
  brushTriangles
  /// Stores the brush culled entities value associated with classic submit stats.
  brushCulledEntities
  /// Stores the brush dirty lightmaps value associated with classic submit stats.
  brushDirtyLightmaps
  /// Stores the transparent draws value associated with classic submit stats.
  transparentDraws
end struct

/// Return the fallback image value.
/// @param name Name of the affected item.
function fallbackImage(name)
  return ClassicImage(name, 64, 64, bytes(0), bytes(0), bytes(0), 0, "")
end function

/// Return the surface vertex value.
/// @param position position value consumed by this operation.
/// @param s s value consumed by this operation.
/// @param t t value consumed by this operation.
/// @param lightS lightS value consumed by this operation.
/// @param lightT lightT value consumed by this operation.
function surfaceVertex(position, s, t, lightS, lightT)
  return SurfaceVertex(ft.Vec3(position.x, position.y, position.z), s, t, lightS, lightT)
end function
