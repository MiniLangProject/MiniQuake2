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
const GL_SRC_COLOR = 0x0300
const GL_SRC_ALPHA = 0x0302
const GL_ONE_MINUS_SRC_ALPHA = 0x0303
const GL_BLEND = 0x0BE2
const GL_ALPHA_TEST = 0x0BC0
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
  gamePalette
  particleTextureId
  rawTextureId
  rawPixels
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

struct OpenGlFrameSlot
  twoDimensional
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

struct Md2DrawState
  textureId
  translucent
  depthHack
  shell
end struct

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

struct OpenGlRawFrame
  rgba
  textureT
end struct

// Mutating a package-owned holder is reliable across the self-hosted full
// graph; rebinding a package global from a function is not.
openGlBackendSlot = OpenGlBackendSlot(void)
openGlFrameSlot = OpenGlFrameSlot(false)

function inline bits(value)
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

function inline openGlPaletteColor(palette, index)
  color = index & 255
  if typeof(palette) == "bytes" and len(palette) == 768 then
    return palette[color * 3] | (palette[color * 3 + 1] << 8) | (palette[color * 3 + 2] << 16)
  end if
  return (color & 0xE0) | (((color & 0x1C) << 3) << 8) | (((color & 0x03) << 6) << 16)
end function

function openGlLoadGamePalette(backend)
  if backend.imports is void then backend.gamePalette = bytes(0); return backend.gamePalette end if
  data = try(backend.imports.fsLoadFile("pics/colormap.pcx"))
  if data is error or typeof(data) != "bytes" then backend.gamePalette = bytes(0); return backend.gamePalette end if
  image = try(ropenglpcx.parse(data))
  if image is error or len(image.palette) != 768 then backend.gamePalette = bytes(0); return backend.gamePalette end if
  backend.gamePalette = image.palette
  return backend.gamePalette
end function

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

function openGlParticlePixels()
  mask = bytes([
    0,0,0,0,0,0,0,0,
    0,0,1,1,0,0,0,0,
    0,1,1,1,1,0,0,0,
    0,1,1,1,1,0,0,0,
    0,0,1,1,0,0,0,0,
    0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0])
  rgba = bytes(8 * 8 * 4)
  index = 0
  while index < 64
    rgba[index * 4] = 255; rgba[index * 4 + 1] = 255; rgba[index * 4 + 2] = 255
    rgba[index * 4 + 3] = mask[index] * 255
    index = index + 1
  end while
  return rgba
end function

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

