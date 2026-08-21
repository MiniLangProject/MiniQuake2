/* Quake II BSP38 loader. Collision and renderer code consume this canonical map. */
package miniquake2.format.bsp

import miniquake2.format.constants as fc
import miniquake2.format.types as ft
import miniquake2.format.binary as fbio

function emptyArray(count)
  return array(count)
end function

function parseLumps(data)
  bspLumpDataHolder = data
  bspHeaderBytes = 8 + fc.HEADER_LUMPS * 8
  if len(bspLumpDataHolder) < bspHeaderBytes then return error(2200, "BSP38 header is truncated") end if
  if fbio.u32(bspLumpDataHolder, 0) != fc.IDBSPHEADER then return error(2201, "BSP38 ident mismatch") end if
  if fbio.i32(bspLumpDataHolder, 4) != fc.BSP_VERSION then return error(2202, "unsupported BSP version") end if
  bspLumpRecords = emptyArray(fc.HEADER_LUMPS)
  bspLumpIndex = 0
  while bspLumpIndex < fc.HEADER_LUMPS
    bspLumpOffset = fbio.i32(bspLumpDataHolder, 8 + bspLumpIndex * 8)
    bspLumpLength = fbio.i32(bspLumpDataHolder, 12 + bspLumpIndex * 8)
    if bspLumpOffset < 0 or bspLumpLength < 0 or bspLumpOffset > len(bspLumpDataHolder) or bspLumpLength > len(bspLumpDataHolder) - bspLumpOffset then
      return error(2203, "BSP lump outside file")
    end if
    bspLumpRecord = ft.Lump(bspLumpOffset, bspLumpLength)
    bspLumpRecords[bspLumpIndex] = bspLumpRecord
    bspLumpIndex = bspLumpIndex + 1
  end while
  return bspLumpRecords
end function

function requireStride(lump, stride, name)
  if lump.length % stride != 0 then return error(2204, "invalid " + name + " lump stride") end if
  return lump.length / stride
end function

function vec3f(data, offset)
  bspFloatVectorDataHolder = data
  bspFloatVectorOffset = offset
  bspFloatVectorX = fbio.f32(bspFloatVectorDataHolder, bspFloatVectorOffset)
  bspFloatVectorY = fbio.f32(bspFloatVectorDataHolder, bspFloatVectorOffset + 4)
  bspFloatVectorZ = fbio.f32(bspFloatVectorDataHolder, bspFloatVectorOffset + 8)
  return ft.Vec3(bspFloatVectorX, bspFloatVectorY, bspFloatVectorZ)
end function

function vec3s(data, offset)
  bspShortVectorDataHolder = data
  bspShortVectorOffset = offset
  bspShortVectorX = fbio.i16(bspShortVectorDataHolder, bspShortVectorOffset)
  bspShortVectorY = fbio.i16(bspShortVectorDataHolder, bspShortVectorOffset + 2)
  bspShortVectorZ = fbio.i16(bspShortVectorDataHolder, bspShortVectorOffset + 4)
  return ft.Vec3(bspShortVectorX, bspShortVectorY, bspShortVectorZ)
end function

function parsePlanes(data, lump)
  bspPlaneDataHolder = data
  bspPlaneLumpHolder = lump
  bspPlaneCount = requireStride(bspPlaneLumpHolder, 20, "plane")
  bspPlaneRecords = emptyArray(bspPlaneCount)
  bspPlaneIndex = 0
  while bspPlaneIndex < bspPlaneCount
    bspPlaneAt = bspPlaneLumpHolder.offset + bspPlaneIndex * 20
    bspPlaneNormalHolder = vec3f(bspPlaneDataHolder, bspPlaneAt)
    bspPlaneDistance = fbio.f32(bspPlaneDataHolder, bspPlaneAt + 12)
    bspPlaneType = fbio.i32(bspPlaneDataHolder, bspPlaneAt + 16)
    bspPlaneRecord = ft.BspPlane(bspPlaneNormalHolder, bspPlaneDistance, bspPlaneType)
    bspPlaneRecord.normal = bspPlaneNormalHolder
    bspPlaneRecords[bspPlaneIndex] = bspPlaneRecord
    bspStoredPlaneRecord = bspPlaneRecords[bspPlaneIndex]
    bspStoredPlaneRecord.normal = bspPlaneNormalHolder
    bspPlaneIndex = bspPlaneIndex + 1
  end while
  return bspPlaneRecords
end function

