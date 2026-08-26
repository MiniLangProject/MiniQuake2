/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Quake II colored static lightmaps plus ref_gl-style dynamic light samples. */
package miniquake2.renderer.classic.lightmaps

import std.math as smath
import miniquake2.format.constants as fc
import miniquake2.qcommon.byteio as qbyteio
import miniquake2.renderer.classic.constants as rclassicconstants
import miniquake2.renderer.classic.surfaces as rclassicsurfaces
import miniquake2.renderer.classic.vector as rclassicvector

function styleRgb(lightStyles, styleIndex)
  if styleIndex >= 0 and styleIndex < len(lightStyles) then return lightStyles[styleIndex].rgb end if
  return [1.0, 1.0, 1.0]
end function

function styleWhite(lightStyles, styleIndex)
  if styleIndex >= 0 and styleIndex < len(lightStyles) then return lightStyles[styleIndex].white end if
  return 1.0
end function

function isLitSurface(surface)
  return (surface.texInfo.flags & (fc.SURF_SKY | fc.SURF_TRANS33 | fc.SURF_TRANS66 | fc.SURF_WARP)) == 0
end function

function markDynamicLights(surface, dLights)
  bits = 0
  lightIndex = 0
  while lightIndex < len(dLights) and lightIndex < 32
    light = dLights[lightIndex]
    planeDistance = rclassicvector.dot(light.origin, surface.plane.normal) - surface.plane.distance
    planeRadius = light.intensity - smath.abs(planeDistance)
    if planeRadius >= rclassicconstants.DLIGHT_CUTOFF then bits = bits | (1 << lightIndex) end if
    lightIndex = lightIndex + 1
  end while
  surface.dlightBits = bits
  return bits
end function

function addDynamicLights(surface, dLights, blockLights)
  lightIndex = 0
  while lightIndex < len(dLights) and lightIndex < 32
    if (surface.dlightBits & (1 << lightIndex)) != 0 then
      light = dLights[lightIndex]
      planeDistance = rclassicvector.dot(light.origin, surface.plane.normal) - surface.plane.distance
      planeRadius = light.intensity - smath.abs(planeDistance)
      if planeRadius >= rclassicconstants.DLIGHT_CUTOFF then
        minimum = planeRadius - rclassicconstants.DLIGHT_CUTOFF
        impact = rclassicvector.multiplyAdd(light.origin, -planeDistance, surface.plane.normal)
        localS = rclassicsurfaces.projected(impact, surface.texInfo.s) - surface.textureMins[0]
        localT = rclassicsurfaces.projected(impact, surface.texInfo.t) - surface.textureMins[1]
        t = 0
        while t < surface.lightHeight
          td = qbyteio.truncInt(localT - t * rclassicconstants.LIGHTMAP_SAMPLE_SIZE)
          if td < 0 then td = -td end if
          s = 0
          while s < surface.lightWidth
            sd = qbyteio.truncInt(localS - s * rclassicconstants.LIGHTMAP_SAMPLE_SIZE)
            if sd < 0 then sd = -sd end if
            distance = td + qbyteio.truncInt(sd / 2)
            if sd > td then distance = sd + qbyteio.truncInt(td / 2) end if
            if distance < minimum then
              amount = planeRadius - distance
              offset = (t * surface.lightWidth + s) * 3
              blockLights[offset] = blockLights[offset] + amount * light.color.x
              blockLights[offset + 1] = blockLights[offset + 1] + amount * light.color.y
              blockLights[offset + 2] = blockLights[offset + 2] + amount * light.color.z
            end if
            s = s + 1
          end while
          t = t + 1
        end while
      end if
    end if
    lightIndex = lightIndex + 1
  end while
  return blockLights
end function

function storeRgba(blockLights, sampleCount)
  output = bytes(sampleCount * rclassicconstants.LIGHTMAP_BYTES)
  sample = 0
  while sample < sampleCount
    inputOffset = sample * 3
    red = qbyteio.truncInt(blockLights[inputOffset])
    green = qbyteio.truncInt(blockLights[inputOffset + 1])
    blue = qbyteio.truncInt(blockLights[inputOffset + 2])
    if red < 0 then red = 0 end if
    if green < 0 then green = 0 end if
    if blue < 0 then blue = 0 end if
    maximum = red
    if green > maximum then maximum = green end if
    if blue > maximum then maximum = blue end if
    alpha = maximum
    if maximum > 255 then
      factor = 255.0 / maximum
      red = qbyteio.truncInt(red * factor)
      green = qbyteio.truncInt(green * factor)
      blue = qbyteio.truncInt(blue * factor)
      alpha = qbyteio.truncInt(alpha * factor)
    end if
    output[sample * 4] = red
    output[sample * 4 + 1] = green
    output[sample * 4 + 2] = blue
    output[sample * 4 + 3] = alpha
    sample = sample + 1
  end while
  return output
end function

function buildLightmap(surface, lightStyles, dLights, modulate)
  if isLitSurface(surface) == false then return error(9720, "R_BuildLightMap called for non-lit surface") end if
  sampleCount = surface.lightWidth * surface.lightHeight
  if sampleCount <= 0 or sampleCount > rclassicconstants.MAX_BLOCKLIGHTS then return error(9721, "classic blocklights size outside limit") end if
  blockLights = array(sampleCount * 3, 0.0)
  if surface.samples is void then
    index = 0
    while index < sampleCount * 3
      blockLights[index] = 255.0
      index = index + 1
    end while
    return storeRgba(blockLights, sampleCount)
  end if

  mapCount = rclassicsurfaces.lightMapCount(surface.styles)
  required = sampleCount * 3 * mapCount
  if typeof(surface.samples) != "bytes" or len(surface.samples) < required then return error(9722, "classic surface light samples are truncated") end if
  mapIndex = 0
  while mapIndex < mapCount
    styleIndex = surface.styles[mapIndex]
    rgb = styleRgb(lightStyles, styleIndex)
    sample = 0
    sourceBase = mapIndex * sampleCount * 3
    while sample < sampleCount
      destination = sample * 3
      source = sourceBase + sample * 3
      blockLights[destination] = blockLights[destination] + surface.samples[source] * modulate * rgb[0]
      blockLights[destination + 1] = blockLights[destination + 1] + surface.samples[source + 1] * modulate * rgb[1]
      blockLights[destination + 2] = blockLights[destination + 2] + surface.samples[source + 2] * modulate * rgb[2]
      sample = sample + 1
    end while
    mapIndex = mapIndex + 1
  end while
  addDynamicLights(surface, dLights, blockLights)
  return storeRgba(blockLights, sampleCount)
end function

function setCacheState(surface, lightStyles)
  mapIndex = 0
  while mapIndex < rclassicconstants.MAX_LIGHTMAPS
    surface.cachedLight[mapIndex] = -1.0
    if mapIndex < len(surface.styles) and surface.styles[mapIndex] != 255 then
      surface.cachedLight[mapIndex] = styleWhite(lightStyles, surface.styles[mapIndex])
    end if
    mapIndex = mapIndex + 1
  end while
  return surface.cachedLight
end function

function prepare(surface, lightStyles, dLights, modulate)
  markDynamicLights(surface, dLights)
  surface.lightmap = buildLightmap(surface, lightStyles, dLights, modulate)
  setCacheState(surface, lightStyles)
  return surface
end function

