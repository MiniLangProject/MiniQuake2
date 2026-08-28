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
import miniquake2.qcommon.directions as ropengldirections
import miniquake2.qcommon.types as ropenglqtypes
import miniquake2.format.constants as ropenglformatconstants
import miniquake2.format.pcx as ropenglpcx
import miniquake2.renderer.constants as rc
import miniquake2.renderer.types as rt
import miniquake2.renderer.recording as recording
import miniquake2.renderer.validation as validation
import miniquake2.renderer.assets as rassets
import miniquake2.renderer.geometry as rgeom
import miniquake2.renderer.classic.types as rclassictypes
import miniquake2.renderer.classic.constants as rclassicconstants
import miniquake2.renderer.classic.world as rclassicworld
import miniquake2.renderer.classic.visibility as rclassicvisibility
import miniquake2.renderer.classic.special as rclassicspecial
import miniquake2.renderer.classic.lightmaps as rclassiclightmaps
import miniquake2.renderer.classic.point_lighting as rclassicpointlighting
import miniquake2.renderer.classic.sprites as rclassicsprites

const GL_POINTS = 0x0000
const GL_LINES = 0x0001
const GL_TRIANGLES = 0x0004
const GL_TRIANGLE_STRIP = 0x0005
const GL_TRIANGLE_FAN = 0x0006
const GL_QUADS = 0x0007
const GL_DEPTH_BUFFER_BIT = 0x00000100
const GL_COLOR_BUFFER_BIT = 0x00004000
const GL_EQUAL = 0x0202
const GL_GREATER = 0x0204
const GL_LEQUAL = 0x0203
const GL_ZERO = 0x0000
const GL_ONE = 0x0001
const GL_SRC_COLOR = 0x0300
const GL_SRC_ALPHA = 0x0302
const GL_DST_COLOR = 0x0306
const GL_ONE_MINUS_SRC_ALPHA = 0x0303
const GL_BLEND = 0x0BE2
const GL_ALPHA_TEST = 0x0BC0
const GL_CULL_FACE = 0x0B44
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
const GL_TEXTURE_ENV = 0x2300
const GL_TEXTURE_ENV_MODE = 0x2200
const GL_LINEAR = 0x2601
const GL_LINEAR_MIPMAP_NEAREST = 0x2701
const GL_FRONT = 0x0404
const GL_BACK = 0x0405
const GL_MODULATE = 0x2100
const GL_CLAMP = 0x2900
const GL_REPEAT = 0x2901
const GL_VENDOR = 0x1F00
const GL_RENDERER = 0x1F01
const GL_VERSION = 0x1F02
const DEG_TO_RAD = 0.017453292519943295

// Store open gl state data.
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
  submittedShadows
  lastShadowEntities
  nextTextureId
  textureRecords
  gamePalette
  particleTextureId
  rawTextureId
  rawPixels
  batchRecords
  batchDraws
  batchAnimationFrame
  md2ShadeRows
  md2NormalVectors
  md2ShadowSpotZ
  md2ShadowValid
  md2LightSpotZ
  md2LightSpotValid
  shadows
  brightness
  handedness
  activeWorld
  lightLevel
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

// World alpha must be emitted after aliases and particles even though the
// MiniLang product submits BSP geometry through a separate API call. Retain
// only the current frame's tail passes; BeginFrame clears stale work.
struct OpenGlPendingClassicPasses
  binding
  transparentDraws
  frame
  active
  stats
end struct

// Fixed six-stage ClipSkyPolygon workspace. Every vertex object is retained
// and mutated in place so sky portals do not build a managed graph per frame.
struct OpenGlSkyClipScratch
  bounds
  distances
  sides
  frontBuffers
  backBuffers
  translated
end struct

// Package-owned holder for the lazily initialized sky clipping workspace.
struct OpenGlSkyScratchSlot
  scratch
end struct

// Store open gl frame slot data.
struct OpenGlFrameSlot
  twoDimensional
end struct

// Store open gl file imports data.
struct OpenGlFileImports
  fsLoadFile
end struct

// Store md 2 entity plan data.
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

// Store md 2 submit stats data.
struct Md2SubmitStats
  submitted
  triangles
  vertices
  textureId
  bounds
end struct

// Store md 2 draw state data.
struct Md2DrawState
  textureId
  translucent
  depthHack
  shell
  mirrored
  shadeRed
  shadeGreen
  shadeBlue
  alpha
end struct

// Store open gl view axes data.
struct OpenGlViewAxes
  forwardX
  forwardY
  forwardZ
  rightX
  rightY
  rightZ
  upX
  upY
  upZ
end struct

// Store open gl raw frame data.
struct OpenGlRawFrame
  rgba
  textureT
end struct

// Mutating a package-owned holder is reliable across the self-hosted full
// graph; rebinding a package global from a function is not.
openGlBackendSlot = OpenGlBackendSlot(void)
openGlFrameSlot = OpenGlFrameSlot(false)
openGlPendingClassicPasses = OpenGlPendingClassicPasses(void, [], void, false,
  void)
openGlSkyScratchSlot = OpenGlSkyScratchSlot(void)
openGlParticleRecords = bytes(rc.MAX_PARTICLES * 16)
openGlClassicTextureCoordinateScratch = array(2, 0.0)

// Return the bits value.
function inline bits(value)
  return native.floatBits(value)
end function

// Allocate texture record.
function allocateTextureRecord(backend, name, role, generation, width, height)
  record = GlTextureRecord(backend.nextTextureId, name, role, generation, width, height, false, false)
  backend.nextTextureId = backend.nextTextureId + 1
  backend.textureRecords = backend.textureRecords + [record]
  return record
end function

// Find texture record.
function findTextureRecord(backend, id)
  for each record in backend.textureRecords
    if record.id == id then return record end if
  end for
  return void
end function

// Release open gl texture record.
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

// Release open gl texture records.
function releaseOpenGlTextureRecords(backend)
  released = 0
  for each record in backend.textureRecords
    if releaseOpenGlTextureRecord(backend, record) then released = released + 1 end if
  end for
  return released
end function

// Return the color byte value.
function inline colorByte(value, shift)
  return (value >> shift) & 255
end function

// Open gl palette color.
function inline openGlPaletteColor(palette, index)
  color = index & 255
  if typeof(palette) == "bytes" and len(palette) == 768 then
    return palette[color * 3] | (palette[color * 3 + 1] << 8) | (palette[color * 3 + 2] << 16)
  end if
  return (color & 0xE0) | (((color & 0x1C) << 3) << 8) | (((color & 0x03) << 6) << 16)
end function

// Open gl load game palette.
function openGlLoadGamePalette(backend)
  if backend.imports is void then backend.gamePalette = bytes(0); return backend.gamePalette end if
  data = try(backend.imports.fsLoadFile("pics/colormap.pcx"))
  if data is error or typeof(data) != "bytes" then backend.gamePalette = bytes(0); return backend.gamePalette end if
  image = try(ropenglpcx.parse(data))
  if image is error or len(image.palette) != 768 then backend.gamePalette = bytes(0); return backend.gamePalette end if
  backend.gamePalette = image.palette
  return backend.gamePalette
end function

// Open gl view axes.
function openGlViewAxes(viewAngles)
  pitch = viewAngles.x * DEG_TO_RAD
  yaw = viewAngles.y * DEG_TO_RAD
  roll = viewAngles.z * DEG_TO_RAD
  pitchSine = rmath.sin(pitch); pitchCosine = rmath.cos(pitch)
  yawSine = rmath.sin(yaw); yawCosine = rmath.cos(yaw)
  rollSine = rmath.sin(roll); rollCosine = rmath.cos(roll)
  return OpenGlViewAxes(
    pitchCosine * yawCosine, pitchCosine * yawSine, -pitchSine,
    -rollSine * pitchSine * yawCosine + rollCosine * yawSine,
    -rollSine * pitchSine * yawSine - rollCosine * yawCosine,
    -rollSine * pitchCosine,
    rollCosine * pitchSine * yawCosine + rollSine * yawSine,
    rollCosine * pitchSine * yawSine - rollSine * yawCosine,
    rollCosine * pitchCosine)
end function

// Open gl particle pixels.
function openGlParticlePixels()
  size = 16
  rgba = bytes(size * size * 4)
  y = 0
  while y < size
    x = 0
    while x < size
      dx = x - 7.5; dy = y - 7.5
      alpha = 255 - ropenglbyteio.truncInt((dx * dx + dy * dy) * 4.5)
      if alpha < 0 then alpha = 0 end if
      if alpha > 255 then alpha = 255 end if
      offset = (y * size + x) * 4
      rgba[offset] = 255; rgba[offset + 1] = 255; rgba[offset + 2] = 255
      rgba[offset + 3] = alpha
      x = x + 1
    end while
    y = y + 1
  end while
  return rgba
end function

// Prepare open gl raw frame.
function prepareOpenGlRawFrame(columns, rows, data, palette, reusable)
  if columns <= 0 or rows <= 0 then return error(9630, "raw frame dimensions must be positive") end if
  rgba = reusable
  if typeof(rgba) != "bytes" or len(rgba) != 256 * 256 * 4 then rgba = bytes(256 * 256 * 4) end if
  heightScale = 1.0
  targetRows = rows
  if rows > 256 then heightScale = rows / 256.0; targetRows = 256 end if
  textureT = rows * heightScale / 256.0
  rowIndex = 0
  while rowIndex < targetRows
    sourceRow = ropenglbyteio.truncInt(rowIndex * heightScale)
    if sourceRow >= rows then sourceRow = rows - 1 end if
    fractionStep = ropenglbyteio.truncInt(columns * 65536.0 / 256.0)
    fraction = fractionStep >> 1
    columnIndex = 0
    while columnIndex < 256
      sourceColumn = fraction >> 16
      if sourceColumn >= columns then sourceColumn = columns - 1 end if
      color = data[sourceRow * columns + sourceColumn]
      packed = openGlPaletteColor(palette, color)
      destination = (rowIndex * 256 + columnIndex) * 4
      rgba[destination] = colorByte(packed, 0)
      rgba[destination + 1] = colorByte(packed, 8)
      rgba[destination + 2] = colorByte(packed, 16)
      rgba[destination + 3] = 255
      fraction = fraction + fractionStep
      columnIndex = columnIndex + 1
    end while
    rowIndex = rowIndex + 1
  end while
  return OpenGlRawFrame(rgba, textureT)
end function

