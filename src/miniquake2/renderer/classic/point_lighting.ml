/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Quake II ref_gl R_LightPoint without recursive MiniLang calls. */
package miniquake2.renderer.classic.point_lighting

import std.math as rpointmath
import miniquake2.format.constants as rpointfc
import miniquake2.qcommon.byteio as rpointbyteio
import miniquake2.renderer.classic.constants as rpointconstants
import miniquake2.renderer.classic.types as rpointtypes

// Return the point plane distance value.
function inline pointPlaneDistance(x, y, z, plane)
  if plane.type == 0 then return x - plane.distance end if
  if plane.type == 1 then return y - plane.distance end if
  if plane.type == 2 then return z - plane.distance end if
  normal = plane.normal
  return x * normal.x + y * normal.y + z * normal.z - plane.distance
end function

// Return the point projected value.
function inline pointProjected(x, y, z, vector)
  return x * vector[0] + y * vector[1] + z * vector[2] + vector[3]
end function

// Return the point style rgb value.
function inline pointStyleRgb(lightStyles, styleIndex)
  if styleIndex >= 0 and styleIndex < len(lightStyles) then
    return lightStyles[styleIndex].rgb
  end if
  return [1.0, 1.0, 1.0]
end function

// Construct the no-hit or fullbright sample without temporary vector records.
function inline emptyPointSample(red, green, blue)
  return rpointtypes.ClassicPointLight(
    red, green, blue, 0.0, 0.0, 0.0, false)
end function

// Iterative equivalent of ref_gl RecursiveLightPoint. Each crossing saves one
// post-node surface check and far segment. ClassicWorld owns the fixed stacks,
// so every alias-light query remains allocation-free until its result is returned.
function staticPointLightSample(world, lightStyles, origin)
  // Keep static point light sample phases explicit: validate inputs, update owned state, then publish the result.
  map = world.map
  if len(map.nodes) == 0 or len(map.models) == 0 then
    return emptyPointSample(0.0, 0.0, 0.0)
  end if

  nodeStack = world.pointNodeStack
  farChildStack = world.pointFarChildStack
  midXStack = world.pointMidXStack; midYStack = world.pointMidYStack
  midZStack = world.pointMidZStack; endXStack = world.pointEndXStack
  endYStack = world.pointEndYStack; endZStack = world.pointEndZStack
  stackCount = 0
  nodeNumber = map.models[0].headNode
  startX = origin.x; startY = origin.y; startZ = origin.z
  endX = startX; endY = startY; endZ = startZ - 2048.0
  guard = 0

  while true
    guard = guard + 1
    if guard > len(map.nodes) * 4 + 4 then
      return emptyPointSample(0.0, 0.0, 0.0)
    end if

    if nodeNumber >= 0 then
      if nodeNumber >= len(map.nodes) then
        return emptyPointSample(0.0, 0.0, 0.0)
      end if
      node = map.nodes[nodeNumber]
      if node.planeIndex < 0 or node.planeIndex >= len(map.planes) then
        return emptyPointSample(0.0, 0.0, 0.0)
      end if
      plane = map.planes[node.planeIndex]
      front = pointPlaneDistance(startX, startY, startZ, plane)
      back = pointPlaneDistance(endX, endY, endZ, plane)
      side = 0
      if front < 0.0 then side = 1 end if

      if (back < 0.0) == (side == 1) then
        if side == 0 then nodeNumber = node.child0
        else nodeNumber = node.child1
        end if
        continue
      end if

      fraction = front / (front - back)
      midX = startX + (endX - startX) * fraction
      midY = startY + (endY - startY) * fraction
      midZ = startZ + (endZ - startZ) * fraction
      if stackCount >= len(nodeStack) then
        return emptyPointSample(0.0, 0.0, 0.0)
      end if
      nodeStack[stackCount] = nodeNumber
      if side == 0 then
        nodeNumber = node.child0
        farChildStack[stackCount] = node.child1
      else
        nodeNumber = node.child1
        farChildStack[stackCount] = node.child0
      end if
      midXStack[stackCount] = midX; midYStack[stackCount] = midY
      midZStack[stackCount] = midZ; endXStack[stackCount] = endX
      endYStack[stackCount] = endY; endZStack[stackCount] = endZ
      stackCount = stackCount + 1
      endX = midX; endY = midY; endZ = midZ
      continue
    end if

    if stackCount == 0 then
      return emptyPointSample(0.0, 0.0, 0.0)
    end if
    stackCount = stackCount - 1
    postNode = map.nodes[nodeStack[stackCount]]
    midX = midXStack[stackCount]; midY = midYStack[stackCount]
    midZ = midZStack[stackCount]
    firstFace = postNode.firstFace
    faceEnd = firstFace + postNode.numFaces
    faceIndex = firstFace
    while faceIndex < faceEnd
      if faceIndex >= 0 and faceIndex < len(world.scene.surfaces) then
        surface = world.scene.surfaces[faceIndex]
        surfaceFlags = surface.texInfo.flags
        if (surfaceFlags & (rpointfc.SURF_WARP | rpointfc.SURF_SKY)) == 0 then
          textureS = rpointbyteio.truncInt(pointProjected(midX, midY, midZ,
            surface.texInfo.s))
          textureT = rpointbyteio.truncInt(pointProjected(midX, midY, midZ,
            surface.texInfo.t))
          if textureS >= surface.textureMins[0] and
              textureT >= surface.textureMins[1] then
            ds = textureS - surface.textureMins[0]
            dt = textureT - surface.textureMins[1]
            if ds <= surface.extents[0] and dt <= surface.extents[1] then
              if surface.samples is void then
                return rpointtypes.ClassicPointLight(
                  0.0, 0.0, 0.0, midX, midY, midZ, true)
              end if
              ds = ds >> 4; dt = dt >> 4
              sampleCount = surface.lightWidth * surface.lightHeight
              sampleOffset = 3 * (dt * surface.lightWidth + ds)
              red = 0.0; green = 0.0; blue = 0.0
              mapIndex = 0
              while mapIndex < rpointconstants.MAX_LIGHTMAPS and
                  mapIndex < len(surface.styles) and surface.styles[mapIndex] != 255
                rgb = pointStyleRgb(lightStyles, surface.styles[mapIndex])
                red = red + surface.samples[sampleOffset] * world.modulate * rgb[0] / 255.0
                green = green + surface.samples[sampleOffset + 1] * world.modulate * rgb[1] / 255.0
                blue = blue + surface.samples[sampleOffset + 2] * world.modulate * rgb[2] / 255.0
                sampleOffset = sampleOffset + sampleCount * 3
                mapIndex = mapIndex + 1
              end while
              return rpointtypes.ClassicPointLight(
                red, green, blue, midX, midY, midZ, true)
            end if
          end if
        end if
      end if
      faceIndex = faceIndex + 1
    end while

    nodeNumber = farChildStack[stackCount]
    startX = midX; startY = midY; startZ = midZ
    endX = endXStack[stackCount]; endY = endYStack[stackCount]
    endZ = endZStack[stackCount]
  end while