function parseVertices(data, lump)
  bspVertexDataHolder = data
  bspVertexLumpHolder = lump
  bspVertexCount = requireStride(bspVertexLumpHolder, 12, "vertex")
  bspVertexRecords = emptyArray(bspVertexCount)
  bspVertexIndex = 0
  while bspVertexIndex < bspVertexCount
    bspVertexPositionHolder = vec3f(bspVertexDataHolder, bspVertexLumpHolder.offset + bspVertexIndex * 12)
    bspVertexRecord = ft.BspVertex(bspVertexPositionHolder)
    bspVertexRecord.position = bspVertexPositionHolder
    bspVertexRecords[bspVertexIndex] = bspVertexRecord
    bspStoredVertexRecord = bspVertexRecords[bspVertexIndex]
    bspStoredVertexRecord.position = bspVertexPositionHolder
    bspVertexIndex = bspVertexIndex + 1
  end while
  return bspVertexRecords
end function

function parseVisibility(data, lump)
  bspVisibilityDataHolder = data
  bspVisibilityLumpHolder = lump
  if bspVisibilityLumpHolder.length == 0 then
    bspEmptyPvsHolder = []
    bspEmptyPhsHolder = []
    bspEmptyVisibilityDataHolder = bytes(0)
    bspEmptyVisibilityRecord = ft.BspVisibility(0, bspEmptyPvsHolder, bspEmptyPhsHolder, bspEmptyVisibilityDataHolder)
    bspEmptyVisibilityRecord.pvsOffsets = bspEmptyPvsHolder
    bspEmptyVisibilityRecord.phsOffsets = bspEmptyPhsHolder
    bspEmptyVisibilityRecord.data = bspEmptyVisibilityDataHolder
    return bspEmptyVisibilityRecord
  end if
  if bspVisibilityLumpHolder.length < 4 then return error(2205, "visibility header is truncated") end if
  bspVisibilityClusters = fbio.i32(bspVisibilityDataHolder, bspVisibilityLumpHolder.offset)
  if bspVisibilityClusters < 0 or bspVisibilityClusters > 65536 or 4 + bspVisibilityClusters * 8 > bspVisibilityLumpHolder.length then
    return error(2206, "invalid visibility cluster table")
  end if
  bspVisibilityPvsHolder = emptyArray(bspVisibilityClusters)
  bspVisibilityPhsHolder = emptyArray(bspVisibilityClusters)
  bspVisibilityIndex = 0
  while bspVisibilityIndex < bspVisibilityClusters
    bspVisibilityPvsHolder[bspVisibilityIndex] = fbio.i32(bspVisibilityDataHolder, bspVisibilityLumpHolder.offset + 4 + bspVisibilityIndex * 8)
    bspVisibilityPhsHolder[bspVisibilityIndex] = fbio.i32(bspVisibilityDataHolder, bspVisibilityLumpHolder.offset + 8 + bspVisibilityIndex * 8)
    if bspVisibilityPvsHolder[bspVisibilityIndex] < 0 or bspVisibilityPvsHolder[bspVisibilityIndex] >= bspVisibilityLumpHolder.length or bspVisibilityPhsHolder[bspVisibilityIndex] < 0 or bspVisibilityPhsHolder[bspVisibilityIndex] >= bspVisibilityLumpHolder.length then
      return error(2207, "visibility bit offset outside lump")
    end if
    bspVisibilityIndex = bspVisibilityIndex + 1
  end while
  bspVisibilityBytesHolder = slice(bspVisibilityDataHolder, bspVisibilityLumpHolder.offset, bspVisibilityLumpHolder.length)
  bspVisibilityRecord = ft.BspVisibility(bspVisibilityClusters, bspVisibilityPvsHolder, bspVisibilityPhsHolder, bspVisibilityBytesHolder)
  bspVisibilityRecord.pvsOffsets = bspVisibilityPvsHolder
  bspVisibilityRecord.phsOffsets = bspVisibilityPhsHolder
  bspVisibilityRecord.data = bspVisibilityBytesHolder
  return bspVisibilityRecord
end function

function decompressVisibility(visibility, cluster, kind)
  if cluster < 0 or cluster >= visibility.numClusters then return error(2208, "visibility cluster outside table") end if
  bspDecompressVisibilityHolder = visibility
  bspVisibilityRowBytes = (bspDecompressVisibilityHolder.numClusters + 7) >> 3
  bspVisibilityRowResult = bytes(bspVisibilityRowBytes)
  bspVisibilityInput = 0
  if kind == 0 then bspVisibilityInput = bspDecompressVisibilityHolder.pvsOffsets[cluster] else bspVisibilityInput = bspDecompressVisibilityHolder.phsOffsets[cluster] end if
  bspVisibilityOutput = 0
  while bspVisibilityOutput < bspVisibilityRowBytes
    if bspVisibilityInput >= len(bspDecompressVisibilityHolder.data) then return error(2209, "truncated visibility row") end if
    bspVisibilityValue = bspDecompressVisibilityHolder.data[bspVisibilityInput]
    bspVisibilityInput = bspVisibilityInput + 1
    if bspVisibilityValue != 0 then
      bspVisibilityRowResult[bspVisibilityOutput] = bspVisibilityValue
      bspVisibilityOutput = bspVisibilityOutput + 1
    else
      if bspVisibilityInput >= len(bspDecompressVisibilityHolder.data) then return error(2210, "truncated visibility run") end if
      bspVisibilityRun = bspDecompressVisibilityHolder.data[bspVisibilityInput]
      bspVisibilityInput = bspVisibilityInput + 1
      if bspVisibilityRun <= 0 or bspVisibilityRun > bspVisibilityRowBytes - bspVisibilityOutput then return error(2211, "invalid visibility run") end if
      bspVisibilityOutput = bspVisibilityOutput + bspVisibilityRun
    end if
  end while
  return bspVisibilityRowResult
