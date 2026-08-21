/* Standalone, non-product entrypoint for deterministic retail renderer captures. */
import miniquake2.runtime.visual_capture as retailvisualtool
import miniquake2.qcommon.types as retailvisualtoolqtypes
import miniquake2.qcommon.byteio as retailvisualtoolbyteio

function retailVisualToolUsage()
  print "usage: retail_visual_capture ROOT MAP OUTPUT.tga [MODEL|- [WIDTH HEIGHT FRAMES [INLINE(0|1) [X Y Z PITCH YAW ROLL]]]]"
  print "defaults: MODEL=- WIDTH=640 HEIGHT=360 FRAMES=4 INLINE=1, camera=first info_player_start"
  return 2
end function

function retailVisualToolInteger(value)
  return retailvisualtoolbyteio.truncInt(toNumber(value))
end function

function main(args)
  if len(args) < 3 or len(args) > 14 or (len(args) > 8 and len(args) != 14) then
    return retailVisualToolUsage()
  end if
  modelName = ""
  width = 640; height = 360; frames = 4; includeInline = true
  if len(args) >= 4 and args[3] != "-" then modelName = args[3] end if
  if len(args) >= 5 then width = retailVisualToolInteger(args[4]) end if
  if len(args) >= 6 then height = retailVisualToolInteger(args[5]) end if
  if len(args) >= 7 then frames = retailVisualToolInteger(args[6]) end if
  if len(args) >= 8 then includeInline = retailVisualToolInteger(args[7]) != 0 end if
  cameraOrigin = void; cameraAngles = void
  if len(args) == 14 then
    cameraOrigin = retailvisualtoolqtypes.Vec3(toNumber(args[8]), toNumber(args[9]), toNumber(args[10]))
    cameraAngles = retailvisualtoolqtypes.Vec3(toNumber(args[11]), toNumber(args[12]), toNumber(args[13]))
  end if
  result = retailvisualtool.captureRetailScene(args[0], args[1], args[2],
    width, height, frames, modelName, includeInline, cameraOrigin, cameraAngles)
  origin = result.viewOrigin; angles = result.viewAngles
  print "MiniQuake2 visual capture: PASS"
  print "  map=" + result.mapName + " output=" + result.outputPath
  print "  size=" + result.width + "x" + result.height + " frames=" + result.renderedFrames + " time=" + result.renderTime
  print "  camera=" + origin.x + " " + origin.y + " " + origin.z + " " + angles.x + " " + angles.y + " " + angles.z
  print "  checksum-fnv1a=" + result.rgbaChecksum + " visible=" + result.visibleSurfaces + " culled=" + result.culledSurfaces
  print "  cluster=" + result.viewCluster + " warp=" + result.warpSurfaces + " alpha=" + result.transparentSurfaces + " sky=" + result.skySurfaces
  print "  brush-entities=" + result.inlineBrushEntities + " md2-entities=" + result.md2Entities
  return 0
end function
