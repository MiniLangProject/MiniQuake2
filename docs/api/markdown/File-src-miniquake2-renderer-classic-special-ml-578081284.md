# `src/miniquake2/renderer/classic/special.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 renderer classic special facilities for this project.

Package: [`miniquake2.renderer.classic.special`](Package-miniquake2-renderer-classic-special-247843555.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/format/constants.ml` as `rspecialformatconstants` → [src/miniquake2/format/constants.ml](File-src-miniquake2-format-constants-ml-1556940367.md)
- `miniquake2/format/types.ml` as `rspecialformattypes` → [src/miniquake2/format/types.ml](File-src-miniquake2-format-types-ml-129451131.md)
- `miniquake2/qcommon/byteio.ml` as `rspecialbyteio` → [src/miniquake2/qcommon/byteio.ml](File-src-miniquake2-qcommon-byteio-ml-159119335.md)
- `miniquake2/renderer/classic/constants.ml` as `rclassicconstants` → [src/miniquake2/renderer/classic/constants.ml](File-src-miniquake2-renderer-classic-constants-ml-1818163902.md)
- `miniquake2/renderer/classic/surfaces.ml` as `rclassicsurfaces` → [src/miniquake2/renderer/classic/surfaces.ml](File-src-miniquake2-renderer-classic-surfaces-ml-1888445105.md)
- `miniquake2/renderer/classic/types.ml` as `rclassictypes` → [src/miniquake2/renderer/classic/types.ml](File-src-miniquake2-renderer-classic-types-ml-1346078158.md)
- `std/array.ml` as `rspecialarray` → `../MiniLangCompilerML/std/array.ml` — external dependency
- `std/math.ml` as `rspecialmath` → `../MiniLangCompilerML/std/math.ml` — external dependency

## Declarations

<a id="function-function-miniquake2-renderer-classic-special-classicspecialbasetexture-inline-function-classicspecialbasetexture-draw-time-src-miniquake2-renderer-classic-special-ml-100970173"></a>
### classicSpecialBaseTexture

```ml
inline function classicSpecialBaseTexture(draw, time)
```

Return the classic special base texture value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `draw` | `dynamic` | — | draw value consumed by this operation. |
| `time` | `dynamic` | — | time value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/special.ml#L93)

<a id="function-function-miniquake2-renderer-classic-special-classicspecialbasetextureframe-inline-function-classicspecialbasetextureframe-draw-frame-src-miniquake2-renderer-classic-special-ml-1197046107"></a>
### classicSpecialBaseTextureFrame

```ml
inline function classicSpecialBaseTextureFrame(draw, frame)
```

Resolve an animated texture from the owning entity frame. World callers use time*2; inline brush entities pass their server-controlled entity.frame.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `draw` | `dynamic` | — | draw value consumed by this operation. |
| `frame` | `dynamic` | — | frame value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/special.ml#L102)

<a id="function-function-miniquake2-renderer-classic-special-classicspecialbounds-function-classicspecialbounds-positions-src-miniquake2-renderer-classic-special-ml-1370963415"></a>
### classicSpecialBounds

```ml
function classicSpecialBounds(positions)
```

Return the classic special bounds.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `positions` | `dynamic` | — | positions value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/special.ml#L138)

<a id="function-function-miniquake2-renderer-classic-special-classicspecialdistancesquared-function-classicspecialdistancesquared-draw-origin-src-miniquake2-renderer-classic-special-ml-1495596703"></a>
### classicSpecialDistanceSquared

```ml
function classicSpecialDistanceSquared(draw, origin)
```

Return the classic special distance squared value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `draw` | `dynamic` | — | draw value consumed by this operation. |
| `origin` | `dynamic` | — | origin value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/special.ml#L279)

<a id="function-function-miniquake2-renderer-classic-special-classicspecialdrawvertices-function-classicspecialdrawvertices-surface-src-miniquake2-renderer-classic-special-ml-1701656512"></a>
### classicSpecialDrawVertices

```ml
function classicSpecialDrawVertices(surface)
```

Draw classic special vertices.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `surface` | `dynamic` | — | surface value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/special.ml#L271)

<a id="function-function-miniquake2-renderer-classic-special-classicspecialfan-function-classicspecialfan-surface-positions-src-miniquake2-renderer-classic-special-ml-4394228"></a>
### classicSpecialFan

```ml
function classicSpecialFan(surface, positions)
```

Return the classic special fan value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `surface` | `dynamic` | — | surface value consumed by this operation. |
| `positions` | `dynamic` | — | positions value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/special.ml#L212)

<a id="function-function-miniquake2-renderer-classic-special-classicspecialflowscroll-function-classicspecialflowscroll-time-src-miniquake2-renderer-classic-special-ml-456434788"></a>
### classicSpecialFlowScroll

```ml
function classicSpecialFlowScroll(time)
```

Return the classic special flow scroll value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `time` | `dynamic` | — | time value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/special.ml#L34)

<a id="function-function-miniquake2-renderer-classic-special-classicspecialinterpolate-function-classicspecialinterpolate-first-second-fraction-src-miniquake2-renderer-classic-special-ml-496024811"></a>
### classicSpecialInterpolate

```ml
function classicSpecialInterpolate(first, second, fraction)
```

Interpolate classic special.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `dynamic` | — | first value consumed by this operation. |
| `second` | `dynamic` | — | second value consumed by this operation. |
| `fraction` | `dynamic` | — | fraction value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/special.ml#L160)

<a id="function-function-miniquake2-renderer-classic-special-classicspecialpassplan-function-classicspecialpassplan-draws-frame-src-miniquake2-renderer-classic-special-ml-60963245"></a>
### classicSpecialPassPlan

```ml
function classicSpecialPassPlan(draws, frame)
```

Return the classic special pass plan value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `draws` | `dynamic` | — | draws value consumed by this operation. |
| `frame` | `dynamic` | — | frame value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/special.ml#L413)

<a id="function-function-miniquake2-renderer-classic-special-classicspecialpassplanorigin-function-classicspecialpassplanorigin-draws-vieworigin-src-miniquake2-renderer-classic-special-ml-677171103"></a>
### classicSpecialPassPlanOrigin

```ml
function classicSpecialPassPlanOrigin(draws, viewOrigin)
```

Return the classic special pass plan origin.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `draws` | `dynamic` | — | draws value consumed by this operation. |
| `viewOrigin` | `dynamic` | — | viewOrigin value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/special.ml#L406)

<a id="function-function-miniquake2-renderer-classic-special-classicspecialpassplanoriginprefix-function-classicspecialpassplanoriginprefix-draws-drawcount-vieworigin-src-miniquake2-renderer-classic-special-ml-1555399266"></a>
### classicSpecialPassPlanOriginPrefix

```ml
function classicSpecialPassPlanOriginPrefix(draws, drawCount, viewOrigin)
```

Return the classic special pass plan origin.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `draws` | `dynamic` | — | draws value consumed by this operation. |
| `drawCount` | `dynamic` | — | Number of draw to process. |
| `viewOrigin` | `dynamic` | — | viewOrigin value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/special.ml#L322)

<a id="function-function-miniquake2-renderer-classic-special-classicspecialpassplanoriginprefixinto-function-classicspecialpassplanoriginprefixinto-draws-drawcount-vieworigin-scratch-src-miniquake2-renderer-classic-special-ml-1907676452"></a>
### classicSpecialPassPlanOriginPrefixInto

```ml
function classicSpecialPassPlanOriginPrefixInto(draws, drawCount, viewOrigin, scratch)
```

Split a visible prefix into caller-owned capacity arrays without allocation.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `draws` | `dynamic` | — | draws value consumed by this operation. |
| `drawCount` | `dynamic` | — | Number of draw to process. |
| `viewOrigin` | `dynamic` | — | viewOrigin value consumed by this operation. |
| `scratch` | `dynamic` | — | scratch value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/special.ml#L379)

<a id="function-function-miniquake2-renderer-classic-special-classicspecialpasssignature-function-classicspecialpasssignature-plan-src-miniquake2-renderer-classic-special-ml-903460526"></a>
### classicSpecialPassSignature

```ml
function classicSpecialPassSignature(plan)
```

Return the classic special pass signature value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `plan` | `dynamic` | — | plan value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/special.ml#L419)

<a id="function-function-miniquake2-renderer-classic-special-classicspecialpositionaxis-function-classicspecialpositionaxis-position-axis-src-miniquake2-renderer-classic-special-ml-75007099"></a>
### classicSpecialPositionAxis

```ml
function classicSpecialPositionAxis(position, axis)
```

Return the classic special position axis value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `position` | `dynamic` | — | position value consumed by this operation. |
| `axis` | `dynamic` | — | axis value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/special.ml#L130)

<a id="function-function-miniquake2-renderer-classic-special-classicspecialsorttransparent-function-classicspecialsorttransparent-draws-origin-src-miniquake2-renderer-classic-special-ml-2018197576"></a>
### classicSpecialSortTransparent

```ml
function classicSpecialSortTransparent(draws, origin)
```

Sort classic special transparent.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `draws` | `dynamic` | — | draws value consumed by this operation. |
| `origin` | `dynamic` | — | origin value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/special.ml#L302)

<a id="function-function-miniquake2-renderer-classic-special-classicspecialsplitpolygon-function-classicspecialsplitpolygon-positions-axis-split-src-miniquake2-renderer-classic-special-ml-1167032382"></a>
### classicSpecialSplitPolygon

```ml
function classicSpecialSplitPolygon(positions, axis, split)
```

Split classic special polygon.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `positions` | `dynamic` | — | positions value consumed by this operation. |
| `axis` | `dynamic` | — | axis value consumed by this operation. |
| `split` | `dynamic` | — | split value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/special.ml#L172)

<a id="function-function-miniquake2-renderer-classic-special-classicspecialsubdivide-function-classicspecialsubdivide-surface-positions-src-miniquake2-renderer-classic-special-ml-544615496"></a>
### classicSpecialSubdivide

```ml
function classicSpecialSubdivide(surface, positions)
```

Return the classic special subdivide value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `surface` | `dynamic` | — | surface value consumed by this operation. |
| `positions` | `dynamic` | — | positions value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/special.ml#L236)

<a id="function-function-miniquake2-renderer-classic-special-classicspecialsurfacevertex-function-classicspecialsurfacevertex-surface-position-src-miniquake2-renderer-classic-special-ml-1359642707"></a>
### classicSpecialSurfaceVertex

```ml
function classicSpecialSurfaceVertex(surface, position)
```

Return the classic special surface vertex value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `surface` | `dynamic` | — | surface value consumed by this operation. |
| `position` | `dynamic` | — | position value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/special.ml#L203)

<a id="function-function-miniquake2-renderer-classic-special-classicspecialtexturecoordinates-function-classicspecialtexturecoordinates-draw-vertex-time-src-miniquake2-renderer-classic-special-ml-1801622476"></a>
### classicSpecialTextureCoordinates

```ml
function classicSpecialTextureCoordinates(draw, vertex, time)
```

Return the classic special texture coordinates value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `draw` | `dynamic` | — | draw value consumed by this operation. |
| `vertex` | `dynamic` | — | vertex value consumed by this operation. |
| `time` | `dynamic` | — | time value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/special.ml#L59)

<a id="function-function-miniquake2-renderer-classic-special-classicspecialtexturecoordinatesinto-function-classicspecialtexturecoordinatesinto-output-draw-vertex-time-src-miniquake2-renderer-classic-special-ml-1945971085"></a>
### classicSpecialTextureCoordinatesInto

```ml
function classicSpecialTextureCoordinatesInto(output, draw, vertex, time)
```

Write special coordinates into caller-owned scratch storage for the hot per-vertex renderer path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `output` | `dynamic` | — | Output collection or buffer populated by the operation. |
| `draw` | `dynamic` | — | draw value consumed by this operation. |
| `vertex` | `dynamic` | — | vertex value consumed by this operation. |
| `time` | `dynamic` | — | time value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/special.ml#L71)

<a id="function-function-miniquake2-renderer-classic-special-classicspecialtransparentbefore-function-classicspecialtransparentbefore-candidate-previous-origin-src-miniquake2-renderer-classic-special-ml-1546195913"></a>
### classicSpecialTransparentBefore

```ml
function classicSpecialTransparentBefore(candidate, previous, origin)
```

Return the classic special transparent before value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `candidate` | `dynamic` | — | candidate value consumed by this operation. |
| `previous` | `dynamic` | — | previous value consumed by this operation. |
| `origin` | `dynamic` | — | origin value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/special.ml#L291)

<a id="function-function-miniquake2-renderer-classic-special-classicspecialtrianglevertices-function-classicspecialtrianglevertices-surface-src-miniquake2-renderer-classic-special-ml-570205576"></a>
### classicSpecialTriangleVertices

```ml
function classicSpecialTriangleVertices(surface)
```

Return the classic special triangle vertices value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `surface` | `dynamic` | — | surface value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/special.ml#L111)

<a id="function-function-miniquake2-renderer-classic-special-classicspecialwarpsine-function-classicspecialwarpsine-value-src-miniquake2-renderer-classic-special-ml-858050902"></a>
### classicSpecialWarpSine

```ml
function classicSpecialWarpSine(value)
```

Return the classic special warp sine value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/special.ml#L50)

<a id="function-function-miniquake2-renderer-classic-special-classicspecialwarpvertices-function-classicspecialwarpvertices-surface-src-miniquake2-renderer-classic-special-ml-1259770016"></a>
### classicSpecialWarpVertices

```ml
function classicSpecialWarpVertices(surface)
```

Return the classic special warp vertices value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `surface` | `dynamic` | — | surface value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/special.ml#L259)

<a id="function-function-miniquake2-renderer-classic-special-classicspecialwaterscroll-function-classicspecialwaterscroll-time-src-miniquake2-renderer-classic-special-ml-97036202"></a>
### classicSpecialWaterScroll

```ml
function classicSpecialWaterScroll(time)
```

Return the classic special water scroll value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `time` | `dynamic` | — | time value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/special.ml#L43)

<a id="function-function-miniquake2-renderer-classic-special-createclassicspecialpassscratch-function-createclassicspecialpassscratch-capacity-src-miniquake2-renderer-classic-special-ml-614677813"></a>
### createClassicSpecialPassScratch

```ml
function createClassicSpecialPassScratch(capacity)
```

Create pass arrays once for a retained world or inline brush model.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `capacity` | `dynamic` | — | capacity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/special.ml#L369)

<a id="constant-constant-miniquake2-renderer-classic-special-special-pi2-const-special-pi2-6-28318530717959-src-miniquake2-renderer-classic-special-ml-2107189512"></a>
### SPECIAL_PI2

```ml
const SPECIAL_PI2 = 6.28318530717959
```

Defines the special pi2 constant used by the miniquake2 renderer classic special module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/special.ml#L24)

<a id="constant-constant-miniquake2-renderer-classic-special-special-subdivide-margin-const-special-subdivide-margin-8-src-miniquake2-renderer-classic-special-ml-837939456"></a>
### SPECIAL_SUBDIVIDE_MARGIN

```ml
const SPECIAL_SUBDIVIDE_MARGIN = 8.
```

Defines the special subdivide margin constant used by the miniquake2 renderer classic special module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/special.ml#L30)

<a id="constant-constant-miniquake2-renderer-classic-special-special-subdivide-size-const-special-subdivide-size-64-src-miniquake2-renderer-classic-special-ml-1877192958"></a>
### SPECIAL_SUBDIVIDE_SIZE

```ml
const SPECIAL_SUBDIVIDE_SIZE = 64.
```

Defines the special subdivide size constant used by the miniquake2 renderer classic special module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/special.ml#L28)

<a id="constant-constant-miniquake2-renderer-classic-special-special-turb-scale-const-special-turb-scale-40-7436654315252-src-miniquake2-renderer-classic-special-ml-1236128467"></a>
### SPECIAL_TURB_SCALE

```ml
const SPECIAL_TURB_SCALE = 40.7436654315252
```

Defines the special turb scale constant used by the miniquake2 renderer classic special module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/special.ml#L26)
