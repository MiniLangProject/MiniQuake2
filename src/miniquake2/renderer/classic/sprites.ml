/* Camera-facing SP2 frame selection and quad preparation from R_DrawSpriteModel. */
package miniquake2.renderer.classic.sprites

import miniquake2.renderer.constants as rc
import miniquake2.renderer.classic.types as rclassictypes
import miniquake2.renderer.classic.vector as rclassicvector

function spriteVertex(position, s, t)
  return rclassictypes.SpriteVertex(rclassicvector.copy(position), s, t)
end function

function frameIndex(model, requestedFrame)
  if len(model.frames) == 0 then return error(9730, "sprite has no frames") end if
  selected = requestedFrame % len(model.frames)
  if selected < 0 then selected = selected + len(model.frames) end if
  return selected
end function

function prepare(model, entity, cameraUp, cameraRight)
  selected = frameIndex(model, entity.frame)
  frame = model.frames[selected]
  alpha = 1.0
  if (entity.flags & rc.RF_TRANSLUCENT) != 0 then alpha = entity.alpha end if
  lowerLeft = rclassicvector.multiplyAdd(entity.origin, -frame.originY, cameraUp)
  lowerLeft = rclassicvector.multiplyAdd(lowerLeft, -frame.originX, cameraRight)
  upperLeft = rclassicvector.multiplyAdd(entity.origin, frame.height - frame.originY, cameraUp)
  upperLeft = rclassicvector.multiplyAdd(upperLeft, -frame.originX, cameraRight)
  upperRight = rclassicvector.multiplyAdd(entity.origin, frame.height - frame.originY, cameraUp)
  upperRight = rclassicvector.multiplyAdd(upperRight, frame.width - frame.originX, cameraRight)
  lowerRight = rclassicvector.multiplyAdd(entity.origin, -frame.originY, cameraUp)
  lowerRight = rclassicvector.multiplyAdd(lowerRight, frame.width - frame.originX, cameraRight)
  vertices = [
    spriteVertex(lowerLeft, 0.0, 1.0),
    spriteVertex(upperLeft, 0.0, 0.0),
    spriteVertex(upperRight, 1.0, 0.0),
    spriteVertex(lowerRight, 1.0, 1.0)
  ]
  return rclassictypes.SpriteDraw(selected, frame.imageName, vertices, alpha, alpha != 1.0, alpha == 1.0)
end function