end function

function parseNodes(data, lump)
  bspNodeDataHolder = data
  bspNodeLumpHolder = lump
  bspNodeCount = requireStride(bspNodeLumpHolder, 28, "node")
  bspNodeRecords = emptyArray(bspNodeCount)
  bspNodeIndex = 0
  while bspNodeIndex < bspNodeCount
    bspNodeAt = bspNodeLumpHolder.offset + bspNodeIndex * 28
    bspNodePlaneIndex = fbio.i32(bspNodeDataHolder, bspNodeAt)
    bspNodeChild0 = fbio.i32(bspNodeDataHolder, bspNodeAt + 4)
    bspNodeChild1 = fbio.i32(bspNodeDataHolder, bspNodeAt + 8)
    bspNodeMinsHolder = vec3s(bspNodeDataHolder, bspNodeAt + 12)
    bspNodeMaxsHolder = vec3s(bspNodeDataHolder, bspNodeAt + 18)
    bspNodeFirstFace = fbio.u16(bspNodeDataHolder, bspNodeAt + 24)
    bspNodeNumFaces = fbio.u16(bspNodeDataHolder, bspNodeAt + 26)
    bspNodeRecord = ft.BspNode(bspNodePlaneIndex, bspNodeChild0, bspNodeChild1, bspNodeMinsHolder, bspNodeMaxsHolder, bspNodeFirstFace, bspNodeNumFaces)
    bspNodeRecord.mins = bspNodeMinsHolder
    bspNodeRecord.maxs = bspNodeMaxsHolder
    bspNodeRecords[bspNodeIndex] = bspNodeRecord
    bspStoredNodeRecord = bspNodeRecords[bspNodeIndex]
    bspStoredNodeRecord.mins = bspNodeMinsHolder
    bspStoredNodeRecord.maxs = bspNodeMaxsHolder
    bspNodeIndex = bspNodeIndex + 1
  end while
  return bspNodeRecords
end function

function parseTexInfo(data, lump)
  bspTexInfoDataHolder = data
  bspTexInfoLumpHolder = lump
  bspTexInfoCount = requireStride(bspTexInfoLumpHolder, 76, "texinfo")
  bspTexInfoRecords = emptyArray(bspTexInfoCount)
  bspTexInfoIndex = 0
  while bspTexInfoIndex < bspTexInfoCount
    bspTexInfoAt = bspTexInfoLumpHolder.offset + bspTexInfoIndex * 76
    bspTexInfoSHolder = [fbio.f32(bspTexInfoDataHolder, bspTexInfoAt), fbio.f32(bspTexInfoDataHolder, bspTexInfoAt + 4), fbio.f32(bspTexInfoDataHolder, bspTexInfoAt + 8), fbio.f32(bspTexInfoDataHolder, bspTexInfoAt + 12)]
    bspTexInfoTHolder = [fbio.f32(bspTexInfoDataHolder, bspTexInfoAt + 16), fbio.f32(bspTexInfoDataHolder, bspTexInfoAt + 20), fbio.f32(bspTexInfoDataHolder, bspTexInfoAt + 24), fbio.f32(bspTexInfoDataHolder, bspTexInfoAt + 28)]
    bspTexInfoFlags = fbio.i32(bspTexInfoDataHolder, bspTexInfoAt + 32)
    bspTexInfoValue = fbio.i32(bspTexInfoDataHolder, bspTexInfoAt + 36)
    bspTexInfoTextureHolder = fbio.fixedString(bspTexInfoDataHolder, bspTexInfoAt + 40, 32)
    bspTexInfoNextIndex = fbio.i32(bspTexInfoDataHolder, bspTexInfoAt + 72)
    bspTexInfoRecord = ft.BspTexInfo(bspTexInfoSHolder, bspTexInfoTHolder, bspTexInfoFlags, bspTexInfoValue, bspTexInfoTextureHolder, bspTexInfoNextIndex)
    bspTexInfoRecord.s = bspTexInfoSHolder
    bspTexInfoRecord.t = bspTexInfoTHolder
    bspTexInfoRecord.texture = bspTexInfoTextureHolder
    bspTexInfoRecords[bspTexInfoIndex] = bspTexInfoRecord
    bspStoredTexInfoRecord = bspTexInfoRecords[bspTexInfoIndex]
    bspStoredTexInfoRecord.s = bspTexInfoSHolder
    bspStoredTexInfoRecord.t = bspTexInfoTHolder
    bspStoredTexInfoRecord.texture = bspTexInfoTextureHolder
    bspTexInfoIndex = bspTexInfoIndex + 1
  end while
  return bspTexInfoRecords
