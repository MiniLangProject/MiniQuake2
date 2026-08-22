/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Small, real OpenGL 1.1 backend behind Quake II's refexport_t-shaped table.
Registration and validation stay in the deterministic renderer core.  When a
platform window owns a current GL context this adapter adds viewport/camera
setup, frame clearing, classic textured BSP submission, entity/particle debug
geometry, 2-D fills and swapping.
*/
package miniquake2.renderer.opengl

import std.math as rmath
import miniquake2.native as native
import miniquake2.qcommon.byteio as ropenglbyteio
import miniquake2.qcommon.types as ropenglqtypes
import miniquake2.renderer.constants as rc
import miniquake2.renderer.types as rt
import miniquake2.renderer.recording as recording
import miniquake2.renderer.assets as rassets
import miniquake2.renderer.geometry as rgeom
import miniquake2.renderer.classic.types as rclassictypes
import miniquake2.renderer.classic.world as rclassicworld
import miniquake2.renderer.classic.visibility as rclassicvisibility
import miniquake2.renderer.classic.special as rclassicspecial
import miniquake2.renderer.classic.lightmaps as rclassiclightmaps

const GL_POINTS = 0x0000
const GL_LINES = 0x0001
const GL_TRIANGLES = 0x0004
const GL_QUADS = 0x0007
const GL_DEPTH_BUFFER_BIT = 0x00000100
const GL_COLOR_BUFFER_BIT = 0x00004000
const GL_EQUAL = 0x0202
const GL_LEQUAL = 0x0203
const GL_ZERO = 0x0000
const GL_SRC_COLOR = 0x0300
const GL_SRC_ALPHA = 0x0302
const GL_ONE_MINUS_SRC_ALPHA = 0x0303
const GL_BLEND = 0x0BE2
const GL_DEPTH_TEST = 0x0B71
const GL_TEXTURE_2D = 0x0DE1
const GL_MODELVIEW = 0x1700
const GL_PROJECTION = 0x1701
const GL_RGBA = 0x1908
const GL_UNSIGNED_BYTE = 0x1401
const GL_TEXTURE_MAG_FILTER = 0x2800
const GL_TEXTURE_MIN_FILTER = 0x2801
const GL_TEXTURE_WRAP_S = 0x2802
const GL_TEXTURE_WRAP_T = 0x2803
const GL_LINEAR = 0x2601
const GL_CLAMP = 0x2900
const GL_REPEAT = 0x2901
const GL_VENDOR = 0x1F00
const GL_RENDERER = 0x1F01
const GL_VERSION = 0x1F02
const DEG_TO_RAD = 0.017453292519943295

struct OpenGlState
  core
  imports
  assets
  contextActive
  vendor
  renderer
  version
  submittedFrames
  submittedEntities
  submittedParticles
  nextTextureId
  textureRecords
end struct

// The native bridge creates OpenGL 1.1 names on first bind.  Keeping every
// allocation here makes generation ownership and release observable. Uploaded
// names are physically deleted through the shared OpenGL bridge; headless
// records follow the same logical lifecycle without a native call.
struct GlTextureRecord
  id
  name
  role
  generation
  width
  height
  uploaded
  released
end struct

// The v3 renderer API selects one backend at a time.  These renderer-specific
// names avoid the self-hosted linker's full-program collisions with the
// recording backend's own makeExports/state closure symbols.
struct OpenGlBackendSlot
  backend
end struct

struct OpenGlFileImports
  fsLoadFile
end struct

struct Md2EntityPlan
  modelAsset
  skinAsset
  mesh
  glVertices
  bounds
  frame
  oldFrame
  backLerp
end struct

struct Md2SubmitStats
  submitted
  triangles
  vertices
  textureId
  bounds
end struct

// Mutating a package-owned holder is reliable across the self-hosted full
// graph; rebinding a package global from a function is not.
openGlBackendSlot = OpenGlBackendSlot(void)

function bits(value)
  return native.floatBits(value)
end function

function allocateTextureRecord(backend, name, role, generation, width, height)
  record = GlTextureRecord(backend.nextTextureId, name, role, generation, width, height, false, false)
  backend.nextTextureId = backend.nextTextureId + 1
  backend.textureRecords = backend.textureRecords + [record]
  return record
end function

function findTextureRecord(backend, id)
  for each record in backend.textureRecords
    if record.id == id then return record end if
  end for
  return void
end function

function releaseOpenGlTextureRecord(backend, record)
  if record is void or record.released then return false end if
  if backend.contextActive and record.uploaded then
    textureIds = bytes(4)
    textureIds[0] = record.id & 255
    textureIds[1] = (record.id >> 8) & 255
    textureIds[2] = (record.id >> 16) & 255
    textureIds[3] = (record.id >> 24) & 255
    native.glDeleteTextures(1, textureIds)
  end if
  record.released = true
  record.uploaded = false
  return true
end function

function releaseOpenGlTextureRecords(backend)
  released = 0
  for each record in backend.textureRecords
    if releaseOpenGlTextureRecord(backend, record) then released = released + 1 end if
  end for
  return released
end function

function colorByte(value, shift)
  return (value >> shift) & 255
end function

function setup3d(frame)
  viewportX = frame.x; viewportY = frame.y; viewportWidth = frame.width; viewportHeight = frame.height
  fovX = frame.fovX; fovY = frame.fovY
  viewAngles = frame.viewAngles; viewOrigin = frame.viewOrigin
  angleX = viewAngles.x; angleY = viewAngles.y; angleZ = viewAngles.z
  originX = viewOrigin.x; originY = viewOrigin.y; originZ = viewOrigin.z
  native.glViewport(viewportX, viewportY, viewportWidth, viewportHeight)
  nearValue = 4.0
  halfX = fovX * DEG_TO_RAD * 0.5
  halfY = fovY * DEG_TO_RAD * 0.5
  horizontal = nearValue * rmath.sin(halfX) / rmath.cos(halfX)
  vertical = nearValue * rmath.sin(halfY) / rmath.cos(halfY)

  native.glMatrixMode(GL_PROJECTION)
  native.glLoadIdentity()
  native.glFrustum(bits(-horizontal), bits(horizontal), bits(-vertical), bits(vertical), bits(nearValue), bits(8192.0))
  native.glMatrixMode(GL_MODELVIEW)
  native.glLoadIdentity()
  native.glRotate(bits(-90.0), bits(1.0), bits(0.0), bits(0.0))
  native.glRotate(bits(90.0), bits(0.0), bits(0.0), bits(1.0))
  native.glRotate(bits(-angleZ), bits(1.0), bits(0.0), bits(0.0))
  native.glRotate(bits(-angleX), bits(0.0), bits(1.0), bits(0.0))
  native.glRotate(bits(-angleY), bits(0.0), bits(0.0), bits(1.0))
  native.glTranslate(bits(-originX), bits(-originY), bits(-originZ))
end function

function drawEntityMarkers(backend, frame)
  if frame.numEntities <= 0 then return void end if
  native.glColor4ub(255, 224, 64, 255)
  native.glBegin(GL_TRIANGLES)
  index = 0
  while index < frame.numEntities
    entity = frame.entities[index]
    modelAsset = rassets.findModelByHandle(backend.assets, entity.model)
    if modelAsset is void or (modelAsset.kind != "md2" and modelAsset.kind != "bsp-inline") then
      origin = entity.origin
      originX = origin.x; originY = origin.y; originZ = origin.z
      native.glVertex3(bits(originX), bits(originY), bits(originZ + 8.0))
      native.glVertex3(bits(originX - 4.0), bits(originY), bits(originZ))
      native.glVertex3(bits(originX + 4.0), bits(originY), bits(originZ))
    end if
    index = index + 1
  end while
  native.glEnd()
end function

