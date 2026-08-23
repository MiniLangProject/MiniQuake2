/* Managed BSP38 and MD2 geometry expansion for the OpenGL backend. */
package miniquake2.renderer.geometry

import std.math as rgeometrymath
import miniquake2.format.types as ft

struct MeshVertex
  position
  s
  t
end struct

struct TriangleMesh
  name
  vertices
  triangleCount
end struct

struct MeshBounds
  mins
  maxs
  radius
end struct

function meshVertex(position, s, t)
  copiedPosition = ft.Vec3(position.x, position.y, position.z)
  return MeshVertex(copiedPosition, s, t)
end function

function faceVertex(map, face, edgeOffset)
  surfaceEdgeIndex = face.firstEdge + edgeOffset
  if surfaceEdgeIndex < 0 or surfaceEdgeIndex >= len(map.surfaceEdges) then return error(9630, "BSP face surface-edge range outside table") end if
  surfaceEdge = map.surfaceEdges[surfaceEdgeIndex]
  edgeIndex = surfaceEdge
  if edgeIndex < 0 then edgeIndex = -edgeIndex end if
  if edgeIndex < 0 or edgeIndex >= len(map.edges) then return error(9631, "BSP edge index outside table") end if
  edge = map.edges[edgeIndex]
  vertexIndex = edge.vertex0
  if surfaceEdge < 0 then vertexIndex = edge.vertex1 end if
  if vertexIndex < 0 or vertexIndex >= len(map.vertices) then return error(9632, "BSP vertex index outside table") end if
  position = map.vertices[vertexIndex].position
  texInfo = map.texInfo[face.texInfo]
  s = position.x * texInfo.s[0] + position.y * texInfo.s[1] + position.z * texInfo.s[2] + texInfo.s[3]
  t = position.x * texInfo.t[0] + position.y * texInfo.t[1] + position.z * texInfo.t[2] + texInfo.t[3]
  return meshVertex(position, s, t)
end function

function bspModelMesh(map, modelIndex)
  if modelIndex < 0 or modelIndex >= len(map.models) then return error(9633, "BSP model index outside table") end if
  model = map.models[modelIndex]
  // BSP worlds contain tens of thousands of expanded fan vertices. Repeated
  // array concatenation makes that expansion quadratic and can exhaust the
  // managed heap before the first frame. Count once and fill one exact array.
  triangleCount = 0
  faceIndex = 0
  while faceIndex < model.numFaces
    tableIndex = model.firstFace + faceIndex
    if tableIndex < 0 or tableIndex >= len(map.faces) then return error(9634, "BSP model face range outside table") end if
    face = map.faces[tableIndex]
    if face.texInfo < 0 or face.texInfo >= len(map.texInfo) then return error(9635, "BSP face texinfo outside table") end if
    if face.numEdges >= 3 then triangleCount = triangleCount + face.numEdges - 2 end if
    faceIndex = faceIndex + 1
  end while

  vertices = array(triangleCount * 3)
  vertexIndex = 0
  faceIndex = 0
  while faceIndex < model.numFaces
    face = map.faces[model.firstFace + faceIndex]
    if face.numEdges >= 3 then
      first = faceVertex(map, face, 0)
      previous = faceVertex(map, face, 1)
      edgeOffset = 2
      while edgeOffset < face.numEdges
        current = faceVertex(map, face, edgeOffset)
        vertices[vertexIndex] = first
        vertices[vertexIndex + 1] = previous
        vertices[vertexIndex + 2] = current
        vertexIndex = vertexIndex + 3
        previous = current
        edgeOffset = edgeOffset + 1
      end while
    end if
    faceIndex = faceIndex + 1
  end while
  return TriangleMesh(map.name + "#" + modelIndex, vertices, triangleCount)
end function

function md2Position(frame, vertexIndex)
  if vertexIndex < 0 or vertexIndex >= len(frame.vertices) then return error(9636, "MD2 vertex outside frame") end if
  packed = frame.vertices[vertexIndex]
  return ft.Vec3(
    packed.x * frame.scale.x + frame.translate.x,
    packed.y * frame.scale.y + frame.translate.y,
    packed.z * frame.scale.z + frame.translate.z,
  )
end function

function interpolate(first, second, backLerp)
  frontLerp = 1.0 - backLerp
  return ft.Vec3(
    first.x * frontLerp + second.x * backLerp,
    first.y * frontLerp + second.y * backLerp,
    first.z * frontLerp + second.z * backLerp,
  )
end function

