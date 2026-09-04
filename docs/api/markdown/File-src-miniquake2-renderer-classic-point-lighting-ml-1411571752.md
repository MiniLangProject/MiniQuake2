# `src/miniquake2/renderer/classic/point_lighting.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 renderer classic point lighting facilities for this project.

Package: [`miniquake2.renderer.classic.point_lighting`](Package-miniquake2-renderer-classic-point-lighting-1268320691.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/format/constants.ml` as `rpointfc` → [src/miniquake2/format/constants.ml](File-src-miniquake2-format-constants-ml-1556940367.md)
- `miniquake2/qcommon/byteio.ml` as `rpointbyteio` → [src/miniquake2/qcommon/byteio.ml](File-src-miniquake2-qcommon-byteio-ml-159119335.md)
- `miniquake2/renderer/classic/constants.ml` as `rpointconstants` → [src/miniquake2/renderer/classic/constants.ml](File-src-miniquake2-renderer-classic-constants-ml-1818163902.md)
- `miniquake2/renderer/classic/types.ml` as `rpointtypes` → [src/miniquake2/renderer/classic/types.ml](File-src-miniquake2-renderer-classic-types-ml-1346078158.md)
- `std/math.ml` as `rpointmath` → `../MiniLangCompilerML/std/math.ml` — external dependency

## Declarations

<a id="function-function-miniquake2-renderer-classic-point-lighting-dynamicpointlightsample-function-dynamicpointlightsample-world-frame-origin-staticsample-src-miniquake2-renderer-classic-point-lighting-ml-217375072"></a>
### dynamicPointLightSample

```ml
function dynamicPointLightSample(world, frame, origin, staticSample)
```

Add the current frame's dynamic lights to a copied static sample. Keeping the immutable BSP result separate lets alias renderers cache the expensive point trace while muzzle flashes and projectiles still affect every frame.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `world` | `dynamic` | — | world value consumed by this operation. |
| `frame` | `dynamic` | — | frame value consumed by this operation. |
| `origin` | `dynamic` | — | origin value consumed by this operation. |
| `staticSample` | `dynamic` | — | staticSample value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/point_lighting.ml#L208)

<a id="function-function-miniquake2-renderer-classic-point-lighting-emptypointsample-inline-function-emptypointsample-red-green-blue-src-miniquake2-renderer-classic-point-lighting-ml-393765244"></a>
### emptyPointSample

```ml
inline function emptyPointSample(red, green, blue)
```

Construct the no-hit or fullbright sample without temporary vector records.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `red` | `dynamic` | — | red value consumed by this operation. |
| `green` | `dynamic` | — | green value consumed by this operation. |
| `blue` | `dynamic` | — | blue value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/point_lighting.ml#L52)

<a id="function-function-miniquake2-renderer-classic-point-lighting-pointlight-function-pointlight-world-frame-origin-src-miniquake2-renderer-classic-point-lighting-ml-957310390"></a>
### pointLight

```ml
function pointLight(world, frame, origin)
```

Return the point light value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `world` | `dynamic` | — | world value consumed by this operation. |
| `frame` | `dynamic` | — | frame value consumed by this operation. |
| `origin` | `dynamic` | — | origin value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/point_lighting.ml#L250)

<a id="function-function-miniquake2-renderer-classic-point-lighting-pointlightsample-function-pointlightsample-world-frame-origin-src-miniquake2-renderer-classic-point-lighting-ml-566010370"></a>
### pointLightSample

```ml
function pointLightSample(world, frame, origin)
```

Sample point light.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `world` | `dynamic` | — | world value consumed by this operation. |
| `frame` | `dynamic` | — | frame value consumed by this operation. |
| `origin` | `dynamic` | — | origin value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/point_lighting.ml#L241)

<a id="function-function-miniquake2-renderer-classic-point-lighting-pointplanedistance-inline-function-pointplanedistance-x-y-z-plane-src-miniquake2-renderer-classic-point-lighting-ml-847012339"></a>
### pointPlaneDistance

```ml
inline function pointPlaneDistance(x, y, z, plane)
```

Return the point plane distance value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `z` | `dynamic` | — | z value consumed by this operation. |
| `plane` | `dynamic` | — | plane value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/point_lighting.ml#L21)

<a id="function-function-miniquake2-renderer-classic-point-lighting-pointprojected-inline-function-pointprojected-x-y-z-vector-src-miniquake2-renderer-classic-point-lighting-ml-1241570488"></a>
### pointProjected

```ml
inline function pointProjected(x, y, z, vector)
```

Return the point projected value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `z` | `dynamic` | — | z value consumed by this operation. |
| `vector` | `dynamic` | — | vector value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/point_lighting.ml#L34)

<a id="function-function-miniquake2-renderer-classic-point-lighting-pointstylergb-inline-function-pointstylergb-lightstyles-styleindex-src-miniquake2-renderer-classic-point-lighting-ml-1356114417"></a>
### pointStyleRgb

```ml
inline function pointStyleRgb(lightStyles, styleIndex)
```

Return the point style rgb value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `lightStyles` | `dynamic` | — | lightStyles value consumed by this operation. |
| `styleIndex` | `dynamic` | — | Zero-based index of style. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/point_lighting.ml#L41)

<a id="function-function-miniquake2-renderer-classic-point-lighting-staticpointlight-function-staticpointlight-world-lightstyles-origin-src-miniquake2-renderer-classic-point-lighting-ml-50709403"></a>
### staticPointLight

```ml
function staticPointLight(world, lightStyles, origin)
```

Return the static point light value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `world` | `dynamic` | — | world value consumed by this operation. |
| `lightStyles` | `dynamic` | — | lightStyles value consumed by this operation. |
| `origin` | `dynamic` | — | origin value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/point_lighting.ml#L193)

<a id="function-function-miniquake2-renderer-classic-point-lighting-staticpointlightsample-function-staticpointlightsample-world-lightstyles-origin-src-miniquake2-renderer-classic-point-lighting-ml-1655876635"></a>
### staticPointLightSample

```ml
function staticPointLightSample(world, lightStyles, origin)
```

Iterative equivalent of ref_gl RecursiveLightPoint. Each crossing saves one post-node surface check and far segment. ClassicWorld owns the fixed stacks, so every alias-light query remains allocation-free until its result is returned.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `world` | `dynamic` | — | world value consumed by this operation. |
| `lightStyles` | `dynamic` | — | lightStyles value consumed by this operation. |
| `origin` | `dynamic` | — | origin value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/point_lighting.ml#L63)