end function

function parseFaces(data, lump)
  bspFaceDataHolder = data
  bspFaceLumpHolder = lump
  bspFaceCount = requireStride(bspFaceLumpHolder, 20, "face")
  bspFaceRecords = emptyArray(bspFaceCount)
  bspFaceIndex = 0
  while bspFaceIndex < bspFaceCount
    bspFaceAt = bspFaceLumpHolder.offset + bspFaceIndex * 20
    bspFacePlaneIndex = fbio.u16(bspFaceDataHolder, bspFaceAt)
    bspFaceSide = fbio.i16(bspFaceDataHolder, bspFaceAt + 2)
    bspFaceFirstEdge = fbio.i32(bspFaceDataHolder, bspFaceAt + 4)
    bspFaceNumEdges = fbio.i16(bspFaceDataHolder, bspFaceAt + 8)
    bspFaceTexInfoIndex = fbio.i16(bspFaceDataHolder, bspFaceAt + 10)
    bspFaceStylesHolder = slice(bspFaceDataHolder, bspFaceAt + 12, 4)
    bspFaceLightOffset = fbio.i32(bspFaceDataHolder, bspFaceAt + 16)
    bspFaceRecord = ft.BspFace(bspFacePlaneIndex, bspFaceSide, bspFaceFirstEdge, bspFaceNumEdges, bspFaceTexInfoIndex, bspFaceStylesHolder, bspFaceLightOffset)
    bspFaceRecord.styles = bspFaceStylesHolder
    bspFaceRecords[bspFaceIndex] = bspFaceRecord
    bspStoredFaceRecord = bspFaceRecords[bspFaceIndex]
    bspStoredFaceRecord.styles = bspFaceStylesHolder
    bspFaceIndex = bspFaceIndex + 1
  end while
  return bspFaceRecords
end function

function parseLeafs(data, lump)
  bspLeafDataHolder = data
  bspLeafLumpHolder = lump
  bspLeafCount = requireStride(bspLeafLumpHolder, 28, "leaf")
  bspLeafRecords = emptyArray(bspLeafCount)
  bspLeafIndex = 0
  while bspLeafIndex < bspLeafCount
    bspLeafAt = bspLeafLumpHolder.offset + bspLeafIndex * 28
    bspLeafContents = fbio.i32(bspLeafDataHolder, bspLeafAt)
    bspLeafCluster = fbio.i16(bspLeafDataHolder, bspLeafAt + 4)
    bspLeafArea = fbio.i16(bspLeafDataHolder, bspLeafAt + 6)
    bspLeafMinsHolder = vec3s(bspLeafDataHolder, bspLeafAt + 8)
    bspLeafMaxsHolder = vec3s(bspLeafDataHolder, bspLeafAt + 14)
    bspLeafFirstFace = fbio.u16(bspLeafDataHolder, bspLeafAt + 20)
    bspLeafNumFaces = fbio.u16(bspLeafDataHolder, bspLeafAt + 22)
    bspLeafFirstBrush = fbio.u16(bspLeafDataHolder, bspLeafAt + 24)
    bspLeafNumBrushes = fbio.u16(bspLeafDataHolder, bspLeafAt + 26)
    bspLeafRecord = ft.BspLeaf(bspLeafContents, bspLeafCluster, bspLeafArea, bspLeafMinsHolder, bspLeafMaxsHolder, bspLeafFirstFace, bspLeafNumFaces, bspLeafFirstBrush, bspLeafNumBrushes)
    bspLeafRecord.mins = bspLeafMinsHolder
    bspLeafRecord.maxs = bspLeafMaxsHolder
    bspLeafRecords[bspLeafIndex] = bspLeafRecord
    bspStoredLeafRecord = bspLeafRecords[bspLeafIndex]
    bspStoredLeafRecord.mins = bspLeafMinsHolder
    bspStoredLeafRecord.maxs = bspLeafMaxsHolder
    bspLeafIndex = bspLeafIndex + 1
  end while
  return bspLeafRecords
end function

function parseU16Array(data, lump, name)
  bspU16DataHolder = data
  bspU16LumpHolder = lump
  bspU16Count = requireStride(bspU16LumpHolder, 2, name)
  bspU16Values = emptyArray(bspU16Count)
  bspU16Index = 0
  while bspU16Index < bspU16Count
    bspU16Values[bspU16Index] = fbio.u16(bspU16DataHolder, bspU16LumpHolder.offset + bspU16Index * 2)
    bspU16Index = bspU16Index + 1
  end while
  return bspU16Values