end function

// Return the static point light value.
function staticPointLight(world, lightStyles, origin)
  if world is void or world.released or world.map is void or
      len(world.map.lighting) == 0 then
    return emptyPointSample(1.0, 1.0, 1.0)
  end if
  return staticPointLightSample(world, lightStyles, origin)
end function

// Add the current frame's dynamic lights to a copied static sample. Keeping
// the immutable BSP result separate lets alias renderers cache the expensive
// point trace while muzzle flashes and projectiles still affect every frame.
function dynamicPointLightSample(world, frame, origin, staticSample)
  if world is void or world.released or world.map is void or
      len(world.map.lighting) == 0 then
    return emptyPointSample(1.0, 1.0, 1.0)
  end if
  color = rpointtypes.ClassicPointLight(staticSample.red, staticSample.green,
    staticSample.blue, staticSample.spotX, staticSample.spotY,
    staticSample.spotZ, staticSample.validSpot)

  lightIndex = 0
  while lightIndex < frame.numDLights
    light = frame.dLights[lightIndex]
    dx = origin.x - light.origin.x
    dy = origin.y - light.origin.y
    dz = origin.z - light.origin.z
    add = (light.intensity - rpointmath.sqrt(dx * dx + dy * dy + dz * dz)) / 256.0
    if add > 0.0 then
      color.red = color.red + add * light.color.x
      color.green = color.green + add * light.color.y
      color.blue = color.blue + add * light.color.z
    end if
    lightIndex = lightIndex + 1
  end while
  color.red = color.red * world.modulate
  color.green = color.green * world.modulate
  color.blue = color.blue * world.modulate
  return color
end function

// Sample point light.
function pointLightSample(world, frame, origin)
  staticSample = staticPointLight(world, frame.lightStyles, origin)
  return dynamicPointLightSample(world, frame, origin, staticSample)
end function

// Return the point light value.
function pointLight(world, frame, origin)
  return pointLightSample(world, frame, origin)
end function