function drawParticles(frame)
  if frame.numParticles <= 0 then return void end if
  native.glEnable(GL_BLEND)
  native.glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
  native.glBegin(GL_POINTS)
  index = 0
  while index < frame.numParticles
    particle = frame.particles[index]
    particleAlpha = particle.alpha
    particleColor = particle.color
    particleOrigin = particle.origin
    particleX = particleOrigin.x; particleY = particleOrigin.y; particleZ = particleOrigin.z
    if particleAlpha > 0.0 then
      // The software palette index is expanded to a deterministic RGB cube.
      palette = particleColor & 255
      red = (palette & 0xE0)
      green = (palette & 0x1C) << 3
      blue = (palette & 0x03) << 6
      native.glColor4ub(red, green, blue, 255)
      native.glVertex3(bits(particleX), bits(particleY), bits(particleZ))
    end if
    index = index + 1
  end while
  native.glEnd()
  native.glDisable(GL_BLEND)
end function

function setup2d()
  width = native.winClientWidth()
  height = native.winClientHeight()
  if width < 1 then width = 1 end if
  if height < 1 then height = 1 end if
  native.glViewport(0, 0, width, height)
  native.glMatrixMode(GL_PROJECTION)
  native.glLoadIdentity()
  native.glOrtho(bits(0.0), bits(width * 1.0), bits(height * 1.0), bits(0.0), bits(-1.0), bits(1.0))
  native.glMatrixMode(GL_MODELVIEW)
  native.glLoadIdentity()
  native.glDisable(GL_DEPTH_TEST)
end function

function drawSolidRect(x, y, width, height, color)
  setup2d()
  red = (color & 0xE0)
  green = (color & 0x1C) << 3
  blue = (color & 0x03) << 6
  native.glColor4ub(red, green, blue, 255)
  native.glBegin(GL_QUADS)
  native.glVertex2(bits(x * 1.0), bits(y * 1.0))
  native.glVertex2(bits((x + width) * 1.0), bits(y * 1.0))
  native.glVertex2(bits((x + width) * 1.0), bits((y + height) * 1.0))
  native.glVertex2(bits(x * 1.0), bits((y + height) * 1.0))
  native.glEnd()
end function

function picturePixels(asset)
  pixels = asset.source.pixels
  if asset.kind == "wal" then pixels = asset.source.mipPixels[0] end if
  palette = bytes(0)
  if asset.kind == "pcx" then palette = asset.source.palette end if
  rgba = bytes(asset.width * asset.height * 4)
  index = 0
  while index < asset.width * asset.height
    color = pixels[index]
    red = color
    green = color
    blue = color
    if len(palette) == 768 then
      red = palette[color * 3]
      green = palette[color * 3 + 1]
      blue = palette[color * 3 + 2]
    end if
    rgba[index * 4] = red
    rgba[index * 4 + 1] = green
    rgba[index * 4 + 2] = blue
    rgba[index * 4 + 3] = 255
    if color == 255 then rgba[index * 4 + 3] = 0 end if
    index = index + 1
  end while
  return rgba
end function

function pictureUploadPixels(asset)
  rgba = picturePixels(asset)
  if asset.usage != "skin" then return rgba end if
  index = 0
  while index < asset.width * asset.height
    red = rgba[index * 4] * 2
    green = rgba[index * 4 + 1] * 2
    blue = rgba[index * 4 + 2] * 2
    if red > 255 then red = 255 end if
    if green > 255 then green = 255 end if
    if blue > 255 then blue = 255 end if
    rgba[index * 4] = red
    rgba[index * 4 + 1] = green
    rgba[index * 4 + 2] = blue
    index = index + 1
  end while
  return rgba
end function

function ensureOpenGlPictureTexture(backend, asset)
  record = void
  if asset.textureId != 0 then record = findTextureRecord(backend, asset.textureId) end if
  if record is void then
    record = allocateTextureRecord(backend, asset.handle.name, "picture", asset.handle.generation, asset.width, asset.height)
    asset.textureId = record.id
  end if
  if record.released then return error(9622, "attempted upload of released picture texture") end if
  return record
end function