end function

function parseI32Array(data, lump, name)
  bspI32DataHolder = data
  bspI32LumpHolder = lump
  bspI32Count = requireStride(bspI32LumpHolder, 4, name)
  bspI32Values = emptyArray(bspI32Count)
  bspI32Index = 0
  while bspI32Index < bspI32Count
    bspI32Values[bspI32Index] = fbio.i32(bspI32DataHolder, bspI32LumpHolder.offset + bspI32Index * 4)
    bspI32Index = bspI32Index + 1
  end while
  return bspI32Values
end function

function parseEdges(data, lump)
  bspEdgeDataHolder = data
  bspEdgeLumpHolder = lump
  bspEdgeCount = requireStride(bspEdgeLumpHolder, 4, "edge")
  bspEdgeRecords = emptyArray(bspEdgeCount)
  bspEdgeIndex = 0
  while bspEdgeIndex < bspEdgeCount
    bspEdgeAt = bspEdgeLumpHolder.offset + bspEdgeIndex * 4
    bspEdgeVertex0 = fbio.u16(bspEdgeDataHolder, bspEdgeAt)
    bspEdgeVertex1 = fbio.u16(bspEdgeDataHolder, bspEdgeAt + 2)
    bspEdgeRecord = ft.BspEdge(bspEdgeVertex0, bspEdgeVertex1)
    bspEdgeRecords[bspEdgeIndex] = bspEdgeRecord
    bspEdgeIndex = bspEdgeIndex + 1
  end while
  return bspEdgeRecords
end function

function parseModels(data, lump)
  bspModelDataHolder = data
  bspModelLumpHolder = lump
  bspModelCount = requireStride(bspModelLumpHolder, 48, "model")
  bspModelRecords = emptyArray(bspModelCount)
  bspModelIndex = 0
  while bspModelIndex < bspModelCount
    bspModelAt = bspModelLumpHolder.offset + bspModelIndex * 48
    bspModelMinsHolder = vec3f(bspModelDataHolder, bspModelAt)
    bspModelMaxsHolder = vec3f(bspModelDataHolder, bspModelAt + 12)
    bspModelOriginHolder = vec3f(bspModelDataHolder, bspModelAt + 24)
    bspModelHeadNode = fbio.i32(bspModelDataHolder, bspModelAt + 36)
    bspModelFirstFace = fbio.i32(bspModelDataHolder, bspModelAt + 40)
    bspModelNumFaces = fbio.i32(bspModelDataHolder, bspModelAt + 44)
    bspModelRecord = ft.BspModel(bspModelMinsHolder, bspModelMaxsHolder, bspModelOriginHolder, bspModelHeadNode, bspModelFirstFace, bspModelNumFaces)
    bspModelRecord.mins = bspModelMinsHolder
    bspModelRecord.maxs = bspModelMaxsHolder
    bspModelRecord.origin = bspModelOriginHolder
    bspModelRecords[bspModelIndex] = bspModelRecord
    bspStoredModelRecord = bspModelRecords[bspModelIndex]
    bspStoredModelRecord.mins = bspModelMinsHolder
    bspStoredModelRecord.maxs = bspModelMaxsHolder
    bspStoredModelRecord.origin = bspModelOriginHolder
    bspModelIndex = bspModelIndex + 1
  end while
  return bspModelRecords
end function

function parseBrushes(data, lump)
  bspBrushDataHolder = data
  bspBrushLumpHolder = lump
  bspBrushCount = requireStride(bspBrushLumpHolder, 12, "brush")
  bspBrushRecords = emptyArray(bspBrushCount)
  bspBrushIndex = 0
  while bspBrushIndex < bspBrushCount
    bspBrushAt = bspBrushLumpHolder.offset + bspBrushIndex * 12
    bspBrushFirstSide = fbio.i32(bspBrushDataHolder, bspBrushAt)
    bspBrushNumSides = fbio.i32(bspBrushDataHolder, bspBrushAt + 4)
    bspBrushContents = fbio.i32(bspBrushDataHolder, bspBrushAt + 8)
    bspBrushRecord = ft.BspBrush(bspBrushFirstSide, bspBrushNumSides, bspBrushContents)
    bspBrushRecords[bspBrushIndex] = bspBrushRecord
    bspBrushIndex = bspBrushIndex + 1
  end while
  return bspBrushRecords
end function