function ensureOpenGlParticleTexture(backend)
  record = void
  if backend.particleTextureId != 0 then record = findTextureRecord(backend, backend.particleTextureId) end if
  if record is void or record.released then
    record = allocateTextureRecord(backend, "***particle***", "particle",
      backend.assets.generation, 8, 8)
    backend.particleTextureId = record.id
  end if
  if backend.contextActive and not record.uploaded then
    native.glBindTexture(GL_TEXTURE_2D, record.id)
    native.glTexParameterI(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
    native.glTexParameterI(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
    native.glTexParameterI(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP)
    native.glTexParameterI(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP)
    native.glTexImage2D(GL_TEXTURE_2D, 0, 4, 8, 8, 0, GL_RGBA,
      GL_UNSIGNED_BYTE, openGlParticlePixels())
    record.uploaded = true
  end if
  return record.id
end function

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

function drawOpenGlSpriteEntity(backend, modelAsset, entity, axes)
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
      native.glColor4ub(colorByte(packed, 0), colorByte(packed, 8), colorByte(packed, 16), alpha)
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
  native.glDepthMask(1)
  native.glDisable(GL_BLEND)
  native.glColor4ub(255, 255, 255, 255)
end function

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

function openGlMd2Shade(entity, time)
  flags = entity.flags
  red = 255; green = 255; blue = 255
  shellMask = rc.RF_SHELL_RED | rc.RF_SHELL_GREEN | rc.RF_SHELL_BLUE | rc.RF_SHELL_DOUBLE | rc.RF_SHELL_HALF_DAM
  if (flags & shellMask) != 0 then
    red = 0; green = 0; blue = 0
    if (flags & rc.RF_SHELL_RED) != 0 and (flags & rc.RF_SHELL_GREEN) != 0 and (flags & rc.RF_SHELL_BLUE) != 0 then
      red = 255; green = 255; blue = 255
    else if (flags & rc.RF_SHELL_RED) != 0 then
      red = 255
      if (flags & (rc.RF_SHELL_BLUE | rc.RF_SHELL_DOUBLE)) != 0 then blue = 255 end if
    else if (flags & rc.RF_SHELL_BLUE) != 0 then
      blue = 255
      if (flags & rc.RF_SHELL_DOUBLE) != 0 then green = 255 end if
    else if (flags & rc.RF_SHELL_DOUBLE) != 0 then
      red = 230; green = 179
    else
      if (flags & rc.RF_SHELL_HALF_DAM) != 0 then red = 143; green = 150; blue = 115 end if
      if (flags & rc.RF_SHELL_GREEN) != 0 then green = 255 end if
    end if
  else if (flags & rc.RF_GLOW) != 0 then
    pulse = 1.0 + 0.1 * rmath.sin(time * 7.0)
    if pulse < 0.8 then pulse = 0.8 end if
    red = ropenglbyteio.truncInt(red * pulse); green = ropenglbyteio.truncInt(green * pulse); blue = ropenglbyteio.truncInt(blue * pulse)
    if red > 255 then red = 255 end if
    if green > 255 then green = 255 end if
    if blue > 255 then blue = 255 end if
  end if
  return red | (green << 8) | (blue << 16)
end function

function beginOpenGlMd2Draw(backend, skinAsset, entity, time)
  entityFlags = entity.flags; entityAlpha = entity.alpha
  entityOrigin = entity.origin; entityAngles = entity.angles
  originX = entityOrigin.x; originY = entityOrigin.y; originZ = entityOrigin.z
  angleX = entityAngles.x; angleY = entityAngles.y; angleZ = entityAngles.z
  textureId = uploadPicture(backend, skinAsset)
  alpha = 255
  translucent = (entityFlags & rc.RF_TRANSLUCENT) != 0
  depthHack = (entityFlags & rc.RF_DEPTHHACK) != 0
  shell = (entityFlags & (rc.RF_SHELL_RED | rc.RF_SHELL_GREEN | rc.RF_SHELL_BLUE | rc.RF_SHELL_DOUBLE | rc.RF_SHELL_HALF_DAM)) != 0
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
  shade = openGlMd2Shade(entity, time)
  native.glColor4ub(colorByte(shade, 0), colorByte(shade, 8), colorByte(shade, 16), alpha)
  native.glPushMatrix()
  native.glTranslate(bits(originX), bits(originY), bits(originZ))
  native.glRotate(bits(angleY), bits(0.0), bits(0.0), bits(1.0))
  native.glRotate(bits(-angleX), bits(0.0), bits(1.0), bits(0.0))
  native.glRotate(bits(-angleZ), bits(1.0), bits(0.0), bits(0.0))
  return Md2DrawState(textureId, translucent, depthHack, shell)
end function

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

function endOpenGlMd2Draw(drawState)
  native.glPopMatrix()
  if drawState.depthHack then native.glDepthRange(bits(0.0), bits(1.0)) end if
  if drawState.shell then native.glEnable(GL_TEXTURE_2D) end if
  if drawState.translucent then
    native.glDepthMask(1)
    native.glDisable(GL_BLEND)
  end if
  native.glColor4ub(255, 255, 255, 255)
end function

function drawOpenGlMd2Scalars(backend, skinAsset, glVertices, triangleCount,
    vertexCount, resultBounds, entity, time)
  // Root every managed value before the first native call. The live path uses
  // one flat scalar array, avoiding the temporary MeshVertex object graph.
  drawState = beginOpenGlMd2Draw(backend, skinAsset, entity, time)
  native.glBegin(GL_TRIANGLES)
  emitOpenGlMd2Scalars(glVertices)
  native.glEnd()
  endOpenGlMd2Draw(drawState)
  return Md2SubmitStats(true, triangleCount, vertexCount,
    drawState.textureId, resultBounds)
end function

function drawOpenGlMd2Plan(backend, plan, entity)
  return drawOpenGlMd2Scalars(backend, plan.skinAsset, plan.glVertices,
    plan.mesh.triangleCount, len(plan.mesh.vertices), plan.bounds, entity, 0.0)
end function

function drawOpenGlMd2EntityFast(backend, modelAsset, entity, time)
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
  // Network snapshots arrive at 10 Hz. Eight sub-frame steps retain smooth
  // alias animation while making the same geometry reusable across render
  // frames instead of rebuilding and crossing the FFI per vertex every time.
  lerpBucket = ropenglbyteio.truncInt(entity.backLerp * 8.0 + 0.5)
  if lerpBucket < 0 then lerpBucket = 0 end if
  if lerpBucket > 8 then lerpBucket = 8 end if
  quantizedBackLerp = lerpBucket / 8.0
  shell = (entity.flags & (rc.RF_SHELL_RED | rc.RF_SHELL_GREEN |
    rc.RF_SHELL_BLUE | rc.RF_SHELL_DOUBLE | rc.RF_SHELL_HALF_DAM)) != 0
  cachePass = 2000 + (frameIndex * 512 + oldFrameIndex) * 9 + lerpBucket
  if shell then cachePass = cachePass + 10000000 end if
  drawState = beginOpenGlMd2Draw(backend, skinAsset, entity, time)
  if native.glStaticGeometryCall(nativeRawValue(modelAsset), cachePass) != 0 then
    endOpenGlMd2Draw(drawState)
    return Md2SubmitStats(true, triangleCount, triangleCount * 3,
      drawState.textureId, bounds)
  end if
  scalars = void
  if shell then
    scalars = rgeom.md2PowerShellFrameScalars(modelAsset.source, frameIndex,
      oldFrameIndex, quantizedBackLerp)
  else
    scalars = rgeom.md2FrameScalars(modelAsset.source, frameIndex,
      oldFrameIndex, quantizedBackLerp)
  end if
  native.glBegin(GL_TRIANGLES)
  emitOpenGlMd2Scalars(scalars)
  native.glEnd()
  endOpenGlMd2Draw(drawState)
  return Md2SubmitStats(true, triangleCount, triangleCount * 3,
    drawState.textureId, bounds)
end function

function submitOpenGlRefDefMd2Entities(backend, frame)
  submitted = 0
  entityIndex = 0
  while entityIndex < frame.numEntities
    entity = frame.entities[entityIndex]
    modelAsset = rassets.findModelByHandle(backend.assets, entity.model)
    if modelAsset is not void and modelAsset.kind == "md2" then
      drawOpenGlMd2EntityFast(backend, modelAsset, entity, frame.time)
      submitted = submitted + 1
    end if
    entityIndex = entityIndex + 1
  end while
  return submitted
end function

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
        if drawOpenGlBeam(backend, entity) then submitted = submitted + 1 end if
      else
        modelAsset = rassets.findModelByHandle(backend.assets, entity.model)
        if modelAsset is void then
          drawOpenGlNullEntity(entity); submitted = submitted + 1
        else if modelAsset.kind == "md2" then
          drawOpenGlMd2EntityFast(backend, modelAsset, entity, frame.time); submitted = submitted + 1
        else if modelAsset.kind == "sprite" then
          drawOpenGlSpriteEntity(backend, modelAsset, entity, axes); submitted = submitted + 1
        end if
        // Inline BSP entities are submitted with the world so they can share
        // its ordered opaque/lightmap/alpha passes.
      end if
    end if
    entityIndex = entityIndex + 1
  end while
  if translucentPass then native.glDepthMask(1) end if
  return submitted
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

function openGlSetSky(name, rotate, axis)
  backend = openGlBackendSlot.backend
  openGlRequireInitialized(backend, "SetSky")
  checked = validation.validateVec3(axis, "sky axis")
  if not checked.valid then return error(9603, checked.message) end if
  backend.core.state.skyName = name
  backend.core.state.skyRotate = rotate
  backend.core.state.skyAxis = axis
end function

function openGlEndRegistration()
  backend = openGlBackendSlot.backend
  openGlRequireInitialized(backend, "EndRegistration")
  backend.core.state.registrationOpen = false
end function

function openGlRenderFrame(frame)
  backend = openGlBackendSlot.backend
  openGlRequireInitialized(backend, "RenderFrame")
  // Headless contract mode retains the exhaustive API validator. Product
  // frames are constructed by the typed client handoff, so a constant-time
  // shape check avoids allocating hundreds of ValidationResult records for
  // the 256 light styles on every rendered frame.
  if backend.contextActive then
    if frame is void then return error(9604, "product refdef is void") end if
    if frame.width <= 0 or frame.height <= 0 or
        frame.numEntities != len(frame.entities) or
        frame.numDLights != len(frame.dLights) or
        frame.numParticles != len(frame.particles) or
        frame.numEntities < 0 or frame.numDLights < 0 or frame.numParticles < 0 or
        frame.numEntities > rc.MAX_ENTITIES or frame.numDLights > rc.MAX_DLIGHTS or
        frame.numParticles > rc.MAX_PARTICLES or
        len(frame.lightStyles) != rc.MAX_LIGHTSTYLES then
      return error(9604, "invalid product refdef shape")
    end if
  else
    checked = validation.validateRefDef(frame)
    if not checked.valid then return error(9604, checked.code + ": " + checked.message) end if
  end if
  backend.core.state.lastRefDef = frame
  backend.core.state.frameCount = backend.core.state.frameCount + 1
  if backend.contextActive then
    setup3d(frame)
    frameState = openGlFrameSlot
    frameState.twoDimensional = false
    native.glEnable(GL_DEPTH_TEST)
    native.glDepthFunc(GL_LEQUAL)
    native.glDepthMask(1)
    axes = openGlViewAxes(frame.viewAngles)
    drawOpenGlEntityPass(backend, frame, axes, false)
    drawOpenGlEntityPass(backend, frame, axes, true)
    drawParticles(backend, frame, axes)
    backend.submittedEntities = backend.submittedEntities + frame.numEntities
    backend.submittedParticles = backend.submittedParticles + frame.numParticles
  end if
  backend.submittedFrames = backend.submittedFrames + 1
end function

function openGlDrawGetPicSize(name)
  backend = openGlBackendSlot.backend
  openGlRequireInitialized(backend, "DrawGetPicSize")
  if backend.imports is void then return rt.PicSize(0, 0) end if
  asset = rassets.findPicture(backend.assets, name)
  if asset is void then asset = rassets.registerPicture(backend.assets, backend.imports, name) end if
  return rt.PicSize(asset.width, asset.height)
end function

function openGlDrawPic(x, y, name)
  backend = openGlBackendSlot.backend
  openGlRequireInitialized(backend, "DrawPic")
  if backend.contextActive and backend.imports is not void then
    asset = rassets.findPicture(backend.assets, name)
    if asset is void then asset = rassets.registerPicture(backend.assets, backend.imports, name) end if
    drawTexturedRect(backend, asset, x, y, asset.width, asset.height)
  end if
end function

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

function openGlDrawFill(x, y, width, height, color)
  backend = openGlBackendSlot.backend
  openGlRequireInitialized(backend, "DrawFill")
  if width < 0 or height < 0 then return error(9607, "DrawFill dimensions must not be negative") end if
  if color < 0 or color > 255 then return error(9608, "DrawFill palette index must be in [0,255]") end if
  if backend.contextActive then drawSolidRect(backend, x, y, width, height, color) end if
end function

function openGlDrawFadeScreen()
  backend = openGlBackendSlot.backend
  openGlRequireInitialized(backend, "DrawFadeScreen")
  if backend.contextActive then drawFadeRect() end if
end function

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

function openGlCinematicSetPalette(palette)
  backend = openGlBackendSlot.backend
  openGlRequireInitialized(backend, "CinematicSetPalette")
  if palette is not void and (typeof(palette) != "bytes" or len(palette) != 768) then
    return error(9611, "cinematic palette must contain 768 bytes or be void")
  end if
  backend.core.state.palette = palette
end function

function openGlBeginFrame(cameraSeparation)
  backend = openGlBackendSlot.backend
  openGlRequireInitialized(backend, "BeginFrame")
  if backend.core.state.frameOpen then return error(9612, "BeginFrame called twice") end if
  backend.core.state.frameOpen = true
  frameState = openGlFrameSlot
  frameState.twoDimensional = false
  if backend.contextActive then
    native.glClearColor(bits(0.0), bits(0.0), bits(0.0), bits(1.0))
    native.glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
  end if
end function

function openGlEndFrame()
  backend = openGlBackendSlot.backend
  openGlRequireInitialized(backend, "EndFrame")
  if not backend.core.state.frameOpen then return error(9613, "EndFrame called without BeginFrame") end if
  backend.core.state.frameOpen = false
  if backend.contextActive then
    native.glFlush()
    native.winSwap()
  end if
end function

function openGlAppActivate(activate)
  backend = openGlBackendSlot.backend
  openGlRequireInitialized(backend, "AppActivate")
  backend.core.state.appActive = activate
end function

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

function createOpenGlRenderer(contextActive)
  coreBinding = rt.RendererBinding(recording.createState("null", void), void)
  glState = OpenGlState(coreBinding, void, rassets.create(), contextActive, "", "", "", 0, 0, 0, 1, [], bytes(0), 0, 0, bytes(0))
  if typeof(glState) != "struct" then return error(9620, "OpenGL state constructor returned " + typeof(glState)) end if
  openGlFactorySlot = openGlBackendSlot
  openGlFactorySlot.backend = glState
  exports = openGlMakeExports()
  return rt.RendererBinding(glState, exports)
end function

function getRefAPI(imports, contextActive)
  checked = validation.validateRefImport(imports)
  if not checked.valid then return error(9614, checked.code + ": " + checked.message) end if
  coreBinding = rt.RendererBinding(recording.createState("null", imports), void)
  glState = OpenGlState(coreBinding, imports, rassets.create(), contextActive, "", "", "", 0, 0, 0, 1, [], bytes(0), 0, 0, bytes(0))
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
  if binding.state.contextActive then precacheOpenGlClassicGeometry(world) end if
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

function classicDrawCanCache(draw)
  flags = draw.surface.texInfo.flags
  return (flags & (ropenglformatconstants.SURF_WARP |
    ropenglformatconstants.SURF_FLOWING)) == 0
end function

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
  end for
  return preparedCount
end function

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
  if frame.numDLights == 0 then
    staticLightmaps = array(len(plan.opaqueDraws))
    staticIndex = 0
    while staticIndex < len(plan.opaqueDraws)
      staticDraw = plan.opaqueDraws[staticIndex]
      staticLightmaps[staticIndex] = rclassictypes.ClassicBrushLightmap(
        staticDraw, staticDraw.lightmapTexture.rgbaPixels, false)
      staticIndex = staticIndex + 1
    end while
    return [staticLightmaps, 0]
  end if
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
    submitOpenGlClassicDraw(draw, lightmap, time)
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
    submitOpenGlClassicDraw(brushLightmap.draw, true, time)
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

  // OpenGL 1.1 fallback for the absent multitexture bridge: destination base
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
      submitOpenGlClassicDraw(draw, false, frame.time)
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