function uploadPicture(backend, asset)
  record = ensureOpenGlPictureTexture(backend, asset)
  textureId = asset.textureId
  if record.uploaded then return textureId end if
  textureWidth = asset.width; textureHeight = asset.height
  texturePixels = pictureUploadPixels(asset)
  native.glBindTexture(GL_TEXTURE_2D, textureId)
  native.glTexParameterI(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
  native.glTexParameterI(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
  native.glTexParameterI(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT)
  native.glTexParameterI(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT)
  native.glTexImage2D(GL_TEXTURE_2D, 0, 4, textureWidth, textureHeight, 0, GL_RGBA, GL_UNSIGNED_BYTE, texturePixels)
  record.uploaded = true
  return textureId
end function

function drawTexturedRect(backend, asset, x, y, width, height)
  setup2d()
  native.glEnable(GL_TEXTURE_2D)
  native.glEnable(GL_BLEND)
  native.glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
  native.glBindTexture(GL_TEXTURE_2D, uploadPicture(backend, asset))
  native.glColor4ub(255, 255, 255, 255)
  native.glBegin(GL_QUADS)
  native.glTexcoord2(bits(0.0), bits(0.0)); native.glVertex2(bits(x * 1.0), bits(y * 1.0))
  native.glTexcoord2(bits(1.0), bits(0.0)); native.glVertex2(bits((x + width) * 1.0), bits(y * 1.0))
  native.glTexcoord2(bits(1.0), bits(1.0)); native.glVertex2(bits((x + width) * 1.0), bits((y + height) * 1.0))
  native.glTexcoord2(bits(0.0), bits(1.0)); native.glVertex2(bits(x * 1.0), bits((y + height) * 1.0))
  native.glEnd()
  native.glDisable(GL_BLEND)
end function

function resolveOpenGlMd2Skin(backend, modelAsset, entity)
  if entity.skin is not void then return rassets.pictureForHandle(backend.assets, entity.skin) end if
  if len(modelAsset.skins) == 0 then return error(9627, "MD2 entity has no registered PCX skin") end if
  skinIndex = entity.skinNum
  if skinIndex < 0 or skinIndex >= len(modelAsset.skins) then skinIndex = 0 end if
  return modelAsset.skins[skinIndex]
end function

function prepareOpenGlMd2Entity(backend, entity)
  modelAsset = rassets.modelForHandle(backend.assets, entity.model)
  if modelAsset.kind != "md2" then return error(9628, "entity model is not MD2") end if
  openGlMd2FrameIndex = entity.frame
  openGlMd2OldFrameIndex = entity.oldFrame
  openGlMd2FrameCount = len(modelAsset.source.frames)
  // ref_gl R_DrawAliasModel prints a developer warning and resets both
  // frames when either index is outside the MD2 table. Recorded release
  // demos rely on this tolerant renderer boundary.
  if openGlMd2FrameIndex < 0 or openGlMd2FrameIndex >= openGlMd2FrameCount then
    openGlMd2FrameIndex = 0
    openGlMd2OldFrameIndex = 0
  end if
  if openGlMd2OldFrameIndex < 0 or openGlMd2OldFrameIndex >= openGlMd2FrameCount then
    openGlMd2FrameIndex = 0
    openGlMd2OldFrameIndex = 0
  end if
  mesh = rgeom.md2FrameMesh(modelAsset.source, openGlMd2FrameIndex,
    openGlMd2OldFrameIndex, entity.backLerp)
  bounds = rgeom.md2FrameBounds(modelAsset.source, openGlMd2FrameIndex,
    openGlMd2OldFrameIndex, entity.backLerp)
  skinAsset = resolveOpenGlMd2Skin(backend, modelAsset, entity)
  glVertices = array(len(mesh.vertices) * 5, 0.0)
  vertexIndex = 0
  while vertexIndex < len(mesh.vertices)
    vertex = mesh.vertices[vertexIndex]
    position = vertex.position
    scalarIndex = vertexIndex * 5
    glVertices[scalarIndex] = vertex.s
    glVertices[scalarIndex + 1] = vertex.t
    glVertices[scalarIndex + 2] = position.x
    glVertices[scalarIndex + 3] = position.y
    glVertices[scalarIndex + 4] = position.z
    vertexIndex = vertexIndex + 1
  end while
  return Md2EntityPlan(modelAsset, skinAsset, mesh, glVertices, bounds,
    openGlMd2FrameIndex, openGlMd2OldFrameIndex, entity.backLerp)
end function

function drawOpenGlMd2Plan(backend, plan, entity)
  // Root every managed/nested value before the first native call. The
  // self-hosted runtime may otherwise reclaim a loop's nested position struct
  // across an FFI boundary even while its parent MeshVertex is still live.
  skinAsset = plan.skinAsset
  glVertices = plan.glVertices
  vertexScalarCount = len(glVertices)
  triangleCount = plan.mesh.triangleCount
  vertexCount = len(plan.mesh.vertices)
  resultBounds = plan.bounds
  entityFlags = entity.flags; entityAlpha = entity.alpha
  entityOrigin = entity.origin; entityAngles = entity.angles
  originX = entityOrigin.x; originY = entityOrigin.y; originZ = entityOrigin.z
  angleX = entityAngles.x; angleY = entityAngles.y; angleZ = entityAngles.z
  textureId = uploadPicture(backend, skinAsset)
  alpha = 255
  translucent = (entityFlags & rc.RF_TRANSLUCENT) != 0
  if translucent then
    alphaValue = entityAlpha
    if alphaValue < 0.0 then alphaValue = 0.0 end if
    if alphaValue > 1.0 then alphaValue = 1.0 end if
    alpha = ropenglbyteio.truncInt(alphaValue * 255.0)
    native.glEnable(GL_BLEND)
    native.glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
    native.glDepthMask(0)
  else
    native.glDisable(GL_BLEND)
    native.glDepthMask(1)
  end if
  native.glEnable(GL_TEXTURE_2D)
  native.glBindTexture(GL_TEXTURE_2D, textureId)
  native.glColor4ub(255, 255, 255, alpha)
  native.glPushMatrix()
  native.glTranslate(bits(originX), bits(originY), bits(originZ))
  native.glRotate(bits(angleZ), bits(1.0), bits(0.0), bits(0.0))
  native.glRotate(bits(-angleX), bits(0.0), bits(1.0), bits(0.0))
  native.glRotate(bits(angleY), bits(0.0), bits(0.0), bits(1.0))
  native.glBegin(GL_TRIANGLES)
  scalarIndex = 0
  while scalarIndex < vertexScalarCount
    textureS = glVertices[scalarIndex]
    textureT = glVertices[scalarIndex + 1]
    positionX = glVertices[scalarIndex + 2]
    positionY = glVertices[scalarIndex + 3]
    positionZ = glVertices[scalarIndex + 4]
    native.glTexcoord2(bits(textureS), bits(textureT))
    native.glVertex3(bits(positionX), bits(positionY), bits(positionZ))
    scalarIndex = scalarIndex + 5
  end while
  native.glEnd()
  native.glPopMatrix()
  if translucent then
    native.glDepthMask(1)
    native.glDisable(GL_BLEND)
  end if
  native.glColor4ub(255, 255, 255, 255)
  return Md2SubmitStats(true, triangleCount, vertexCount, textureId, resultBounds)
end function

function submitOpenGlRefDefMd2Entities(backend, frame)
  submitted = 0
  entityIndex = 0
  while entityIndex < frame.numEntities
    entity = frame.entities[entityIndex]
    modelAsset = rassets.findModelByHandle(backend.assets, entity.model)
    if modelAsset is not void and modelAsset.kind == "md2" then
      plan = prepareOpenGlMd2Entity(backend, entity)
      drawOpenGlMd2Plan(backend, plan, entity)
      submitted = submitted + 1
    end if
    entityIndex = entityIndex + 1
  end while
  return submitted
end function

function openGlMakeExports()
  // Extract uncaptured pass-through callbacks before nested closure creation.
  // The self-hosted compiler can otherwise clear a captured struct parameter
  // before RefExport evaluates late direct member accesses in large programs.
  coreSetSky = openGlBackendSlot.backend.core.exports.SetSky
  coreEndRegistration = openGlBackendSlot.backend.core.exports.EndRegistration
  coreDrawChar = openGlBackendSlot.backend.core.exports.DrawChar
  coreDrawTileClear = openGlBackendSlot.backend.core.exports.DrawTileClear
  coreDrawFadeScreen = openGlBackendSlot.backend.core.exports.DrawFadeScreen
  coreDrawStretchRaw = openGlBackendSlot.backend.core.exports.DrawStretchRaw
  coreCinematicSetPalette = openGlBackendSlot.backend.core.exports.CinematicSetPalette
  coreAppActivate = openGlBackendSlot.backend.core.exports.AppActivate

  function rendererInit(hinstance, wndproc)
    openGlCurrentBackend = openGlBackendSlot.backend
    result = openGlCurrentBackend.core.exports.Init(hinstance, wndproc)
    if openGlCurrentBackend.contextActive then
      openGlCurrentBackend.vendor = native.glGetString(GL_VENDOR)
      openGlCurrentBackend.renderer = native.glGetString(GL_RENDERER)
      openGlCurrentBackend.version = native.glGetString(GL_VERSION)
    end if
    return result
  end function

  function rendererShutdown()
    openGlCurrentBackend = openGlBackendSlot.backend
    releaseOpenGlTextureRecords(openGlCurrentBackend)
    return openGlCurrentBackend.core.exports.Shutdown()
  end function

  function beginRegistration(mapName)
    openGlCurrentBackend = openGlBackendSlot.backend
    result = openGlCurrentBackend.core.exports.BeginRegistration(mapName)
    releaseOpenGlTextureRecords(openGlCurrentBackend)
    rassets.beginRegistration(openGlCurrentBackend.assets)
    return result
  end function

  function registerModel(name)
    openGlCurrentBackend = openGlBackendSlot.backend
    baseHandle = openGlCurrentBackend.core.exports.RegisterModel(name)
    if openGlCurrentBackend.imports is void then return baseHandle end if
    modelAsset = rassets.registerModel(openGlCurrentBackend.assets, openGlCurrentBackend.imports, name)
    if modelAsset.kind == "md2" then
      for each skinAsset in modelAsset.skins
        ensureOpenGlPictureTexture(openGlCurrentBackend, skinAsset)
        if openGlCurrentBackend.contextActive then uploadPicture(openGlCurrentBackend, skinAsset) end if
      end for
    end if
    return modelAsset.handle
  end function

  function registerSkin(name)
    openGlCurrentBackend = openGlBackendSlot.backend
    baseHandle = openGlCurrentBackend.core.exports.RegisterSkin(name)
    if openGlCurrentBackend.imports is void then return baseHandle end if
    asset = rassets.registerPicture(openGlCurrentBackend.assets, openGlCurrentBackend.imports, name)
    ensureOpenGlPictureTexture(openGlCurrentBackend, asset)
    if openGlCurrentBackend.contextActive then uploadPicture(openGlCurrentBackend, asset) end if
    return asset.handle
  end function

  function registerPic(name)
    openGlCurrentBackend = openGlBackendSlot.backend
    baseHandle = openGlCurrentBackend.core.exports.RegisterPic(name)
    if openGlCurrentBackend.imports is void then return baseHandle end if
    asset = rassets.registerPicture(openGlCurrentBackend.assets, openGlCurrentBackend.imports, name)
    ensureOpenGlPictureTexture(openGlCurrentBackend, asset)
    if openGlCurrentBackend.contextActive then uploadPicture(openGlCurrentBackend, asset) end if
    return asset.handle
  end function

  function drawGetPicSize(name)
    openGlCurrentBackend = openGlBackendSlot.backend
    if openGlCurrentBackend.imports is not void then
      asset = rassets.findPicture(openGlCurrentBackend.assets, name)
      if asset is void then asset = rassets.registerPicture(openGlCurrentBackend.assets, openGlCurrentBackend.imports, name) end if
      return rt.PicSize(asset.width, asset.height)
    end if
    return openGlCurrentBackend.core.exports.DrawGetPicSize(name)
  end function

  function drawStretchPic(x, y, width, height, name)
    openGlCurrentBackend = openGlBackendSlot.backend
    result = openGlCurrentBackend.core.exports.DrawStretchPic(x, y, width, height, name)
    if openGlCurrentBackend.contextActive and openGlCurrentBackend.imports is not void then
      asset = rassets.findPicture(openGlCurrentBackend.assets, name)
      if asset is void then asset = rassets.registerPicture(openGlCurrentBackend.assets, openGlCurrentBackend.imports, name) end if
      drawTexturedRect(openGlCurrentBackend, asset, x, y, width, height)
    end if
    return result
  end function

  function drawPic(x, y, name)
    openGlCurrentBackend = openGlBackendSlot.backend
    result = openGlCurrentBackend.core.exports.DrawPic(x, y, name)
    if openGlCurrentBackend.contextActive and openGlCurrentBackend.imports is not void then
      asset = rassets.findPicture(openGlCurrentBackend.assets, name)
      if asset is void then asset = rassets.registerPicture(openGlCurrentBackend.assets, openGlCurrentBackend.imports, name) end if
      drawTexturedRect(openGlCurrentBackend, asset, x, y, asset.width, asset.height)
    end if
    return result
  end function

  function renderFrame(frame)
    openGlCurrentBackend = openGlBackendSlot.backend
    result = openGlCurrentBackend.core.exports.RenderFrame(frame)
    if openGlCurrentBackend.contextActive then
      setup3d(frame)
      native.glEnable(GL_DEPTH_TEST)
      native.glDepthFunc(GL_LEQUAL)
      native.glDepthMask(1)
      submitOpenGlRefDefMd2Entities(openGlCurrentBackend, frame)
      drawEntityMarkers(openGlCurrentBackend, frame)
      drawParticles(frame)
      openGlCurrentBackend.submittedEntities = openGlCurrentBackend.submittedEntities + frame.numEntities
      openGlCurrentBackend.submittedParticles = openGlCurrentBackend.submittedParticles + frame.numParticles
    end if
    openGlCurrentBackend.submittedFrames = openGlCurrentBackend.submittedFrames + 1
    return result
  end function

  function drawFill(x, y, width, height, color)
    openGlCurrentBackend = openGlBackendSlot.backend
    result = openGlCurrentBackend.core.exports.DrawFill(x, y, width, height, color)
    if openGlCurrentBackend.contextActive then drawSolidRect(x, y, width, height, color) end if
    return result
  end function

  function beginFrame(cameraSeparation)
    openGlCurrentBackend = openGlBackendSlot.backend
    result = openGlCurrentBackend.core.exports.BeginFrame(cameraSeparation)
    if openGlCurrentBackend.contextActive then
      native.glClearColor(bits(0.0), bits(0.0), bits(0.0), bits(1.0))
      native.glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
    end if
    return result
  end function

  function endFrame()
    openGlCurrentBackend = openGlBackendSlot.backend
    result = openGlCurrentBackend.core.exports.EndFrame()
    if openGlCurrentBackend.contextActive then
      native.glFlush()
      native.winSwap()
    end if
    return result
  end function

  return rt.RefExport(
    rc.API_VERSION, rendererInit, rendererShutdown,
    beginRegistration, registerModel,
    registerSkin, registerPic, coreSetSky,
    coreEndRegistration, renderFrame, drawGetPicSize,
    drawPic, drawStretchPic, coreDrawChar,
    coreDrawTileClear, drawFill, coreDrawFadeScreen,
    coreDrawStretchRaw, coreCinematicSetPalette, beginFrame,
    endFrame, coreAppActivate,
  )
end function

function createOpenGlRenderer(contextActive)
  coreBinding = recording.createRecordingRenderer()
  glState = OpenGlState(coreBinding, void, rassets.create(), contextActive, "", "", "", 0, 0, 0, 1, [])
  if typeof(glState) != "struct" then return error(9620, "OpenGL state constructor returned " + typeof(glState)) end if
  openGlFactorySlot = openGlBackendSlot
  openGlFactorySlot.backend = glState
  exports = openGlMakeExports()
  return rt.RendererBinding(glState, exports)
end function

function getRefAPI(imports, contextActive)
  coreBinding = recording.getRefAPI(imports, "recording")
  glState = OpenGlState(coreBinding, imports, rassets.create(), contextActive, "", "", "", 0, 0, 0, 1, [])
  openGlFactorySlot = openGlBackendSlot
  openGlFactorySlot.backend = glState
  return rt.RendererBinding(glState, openGlMakeExports())
end function

function setContextActive(binding, active)
  if not active then
    for each record in binding.state.textureRecords
      record.uploaded = false
    end for
  end if
  binding.state.contextActive = active
  if active and binding.state.core.state.initialized then
    binding.state.vendor = native.glGetString(GL_VENDOR)
    binding.state.renderer = native.glGetString(GL_RENDERER)
    binding.state.version = native.glGetString(GL_VERSION)
  end if
end function

function prepareClassicWorld(binding, map, loadFile, lightStyles, entityFrame, modulate)
  world = rclassicworld.build(map, loadFile, lightStyles, entityFrame, modulate, binding.state.assets.generation)
  skyName = binding.state.core.state.skyName
  skyRotate = binding.state.core.state.skyRotate
  skyAxis = binding.state.core.state.skyAxis
  if skyName == "" then
    skyName = rclassicworld.classicWorldEntityValue(map.entityText, "sky")
    skyRotate = rclassicworld.classicWorldSkyRotate(map.entityText)
    skyAxis = rclassicworld.classicWorldSkyAxis(map.entityText)
  end if
  rclassicworld.configureSky(world, loadFile, skyName, skyRotate, skyAxis)
  for each texture in world.textures
    record = allocateTextureRecord(
      binding.state, world.name + ":" + texture.name, texture.role,
      world.generation, texture.width, texture.height
    )
    texture.id = record.id
  end for
  return world
end function

function uploadClassicTexture(binding, texture)
  record = findTextureRecord(binding.state, texture.id)
  if record is void or record.released or texture.released then return error(9623, "classic texture handle is not active") end if
  if record.uploaded then
    texture.uploaded = true
    return false
  end if
  expected = texture.width * texture.height * 4
  if len(texture.rgbaPixels) != expected then return error(9624, "classic texture RGBA payload has invalid size") end if
  native.glBindTexture(GL_TEXTURE_2D, texture.id)
  native.glTexParameterI(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
  native.glTexParameterI(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
  wrap = GL_REPEAT
  if texture.role == "lightmap" or texture.role == "sky" then wrap = GL_CLAMP end if
  native.glTexParameterI(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, wrap)
  native.glTexParameterI(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, wrap)
  native.glTexImage2D(GL_TEXTURE_2D, 0, 4, texture.width, texture.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, texture.rgbaPixels)
  record.uploaded = true
  texture.uploaded = true
  return true
end function

function emitClassicVertex(draw, vertex, lightmap, time)
  position = vertex.position
  positionX = position.x; positionY = position.y; positionZ = position.z
  textureS = 0.0; textureT = 0.0
  if lightmap then
    textureS = vertex.lightS; textureT = vertex.lightT
  else
    coordinates = rclassicspecial.classicSpecialTextureCoordinates(draw, vertex, time)
    textureS = coordinates[0]; textureT = coordinates[1]
  end if
  native.glTexcoord2(bits(textureS), bits(textureT))
  native.glVertex3(bits(positionX), bits(positionY), bits(positionZ))
end function

function emitClassicDraw(draw, lightmap, time)
  vertexIndex = 0
  while vertexIndex < len(draw.vertices)
    emitClassicVertex(draw, draw.vertices[vertexIndex], lightmap, time)
    vertexIndex = vertexIndex + 1
  end while
end function

function emitOpenGlSkyVertex(s, t, axis, texture)
  x = 0.0; y = 0.0; z = 0.0
  scaledS = s * 2300.0; scaledT = t * 2300.0
  if axis == 0 then x = 2300.0; y = -scaledS; z = scaledT
  else if axis == 1 then x = -2300.0; y = scaledS; z = scaledT
  else if axis == 2 then x = scaledS; y = 2300.0; z = scaledT
  else if axis == 3 then x = -scaledS; y = -2300.0; z = scaledT
  else if axis == 4 then x = -scaledT; y = -scaledS; z = 2300.0
  else x = scaledT; y = -scaledS; z = -2300.0
  end if
  textureS = (s + 1.0) * 0.5
  textureT = 1.0 - (t + 1.0) * 0.5
  seamS = 0.5 / texture.width; seamT = 0.5 / texture.height
  if textureS < seamS then textureS = seamS end if
  if textureS > 1.0 - seamS then textureS = 1.0 - seamS end if
  if textureT < seamT then textureT = seamT end if
  if textureT > 1.0 - seamT then textureT = 1.0 - seamT end if
  native.glTexcoord2(bits(textureS), bits(textureT))
  native.glVertex3(bits(x), bits(y), bits(z))
end function

function drawOpenGlSkyBox(binding, world, frame)
  if not world.skyBox.active then return 0 end if
  textureOrder = [0, 2, 1, 3, 4, 5]
  uploaded = 0
  native.glPushMatrix()
  native.glTranslate(bits(frame.viewOrigin.x), bits(frame.viewOrigin.y), bits(frame.viewOrigin.z))
  if world.skyBox.rotate != 0.0 then
    native.glRotate(bits(frame.time * world.skyBox.rotate), bits(world.skyBox.axis.x), bits(world.skyBox.axis.y), bits(world.skyBox.axis.z))
  end if
  axis = 0
  while axis < 6
    texture = world.skyBox.textures[textureOrder[axis]]
    if uploadClassicTexture(binding, texture) then uploaded = uploaded + 1 end if
    native.glBindTexture(GL_TEXTURE_2D, texture.id)
    native.glBegin(GL_QUADS)
    emitOpenGlSkyVertex(-1.0, -1.0, axis, texture)
    emitOpenGlSkyVertex(-1.0, 1.0, axis, texture)
    emitOpenGlSkyVertex(1.0, 1.0, axis, texture)
    emitOpenGlSkyVertex(1.0, -1.0, axis, texture)
    native.glEnd()
    axis = axis + 1
  end while
  native.glPopMatrix()
  return uploaded
end function

function classicInlineModelIndex(modelAsset)
  nameBytes = bytes(modelAsset.handle.name)
  if len(nameBytes) < 2 or nameBytes[0] != 42 then return error(9632, "inline BSP asset has invalid *n name") end if
  indexText = decode(slice(nameBytes, 1, len(nameBytes) - 1))
  parsed = try(toNumber(indexText))
  if parsed is error then return error(9633, "inline BSP asset has invalid model index") end if
  modelIndex = ropenglbyteio.truncInt(parsed)
  if modelIndex < 1 or modelIndex >= len(modelAsset.source.models) then return error(9634, "inline BSP asset model index outside map") end if
  return modelIndex
end function

function classicBrushDistanceSquared(submission, viewOrigin)
  origin = submission.entity.origin
  deltaX = origin.x - viewOrigin.x; deltaY = origin.y - viewOrigin.y; deltaZ = origin.z - viewOrigin.z
  return deltaX * deltaX + deltaY * deltaY + deltaZ * deltaZ
end function

function sortClassicBrushSubmissions(submissions, viewOrigin)
  sorted = array(len(submissions))
  count = 0
  for each submission in submissions
    distance = classicBrushDistanceSquared(submission, viewOrigin)
    insert = count
    while insert > 0 and distance > classicBrushDistanceSquared(sorted[insert - 1], viewOrigin)
      sorted[insert] = sorted[insert - 1]
      insert = insert - 1
    end while
    sorted[insert] = submission
    count = count + 1
  end for
  return sorted
end function

function classicBrushLocalLights(entity, frame)
  localLights = array(frame.numDLights)
  lightIndex = 0
  while lightIndex < frame.numDLights
    light = frame.dLights[lightIndex]
    localOrigin = rclassicvisibility.classicVisibilityBrushLocalView(entity, light.origin)
    localLights[lightIndex] = rt.DLight(localOrigin, light.color, light.intensity)
    lightIndex = lightIndex + 1
  end while
  return localLights
end function

function classicBrushDynamicLightmaps(world, entity, plan, frame)
  localLights = classicBrushLocalLights(entity, frame)
  lightmaps = array(len(plan.opaqueDraws))
  dirtyCount = 0
  drawIndex = 0
  while drawIndex < len(plan.opaqueDraws)
    draw = plan.opaqueDraws[drawIndex]
    rclassiclightmaps.markDynamicLights(draw.surface, localLights)
    rgbaPixels = rclassiclightmaps.buildLightmap(draw.surface, frame.lightStyles, localLights, world.modulate)
    dirty = rgbaPixels != draw.surface.lightmap
    if dirty then dirtyCount = dirtyCount + 1 end if
    lightmaps[drawIndex] = rclassictypes.ClassicBrushLightmap(draw, rgbaPixels, dirty)
    drawIndex = drawIndex + 1
  end while
  return [lightmaps, dirtyCount]
end function

// Product-graph-facing CPU plan. It consumes the same model handles emitted by
// client asset registration, but never reparses or expands the adopted BSP.
function prepareClassicBrushFrame(binding, world, frame)
  submissions = array(frame.numEntities)
  submissionCount = 0
  culledEntities = 0; surfaces = 0; triangles = 0; dirtyLightmaps = 0
  entityIndex = 0
  while entityIndex < frame.numEntities
    entity = frame.entities[entityIndex]
    modelAsset = rassets.findModelByHandle(binding.state.assets, entity.model)
    if modelAsset is not void and modelAsset.kind == "bsp-inline" then
      if modelAsset.source != world.map then return error(9635, "inline BSP entity belongs to a different ClassicWorld") end if
      modelIndex = classicInlineModelIndex(modelAsset)
      brushModel = rclassicworld.findBrushModel(world, modelIndex)
      if brushModel is void then return error(9636, "ClassicWorld has no prepared inline BSP model " + modelIndex) end if
      selectedDraws = rclassicvisibility.selectClassicBrushModel(brushModel, entity, frame)
      if len(selectedDraws) == 0 then
        culledEntities = culledEntities + 1
      else
        localView = rclassicvisibility.classicVisibilityBrushLocalView(entity, frame.viewOrigin)
        brushPlan = rclassicspecial.classicSpecialPassPlanOrigin(selectedDraws, localView)
        lightmapResult = classicBrushDynamicLightmaps(world, entity, brushPlan, frame)
        submissions[submissionCount] = rclassictypes.ClassicBrushSubmission(entity, brushModel, brushPlan, lightmapResult[0])
        submissionCount = submissionCount + 1
        dirtyLightmaps = dirtyLightmaps + lightmapResult[1]
        surfaces = surfaces + len(selectedDraws)
        for each draw in selectedDraws triangles = triangles + draw.triangleCount end for
      end if
    end if
    entityIndex = entityIndex + 1
  end while
  if submissionCount == 0 then return rclassictypes.ClassicBrushFramePlan(array(0), culledEntities, surfaces, triangles, dirtyLightmaps) end if
  exact = array(submissionCount)
  copyIndex = 0
  while copyIndex < submissionCount
    exact[copyIndex] = submissions[copyIndex]
    copyIndex = copyIndex + 1
  end while
  exact = sortClassicBrushSubmissions(exact, frame.viewOrigin)
  return rclassictypes.ClassicBrushFramePlan(exact, culledEntities, surfaces, triangles, dirtyLightmaps)
end function

function classicBrushFrameSignature(brushFrame)
  result = len(brushFrame.submissions) + ":" + brushFrame.culledEntities + ":" + brushFrame.surfaces + ":" + brushFrame.triangles
  for each submission in brushFrame.submissions
    origin = submission.entity.origin
    result = result + ":*" + submission.brushModel.modelIndex + "@" + origin.x + "," + origin.y + "," + origin.z + "/" + rclassicspecial.classicSpecialPassSignature(submission.plan)
  end for
  return result
end function

function drawOpenGlClassicDraws(binding, draws, time, lightmap)
  uploaded = 0
  lastTexture = -1
  for each draw in draws
    texture = rclassicspecial.classicSpecialBaseTexture(draw, time)
    if lightmap then texture = draw.lightmapTexture end if
    if uploadClassicTexture(binding, texture) then uploaded = uploaded + 1 end if
    textureId = texture.id
    if lastTexture != textureId then
      native.glBindTexture(GL_TEXTURE_2D, textureId)
      lastTexture = textureId
    end if
    native.glBegin(GL_TRIANGLES)
    emitClassicDraw(draw, lightmap, time)
    native.glEnd()
  end for
  return uploaded
end function

function uploadClassicBrushLightmap(binding, brushLightmap)
  texture = brushLightmap.draw.lightmapTexture
  rgbaPixels = brushLightmap.rgbaPixels
  if texture.rgbaPixels != rgbaPixels then
    texture.rgbaPixels = rgbaPixels
    texture.uploaded = false
    record = findTextureRecord(binding.state, texture.id)
    if record is not void then record.uploaded = false end if
  end if
  return uploadClassicTexture(binding, texture)
end function

function drawOpenGlClassicBrushLightmaps(binding, submission, time)
  uploaded = 0
  lastTexture = -1
  for each brushLightmap in submission.dynamicLightmaps
    if uploadClassicBrushLightmap(binding, brushLightmap) then uploaded = uploaded + 1 end if
    textureId = brushLightmap.draw.lightmapTexture.id
    if lastTexture != textureId then native.glBindTexture(GL_TEXTURE_2D, textureId); lastTexture = textureId end if
    native.glBegin(GL_TRIANGLES)
    emitClassicDraw(brushLightmap.draw, true, time)
    native.glEnd()
  end for
  return uploaded
end function

function pushOpenGlClassicBrush(entity)
  origin = entity.origin; angles = entity.angles
  originX = origin.x; originY = origin.y; originZ = origin.z
  pitch = angles.x; yaw = angles.y; roll = angles.z
  native.glPushMatrix()
  native.glTranslate(bits(originX), bits(originY), bits(originZ))
  // Exact R_DrawBrushModel/R_RotateForEntity effective order after its
  // historical pitch/roll sign workaround.
  native.glRotate(bits(yaw), bits(0.0), bits(0.0), bits(1.0))
  native.glRotate(bits(pitch), bits(0.0), bits(1.0), bits(0.0))
  native.glRotate(bits(roll), bits(1.0), bits(0.0), bits(0.0))
end function

function drawOpenGlClassicBrushOpaque(binding, submission, frame)
  entityFlags = submission.entity.flags
  if (entityFlags & rc.RF_TRANSLUCENT) != 0 then return 0 end if
  plan = submission.plan
  pushOpenGlClassicBrush(submission.entity)
  native.glColor4ub(255, 255, 255, 255)
  native.glDisable(GL_BLEND)
  native.glDepthFunc(GL_LEQUAL)
  native.glDepthMask(1)
  uploaded = drawOpenGlClassicDraws(binding, plan.opaqueDraws, frame.time, false)
  native.glEnable(GL_BLEND)
  native.glBlendFunc(GL_ZERO, GL_SRC_COLOR)
  native.glDepthFunc(GL_EQUAL)
  native.glDepthMask(0)
  uploaded = uploaded + drawOpenGlClassicBrushLightmaps(binding, submission, frame.time)
  native.glDepthMask(1)
  native.glDepthFunc(GL_LEQUAL)
  native.glDisable(GL_BLEND)
  native.glColor4ub(128, 128, 128, 255)
  uploaded = uploaded + drawOpenGlClassicDraws(binding, plan.warpDraws, frame.time, false)
  native.glColor4ub(255, 255, 255, 255)
  uploaded = uploaded + drawOpenGlClassicDraws(binding, plan.skyDraws, frame.time, false)
  native.glPopMatrix()
  return uploaded
end function

function classicTransparentDistance(draw, entity, viewOrigin)
  centerX = (draw.mins.x + draw.maxs.x) * 0.5
  centerY = (draw.mins.y + draw.maxs.y) * 0.5
  centerZ = (draw.mins.z + draw.maxs.z) * 0.5
  if entity is not void then
    localCenter = ropenglqtypes.Vec3(centerX, centerY, centerZ)
    worldCenter = rclassicvisibility.classicVisibilityBrushWorldPoint(entity, localCenter)
    centerX = worldCenter.x; centerY = worldCenter.y; centerZ = worldCenter.z
  end if
  deltaX = centerX - viewOrigin.x; deltaY = centerY - viewOrigin.y; deltaZ = centerZ - viewOrigin.z
  return deltaX * deltaX + deltaY * deltaY + deltaZ * deltaZ
end function

function appendClassicTransparentDraws(output, count, draws, entity, entityAlpha, useSurfaceAlpha, viewOrigin)
  for each draw in draws
    alpha = entityAlpha
    if useSurfaceAlpha then alpha = alpha * draw.surface.alpha end if
    distance = classicTransparentDistance(draw, entity, viewOrigin)
    output[count] = rclassictypes.ClassicTransparentDraw(draw, entity, alpha, distance)
    count = count + 1
  end for
  return count
end function

function sortClassicTransparentDraws(draws)
  sorted = array(len(draws))
  count = 0
  for each candidate in draws
    insert = count
    while insert > 0 and candidate.distanceSquared > sorted[insert - 1].distanceSquared
      sorted[insert] = sorted[insert - 1]
      insert = insert - 1
    end while
    sorted[insert] = candidate
    count = count + 1
  end for
  return sorted
end function

function prepareClassicTransparentFrame(worldPlan, brushFrame, frame)
  capacity = len(worldPlan.transparentDraws)
  for each submission in brushFrame.submissions
    entityTranslucent = (submission.entity.flags & rc.RF_TRANSLUCENT) != 0
    if entityTranslucent then
      capacity = capacity + len(submission.plan.opaqueDraws) + len(submission.plan.warpDraws) + len(submission.plan.skyDraws)
    end if
    capacity = capacity + len(submission.plan.transparentDraws)
  end for
  if capacity == 0 then return array(0) end if
  output = array(capacity)
  count = appendClassicTransparentDraws(output, 0, worldPlan.transparentDraws, void, 1.0, true, frame.viewOrigin)
  for each submission in brushFrame.submissions
    entity = submission.entity
    entityAlpha = 1.0
    entityTranslucent = (entity.flags & rc.RF_TRANSLUCENT) != 0
    if entityTranslucent then
      entityAlpha = entity.alpha
      count = appendClassicTransparentDraws(output, count, submission.plan.opaqueDraws, entity, entityAlpha, false, frame.viewOrigin)
      count = appendClassicTransparentDraws(output, count, submission.plan.warpDraws, entity, entityAlpha, false, frame.viewOrigin)
      count = appendClassicTransparentDraws(output, count, submission.plan.skyDraws, entity, entityAlpha, false, frame.viewOrigin)
    end if
    count = appendClassicTransparentDraws(output, count, submission.plan.transparentDraws, entity, entityAlpha, true, frame.viewOrigin)
  end for
  return sortClassicTransparentDraws(output)
end function

function classicTransparentFrameSignature(draws)
  result = ""
  for each transparentDraw in draws
    owner = "w"
    if transparentDraw.entity is not void then owner = "b" end if
    result = result + owner + transparentDraw.draw.surface.index + "@" + transparentDraw.alpha + ","
  end for
  return result
end function

function drawOpenGlClassicTransparentFrame(binding, draws, frame)
  if len(draws) == 0 then return 0 end if
  native.glEnable(GL_BLEND)
  native.glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
  native.glDepthFunc(GL_LEQUAL)
  native.glDepthMask(0)
  uploaded = 0
  lastTexture = -1
  for each transparentDraw in draws
    draw = transparentDraw.draw
    entity = transparentDraw.entity
    if entity is not void then
      pushOpenGlClassicBrush(entity)
      lastTexture = -1
    end if
    texture = rclassicspecial.classicSpecialBaseTexture(draw, frame.time)
    if uploadClassicTexture(binding, texture) then uploaded = uploaded + 1 end if
    textureId = texture.id
    if lastTexture != textureId then native.glBindTexture(GL_TEXTURE_2D, textureId); lastTexture = textureId end if
    alphaValue = transparentDraw.alpha
    if alphaValue < 0.0 then alphaValue = 0.0 end if
    if alphaValue > 1.0 then alphaValue = 1.0 end if
    native.glColor4ub(128, 128, 128, ropenglbyteio.truncInt(alphaValue * 255.0))
    native.glBegin(GL_TRIANGLES)
    emitClassicDraw(draw, false, frame.time)
    native.glEnd()
    if entity is not void then native.glPopMatrix() end if
  end for
  native.glColor4ub(255, 255, 255, 255)
  native.glDepthMask(1)
  native.glDisable(GL_BLEND)
  return uploaded
end function

// Product BSP handoff. Geometry debug remains independent via
// submitTriangleMesh. This path follows the classic order: lit opaque base,
// multiplicative lightmaps, turbulent water, sky portals, then sorted alpha.
function submitClassicWorld(binding, world, frame)
  if world.released then return error(9625, "classic world was released") end if
  if world.generation != binding.state.assets.generation then return error(9626, "classic world belongs to a stale registration generation") end if
  selection = rclassicvisibility.selectClassicWorld(world, frame)
  visibleSurfaces = len(selection.draws)
  culledSurfaces = rclassicvisibility.classicVisibilityCulledCount(selection)
  plan = rclassicspecial.classicSpecialPassPlan(selection.draws, frame)
  passOrder = rclassicspecial.classicSpecialPassSignature(plan)
  opaqueSurfaces = len(plan.opaqueDraws)
  warpSurfaces = len(plan.warpDraws)
  skySurfaces = len(plan.skyDraws)
  transparentSurfaces = len(plan.transparentDraws)
  brushFrame = prepareClassicBrushFrame(binding, world, frame)
  brushEntities = len(brushFrame.submissions)
  transparentFrame = prepareClassicTransparentFrame(plan, brushFrame, frame)
  if not binding.state.contextActive then
    return rclassictypes.ClassicSubmitStats(
      0, 0, 0, 0, 0, visibleSurfaces, culledSurfaces, selection.viewLeaf, selection.viewCluster,
      opaqueSurfaces, warpSurfaces, skySurfaces, transparentSurfaces, passOrder,
      brushEntities, brushFrame.surfaces, brushFrame.triangles, brushFrame.culledEntities,
      brushFrame.dirtyLightmaps, len(transparentFrame)
    )
  end if

  setup3d(frame)
  native.glEnable(GL_DEPTH_TEST)
  native.glDepthFunc(GL_LEQUAL)
  native.glDepthMask(1)
  native.glEnable(GL_TEXTURE_2D)
  native.glDisable(GL_BLEND)
  native.glColor4ub(255, 255, 255, 255)
  uploaded = 0
  lastTexture = -1
  for each draw in plan.opaqueDraws
    baseTexture = rclassicspecial.classicSpecialBaseTexture(draw, frame.time)
    if uploadClassicTexture(binding, baseTexture) then uploaded = uploaded + 1 end if
    if lastTexture != baseTexture.id then
      native.glBindTexture(GL_TEXTURE_2D, baseTexture.id)
      lastTexture = baseTexture.id
    end if
    native.glBegin(GL_TRIANGLES)
    emitClassicDraw(draw, false, frame.time)
    native.glEnd()
  end for

  // OpenGL 1.1 fallback for the absent multitexture bridge: destination base
  // colour is multiplied by the uploaded Quake II lightmap colour.
  native.glEnable(GL_BLEND)
  native.glBlendFunc(GL_ZERO, GL_SRC_COLOR)
  native.glDepthFunc(GL_EQUAL)
  native.glDepthMask(0)
  for each draw in plan.opaqueDraws
    if uploadClassicTexture(binding, draw.lightmapTexture) then uploaded = uploaded + 1 end if
    native.glBindTexture(GL_TEXTURE_2D, draw.lightmapTexture.id)
    native.glBegin(GL_TRIANGLES)
    emitClassicDraw(draw, true, frame.time)
    native.glEnd()
  end for
  native.glDepthMask(1)
  native.glDepthFunc(GL_LEQUAL)
  native.glDisable(GL_BLEND)

  // Turbulent opaque water is fullbright in ref_gl and owns no lightmap.
  lastTexture = -1
  for each draw in plan.warpDraws
    baseTexture = rclassicspecial.classicSpecialBaseTexture(draw, frame.time)
    if uploadClassicTexture(binding, baseTexture) then uploaded = uploaded + 1 end if
    if lastTexture != baseTexture.id then
      native.glBindTexture(GL_TEXTURE_2D, baseTexture.id)
      lastTexture = baseTexture.id
    end if
    native.glColor4ub(128, 128, 128, 255)
    native.glBegin(GL_TRIANGLES)
    emitClassicDraw(draw, false, frame.time)
    native.glEnd()
  end for
  native.glColor4ub(255, 255, 255, 255)

  // Visible sky portals gate one six-face environment cube. PCX sky images
  // follow ref_gl's rt/bk/lf/ft/up/dn naming and skytexorder. Missing optional
  // environments retain the deterministic fullbright portal-WAL fallback.
  if len(plan.skyDraws) > 0 and world.skyBox.active then
    uploaded = uploaded + drawOpenGlSkyBox(binding, world, frame)
  else
    lastTexture = -1
    for each draw in plan.skyDraws
      baseTexture = rclassicspecial.classicSpecialBaseTexture(draw, frame.time)
      if uploadClassicTexture(binding, baseTexture) then uploaded = uploaded + 1 end if
      if lastTexture != baseTexture.id then
        native.glBindTexture(GL_TEXTURE_2D, baseTexture.id)
        lastTexture = baseTexture.id
      end if
      native.glBegin(GL_TRIANGLES)
      emitClassicDraw(draw, false, frame.time)
      native.glEnd()
    end for
  end if

  // Inline BSP entities share the world's textures/lightmaps but own a model
  // transform and brush-local backface decision. Their opaque passes precede
  // every translucent brush pass.
  for each brushSubmission in brushFrame.submissions
    uploaded = uploaded + drawOpenGlClassicBrushOpaque(binding, brushSubmission, frame)
  end for

  // One polygon-wide list combines world alpha, special brush alpha and
  // RF_TRANSLUCENT brush surfaces in true world-space back-to-front order.
  uploaded = uploaded + drawOpenGlClassicTransparentFrame(binding, transparentFrame, frame)

  triangles = 0
  for each draw in selection.draws
    triangles = triangles + draw.triangleCount
  end for
  vertices = triangles * 3
  lightmapVertices = 0
  for each draw in plan.opaqueDraws lightmapVertices = lightmapVertices + draw.triangleCount * 3 end for
  return rclassictypes.ClassicSubmitStats(
    visibleSurfaces, triangles, vertices, lightmapVertices, uploaded,
    visibleSurfaces, culledSurfaces, selection.viewLeaf, selection.viewCluster,
    opaqueSurfaces, warpSurfaces, skySurfaces, transparentSurfaces, passOrder,
    brushEntities, brushFrame.surfaces, brushFrame.triangles, brushFrame.culledEntities,
    brushFrame.dirtyLightmaps, len(transparentFrame)
  )
end function

function releaseClassicWorld(binding, world)
  if world.released then return 0 end if
  released = 0
  for each texture in world.textures
    texture.released = true
    texture.uploaded = false
    record = findTextureRecord(binding.state, texture.id)
    if releaseOpenGlTextureRecord(binding.state, record) then released = released + 1 end if
  end for
  world.released = true
  // A released handle may remain reachable through product/UI state. Detach
  // all heavyweight CPU ownership so the next BSP can be expanded without
  // retaining the previous map, scene, lightmaps and triangle arrays.
  world.map = void
  world.scene = void
  world.textures = []
  world.draws = []
  world.brushModels = []
  world.skyBox = void
  return released
end function

function backendDescription(binding)
  if not binding.state.contextActive then return "OpenGL 1.1 (headless contract mode)" end if
  return binding.state.vendor + " / " + binding.state.renderer + " / " + binding.state.version
end function

// Callback-backed registration for createOpenGlRenderer(), whose refimport is
// intentionally void. getRefAPI() users can use exports.RegisterModel.
function registerMd2Model(binding, name, loadFile)
  imports = OpenGlFileImports(loadFile)
  modelAsset = rassets.registerModel(binding.state.assets, imports, name)
  if modelAsset.kind != "md2" then return error(9629, "registered model is not MD2") end if
  for each skinAsset in modelAsset.skins
    ensureOpenGlPictureTexture(binding.state, skinAsset)
    if binding.state.contextActive then uploadPicture(binding.state, skinAsset) end if
  end for
  return modelAsset.handle
end function

function adoptClassicMapModel(binding, map, path)
  return rassets.adoptBspModel(binding.state.assets, map, path).handle
end function

function md2ModelFrameBounds(binding, modelHandle, frameIndex)
  modelAsset = rassets.modelForHandle(binding.state.assets, modelHandle)
  if modelAsset.kind != "md2" then return error(9630, "model bounds requested for non-MD2 handle") end if
  if frameIndex < 0 or frameIndex >= len(modelAsset.frameBounds) then return error(9631, "MD2 model bounds frame outside table") end if
  return modelAsset.frameBounds[frameIndex]
end function

function prepareMd2Entity(binding, entity)
  return prepareOpenGlMd2Entity(binding.state, entity)
end function

// Explicit handoff for tools. Product RefDef entities are submitted
// automatically by RenderFrame when entity.model is a current MD2 handle.
function submitMd2Entity(binding, entity)
  plan = prepareOpenGlMd2Entity(binding.state, entity)
  if not binding.state.contextActive then
    return Md2SubmitStats(false, plan.mesh.triangleCount, len(plan.mesh.vertices), 0, plan.bounds)
  end if
  return drawOpenGlMd2Plan(binding.state, plan, entity)
end function

// Independent wireframe/geometry-debug path for BSP38 fan geometry and
// interpolated MD2 meshes produced by renderer.geometry.
function submitTriangleMesh(binding, mesh, origin, angles, red, green, blue, alpha)
  if not binding.state.contextActive then return 0 end if
  if typeof(mesh.vertices) != "array" or len(mesh.vertices) % 3 != 0 then return error(9621, "triangle mesh vertex count must be divisible by three") end if
  meshVertices = mesh.vertices
  meshVertexCount = len(meshVertices)
  originX = origin.x; originY = origin.y; originZ = origin.z
  angleX = angles.x; angleY = angles.y; angleZ = angles.z
  native.glPushMatrix()
  native.glTranslate(bits(originX), bits(originY), bits(originZ))
  native.glRotate(bits(angleZ), bits(1.0), bits(0.0), bits(0.0))
  native.glRotate(bits(-angleX), bits(0.0), bits(1.0), bits(0.0))
  native.glRotate(bits(angleY), bits(0.0), bits(0.0), bits(1.0))
  native.glBegin(GL_TRIANGLES)
  index = 0
  while index < meshVertexCount
    first = meshVertices[index].position
    second = meshVertices[index + 1].position
    third = meshVertices[index + 2].position
    firstX = first.x; firstY = first.y; firstZ = first.z
    secondX = second.x; secondY = second.y; secondZ = second.z
    thirdX = third.x; thirdY = third.y; thirdZ = third.z
    ux = secondX - firstX; uy = secondY - firstY; uz = secondZ - firstZ
    vx = thirdX - firstX; vy = thirdY - firstY; vz = thirdZ - firstZ
    nx = uy * vz - uz * vy; ny = uz * vx - ux * vz; nz = ux * vy - uy * vx
    ax = nx; ay = ny; az = nz
    if ax < 0.0 then ax = -ax end if
    if ay < 0.0 then ay = -ay end if
    if az < 0.0 then az = -az end if
    shadeRed = red; shadeGreen = green; shadeBlue = blue
    if ax >= ay and ax >= az then
      shadeRed = (red * 3) >> 2; shadeGreen = (green * 3) >> 2; shadeBlue = (blue * 3) >> 2
    else if ay >= ax and ay >= az then
      shadeRed = (red * 7) >> 3; shadeGreen = (green * 7) >> 3; shadeBlue = (blue * 7) >> 3
    end if
    native.glColor4ub(shadeRed, shadeGreen, shadeBlue, alpha)
    native.glVertex3(bits(firstX), bits(firstY), bits(firstZ))
    native.glVertex3(bits(secondX), bits(secondY), bits(secondZ))
    native.glVertex3(bits(thirdX), bits(thirdY), bits(thirdZ))
    index = index + 3
  end while
  native.glEnd()

  // A subdued edge overlay makes the untextured BSP preview readable while
  // WAL/lightmap upload is still being connected to the product renderer.
  native.glColor4ub(24, 30, 40, 255)
  native.glBegin(GL_LINES)
  index = 0
  while index < meshVertexCount
    first = meshVertices[index].position
    second = meshVertices[index + 1].position
    third = meshVertices[index + 2].position
    firstX = first.x; firstY = first.y; firstZ = first.z
    secondX = second.x; secondY = second.y; secondZ = second.z
    thirdX = third.x; thirdY = third.y; thirdZ = third.z
    native.glVertex3(bits(firstX), bits(firstY), bits(firstZ)); native.glVertex3(bits(secondX), bits(secondY), bits(secondZ))
    native.glVertex3(bits(secondX), bits(secondY), bits(secondZ)); native.glVertex3(bits(thirdX), bits(thirdY), bits(thirdZ))
    native.glVertex3(bits(thirdX), bits(thirdY), bits(thirdZ)); native.glVertex3(bits(firstX), bits(firstY), bits(firstZ))
    index = index + 3
  end while
  native.glEnd()
  native.glPopMatrix()
  return meshVertexCount / 3
end function