function parseBrushSides(data, lump)
  bspBrushSideDataHolder = data
  bspBrushSideLumpHolder = lump
  bspBrushSideCount = requireStride(bspBrushSideLumpHolder, 4, "brushside")
  bspBrushSideRecords = emptyArray(bspBrushSideCount)
  bspBrushSideIndex = 0
  while bspBrushSideIndex < bspBrushSideCount
    bspBrushSideAt = bspBrushSideLumpHolder.offset + bspBrushSideIndex * 4
    bspBrushSidePlaneIndex = fbio.u16(bspBrushSideDataHolder, bspBrushSideAt)
    bspBrushSideTexInfo = fbio.i16(bspBrushSideDataHolder, bspBrushSideAt + 2)
    bspBrushSideRecord = ft.BspBrushSide(bspBrushSidePlaneIndex, bspBrushSideTexInfo)
    bspBrushSideRecords[bspBrushSideIndex] = bspBrushSideRecord
    bspBrushSideIndex = bspBrushSideIndex + 1
  end while
  return bspBrushSideRecords
end function

function parseAreas(data, lump)
  bspAreaDataHolder = data
  bspAreaLumpHolder = lump
  bspAreaCount = requireStride(bspAreaLumpHolder, 8, "area")
  bspAreaRecords = emptyArray(bspAreaCount)
  bspAreaIndex = 0
  while bspAreaIndex < bspAreaCount
    bspAreaAt = bspAreaLumpHolder.offset + bspAreaIndex * 8
    bspAreaNumPortals = fbio.i32(bspAreaDataHolder, bspAreaAt)
    bspAreaFirstPortal = fbio.i32(bspAreaDataHolder, bspAreaAt + 4)
    bspAreaRecord = ft.BspArea(bspAreaNumPortals, bspAreaFirstPortal)
    bspAreaRecords[bspAreaIndex] = bspAreaRecord
    bspAreaIndex = bspAreaIndex + 1
  end while
  return bspAreaRecords
end function

function parseAreaPortals(data, lump)
  bspAreaPortalDataHolder = data
  bspAreaPortalLumpHolder = lump
  bspAreaPortalCount = requireStride(bspAreaPortalLumpHolder, 8, "areaportal")
  bspAreaPortalRecords = emptyArray(bspAreaPortalCount)
  bspAreaPortalIndex = 0
  while bspAreaPortalIndex < bspAreaPortalCount
    bspAreaPortalAt = bspAreaPortalLumpHolder.offset + bspAreaPortalIndex * 8
    bspAreaPortalNumber = fbio.i32(bspAreaPortalDataHolder, bspAreaPortalAt)
    bspAreaPortalOtherArea = fbio.i32(bspAreaPortalDataHolder, bspAreaPortalAt + 4)
    bspAreaPortalRecord = ft.BspAreaPortal(bspAreaPortalNumber, bspAreaPortalOtherArea)
    bspAreaPortalRecords[bspAreaPortalIndex] = bspAreaPortalRecord
    bspAreaPortalIndex = bspAreaPortalIndex + 1
  end while
  return bspAreaPortalRecords
end function