function md2FrameBounds(model, frameIndex, oldFrameIndex, backLerp)
  if frameIndex < 0 or frameIndex >= len(model.frames) or oldFrameIndex < 0 or oldFrameIndex >= len(model.frames) then
    return error(9640, "MD2 bounds frame outside table")
  end if
  if backLerp < 0.0 or backLerp > 1.0 then return error(9641, "MD2 bounds backlerp outside [0,1]") end if
  currentFrame = model.frames[frameIndex]
  oldFrame = model.frames[oldFrameIndex]
  if len(currentFrame.vertices) == 0 or len(currentFrame.vertices) != len(oldFrame.vertices) then return error(9642, "MD2 bounds require matching non-empty frames") end if
  firstCurrent = md2Position(currentFrame, 0)
  firstPrevious = md2Position(oldFrame, 0)
  first = interpolate(firstCurrent, firstPrevious, backLerp)
  minX = first.x; minY = first.y; minZ = first.z
  maxX = first.x; maxY = first.y; maxZ = first.z
  radiusSquared = first.x * first.x + first.y * first.y + first.z * first.z
  vertexIndex = 1
  while vertexIndex < len(currentFrame.vertices)
    position = interpolate(md2Position(currentFrame, vertexIndex), md2Position(oldFrame, vertexIndex), backLerp)
    if position.x < minX then minX = position.x end if
    if position.y < minY then minY = position.y end if
    if position.z < minZ then minZ = position.z end if
    if position.x > maxX then maxX = position.x end if
    if position.y > maxY then maxY = position.y end if
    if position.z > maxZ then maxZ = position.z end if
    distanceSquared = position.x * position.x + position.y * position.y + position.z * position.z
    if distanceSquared > radiusSquared then radiusSquared = distanceSquared end if
    vertexIndex = vertexIndex + 1
  end while
  mins = ft.Vec3(minX, minY, minZ)
  maxs = ft.Vec3(maxX, maxY, maxZ)
  radius = rgeometrymath.sqrt(radiusSquared)
  return MeshBounds(mins, maxs, radius)
end function

function md2FrameMesh(model, frameIndex, oldFrameIndex, backLerp)
  if frameIndex < 0 or frameIndex >= len(model.frames) or oldFrameIndex < 0 or oldFrameIndex >= len(model.frames) then
    return error(9637, "MD2 animation frame outside table")
  end if
  if backLerp < 0.0 or backLerp > 1.0 then return error(9638, "MD2 backlerp outside [0,1]") end if
  currentFrame = model.frames[frameIndex]
  oldFrame = model.frames[oldFrameIndex]
  vertices = array(len(model.triangles) * 3)
  outputIndex = 0
  triangleIndex = 0
  while triangleIndex < len(model.triangles)
    triangle = model.triangles[triangleIndex]
    corner = 0
    while corner < 3
      vertexIndex = triangle.xyz[corner]
      texCoordIndex = triangle.st[corner]
      if texCoordIndex < 0 or texCoordIndex >= len(model.texCoords) then return error(9639, "MD2 texcoord outside table") end if
      current = md2Position(currentFrame, vertexIndex)
      previous = md2Position(oldFrame, vertexIndex)
      texCoord = model.texCoords[texCoordIndex]
      s = texCoord.s / (model.skinWidth * 1.0)
      t = texCoord.t / (model.skinHeight * 1.0)
      position = interpolate(current, previous, backLerp)
      vertices[outputIndex] = meshVertex(position, s, t)
      outputIndex = outputIndex + 1
      corner = corner + 1
    end while
    triangleIndex = triangleIndex + 1
  end while
  return TriangleMesh(model.name + "#" + frameIndex, vertices, len(model.triangles))
end function

// Render-only MD2 expansion. The inspection API above intentionally retains
// MeshVertex structs; the live renderer needs only interleaved ST/XYZ scalars.
// Building those scalars directly avoids a full temporary object graph and a
// second traversal for every visible alias model on every frame.
function md2FrameScalars(model, frameIndex, oldFrameIndex, backLerp)
  if frameIndex < 0 or frameIndex >= len(model.frames) or oldFrameIndex < 0 or
      oldFrameIndex >= len(model.frames) then
    return error(9643, "MD2 scalar frame outside table")
  end if
  if backLerp < 0.0 or backLerp > 1.0 then
    return error(9644, "MD2 scalar backlerp outside [0,1]")
  end if
  currentFrame = model.frames[frameIndex]
  previousFrame = model.frames[oldFrameIndex]
  frontLerp = 1.0 - backLerp
  scalars = array(len(model.triangles) * 15, 0.0)
  scalarIndex = 0
  triangleIndex = 0
  while triangleIndex < len(model.triangles)
    triangle = model.triangles[triangleIndex]
    corner = 0
    while corner < 3
      vertexIndex = triangle.xyz[corner]
      texCoordIndex = triangle.st[corner]
      if vertexIndex < 0 or vertexIndex >= len(currentFrame.vertices) or
          vertexIndex >= len(previousFrame.vertices) then
        return error(9645, "MD2 scalar vertex outside frame")
      end if
      if texCoordIndex < 0 or texCoordIndex >= len(model.texCoords) then
        return error(9646, "MD2 scalar texcoord outside table")
      end if
      current = currentFrame.vertices[vertexIndex]
      previous = previousFrame.vertices[vertexIndex]
      texCoord = model.texCoords[texCoordIndex]
      scalars[scalarIndex] = texCoord.s / (model.skinWidth * 1.0)
      scalars[scalarIndex + 1] = texCoord.t / (model.skinHeight * 1.0)
      currentX = current.x * currentFrame.scale.x + currentFrame.translate.x
      currentY = current.y * currentFrame.scale.y + currentFrame.translate.y
      currentZ = current.z * currentFrame.scale.z + currentFrame.translate.z
      previousX = previous.x * previousFrame.scale.x + previousFrame.translate.x
      previousY = previous.y * previousFrame.scale.y + previousFrame.translate.y
      previousZ = previous.z * previousFrame.scale.z + previousFrame.translate.z
      scalars[scalarIndex + 2] = currentX * frontLerp + previousX * backLerp
      scalars[scalarIndex + 3] = currentY * frontLerp + previousY * backLerp
      scalars[scalarIndex + 4] = currentZ * frontLerp + previousZ * backLerp
      scalarIndex = scalarIndex + 5
      corner = corner + 1
    end while
    triangleIndex = triangleIndex + 1
  end while
  return scalars
end function
