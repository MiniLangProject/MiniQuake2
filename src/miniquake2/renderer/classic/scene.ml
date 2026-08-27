/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Surface classification/chaining and lightmap preparation, with no GL calls. */
package miniquake2.renderer.classic.scene

import miniquake2.format.constants as fc
import miniquake2.renderer.classic.constants as rclassicconstants
import miniquake2.renderer.classic.types as rclassictypes
import miniquake2.renderer.classic.surfaces as rclassicsurfaces
import miniquake2.renderer.classic.lightmaps as rclassiclightmaps
import miniquake2.renderer.classic.sprites as rclassicsprites

// Find chain.
function findChain(chains, imageName)
  for each chain in chains
    if chain.imageName == imageName then return chain end if
  end for
  return void
end function

// Add to texture chain.
function addToTextureChain(chains, surface)
  chain = findChain(chains, surface.image.name)
  if chain is void then
    chain = rclassictypes.TextureChain(surface.image.name, [])
    chains = chains + [chain]
  end if
  // BSP traversal is front-to-back and ref_gl links at the chain head.
  chain.surfaces = [surface] + chain.surfaces
  return chains
end function

// Prepare map.
function prepareMap(map, images, entityFrame, lightStyles, dLights, modulate)
  surfaces = rclassicsurfaces.buildSurfaces(map, images, entityFrame)
  chains = []
  transparent = []
  sky = []
  warp = []
  noDraw = []
  for each surface in surfaces
    if surface.category == rclassicconstants.MATERIAL_NODRAW then
      noDraw = noDraw + [surface]
    else if surface.category == rclassicconstants.MATERIAL_SKY then
      sky = sky + [surface]
    else if surface.category == rclassicconstants.MATERIAL_TRANSPARENT then
      // Head insertion makes a front-to-back traversal render back-to-front.
      transparent = [surface] + transparent
      if (surface.texInfo.flags & fc.SURF_WARP) != 0 then warp = warp + [surface] end if
    else
      if surface.category == rclassicconstants.MATERIAL_WARP then
        warp = warp + [surface]
      else
        rclassiclightmaps.prepare(surface, lightStyles, dLights, modulate)
      end if
      chains = addToTextureChain(chains, surface)
    end if
  end for
  return rclassictypes.ClassicScene(surfaces, chains, transparent, sky, warp, noDraw, [])
end function

// Add sprite.
function addSprite(scene, model, entity, cameraUp, cameraRight)
  draw = rclassicsprites.prepare(model, entity, cameraUp, cameraRight)
  scene.sprites = scene.sprites + [draw]
  return draw
end function