function validateReferences(bspMapToValidate)
  bspValidatedMapHolder = bspMapToValidate
  if typeof(bspValidatedMapHolder) != "struct" then return error(2215, "BSP map record required") end if
  bspReferenceIndex = 0
  while bspReferenceIndex < len(bspValidatedMapHolder.planes)
    bspReferencePlaneRecord = bspValidatedMapHolder.planes[bspReferenceIndex]
    if typeof(bspReferencePlaneRecord) != "struct" or typeof(bspReferencePlaneRecord.normal) != "struct" then
      return error(2216, "plane normal record is unavailable")
    end if
    bspReferenceIndex = bspReferenceIndex + 1
  end while
  bspReferenceIndex = 0
  while bspReferenceIndex < len(bspValidatedMapHolder.nodes)
    bspReferenceNodeRecord = bspValidatedMapHolder.nodes[bspReferenceIndex]
    if typeof(bspReferenceNodeRecord) != "struct" then return error(2217, "node bounds record is unavailable") end if
    bspReferenceNodeMinsProbe = try(bspReferenceNodeRecord.mins)
    bspReferenceNodeMaxsProbe = try(bspReferenceNodeRecord.maxs)
    if typeof(bspReferenceNodeMinsProbe) != "struct" or typeof(bspReferenceNodeMaxsProbe) != "struct" then
      // data+lumps are the immutable canonical representation.  Re-materialize
      // a lost nested bounds record at the validation/write-barrier boundary.
      if typeof(bspValidatedMapHolder.data) != "bytes" or typeof(bspValidatedMapHolder.lumps) != "array" then
        return error(2217, "node bounds record is unavailable")
      end if
      bspReferenceNodeLumpHolder = bspValidatedMapHolder.lumps[fc.LUMP_NODES]
      if typeof(bspReferenceNodeLumpHolder) != "struct" or bspReferenceIndex * 28 + 28 > bspReferenceNodeLumpHolder.length then
        return error(2217, "node bounds record is unavailable")
      end if
      bspReferenceNodeOffset = bspReferenceNodeLumpHolder.offset + bspReferenceIndex * 28
      bspReferenceNodeMinsProbe = vec3s(bspValidatedMapHolder.data, bspReferenceNodeOffset + 12)
      bspReferenceNodeMaxsProbe = vec3s(bspValidatedMapHolder.data, bspReferenceNodeOffset + 18)
    end if
    bspReferenceNodeRecord.mins = bspReferenceNodeMinsProbe
    bspReferenceNodeRecord.maxs = bspReferenceNodeMaxsProbe
    bspValidatedMapHolder.nodes[bspReferenceIndex] = bspReferenceNodeRecord
    bspReferenceStoredNodeHolder = bspValidatedMapHolder.nodes[bspReferenceIndex]
    bspReferenceStoredNodeHolder.mins = bspReferenceNodeMinsProbe
    bspReferenceStoredNodeHolder.maxs = bspReferenceNodeMaxsProbe
    if bspReferenceNodeRecord.planeIndex < 0 or bspReferenceNodeRecord.planeIndex >= len(bspValidatedMapHolder.planes) then return error(2212, "node plane outside table") end if
    bspReferenceIndex = bspReferenceIndex + 1
  end while
  bspReferenceIndex = 0
  while bspReferenceIndex < len(bspValidatedMapHolder.brushes)
    bspReferenceBrushRecord = bspValidatedMapHolder.brushes[bspReferenceIndex]
    if typeof(bspReferenceBrushRecord) != "struct" then return error(2218, "brush record is unavailable") end if
    if bspReferenceBrushRecord.firstSide < 0 or bspReferenceBrushRecord.numSides < 0 or bspReferenceBrushRecord.firstSide > len(bspValidatedMapHolder.brushSides) or bspReferenceBrushRecord.numSides > len(bspValidatedMapHolder.brushSides) - bspReferenceBrushRecord.firstSide then
      return error(2213, "brush side range outside table")
    end if
    bspReferenceIndex = bspReferenceIndex + 1
  end while
  bspReferenceIndex = 0
  while bspReferenceIndex < len(bspValidatedMapHolder.brushSides)
    bspReferenceBrushSideRecord = bspValidatedMapHolder.brushSides[bspReferenceIndex]
    if typeof(bspReferenceBrushSideRecord) != "struct" then return error(2219, "brush side record is unavailable") end if
    if bspReferenceBrushSideRecord.planeIndex < 0 or bspReferenceBrushSideRecord.planeIndex >= len(bspValidatedMapHolder.planes) then return error(2220, "brush side plane outside table") end if
    bspReferenceIndex = bspReferenceIndex + 1
  end while
  return true
end function

