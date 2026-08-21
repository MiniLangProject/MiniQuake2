/* BSP lifetime gate under the complete retail play/runtime/bridge import graph. */
import miniquake2.runtime.application as bspgraphapplication
import miniquake2.runtime.play_session as bspgraphplaysession
import miniquake2.server.game_bridge as bspgraphbridge
import miniquake2.qcommon.filesystem as bspgraphfilesystem
import miniquake2.format.bsp as bspgraphparser
import miniquake2.format.constants as bspgraphconstants
import miniquake2.format.types as bspgraphtypes
import miniquake2.collision.model as bspgraphcollision

function bspGraphAssert(value, message)
  if not value then return error(9898, message) end if
  return true
end function

function bspGraphValidateModel(bspGraphModelHolder, bspGraphLabel)
  bspGraphAssert(typeof(bspGraphModelHolder) == "struct" and typeof(bspGraphModelHolder.map) == "struct",
    bspGraphLabel + ": collision map lost")
  bspGraphMapHolder = bspGraphModelHolder.map
  for each bspGraphPlaneRecord in bspGraphMapHolder.planes
    bspGraphAssert(typeof(bspGraphPlaneRecord) == "struct" and typeof(bspGraphPlaneRecord.normal) == "struct",
      bspGraphLabel + ": plane normal lost")
  end for
  for each bspGraphNodeRecord in bspGraphMapHolder.nodes
    bspGraphAssert(typeof(bspGraphNodeRecord) == "struct" and typeof(bspGraphNodeRecord.mins) == "struct" and
      typeof(bspGraphNodeRecord.maxs) == "struct", bspGraphLabel + ": node bounds lost")
  end for
  for each bspGraphBrushSideRecord in bspGraphMapHolder.brushSides
    bspGraphAssert(typeof(bspGraphBrushSideRecord) == "struct", bspGraphLabel + ": brush side lost")
  end for
  bspGraphHeadNode = bspGraphMapHolder.models[0].headNode
  bspGraphPointHolder = bspgraphtypes.Vec3(0.0, 0.0, 0.0)
  bspGraphLeaf = bspgraphcollision.pointLeafNumber(bspGraphModelHolder, bspGraphPointHolder, bspGraphHeadNode)
  bspGraphAssert(bspGraphLeaf >= 0 and bspGraphLeaf < len(bspGraphMapHolder.leafs), bspGraphLabel + ": point traversal failed")
  bspGraphFinishHolder = bspgraphtypes.Vec3(2.0, 0.0, 0.0)
  bspGraphMinsHolder = bspgraphtypes.Vec3(0.0, 0.0, 0.0)
  bspGraphMaxsHolder = bspgraphtypes.Vec3(0.0, 0.0, 0.0)
  bspGraphTraceHolder = bspgraphcollision.boxTrace(bspGraphModelHolder, bspGraphPointHolder,
    bspGraphFinishHolder, bspGraphMinsHolder, bspGraphMaxsHolder, bspGraphHeadNode,
    bspgraphconstants.CONTENTS_SOLID)
  bspGraphAssert(bspGraphTraceHolder.fraction >= 0.0 and bspGraphTraceHolder.fraction <= 1.0,
    bspGraphLabel + ": trace traversal failed")
  return true
end function

function bspGraphRetailRetention(root)
  // Referencing all three roots prevents the compiler from reducing this to
  // the isolated format/collision graph that did not reproduce Product39.
  bspGraphLinkedFunctions = [typeof(bspgraphapplication.campaignMapNames),
    typeof(bspgraphplaysession.createRetail), typeof(bspgraphbridge.makeImports)]
  bspGraphAssert(bspGraphLinkedFunctions == ["function", "function", "function"],
    "product graph imports missing")
  bspGraphFilesystemHolder = bspgraphfilesystem.initialize(root, "")
  bspGraphMapNamesHolder = bspgraphapplication.campaignMapNames()
  bspGraphRetainedModels = array(4, void)
  bspGraphMapIndex = 0
  while bspGraphMapIndex < len(bspGraphMapNamesHolder)
    bspGraphMapNameHolder = bspGraphMapNamesHolder[bspGraphMapIndex]
    bspGraphMapPathHolder = "maps/" + bspGraphMapNameHolder + ".bsp"
    bspGraphFileDataHolder = bspgraphfilesystem.readFile(bspGraphFilesystemHolder, bspGraphMapPathHolder)
    bspGraphParsedMapHolder = bspgraphparser.parse(bspGraphFileDataHolder, bspGraphMapPathHolder)
    bspGraphCollisionModelHolder = bspgraphcollision.create(bspGraphParsedMapHolder)
    bspGraphRetainedSlot = bspGraphMapIndex % len(bspGraphRetainedModels)
    bspGraphRetainedModels[bspGraphRetainedSlot] = bspGraphCollisionModelHolder
    bspGraphStoredModelHolder = bspGraphRetainedModels[bspGraphRetainedSlot]
    bspGraphStoredModelHolder.map = bspGraphParsedMapHolder
    bspGraphWindowIndex = 0
    while bspGraphWindowIndex < len(bspGraphRetainedModels)
      if bspGraphRetainedModels[bspGraphWindowIndex] is not void then
        bspGraphValidateModel(bspGraphRetainedModels[bspGraphWindowIndex], bspGraphMapNameHolder)
      end if
      bspGraphWindowIndex = bspGraphWindowIndex + 1
    end while
    bspGraphMapIndex = bspGraphMapIndex + 1
  end while
  bspGraphAssert(bspGraphMapIndex == 39, "campaign map count changed")
  return true
end function

function main(args)
  if len(args) == 0 then
    print "collision_bsp_product_graph_retention_tests: SKIP (no retail root)"
    return 0
  end if
  if len(args) != 1 then return error(9899, "expected Quake II install root") end if
  bspGraphRetailRetention(args[0])
  print "collision_bsp_product_graph_retention_tests: PASS (retail Product39 graph)"
  return 0
end function
