# `src/miniquake2/collision/model.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 collision model facilities for this project.

Package: [`miniquake2.collision.model`](Package-miniquake2-collision-model-1746035802.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/format/bsp.ml` as `cbsp` → [src/miniquake2/format/bsp.ml](File-src-miniquake2-format-bsp-ml-2080213539.md)
- `miniquake2/format/types.ml` as `ft` → [src/miniquake2/format/types.ml](File-src-miniquake2-format-types-ml-129451131.md)

## Declarations

<a id="function-function-miniquake2-collision-model-areasconnected-function-areasconnected-model-firstarea-secondarea-src-miniquake2-collision-model-ml-1994032247"></a>
### areasConnected

```ml
function areasConnected(model, firstArea, secondArea)
```

Report whether areas connected.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `model` | `dynamic` | — | model value consumed by this operation. |
| `firstArea` | `dynamic` | — | firstArea value consumed by this operation. |
| `secondArea` | `dynamic` | — | secondArea value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/collision/model.ml#L784)

<a id="function-function-miniquake2-collision-model-boxleafnumbers-function-boxleafnumbers-model-mins-maxs-headnode-src-miniquake2-collision-model-ml-444843419"></a>
### boxLeafNumbers

```ml
function boxLeafNumbers(model, mins, maxs, headNode)
```

Return the box leaf numbers value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `model` | `dynamic` | — | model value consumed by this operation. |
| `mins` | `dynamic` | — | mins value consumed by this operation. |
| `maxs` | `dynamic` | — | maxs value consumed by this operation. |
| `headNode` | `dynamic` | — | headNode value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/collision/model.ml#L297)

<a id="function-function-miniquake2-collision-model-boxonplaneside-function-boxonplaneside-mins-maxs-plane-src-miniquake2-collision-model-ml-1627788596"></a>
### boxOnPlaneSide

```ml
function boxOnPlaneSide(mins, maxs, plane)
```

Report whether box on plane side.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mins` | `dynamic` | — | mins value consumed by this operation. |
| `maxs` | `dynamic` | — | maxs value consumed by this operation. |
| `plane` | `dynamic` | — | plane value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/collision/model.ml#L244)

<a id="function-function-miniquake2-collision-model-boxtrace-function-boxtrace-model-start-finish-mins-maxs-headnode-brushmask-src-miniquake2-collision-model-ml-836019620"></a>
### boxTrace

```ml
function boxTrace(model, start, finish, mins, maxs, headNode, brushMask)
```

Trace box.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `model` | `dynamic` | — | model value consumed by this operation. |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `finish` | `dynamic` | — | finish value consumed by this operation. |
| `mins` | `dynamic` | — | mins value consumed by this operation. |
| `maxs` | `dynamic` | — | maxs value consumed by this operation. |
| `headNode` | `dynamic` | — | headNode value consumed by this operation. |
| `brushMask` | `dynamic` | — | brushMask value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/collision/model.ml#L683)

<a id="function-function-miniquake2-collision-model-clearvisibilityrows-function-clearvisibilityrows-model-src-miniquake2-collision-model-ml-1742538619"></a>
### clearVisibilityRows

```ml
function clearVisibilityRows(model)
```

Clear visibility rows.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `model` | `dynamic` | — | model value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/collision/model.ml#L223)

<a id="function-function-miniquake2-collision-model-clipboxtobrush-inline-function-clipboxtobrush-model-mins-maxs-start-finish-trace-brush-src-miniquake2-collision-model-ml-1375849634"></a>
### clipBoxToBrush

```ml
inline function clipBoxToBrush(model, mins, maxs, start, finish, trace, brush)
```

Clip box to brush.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `model` | `dynamic` | — | model value consumed by this operation. |
| `mins` | `dynamic` | — | mins value consumed by this operation. |
| `maxs` | `dynamic` | — | maxs value consumed by this operation. |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `finish` | `dynamic` | — | finish value consumed by this operation. |
| `trace` | `dynamic` | — | trace value consumed by this operation. |
| `brush` | `dynamic` | — | brush value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/collision/model.ml#L355)

<a id="function-function-miniquake2-collision-model-collectboxleafs-function-collectboxleafs-model-nodenumber-mins-maxs-output-count-src-miniquake2-collision-model-ml-1208552702"></a>
### collectBoxLeafs

```ml
function collectBoxLeafs(model, nodeNumber, mins, maxs, output, count)
```

Collect box leafs.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `model` | `dynamic` | — | model value consumed by this operation. |
| `nodeNumber` | `dynamic` | — | nodeNumber value consumed by this operation. |
| `mins` | `dynamic` | — | mins value consumed by this operation. |
| `maxs` | `dynamic` | — | maxs value consumed by this operation. |
| `output` | `dynamic` | — | Output collection or buffer populated by the operation. |
| `count` | `dynamic` | — | Number of items or units to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/collision/model.ml#L275)

- [miniquake2.collision.model.CollisionModel](Type-miniquake2-collision-model-collisionmodel-1951780449.md) — struct
- [miniquake2.collision.model.CollisionSurface](Type-miniquake2-collision-model-collisionsurface-1699466447.md) — struct
<a id="function-function-miniquake2-collision-model-component-function-component-value-axis-src-miniquake2-collision-model-ml-1408136538"></a>
### component

```ml
function component(value, axis)
```

Return the component value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `axis` | `dynamic` | — | axis value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/collision/model.ml#L130)

<a id="function-function-miniquake2-collision-model-create-function-create-map-src-miniquake2-collision-model-ml-1289074658"></a>
### create

```ml
function create(map)
```

Creates create for the miniquake2 collision model module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `map` | `dynamic` | — | map value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/collision/model.ml#L139)

<a id="constant-constant-miniquake2-collision-model-dist-epsilon-const-dist-epsilon-3-125e-002-src-miniquake2-collision-model-ml-39884880"></a>
### DIST_EPSILON

```ml
const DIST_EPSILON = 3.125e-002
```

Defines the dist epsilon constant used by the miniquake2 collision model module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/collision/model.ml#L18)

<a id="function-function-miniquake2-collision-model-dot-function-dot-a-b-src-miniquake2-collision-model-ml-1832492179"></a>
### dot

```ml
function dot(a, b)
```

Performs the dot operation for the miniquake2 collision model module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | a value consumed by this operation. |
| `b` | `dynamic` | — | b value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/collision/model.ml#L119)

<a id="function-function-miniquake2-collision-model-floodarea-function-floodarea-model-areanumber-floodnumber-src-miniquake2-collision-model-ml-1437546512"></a>
### floodArea

```ml
function floodArea(model, areaNumber, floodNumber)
```

Return the flood area value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `model` | `dynamic` | — | model value consumed by this operation. |
| `areaNumber` | `dynamic` | — | areaNumber value consumed by this operation. |
| `floodNumber` | `dynamic` | — | floodNumber value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/collision/model.ml#L739)

<a id="function-function-miniquake2-collision-model-floodareas-function-floodareas-model-src-miniquake2-collision-model-ml-1625311679"></a>
### floodAreas

```ml
function floodAreas(model)
```

Return the flood areas value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `model` | `dynamic` | — | model value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/collision/model.ml#L758)

<a id="function-function-miniquake2-collision-model-hullcheck-function-hullcheck-model-headnode-startx-starty-startz-finishx-finishy-finishz-mins-maxs-start-finish-brushmask-trace-checkcount-ispoint-extentx-extenty-extentz-src-miniquake2-collision-model-ml-73088854"></a>
### hullCheck

```ml
function hullCheck(model, headNode, startX, startY, startZ, finishX, finishY, finishZ, mins, maxs, start, finish, brushMask, trace, checkCount, isPoint, extentX, extentY, extentZ)
```

Quake II CM_RecursiveHullCheck as an allocation-free iterative DFS. A MiniLang function call carries dynamic values, so the original C recursion is substantially more expensive here. The preallocated per-map stack keeps identical near-before-far BSP traversal and fraction pruning semantics.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `model` | `dynamic` | — | model value consumed by this operation. |
| `headNode` | `dynamic` | — | headNode value consumed by this operation. |
| `startX` | `dynamic` | — | startX value consumed by this operation. |
| `startY` | `dynamic` | — | startY value consumed by this operation. |
| `startZ` | `dynamic` | — | startZ value consumed by this operation. |
| `finishX` | `dynamic` | — | finishX value consumed by this operation. |
| `finishY` | `dynamic` | — | finishY value consumed by this operation. |
| `finishZ` | `dynamic` | — | finishZ value consumed by this operation. |
| `mins` | `dynamic` | — | mins value consumed by this operation. |
| `maxs` | `dynamic` | — | maxs value consumed by this operation. |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `finish` | `dynamic` | — | finish value consumed by this operation. |
| `brushMask` | `dynamic` | — | brushMask value consumed by this operation. |
| `trace` | `dynamic` | — | trace value consumed by this operation. |
| `checkCount` | `dynamic` | — | Number of check to process. |
| `isPoint` | `dynamic` | — | isPoint value consumed by this operation. |
| `extentX` | `dynamic` | — | extentX value consumed by this operation. |
| `extentY` | `dynamic` | — | extentY value consumed by this operation. |
| `extentZ` | `dynamic` | — | extentZ value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/collision/model.ml#L555)

<a id="function-function-miniquake2-collision-model-makedefaulttrace-function-makedefaulttrace-endposition-src-miniquake2-collision-model-ml-1945110154"></a>
### makeDefaultTrace

```ml
function makeDefaultTrace(endPosition)
```

Create default trace.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `endPosition` | `dynamic` | — | endPosition value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/collision/model.ml#L313)

<a id="function-function-miniquake2-collision-model-maxvalue-function-maxvalue-a-b-src-miniquake2-collision-model-ml-1711432201"></a>
### maxValue

```ml
function maxValue(a, b)
```

Return the max value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | a value consumed by this operation. |
| `b` | `dynamic` | — | b value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/collision/model.ml#L434)

<a id="function-function-miniquake2-collision-model-minvalue-function-minvalue-a-b-src-miniquake2-collision-model-ml-1402673149"></a>
### minValue

```ml
function minValue(a, b)
```

Return the min value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | a value consumed by this operation. |
| `b` | `dynamic` | — | b value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/collision/model.ml#L426)

<a id="function-function-miniquake2-collision-model-offsetdistance-function-offsetdistance-plane-mins-maxs-src-miniquake2-collision-model-ml-293856340"></a>
### offsetDistance

```ml
function offsetDistance(plane, mins, maxs)
```

Return the offset distance value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `plane` | `dynamic` | — | plane value consumed by this operation. |
| `mins` | `dynamic` | — | mins value consumed by this operation. |
| `maxs` | `dynamic` | — | maxs value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/collision/model.ml#L325)

<a id="function-function-miniquake2-collision-model-pointcontents-function-pointcontents-model-point-headnode-src-miniquake2-collision-model-ml-2074855945"></a>
### pointContents

```ml
function pointContents(model, point, headNode)
```

Performs the pointContents operation for the miniquake2 collision model module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `model` | `dynamic` | — | model value consumed by this operation. |
| `point` | `dynamic` | — | point value consumed by this operation. |
| `headNode` | `dynamic` | — | headNode value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/collision/model.ml#L234)

<a id="function-function-miniquake2-collision-model-pointleafnumber-function-pointleafnumber-model-point-headnode-src-miniquake2-collision-model-ml-1302351967"></a>
### pointLeafNumber

```ml
function pointLeafNumber(model, point, headNode)
```

Return the point leaf number.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `model` | `dynamic` | — | model value consumed by this operation. |
| `point` | `dynamic` | — | point value consumed by this operation. |
| `headNode` | `dynamic` | — | headNode value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/collision/model.ml#L175)

<a id="function-function-miniquake2-collision-model-requirecollisionvector-function-requirecollisionvector-value-operation-src-miniquake2-collision-model-ml-1327109982"></a>
### requireCollisionVector

```ml
function requireCollisionVector(value, operation)
```

Require collision vector.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `operation` | `dynamic` | — | operation value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/collision/model.ml#L111)

<a id="function-function-miniquake2-collision-model-setareaportalstate-function-setareaportalstate-model-portalnumber-isopen-src-miniquake2-collision-model-ml-280285258"></a>
### setAreaPortalState

```ml
function setAreaPortalState(model, portalNumber, isOpen)
```

Set area portal state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `model` | `dynamic` | — | model value consumed by this operation. |
| `portalNumber` | `dynamic` | — | portalNumber value consumed by this operation. |
| `isOpen` | `dynamic` | — | isOpen value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/collision/model.ml#L773)

<a id="function-function-miniquake2-collision-model-surfaceforside-function-surfaceforside-model-side-src-miniquake2-collision-model-ml-1083118358"></a>
### surfaceForSide

```ml
function surfaceForSide(model, side)
```

Return the surface for side value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `model` | `dynamic` | — | model value consumed by this operation. |
| `side` | `dynamic` | — | side value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/collision/model.ml#L341)

<a id="function-function-miniquake2-collision-model-testboxinbrush-inline-function-testboxinbrush-model-mins-maxs-start-trace-brush-src-miniquake2-collision-model-ml-62125639"></a>
### testBoxInBrush

```ml
inline function testBoxInBrush(model, mins, maxs, start, trace, brush)
```

Exact CM_TestBoxInBrush position test. Swept traces use the recursive BSP hull walk below; a stationary hull must instead visit every leaf touched by its expanded bounds and test whether the complete box starts in a brush.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `model` | `dynamic` | — | model value consumed by this operation. |
| `mins` | `dynamic` | — | mins value consumed by this operation. |
| `maxs` | `dynamic` | — | maxs value consumed by this operation. |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `trace` | `dynamic` | — | trace value consumed by this operation. |
| `brush` | `dynamic` | — | brush value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/collision/model.ml#L448)

<a id="function-function-miniquake2-collision-model-testinleaf-function-testinleaf-model-leafnumber-mins-maxs-start-brushmask-trace-checkcount-src-miniquake2-collision-model-ml-621896464"></a>
### testInLeaf

```ml
function testInLeaf(model, leafNumber, mins, maxs, start, brushMask, trace, checkCount)
```

Verify in leaf.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `model` | `dynamic` | — | model value consumed by this operation. |
| `leafNumber` | `dynamic` | — | leafNumber value consumed by this operation. |
| `mins` | `dynamic` | — | mins value consumed by this operation. |
| `maxs` | `dynamic` | — | maxs value consumed by this operation. |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `brushMask` | `dynamic` | — | brushMask value consumed by this operation. |
| `trace` | `dynamic` | — | trace value consumed by this operation. |
| `checkCount` | `dynamic` | — | Number of check to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/collision/model.ml#L482)

- [miniquake2.collision.model.Trace](Type-miniquake2-collision-model-trace-1604305597.md) — struct
- [miniquake2.collision.model.TracePlane](Type-miniquake2-collision-model-traceplane-73884573.md) — struct
<a id="function-function-miniquake2-collision-model-tracetoleaf-inline-function-tracetoleaf-model-leafnumber-mins-maxs-start-finish-brushmask-trace-checkcount-src-miniquake2-collision-model-ml-810049874"></a>
### traceToLeaf

```ml
inline function traceToLeaf(model, leafNumber, mins, maxs, start, finish, brushMask, trace, checkCount)
```

Exact CM_TraceToLeaf brush filtering with a generation table instead of clearing/copying a brush array for every trace.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `model` | `dynamic` | — | model value consumed by this operation. |
| `leafNumber` | `dynamic` | — | leafNumber value consumed by this operation. |
| `mins` | `dynamic` | — | mins value consumed by this operation. |
| `maxs` | `dynamic` | — | maxs value consumed by this operation. |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `finish` | `dynamic` | — | finish value consumed by this operation. |
| `brushMask` | `dynamic` | — | brushMask value consumed by this operation. |
| `trace` | `dynamic` | — | trace value consumed by this operation. |
| `checkCount` | `dynamic` | — | Number of check to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/collision/model.ml#L512)

<a id="function-function-miniquake2-collision-model-vec3-function-vec3-x-y-z-src-miniquake2-collision-model-ml-1269137817"></a>
### vec3

```ml
function vec3(x, y, z)
```

Return the vec 3 value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `z` | `dynamic` | — | z value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/collision/model.ml#L104)

<a id="function-function-miniquake2-collision-model-visibilityrow-function-visibilityrow-model-cluster-kind-src-miniquake2-collision-model-ml-285232949"></a>
### visibilityRow

```ml
function visibilityRow(model, cluster, kind)
```

BSP visibility lumps are immutable after load in the product. Cache each decompressed cluster row once, matching the original engine's pointer-like visibility access instead of rebuilding RLE output for every entity/sound.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `model` | `dynamic` | — | model value consumed by this operation. |
| `cluster` | `dynamic` | — | cluster value consumed by this operation. |
| `kind` | `dynamic` | — | kind value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/collision/model.ml#L205)

<a id="function-function-miniquake2-collision-model-writeareabits-function-writeareabits-model-areanumber-src-miniquake2-collision-model-ml-1002792907"></a>
### writeAreaBits

```ml
function writeAreaBits(model, areaNumber)
```

Write area bits.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `model` | `dynamic` | — | model value consumed by this operation. |
| `areaNumber` | `dynamic` | — | areaNumber value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/collision/model.ml#L792)