// Ensure open gl particle texture.
function ensureOpenGlParticleTexture(backend)
  record = void
  if backend.particleTextureId != 0 then record = findTextureRecord(backend, backend.particleTextureId) end if
  if record is void or record.released then
    record = allocateTextureRecord(backend, "***particle***", "particle",
      backend.assets.generation, 16, 16)
    backend.particleTextureId = record.id
  end if
  if backend.contextActive and not record.uploaded then
    native.glBindTexture(GL_TEXTURE_2D, record.id)
    native.glTexParameterI(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
    native.glTexParameterI(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
    native.glTexParameterI(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP)
    native.glTexParameterI(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP)
    native.glTexImage2D(GL_TEXTURE_2D, 0, 4, 16, 16, 0, GL_RGBA,
      GL_UNSIGNED_BYTE, openGlParticlePixels())
    record.uploaded = true
  end if
  return record.id
end function

// Ensure open gl raw texture.
function ensureOpenGlRawTexture(backend)
  record = void
  if backend.rawTextureId != 0 then record = findTextureRecord(backend, backend.rawTextureId) end if
  if record is void or record.released then
    record = allocateTextureRecord(backend, "***cinematic***", "raw",
      backend.assets.generation, 256, 256)
    backend.rawTextureId = record.id
  end if
  return record
end function

// Return the setup 3 d value.
function setup3d(frame)
  viewportX = frame.x; viewportY = frame.y; viewportWidth = frame.width; viewportHeight = frame.height
  fovX = frame.fovX; fovY = frame.fovY
  viewAngles = frame.viewAngles; viewOrigin = frame.viewOrigin
  angleX = viewAngles.x; angleY = viewAngles.y; angleZ = viewAngles.z
  originX = viewOrigin.x; originY = viewOrigin.y; originZ = viewOrigin.z
  // RefDef uses Quake's top-left screen origin, while OpenGL viewports use a
  // bottom-left origin. Full-screen frames mask the distinction; menu model
  // previews and other subviews require the explicit conversion.
  native.glViewport(viewportX,
    native.winClientHeight() - viewportY - viewportHeight,
    viewportWidth, viewportHeight)
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

// Draw open gl null entity.
function drawOpenGlNullEntity(entity)
  origin = entity.origin; angles = entity.angles
  native.glPushMatrix()
  native.glTranslate(bits(origin.x), bits(origin.y), bits(origin.z))
  native.glRotate(bits(angles.y), bits(0.0), bits(0.0), bits(1.0))
  native.glRotate(bits(-angles.x), bits(0.0), bits(1.0), bits(0.0))
  native.glRotate(bits(-angles.z), bits(1.0), bits(0.0), bits(0.0))
  native.glDisable(GL_TEXTURE_2D)
  shade = 160
  if (entity.flags & rc.RF_FULLBRIGHT) != 0 then shade = 255 end if
  native.glColor4ub(shade, shade, shade, 255)
  native.glBegin(GL_TRIANGLE_FAN)
  native.glVertex3(bits(0.0), bits(0.0), bits(-16.0))
  index = 0
  while index <= 4
    angle = index * 1.5707963267948966
    native.glVertex3(bits(16.0 * rmath.cos(angle)), bits(16.0 * rmath.sin(angle)), bits(0.0))
    index = index + 1
  end while
  native.glEnd()
  native.glBegin(GL_TRIANGLE_FAN)
  native.glVertex3(bits(0.0), bits(0.0), bits(16.0))
  index = 4
  while index >= 0
    angle = index * 1.5707963267948966
    native.glVertex3(bits(16.0 * rmath.cos(angle)), bits(16.0 * rmath.sin(angle)), bits(0.0))
    index = index - 1
  end while
  native.glEnd()
  native.glColor4ub(255, 255, 255, 255)
  native.glEnable(GL_TEXTURE_2D)
  native.glPopMatrix()
end function

// Open gl beam scalars.
function openGlBeamScalars(entity)
  origin = entity.origin; finish = entity.oldOrigin
  directionX = finish.x - origin.x; directionY = finish.y - origin.y; directionZ = finish.z - origin.z
  magnitude = rmath.sqrt(directionX * directionX + directionY * directionY + directionZ * directionZ)
  if magnitude <= 0.000001 then return [] end if
  normalX = directionX / magnitude; normalY = directionY / magnitude; normalZ = directionZ / magnitude
  absoluteX = rmath.abs(normalX); absoluteY = rmath.abs(normalY); absoluteZ = rmath.abs(normalZ)
  axisX = 0.0; axisY = 0.0; axisZ = 0.0
  if absoluteX <= absoluteY and absoluteX <= absoluteZ then axisX = 1.0
  else if absoluteY <= absoluteZ then axisY = 1.0
  else axisZ = 1.0
  end if
  projection = axisX * normalX + axisY * normalY + axisZ * normalZ
  perpendicularX = axisX - projection * normalX
  perpendicularY = axisY - projection * normalY
  perpendicularZ = axisZ - projection * normalZ
  perpendicularLength = rmath.sqrt(perpendicularX * perpendicularX + perpendicularY * perpendicularY + perpendicularZ * perpendicularZ)
  perpendicularX = perpendicularX / perpendicularLength
  perpendicularY = perpendicularY / perpendicularLength
  perpendicularZ = perpendicularZ / perpendicularLength
  sideX = normalY * perpendicularZ - normalZ * perpendicularY
  sideY = normalZ * perpendicularX - normalX * perpendicularZ
  sideZ = normalX * perpendicularY - normalY * perpendicularX
  radius = entity.frame * 0.5
  scalars = array(6 * 4 * 3, 0.0)
  scalarIndex = 0
  segment = 0
  while segment < 6
    angle0 = segment * 1.0471975511965976
    angle1 = (segment + 1) * 1.0471975511965976
    ring0X = radius * (perpendicularX * rmath.cos(angle0) + sideX * rmath.sin(angle0))
    ring0Y = radius * (perpendicularY * rmath.cos(angle0) + sideY * rmath.sin(angle0))
    ring0Z = radius * (perpendicularZ * rmath.cos(angle0) + sideZ * rmath.sin(angle0))
    ring1X = radius * (perpendicularX * rmath.cos(angle1) + sideX * rmath.sin(angle1))
    ring1Y = radius * (perpendicularY * rmath.cos(angle1) + sideY * rmath.sin(angle1))
    ring1Z = radius * (perpendicularZ * rmath.cos(angle1) + sideZ * rmath.sin(angle1))
    scalars[scalarIndex] = origin.x + ring0X; scalars[scalarIndex + 1] = origin.y + ring0Y; scalars[scalarIndex + 2] = origin.z + ring0Z
    scalars[scalarIndex + 3] = finish.x + ring0X; scalars[scalarIndex + 4] = finish.y + ring0Y; scalars[scalarIndex + 5] = finish.z + ring0Z
    scalars[scalarIndex + 6] = origin.x + ring1X; scalars[scalarIndex + 7] = origin.y + ring1Y; scalars[scalarIndex + 8] = origin.z + ring1Z
    scalars[scalarIndex + 9] = finish.x + ring1X; scalars[scalarIndex + 10] = finish.y + ring1Y; scalars[scalarIndex + 11] = finish.z + ring1Z
    scalarIndex = scalarIndex + 12
    segment = segment + 1
  end while
  return scalars
end function

// Draw open gl beam.
function drawOpenGlBeam(backend, entity)
  scalars = openGlBeamScalars(entity)
  if len(scalars) == 0 then return false end if
  packed = openGlPaletteColor(backend.gamePalette, entity.skinNum)
  alpha = ropenglbyteio.truncInt(entity.alpha * 255.0)
  if alpha < 0 then alpha = 0 end if
  if alpha > 255 then alpha = 255 end if
  native.glDisable(GL_TEXTURE_2D)
  native.glEnable(GL_BLEND)
  native.glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
  native.glDepthMask(0)
  native.glColor4ub(colorByte(packed, 0), colorByte(packed, 8), colorByte(packed, 16), alpha)
  native.glBegin(GL_TRIANGLE_STRIP)
  index = 0
  while index < len(scalars)
    native.glVertex3(bits(scalars[index]), bits(scalars[index + 1]), bits(scalars[index + 2]))
    index = index + 3
  end while
  native.glEnd()
  native.glColor4ub(255, 255, 255, 255)
  native.glDepthMask(1)
  native.glDisable(GL_BLEND)
  native.glEnable(GL_TEXTURE_2D)
  return true
end function

// Draw open gl sprite entity.
function drawOpenGlSpriteEntity(backend, modelAsset, entity, axes)
  // Keep draw open gl sprite entity phases explicit: validate inputs, update owned state, then publish the result.
  if len(modelAsset.skins) == 0 then return error(9631, "SP2 entity has no registered PCX frames") end if
  up = ropenglqtypes.Vec3(axes.upX, axes.upY, axes.upZ)
  right = ropenglqtypes.Vec3(axes.rightX, axes.rightY, axes.rightZ)
  draw = rclassicsprites.prepare(modelAsset.source, entity, up, right)
  if draw.frameIndex < 0 or draw.frameIndex >= len(modelAsset.skins) then return error(9632, "SP2 frame skin is unavailable") end if
  skinAsset = modelAsset.skins[draw.frameIndex]
  textureId = uploadPicture(backend, skinAsset)
  alpha = ropenglbyteio.truncInt(draw.alpha * 255.0)
  if alpha < 0 then alpha = 0 end if
  if alpha > 255 then alpha = 255 end if
  native.glEnable(GL_TEXTURE_2D)
  native.glBindTexture(GL_TEXTURE_2D, textureId)
  if draw.blend then
    native.glDisable(GL_ALPHA_TEST)
    native.glEnable(GL_BLEND)
    native.glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
    native.glDepthMask(0)
  else
    native.glDisable(GL_BLEND)
    native.glEnable(GL_ALPHA_TEST)
    native.glAlphaFunc(GL_GREATER, bits(0.666))
    native.glDepthMask(1)
  end if
  native.glColor4ub(255, 255, 255, alpha)
  native.glBegin(GL_QUADS)
  for each vertex in draw.vertices
    native.glTexcoord2(bits(vertex.s), bits(vertex.t))
    native.glVertex3(bits(vertex.position.x), bits(vertex.position.y), bits(vertex.position.z))
  end for
  native.glEnd()
  native.glDisable(GL_ALPHA_TEST)
  native.glDisable(GL_BLEND)
  native.glDepthMask(1)
  native.glColor4ub(255, 255, 255, 255)
  return true
end function

// Write open gl particle record.
function writeOpenGlParticleRecord(buffer, index, packed, alpha, origin)
  offset = index * 16
  buffer[offset] = colorByte(packed, 0)
  buffer[offset + 1] = colorByte(packed, 8)
  buffer[offset + 2] = colorByte(packed, 16)
  buffer[offset + 3] = alpha
  xBits = bits(origin.x); yBits = bits(origin.y); zBits = bits(origin.z)
  buffer[offset + 4] = xBits & 255
  buffer[offset + 5] = (xBits >> 8) & 255
  buffer[offset + 6] = (xBits >> 16) & 255
  buffer[offset + 7] = (xBits >> 24) & 255
  buffer[offset + 8] = yBits & 255
  buffer[offset + 9] = (yBits >> 8) & 255
  buffer[offset + 10] = (yBits >> 16) & 255
  buffer[offset + 11] = (yBits >> 24) & 255
  buffer[offset + 12] = zBits & 255
  buffer[offset + 13] = (zBits >> 8) & 255
  buffer[offset + 14] = (zBits >> 16) & 255
  buffer[offset + 15] = (zBits >> 24) & 255
  return offset + 16
end function

// Draw particles.
function drawParticles(backend, frame, axes)
  if frame.numParticles <= 0 then return void end if
  textureId = ensureOpenGlParticleTexture(backend)
  viewOrigin = frame.viewOrigin
  scaledUpX = axes.upX * 1.5; scaledUpY = axes.upY * 1.5; scaledUpZ = axes.upZ * 1.5
  scaledRightX = axes.rightX * 1.5; scaledRightY = axes.rightY * 1.5; scaledRightZ = axes.rightZ * 1.5
  native.glEnable(GL_TEXTURE_2D)
  native.glBindTexture(GL_TEXTURE_2D, textureId)
  native.glEnable(GL_BLEND)
  native.glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
  native.glDepthMask(0)
  batchCount = 0
  index = 0
  while index < frame.numParticles
    particle = frame.particles[index]
    particleAlpha = particle.alpha
    particleColor = particle.color
    particleOrigin = particle.origin
    particleX = particleOrigin.x; particleY = particleOrigin.y; particleZ = particleOrigin.z
    if particleAlpha > 0.0 then
      packed = openGlPaletteColor(backend.gamePalette, particleColor)
      alpha = ropenglbyteio.truncInt(particleAlpha * 255.0)
      if alpha < 0 then alpha = 0 end if
      if alpha > 255 then alpha = 255 end if
      writeOpenGlParticleRecord(openGlParticleRecords, batchCount, packed, alpha,
        particleOrigin)
      batchCount = batchCount + 1
    end if
    index = index + 1
  end while
  submitted = 0
  if batchCount > 0 then
    submitted = native.glDrawParticleBatchStyled(openGlParticleRecords, batchCount * 16,
      bits(viewOrigin.x), bits(viewOrigin.y), bits(viewOrigin.z),
      bits(axes.forwardX), bits(axes.forwardY), bits(axes.forwardZ),
      bits(axes.upX), bits(axes.upY), bits(axes.upZ),
      bits(axes.rightX), bits(axes.rightY), bits(axes.rightZ))
  end if

  // Older shared native bridges retain the scalar path as a safe fallback.
  if submitted != batchCount then
    native.glBegin(GL_TRIANGLES)
    index = 0
    while index < frame.numParticles
      particle = frame.particles[index]
      particleAlpha = particle.alpha
      particleColor = particle.color
      particleOrigin = particle.origin
      particleX = particleOrigin.x; particleY = particleOrigin.y; particleZ = particleOrigin.z
      if particleAlpha > 0.0 then
        packed = openGlPaletteColor(backend.gamePalette, particleColor)
        alpha = ropenglbyteio.truncInt(particleAlpha * 255.0)
        if alpha < 0 then alpha = 0 end if
        if alpha > 255 then alpha = 255 end if
        native.glColor4ub(colorByte(packed, 0), colorByte(packed, 8),
          colorByte(packed, 16), alpha)
      distance = (particleX - viewOrigin.x) * axes.forwardX +
        (particleY - viewOrigin.y) * axes.forwardY +
        (particleZ - viewOrigin.z) * axes.forwardZ
      scale = 1.0
      if distance >= 20.0 then scale = 1.0 + distance * 0.004 end if
      native.glTexcoord2(bits(0.0625), bits(0.0625))
      native.glVertex3(bits(particleX), bits(particleY), bits(particleZ))
      native.glTexcoord2(bits(1.0625), bits(0.0625))
      native.glVertex3(bits(particleX + scaledUpX * scale), bits(particleY + scaledUpY * scale), bits(particleZ + scaledUpZ * scale))
      native.glTexcoord2(bits(0.0625), bits(1.0625))
      native.glVertex3(bits(particleX + scaledRightX * scale), bits(particleY + scaledRightY * scale), bits(particleZ + scaledRightZ * scale))
      end if
      index = index + 1
    end while
    native.glEnd()
    end if
  native.glDepthMask(1)
  native.glDisable(GL_BLEND)
  native.glColor4ub(255, 255, 255, 255)
end function

// Return the setup 2 d value.
function setup2d()
  frameState = openGlFrameSlot
  if frameState.twoDimensional then return void end if
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
  frameState.twoDimensional = true
end function

// Draw solid rect.
function drawSolidRect(backend, x, y, width, height, color)
  setup2d()
  packed = openGlPaletteColor(backend.gamePalette, color)
  native.glDisable(GL_TEXTURE_2D)
  native.glColor4ub(colorByte(packed, 0), colorByte(packed, 8),
    colorByte(packed, 16), 255)
  native.glBegin(GL_QUADS)
  native.glVertex2(bits(x * 1.0), bits(y * 1.0))
  native.glVertex2(bits((x + width) * 1.0), bits(y * 1.0))
  native.glVertex2(bits((x + width) * 1.0), bits((y + height) * 1.0))
  native.glVertex2(bits(x * 1.0), bits((y + height) * 1.0))
  native.glEnd()
  native.glColor4ub(255, 255, 255, 255)
  native.glEnable(GL_TEXTURE_2D)
end function

// Return the picture pixels value.
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

// Return the picture upload pixels value.
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

// Ensure open gl picture texture.
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

// Upload a complete RGBA mip chain during registration. Keeping mip generation
// inside this renderer helper restores stock sampling without gameplay heap use.
function uploadOpenGlMipChain(width, height, rgba)
  // Validate the base level, upload each level, then downsample into the next
  // registration-owned temporary buffer until the 1x1 terminal level.
  level = 0; levelWidth = width; levelHeight = height; pixels = rgba
  while true
    native.glTexImage2D(GL_TEXTURE_2D, level, 4, levelWidth, levelHeight, 0,
      GL_RGBA, GL_UNSIGNED_BYTE, pixels)
    if levelWidth == 1 and levelHeight == 1 then return level + 1 end if
    nextWidth = levelWidth >> 1; nextHeight = levelHeight >> 1
    if nextWidth < 1 then nextWidth = 1 end if
    if nextHeight < 1 then nextHeight = 1 end if
    nextPixels = bytes(nextWidth * nextHeight * 4)
    y = 0
    while y < nextHeight
      sourceY0 = y * 2; sourceY1 = sourceY0 + 1
      if sourceY1 >= levelHeight then sourceY1 = levelHeight - 1 end if
      x = 0
      while x < nextWidth
        sourceX0 = x * 2; sourceX1 = sourceX0 + 1
        if sourceX1 >= levelWidth then sourceX1 = levelWidth - 1 end if
        first = (sourceY0 * levelWidth + sourceX0) * 4
        second = (sourceY0 * levelWidth + sourceX1) * 4
        third = (sourceY1 * levelWidth + sourceX0) * 4
        fourth = (sourceY1 * levelWidth + sourceX1) * 4
        destination = (y * nextWidth + x) * 4
        channel = 0
        while channel < 4
          nextPixels[destination + channel] = (pixels[first + channel] +
            pixels[second + channel] + pixels[third + channel] +
            pixels[fourth + channel]) >> 2
          channel = channel + 1
        end while
        x = x + 1
      end while
      y = y + 1
    end while
    pixels = nextPixels; levelWidth = nextWidth; levelHeight = nextHeight
    level = level + 1
  end while
end function

// Return the upload picture value.
function uploadPicture(backend, asset)
  record = ensureOpenGlPictureTexture(backend, asset)
  textureId = asset.textureId
  if record.uploaded then return textureId end if
  textureWidth = asset.width; textureHeight = asset.height
  texturePixels = pictureUploadPixels(asset)
  native.glBindTexture(GL_TEXTURE_2D, textureId)
  mipmapped = asset.usage == "skin"
  minFilter = GL_LINEAR
  if mipmapped then minFilter = GL_LINEAR_MIPMAP_NEAREST end if
  native.glTexParameterI(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, minFilter)
  native.glTexParameterI(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
  native.glTexParameterI(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT)
  native.glTexParameterI(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT)
  if mipmapped then
    uploadOpenGlMipChain(textureWidth, textureHeight, texturePixels)
  else
    native.glTexImage2D(GL_TEXTURE_2D, 0, 4, textureWidth, textureHeight, 0,
      GL_RGBA, GL_UNSIGNED_BYTE, texturePixels)
  end if
  record.uploaded = true
  return textureId
end function

// Draw textured rect.
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

// Draw textured sub rect.
function drawTexturedSubRect(backend, asset, x, y, width, height,
    left, top, right, bottom)
  setup2d()
  native.glEnable(GL_TEXTURE_2D)
  native.glEnable(GL_BLEND)
  native.glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
  native.glBindTexture(GL_TEXTURE_2D, uploadPicture(backend, asset))
  native.glColor4ub(255, 255, 255, 255)
  native.glBegin(GL_QUADS)
  native.glTexcoord2(bits(left), bits(top)); native.glVertex2(bits(x * 1.0), bits(y * 1.0))
  native.glTexcoord2(bits(right), bits(top)); native.glVertex2(bits((x + width) * 1.0), bits(y * 1.0))
  native.glTexcoord2(bits(right), bits(bottom)); native.glVertex2(bits((x + width) * 1.0), bits((y + height) * 1.0))
  native.glTexcoord2(bits(left), bits(bottom)); native.glVertex2(bits(x * 1.0), bits((y + height) * 1.0))
  native.glEnd()
  native.glDisable(GL_BLEND)
end function

// Draw tiled rect.
function drawTiledRect(backend, asset, x, y, width, height)
  setup2d()
  native.glEnable(GL_TEXTURE_2D)
  native.glDisable(GL_BLEND)
  native.glBindTexture(GL_TEXTURE_2D, uploadPicture(backend, asset))
  native.glColor4ub(255, 255, 255, 255)
  left = x / 64.0; top = y / 64.0
  right = (x + width) / 64.0; bottom = (y + height) / 64.0
  native.glBegin(GL_QUADS)
  native.glTexcoord2(bits(left), bits(top)); native.glVertex2(bits(x * 1.0), bits(y * 1.0))
  native.glTexcoord2(bits(right), bits(top)); native.glVertex2(bits((x + width) * 1.0), bits(y * 1.0))
  native.glTexcoord2(bits(right), bits(bottom)); native.glVertex2(bits((x + width) * 1.0), bits((y + height) * 1.0))
  native.glTexcoord2(bits(left), bits(bottom)); native.glVertex2(bits(x * 1.0), bits((y + height) * 1.0))
  native.glEnd()
end function

// Draw fade rect.
function drawFadeRect()
  setup2d()
  width = native.winClientWidth(); height = native.winClientHeight()
  native.glDisable(GL_TEXTURE_2D)
  native.glEnable(GL_BLEND)
  native.glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
  native.glColor4ub(0, 0, 0, 190)
  native.glBegin(GL_QUADS)
  native.glVertex2(bits(0.0), bits(0.0))
  native.glVertex2(bits(width * 1.0), bits(0.0))
  native.glVertex2(bits(width * 1.0), bits(height * 1.0))
  native.glVertex2(bits(0.0), bits(height * 1.0))
  native.glEnd()
  native.glDisable(GL_BLEND)
  native.glColor4ub(255, 255, 255, 255)
  native.glEnable(GL_TEXTURE_2D)
end function

// Resolve open gl md 2 skin.
function resolveOpenGlMd2Skin(backend, modelAsset, entity)
  if entity.skin is not void then return rassets.pictureForHandle(backend.assets, entity.skin) end if
  if len(modelAsset.skins) == 0 then return error(9627, "MD2 entity has no registered PCX skin") end if
  skinIndex = entity.skinNum
  if skinIndex < 0 or skinIndex >= len(modelAsset.skins) then skinIndex = 0 end if
  return modelAsset.skins[skinIndex]
end function

// Prepare open gl md 2 entity.
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

// Open gl shade byte.
function inline openGlShadeByte(component)
  value = ropenglbyteio.truncInt(component * 255.0 + 0.5)
  if value < 0 then return 0 end if
  if value > 255 then return 255 end if
  return value
end function

// ref_gl copies RefDef.blend into v_blend and overlays it after the complete
// 3-D scene.  This carries damage flashes, underwater tint and powerup color
// shifts; retaining the field without drawing it leaves all three invisible.
function openGlPolyBlendColor(blend)
  if typeof(blend) != "array" or len(blend) != 4 then
    return error(9633, "polyblend requires four RGBA components")
  end if
  color = bytes(4)
  index = 0
  while index < 4
    component = blend[index]
    if typeof(component) != "int" and typeof(component) != "float" then
      return error(9633, "polyblend component must be numeric")
    end if
    color[index] = openGlShadeByte(component)
    index = index + 1
  end while
  return color
end function

// Draw open gl poly blend.
function drawOpenGlPolyBlend(frame)
  color = openGlPolyBlendColor(frame.blend)
  if color[3] == 0 then return false end if
  setup2d()
  native.glDisable(GL_ALPHA_TEST)
  native.glDisable(GL_TEXTURE_2D)
  native.glEnable(GL_BLEND)
  native.glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
  native.glColor4ub(color[0], color[1], color[2], color[3])
  native.glBegin(GL_QUADS)
  native.glVertex2(bits(frame.x * 1.0), bits(frame.y * 1.0))
  native.glVertex2(bits((frame.x + frame.width) * 1.0), bits(frame.y * 1.0))
  native.glVertex2(bits((frame.x + frame.width) * 1.0),
    bits((frame.y + frame.height) * 1.0))
  native.glVertex2(bits(frame.x * 1.0), bits((frame.y + frame.height) * 1.0))
  native.glEnd()
  native.glColor4ub(255, 255, 255, 255)
  native.glDisable(GL_BLEND)
  native.glEnable(GL_TEXTURE_2D)
  native.glEnable(GL_ALPHA_TEST)
  return true
end function

// Open gl md 2 shade components.
function openGlMd2ShadeComponents(entity, time, rdFlags, baseColor)
  // Keep open gl md 2 shade components phases explicit: validate inputs, update owned state, then publish the result.
  flags = entity.flags
  red = baseColor.red; green = baseColor.green; blue = baseColor.blue
  shellMask = rc.RF_SHELL_RED | rc.RF_SHELL_GREEN | rc.RF_SHELL_BLUE | rc.RF_SHELL_DOUBLE | rc.RF_SHELL_HALF_DAM
  if (flags & shellMask) != 0 then
    red = 0.0; green = 0.0; blue = 0.0
    if (flags & rc.RF_SHELL_RED) != 0 and (flags & rc.RF_SHELL_GREEN) != 0 and (flags & rc.RF_SHELL_BLUE) != 0 then
      red = 1.0; green = 1.0; blue = 1.0
    else if (flags & rc.RF_SHELL_RED) != 0 then
      red = 1.0
      if (flags & (rc.RF_SHELL_BLUE | rc.RF_SHELL_DOUBLE)) != 0 then blue = 1.0 end if
    else if (flags & rc.RF_SHELL_BLUE) != 0 then
      blue = 1.0
      if (flags & rc.RF_SHELL_DOUBLE) != 0 then green = 1.0 end if
    else if (flags & rc.RF_SHELL_DOUBLE) != 0 then
      red = 0.9; green = 0.7
    else
      if (flags & rc.RF_SHELL_HALF_DAM) != 0 then red = 0.56; green = 0.59; blue = 0.45 end if
      if (flags & rc.RF_SHELL_GREEN) != 0 then green = 1.0 end if
    end if
  else if (flags & rc.RF_FULLBRIGHT) != 0 then
    red = 1.0; green = 1.0; blue = 1.0
  end if

  if (flags & rc.RF_MINLIGHT) != 0 and red <= 0.1 and green <= 0.1 and blue <= 0.1 then
    red = 0.1; green = 0.1; blue = 0.1
  end if
  if (flags & rc.RF_GLOW) != 0 then
    scale = 0.1 * rmath.sin(time * 7.0)
    minimum = red * 0.8; red = red + scale
    if red < minimum then red = minimum end if
    minimum = green * 0.8; green = green + scale
    if green < minimum then green = minimum end if
    minimum = blue * 0.8; blue = blue + scale
    if blue < minimum then blue = minimum end if
  end if
  if (rdFlags & rc.RDF_IRGOGGLES) != 0 and (flags & rc.RF_IR_VISIBLE) != 0 then
    red = 1.0; green = 0.0; blue = 0.0
  end if
  return rclassictypes.ClassicPointLight(
    red, green, blue, 0.0, 0.0, 0.0, false)
end function

// Open gl pack md 2 shade.
function inline openGlPackMd2Shade(color)
  return openGlShadeByte(color.red) | (openGlShadeByte(color.green) << 8) |
    (openGlShadeByte(color.blue) << 16)
end function

// Open gl md 2 shade color.
function openGlMd2ShadeColor(entity, time, rdFlags, baseColor)
  return openGlPackMd2Shade(
    openGlMd2ShadeComponents(entity, time, rdFlags, baseColor))
end function

// Open gl md 2 shade.
function openGlMd2Shade(entity, time)
  return openGlMd2ShadeColor(entity, time, 0,
    rclassictypes.ClassicPointLight(1.0, 1.0, 1.0, 0.0, 0.0, 0.0, false))
end function

// Open gl md 2 frame shade components.
function openGlMd2FrameShadeComponents(backend, frame, entity)
  shellMask = rc.RF_SHELL_RED | rc.RF_SHELL_GREEN | rc.RF_SHELL_BLUE |
    rc.RF_SHELL_DOUBLE | rc.RF_SHELL_HALF_DAM
  baseColor = rclassictypes.ClassicPointLight(
    1.0, 1.0, 1.0, 0.0, 0.0, 0.0, false)
  sample = rclassicpointlighting.pointLightSample(backend.activeWorld, frame,
    entity.origin)
  backend.md2LightSpotZ = sample.spotZ
  backend.md2LightSpotValid = sample.validSpot
  if (entity.flags & shellMask) == 0 and
      (entity.flags & rc.RF_FULLBRIGHT) == 0 then
    baseColor = sample
    if (entity.flags & rc.RF_WEAPONMODEL) != 0 then
      maximum = baseColor.red
      if baseColor.green > maximum then maximum = baseColor.green end if
      if baseColor.blue > maximum then maximum = baseColor.blue end if
      backend.lightLevel = ropenglbyteio.truncInt(150.0 * maximum) & 255
    end if
  end if
  return openGlMd2ShadeComponents(entity, frame.time, frame.rdFlags, baseColor)
end function

// Open gl md 2 frame shade.
function openGlMd2FrameShade(backend, frame, entity)
  return openGlPackMd2Shade(
    openGlMd2FrameShadeComponents(backend, frame, entity))
end function

// Open gl md 2 shade row index.
function inline openGlMd2ShadeRowIndex(yaw)
  return ropenglbyteio.truncInt(yaw * (16.0 / 360.0)) & 15
end function

// anormtab.h is generated from Quake II's 162 bytedirs. Keep the compact
// source normals as the single truth and lazily materialize only the sixteen
// 648-byte rows. Values are rounded to the original table's hundredths.
function buildOpenGlMd2ShadeRow(rowIndex)
  normals = ropengldirections.normals
  result = bytes(len(normals) * 4)
  angle = rowIndex * (360.0 / 16.0) * DEG_TO_RAD
  inverseRootTwo = 1.0 / rmath.sqrt(2.0)
  shadeX = rmath.cos(-angle) * inverseRootTwo
  shadeY = rmath.sin(-angle) * inverseRootTwo
  shadeZ = inverseRootTwo
  normalIndex = 0
  while normalIndex < len(normals)
    normal = normals[normalIndex]
    dot = normal[0] * shadeX + normal[1] * shadeY + normal[2] * shadeZ
    if dot < 0.0 then dot = dot * 0.3 end if
    value = ropenglbyteio.truncInt((1.0 + dot) * 100.0 + 0.5) / 100.0
    ropenglbyteio.putF32(result, normalIndex * 4, value)
    normalIndex = normalIndex + 1
  end while
  return result
end function

// Open gl md 2 shade row.
function openGlMd2ShadeRow(backend, yaw)
  rowIndex = openGlMd2ShadeRowIndex(yaw)
  result = backend.md2ShadeRows[rowIndex]
  if result is void then
    result = buildOpenGlMd2ShadeRow(rowIndex)
    backend.md2ShadeRows[rowIndex] = result
  end if
  return result
end function

// Open gl md 2 normal vectors.
function openGlMd2NormalVectors(backend)
  normals = ropengldirections.normals
  expected = len(normals) * 12
  if len(backend.md2NormalVectors) == expected then
    return backend.md2NormalVectors
  end if
  result = bytes(expected)
  normalIndex = 0
  while normalIndex < len(normals)
    normal = normals[normalIndex]
    offset = normalIndex * 12
    ropenglbyteio.putF32(result, offset, normal[0])
    ropenglbyteio.putF32(result, offset + 4, normal[1])
    ropenglbyteio.putF32(result, offset + 8, normal[2])
    normalIndex = normalIndex + 1
  end while
  backend.md2NormalVectors = result
  return result
end function

// R_DrawAliasModel negates PITCH before calling R_RotateForEntity (the
// original source's "sigh" workaround). R_RotateForEntity negates it again,
// so alias models use a positive pitch rotation while brush models do not.
function inline openGlMd2ModelPitch(angle)
  return angle
end function

// Begin open gl md 2 draw.
function beginOpenGlMd2Draw(backend, skinAsset, entity, frame)
  // Keep begin open gl md 2 draw phases explicit: validate inputs, update owned state, then publish the result.
  entityFlags = entity.flags; entityAlpha = entity.alpha
  entityOrigin = entity.origin; entityAngles = entity.angles
  originX = entityOrigin.x; originY = entityOrigin.y; originZ = entityOrigin.z
  angleX = entityAngles.x; angleY = entityAngles.y; angleZ = entityAngles.z
  textureId = uploadPicture(backend, skinAsset)
  alpha = 255
  translucent = (entityFlags & rc.RF_TRANSLUCENT) != 0
  depthHack = (entityFlags & rc.RF_DEPTHHACK) != 0
  shell = (entityFlags & (rc.RF_SHELL_RED | rc.RF_SHELL_GREEN | rc.RF_SHELL_BLUE | rc.RF_SHELL_DOUBLE | rc.RF_SHELL_HALF_DAM)) != 0
  mirrored = (entityFlags & rc.RF_WEAPONMODEL) != 0 and backend.handedness == 1
  native.glCullFace(GL_FRONT)
  if mirrored then native.glCullFace(GL_BACK) end if
  native.glEnable(GL_CULL_FACE)
  if depthHack then native.glDepthRange(bits(0.0), bits(0.3)) end if
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
  if shell then native.glDisable(GL_TEXTURE_2D)
  else native.glEnable(GL_TEXTURE_2D); native.glBindTexture(GL_TEXTURE_2D, textureId)
  end if
  shadeColor = openGlMd2ShadeComponents(entity, 0.0, 0,
    rclassictypes.ClassicPointLight(
      1.0, 1.0, 1.0, 0.0, 0.0, 0.0, false))
  if frame is not void then
    shadeColor = openGlMd2FrameShadeComponents(backend, frame, entity)
  end if
  shade = openGlPackMd2Shade(shadeColor)
  native.glColor4ub(colorByte(shade, 0), colorByte(shade, 8), colorByte(shade, 16), alpha)
  if mirrored then
    native.glMatrixMode(GL_PROJECTION)
    native.glPushMatrix()
    native.glScale(bits(-1.0), bits(1.0), bits(1.0))
    native.glMatrixMode(GL_MODELVIEW)
  end if
  native.glPushMatrix()
  native.glTranslate(bits(originX), bits(originY), bits(originZ))
  native.glRotate(bits(angleY), bits(0.0), bits(0.0), bits(1.0))
  native.glRotate(bits(openGlMd2ModelPitch(angleX)), bits(0.0), bits(1.0), bits(0.0))
  native.glRotate(bits(-angleZ), bits(1.0), bits(0.0), bits(0.0))
  return Md2DrawState(textureId, translucent, depthHack, shell, mirrored,
    shadeColor.red, shadeColor.green, shadeColor.blue, alpha)
end function

// Emit open gl md 2 scalars.
function emitOpenGlMd2Scalars(glVertices)
  vertexScalarCount = len(glVertices)
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
end function

// End open gl md 2 draw.
function endOpenGlMd2Draw(drawState)
  native.glPopMatrix()
  if drawState.mirrored then
    native.glMatrixMode(GL_PROJECTION)
    native.glPopMatrix()
    native.glMatrixMode(GL_MODELVIEW)
  end if
  if drawState.depthHack then native.glDepthRange(bits(0.0), bits(1.0)) end if
  if drawState.shell then native.glEnable(GL_TEXTURE_2D) end if
  if drawState.translucent then
    native.glDepthMask(1)
    native.glDisable(GL_BLEND)
  end if
  native.glCullFace(GL_FRONT)
  native.glDisable(GL_CULL_FACE)
  native.glColor4ub(255, 255, 255, 255)
end function

// Apply a compositor-safe brightness fallback to the completed framebuffer.
// Modern Windows can accept SetDeviceGammaRamp while silently ignoring it in
// windowed/HDR composition. This exposure approximation keeps black anchored
// when brightening and uses an ordinary black blend when darkening, so the
// video-menu control always has an immediate visible runtime effect.
function drawOpenGlBrightness(backend)
  gamma = backend.brightness
  if gamma == 1.0 or gamma == 1 then return false end if
  setup2d()
  width = native.winClientWidth(); height = native.winClientHeight()
  native.glDisable(GL_TEXTURE_2D)
  native.glDisable(GL_ALPHA_TEST)
  native.glEnable(GL_BLEND)
  if gamma < 1.0 then
    component = ropenglbyteio.truncInt((1.0 / gamma - 1.0) * 255.0 + 0.5)
    if component < 0 then component = 0 end if
    if component > 255 then component = 255 end if
    native.glBlendFunc(GL_DST_COLOR, GL_ONE)
    native.glColor4ub(component, component, component, 255)
  else
    alpha = ropenglbyteio.truncInt((1.0 - 1.0 / gamma) * 255.0 + 0.5)
    if alpha < 0 then alpha = 0 end if
    if alpha > 255 then alpha = 255 end if
    native.glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
    native.glColor4ub(0, 0, 0, alpha)
  end if
  native.glBegin(GL_QUADS)
  native.glVertex2(bits(0.0), bits(0.0))
  native.glVertex2(bits(width * 1.0), bits(0.0))
  native.glVertex2(bits(width * 1.0), bits(height * 1.0))
  native.glVertex2(bits(0.0), bits(height * 1.0))
  native.glEnd()
  native.glDisable(GL_BLEND)
  native.glColor4ub(255, 255, 255, 255)
  native.glEnable(GL_TEXTURE_2D)
  return true
end function

// Report whether open gl md 2 entity visible.
function inline openGlMd2EntityVisible(backend, entity)
  return (entity.flags & rc.RF_WEAPONMODEL) == 0 or backend.handedness != 2
end function

// Conservatively cull alias models with the union radius of the current and
// previous poses. Weapon models deliberately bypass the world frustum, as in
// the original R_CullAliasModel call site.
function inline openGlMd2EntityInFrustum(modelAsset, entity, frame)
  if (entity.flags & rc.RF_WEAPONMODEL) != 0 then return true end if
  frameIndex = entity.frame; oldFrameIndex = entity.oldFrame
  frameCount = len(modelAsset.frameBounds)
  if frameIndex < 0 or frameIndex >= frameCount then frameIndex = 0 end if
  if oldFrameIndex < 0 or oldFrameIndex >= frameCount then oldFrameIndex = 0 end if
  radius = modelAsset.frameBounds[frameIndex].radius
  oldRadius = modelAsset.frameBounds[oldFrameIndex].radius
  if oldRadius > radius then radius = oldRadius end if
  return rclassicvisibility.classicVisibilitySphereInsideFrustum(
    entity.origin, radius, frame)
end function

// Return the immutable GPU cache state for one MD2 frame pair.
function inline openGlMd2GeometryState(frameIndex, oldFrameIndex)
  return ((frameIndex * 73856093) ^ (oldFrameIndex * 19349663) ^
    0x4d4432) & 0x7fffffff
end function

// Draw open gl md 2 scalars.
function drawOpenGlMd2Scalars(backend, skinAsset, glVertices, triangleCount,
    vertexCount, resultBounds, entity, frame)
  // Root every managed value before the first native call. The live path uses
  // one flat scalar array, avoiding the temporary MeshVertex object graph.
  drawState = beginOpenGlMd2Draw(backend, skinAsset, entity, frame)
  native.glBegin(GL_TRIANGLES)
  emitOpenGlMd2Scalars(glVertices)
  native.glEnd()
  endOpenGlMd2Draw(drawState)
  return Md2SubmitStats(true, triangleCount, vertexCount,
    drawState.textureId, resultBounds)
end function

// Draw open gl md 2 plan.
function drawOpenGlMd2Plan(backend, plan, entity)
  return drawOpenGlMd2Scalars(backend, plan.skinAsset, plan.glVertices,
    plan.mesh.triangleCount, len(plan.mesh.vertices), plan.bounds, entity, void)
end function

// Draw open gl md 2 entity fast.
function drawOpenGlMd2EntityFast(backend, modelAsset, entity, frame, entityIndex)
  frameIndex = entity.frame; oldFrameIndex = entity.oldFrame
  frameCount = len(modelAsset.source.frames)
  if frameIndex < 0 or frameIndex >= frameCount then
    frameIndex = 0; oldFrameIndex = 0
  end if
  if oldFrameIndex < 0 or oldFrameIndex >= frameCount then
    frameIndex = 0; oldFrameIndex = 0
  end if
  skinAsset = resolveOpenGlMd2Skin(backend, modelAsset, entity)
  bounds = modelAsset.frameBounds[frameIndex]
  triangleCount = len(modelAsset.source.triangles)
  backLerp = entity.backLerp
  if backLerp < 0.0 then backLerp = 0.0 end if
  if backLerp > 1.0 then backLerp = 1.0 end if
  // The native OpenGL path stores both MD2 poses in one immutable VBO and
  // interpolates them on the GPU. The cache key therefore identifies only the
  // frame pair; backLerp remains a continuous per-draw value and no longer
  // forces a VBO delete/upload for every rendered animation sample.
  geometryState = openGlMd2GeometryState(frameIndex, oldFrameIndex)
  shell = (entity.flags & (rc.RF_SHELL_RED | rc.RF_SHELL_GREEN |
    rc.RF_SHELL_BLUE | rc.RF_SHELL_DOUBLE | rc.RF_SHELL_HALF_DAM)) != 0
  drawState = beginOpenGlMd2Draw(backend, skinAsset, entity, frame)
  if entityIndex >= 0 and entityIndex < rc.MAX_ENTITIES then
    backend.md2ShadowSpotZ[entityIndex] = backend.md2LightSpotZ
    if backend.md2LightSpotValid then backend.md2ShadowValid[entityIndex] = 1
    else backend.md2ShadowValid[entityIndex] = 0
    end if
  end if
  if not shell then
    shadeDots = openGlMd2ShadeRow(backend, entity.angles.y)
    normalVectors = openGlMd2NormalVectors(backend)
    modelData = modelAsset.source.rawData
    drawnTriangles = native.glDrawMd2Rgb(modelData, len(modelData), frameIndex,
      oldFrameIndex, bits(backLerp), shadeDots,
      len(ropengldirections.normals), normalVectors,
      len(ropengldirections.normals), nativeRawValue(modelAsset),
      geometryState,
      openGlMd2ShadeRowIndex(entity.angles.y),
      bits(drawState.shadeRed), bits(drawState.shadeGreen),
      bits(drawState.shadeBlue), drawState.alpha)
    if drawnTriangles == triangleCount then
      endOpenGlMd2Draw(drawState)
      return Md2SubmitStats(true, triangleCount, triangleCount * 3,
        drawState.textureId, bounds)
    end if
  end if
  native.glDrawAliasRgbEnd()
  cachePass = geometryState
  if shell then cachePass = cachePass + 10000000 end if
  if native.glStaticGeometryCall(nativeRawValue(modelAsset), cachePass) != 0 then
    endOpenGlMd2Draw(drawState)
    return Md2SubmitStats(true, triangleCount, triangleCount * 3,
      drawState.textureId, bounds)
  end if
  scalars = void
  if shell then
    scalars = rgeom.md2PowerShellFrameScalars(modelAsset.source, frameIndex,
      oldFrameIndex, backLerp)
  else
    scalars = rgeom.md2FrameScalars(modelAsset.source, frameIndex,
      oldFrameIndex, backLerp)
  end if
  native.glBegin(GL_TRIANGLES)
  emitOpenGlMd2Scalars(scalars)
  native.glEnd()
  endOpenGlMd2Draw(drawState)
  return Md2SubmitStats(true, triangleCount, triangleCount * 3,
    drawState.textureId, bounds)
end function

// Submit open gl ref def md 2 entities.
function submitOpenGlRefDefMd2Entities(backend, frame)
  submitted = 0
  entityIndex = 0
  while entityIndex < frame.numEntities
    entity = frame.entities[entityIndex]
    modelAsset = rassets.findModelByHandle(backend.assets, entity.model)
    if modelAsset is not void and modelAsset.kind == "md2" and
        openGlMd2EntityVisible(backend, entity) and
        openGlMd2EntityInFrustum(modelAsset, entity, frame) then
      drawOpenGlMd2EntityFast(backend, modelAsset, entity, frame, entityIndex)
      submitted = submitted + 1
    end if
    entityIndex = entityIndex + 1
  end while
  native.glDrawAliasRgbEnd()
  return submitted
end function

// Draw open gl entity pass.
function drawOpenGlEntityPass(backend, frame, axes, translucentPass)
  submitted = 0
  if translucentPass then native.glDepthMask(0) end if
  entityIndex = 0
  while entityIndex < frame.numEntities
    entity = frame.entities[entityIndex]
    translucent = (entity.flags & rc.RF_TRANSLUCENT) != 0
    if translucent == translucentPass then
      if translucentPass then native.glDepthMask(0) end if
      if (entity.flags & rc.RF_BEAM) != 0 then
        native.glDrawAliasRgbEnd()
        if drawOpenGlBeam(backend, entity) then submitted = submitted + 1 end if
      else
        modelAsset = rassets.findModelByHandle(backend.assets, entity.model)
        if modelAsset is void then
          native.glDrawAliasRgbEnd()
          drawOpenGlNullEntity(entity); submitted = submitted + 1
        else if modelAsset.kind == "md2" and
            openGlMd2EntityVisible(backend, entity) and
            openGlMd2EntityInFrustum(modelAsset, entity, frame) then
          drawOpenGlMd2EntityFast(backend, modelAsset, entity, frame,
            entityIndex); submitted = submitted + 1
        else if modelAsset.kind == "sprite" then
          native.glDrawAliasRgbEnd()
          drawOpenGlSpriteEntity(backend, modelAsset, entity, axes); submitted = submitted + 1
        end if
        // Inline BSP entities are submitted with the world so they can share
        // its ordered opaque/lightmap/alpha passes.
      end if
    end if
    entityIndex = entityIndex + 1
  end while
  native.glDrawAliasRgbEnd()
  if translucentPass then native.glDepthMask(1) end if
  return submitted
end function

// Open gl md 2 shadow eligible.
function inline openGlMd2ShadowEligible(backend, entity)
  return backend.shadows and
    (entity.flags & (rc.RF_TRANSLUCENT | rc.RF_WEAPONMODEL)) == 0
end function

// Open gl md 2 shadow vector x.
function inline openGlMd2ShadowVectorX(yaw)
  return rmath.cos(-yaw * DEG_TO_RAD) / rmath.sqrt(2.0)
end function

// Open gl md 2 shadow vector y.
function inline openGlMd2ShadowVectorY(yaw)
  return rmath.sin(-yaw * DEG_TO_RAD) / rmath.sqrt(2.0)
end function

// Open gl md 2 shadow light height.
function inline openGlMd2ShadowLightHeight(entity, spotZ)
  return entity.origin.z - spotZ
end function

// Keep alias lighting in one shader run, then submit the original optional
// GL_DrawAliasShadow behavior as a separate blended pass over cached MD2 VBOs.
function drawOpenGlMd2ShadowPass(backend, frame)
  // Keep draw open gl md 2 shadow pass phases explicit: validate inputs, update owned state, then publish the result.
  if not backend.shadows then return 0 end if
  native.glDrawAliasRgbEnd()
  native.glDisable(GL_TEXTURE_2D)
  native.glEnable(GL_BLEND)
  native.glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
  native.glColor4ub(0, 0, 0, 128)
  submitted = 0
  entityIndex = 0
  while entityIndex < frame.numEntities
    entity = frame.entities[entityIndex]
    if backend.md2ShadowValid[entityIndex] != 0 and
        openGlMd2ShadowEligible(backend, entity) then
      modelAsset = rassets.findModelByHandle(backend.assets, entity.model)
      if modelAsset is not void and modelAsset.kind == "md2" then
        frameIndex = entity.frame; oldFrameIndex = entity.oldFrame
        frameCount = len(modelAsset.source.frames)
        if frameIndex < 0 or frameIndex >= frameCount then
          frameIndex = 0; oldFrameIndex = 0
        end if
        if oldFrameIndex < 0 or oldFrameIndex >= frameCount then
          frameIndex = 0; oldFrameIndex = 0
        end if
        backLerp = entity.backLerp
        if backLerp < 0.0 then backLerp = 0.0 end if
        if backLerp > 1.0 then backLerp = 1.0 end if
        geometryState = openGlMd2GeometryState(frameIndex, oldFrameIndex)
        modelData = modelAsset.source.rawData
        normalVectors = openGlMd2NormalVectors(backend)
        native.glPushMatrix()
        native.glTranslate(bits(entity.origin.x), bits(entity.origin.y),
          bits(entity.origin.z))
        native.glRotate(bits(entity.angles.y), bits(0.0), bits(0.0), bits(1.0))
        native.glRotate(bits(-entity.angles.x), bits(0.0), bits(1.0), bits(0.0))
        native.glRotate(bits(-entity.angles.z), bits(1.0), bits(0.0), bits(0.0))
        drawn = native.glDrawMd2Shadow(modelData, len(modelData), frameIndex,
          oldFrameIndex, bits(backLerp), normalVectors,
          len(ropengldirections.normals), nativeRawValue(modelAsset),
          geometryState, len(modelAsset.source.triangles),
          bits(openGlMd2ShadowVectorX(entity.angles.y)),
          bits(openGlMd2ShadowVectorY(entity.angles.y)),
          bits(openGlMd2ShadowLightHeight(entity,
            backend.md2ShadowSpotZ[entityIndex])))
        native.glPopMatrix()
        if drawn == len(modelAsset.source.triangles) then
          submitted = submitted + 1
        end if
      end if
    end if
    entityIndex = entityIndex + 1
  end while
  native.glColor4ub(255, 255, 255, 255)
  native.glDisable(GL_BLEND)
  native.glEnable(GL_TEXTURE_2D)
  return submitted
end function

// Draw the alias shadows only after the current frame's alias lighting pass has
// populated md2ShadowSpotZ. This removes the historical one-frame stale spot
// introduced by MiniQuake2's split world/entity submission API.
function drawOpenGlPendingClassicShadows(backend)
  pending = openGlPendingClassicPasses
  if not pending.active then return 0 end if
  submitted = drawOpenGlMd2ShadowPass(backend, pending.frame)
  backend.lastShadowEntities = submitted
  backend.submittedShadows = backend.submittedShadows + submitted
  return submitted
end function

// Finish stock's tail ordering after entities and particles. The actual alpha
// draw routine is declared later with the other ClassicWorld helpers.
function flushOpenGlPendingClassicAlpha()
  pending = openGlPendingClassicPasses
  if not pending.active then return 0 end if
  uploaded = drawOpenGlClassicTransparentFrame(pending.binding,
    pending.transparentDraws, pending.frame)
  if pending.stats is not void then
    recordClassicDeferredUploads(pending.stats, uploaded)
  end if
  pending.binding = void; pending.transparentDraws = []; pending.frame = void
  pending.active = false; pending.stats = void
  return uploaded
end function

// Add uploads completed after submitClassicWorld returned to its retained
// mutable diagnostic record.
function recordClassicDeferredUploads(stats, uploaded)
  if stats is void then return 0 end if
  stats.uploadedTextures = stats.uploadedTextures + uploaded
  return stats.uploadedTextures
end function

// The full product graph is large enough to expose a closure-layout bug in the
// current self-hosted compiler. The production renderer therefore publishes
// capture-free top-level callbacks and resolves its one active backend through
// the package-owned slot. This also keeps the deterministic command recorder
// out of the real-time path.
function openGlRequireInitialized(backend, operation)
  if not backend.core.state.initialized then
    return error(9600, operation + " called before renderer Init")
  end if
  return true
end function

// Open gl renderer init.
function openGlRendererInit(hinstance, wndproc)
  backend = openGlBackendSlot.backend
  if backend.core.state.initialized then return true end if
  backend.core.state.initialized = true
  if backend.contextActive then
    backend.vendor = native.glGetString(GL_VENDOR)
    backend.renderer = native.glGetString(GL_RENDERER)
    backend.version = native.glGetString(GL_VERSION)
  end if
  openGlLoadGamePalette(backend)
  return true
end function

// Open gl renderer shutdown.
function openGlRendererShutdown()
  backend = openGlBackendSlot.backend
  if not backend.core.state.initialized then return void end if
  if backend.core.state.frameOpen then
    return error(9601, "Shutdown called inside a frame")
  end if
  if backend.contextActive then native.glStaticGeometryClear() end if
  releaseOpenGlTextureRecords(backend)
  backend.particleTextureId = 0; backend.rawTextureId = 0; backend.rawPixels = bytes(0)
  backend.core.state.registrationOpen = false
  backend.core.state.initialized = false
end function

// Open gl begin registration.
function openGlBeginRegistration(mapName)
  backend = openGlBackendSlot.backend
  openGlRequireInitialized(backend, "BeginRegistration")
  if mapName == "" then return error(9602, "BeginRegistration requires a map name") end if
  state = backend.core.state
  state.registrationGeneration = state.registrationGeneration + 1
  state.registrationOpen = true
  state.models = []; state.skins = []; state.pictures = []
  state.lastRefDef = void
  if backend.contextActive then native.glStaticGeometryClear() end if
  releaseOpenGlTextureRecords(backend)
  backend.particleTextureId = 0; backend.rawTextureId = 0
  rassets.beginRegistration(backend.assets)
  openGlLoadGamePalette(backend)
end function

// Open gl register model.
function openGlRegisterModel(name)
  backend = openGlBackendSlot.backend
  openGlRequireInitialized(backend, "RegisterModel")
  if name == "" then return void end if
  if backend.imports is void then
    return recording.registerResource(backend.core.state, "model", name)
  end if
  modelAsset = rassets.registerModel(backend.assets, backend.imports, name)
  if modelAsset.kind == "md2" or modelAsset.kind == "sprite" then
    for each skinAsset in modelAsset.skins
      ensureOpenGlPictureTexture(backend, skinAsset)
      if backend.contextActive then uploadPicture(backend, skinAsset) end if
    end for
  end if
  return modelAsset.handle
end function

// Open gl register skin.
function openGlRegisterSkin(name)
  backend = openGlBackendSlot.backend
  openGlRequireInitialized(backend, "RegisterSkin")
  if name == "" then return void end if
  if backend.imports is void then
    return recording.registerResource(backend.core.state, "skin", name)
  end if
  asset = rassets.registerPicture(backend.assets, backend.imports, name)
  ensureOpenGlPictureTexture(backend, asset)
  if backend.contextActive then uploadPicture(backend, asset) end if
  return asset.handle
end function

// Open gl register pic.
function openGlRegisterPic(name)
  backend = openGlBackendSlot.backend
  openGlRequireInitialized(backend, "RegisterPic")
  if name == "" then return void end if
  if backend.imports is void then
    return recording.registerResource(backend.core.state, "pic", name)
  end if
  asset = rassets.registerPicture(backend.assets, backend.imports, name)
  ensureOpenGlPictureTexture(backend, asset)
  if backend.contextActive then uploadPicture(backend, asset) end if
  return asset.handle
end function

// Open gl set sky.
function openGlSetSky(name, rotate, axis)
  backend = openGlBackendSlot.backend
  openGlRequireInitialized(backend, "SetSky")
  checked = validation.validateVec3(axis, "sky axis")
  if not checked.valid then return error(9603, checked.message) end if
  backend.core.state.skyName = name
  backend.core.state.skyRotate = rotate
  backend.core.state.skyAxis = axis
end function

// Open gl end registration.
function openGlEndRegistration()
  backend = openGlBackendSlot.backend
  openGlRequireInitialized(backend, "EndRegistration")
  if backend.contextActive then
    // Skin/picture conversion expands indexed PCX/WAL pixels to RGBA and the
    // driver creates the texture on first upload. Doing that lazily made the
    // second gameplay frame spend more than 200 ms inside RenderFrame. Finish
    // all registered image work while the product loading screen is active;
    // it also covers projectile particles before the first shot.
    for each registeredPicture in backend.assets.pictures
      uploadPicture(backend, registeredPicture)
    end for
    ensureOpenGlParticleTexture(backend)
    // Alias-model lighting quantizes yaw into sixteen shadedot rows. Building
    // the first row lazily was the remaining >200-ms second-frame stall, and
    // later monster rotations could repeat it for the other rows. Generate the
    // complete tiny lookup table plus packed normal vectors during loading.
    shadeRowIndex = 0
    while shadeRowIndex < len(backend.md2ShadeRows)
      if backend.md2ShadeRows[shadeRowIndex] is void then
        backend.md2ShadeRows[shadeRowIndex] = buildOpenGlMd2ShadeRow(shadeRowIndex)
      end if
      shadeRowIndex = shadeRowIndex + 1
    end while
    openGlMd2NormalVectors(backend)
  end if
  backend.core.state.registrationOpen = false
end function

// Normalize the mutable effect handoff counts and validate its constant-time
// product contract. A zero client viewport is a normal minimized-window state,
// not a fatal renderer error.
function prepareProductRefDef(frame)
  if frame is void or typeof(frame) != "struct" then
    return error(9604, "product refdef is missing")
  end if
  if typeof(frame.width) != "int" or typeof(frame.height) != "int" then
    return error(9604, "product refdef viewport is not integral")
  end if
  if frame.width <= 0 or frame.height <= 0 then return false end if
  if typeof(frame.entities) != "array" or typeof(frame.dLights) != "array" or
      typeof(frame.particles) != "array" then
    return error(9604, "product refdef render collections are not arrays")
  end if
  // Entity effects append to the typed RefDef after construction. Treat the
  // arrays as authoritative and repair redundant C-ABI count mirrors here.
  frame.numEntities = len(frame.entities)
  frame.numDLights = len(frame.dLights)
  frame.numParticles = len(frame.particles)
  if frame.numEntities > rc.MAX_ENTITIES then
    return error(9604, "product refdef entity limit exceeded")
  end if
  if frame.numDLights > rc.MAX_DLIGHTS then
    return error(9604, "product refdef dynamic-light limit exceeded")
  end if
  if frame.numParticles > rc.MAX_PARTICLES then
    return error(9604, "product refdef particle limit exceeded")
  end if
  if typeof(frame.blend) != "array" or len(frame.blend) != 4 then
    return error(9604, "product refdef blend must contain four values")
  end if
  if typeof(frame.lightStyles) != "array" or
      len(frame.lightStyles) != rc.MAX_LIGHTSTYLES then
    return error(9604, "product refdef must contain 256 light styles")
  end if
  return true
end function

// Open gl render frame.
function openGlRenderFrame(frame)
  backend = openGlBackendSlot.backend
  openGlRequireInitialized(backend, "RenderFrame")
  // Headless contract mode retains the exhaustive API validator. Product
  // frames are constructed by the typed client handoff, so a constant-time
  // shape check avoids allocating hundreds of ValidationResult records for
  // the 256 light styles on every rendered frame.
  if backend.contextActive then
    productFrameReady = prepareProductRefDef(frame)
    if not productFrameReady then return false end if
  else
    checked = validation.validateRefDef(frame)
    if not checked.valid then return error(9604, checked.code + ": " + checked.message) end if
  end if
  backend.core.state.lastRefDef = frame
  backend.core.state.frameCount = backend.core.state.frameCount + 1
  if backend.contextActive then
    setup3d(frame)
    if (frame.rdFlags & rc.RDF_NOWORLDMODEL) != 0 then
      // A menu preview can follow the world view in the same BeginFrame. Drop
      // its depth without erasing the already composed 2-D menu background.
      native.glClear(GL_DEPTH_BUFFER_BIT)
    end if
    frameState = openGlFrameSlot
    frameState.twoDimensional = false
    native.glEnable(GL_DEPTH_TEST)
    native.glDepthFunc(GL_LEQUAL)
    native.glDepthMask(1)
    axes = openGlViewAxes(frame.viewAngles)
    shadowIndex = 0
    while shadowIndex < frame.numEntities
      backend.md2ShadowValid[shadowIndex] = 0
      shadowIndex = shadowIndex + 1
    end while
    drawOpenGlEntityPass(backend, frame, axes, false)
    drawOpenGlEntityPass(backend, frame, axes, true)
    backend.lastShadowEntities = 0
    drawOpenGlPendingClassicShadows(backend)
    drawParticles(backend, frame, axes)
    flushOpenGlPendingClassicAlpha()
    drawOpenGlPolyBlend(frame)
    backend.submittedEntities = backend.submittedEntities + frame.numEntities
    backend.submittedParticles = backend.submittedParticles + frame.numParticles
  end if
  backend.submittedFrames = backend.submittedFrames + 1
end function

// Open gl draw get pic size.
function openGlDrawGetPicSize(name)
  backend = openGlBackendSlot.backend
  openGlRequireInitialized(backend, "DrawGetPicSize")
  if backend.imports is void then return rt.PicSize(0, 0) end if
  asset = rassets.findPicture(backend.assets, name)
  if asset is void then asset = rassets.registerPicture(backend.assets, backend.imports, name) end if
  return rt.PicSize(asset.width, asset.height)
end function

// Open gl draw pic.
function openGlDrawPic(x, y, name)
  backend = openGlBackendSlot.backend
  openGlRequireInitialized(backend, "DrawPic")
  if backend.contextActive and backend.imports is not void then
    asset = rassets.findPicture(backend.assets, name)
    if asset is void then asset = rassets.registerPicture(backend.assets, backend.imports, name) end if
    drawTexturedRect(backend, asset, x, y, asset.width, asset.height)
  end if
end function

// Open gl draw stretch pic.
function openGlDrawStretchPic(x, y, width, height, name)
  backend = openGlBackendSlot.backend
  openGlRequireInitialized(backend, "DrawStretchPic")
  if width < 0 or height < 0 then return error(9605, "DrawStretchPic dimensions must not be negative") end if
  if backend.contextActive and backend.imports is not void then
    asset = rassets.findPicture(backend.assets, name)
    if asset is void then asset = rassets.registerPicture(backend.assets, backend.imports, name) end if
    drawTexturedRect(backend, asset, x, y, width, height)
  end if
end function

// Open gl draw char.
function openGlDrawChar(x, y, character)
  backend = openGlBackendSlot.backend
  openGlRequireInitialized(backend, "DrawChar")
  glyph = character & 255
  if (glyph & 127) == 32 or y <= -8 or not backend.contextActive or backend.imports is void then
    return void
  end if
  asset = rassets.findPicture(backend.assets, "conchars")
  if asset is void then asset = rassets.registerPicture(backend.assets, backend.imports, "conchars") end if
  column = glyph & 15; row = glyph >> 4
  left = column / 16.0; top = row / 16.0
  drawTexturedSubRect(backend, asset, x, y, 8, 8,
    left, top, left + 0.0625, top + 0.0625)
end function

// Open gl draw tile clear.
function openGlDrawTileClear(x, y, width, height, name)
  backend = openGlBackendSlot.backend
  openGlRequireInitialized(backend, "DrawTileClear")
  if width < 0 or height < 0 then return error(9606, "DrawTileClear dimensions must not be negative") end if
  if backend.contextActive and backend.imports is not void then
    asset = rassets.findPicture(backend.assets, name)
    if asset is void then asset = rassets.registerPicture(backend.assets, backend.imports, name) end if
    drawTiledRect(backend, asset, x, y, width, height)
  end if
end function

// Open gl draw fill.
function openGlDrawFill(x, y, width, height, color)
  backend = openGlBackendSlot.backend
  openGlRequireInitialized(backend, "DrawFill")
  if width < 0 or height < 0 then return error(9607, "DrawFill dimensions must not be negative") end if
  if color < 0 or color > 255 then return error(9608, "DrawFill palette index must be in [0,255]") end if
  if backend.contextActive then drawSolidRect(backend, x, y, width, height, color) end if
end function

// Open gl draw fade screen.
function openGlDrawFadeScreen()
  backend = openGlBackendSlot.backend
  openGlRequireInitialized(backend, "DrawFadeScreen")
  if backend.contextActive then drawFadeRect() end if
end function

// Open gl draw stretch raw.
function openGlDrawStretchRaw(x, y, width, height, columns, rows, data)
  backend = openGlBackendSlot.backend
  openGlRequireInitialized(backend, "DrawStretchRaw")
  if width < 0 or height < 0 or columns < 0 or rows < 0 then
    return error(9609, "DrawStretchRaw dimensions must not be negative")
  end if
  if typeof(data) != "bytes" or len(data) < columns * rows then
    return error(9610, "DrawStretchRaw source data is truncated")
  end if
  if not backend.contextActive or columns == 0 or rows == 0 then return void end if
  palette = backend.core.state.palette
  if typeof(palette) != "bytes" or len(palette) != 768 then palette = backend.gamePalette end if
  raw = prepareOpenGlRawFrame(columns, rows, data, palette, backend.rawPixels)
  backend.rawPixels = raw.rgba
  record = ensureOpenGlRawTexture(backend)
  setup2d()
  native.glEnable(GL_TEXTURE_2D)
  native.glDisable(GL_BLEND)
  native.glBindTexture(GL_TEXTURE_2D, record.id)
  native.glTexParameterI(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
  native.glTexParameterI(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
  native.glTexParameterI(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP)
  native.glTexParameterI(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP)
  native.glTexImage2D(GL_TEXTURE_2D, 0, 4, 256, 256, 0, GL_RGBA,
    GL_UNSIGNED_BYTE, raw.rgba)
  record.uploaded = true
  native.glColor4ub(255, 255, 255, 255)
  native.glBegin(GL_QUADS)
  native.glTexcoord2(bits(0.0), bits(0.0)); native.glVertex2(bits(x * 1.0), bits(y * 1.0))
  native.glTexcoord2(bits(1.0), bits(0.0)); native.glVertex2(bits((x + width) * 1.0), bits(y * 1.0))
  native.glTexcoord2(bits(1.0), bits(raw.textureT)); native.glVertex2(bits((x + width) * 1.0), bits((y + height) * 1.0))
  native.glTexcoord2(bits(0.0), bits(raw.textureT)); native.glVertex2(bits(x * 1.0), bits((y + height) * 1.0))
  native.glEnd()
end function

// Open gl cinematic set palette.
function openGlCinematicSetPalette(palette)
  backend = openGlBackendSlot.backend
  openGlRequireInitialized(backend, "CinematicSetPalette")
  if palette is not void and (typeof(palette) != "bytes" or len(palette) != 768) then
    return error(9611, "cinematic palette must contain 768 bytes or be void")
  end if
  backend.core.state.palette = palette
end function

// Open gl begin frame.
function openGlBeginFrame(cameraSeparation)
  backend = openGlBackendSlot.backend
  openGlRequireInitialized(backend, "BeginFrame")
  if backend.core.state.frameOpen then return error(9612, "BeginFrame called twice") end if
  backend.core.state.frameOpen = true
  pending = openGlPendingClassicPasses
  pending.binding = void; pending.transparentDraws = []; pending.frame = void
  pending.active = false; pending.stats = void
  frameState = openGlFrameSlot
  frameState.twoDimensional = false
  if backend.contextActive then
    native.glClearColor(bits(0.0), bits(0.0), bits(0.0), bits(1.0))
    native.glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
  end if
end function

// Open gl end frame.
function openGlEndFrame()
  backend = openGlBackendSlot.backend
  openGlRequireInitialized(backend, "EndFrame")
  if not backend.core.state.frameOpen then return error(9613, "EndFrame called without BeginFrame") end if
  if backend.contextActive and openGlPendingClassicPasses.active then
    // Compatibility for capture/test callers that submit BSP after RenderFrame.
    drawOpenGlPendingClassicShadows(backend)
    flushOpenGlPendingClassicAlpha()
  end if
  if backend.contextActive then drawOpenGlBrightness(backend) end if
  backend.core.state.frameOpen = false
  if backend.contextActive then
    native.glFlush()
    native.winSwap()
  end if
end function

// Open gl app activate.
function openGlAppActivate(activate)
  backend = openGlBackendSlot.backend
  openGlRequireInitialized(backend, "AppActivate")
  backend.core.state.appActive = activate
end function

// Open gl make exports.
function openGlMakeExports()
  return rt.RefExport(
    rc.API_VERSION, openGlRendererInit, openGlRendererShutdown,
    openGlBeginRegistration, openGlRegisterModel,
    openGlRegisterSkin, openGlRegisterPic, openGlSetSky,
    openGlEndRegistration, openGlRenderFrame, openGlDrawGetPicSize,
    openGlDrawPic, openGlDrawStretchPic, openGlDrawChar,
    openGlDrawTileClear, openGlDrawFill, openGlDrawFadeScreen,
    openGlDrawStretchRaw, openGlCinematicSetPalette, openGlBeginFrame,
    openGlEndFrame, openGlAppActivate,
  )
end function

// Create open gl renderer.
function createOpenGlRenderer(contextActive)
  coreBinding = rt.RendererBinding(recording.createState("null", void), void)
  glState = OpenGlState(coreBinding, void, rassets.create(), contextActive, "", "", "", 0, 0, 0, 0, 0, 1, [], bytes(0), 0, 0, bytes(0), bytes(0), [], -1, array(16), bytes(0), array(rc.MAX_ENTITIES, 0.0), bytes(rc.MAX_ENTITIES), 0.0, false, false, 1.0, 0, void, 0)
  if typeof(glState) != "struct" then return error(9620, "OpenGL state constructor returned " + typeof(glState)) end if
  openGlFactorySlot = openGlBackendSlot
  openGlFactorySlot.backend = glState
  exports = openGlMakeExports()
  return rt.RendererBinding(glState, exports)
end function

// Return ref api.
function getRefAPI(imports, contextActive)
  checked = validation.validateRefImport(imports)
  if not checked.valid then return error(9614, checked.code + ": " + checked.message) end if
  coreBinding = rt.RendererBinding(recording.createState("null", imports), void)
  glState = OpenGlState(coreBinding, imports, rassets.create(), contextActive, "", "", "", 0, 0, 0, 0, 0, 1, [], bytes(0), 0, 0, bytes(0), bytes(0), [], -1, array(16), bytes(0), array(rc.MAX_ENTITIES, 0.0), bytes(rc.MAX_ENTITIES), 0.0, false, false, 1.0, 0, void, 0)
  openGlFactorySlot = openGlBackendSlot
  openGlFactorySlot.backend = glState
  return rt.RendererBinding(glState, openGlMakeExports())
end function

// Report whether set context active.
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

// Set handedness.
function setHandedness(binding, hand)
  if typeof(hand) != "int" or hand < 0 or hand > 2 then
    return error(9637, "renderer handedness must be 0, 1 or 2")
  end if
  binding.state.handedness = hand
  return hand
end function

// Return the handedness value.
function handedness(binding)
  return binding.state.handedness
end function

// Set shadows.
function setShadows(binding, enabled)
  if typeof(enabled) != "bool" then
    return error(9638, "renderer shadows setting must be bool")
  end if
  binding.state.shadows = enabled
  return enabled
end function

// Return the shadows value.
function shadows(binding)
  return binding.state.shadows
end function

// Return the last shadow entities value.
function lastShadowEntities(binding)
  return binding.state.lastShadowEntities
end function

// Return the md 2 shadow eligible value.
function md2ShadowEligible(binding, entity)
  return openGlMd2ShadowEligible(binding.state, entity)
end function

// Return the md 2 shadow vector x value.
function md2ShadowVectorX(yaw)
  return openGlMd2ShadowVectorX(yaw)
end function

// Return the md 2 shadow vector y value.
function md2ShadowVectorY(yaw)
  return openGlMd2ShadowVectorY(yaw)
end function

// Return the md 2 shadow light height value.
function md2ShadowLightHeight(entity, spotZ)
  return openGlMd2ShadowLightHeight(entity, spotZ)
end function

// Return the light level value.
function lightLevel(binding)
  return binding.state.lightLevel
end function

// Return the md 2 entity shade value.
function md2EntityShade(binding, frame, entity)
  return openGlMd2FrameShade(binding.state, frame, entity)
end function

// Return the md 2 shade row value.
function md2ShadeRow(binding, yaw)
  return openGlMd2ShadeRow(binding.state, yaw)
end function

// Report whether md 2 entity visible.
function md2EntityVisible(binding, entity)
  return openGlMd2EntityVisible(binding.state, entity)
end function

// Return the md 2 model pitch value.
function md2ModelPitch(angle)
  return openGlMd2ModelPitch(angle)
end function

// Prepare classic world.
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
  if len(world.scene.skySurfaces) > 0 then ensureOpenGlSkyClipScratch() end if
  for each texture in world.textures
    record = allocateTextureRecord(
      binding.state, world.name + ":" + texture.name, texture.role,
      world.generation, texture.width, texture.height
    )
    texture.id = record.id
  end for
  // One reusable record buffer serves every visible-set submission. The
  // native call receives the active byte count, so camera movement never
  // allocates or concatenates a per-surface command array.
  requiredBatchBytes = len(world.draws) * 16
  if len(binding.state.batchRecords) < requiredBatchBytes then
    binding.state.batchRecords = bytes(requiredBatchBytes)
  end if
  if binding.state.contextActive then
    // Perform immutable WAL/lightmap uploads while the product still displays
    // its loading screen and before waveOut is opened. Lazy first-frame uploads
    // produced a 200+ ms hitch large enough to empty any low-latency audio
    // queue and made the initial gameplay FPS visibly stutter.
    for each preparedTexture in world.textures
      uploadClassicTexture(binding, preparedTexture)
    end for
    precacheOpenGlClassicGeometry(world)
  end if
  binding.state.activeWorld = world
  return world
end function

// Set the post-composition brightness/gamma value.
function setBrightness(binding, brightness)
  if (typeof(brightness) != "int" and typeof(brightness) != "float") or
      brightness != brightness or brightness < 0.5 or brightness > 2.0 then
    return error(9639, "renderer brightness must be inside [0.5,2]")
  end if
  binding.state.brightness = brightness * 1.0
  return binding.state.brightness
end function

// Return the post-composition brightness value.
function brightness(binding)
  return binding.state.brightness
end function

// Return the CPU-side registration graph retained across a video mode change.
function classicRegistrationAssets(binding)
  if binding is void or typeof(binding.state) != "struct" then
    return error(9637, "classic registration renderer is invalid")
  end if
  return binding.state.assets
end function

// Rebind an intact CPU-side world and asset graph to a replacement OpenGL
// context. Resolution/fullscreen changes invalidate native texture names, but
// do not require reparsing the BSP, WAL, PCX, MD2, SP2 or WAV resources.
function restoreClassicRegistration(binding, world, registrationAssets)
  // Validate the retained CPU graph, transfer registry ownership, recreate
  // native textures/geometry, then publish the rebound world atomically.
  if binding is void or typeof(binding.state) != "struct" or
      world is void or typeof(world) != "struct" or world.released or
      world.map is void or registrationAssets is void or
      typeof(registrationAssets) != "struct" then
    return error(9637, "classic registration restore requires live CPU resources")
  end if
  state = binding.state
  state.assets = registrationAssets
  state.core.state.registrationGeneration = registrationAssets.generation
  state.core.state.registrationOpen = false
  state.textureRecords = []
  state.nextTextureId = 1
  state.particleTextureId = 0
  state.rawTextureId = 0
  state.rawPixels = bytes(0)

  for each picture in registrationAssets.pictures
    picture.textureId = 0
    ensureOpenGlPictureTexture(state, picture)
    if state.contextActive then uploadPicture(state, picture) end if
  end for

  world.generation = registrationAssets.generation
  for each texture in world.textures
    texture.generation = world.generation
    texture.released = false
    texture.uploaded = false
    record = allocateTextureRecord(state, world.name + ":" + texture.name,
      texture.role, world.generation, texture.width, texture.height)
    texture.id = record.id
    if state.contextActive then uploadClassicTexture(binding, texture) end if
  end for
  requiredBatchBytes = len(world.draws) * 16
  if len(state.batchRecords) < requiredBatchBytes then
    state.batchRecords = bytes(requiredBatchBytes)
  end if
  if state.contextActive then
    precacheOpenGlClassicGeometry(world)
    ensureOpenGlParticleTexture(state)
    shadeRowIndex = 0
    while shadeRowIndex < len(state.md2ShadeRows)
      if state.md2ShadeRows[shadeRowIndex] is void then
        state.md2ShadeRows[shadeRowIndex] = buildOpenGlMd2ShadeRow(shadeRowIndex)
      end if
      shadeRowIndex = shadeRowIndex + 1
    end while
    openGlMd2NormalVectors(state)
  end if
  state.activeWorld = world
  return world
end function

// Return the upload classic texture value.
function uploadClassicTexture(binding, texture)
  if texture.released then return error(9623, "classic texture handle is not active") end if
  // Texture objects mirror the native record's upload bit. Checking the local
  // hot flag first avoids a linear texture-record lookup for every visible BSP
  // base/lightmap surface on every frame.
  if texture.uploaded then return false end if
  record = findTextureRecord(binding.state, texture.id)
  if record is void or record.released then return error(9623, "classic texture handle is not active") end if
  if record.uploaded then
    texture.uploaded = true
    return false
  end if
  expected = texture.width * texture.height * 4
  if len(texture.rgbaPixels) != expected then return error(9624, "classic texture RGBA payload has invalid size") end if
  native.glBindTexture(GL_TEXTURE_2D, texture.id)
  minFilter = GL_LINEAR
  if texture.role == "base" then minFilter = GL_LINEAR_MIPMAP_NEAREST end if
  native.glTexParameterI(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, minFilter)
  native.glTexParameterI(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
  wrap = GL_REPEAT
  if texture.role == "lightmap" or texture.role == "sky" then wrap = GL_CLAMP end if
  native.glTexParameterI(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, wrap)
  native.glTexParameterI(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, wrap)
  if texture.role == "base" then
    uploadOpenGlMipChain(texture.width, texture.height, texture.rgbaPixels)
  else
    native.glTexImage2D(GL_TEXTURE_2D, 0, 4, texture.width, texture.height, 0,
      GL_RGBA, GL_UNSIGNED_BYTE, texture.rgbaPixels)
  end if
  record.uploaded = true
  texture.uploaded = true
  return true
end function

// Emit classic vertex.
function emitClassicVertex(draw, vertex, lightmap, time)
  position = vertex.position
  positionX = position.x; positionY = position.y; positionZ = position.z
  textureS = 0.0; textureT = 0.0
  if lightmap then
    textureS = vertex.lightS; textureT = vertex.lightT
  else
    coordinates = openGlClassicTextureCoordinateScratch
    rclassicspecial.classicSpecialTextureCoordinatesInto(coordinates, draw,
      vertex, time)
    textureS = coordinates[0]; textureT = coordinates[1]
  end if
  native.glTexcoord2(bits(textureS), bits(textureT))
  native.glVertex3(bits(positionX), bits(positionY), bits(positionZ))
end function

// Emit classic draw.
function emitClassicDraw(draw, lightmap, time)
  vertexIndex = 0
  while vertexIndex < len(draw.vertices)
    emitClassicVertex(draw, draw.vertices[vertexIndex], lightmap, time)
    vertexIndex = vertexIndex + 1
  end while
end function

// Report whether classic draw can cache.
function inline classicDrawCanCache(draw)
  flags = draw.surface.texInfo.flags
  return (flags & (ropenglformatconstants.SURF_WARP |
    ropenglformatconstants.SURF_FLOWING)) == 0
end function

// Prepare open gl classic draw.
function prepareOpenGlClassicDraw(draw, pass, lightmap)
  if not classicDrawCanCache(draw) then return false end if
  prepared = native.glStaticGeometryPrepare(nativeRawValue(draw), pass)
  if prepared < 0 then return false end if
  if prepared == 0 then
    native.glBegin(GL_TRIANGLES)
    emitClassicDraw(draw, lightmap, 0.0)
    native.glEnd()
  end if
  return true
end function

// Prepare open gl classic multitexture draw.
function prepareOpenGlClassicMultitextureDraw(draw)
  if not classicDrawCanCache(draw) then return false end if
  prepared = native.glStaticGeometryPrepare(nativeRawValue(draw), 2)
  if prepared < 0 then return false end if
  if prepared == 0 then
    // Pass 2 preserves the source polygon. The native cache triangulates it
    // once and retains both texture-coordinate sets for batched replay.
    native.glBegin(0x0009)
    for each vertex in draw.surface.vertices
      native.glMultiTexCoord2(0, bits(vertex.s), bits(vertex.t))
      native.glMultiTexCoord2(1, bits(vertex.lightS), bits(vertex.lightT))
      native.glVertex3(bits(vertex.position.x), bits(vertex.position.y),
        bits(vertex.position.z))
    end for
    native.glEnd()
  end if
  return true
end function

// Open precache gl classic geometry.
function precacheOpenGlClassicGeometry(world)
  preparedCount = 0
  for each draw in world.draws
    if prepareOpenGlClassicDraw(draw, 0, false) then
      preparedCount = preparedCount + 1
    end if
    if draw.surface.category == rclassicconstants.MATERIAL_OPAQUE and
        prepareOpenGlClassicDraw(draw, 1, true) then
      preparedCount = preparedCount + 1
    end if
    if draw.surface.category == rclassicconstants.MATERIAL_OPAQUE and
        native.glMultitextureAvailable() != 0 and
        prepareOpenGlClassicMultitextureDraw(draw) then
      preparedCount = preparedCount + 1
    end if
  end for
  return preparedCount
end function

// Write open gl batch u 32.
function inline writeOpenGlBatchU32(buffer, offset, value)
  buffer[offset] = value & 255
  buffer[offset + 1] = (value >> 8) & 255
  buffer[offset + 2] = (value >> 16) & 255
  buffer[offset + 3] = (value >> 24) & 255
end function

// Report whether open gl batch draws equal.
function inline openGlBatchDrawsEqual(first, second)
  if nativeRawValue(first) == nativeRawValue(second) then return true end if
  if len(first) != len(second) then return false end if
  index = 0
  while index < len(first)
    if first[index] != second[index] then return false end if
    index = index + 1
  end while
  return true
end function

// Write open gl multitexture record.
function inline writeOpenGlMultitextureRecord(buffer, index, draw, baseTextureId,
    lightmapTextureId)
  offset = index * 16
  key = nativeRawValue(draw)
  writeOpenGlBatchU32(buffer, offset, key & 0xffffffff)
  writeOpenGlBatchU32(buffer, offset + 4, (key >> 32) & 0xffffffff)
  writeOpenGlBatchU32(buffer, offset + 8, baseTextureId)
  writeOpenGlBatchU32(buffer, offset + 12, lightmapTextureId)
  return offset + 16
end function

// Submit open gl classic multitexture.
function submitOpenGlClassicMultitexture(binding, draws, time)
  // Keep submit open gl classic multitexture phases explicit: validate inputs, update owned state, then publish the result.
  if len(draws) == 0 or native.glMultitextureAvailable() == 0 then return [false, 0] end if
  required = len(draws) * 16
  if len(binding.state.batchRecords) < required then
    binding.state.batchRecords = bytes(required)
    binding.state.batchDraws = []
  end if
  uploaded = 0
  animationFrame = ropenglbyteio.truncInt(time * 2.0)
  batchHit = binding.state.batchAnimationFrame == animationFrame and
    openGlBatchDrawsEqual(binding.state.batchDraws, draws)
  if not batchHit then
    index = 0
    while index < len(draws)
      draw = draws[index]
      if not classicDrawCanCache(draw) then return [false, uploaded] end if
      baseTexture = rclassicspecial.classicSpecialBaseTexture(draw, time)
      if uploadClassicTexture(binding, baseTexture) then uploaded = uploaded + 1 end if
      if uploadClassicTexture(binding, draw.lightmapTexture) then uploaded = uploaded + 1 end if
      writeOpenGlMultitextureRecord(binding.state.batchRecords, index, draw,
        baseTexture.id, draw.lightmapTexture.id)
      index = index + 1
    end while
    binding.state.batchDraws = draws
    binding.state.batchAnimationFrame = animationFrame
  end if

  native.glActiveTexture(0)
  native.glEnable(GL_TEXTURE_2D)
  native.glTexEnvI(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE)
  native.glActiveTexture(1)
  native.glEnable(GL_TEXTURE_2D)
  native.glTexEnvI(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE)
  submitted = native.glStaticGeometryCallMultitextureBatch(
    binding.state.batchRecords, required)
  native.glDisable(GL_TEXTURE_2D)
  native.glActiveTexture(0)
  return [submitted == len(draws), uploaded]
end function

// Submit open gl classic draw.
function submitOpenGlClassicDraw(draw, lightmap, time)
  pass = 0
  if lightmap then pass = 1 end if
  if classicDrawCanCache(draw) and
      native.glStaticGeometryCall(nativeRawValue(draw), pass) != 0 then
    return true
  end if
  native.glBegin(GL_TRIANGLES)
  emitClassicDraw(draw, lightmap, time)
  native.glEnd()
  return false
end function

// Create open gl sky bounds.
function createOpenGlSkyBounds()
  return rclassictypes.ClassicSkyBounds(array(6, 9999.0),
    array(6, 9999.0), array(6, -9999.0), array(6, -9999.0))
end function

// Create one fixed-capacity sky vertex buffer.
function createOpenGlSkyVertexBuffer()
  result = array(66)
  index = 0
  while index < len(result)
    result[index] = ropenglqtypes.Vec3(0.0, 0.0, 0.0)
    index = index + 1
  end while
  return result
end function

// Lazily create the retained clipping workspace. Product registration calls
// this before gameplay whenever a map owns sky surfaces.
function ensureOpenGlSkyClipScratch()
  slot = openGlSkyScratchSlot
  if slot.scratch is not void then return slot.scratch end if
  distances = array(6); sides = array(6)
  frontBuffers = array(6); backBuffers = array(6)
  stage = 0
  while stage < 6
    distances[stage] = array(66, 0.0); sides[stage] = array(66, 0)
    frontBuffers[stage] = createOpenGlSkyVertexBuffer()
    backBuffers[stage] = createOpenGlSkyVertexBuffer()
    stage = stage + 1
  end while
  slot.scratch = OpenGlSkyClipScratch(createOpenGlSkyBounds(), distances,
    sides, frontBuffers, backBuffers, createOpenGlSkyVertexBuffer())
  return slot.scratch
end function

// Copy coordinates into one retained vertex object.
function inline setOpenGlSkyScratchVertex(buffer, index, x, y, z)
  target = buffer[index]
  target.x = x; target.y = y; target.z = z
  return target
end function

// Reset the persistent sky bounds for a new view.
function resetOpenGlSkyBounds(bounds)
  axis = 0
  while axis < 6
    bounds.minimumS[axis] = 9999.0; bounds.minimumT[axis] = 9999.0
    bounds.maximumS[axis] = -9999.0; bounds.maximumT[axis] = -9999.0
    axis = axis + 1
  end while
  return bounds
end function

// Open gl sky clip distance.
function openGlSkyClipDistance(value, stage)
  if stage == 0 then return value.x + value.y end if
  if stage == 1 then return value.x - value.y end if
  if stage == 2 then return -value.y + value.z end if
  if stage == 3 then return value.y + value.z end if
  if stage == 4 then return value.x + value.z end if
  return -value.x + value.z
end function

// Project open gl sky polygon.
function projectOpenGlSkyPolygon(bounds, vertices, count)
  // Keep project open gl sky polygon phases explicit: validate inputs, update owned state, then publish the result.
  sumX = 0.0; sumY = 0.0; sumZ = 0.0
  vertexIndex = 0
  while vertexIndex < count
    value = vertices[vertexIndex]
    sumX = sumX + value.x; sumY = sumY + value.y; sumZ = sumZ + value.z
    vertexIndex = vertexIndex + 1
  end while
  absoluteX = rmath.abs(sumX); absoluteY = rmath.abs(sumY)
  absoluteZ = rmath.abs(sumZ)
  axis = 4
  if absoluteX > absoluteY and absoluteX > absoluteZ then
    axis = 0; if sumX < 0.0 then axis = 1 end if
  else if absoluteY > absoluteZ and absoluteY > absoluteX then
    axis = 2; if sumY < 0.0 then axis = 3 end if
  else if sumZ < 0.0 then axis = 5 end if

  vertexIndex = 0
  while vertexIndex < count
    value = vertices[vertexIndex]
    divisor = value.x; s = -value.y; t = value.z
    if axis == 1 then divisor = -value.x; s = value.y; t = value.z
    else if axis == 2 then divisor = value.y; s = value.x; t = value.z
    else if axis == 3 then divisor = -value.y; s = -value.x; t = value.z
    else if axis == 4 then divisor = value.z; s = -value.y; t = -value.x
    else if axis == 5 then divisor = -value.z; s = -value.y; t = value.x
    end if
    if divisor >= 0.001 then
      s = s / divisor; t = t / divisor
      if s < bounds.minimumS[axis] then bounds.minimumS[axis] = s end if
      if t < bounds.minimumT[axis] then bounds.minimumT[axis] = t end if
      if s > bounds.maximumS[axis] then bounds.maximumS[axis] = s end if
      if t > bounds.maximumT[axis] then bounds.maximumT[axis] = t end if
    end if
    vertexIndex = vertexIndex + 1
  end while
  return true
end function

// Exact managed port of ref_gl's six-plane ClipSkyPolygon. Sky surfaces are
// already triangle lists, so even the worst split remains well below 64 verts.
function clipOpenGlSkyPolygonScratch(bounds, vertices, count, stage, scratch)
  // Keep clip open gl sky polygon phases explicit: validate inputs, update owned state, then publish the result.
  if count < 3 then return false end if
  if stage == 6 then return projectOpenGlSkyPolygon(bounds, vertices, count) end if
  distances = scratch.distances[stage]; sides = scratch.sides[stage]
  front = false; back = false
  vertexIndex = 0
  while vertexIndex < count
    distance = openGlSkyClipDistance(vertices[vertexIndex], stage)
    distances[vertexIndex] = distance
    if distance > 0.1 then sides[vertexIndex] = 1; front = true
    else if distance < -0.1 then sides[vertexIndex] = -1; back = true end if
    vertexIndex = vertexIndex + 1
  end while
  if not front or not back then
    return clipOpenGlSkyPolygonScratch(bounds, vertices, count, stage + 1,
      scratch)
  end if

  frontVertices = scratch.frontBuffers[stage]
  backVertices = scratch.backBuffers[stage]
  frontCount = 0; backCount = 0
  vertexIndex = 0
  while vertexIndex < count
    nextIndex = vertexIndex + 1
    if nextIndex == count then nextIndex = 0 end if
    value = vertices[vertexIndex]
    side = sides[vertexIndex]
    if side >= 0 then
      setOpenGlSkyScratchVertex(frontVertices, frontCount, value.x, value.y,
        value.z); frontCount = frontCount + 1
    end if
    if side <= 0 then
      setOpenGlSkyScratchVertex(backVertices, backCount, value.x, value.y,
        value.z); backCount = backCount + 1
    end if
    nextSide = sides[nextIndex]
    if side != 0 and nextSide != 0 and nextSide != side then
      fraction = distances[vertexIndex] /
        (distances[vertexIndex] - distances[nextIndex])
      nextValue = vertices[nextIndex]
      intersectionX = value.x + fraction * (nextValue.x - value.x)
      intersectionY = value.y + fraction * (nextValue.y - value.y)
      intersectionZ = value.z + fraction * (nextValue.z - value.z)
      setOpenGlSkyScratchVertex(frontVertices, frontCount, intersectionX,
        intersectionY, intersectionZ); frontCount = frontCount + 1
      setOpenGlSkyScratchVertex(backVertices, backCount, intersectionX,
        intersectionY, intersectionZ); backCount = backCount + 1
    end if
    vertexIndex = vertexIndex + 1
  end while
  clipOpenGlSkyPolygonScratch(bounds, frontVertices, frontCount, stage + 1,
    scratch)
  clipOpenGlSkyPolygonScratch(bounds, backVertices, backCount, stage + 1,
    scratch)
  return true
end function

// Compatibility wrapper used by focused geometry tests.
function clipOpenGlSkyPolygon(bounds, vertices, count, stage)
  return clipOpenGlSkyPolygonScratch(bounds, vertices, count, stage,
    ensureOpenGlSkyClipScratch())
end function

// Open gl sky bounds.
function openGlSkyBounds(draws, viewOrigin)
  scratch = ensureOpenGlSkyClipScratch()
  bounds = resetOpenGlSkyBounds(scratch.bounds)
  for each draw in draws
    count = len(draw.surface.vertices)
    if count > 66 then return error(9639,
      "sky portal exceeds ClipSkyPolygon vertex capacity") end if
    translated = scratch.translated
    vertexIndex = 0
    while vertexIndex < count
      position = draw.surface.vertices[vertexIndex].position
      setOpenGlSkyScratchVertex(translated, vertexIndex,
        position.x - viewOrigin.x, position.y - viewOrigin.y,
        position.z - viewOrigin.z)
      vertexIndex = vertexIndex + 1
    end while
    clipOpenGlSkyPolygonScratch(bounds, translated, count, 0, scratch)
  end for
  return bounds
end function

// Emit open gl sky vertex.
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

// Draw open gl sky box.
function drawOpenGlSkyBox(binding, world, frame, draws)
  // Keep draw open gl sky box phases explicit: validate inputs, update owned state, then publish the result.
  if not world.skyBox.active then return 0 end if
  textureOrder = [0, 2, 1, 3, 4, 5]
  bounds = openGlSkyBounds(draws, frame.viewOrigin)
  uploaded = 0
  native.glPushMatrix()
  native.glTranslate(bits(frame.viewOrigin.x), bits(frame.viewOrigin.y), bits(frame.viewOrigin.z))
  if world.skyBox.rotate != 0.0 then
    native.glRotate(bits(frame.time * world.skyBox.rotate), bits(world.skyBox.axis.x), bits(world.skyBox.axis.y), bits(world.skyBox.axis.z))
  end if
  axis = 0
  while axis < 6
    minimumS = bounds.minimumS[axis]; minimumT = bounds.minimumT[axis]
    maximumS = bounds.maximumS[axis]; maximumT = bounds.maximumT[axis]
    if world.skyBox.rotate != 0.0 then
      minimumS = -1.0; minimumT = -1.0; maximumS = 1.0; maximumT = 1.0
    end if
    if minimumS >= maximumS or minimumT >= maximumT then
      axis = axis + 1
      continue
    end if
    if minimumS < -1.0 then minimumS = -1.0 end if
    if minimumT < -1.0 then minimumT = -1.0 end if
    if maximumS > 1.0 then maximumS = 1.0 end if
    if maximumT > 1.0 then maximumT = 1.0 end if
    texture = world.skyBox.textures[textureOrder[axis]]
    if uploadClassicTexture(binding, texture) then uploaded = uploaded + 1 end if
    native.glBindTexture(GL_TEXTURE_2D, texture.id)
    native.glBegin(GL_QUADS)
    emitOpenGlSkyVertex(minimumS, minimumT, axis, texture)
    emitOpenGlSkyVertex(minimumS, maximumT, axis, texture)
    emitOpenGlSkyVertex(maximumS, maximumT, axis, texture)
    emitOpenGlSkyVertex(maximumS, minimumT, axis, texture)
    native.glEnd()
    axis = axis + 1
  end while
  native.glPopMatrix()
  return uploaded
end function

// Return the classic inline model index.
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

// Return the classic brush distance squared value.
function inline classicBrushDistanceSquared(submission, viewOrigin)
  origin = submission.entity.origin
  deltaX = origin.x - viewOrigin.x; deltaY = origin.y - viewOrigin.y; deltaZ = origin.z - viewOrigin.z
  return deltaX * deltaX + deltaY * deltaY + deltaZ * deltaZ
end function

// Sort classic brush submissions.
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

// Sort classic brush submission prefix.
function sortClassicBrushSubmissionPrefix(submissions, count, viewOrigin)
  index = 1
  while index < count
    candidate = submissions[index]
    distance = classicBrushDistanceSquared(candidate, viewOrigin)
    insert = index
    while insert > 0 and distance >
        classicBrushDistanceSquared(submissions[insert - 1], viewOrigin)
      submissions[insert] = submissions[insert - 1]
      insert = insert - 1
    end while
    submissions[insert] = candidate
    index = index + 1
  end while
  return submissions
end function

// Return the classic brush local lights value.
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

// Rebuild one lightmap only when a style changed, a dynamic light affects the
// plane, or last frame's dynamic contribution must be removed.
function classicDynamicLightmapForDraw(world, draw, lightStyles, dLights)
  surface = draw.surface
  previousBits = surface.dlightBits
  currentBits = rclassiclightmaps.markDynamicLights(surface, dLights)
  dirty = previousBits != 0 or currentBits != 0 or
    rclassiclightmaps.lightStylesChanged(surface, lightStyles)
  if not dirty then
    return rclassictypes.ClassicBrushLightmap(draw, surface.lightmap, false)
  end if
  rgbaPixels = rclassiclightmaps.buildLightmap(surface, lightStyles, dLights,
    world.modulate)
  rclassiclightmaps.setCacheState(surface, lightStyles)
  return rclassictypes.ClassicBrushLightmap(draw, rgbaPixels, true)
end function

// Return the classic brush dynamic lightmaps value.
function classicBrushDynamicLightmaps(world, entity, plan, frame)
  localLights = []
  if frame.numDLights > 0 then localLights = classicBrushLocalLights(entity, frame) end if
  lightmaps = array(len(plan.opaqueDraws))
  dirtyCount = 0
  drawIndex = 0
  while drawIndex < len(plan.opaqueDraws)
    draw = plan.opaqueDraws[drawIndex]
    lightmap = classicDynamicLightmapForDraw(world, draw, frame.lightStyles,
      localLights)
    if lightmap.dirty then dirtyCount = dirtyCount + 1 end if
    lightmaps[drawIndex] = lightmap
    drawIndex = drawIndex + 1
  end while
  return [lightmaps, dirtyCount]
end function

// Product-graph-facing CPU plan. It consumes the same model handles emitted by
// client asset registration, but never reparses or expands the adopted BSP.
function prepareClassicBrushFrame(binding, world, frame)
  // Keep prepare classic brush frame phases explicit: validate inputs, update owned state, then publish the result.
  submissions = array(frame.numEntities)
  submissionCount = 0
  culledEntities = 0; surfaces = 0; triangles = 0; dirtyLightmaps = 0
  brushFrustum = void
  entityIndex = 0
  while entityIndex < frame.numEntities
    entity = frame.entities[entityIndex]
    modelAsset = rassets.findModelByHandle(binding.state.assets, entity.model)
    if modelAsset is not void and modelAsset.kind == "bsp-inline" then
      if modelAsset.source != world.map then return error(9635, "inline BSP entity belongs to a different ClassicWorld") end if
      modelIndex = modelAsset.modelIndex
      if modelIndex < 1 or modelIndex > len(world.brushModels) then
        return error(9636, "ClassicWorld has no prepared inline BSP model " + modelIndex)
      end if
      brushModel = world.brushModels[modelIndex - 1]
      if brushFrustum is void then
        brushFrustum = rclassicvisibility.classicVisibilityFrustum(frame)
      end if
      brushSelection = rclassicvisibility.selectClassicBrushModelPrepared(
        brushModel, entity, frame, brushFrustum)
      selectedDraws = brushSelection.draws
      selectedCount = brushSelection.count
      if selectedCount == 0 then
        culledEntities = culledEntities + 1
      else
        localView = brushSelection.localView
        brushPlan = rclassicspecial.classicSpecialPassPlanOriginPrefix(
          selectedDraws, selectedCount, localView)
        lightmapResult = classicBrushDynamicLightmaps(world, entity, brushPlan, frame)
        submissions[submissionCount] = rclassictypes.ClassicBrushSubmission(entity, brushModel, brushPlan, lightmapResult[0])
        submissionCount = submissionCount + 1
        dirtyLightmaps = dirtyLightmaps + lightmapResult[1]
        surfaces = surfaces + selectedCount
        selectedIndex = 0
        while selectedIndex < selectedCount
          triangles = triangles + selectedDraws[selectedIndex].triangleCount
          selectedIndex = selectedIndex + 1
        end while
      end if
    end if
    entityIndex = entityIndex + 1
  end while
  if submissionCount == 0 then return rclassictypes.ClassicBrushFramePlan(array(0), culledEntities, surfaces, triangles, dirtyLightmaps) end if
  sortClassicBrushSubmissionPrefix(submissions, submissionCount,
    frame.viewOrigin)
  exact = array(submissionCount)
  copyIndex = 0
  while copyIndex < submissionCount
    exact[copyIndex] = submissions[copyIndex]
    copyIndex = copyIndex + 1
  end while
  return rclassictypes.ClassicBrushFramePlan(exact, culledEntities, surfaces, triangles, dirtyLightmaps)
end function

// Return the classic brush frame signature value.
function classicBrushFrameSignature(brushFrame)
  result = len(brushFrame.submissions) + ":" + brushFrame.culledEntities + ":" + brushFrame.surfaces + ":" + brushFrame.triangles
  for each submission in brushFrame.submissions
    origin = submission.entity.origin
    result = result + ":*" + submission.brushModel.modelIndex + "@" + origin.x + "," + origin.y + "," + origin.z + "/" + rclassicspecial.classicSpecialPassSignature(submission.plan)
  end for
  return result
end function

// Draw open gl classic draws.
function drawOpenGlClassicDraws(binding, draws, time, lightmap, entityFrame)
  uploaded = 0
  lastTexture = -1
  for each draw in draws
    texture = rclassicspecial.classicSpecialBaseTextureFrame(draw, entityFrame)
    if lightmap then texture = draw.lightmapTexture end if
    if uploadClassicTexture(binding, texture) then uploaded = uploaded + 1 end if
    textureId = texture.id
    if lastTexture != textureId then
      native.glBindTexture(GL_TEXTURE_2D, textureId)
      lastTexture = textureId
    end if
    submitOpenGlClassicDraw(draw, lightmap, time)
  end for
  return uploaded
end function

// Return the upload classic brush lightmap value.
function uploadClassicBrushLightmap(binding, brushLightmap)
  texture = brushLightmap.draw.lightmapTexture
  rgbaPixels = brushLightmap.rgbaPixels
  if not brushLightmap.dirty then return false end if
  // Atlas objects remain resident. Update only this surface's rectangle and
  // mirror it in the retained CPU payload for context-loss reconstruction.
  width = brushLightmap.draw.surface.lightWidth
  height = brushLightmap.draw.surface.lightHeight
  x = brushLightmap.draw.lightmapX; y = brushLightmap.draw.lightmapY
  row = 0
  while row < height
    copyBytes(texture.rgbaPixels, ((y + row) * texture.width + x) * 4,
      rgbaPixels, row * width * 4, width * 4)
    row = row + 1
  end while
  uploadClassicTexture(binding, texture)
  native.glBindTexture(GL_TEXTURE_2D, texture.id)
  native.glTexSubImage2D(GL_TEXTURE_2D, 0, x, y, width, height, GL_RGBA,
    GL_UNSIGNED_BYTE, rgbaPixels)
  return true
end function

// Refresh visible world lightmap rectangles before their opaque base/lightmap
// pass. Dynamic lights are already in world space, unlike inline brush lights.
function updateClassicWorldLightmaps(binding, world, draws, frame)
  uploaded = 0
  for each draw in draws
    lightmap = classicDynamicLightmapForDraw(world, draw, frame.lightStyles,
      frame.dLights)
    if uploadClassicBrushLightmap(binding, lightmap) then
      uploaded = uploaded + 1
    end if
  end for
  return uploaded
end function

// Draw open gl classic brush lightmaps.
function drawOpenGlClassicBrushLightmaps(binding, submission, time)
  uploaded = 0
  lastTexture = -1
  for each brushLightmap in submission.dynamicLightmaps
    if uploadClassicBrushLightmap(binding, brushLightmap) then uploaded = uploaded + 1 end if
    textureId = brushLightmap.draw.lightmapTexture.id
    if lastTexture != textureId then native.glBindTexture(GL_TEXTURE_2D, textureId); lastTexture = textureId end if
    submitOpenGlClassicDraw(brushLightmap.draw, true, time)
  end for
  return uploaded
end function

// Open push gl classic brush.
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

// Draw open gl classic brush opaque.
function drawOpenGlClassicBrushOpaque(binding, submission, frame)
  entityFlags = submission.entity.flags
  if (entityFlags & rc.RF_TRANSLUCENT) != 0 then return 0 end if
  plan = submission.plan
  pushOpenGlClassicBrush(submission.entity)
  native.glColor4ub(255, 255, 255, 255)
  native.glDisable(GL_BLEND)
  native.glDepthFunc(GL_LEQUAL)
  native.glDepthMask(1)
  entityFrame = submission.entity.frame
  uploaded = drawOpenGlClassicDraws(binding, plan.opaqueDraws, frame.time, false,
    entityFrame)
  native.glEnable(GL_BLEND)
  native.glBlendFunc(GL_ZERO, GL_SRC_COLOR)
  native.glDepthFunc(GL_EQUAL)
  native.glDepthMask(0)
  uploaded = uploaded + drawOpenGlClassicBrushLightmaps(binding, submission, frame.time)
  native.glDepthMask(1)
  native.glDepthFunc(GL_LEQUAL)
  native.glDisable(GL_BLEND)
  native.glColor4ub(128, 128, 128, 255)
  uploaded = uploaded + drawOpenGlClassicDraws(binding, plan.warpDraws,
    frame.time, false, entityFrame)
  native.glColor4ub(255, 255, 255, 255)
  uploaded = uploaded + drawOpenGlClassicDraws(binding, plan.skyDraws,
    frame.time, false, entityFrame)
  native.glPopMatrix()
  return uploaded
end function

// Return the classic transparent distance value.
function inline classicTransparentDistance(draw, entity, viewOrigin)
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

// Append classic transparent draws.
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

// Sort classic transparent draws.
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

// Sort classic transparent draws in place.
function sortClassicTransparentDrawsInPlace(draws, count)
  index = 1
  while index < count
    candidate = draws[index]
    insert = index
    while insert > 0 and candidate.distanceSquared >
        draws[insert - 1].distanceSquared
      draws[insert] = draws[insert - 1]
      insert = insert - 1
    end while
    draws[insert] = candidate
    index = index + 1
  end while
  return draws
end function

// Prepare classic transparent frame.
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
  count = 0
  // Brush alpha faces are linked at the global alpha-chain head while entities
  // are drawn. Reverse entity traversal reproduces that head-insertion order;
  // the world chain follows behind them.
  submissionIndex = len(brushFrame.submissions) - 1
  while submissionIndex >= 0
    submission = brushFrame.submissions[submissionIndex]
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
    submissionIndex = submissionIndex - 1
  end while
  count = appendClassicTransparentDraws(output, count,
    worldPlan.transparentDraws, void, 1.0, true, frame.viewOrigin)
  return output
end function

// Return the classic transparent frame signature value.
function classicTransparentFrameSignature(draws)
  result = ""
  for each transparentDraw in draws
    owner = "w"
    if transparentDraw.entity is not void then owner = "b" end if
    result = result + owner + transparentDraw.draw.surface.index + "@" + transparentDraw.alpha + ","
  end for
  return result
end function

// Draw open gl classic transparent frame.
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
    if entity is not void then
      texture = rclassicspecial.classicSpecialBaseTextureFrame(draw,
        entity.frame)
    end if
    if uploadClassicTexture(binding, texture) then uploaded = uploaded + 1 end if
    textureId = texture.id
    if lastTexture != textureId then native.glBindTexture(GL_TEXTURE_2D, textureId); lastTexture = textureId end if
    alphaValue = transparentDraw.alpha
    if alphaValue < 0.0 then alphaValue = 0.0 end if
    if alphaValue > 1.0 then alphaValue = 1.0 end if
    native.glColor4ub(128, 128, 128, ropenglbyteio.truncInt(alphaValue * 255.0))
    submitOpenGlClassicDraw(draw, false, frame.time)
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
  selection = void
  if binding.state.contextActive then
    selection = rclassicvisibility.selectClassicWorldCached(world, frame)
  else
    selection = rclassicvisibility.selectClassicWorld(world, frame)
  end if
  visibleSurfaces = len(selection.draws)
  culledSurfaces = rclassicvisibility.classicVisibilityCulledCount(selection)
  plan = rclassicspecial.classicSpecialPassPlan(selection.draws, frame)
  plan.transparentDraws = rclassicvisibility.classicVisibilityStockAlphaDraws(
    world, plan.transparentDraws, frame.viewOrigin)
  // The pass signature is a deterministic diagnostics artifact. Building it
  // concatenates one string fragment per visible surface, so keep it out of
  // the product frame loop where it would repeatedly copy the whole prefix.
  passOrder = ""
  if not binding.state.contextActive then
    passOrder = rclassicspecial.classicSpecialPassSignature(plan)
  end if
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
  uploaded = uploaded + updateClassicWorldLightmaps(binding, world,
    plan.opaqueDraws, frame)
  multitexture = submitOpenGlClassicMultitexture(binding, plan.opaqueDraws,
    frame.time)
  usedMultitexture = multitexture[0]
  uploaded = uploaded + multitexture[1]
  if not usedMultitexture then
    lastTexture = -1
    for each draw in plan.opaqueDraws
      baseTexture = rclassicspecial.classicSpecialBaseTexture(draw, frame.time)
      if uploadClassicTexture(binding, baseTexture) then uploaded = uploaded + 1 end if
      if lastTexture != baseTexture.id then
        native.glBindTexture(GL_TEXTURE_2D, baseTexture.id)
        lastTexture = baseTexture.id
      end if
      submitOpenGlClassicDraw(draw, false, frame.time)
    end for

    // OpenGL 1.1 fallback for hardware without multitexture: destination base
    // colour is multiplied by the uploaded Quake II lightmap colour.
    native.glEnable(GL_BLEND)
    native.glBlendFunc(GL_ZERO, GL_SRC_COLOR)
    native.glDepthFunc(GL_EQUAL)
    native.glDepthMask(0)
    for each draw in plan.opaqueDraws
      if uploadClassicTexture(binding, draw.lightmapTexture) then uploaded = uploaded + 1 end if
      native.glBindTexture(GL_TEXTURE_2D, draw.lightmapTexture.id)
      submitOpenGlClassicDraw(draw, true, frame.time)
    end for
    native.glDepthMask(1)
    native.glDepthFunc(GL_LEQUAL)
    native.glDisable(GL_BLEND)
  end if

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
    submitOpenGlClassicDraw(draw, false, frame.time)
  end for
  native.glColor4ub(255, 255, 255, 255)

  // Visible sky portals gate one six-face environment cube. PCX sky images
  // follow ref_gl's rt/bk/lf/ft/up/dn naming and skytexorder. Missing optional
  // environments retain the deterministic fullbright portal-WAL fallback.
  if len(plan.skyDraws) > 0 and world.skyBox.active then
    uploaded = uploaded + drawOpenGlSkyBox(binding, world, frame, plan.skyDraws)
  else
    lastTexture = -1
    for each draw in plan.skyDraws
      baseTexture = rclassicspecial.classicSpecialBaseTexture(draw, frame.time)
      if uploadClassicTexture(binding, baseTexture) then uploaded = uploaded + 1 end if
      if lastTexture != baseTexture.id then
        native.glBindTexture(GL_TEXTURE_2D, baseTexture.id)
        lastTexture = baseTexture.id
      end if
      submitOpenGlClassicDraw(draw, false, frame.time)
    end for
  end if

  // Inline BSP entities share the world's textures/lightmaps but own a model
  // transform and brush-local backface decision. Their opaque passes precede
  // every translucent brush pass.
  for each brushSubmission in brushFrame.submissions
    uploaded = uploaded + drawOpenGlClassicBrushOpaque(binding, brushSubmission, frame)
  end for

  // Retain stock's tail pass for RenderFrame: aliases and particles must be in
  // the colour buffer before water, glass and translucent brush polygons blend
  // over them. The pending slot also lets shadows consume this frame's light
  // spot instead of the previous frame's value.
  pending = openGlPendingClassicPasses
  pending.binding = binding; pending.transparentDraws = transparentFrame
  pending.frame = frame; pending.active = true; pending.stats = void

  triangles = 0
  for each draw in selection.draws
    triangles = triangles + draw.triangleCount
  end for
  vertices = triangles * 3
  lightmapVertices = 0
  for each draw in plan.opaqueDraws lightmapVertices = lightmapVertices + draw.triangleCount * 3 end for
  stats = rclassictypes.ClassicSubmitStats(
    visibleSurfaces, triangles, vertices, lightmapVertices, uploaded,
    visibleSurfaces, culledSurfaces, selection.viewLeaf, selection.viewCluster,
    opaqueSurfaces, warpSurfaces, skySurfaces, transparentSurfaces, passOrder,
    brushEntities, brushFrame.surfaces, brushFrame.triangles, brushFrame.culledEntities,
    brushFrame.dirtyLightmaps, len(transparentFrame)
  )
  pending.stats = stats
  return stats
end function

// Release classic world.
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
  if binding.state.activeWorld == world then binding.state.activeWorld = void end if
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

// Return the backend description value.
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

// Map adopt classic model.
function adoptClassicMapModel(binding, map, path)
  return rassets.adoptBspModel(binding.state.assets, map, path).handle
end function

// Return the md 2 model frame bounds.
function md2ModelFrameBounds(binding, modelHandle, frameIndex)
  modelAsset = rassets.modelForHandle(binding.state.assets, modelHandle)
  if modelAsset.kind != "md2" then return error(9630, "model bounds requested for non-MD2 handle") end if
  if frameIndex < 0 or frameIndex >= len(modelAsset.frameBounds) then return error(9631, "MD2 model bounds frame outside table") end if
  return modelAsset.frameBounds[frameIndex]
end function

// Prepare md 2 entity.
function prepareMd2Entity(binding, entity)
  return prepareOpenGlMd2Entity(binding.state, entity)
end function

// Explicit handoff for tools. Product RefDef entities are submitted
// automatically by RenderFrame when entity.model is a current MD2 handle.
function submitMd2Entity(binding, entity)
  plan = prepareOpenGlMd2Entity(binding.state, entity)
  if not openGlMd2EntityVisible(binding.state, entity) then
    return Md2SubmitStats(false, 0, 0, 0, plan.bounds)
  end if
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