function parse(data, name)
  bspParseDataHolder = data
  bspParseMapNameHolder = name
  bspParseLumpsHolder = parseLumps(bspParseDataHolder)
  bspParseEntityLumpHolder = bspParseLumpsHolder[fc.LUMP_ENTITIES]
  bspParseEntityTextHolder = ""
  if bspParseEntityLumpHolder.length > 0 then
    bspParseEntityBytesHolder = slice(bspParseDataHolder, bspParseEntityLumpHolder.offset, bspParseEntityLumpHolder.length)
    bspParseEntityTextHolder = decode(bspParseEntityBytesHolder)
    if bspParseEntityTextHolder is void then return error(2214, "invalid entity text") end if
  end if
  bspParsePlaneLumpHolder = bspParseLumpsHolder[fc.LUMP_PLANES]
  bspParseVertexLumpHolder = bspParseLumpsHolder[fc.LUMP_VERTEXES]
  bspParseVisibilityLumpHolder = bspParseLumpsHolder[fc.LUMP_VISIBILITY]
  bspParseNodeLumpHolder = bspParseLumpsHolder[fc.LUMP_NODES]
  bspParseTexInfoLumpHolder = bspParseLumpsHolder[fc.LUMP_TEXINFO]
  bspParseFaceLumpHolder = bspParseLumpsHolder[fc.LUMP_FACES]
  bspParseLightingLumpHolder = bspParseLumpsHolder[fc.LUMP_LIGHTING]
  bspParseLeafLumpHolder = bspParseLumpsHolder[fc.LUMP_LEAFS]
  bspParseLeafFaceLumpHolder = bspParseLumpsHolder[fc.LUMP_LEAFFACES]
  bspParseLeafBrushLumpHolder = bspParseLumpsHolder[fc.LUMP_LEAFBRUSHES]
  bspParseEdgeLumpHolder = bspParseLumpsHolder[fc.LUMP_EDGES]
  bspParseSurfaceEdgeLumpHolder = bspParseLumpsHolder[fc.LUMP_SURFEDGES]
  bspParseModelLumpHolder = bspParseLumpsHolder[fc.LUMP_MODELS]
  bspParseBrushLumpHolder = bspParseLumpsHolder[fc.LUMP_BRUSHES]
  bspParseBrushSideLumpHolder = bspParseLumpsHolder[fc.LUMP_BRUSHSIDES]
  bspParseAreaLumpHolder = bspParseLumpsHolder[fc.LUMP_AREAS]
  bspParseAreaPortalLumpHolder = bspParseLumpsHolder[fc.LUMP_AREAPORTALS]
  bspParsePlanesHolder = parsePlanes(bspParseDataHolder, bspParsePlaneLumpHolder)
  bspParseVerticesHolder = parseVertices(bspParseDataHolder, bspParseVertexLumpHolder)
  bspParseVisibilityHolder = parseVisibility(bspParseDataHolder, bspParseVisibilityLumpHolder)
  bspParseNodesHolder = parseNodes(bspParseDataHolder, bspParseNodeLumpHolder)
  bspParseTexInfoHolder = parseTexInfo(bspParseDataHolder, bspParseTexInfoLumpHolder)
  bspParseFacesHolder = parseFaces(bspParseDataHolder, bspParseFaceLumpHolder)
  bspParseLightingOffset = bspParseLightingLumpHolder.offset
  bspParseLightingLength = bspParseLightingLumpHolder.length
  bspParseLightingHolder = slice(bspParseDataHolder, bspParseLightingOffset, bspParseLightingLength)
  bspParseLeafsHolder = parseLeafs(bspParseDataHolder, bspParseLeafLumpHolder)
  bspParseLeafFacesHolder = parseU16Array(bspParseDataHolder, bspParseLeafFaceLumpHolder, "leafface")
  bspParseLeafBrushesHolder = parseU16Array(bspParseDataHolder, bspParseLeafBrushLumpHolder, "leafbrush")
  bspParseEdgesHolder = parseEdges(bspParseDataHolder, bspParseEdgeLumpHolder)
  bspParseSurfaceEdgesHolder = parseI32Array(bspParseDataHolder, bspParseSurfaceEdgeLumpHolder, "surfedge")
  bspParseModelsHolder = parseModels(bspParseDataHolder, bspParseModelLumpHolder)
  bspParseBrushesHolder = parseBrushes(bspParseDataHolder, bspParseBrushLumpHolder)
  bspParseBrushSidesHolder = parseBrushSides(bspParseDataHolder, bspParseBrushSideLumpHolder)
  bspParseAreasHolder = parseAreas(bspParseDataHolder, bspParseAreaLumpHolder)
  bspParseAreaPortalsHolder = parseAreaPortals(bspParseDataHolder, bspParseAreaPortalLumpHolder)
  bspParsedMapRecord = ft.BspMap(
    bspParseMapNameHolder,
    bspParseDataHolder,
    bspParseLumpsHolder,
    bspParseEntityTextHolder,
    bspParsePlanesHolder,
    bspParseVerticesHolder,
    bspParseVisibilityHolder,
    bspParseNodesHolder,
    bspParseTexInfoHolder,
    bspParseFacesHolder,
    bspParseLightingHolder,
    bspParseLeafsHolder,
    bspParseLeafFacesHolder,
    bspParseLeafBrushesHolder,
    bspParseEdgesHolder,
    bspParseSurfaceEdgesHolder,
    bspParseModelsHolder,
    bspParseBrushesHolder,
    bspParseBrushSidesHolder,
    bspParseAreasHolder,
    bspParseAreaPortalsHolder,
  )
  // Repeat every managed child after construction so the full-product graph's
  // generational write barrier observes the complete persistent BSP object.
  bspParsedMapRecord.name = bspParseMapNameHolder
  bspParsedMapRecord.data = bspParseDataHolder
  bspParsedMapRecord.lumps = bspParseLumpsHolder
  bspParsedMapRecord.entityText = bspParseEntityTextHolder
  bspParsedMapRecord.planes = bspParsePlanesHolder
  bspParsedMapRecord.vertices = bspParseVerticesHolder
  bspParsedMapRecord.visibility = bspParseVisibilityHolder
  bspParsedMapRecord.nodes = bspParseNodesHolder
  bspParsedMapRecord.texInfo = bspParseTexInfoHolder
  bspParsedMapRecord.faces = bspParseFacesHolder
  bspParsedMapRecord.lighting = bspParseLightingHolder
  bspParsedMapRecord.leafs = bspParseLeafsHolder
  bspParsedMapRecord.leafFaces = bspParseLeafFacesHolder
  bspParsedMapRecord.leafBrushes = bspParseLeafBrushesHolder
  bspParsedMapRecord.edges = bspParseEdgesHolder
  bspParsedMapRecord.surfaceEdges = bspParseSurfaceEdgesHolder
  bspParsedMapRecord.models = bspParseModelsHolder
  bspParsedMapRecord.brushes = bspParseBrushesHolder
  bspParsedMapRecord.brushSides = bspParseBrushSidesHolder
  bspParsedMapRecord.areas = bspParseAreasHolder
  bspParsedMapRecord.areaPortals = bspParseAreaPortalsHolder
  validateReferences(bspParsedMapRecord)
  return bspParsedMapRecord
end function
