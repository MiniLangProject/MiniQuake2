# `src/miniquake2/renderer/opengl.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 renderer opengl facilities for this project.

Package: [`miniquake2.renderer.opengl`](Package-miniquake2-renderer-opengl-480488577.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/format/constants.ml` as `ropenglformatconstants` → [src/miniquake2/format/constants.ml](File-src-miniquake2-format-constants-ml-1556940367.md)
- `miniquake2/format/pcx.ml` as `ropenglpcx` → [src/miniquake2/format/pcx.ml](File-src-miniquake2-format-pcx-ml-1818682253.md)
- `miniquake2/native.ml` as `native` → [src/miniquake2/native.ml](File-src-miniquake2-native-ml-139597585.md)
- `miniquake2/qcommon/byteio.ml` as `ropenglbyteio` → [src/miniquake2/qcommon/byteio.ml](File-src-miniquake2-qcommon-byteio-ml-159119335.md)
- `miniquake2/qcommon/directions.ml` as `ropengldirections` → [src/miniquake2/qcommon/directions.ml](File-src-miniquake2-qcommon-directions-ml-1980852047.md)
- `miniquake2/qcommon/types.ml` as `ropenglqtypes` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)
- `miniquake2/renderer/assets.ml` as `rassets` → [src/miniquake2/renderer/assets.ml](File-src-miniquake2-renderer-assets-ml-650889185.md)
- `miniquake2/renderer/classic/constants.ml` as `rclassicconstants` → [src/miniquake2/renderer/classic/constants.ml](File-src-miniquake2-renderer-classic-constants-ml-1818163902.md)
- `miniquake2/renderer/classic/lightmaps.ml` as `rclassiclightmaps` → [src/miniquake2/renderer/classic/lightmaps.ml](File-src-miniquake2-renderer-classic-lightmaps-ml-1607780996.md)
- `miniquake2/renderer/classic/point_lighting.ml` as `rclassicpointlighting` → [src/miniquake2/renderer/classic/point_lighting.ml](File-src-miniquake2-renderer-classic-point-lighting-ml-1411571752.md)
- `miniquake2/renderer/classic/special.ml` as `rclassicspecial` → [src/miniquake2/renderer/classic/special.ml](File-src-miniquake2-renderer-classic-special-ml-578081284.md)
- `miniquake2/renderer/classic/sprites.ml` as `rclassicsprites` → [src/miniquake2/renderer/classic/sprites.ml](File-src-miniquake2-renderer-classic-sprites-ml-1178218947.md)
- `miniquake2/renderer/classic/types.ml` as `rclassictypes` → [src/miniquake2/renderer/classic/types.ml](File-src-miniquake2-renderer-classic-types-ml-1346078158.md)
- `miniquake2/renderer/classic/visibility.ml` as `rclassicvisibility` → [src/miniquake2/renderer/classic/visibility.ml](File-src-miniquake2-renderer-classic-visibility-ml-1972680069.md)
- `miniquake2/renderer/classic/world.ml` as `rclassicworld` → [src/miniquake2/renderer/classic/world.ml](File-src-miniquake2-renderer-classic-world-ml-1807791993.md)
- `miniquake2/renderer/constants.ml` as `rc` → [src/miniquake2/renderer/constants.ml](File-src-miniquake2-renderer-constants-ml-1893707491.md)
- `miniquake2/renderer/geometry.ml` as `rgeom` → [src/miniquake2/renderer/geometry.ml](File-src-miniquake2-renderer-geometry-ml-1941312570.md)
- `miniquake2/renderer/recording.ml` as `recording` → [src/miniquake2/renderer/recording.ml](File-src-miniquake2-renderer-recording-ml-838772621.md)
- `miniquake2/renderer/types.ml` as `rt` → [src/miniquake2/renderer/types.ml](File-src-miniquake2-renderer-types-ml-975707623.md)
- `miniquake2/renderer/validation.ml` as `validation` → [src/miniquake2/renderer/validation.ml](File-src-miniquake2-renderer-validation-ml-96374779.md)
- `std/math.ml` as `rmath` → `../MiniLangCompilerML/std/math.ml` — external dependency

## Declarations

<a id="function-function-miniquake2-renderer-opengl-adoptclassicmapmodel-function-adoptclassicmapmodel-binding-map-path-src-miniquake2-renderer-opengl-ml-440310920"></a>
### adoptClassicMapModel

```ml
function adoptClassicMapModel(binding, map, path)
```

Map adopt classic model.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `binding` | `dynamic` | — | binding value consumed by this operation. |
| `map` | `dynamic` | — | map value consumed by this operation. |
| `path` | `dynamic` | — | Path of the file or directory used by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L4297)

<a id="function-function-miniquake2-renderer-opengl-allocatetexturerecord-function-allocatetexturerecord-backend-name-role-generation-width-height-src-miniquake2-renderer-opengl-ml-534161784"></a>
### allocateTextureRecord

```ml
function allocateTextureRecord(backend, name, role, generation, width, height)
```

Allocate texture record.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `backend` | `dynamic` | — | backend value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |
| `role` | `dynamic` | — | role value consumed by this operation. |
| `generation` | `dynamic` | — | generation value consumed by this operation. |
| `width` | `dynamic` | — | Width in the coordinate or storage units used by the caller. |
| `height` | `dynamic` | — | Height in the coordinate or storage units used by the caller. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L424)

<a id="function-function-miniquake2-renderer-opengl-appendclassictransparentdraws-function-appendclassictransparentdraws-output-count-draws-drawcount-entity-entityalpha-usesurfacealpha-vieworigin-src-miniquake2-renderer-opengl-ml-2068325501"></a>
### appendClassicTransparentDraws

```ml
function appendClassicTransparentDraws(output, count, draws, drawCount, entity, entityAlpha, useSurfaceAlpha, viewOrigin)
```

Append classic transparent draws.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `output` | `dynamic` | — | Output collection or buffer populated by the operation. |
| `count` | `dynamic` | — | Number of items or units to process. |
| `draws` | `dynamic` | — | draws value consumed by this operation. |
| `drawCount` | `dynamic` | — | Number of draw to process. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `entityAlpha` | `dynamic` | — | entityAlpha value consumed by this operation. |
| `useSurfaceAlpha` | `dynamic` | — | useSurfaceAlpha value consumed by this operation. |
| `viewOrigin` | `dynamic` | — | viewOrigin value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L3862)

<a id="function-function-miniquake2-renderer-opengl-backenddescription-function-backenddescription-binding-src-miniquake2-renderer-opengl-ml-936898979"></a>
### backendDescription

```ml
function backendDescription(binding)
```

Return the backend description value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `binding` | `dynamic` | — | binding value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L4271)

<a id="function-function-miniquake2-renderer-opengl-beginopenglmd2draw-function-beginopenglmd2draw-backend-skinasset-entity-frame-entityindex-src-miniquake2-renderer-opengl-ml-1482602956"></a>
### beginOpenGlMd2Draw

```ml
function beginOpenGlMd2Draw(backend, skinAsset, entity, frame, entityIndex)
```

Begin open gl md 2 draw.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `backend` | `dynamic` | — | backend value consumed by this operation. |
| `skinAsset` | `dynamic` | — | skinAsset value consumed by this operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `frame` | `dynamic` | — | frame value consumed by this operation. |
| `entityIndex` | `dynamic` | — | Zero-based index of entity. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L1556)

<a id="function-function-miniquake2-renderer-opengl-bits-inline-function-bits-value-src-miniquake2-renderer-opengl-ml-937407474"></a>
### bits

```ml
inline function bits(value)
```

Return the bits value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L413)

<a id="function-function-miniquake2-renderer-opengl-brightness-function-brightness-binding-src-miniquake2-renderer-opengl-ml-614152659"></a>
### brightness

```ml
function brightness(binding)
```

Return the post-composition brightness value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `binding` | `dynamic` | — | binding value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L2707)

<a id="function-function-miniquake2-renderer-opengl-buildopenglmd2shaderow-function-buildopenglmd2shaderow-rowindex-src-miniquake2-renderer-opengl-ml-334775366"></a>
### buildOpenGlMd2ShadeRow

```ml
function buildOpenGlMd2ShadeRow(rowIndex)
```

anormtab.h is generated from Quake II's 162 bytedirs. Keep the compact source normals as the single truth and lazily materialize only the sixteen 648-byte rows. Values are rounded to the original table's hundredths.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `rowIndex` | `dynamic` | — | Zero-based index of row. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L1487)

<a id="function-function-miniquake2-renderer-opengl-classicbrushdistancesquared-inline-function-classicbrushdistancesquared-submission-vieworigin-src-miniquake2-renderer-opengl-ml-327509626"></a>
### classicBrushDistanceSquared

```ml
inline function classicBrushDistanceSquared(submission, viewOrigin)
```

Return the classic brush distance squared value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `submission` | `dynamic` | — | submission value consumed by this operation. |
| `viewOrigin` | `dynamic` | — | viewOrigin value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L3370)

<a id="function-function-miniquake2-renderer-opengl-classicbrushdynamiclightmaps-function-classicbrushdynamiclightmaps-world-entity-plan-frame-src-miniquake2-renderer-opengl-ml-1435614821"></a>
### classicBrushDynamicLightmaps

```ml
function classicBrushDynamicLightmaps(world, entity, plan, frame)
```

Return the classic brush dynamic lightmaps value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `world` | `dynamic` | — | world value consumed by this operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `plan` | `dynamic` | — | plan value consumed by this operation. |
| `frame` | `dynamic` | — | frame value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L3544)

<a id="function-function-miniquake2-renderer-opengl-classicbrushdynamiclightmapsinto-function-classicbrushdynamiclightmapsinto-world-entity-brushmodel-plan-frame-src-miniquake2-renderer-opengl-ml-30077420"></a>
### classicBrushDynamicLightmapsInto

```ml
function classicBrushDynamicLightmapsInto(world, entity, brushModel, plan, frame)
```

Populate retained per-submission light and lightmap prefixes for the live OpenGL path. This removes the periodic array/wrapper graph produced by each visible door and lift while preserving exact headless diagnostics below.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `world` | `dynamic` | — | world value consumed by this operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `brushModel` | `dynamic` | — | brushModel value consumed by this operation. |
| `plan` | `dynamic` | — | plan value consumed by this operation. |
| `frame` | `dynamic` | — | frame value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L3519)

<a id="function-function-miniquake2-renderer-opengl-classicbrushframesignature-function-classicbrushframesignature-brushframe-src-miniquake2-renderer-opengl-ml-1586964029"></a>
### classicBrushFrameSignature

```ml
function classicBrushFrameSignature(brushFrame)
```

Return the classic brush frame signature value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `brushFrame` | `dynamic` | — | brushFrame value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L3665)

<a id="function-function-miniquake2-renderer-opengl-classicbrushlocallights-function-classicbrushlocallights-entity-frame-src-miniquake2-renderer-opengl-ml-273321744"></a>
### classicBrushLocalLights

```ml
function classicBrushLocalLights(entity, frame)
```

Return the classic brush local lights value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `frame` | `dynamic` | — | frame value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L3419)

<a id="function-function-miniquake2-renderer-opengl-classicbrushlocallightsinto-function-classicbrushlocallightsinto-entity-frame-brushmodel-src-miniquake2-renderer-opengl-ml-1738794719"></a>
### classicBrushLocalLightsInto

```ml
function classicBrushLocalLightsInto(entity, frame, brushModel)
```

Transform dynamic lights into one mover's local space using retained capacity storage. Only frame.numDLights entries form the active prefix.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `frame` | `dynamic` | — | frame value consumed by this operation. |
| `brushModel` | `dynamic` | — | brushModel value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L3436)

<a id="function-function-miniquake2-renderer-opengl-classicdrawcancache-inline-function-classicdrawcancache-draw-src-miniquake2-renderer-opengl-ml-810553333"></a>
### classicDrawCanCache

```ml
inline function classicDrawCanCache(draw)
```

Report whether classic draw can cache.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `draw` | `dynamic` | — | draw value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L2856)

<a id="function-function-miniquake2-renderer-opengl-classicdynamiclightmapfordraw-function-classicdynamiclightmapfordraw-world-draw-lightstyles-dlights-src-miniquake2-renderer-opengl-ml-1093173247"></a>
### classicDynamicLightmapForDraw

```ml
function classicDynamicLightmapForDraw(world, draw, lightStyles, dLights)
```

Rebuild one lightmap only when a style changed, a dynamic light affects the plane, or last frame's dynamic contribution must be removed.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `world` | `dynamic` | — | world value consumed by this operation. |
| `draw` | `dynamic` | — | draw value consumed by this operation. |
| `lightStyles` | `dynamic` | — | lightStyles value consumed by this operation. |
| `dLights` | `dynamic` | — | dLights value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L3466)

<a id="function-function-miniquake2-renderer-opengl-classicdynamiclightmapfordrawinto-function-classicdynamiclightmapfordrawinto-world-draw-lightstyles-dlights-dlightcount-retained-src-miniquake2-renderer-opengl-ml-506249034"></a>
### classicDynamicLightmapForDrawInto

```ml
function classicDynamicLightmapForDrawInto(world, draw, lightStyles, dLights, dLightCount, retained)
```

Rebuild one mover lightmap into a retained wrapper while observing only the active local-light prefix.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `world` | `dynamic` | — | world value consumed by this operation. |
| `draw` | `dynamic` | — | draw value consumed by this operation. |
| `lightStyles` | `dynamic` | — | lightStyles value consumed by this operation. |
| `dLights` | `dynamic` | — | dLights value consumed by this operation. |
| `dLightCount` | `dynamic` | — | Number of d light to process. |
| `retained` | `dynamic` | — | retained value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L3489)

<a id="function-function-miniquake2-renderer-opengl-classicinlinemodelindex-function-classicinlinemodelindex-modelasset-src-miniquake2-renderer-opengl-ml-1598345991"></a>
### classicInlineModelIndex

```ml
function classicInlineModelIndex(modelAsset)
```

Return the classic inline model index.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `modelAsset` | `dynamic` | — | modelAsset value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L3356)

<a id="function-function-miniquake2-renderer-opengl-classicregistrationassets-function-classicregistrationassets-binding-src-miniquake2-renderer-opengl-ml-1836226339"></a>
### classicRegistrationAssets

```ml
function classicRegistrationAssets(binding)
```

Return the CPU-side registration graph retained across a video mode change.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `binding` | `dynamic` | — | binding value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L2713)

<a id="function-function-miniquake2-renderer-opengl-classictransparentdistance-inline-function-classictransparentdistance-draw-entity-vieworigin-src-miniquake2-renderer-opengl-ml-512460381"></a>
### classicTransparentDistance

```ml
inline function classicTransparentDistance(draw, entity, viewOrigin)
```

Return the classic transparent distance value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `draw` | `dynamic` | — | draw value consumed by this operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `viewOrigin` | `dynamic` | — | viewOrigin value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L3840)

<a id="function-function-miniquake2-renderer-opengl-classictransparentframesignature-function-classictransparentframesignature-draws-src-miniquake2-renderer-opengl-ml-741918913"></a>
### classicTransparentFrameSignature

```ml
function classicTransparentFrameSignature(draws)
```

Return the classic transparent frame signature value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `draws` | `dynamic` | — | draws value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L3997)

<a id="function-function-miniquake2-renderer-opengl-clipopenglskypolygon-function-clipopenglskypolygon-bounds-vertices-count-stage-src-miniquake2-renderer-opengl-ml-234775597"></a>
### clipOpenGlSkyPolygon

```ml
function clipOpenGlSkyPolygon(bounds, vertices, count, stage)
```

Compatibility wrapper used by focused geometry tests.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `bounds` | `dynamic` | — | bounds value consumed by this operation. |
| `vertices` | `dynamic` | — | vertices value consumed by this operation. |
| `count` | `dynamic` | — | Number of items or units to process. |
| `stage` | `dynamic` | — | stage value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L3239)

<a id="function-function-miniquake2-renderer-opengl-clipopenglskypolygonscratch-function-clipopenglskypolygonscratch-bounds-vertices-count-stage-scratch-src-miniquake2-renderer-opengl-ml-570573395"></a>
### clipOpenGlSkyPolygonScratch

```ml
function clipOpenGlSkyPolygonScratch(bounds, vertices, count, stage, scratch)
```

Exact managed port of ref_gl's six-plane ClipSkyPolygon. Sky surfaces are already triangle lists, so even the worst split remains well below 64 verts.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `bounds` | `dynamic` | — | bounds value consumed by this operation. |
| `vertices` | `dynamic` | — | vertices value consumed by this operation. |
| `count` | `dynamic` | — | Number of items or units to process. |
| `stage` | `dynamic` | — | stage value consumed by this operation. |
| `scratch` | `dynamic` | — | scratch value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L3169)

<a id="function-function-miniquake2-renderer-opengl-colorbyte-inline-function-colorbyte-value-shift-src-miniquake2-renderer-opengl-ml-1786666722"></a>
### colorByte

```ml
inline function colorByte(value, shift)
```

Return the color byte value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `shift` | `dynamic` | — | shift value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L481)

<a id="function-function-miniquake2-renderer-opengl-createopenglrenderer-function-createopenglrenderer-contextactive-src-miniquake2-renderer-opengl-ml-547372447"></a>
### createOpenGlRenderer

```ml
function createOpenGlRenderer(contextActive)
```

Create open gl renderer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `contextActive` | `dynamic` | — | contextActive value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L2502)

<a id="function-function-miniquake2-renderer-opengl-createopenglskybounds-function-createopenglskybounds-src-miniquake2-renderer-opengl-ml-1884170032"></a>
### createOpenGlSkyBounds

```ml
function createOpenGlSkyBounds()
```

Create open gl sky bounds.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L3032)

<a id="function-function-miniquake2-renderer-opengl-createopenglskyvertexbuffer-function-createopenglskyvertexbuffer-src-miniquake2-renderer-opengl-ml-1302609030"></a>
### createOpenGlSkyVertexBuffer

```ml
function createOpenGlSkyVertexBuffer()
```

Create one fixed-capacity sky vertex buffer.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L3052)

<a id="constant-constant-miniquake2-renderer-opengl-deg-to-rad-const-deg-to-rad-1-74532925199433e-002-src-miniquake2-renderer-opengl-ml-1940022546"></a>
### DEG_TO_RAD

```ml
const DEG_TO_RAD = 1.74532925199433e-002
```

Defines the deg to rad constant used by the miniquake2 renderer opengl module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L125)

<a id="function-function-miniquake2-renderer-opengl-drawfaderect-function-drawfaderect-src-miniquake2-renderer-opengl-ml-1730038102"></a>
### drawFadeRect

```ml
function drawFadeRect()
```

Draw fade rect.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L1182)

<a id="function-function-miniquake2-renderer-opengl-drawopenglbeam-function-drawopenglbeam-backend-entity-src-miniquake2-renderer-opengl-ml-1890516233"></a>
### drawOpenGlBeam

```ml
function drawOpenGlBeam(backend, entity)
```

Draw open gl beam.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `backend` | `dynamic` | — | backend value consumed by this operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L746)

<a id="function-function-miniquake2-renderer-opengl-drawopenglbrightness-function-drawopenglbrightness-backend-src-miniquake2-renderer-opengl-ml-596707868"></a>
### drawOpenGlBrightness

```ml
function drawOpenGlBrightness(backend)
```

Apply a compositor-safe brightness fallback to the completed framebuffer. Modern Windows can accept SetDeviceGammaRamp while silently ignoring it in windowed/HDR composition. This exposure approximation keeps black anchored when brightening and uses an ordinary black blend when darkening, so the video-menu control always has an immediate visible runtime effect.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `backend` | `dynamic` | — | backend value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L1654)

<a id="function-function-miniquake2-renderer-opengl-drawopenglclassicbrushlightmaps-function-drawopenglclassicbrushlightmaps-binding-submission-time-src-miniquake2-renderer-opengl-ml-1453473164"></a>
### drawOpenGlClassicBrushLightmaps

```ml
function drawOpenGlClassicBrushLightmaps(binding, submission, time)
```

Draw open gl classic brush lightmaps.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `binding` | `dynamic` | — | binding value consumed by this operation. |
| `submission` | `dynamic` | — | submission value consumed by this operation. |
| `time` | `dynamic` | — | time value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L3772)

<a id="function-function-miniquake2-renderer-opengl-drawopenglclassicbrushopaque-function-drawopenglclassicbrushopaque-binding-submission-frame-src-miniquake2-renderer-opengl-ml-295162604"></a>
### drawOpenGlClassicBrushOpaque

```ml
function drawOpenGlClassicBrushOpaque(binding, submission, frame)
```

Draw open gl classic brush opaque.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `binding` | `dynamic` | — | binding value consumed by this operation. |
| `submission` | `dynamic` | — | submission value consumed by this operation. |
| `frame` | `dynamic` | — | frame value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L3806)

<a id="function-function-miniquake2-renderer-opengl-drawopenglclassicdraws-function-drawopenglclassicdraws-binding-draws-drawcount-time-lightmap-entityframe-src-miniquake2-renderer-opengl-ml-1597003792"></a>
### drawOpenGlClassicDraws

```ml
function drawOpenGlClassicDraws(binding, draws, drawCount, time, lightmap, entityFrame)
```

Draw open gl classic draws.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `binding` | `dynamic` | — | binding value consumed by this operation. |
| `draws` | `dynamic` | — | draws value consumed by this operation. |
| `drawCount` | `dynamic` | — | Number of draw to process. |
| `time` | `dynamic` | — | time value consumed by this operation. |
| `lightmap` | `dynamic` | — | lightmap value consumed by this operation. |
| `entityFrame` | `dynamic` | — | entityFrame value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L3684)

<a id="function-function-miniquake2-renderer-opengl-drawopenglclassictransparentframe-function-drawopenglclassictransparentframe-binding-draws-drawcount-frame-src-miniquake2-renderer-opengl-ml-18989868"></a>
### drawOpenGlClassicTransparentFrame

```ml
function drawOpenGlClassicTransparentFrame(binding, draws, drawCount, frame)
```

Draw open gl classic transparent frame.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `binding` | `dynamic` | — | binding value consumed by this operation. |
| `draws` | `dynamic` | — | draws value consumed by this operation. |
| `drawCount` | `dynamic` | — | Number of draw to process. |
| `frame` | `dynamic` | — | frame value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L4012)

<a id="function-function-miniquake2-renderer-opengl-drawopenglentitypass-function-drawopenglentitypass-backend-frame-axes-translucentpass-src-miniquake2-renderer-opengl-ml-1636733982"></a>
### drawOpenGlEntityPass

```ml
function drawOpenGlEntityPass(backend, frame, axes, translucentPass)
```

Draw open gl entity pass.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `backend` | `dynamic` | — | backend value consumed by this operation. |
| `frame` | `dynamic` | — | frame value consumed by this operation. |
| `axes` | `dynamic` | — | axes value consumed by this operation. |
| `translucentPass` | `dynamic` | — | translucentPass value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L1864)

<a id="function-function-miniquake2-renderer-opengl-drawopenglmd2entityfast-function-drawopenglmd2entityfast-backend-modelasset-entity-frame-entityindex-src-miniquake2-renderer-opengl-ml-1650078552"></a>
### drawOpenGlMd2EntityFast

```ml
function drawOpenGlMd2EntityFast(backend, modelAsset, entity, frame, entityIndex)
```

Draw open gl md 2 entity fast.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `backend` | `dynamic` | — | backend value consumed by this operation. |
| `modelAsset` | `dynamic` | — | modelAsset value consumed by this operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `frame` | `dynamic` | — | frame value consumed by this operation. |
| `entityIndex` | `dynamic` | — | Zero-based index of entity. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L1767)

<a id="function-function-miniquake2-renderer-opengl-drawopenglmd2plan-function-drawopenglmd2plan-backend-plan-entity-src-miniquake2-renderer-opengl-ml-2066510282"></a>
### drawOpenGlMd2Plan

```ml
function drawOpenGlMd2Plan(backend, plan, entity)
```

Draw open gl md 2 plan.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `backend` | `dynamic` | — | backend value consumed by this operation. |
| `plan` | `dynamic` | — | plan value consumed by this operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L1756)

<a id="function-function-miniquake2-renderer-opengl-drawopenglmd2scalars-function-drawopenglmd2scalars-backend-skinasset-glvertices-trianglecount-vertexcount-resultbounds-entity-frame-src-miniquake2-renderer-opengl-ml-945971435"></a>
### drawOpenGlMd2Scalars

```ml
function drawOpenGlMd2Scalars(backend, skinAsset, glVertices, triangleCount, vertexCount, resultBounds, entity, frame)
```

Draw open gl md 2 scalars.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `backend` | `dynamic` | — | backend value consumed by this operation. |
| `skinAsset` | `dynamic` | — | skinAsset value consumed by this operation. |
| `glVertices` | `dynamic` | — | glVertices value consumed by this operation. |
| `triangleCount` | `dynamic` | — | Number of triangle to process. |
| `vertexCount` | `dynamic` | — | Number of vertex to process. |
| `resultBounds` | `dynamic` | — | resultBounds value consumed by this operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `frame` | `dynamic` | — | frame value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L1739)

<a id="function-function-miniquake2-renderer-opengl-drawopenglmd2shadowpass-function-drawopenglmd2shadowpass-backend-frame-src-miniquake2-renderer-opengl-ml-1801804951"></a>
### drawOpenGlMd2ShadowPass

```ml
function drawOpenGlMd2ShadowPass(backend, frame)
```

Keep alias lighting in one shader run, then submit the original optional GL_DrawAliasShadow behavior as a separate blended pass over cached MD2 VBOs.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `backend` | `dynamic` | — | backend value consumed by this operation. |
| `frame` | `dynamic` | — | frame value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L1936)

<a id="function-function-miniquake2-renderer-opengl-drawopenglnullentity-function-drawopenglnullentity-entity-src-miniquake2-renderer-opengl-ml-562586403"></a>
### drawOpenGlNullEntity

```ml
function drawOpenGlNullEntity(entity)
```

Draw open gl null entity.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L661)

<a id="function-function-miniquake2-renderer-opengl-drawopenglpendingclassicshadows-function-drawopenglpendingclassicshadows-backend-src-miniquake2-renderer-opengl-ml-153637950"></a>
### drawOpenGlPendingClassicShadows

```ml
function drawOpenGlPendingClassicShadows(backend)
```

Draw the alias shadows only after the current frame's alias lighting pass has populated md2ShadowSpotZ. This removes the historical one-frame stale spot introduced by MiniQuake2's split world/entity submission API.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `backend` | `dynamic` | — | backend value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L2004)

<a id="function-function-miniquake2-renderer-opengl-drawopenglpolyblend-function-drawopenglpolyblend-frame-src-miniquake2-renderer-opengl-ml-705611239"></a>
### drawOpenGlPolyBlend

```ml
function drawOpenGlPolyBlend(frame)
```

Draw open gl poly blend.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `frame` | `dynamic` | — | frame value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L1286)

<a id="function-function-miniquake2-renderer-opengl-drawopenglskybox-function-drawopenglskybox-binding-world-frame-draws-drawcount-src-miniquake2-renderer-opengl-ml-186671668"></a>
### drawOpenGlSkyBox

```ml
function drawOpenGlSkyBox(binding, world, frame, draws, drawCount)
```

Draw open gl sky box.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `binding` | `dynamic` | — | binding value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |
| `frame` | `dynamic` | — | frame value consumed by this operation. |
| `draws` | `dynamic` | — | draws value consumed by this operation. |
| `drawCount` | `dynamic` | — | Number of draw to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L3313)

<a id="function-function-miniquake2-renderer-opengl-drawopenglspriteentity-function-drawopenglspriteentity-backend-modelasset-entity-axes-src-miniquake2-renderer-opengl-ml-133289767"></a>
### drawOpenGlSpriteEntity

```ml
function drawOpenGlSpriteEntity(backend, modelAsset, entity, axes)
```

Draw open gl sprite entity.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `backend` | `dynamic` | — | backend value consumed by this operation. |
| `modelAsset` | `dynamic` | — | modelAsset value consumed by this operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `axes` | `dynamic` | — | axes value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L777)

<a id="function-function-miniquake2-renderer-opengl-drawparticles-function-drawparticles-backend-frame-axes-src-miniquake2-renderer-opengl-ml-1410089220"></a>
### drawParticles

```ml
function drawParticles(backend, frame, axes)
```

Draw particles.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `backend` | `dynamic` | — | backend value consumed by this operation. |
| `frame` | `dynamic` | — | frame value consumed by this operation. |
| `axes` | `dynamic` | — | axes value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L848)

<a id="function-function-miniquake2-renderer-opengl-drawsolidrect-function-drawsolidrect-backend-x-y-width-height-color-src-miniquake2-renderer-opengl-ml-1615351777"></a>
### drawSolidRect

```ml
function drawSolidRect(backend, x, y, width, height, color)
```

Draw solid rect.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `backend` | `dynamic` | — | backend value consumed by this operation. |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `width` | `dynamic` | — | Width in the coordinate or storage units used by the caller. |
| `height` | `dynamic` | — | Height in the coordinate or storage units used by the caller. |
| `color` | `dynamic` | — | color value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L951)

<a id="function-function-miniquake2-renderer-opengl-drawtexturedrect-function-drawtexturedrect-backend-asset-x-y-width-height-src-miniquake2-renderer-opengl-ml-1729621958"></a>
### drawTexturedRect

```ml
function drawTexturedRect(backend, asset, x, y, width, height)
```

Draw textured rect.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `backend` | `dynamic` | — | backend value consumed by this operation. |
| `asset` | `dynamic` | — | asset value consumed by this operation. |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `width` | `dynamic` | — | Width in the coordinate or storage units used by the caller. |
| `height` | `dynamic` | — | Height in the coordinate or storage units used by the caller. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L1114)

<a id="function-function-miniquake2-renderer-opengl-drawtexturedsubrect-function-drawtexturedsubrect-backend-asset-x-y-width-height-left-top-right-bottom-src-miniquake2-renderer-opengl-ml-1202698259"></a>
### drawTexturedSubRect

```ml
function drawTexturedSubRect(backend, asset, x, y, width, height, left, top, right, bottom)
```

Draw textured sub rect.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `backend` | `dynamic` | — | backend value consumed by this operation. |
| `asset` | `dynamic` | — | asset value consumed by this operation. |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `width` | `dynamic` | — | Width in the coordinate or storage units used by the caller. |
| `height` | `dynamic` | — | Height in the coordinate or storage units used by the caller. |
| `left` | `dynamic` | — | left value consumed by this operation. |
| `top` | `dynamic` | — | top value consumed by this operation. |
| `right` | `dynamic` | — | right value consumed by this operation. |
| `bottom` | `dynamic` | — | bottom value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L1141)

<a id="function-function-miniquake2-renderer-opengl-drawtiledrect-function-drawtiledrect-backend-asset-x-y-width-height-src-miniquake2-renderer-opengl-ml-298053214"></a>
### drawTiledRect

```ml
function drawTiledRect(backend, asset, x, y, width, height)
```

Draw tiled rect.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `backend` | `dynamic` | — | backend value consumed by this operation. |
| `asset` | `dynamic` | — | asset value consumed by this operation. |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `width` | `dynamic` | — | Width in the coordinate or storage units used by the caller. |
| `height` | `dynamic` | — | Height in the coordinate or storage units used by the caller. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L1165)

<a id="function-function-miniquake2-renderer-opengl-emitclassicdraw-function-emitclassicdraw-draw-lightmap-time-src-miniquake2-renderer-opengl-ml-1925839415"></a>
### emitClassicDraw

```ml
function emitClassicDraw(draw, lightmap, time)
```

Emit classic draw.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `draw` | `dynamic` | — | draw value consumed by this operation. |
| `lightmap` | `dynamic` | — | lightmap value consumed by this operation. |
| `time` | `dynamic` | — | time value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L2846)

<a id="function-function-miniquake2-renderer-opengl-emitclassicvertex-function-emitclassicvertex-draw-vertex-lightmap-time-src-miniquake2-renderer-opengl-ml-1065544701"></a>
### emitClassicVertex

```ml
function emitClassicVertex(draw, vertex, lightmap, time)
```

Emit classic vertex.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `draw` | `dynamic` | — | draw value consumed by this operation. |
| `vertex` | `dynamic` | — | vertex value consumed by this operation. |
| `lightmap` | `dynamic` | — | lightmap value consumed by this operation. |
| `time` | `dynamic` | — | time value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L2826)

<a id="function-function-miniquake2-renderer-opengl-emitopenglmd2scalars-function-emitopenglmd2scalars-glvertices-src-miniquake2-renderer-opengl-ml-1253013278"></a>
### emitOpenGlMd2Scalars

```ml
function emitOpenGlMd2Scalars(glVertices)
```

Emit open gl md 2 scalars.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `glVertices` | `dynamic` | — | glVertices value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L1613)

<a id="function-function-miniquake2-renderer-opengl-emitopenglskyvertex-function-emitopenglskyvertex-s-t-axis-texture-src-miniquake2-renderer-opengl-ml-1782679269"></a>
### emitOpenGlSkyVertex

```ml
function emitOpenGlSkyVertex(s, t, axis, texture)
```

Emit open gl sky vertex.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s` | `dynamic` | — | s value consumed by this operation. |
| `t` | `dynamic` | — | t value consumed by this operation. |
| `axis` | `dynamic` | — | axis value consumed by this operation. |
| `texture` | `dynamic` | — | texture value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L3286)

<a id="function-function-miniquake2-renderer-opengl-endopenglmd2draw-function-endopenglmd2draw-drawstate-src-miniquake2-renderer-opengl-ml-1900829445"></a>
### endOpenGlMd2Draw

```ml
function endOpenGlMd2Draw(drawState)
```

End open gl md 2 draw.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `drawState` | `dynamic` | — | drawState value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L1630)

<a id="function-function-miniquake2-renderer-opengl-ensureopenglparticletexture-function-ensureopenglparticletexture-backend-src-miniquake2-renderer-opengl-ml-94711936"></a>
### ensureOpenGlParticleTexture

```ml
function ensureOpenGlParticleTexture(backend)
```

Ensure open gl particle texture.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `backend` | `dynamic` | — | backend value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L590)

<a id="function-function-miniquake2-renderer-opengl-ensureopenglpicturetexture-function-ensureopenglpicturetexture-backend-asset-src-miniquake2-renderer-opengl-ml-1192992894"></a>
### ensureOpenGlPictureTexture

```ml
function ensureOpenGlPictureTexture(backend, asset)
```

Ensure open gl picture texture.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `backend` | `dynamic` | — | backend value consumed by this operation. |
| `asset` | `dynamic` | — | asset value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L1020)

<a id="function-function-miniquake2-renderer-opengl-ensureopenglrawtexture-function-ensureopenglrawtexture-backend-src-miniquake2-renderer-opengl-ml-2001828812"></a>
### ensureOpenGlRawTexture

```ml
function ensureOpenGlRawTexture(backend)
```

Ensure open gl raw texture.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `backend` | `dynamic` | — | backend value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L614)

<a id="function-function-miniquake2-renderer-opengl-ensureopenglskyclipscratch-function-ensureopenglskyclipscratch-src-miniquake2-renderer-opengl-ml-1513024774"></a>
### ensureOpenGlSkyClipScratch

```ml
function ensureOpenGlSkyClipScratch()
```

Lazily create the retained clipping workspace. Product registration calls this before gameplay whenever a map owns sky surfaces.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L3064)

<a id="function-function-miniquake2-renderer-opengl-findtexturerecord-function-findtexturerecord-backend-id-src-miniquake2-renderer-opengl-ml-1031002861"></a>
### findTextureRecord

```ml
function findTextureRecord(backend, id)
```

Find texture record.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `backend` | `dynamic` | — | backend value consumed by this operation. |
| `id` | `dynamic` | — | Stable identifier of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L438)

<a id="function-function-miniquake2-renderer-opengl-flushopenglpendingclassicalpha-function-flushopenglpendingclassicalpha-src-miniquake2-renderer-opengl-ml-155411442"></a>
### flushOpenGlPendingClassicAlpha

```ml
function flushOpenGlPendingClassicAlpha()
```

Finish stock's tail ordering after entities and particles. The actual alpha draw routine is declared later with the other ClassicWorld helpers.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L2015)

<a id="function-function-miniquake2-renderer-opengl-getrefapi-function-getrefapi-imports-contextactive-src-miniquake2-renderer-opengl-ml-1375126133"></a>
### getRefAPI

```ml
function getRefAPI(imports, contextActive)
```

Return ref api.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `imports` | `dynamic` | — | imports value consumed by this operation. |
| `contextActive` | `dynamic` | — | contextActive value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L2515)

<a id="constant-constant-miniquake2-renderer-opengl-gl-alpha-test-const-gl-alpha-test-3008-src-miniquake2-renderer-opengl-ml-687983818"></a>
### GL_ALPHA_TEST

```ml
const GL_ALPHA_TEST = 3008
```

Defines the gl alpha test constant used by the miniquake2 renderer opengl module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L77)

<a id="constant-constant-miniquake2-renderer-opengl-gl-back-const-gl-back-1029-src-miniquake2-renderer-opengl-ml-829685009"></a>
### GL_BACK

```ml
const GL_BACK = 1029
```

Defines the gl back constant used by the miniquake2 renderer opengl module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L111)

<a id="constant-constant-miniquake2-renderer-opengl-gl-blend-const-gl-blend-3042-src-miniquake2-renderer-opengl-ml-514649964"></a>
### GL_BLEND

```ml
const GL_BLEND = 3042
```

Defines the gl blend constant used by the miniquake2 renderer opengl module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L75)

<a id="constant-constant-miniquake2-renderer-opengl-gl-clamp-const-gl-clamp-10496-src-miniquake2-renderer-opengl-ml-1664868383"></a>
### GL_CLAMP

```ml
const GL_CLAMP = 10496
```

Defines the gl clamp constant used by the miniquake2 renderer opengl module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L115)

<a id="constant-constant-miniquake2-renderer-opengl-gl-color-buffer-bit-const-gl-color-buffer-bit-16384-src-miniquake2-renderer-opengl-ml-660746711"></a>
### GL_COLOR_BUFFER_BIT

```ml
const GL_COLOR_BUFFER_BIT = 16384
```

Defines the gl color buffer bit constant used by the miniquake2 renderer opengl module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L53)

<a id="constant-constant-miniquake2-renderer-opengl-gl-cull-face-const-gl-cull-face-2884-src-miniquake2-renderer-opengl-ml-1283846157"></a>
### GL_CULL_FACE

```ml
const GL_CULL_FACE = 2884
```

Defines the gl cull face constant used by the miniquake2 renderer opengl module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L79)

<a id="constant-constant-miniquake2-renderer-opengl-gl-depth-buffer-bit-const-gl-depth-buffer-bit-256-src-miniquake2-renderer-opengl-ml-2084444078"></a>
### GL_DEPTH_BUFFER_BIT

```ml
const GL_DEPTH_BUFFER_BIT = 256
```

Defines the gl depth buffer bit constant used by the miniquake2 renderer opengl module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L51)

<a id="constant-constant-miniquake2-renderer-opengl-gl-depth-test-const-gl-depth-test-2929-src-miniquake2-renderer-opengl-ml-627677445"></a>
### GL_DEPTH_TEST

```ml
const GL_DEPTH_TEST = 2929
```

Defines the gl depth test constant used by the miniquake2 renderer opengl module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L81)

<a id="constant-constant-miniquake2-renderer-opengl-gl-dst-color-const-gl-dst-color-774-src-miniquake2-renderer-opengl-ml-364711417"></a>
### GL_DST_COLOR

```ml
const GL_DST_COLOR = 774
```

Defines the gl dst color constant used by the miniquake2 renderer opengl module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L71)

<a id="constant-constant-miniquake2-renderer-opengl-gl-equal-const-gl-equal-514-src-miniquake2-renderer-opengl-ml-1054544295"></a>
### GL_EQUAL

```ml
const GL_EQUAL = 514
```

Defines the gl equal constant used by the miniquake2 renderer opengl module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L57)

<a id="constant-constant-miniquake2-renderer-opengl-gl-front-const-gl-front-1028-src-miniquake2-renderer-opengl-ml-1367826618"></a>
### GL_FRONT

```ml
const GL_FRONT = 1028
```

Defines the gl front constant used by the miniquake2 renderer opengl module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L109)

<a id="constant-constant-miniquake2-renderer-opengl-gl-greater-const-gl-greater-516-src-miniquake2-renderer-opengl-ml-609443385"></a>
### GL_GREATER

```ml
const GL_GREATER = 516
```

Defines the gl greater constant used by the miniquake2 renderer opengl module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L59)

<a id="constant-constant-miniquake2-renderer-opengl-gl-lequal-const-gl-lequal-515-src-miniquake2-renderer-opengl-ml-76758226"></a>
### GL_LEQUAL

```ml
const GL_LEQUAL = 515
```

Defines the gl lequal constant used by the miniquake2 renderer opengl module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L61)

<a id="constant-constant-miniquake2-renderer-opengl-gl-less-const-gl-less-513-src-miniquake2-renderer-opengl-ml-446011112"></a>
### GL_LESS

```ml
const GL_LESS = 513
```

Defines the gl less constant used by the miniquake2 renderer opengl module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L55)

<a id="constant-constant-miniquake2-renderer-opengl-gl-linear-const-gl-linear-9729-src-miniquake2-renderer-opengl-ml-662744968"></a>
### GL_LINEAR

```ml
const GL_LINEAR = 9729
```

Defines the gl linear constant used by the miniquake2 renderer opengl module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L105)

<a id="constant-constant-miniquake2-renderer-opengl-gl-linear-mipmap-nearest-const-gl-linear-mipmap-nearest-9985-src-miniquake2-renderer-opengl-ml-1057021784"></a>
### GL_LINEAR_MIPMAP_NEAREST

```ml
const GL_LINEAR_MIPMAP_NEAREST = 9985
```

Defines the gl linear mipmap nearest constant used by the miniquake2 renderer opengl module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L107)

<a id="constant-constant-miniquake2-renderer-opengl-gl-lines-const-gl-lines-1-src-miniquake2-renderer-opengl-ml-1473037864"></a>
### GL_LINES

```ml
const GL_LINES = 1
```

Defines the gl lines constant used by the miniquake2 renderer opengl module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L41)

<a id="constant-constant-miniquake2-renderer-opengl-gl-modelview-const-gl-modelview-5888-src-miniquake2-renderer-opengl-ml-2076866674"></a>
### GL_MODELVIEW

```ml
const GL_MODELVIEW = 5888
```

Defines the gl modelview constant used by the miniquake2 renderer opengl module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L85)

<a id="constant-constant-miniquake2-renderer-opengl-gl-modulate-const-gl-modulate-8448-src-miniquake2-renderer-opengl-ml-821401609"></a>
### GL_MODULATE

```ml
const GL_MODULATE = 8448
```

Defines the gl modulate constant used by the miniquake2 renderer opengl module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L113)

<a id="constant-constant-miniquake2-renderer-opengl-gl-one-const-gl-one-1-src-miniquake2-renderer-opengl-ml-949182490"></a>
### GL_ONE

```ml
const GL_ONE = 1
```

Defines the gl one constant used by the miniquake2 renderer opengl module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L65)

<a id="constant-constant-miniquake2-renderer-opengl-gl-one-minus-src-alpha-const-gl-one-minus-src-alpha-771-src-miniquake2-renderer-opengl-ml-532707558"></a>
### GL_ONE_MINUS_SRC_ALPHA

```ml
const GL_ONE_MINUS_SRC_ALPHA = 771
```

Defines the gl one minus src alpha constant used by the miniquake2 renderer opengl module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L73)

<a id="constant-constant-miniquake2-renderer-opengl-gl-points-const-gl-points-0-src-miniquake2-renderer-opengl-ml-1144093999"></a>
### GL_POINTS

```ml
const GL_POINTS = 0
```

Defines the gl points constant used by the miniquake2 renderer opengl module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L39)

<a id="constant-constant-miniquake2-renderer-opengl-gl-projection-const-gl-projection-5889-src-miniquake2-renderer-opengl-ml-602972843"></a>
### GL_PROJECTION

```ml
const GL_PROJECTION = 5889
```

Defines the gl projection constant used by the miniquake2 renderer opengl module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L87)

<a id="constant-constant-miniquake2-renderer-opengl-gl-quads-const-gl-quads-7-src-miniquake2-renderer-opengl-ml-1312464232"></a>
### GL_QUADS

```ml
const GL_QUADS = 7
```

Defines the gl quads constant used by the miniquake2 renderer opengl module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L49)

<a id="constant-constant-miniquake2-renderer-opengl-gl-renderer-const-gl-renderer-7937-src-miniquake2-renderer-opengl-ml-534206755"></a>
### GL_RENDERER

```ml
const GL_RENDERER = 7937
```

Defines the gl renderer constant used by the miniquake2 renderer opengl module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L121)

<a id="constant-constant-miniquake2-renderer-opengl-gl-repeat-const-gl-repeat-10497-src-miniquake2-renderer-opengl-ml-1168210232"></a>
### GL_REPEAT

```ml
const GL_REPEAT = 10497
```

Defines the gl repeat constant used by the miniquake2 renderer opengl module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L117)

<a id="constant-constant-miniquake2-renderer-opengl-gl-rgba-const-gl-rgba-6408-src-miniquake2-renderer-opengl-ml-1031189735"></a>
### GL_RGBA

```ml
const GL_RGBA = 6408
```

Defines the gl rgba constant used by the miniquake2 renderer opengl module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L89)

<a id="constant-constant-miniquake2-renderer-opengl-gl-src-alpha-const-gl-src-alpha-770-src-miniquake2-renderer-opengl-ml-646608569"></a>
### GL_SRC_ALPHA

```ml
const GL_SRC_ALPHA = 770
```

Defines the gl src alpha constant used by the miniquake2 renderer opengl module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L69)

<a id="constant-constant-miniquake2-renderer-opengl-gl-src-color-const-gl-src-color-768-src-miniquake2-renderer-opengl-ml-228863978"></a>
### GL_SRC_COLOR

```ml
const GL_SRC_COLOR = 768
```

Defines the gl src color constant used by the miniquake2 renderer opengl module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L67)

<a id="constant-constant-miniquake2-renderer-opengl-gl-texture-2d-const-gl-texture-2d-3553-src-miniquake2-renderer-opengl-ml-556436809"></a>
### GL_TEXTURE_2D

```ml
const GL_TEXTURE_2D = 3553
```

Defines the gl texture 2 d constant used by the miniquake2 renderer opengl module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L83)

<a id="constant-constant-miniquake2-renderer-opengl-gl-texture-env-const-gl-texture-env-8960-src-miniquake2-renderer-opengl-ml-465799144"></a>
### GL_TEXTURE_ENV

```ml
const GL_TEXTURE_ENV = 8960
```

Defines the gl texture env constant used by the miniquake2 renderer opengl module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L101)

<a id="constant-constant-miniquake2-renderer-opengl-gl-texture-env-mode-const-gl-texture-env-mode-8704-src-miniquake2-renderer-opengl-ml-1576643888"></a>
### GL_TEXTURE_ENV_MODE

```ml
const GL_TEXTURE_ENV_MODE = 8704
```

Defines the gl texture env mode constant used by the miniquake2 renderer opengl module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L103)

<a id="constant-constant-miniquake2-renderer-opengl-gl-texture-mag-filter-const-gl-texture-mag-filter-10240-src-miniquake2-renderer-opengl-ml-1105523118"></a>
### GL_TEXTURE_MAG_FILTER

```ml
const GL_TEXTURE_MAG_FILTER = 10240
```

Defines the gl texture mag filter constant used by the miniquake2 renderer opengl module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L93)

<a id="constant-constant-miniquake2-renderer-opengl-gl-texture-min-filter-const-gl-texture-min-filter-10241-src-miniquake2-renderer-opengl-ml-1967991169"></a>
### GL_TEXTURE_MIN_FILTER

```ml
const GL_TEXTURE_MIN_FILTER = 10241
```

Defines the gl texture min filter constant used by the miniquake2 renderer opengl module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L95)

<a id="constant-constant-miniquake2-renderer-opengl-gl-texture-wrap-s-const-gl-texture-wrap-s-10242-src-miniquake2-renderer-opengl-ml-523754372"></a>
### GL_TEXTURE_WRAP_S

```ml
const GL_TEXTURE_WRAP_S = 10242
```

Defines the gl texture wrap s constant used by the miniquake2 renderer opengl module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L97)

<a id="constant-constant-miniquake2-renderer-opengl-gl-texture-wrap-t-const-gl-texture-wrap-t-10243-src-miniquake2-renderer-opengl-ml-79920171"></a>
### GL_TEXTURE_WRAP_T

```ml
const GL_TEXTURE_WRAP_T = 10243
```

Defines the gl texture wrap t constant used by the miniquake2 renderer opengl module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L99)

<a id="constant-constant-miniquake2-renderer-opengl-gl-triangle-fan-const-gl-triangle-fan-6-src-miniquake2-renderer-opengl-ml-629677545"></a>
### GL_TRIANGLE_FAN

```ml
const GL_TRIANGLE_FAN = 6
```

Defines the gl triangle fan constant used by the miniquake2 renderer opengl module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L47)

<a id="constant-constant-miniquake2-renderer-opengl-gl-triangle-strip-const-gl-triangle-strip-5-src-miniquake2-renderer-opengl-ml-1548837692"></a>
### GL_TRIANGLE_STRIP

```ml
const GL_TRIANGLE_STRIP = 5
```

Defines the gl triangle strip constant used by the miniquake2 renderer opengl module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L45)

<a id="constant-constant-miniquake2-renderer-opengl-gl-triangles-const-gl-triangles-4-src-miniquake2-renderer-opengl-ml-1134316635"></a>
### GL_TRIANGLES

```ml
const GL_TRIANGLES = 4
```

Defines the gl triangles constant used by the miniquake2 renderer opengl module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L43)

<a id="constant-constant-miniquake2-renderer-opengl-gl-unsigned-byte-const-gl-unsigned-byte-5121-src-miniquake2-renderer-opengl-ml-215815084"></a>
### GL_UNSIGNED_BYTE

```ml
const GL_UNSIGNED_BYTE = 5121
```

Defines the gl unsigned byte constant used by the miniquake2 renderer opengl module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L91)

<a id="constant-constant-miniquake2-renderer-opengl-gl-vendor-const-gl-vendor-7936-src-miniquake2-renderer-opengl-ml-1331278436"></a>
### GL_VENDOR

```ml
const GL_VENDOR = 7936
```

Defines the gl vendor constant used by the miniquake2 renderer opengl module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L119)

<a id="constant-constant-miniquake2-renderer-opengl-gl-version-const-gl-version-7938-src-miniquake2-renderer-opengl-ml-342543832"></a>
### GL_VERSION

```ml
const GL_VERSION = 7938
```

Defines the gl version constant used by the miniquake2 renderer opengl module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L123)

<a id="constant-constant-miniquake2-renderer-opengl-gl-zero-const-gl-zero-0-src-miniquake2-renderer-opengl-ml-1952335095"></a>
### GL_ZERO

```ml
const GL_ZERO = 0
```

Defines the gl zero constant used by the miniquake2 renderer opengl module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L63)

- [miniquake2.renderer.opengl.GlTextureRecord](Type-miniquake2-renderer-opengl-gltexturerecord-769947672.md) — struct
<a id="function-function-miniquake2-renderer-opengl-handedness-function-handedness-binding-src-miniquake2-renderer-opengl-ml-486082363"></a>
### handedness

```ml
function handedness(binding)
```

Return the handedness value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `binding` | `dynamic` | — | binding value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L2558)

<a id="function-function-miniquake2-renderer-opengl-lastshadowentities-function-lastshadowentities-binding-src-miniquake2-renderer-opengl-ml-2115837835"></a>
### lastShadowEntities

```ml
function lastShadowEntities(binding)
```

Return the last shadow entities value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `binding` | `dynamic` | — | binding value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L2581)

<a id="function-function-miniquake2-renderer-opengl-lightlevel-function-lightlevel-binding-src-miniquake2-renderer-opengl-ml-399464811"></a>
### lightLevel

```ml
function lightLevel(binding)
```

Return the light level value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `binding` | `dynamic` | — | binding value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L2613)

- [miniquake2.renderer.opengl.Md2DrawState](Type-miniquake2-renderer-opengl-md2drawstate-1142408873.md) — struct
- [miniquake2.renderer.opengl.Md2EntityPlan](Type-miniquake2-renderer-opengl-md2entityplan-1334633446.md) — struct
<a id="function-function-miniquake2-renderer-opengl-md2entityshade-function-md2entityshade-binding-frame-entity-src-miniquake2-renderer-opengl-ml-987168477"></a>
### md2EntityShade

```ml
function md2EntityShade(binding, frame, entity)
```

Return the md 2 entity shade value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `binding` | `dynamic` | — | binding value consumed by this operation. |
| `frame` | `dynamic` | — | frame value consumed by this operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L2621)

<a id="function-function-miniquake2-renderer-opengl-md2entityvisible-function-md2entityvisible-binding-entity-src-miniquake2-renderer-opengl-ml-1680075494"></a>
### md2EntityVisible

```ml
function md2EntityVisible(binding, entity)
```

Report whether md 2 entity visible.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `binding` | `dynamic` | — | binding value consumed by this operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L2635)

- [miniquake2.renderer.opengl.Md2LightCacheEntry](Type-miniquake2-renderer-opengl-md2lightcacheentry-513055840.md) — struct
<a id="function-function-miniquake2-renderer-opengl-md2modelframebounds-function-md2modelframebounds-binding-modelhandle-frameindex-src-miniquake2-renderer-opengl-ml-1833422527"></a>
### md2ModelFrameBounds

```ml
function md2ModelFrameBounds(binding, modelHandle, frameIndex)
```

Return the md 2 model frame bounds.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `binding` | `dynamic` | — | binding value consumed by this operation. |
| `modelHandle` | `dynamic` | — | modelHandle value consumed by this operation. |
| `frameIndex` | `dynamic` | — | Zero-based index of frame. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L4305)

<a id="function-function-miniquake2-renderer-opengl-md2modelpitch-function-md2modelpitch-angle-src-miniquake2-renderer-opengl-ml-1815037717"></a>
### md2ModelPitch

```ml
function md2ModelPitch(angle)
```

Return the md 2 model pitch value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `angle` | `dynamic` | — | angle value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L2641)

<a id="function-function-miniquake2-renderer-opengl-md2shaderow-function-md2shaderow-binding-yaw-src-miniquake2-renderer-opengl-ml-263995398"></a>
### md2ShadeRow

```ml
function md2ShadeRow(binding, yaw)
```

Return the md 2 shade row value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `binding` | `dynamic` | — | binding value consumed by this operation. |
| `yaw` | `dynamic` | — | yaw value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L2628)

<a id="function-function-miniquake2-renderer-opengl-md2shadoweligible-function-md2shadoweligible-binding-entity-src-miniquake2-renderer-opengl-ml-910088574"></a>
### md2ShadowEligible

```ml
function md2ShadowEligible(binding, entity)
```

Return the md 2 shadow eligible value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `binding` | `dynamic` | — | binding value consumed by this operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L2588)

<a id="function-function-miniquake2-renderer-opengl-md2shadowlightheight-function-md2shadowlightheight-entity-spotz-src-miniquake2-renderer-opengl-ml-540357829"></a>
### md2ShadowLightHeight

```ml
function md2ShadowLightHeight(entity, spotZ)
```

Return the md 2 shadow light height value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `spotZ` | `dynamic` | — | spotZ value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L2607)

<a id="function-function-miniquake2-renderer-opengl-md2shadowvectorx-function-md2shadowvectorx-yaw-src-miniquake2-renderer-opengl-ml-2044010397"></a>
### md2ShadowVectorX

```ml
function md2ShadowVectorX(yaw)
```

Return the md 2 shadow vector x value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `yaw` | `dynamic` | — | yaw value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L2594)

<a id="function-function-miniquake2-renderer-opengl-md2shadowvectory-function-md2shadowvectory-yaw-src-miniquake2-renderer-opengl-ml-804076781"></a>
### md2ShadowVectorY

```ml
function md2ShadowVectorY(yaw)
```

Return the md 2 shadow vector y value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `yaw` | `dynamic` | — | yaw value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L2600)

- [miniquake2.renderer.opengl.Md2SubmitStats](Type-miniquake2-renderer-opengl-md2submitstats-1335459521.md) — struct
<a id="constant-constant-miniquake2-renderer-opengl-open-gl-max-texture-id-const-open-gl-max-texture-id-16383-src-miniquake2-renderer-opengl-ml-535152190"></a>
### OPEN_GL_MAX_TEXTURE_ID

```ml
const OPEN_GL_MAX_TEXTURE_ID = 16383
```

Native renderer texture identifiers occupy 14 bits. Keep a dense retained


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L127)

<a id="constant-constant-miniquake2-renderer-opengl-open-gl-sky-clip-capacity-const-open-gl-sky-clip-capacity-72-src-miniquake2-renderer-opengl-ml-1025260588"></a>
### OPEN_GL_SKY_CLIP_CAPACITY

```ml
const OPEN_GL_SKY_CLIP_CAPACITY = 72
```

Defines the open gl sky clip capacity constant used by the miniquake2 renderer opengl module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L131)

<a id="constant-constant-miniquake2-renderer-opengl-open-gl-sky-source-capacity-const-open-gl-sky-source-capacity-66-src-miniquake2-renderer-opengl-ml-466961829"></a>
### OPEN_GL_SKY_SOURCE_CAPACITY

```ml
const OPEN_GL_SKY_SOURCE_CAPACITY = 66
```

ref_gl accepts at most 66 source vertices. Each of the six clip planes can


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L129)

<a id="function-function-miniquake2-renderer-opengl-openglappactivate-function-openglappactivate-activate-src-miniquake2-renderer-opengl-ml-1990765239"></a>
### openGlAppActivate

```ml
function openGlAppActivate(activate)
```

Open gl app activate.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `activate` | `dynamic` | — | activate value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L2480)

<a id="global-global-miniquake2-renderer-opengl-openglbackendslot-openglbackendslot-src-miniquake2-renderer-opengl-ml-2097986770"></a>
### openGlBackendSlot

```ml
openGlBackendSlot
```

Mutating a package-owned holder is reliable across the self-hosted full


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L396)

- [miniquake2.renderer.opengl.OpenGlBackendSlot](Type-miniquake2-renderer-opengl-openglbackendslot-1061207658.md) — struct
<a id="function-function-miniquake2-renderer-opengl-openglbatchdrawsequal-inline-function-openglbatchdrawsequal-first-second-src-miniquake2-renderer-opengl-ml-1485447985"></a>
### openGlBatchDrawsEqual

```ml
inline function openGlBatchDrawsEqual(first, second)
```

Report whether open gl batch draws equal.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `dynamic` | — | first value consumed by this operation. |
| `second` | `dynamic` | — | second value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L2934)

<a id="function-function-miniquake2-renderer-opengl-openglbatchdrawsequalprefix-inline-function-openglbatchdrawsequalprefix-first-second-count-src-miniquake2-renderer-opengl-ml-372774020"></a>
### openGlBatchDrawsEqualPrefix

```ml
inline function openGlBatchDrawsEqualPrefix(first, second, count)
```

Compare an exact retained batch with a capacity-sized visible prefix.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `dynamic` | — | first value consumed by this operation. |
| `second` | `dynamic` | — | second value consumed by this operation. |
| `count` | `dynamic` | — | Number of items or units to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L3041)

<a id="function-function-miniquake2-renderer-opengl-openglbeamscalars-function-openglbeamscalars-entity-src-miniquake2-renderer-opengl-ml-1584572985"></a>
### openGlBeamScalars

```ml
function openGlBeamScalars(entity)
```

Open gl beam scalars.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L697)

<a id="function-function-miniquake2-renderer-opengl-openglbeginframe-function-openglbeginframe-cameraseparation-src-miniquake2-renderer-opengl-ml-448812735"></a>
### openGlBeginFrame

```ml
function openGlBeginFrame(cameraSeparation)
```

Open gl begin frame.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `cameraSeparation` | `dynamic` | — | cameraSeparation value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L2444)

<a id="function-function-miniquake2-renderer-opengl-openglbeginregistration-function-openglbeginregistration-mapname-src-miniquake2-renderer-opengl-ml-164577937"></a>
### openGlBeginRegistration

```ml
function openGlBeginRegistration(mapName)
```

Open gl begin registration.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L2084)

<a id="global-global-miniquake2-renderer-opengl-openglbrushsubmissionscratch-openglbrushsubmissionscratch-src-miniquake2-renderer-opengl-ml-731856812"></a>
### openGlBrushSubmissionScratch

```ml
openGlBrushSubmissionScratch
```

Stores module-wide open gl brush submission scratch state for the miniquake2 renderer opengl module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L409)

<a id="function-function-miniquake2-renderer-opengl-openglcinematicsetpalette-function-openglcinematicsetpalette-palette-src-miniquake2-renderer-opengl-ml-599779515"></a>
### openGlCinematicSetPalette

```ml
function openGlCinematicSetPalette(palette)
```

Open gl cinematic set palette.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `palette` | `dynamic` | — | palette value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L2433)

<a id="global-global-miniquake2-renderer-opengl-openglclassictexturecoordinatescratch-openglclassictexturecoordinatescratch-src-miniquake2-renderer-opengl-ml-1832659478"></a>
### openGlClassicTextureCoordinateScratch

```ml
openGlClassicTextureCoordinateScratch
```

Stores module-wide open gl classic texture coordinate scratch state for the miniquake2 renderer opengl module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L407)

<a id="function-function-miniquake2-renderer-opengl-opengldrawchar-function-opengldrawchar-x-y-character-src-miniquake2-renderer-opengl-ml-756273722"></a>
### openGlDrawChar

```ml
function openGlDrawChar(x, y, character)
```

Open gl draw char.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `character` | `dynamic` | — | character value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L2334)

<a id="function-function-miniquake2-renderer-opengl-opengldrawfadescreen-function-opengldrawfadescreen-src-miniquake2-renderer-opengl-ml-1897873926"></a>
### openGlDrawFadeScreen

```ml
function openGlDrawFadeScreen()
```

Open gl draw fade screen.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L2381)

<a id="function-function-miniquake2-renderer-opengl-opengldrawfill-function-opengldrawfill-x-y-width-height-color-src-miniquake2-renderer-opengl-ml-242827641"></a>
### openGlDrawFill

```ml
function openGlDrawFill(x, y, width, height, color)
```

Open gl draw fill.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `width` | `dynamic` | — | Width in the coordinate or storage units used by the caller. |
| `height` | `dynamic` | — | Height in the coordinate or storage units used by the caller. |
| `color` | `dynamic` | — | color value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L2372)

<a id="function-function-miniquake2-renderer-opengl-opengldrawgetpicsize-function-opengldrawgetpicsize-name-src-miniquake2-renderer-opengl-ml-1296027055"></a>
### openGlDrawGetPicSize

```ml
function openGlDrawGetPicSize(name)
```

Open gl draw get pic size.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L2290)

<a id="function-function-miniquake2-renderer-opengl-opengldrawpic-function-opengldrawpic-x-y-name-src-miniquake2-renderer-opengl-ml-115152524"></a>
### openGlDrawPic

```ml
function openGlDrawPic(x, y, name)
```

Open gl draw pic.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L2303)

<a id="function-function-miniquake2-renderer-opengl-opengldrawstretchpic-function-opengldrawstretchpic-x-y-width-height-name-src-miniquake2-renderer-opengl-ml-1608611583"></a>
### openGlDrawStretchPic

```ml
function openGlDrawStretchPic(x, y, width, height, name)
```

Open gl draw stretch pic.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `width` | `dynamic` | — | Width in the coordinate or storage units used by the caller. |
| `height` | `dynamic` | — | Height in the coordinate or storage units used by the caller. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L2319)

<a id="function-function-miniquake2-renderer-opengl-opengldrawstretchraw-function-opengldrawstretchraw-x-y-width-height-columns-rows-data-src-miniquake2-renderer-opengl-ml-135738270"></a>
### openGlDrawStretchRaw

```ml
function openGlDrawStretchRaw(x, y, width, height, columns, rows, data)
```

Open gl draw stretch raw.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `width` | `dynamic` | — | Width in the coordinate or storage units used by the caller. |
| `height` | `dynamic` | — | Height in the coordinate or storage units used by the caller. |
| `columns` | `dynamic` | — | columns value consumed by this operation. |
| `rows` | `dynamic` | — | rows value consumed by this operation. |
| `data` | `dynamic` | — | Input data consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L2395)

<a id="function-function-miniquake2-renderer-opengl-opengldrawtileclear-function-opengldrawtileclear-x-y-width-height-name-src-miniquake2-renderer-opengl-ml-900889355"></a>
### openGlDrawTileClear

```ml
function openGlDrawTileClear(x, y, width, height, name)
```

Open gl draw tile clear.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `width` | `dynamic` | — | Width in the coordinate or storage units used by the caller. |
| `height` | `dynamic` | — | Height in the coordinate or storage units used by the caller. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L2355)

<a id="function-function-miniquake2-renderer-opengl-openglendframe-function-openglendframe-src-miniquake2-renderer-opengl-ml-1532847054"></a>
### openGlEndFrame

```ml
function openGlEndFrame()
```

Open gl end frame.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L2461)

<a id="function-function-miniquake2-renderer-opengl-openglendregistration-function-openglendregistration-src-miniquake2-renderer-opengl-ml-403099952"></a>
### openGlEndRegistration

```ml
function openGlEndRegistration()
```

Open gl end registration.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L2167)

- [miniquake2.renderer.opengl.OpenGlFileImports](Type-miniquake2-renderer-opengl-openglfileimports-1770640198.md) — struct
<a id="global-global-miniquake2-renderer-opengl-openglframeslot-openglframeslot-src-miniquake2-renderer-opengl-ml-201801630"></a>
### openGlFrameSlot

```ml
openGlFrameSlot
```

Stores module-wide open gl frame slot state for the miniquake2 renderer opengl module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L398)

- [miniquake2.renderer.opengl.OpenGlFrameSlot](Type-miniquake2-renderer-opengl-openglframeslot-1468631607.md) — struct
<a id="function-function-miniquake2-renderer-opengl-openglloadgamepalette-function-openglloadgamepalette-backend-src-miniquake2-renderer-opengl-ml-1791612284"></a>
### openGlLoadGamePalette

```ml
function openGlLoadGamePalette(backend)
```

Open gl load game palette.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `backend` | `dynamic` | — | backend value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L498)

<a id="function-function-miniquake2-renderer-opengl-openglmakeexports-function-openglmakeexports-src-miniquake2-renderer-opengl-ml-1810740758"></a>
### openGlMakeExports

```ml
function openGlMakeExports()
```

Open gl make exports.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L2487)

<a id="function-function-miniquake2-renderer-opengl-openglmd2entityinfrustum-inline-function-openglmd2entityinfrustum-modelasset-entity-frame-src-miniquake2-renderer-opengl-ml-817030282"></a>
### openGlMd2EntityInFrustum

```ml
inline function openGlMd2EntityInFrustum(modelAsset, entity, frame)
```

Conservatively cull alias models with the union radius of the current and previous poses. Weapon models deliberately bypass the world frustum, as in the original R_CullAliasModel call site.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `modelAsset` | `dynamic` | — | modelAsset value consumed by this operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `frame` | `dynamic` | — | frame value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L1700)

<a id="function-function-miniquake2-renderer-opengl-openglmd2entityvisible-inline-function-openglmd2entityvisible-backend-entity-src-miniquake2-renderer-opengl-ml-1942906046"></a>
### openGlMd2EntityVisible

```ml
inline function openGlMd2EntityVisible(backend, entity)
```

Report whether open gl md 2 entity visible.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `backend` | `dynamic` | — | backend value consumed by this operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L1690)

<a id="function-function-miniquake2-renderer-opengl-openglmd2frameshade-function-openglmd2frameshade-backend-frame-entity-src-miniquake2-renderer-opengl-ml-1807286880"></a>
### openGlMd2FrameShade

```ml
function openGlMd2FrameShade(backend, frame, entity)
```

Open gl md 2 frame shade.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `backend` | `dynamic` | — | backend value consumed by this operation. |
| `frame` | `dynamic` | — | frame value consumed by this operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L1472)

<a id="function-function-miniquake2-renderer-opengl-openglmd2frameshadecomponents-function-openglmd2frameshadecomponents-backend-frame-entity-src-miniquake2-renderer-opengl-ml-1455797552"></a>
### openGlMd2FrameShadeComponents

```ml
function openGlMd2FrameShadeComponents(backend, frame, entity)
```

Open gl md 2 frame shade components for diagnostic callers without a stable live RefDef slot.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `backend` | `dynamic` | — | backend value consumed by this operation. |
| `frame` | `dynamic` | — | frame value consumed by this operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L1464)

<a id="function-function-miniquake2-renderer-opengl-openglmd2frameshadecomponentsat-function-openglmd2frameshadecomponentsat-backend-frame-entity-entityindex-src-miniquake2-renderer-opengl-ml-2122535567"></a>
### openGlMd2FrameShadeComponentsAt

```ml
function openGlMd2FrameShadeComponentsAt(backend, frame, entity, entityIndex)
```

Open gl md 2 frame shade components.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `backend` | `dynamic` | — | backend value consumed by this operation. |
| `frame` | `dynamic` | — | frame value consumed by this operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `entityIndex` | `dynamic` | — | Zero-based index of entity. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L1436)

<a id="function-function-miniquake2-renderer-opengl-openglmd2geometrystate-inline-function-openglmd2geometrystate-frameindex-oldframeindex-src-miniquake2-renderer-opengl-ml-1936847042"></a>
### openGlMd2GeometryState

```ml
inline function openGlMd2GeometryState(frameIndex, oldFrameIndex)
```

Return the immutable GPU cache state for one MD2 frame pair.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `frameIndex` | `dynamic` | — | Zero-based index of frame. |
| `oldFrameIndex` | `dynamic` | — | Zero-based index of old frame. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L1716)

<a id="function-function-miniquake2-renderer-opengl-openglmd2modelpitch-inline-function-openglmd2modelpitch-angle-src-miniquake2-renderer-opengl-ml-1065496150"></a>
### openGlMd2ModelPitch

```ml
inline function openGlMd2ModelPitch(angle)
```

R_DrawAliasModel negates PITCH before calling R_RotateForEntity (the original source's "sigh" workaround). R_RotateForEntity negates it again, so alias models use a positive pitch rotation while brush models do not.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `angle` | `dynamic` | — | angle value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L1546)

<a id="function-function-miniquake2-renderer-opengl-openglmd2normalvectors-function-openglmd2normalvectors-backend-src-miniquake2-renderer-opengl-ml-69985044"></a>
### openGlMd2NormalVectors

```ml
function openGlMd2NormalVectors(backend)
```

Open gl md 2 normal vectors.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `backend` | `dynamic` | — | backend value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L1522)

<a id="function-function-miniquake2-renderer-opengl-openglmd2shade-function-openglmd2shade-entity-time-src-miniquake2-renderer-opengl-ml-326254280"></a>
### openGlMd2Shade

```ml
function openGlMd2Shade(entity, time)
```

Open gl md 2 shade.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `time` | `dynamic` | — | time value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L1378)

<a id="function-function-miniquake2-renderer-opengl-openglmd2shadecolor-function-openglmd2shadecolor-entity-time-rdflags-basecolor-src-miniquake2-renderer-opengl-ml-884187445"></a>
### openGlMd2ShadeColor

```ml
function openGlMd2ShadeColor(entity, time, rdFlags, baseColor)
```

Open gl md 2 shade color.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `time` | `dynamic` | — | time value consumed by this operation. |
| `rdFlags` | `dynamic` | — | rdFlags value consumed by this operation. |
| `baseColor` | `dynamic` | — | baseColor value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L1370)

<a id="function-function-miniquake2-renderer-opengl-openglmd2shadecomponents-function-openglmd2shadecomponents-entity-time-rdflags-basecolor-src-miniquake2-renderer-opengl-ml-1272819385"></a>
### openGlMd2ShadeComponents

```ml
function openGlMd2ShadeComponents(entity, time, rdFlags, baseColor)
```

Open gl md 2 shade components.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `time` | `dynamic` | — | time value consumed by this operation. |
| `rdFlags` | `dynamic` | — | rdFlags value consumed by this operation. |
| `baseColor` | `dynamic` | — | baseColor value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L1314)

<a id="function-function-miniquake2-renderer-opengl-openglmd2shaderow-function-openglmd2shaderow-backend-yaw-src-miniquake2-renderer-opengl-ml-2116222425"></a>
### openGlMd2ShadeRow

```ml
function openGlMd2ShadeRow(backend, yaw)
```

Open gl md 2 shade row.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `backend` | `dynamic` | — | backend value consumed by this operation. |
| `yaw` | `dynamic` | — | yaw value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L1510)

<a id="function-function-miniquake2-renderer-opengl-openglmd2shaderowindex-inline-function-openglmd2shaderowindex-yaw-src-miniquake2-renderer-opengl-ml-1054369630"></a>
### openGlMd2ShadeRowIndex

```ml
inline function openGlMd2ShadeRowIndex(yaw)
```

Open gl md 2 shade row index.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `yaw` | `dynamic` | — | yaw value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L1479)

<a id="function-function-miniquake2-renderer-opengl-openglmd2shadoweligible-inline-function-openglmd2shadoweligible-backend-entity-src-miniquake2-renderer-opengl-ml-1744980926"></a>
### openGlMd2ShadowEligible

```ml
inline function openGlMd2ShadowEligible(backend, entity)
```

Open gl md 2 shadow eligible.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `backend` | `dynamic` | — | backend value consumed by this operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L1904)

<a id="function-function-miniquake2-renderer-opengl-openglmd2shadowlightheight-inline-function-openglmd2shadowlightheight-entity-spotz-src-miniquake2-renderer-opengl-ml-747664322"></a>
### openGlMd2ShadowLightHeight

```ml
inline function openGlMd2ShadowLightHeight(entity, spotZ)
```

Open gl md 2 shadow light height.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `spotZ` | `dynamic` | — | spotZ value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L1928)

<a id="function-function-miniquake2-renderer-opengl-openglmd2shadowvectorx-inline-function-openglmd2shadowvectorx-yaw-src-miniquake2-renderer-opengl-ml-814080998"></a>
### openGlMd2ShadowVectorX

```ml
inline function openGlMd2ShadowVectorX(yaw)
```

Open gl md 2 shadow vector x.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `yaw` | `dynamic` | — | yaw value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L1915)

<a id="function-function-miniquake2-renderer-opengl-openglmd2shadowvectory-inline-function-openglmd2shadowvectory-yaw-src-miniquake2-renderer-opengl-ml-1361576880"></a>
### openGlMd2ShadowVectorY

```ml
inline function openGlMd2ShadowVectorY(yaw)
```

Open gl md 2 shadow vector y.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `yaw` | `dynamic` | — | yaw value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L1921)

<a id="function-function-miniquake2-renderer-opengl-openglmd2staticgeometrypass-inline-function-openglmd2staticgeometrypass-frameindex-oldframeindex-shell-src-miniquake2-renderer-opengl-ml-1137357970"></a>
### openGlMd2StaticGeometryPass

```ml
inline function openGlMd2StaticGeometryPass(frameIndex, oldFrameIndex, shell)
```

Power-shell vertices depend on backLerp and therefore cannot reuse the immutable native frame-pair cache used by ordinary MD2 geometry.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `frameIndex` | `dynamic` | — | Zero-based index of frame. |
| `oldFrameIndex` | `dynamic` | — | Zero-based index of old frame. |
| `shell` | `dynamic` | — | shell value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L1725)

<a id="function-function-miniquake2-renderer-opengl-openglmd2staticlightsample-function-openglmd2staticlightsample-backend-frame-entity-entityindex-src-miniquake2-renderer-opengl-ml-715681473"></a>
### openGlMd2StaticLightSample

```ml
function openGlMd2StaticLightSample(backend, frame, entity, entityIndex)
```

Return a cached static BSP sample for one live RefDef entity slot.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `backend` | `dynamic` | — | backend value consumed by this operation. |
| `frame` | `dynamic` | — | frame value consumed by this operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `entityIndex` | `dynamic` | — | Zero-based index of entity. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L1410)

<a id="function-function-miniquake2-renderer-opengl-openglpackmd2shade-inline-function-openglpackmd2shade-color-src-miniquake2-renderer-opengl-ml-1425570680"></a>
### openGlPackMd2Shade

```ml
inline function openGlPackMd2Shade(color)
```

Open gl pack md 2 shade.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `color` | `dynamic` | — | color value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L1360)

<a id="function-function-miniquake2-renderer-opengl-openglpalettecolor-inline-function-openglpalettecolor-palette-index-src-miniquake2-renderer-opengl-ml-327790708"></a>
### openGlPaletteColor

```ml
inline function openGlPaletteColor(palette, index)
```

Open gl palette color.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `palette` | `dynamic` | — | palette value consumed by this operation. |
| `index` | `dynamic` | — | Zero-based index of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L488)

<a id="function-function-miniquake2-renderer-opengl-openglparticlepixels-function-openglparticlepixels-src-miniquake2-renderer-opengl-ml-2024070146"></a>
### openGlParticlePixels

```ml
function openGlParticlePixels()
```

Open gl particle pixels.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L528)

<a id="global-global-miniquake2-renderer-opengl-openglparticlerecords-openglparticlerecords-src-miniquake2-renderer-opengl-ml-248665942"></a>
### openGlParticleRecords

```ml
openGlParticleRecords
```

Stores module-wide open gl particle records state for the miniquake2 renderer opengl module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L405)

<a id="global-global-miniquake2-renderer-opengl-openglpendingclassicpasses-openglpendingclassicpasses-src-miniquake2-renderer-opengl-ml-361764540"></a>
### openGlPendingClassicPasses

```ml
openGlPendingClassicPasses
```

Stores module-wide open gl pending classic passes state for the miniquake2 renderer opengl module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L400)

- [miniquake2.renderer.opengl.OpenGlPendingClassicPasses](Type-miniquake2-renderer-opengl-openglpendingclassicpasses-398591638.md) — struct
<a id="function-function-miniquake2-renderer-opengl-openglpolyblendcolor-function-openglpolyblendcolor-blend-src-miniquake2-renderer-opengl-ml-606269245"></a>
### openGlPolyBlendColor

```ml
function openGlPolyBlendColor(blend)
```

ref_gl copies RefDef.blend into v_blend and overlays it after the complete 3-D scene.  This carries damage flashes, underwater tint and powerup color shifts; retaining the field without drawing it leaves all three invisible.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `blend` | `dynamic` | — | blend value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L1267)

- [miniquake2.renderer.opengl.OpenGlRawFrame](Type-miniquake2-renderer-opengl-openglrawframe-7544385.md) — struct
<a id="function-function-miniquake2-renderer-opengl-openglregistermodel-function-openglregistermodel-name-src-miniquake2-renderer-opengl-ml-191975065"></a>
### openGlRegisterModel

```ml
function openGlRegisterModel(name)
```

Open gl register model.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L2102)

<a id="function-function-miniquake2-renderer-opengl-openglregisterpic-function-openglregisterpic-name-src-miniquake2-renderer-opengl-ml-1040728591"></a>
### openGlRegisterPic

```ml
function openGlRegisterPic(name)
```

Open gl register pic.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L2138)

<a id="function-function-miniquake2-renderer-opengl-openglregisterskin-function-openglregisterskin-name-src-miniquake2-renderer-opengl-ml-1804442707"></a>
### openGlRegisterSkin

```ml
function openGlRegisterSkin(name)
```

Open gl register skin.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L2122)

<a id="function-function-miniquake2-renderer-opengl-openglrendererinit-function-openglrendererinit-hinstance-wndproc-src-miniquake2-renderer-opengl-ml-377801644"></a>
### openGlRendererInit

```ml
function openGlRendererInit(hinstance, wndproc)
```

Open gl renderer init.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `hinstance` | `dynamic` | — | hinstance value consumed by this operation. |
| `wndproc` | `dynamic` | — | wndproc value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L2055)

<a id="function-function-miniquake2-renderer-opengl-openglrenderershutdown-function-openglrenderershutdown-src-miniquake2-renderer-opengl-ml-752067094"></a>
### openGlRendererShutdown

```ml
function openGlRendererShutdown()
```

Open gl renderer shutdown.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L2069)

<a id="function-function-miniquake2-renderer-opengl-openglrenderframe-function-openglrenderframe-frame-src-miniquake2-renderer-opengl-ml-11728703"></a>
### openGlRenderFrame

```ml
function openGlRenderFrame(frame)
```

Open gl render frame.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `frame` | `dynamic` | — | frame value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L2240)

<a id="function-function-miniquake2-renderer-opengl-openglrequireinitialized-function-openglrequireinitialized-backend-operation-src-miniquake2-renderer-opengl-ml-1921488677"></a>
### openGlRequireInitialized

```ml
function openGlRequireInitialized(backend, operation)
```

The full product graph is large enough to expose a closure-layout bug in the current self-hosted compiler. The production renderer therefore publishes capture-free top-level callbacks and resolves its one active backend through the package-owned slot. This also keeps the deterministic command recorder out of the real-time path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `backend` | `dynamic` | — | backend value consumed by this operation. |
| `operation` | `dynamic` | — | operation value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L2045)

<a id="function-function-miniquake2-renderer-opengl-openglsetsky-function-openglsetsky-name-rotate-axis-src-miniquake2-renderer-opengl-ml-1187390241"></a>
### openGlSetSky

```ml
function openGlSetSky(name, rotate, axis)
```

Open gl set sky.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Name of the affected item. |
| `rotate` | `dynamic` | — | rotate value consumed by this operation. |
| `axis` | `dynamic` | — | axis value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L2156)

<a id="function-function-miniquake2-renderer-opengl-openglshadebyte-inline-function-openglshadebyte-component-src-miniquake2-renderer-opengl-ml-1100088350"></a>
### openGlShadeByte

```ml
inline function openGlShadeByte(component)
```

Open gl shade byte.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `component` | `dynamic` | — | component value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L1256)

<a id="function-function-miniquake2-renderer-opengl-openglskybounds-function-openglskybounds-draws-vieworigin-src-miniquake2-renderer-opengl-ml-1919258866"></a>
### openGlSkyBounds

```ml
function openGlSkyBounds(draws, viewOrigin)
```

Compatibility wrapper for exact diagnostic arrays.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `draws` | `dynamic` | — | draws value consumed by this operation. |
| `viewOrigin` | `dynamic` | — | viewOrigin value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L3277)

<a id="function-function-miniquake2-renderer-opengl-openglskyboundsprefix-function-openglskyboundsprefix-draws-drawcount-vieworigin-src-miniquake2-renderer-opengl-ml-1871171189"></a>
### openGlSkyBoundsPrefix

```ml
function openGlSkyBoundsPrefix(draws, drawCount, viewOrigin)
```

Open gl sky bounds.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `draws` | `dynamic` | — | draws value consumed by this operation. |
| `drawCount` | `dynamic` | — | Number of draw to process. |
| `viewOrigin` | `dynamic` | — | viewOrigin value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L3248)

<a id="function-function-miniquake2-renderer-opengl-openglskyclipdistance-function-openglskyclipdistance-value-stage-src-miniquake2-renderer-opengl-ml-894132207"></a>
### openGlSkyClipDistance

```ml
function openGlSkyClipDistance(value, stage)
```

Open gl sky clip distance.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `stage` | `dynamic` | — | stage value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L3109)

- [miniquake2.renderer.opengl.OpenGlSkyClipScratch](Type-miniquake2-renderer-opengl-openglskyclipscratch-1904524397.md) — struct
<a id="global-global-miniquake2-renderer-opengl-openglskyscratchslot-openglskyscratchslot-src-miniquake2-renderer-opengl-ml-1151186290"></a>
### openGlSkyScratchSlot

```ml
openGlSkyScratchSlot
```

Stores module-wide open gl sky scratch slot state for the miniquake2 renderer opengl module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L403)

- [miniquake2.renderer.opengl.OpenGlSkyScratchSlot](Type-miniquake2-renderer-opengl-openglskyscratchslot-870322795.md) — struct
- [miniquake2.renderer.opengl.OpenGlState](Type-miniquake2-renderer-opengl-openglstate-2066733135.md) — struct
<a id="function-function-miniquake2-renderer-opengl-openglviewaxes-function-openglviewaxes-viewangles-src-miniquake2-renderer-opengl-ml-1592263789"></a>
### openGlViewAxes

```ml
function openGlViewAxes(viewAngles)
```

Open gl view axes.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `viewAngles` | `dynamic` | — | viewAngles value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L510)

- [miniquake2.renderer.opengl.OpenGlViewAxes](Type-miniquake2-renderer-opengl-openglviewaxes-380884138.md) — struct
<a id="function-function-miniquake2-renderer-opengl-picturepixels-function-picturepixels-asset-src-miniquake2-renderer-opengl-ml-455015170"></a>
### picturePixels

```ml
function picturePixels(asset)
```

Return the picture pixels value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `asset` | `dynamic` | — | asset value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L969)

<a id="function-function-miniquake2-renderer-opengl-pictureuploadpixels-function-pictureuploadpixels-asset-src-miniquake2-renderer-opengl-ml-1180585176"></a>
### pictureUploadPixels

```ml
function pictureUploadPixels(asset)
```

Return the picture upload pixels value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `asset` | `dynamic` | — | asset value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L998)

<a id="function-function-miniquake2-renderer-opengl-precacheopenglclassicgeometry-function-precacheopenglclassicgeometry-world-src-miniquake2-renderer-opengl-ml-356891068"></a>
### precacheOpenGlClassicGeometry

```ml
function precacheOpenGlClassicGeometry(world)
```

Open precache gl classic geometry.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L2901)

<a id="function-function-miniquake2-renderer-opengl-prepareclassicbrushframe-function-prepareclassicbrushframe-binding-world-frame-src-miniquake2-renderer-opengl-ml-87097228"></a>
### prepareClassicBrushFrame

```ml
function prepareClassicBrushFrame(binding, world, frame)
```

Product-graph-facing CPU plan. It consumes the same model handles emitted by client asset registration, but never reparses or expands the adopted BSP.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `binding` | `dynamic` | — | binding value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |
| `frame` | `dynamic` | — | frame value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L3566)

<a id="function-function-miniquake2-renderer-opengl-prepareclassictransparentframe-function-prepareclassictransparentframe-worldplan-brushframe-frame-src-miniquake2-renderer-opengl-ml-1269863075"></a>
### prepareClassicTransparentFrame

```ml
function prepareClassicTransparentFrame(worldPlan, brushFrame, frame)
```

Compatibility wrapper returning an exact diagnostic array.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `worldPlan` | `dynamic` | — | worldPlan value consumed by this operation. |
| `brushFrame` | `dynamic` | — | brushFrame value consumed by this operation. |
| `frame` | `dynamic` | — | frame value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L3984)

<a id="function-function-miniquake2-renderer-opengl-prepareclassictransparentframeprefix-function-prepareclassictransparentframeprefix-worldplan-brushframe-frame-src-miniquake2-renderer-opengl-ml-1113166403"></a>
### prepareClassicTransparentFramePrefix

```ml
function prepareClassicTransparentFramePrefix(worldPlan, brushFrame, frame)
```

Prepare classic transparent frame.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `worldPlan` | `dynamic` | — | worldPlan value consumed by this operation. |
| `brushFrame` | `dynamic` | — | brushFrame value consumed by this operation. |
| `frame` | `dynamic` | — | frame value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L3927)

<a id="function-function-miniquake2-renderer-opengl-prepareclassicworld-function-prepareclassicworld-binding-map-loadfile-lightstyles-entityframe-modulate-src-miniquake2-renderer-opengl-ml-881910946"></a>
### prepareClassicWorld

```ml
function prepareClassicWorld(binding, map, loadFile, lightStyles, entityFrame, modulate)
```

Prepare classic world.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `binding` | `dynamic` | — | binding value consumed by this operation. |
| `map` | `dynamic` | — | map value consumed by this operation. |
| `loadFile` | `dynamic` | — | loadFile value consumed by this operation. |
| `lightStyles` | `dynamic` | — | lightStyles value consumed by this operation. |
| `entityFrame` | `dynamic` | — | entityFrame value consumed by this operation. |
| `modulate` | `dynamic` | — | modulate value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L2652)

<a id="function-function-miniquake2-renderer-opengl-preparemd2entity-function-preparemd2entity-binding-entity-src-miniquake2-renderer-opengl-ml-1965608834"></a>
### prepareMd2Entity

```ml
function prepareMd2Entity(binding, entity)
```

Prepare md 2 entity.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `binding` | `dynamic` | — | binding value consumed by this operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L4315)

<a id="function-function-miniquake2-renderer-opengl-prepareopenglclassicdraw-function-prepareopenglclassicdraw-draw-pass-lightmap-src-miniquake2-renderer-opengl-ml-1430436113"></a>
### prepareOpenGlClassicDraw

```ml
function prepareOpenGlClassicDraw(draw, pass, lightmap)
```

Prepare open gl classic draw.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `draw` | `dynamic` | — | draw value consumed by this operation. |
| `pass` | `dynamic` | — | pass value consumed by this operation. |
| `lightmap` | `dynamic` | — | lightmap value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L2866)

<a id="function-function-miniquake2-renderer-opengl-prepareopenglclassicmultitexturedraw-function-prepareopenglclassicmultitexturedraw-draw-src-miniquake2-renderer-opengl-ml-1892611080"></a>
### prepareOpenGlClassicMultitextureDraw

```ml
function prepareOpenGlClassicMultitextureDraw(draw)
```

Prepare open gl classic multitexture draw.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `draw` | `dynamic` | — | draw value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L2880)

<a id="function-function-miniquake2-renderer-opengl-prepareopenglmd2entity-function-prepareopenglmd2entity-backend-entity-src-miniquake2-renderer-opengl-ml-522814137"></a>
### prepareOpenGlMd2Entity

```ml
function prepareOpenGlMd2Entity(backend, entity)
```

Prepare open gl md 2 entity.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `backend` | `dynamic` | — | backend value consumed by this operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L1215)

<a id="function-function-miniquake2-renderer-opengl-prepareopenglrawframe-function-prepareopenglrawframe-columns-rows-data-palette-reusable-src-miniquake2-renderer-opengl-ml-2093502468"></a>
### prepareOpenGlRawFrame

```ml
function prepareOpenGlRawFrame(columns, rows, data, palette, reusable)
```

Prepare open gl raw frame.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `columns` | `dynamic` | — | columns value consumed by this operation. |
| `rows` | `dynamic` | — | rows value consumed by this operation. |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `palette` | `dynamic` | — | palette value consumed by this operation. |
| `reusable` | `dynamic` | — | reusable value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L555)

<a id="function-function-miniquake2-renderer-opengl-prepareproductrefdef-function-prepareproductrefdef-frame-src-miniquake2-renderer-opengl-ml-907809295"></a>
### prepareProductRefDef

```ml
function prepareProductRefDef(frame)
```

Normalize the mutable effect handoff counts and validate its constant-time product contract. A zero client viewport is a normal minimized-window state, not a fatal renderer error.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `frame` | `dynamic` | — | frame value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L2202)

<a id="function-function-miniquake2-renderer-opengl-projectopenglskypolygon-function-projectopenglskypolygon-bounds-vertices-count-src-miniquake2-renderer-opengl-ml-1646244569"></a>
### projectOpenGlSkyPolygon

```ml
function projectOpenGlSkyPolygon(bounds, vertices, count)
```

Project open gl sky polygon.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `bounds` | `dynamic` | — | bounds value consumed by this operation. |
| `vertices` | `dynamic` | — | vertices value consumed by this operation. |
| `count` | `dynamic` | — | Number of items or units to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L3122)

<a id="function-function-miniquake2-renderer-opengl-pushopenglclassicbrush-function-pushopenglclassicbrush-entity-src-miniquake2-renderer-opengl-ml-1040299951"></a>
### pushOpenGlClassicBrush

```ml
function pushOpenGlClassicBrush(entity)
```

Open push gl classic brush.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L3789)

<a id="function-function-miniquake2-renderer-opengl-recordclassicdeferreduploads-function-recordclassicdeferreduploads-stats-uploaded-src-miniquake2-renderer-opengl-ml-1382352997"></a>
### recordClassicDeferredUploads

```ml
function recordClassicDeferredUploads(stats, uploaded)
```

Add uploads completed after submitClassicWorld returned to its retained mutable diagnostic record.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `stats` | `dynamic` | — | stats value consumed by this operation. |
| `uploaded` | `dynamic` | — | uploaded value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L2032)

<a id="function-function-miniquake2-renderer-opengl-registermd2model-function-registermd2model-binding-name-loadfile-src-miniquake2-renderer-opengl-ml-2003921032"></a>
### registerMd2Model

```ml
function registerMd2Model(binding, name, loadFile)
```

Callback-backed registration for createOpenGlRenderer(), whose refimport is intentionally void. getRefAPI() users can use exports.RegisterModel.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `binding` | `dynamic` | — | binding value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |
| `loadFile` | `dynamic` | — | loadFile value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L4281)

<a id="function-function-miniquake2-renderer-opengl-releaseclassicworld-function-releaseclassicworld-binding-world-src-miniquake2-renderer-opengl-ml-495277581"></a>
### releaseClassicWorld

```ml
function releaseClassicWorld(binding, world)
```

Release classic world.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `binding` | `dynamic` | — | binding value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L4246)

<a id="function-function-miniquake2-renderer-opengl-releaseopengltexturerecord-function-releaseopengltexturerecord-backend-record-src-miniquake2-renderer-opengl-ml-262700847"></a>
### releaseOpenGlTextureRecord

```ml
function releaseOpenGlTextureRecord(backend, record)
```

Release open gl texture record.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `backend` | `dynamic` | — | backend value consumed by this operation. |
| `record` | `dynamic` | — | record value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L447)

<a id="function-function-miniquake2-renderer-opengl-releaseopengltexturerecords-function-releaseopengltexturerecords-backend-src-miniquake2-renderer-opengl-ml-1317179634"></a>
### releaseOpenGlTextureRecords

```ml
function releaseOpenGlTextureRecords(backend)
```

Release open gl texture records.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `backend` | `dynamic` | — | backend value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L464)

<a id="function-function-miniquake2-renderer-opengl-resetopenglskybounds-function-resetopenglskybounds-bounds-src-miniquake2-renderer-opengl-ml-886329557"></a>
### resetOpenGlSkyBounds

```ml
function resetOpenGlSkyBounds(bounds)
```

Reset the persistent sky bounds for a new view.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `bounds` | `dynamic` | — | bounds value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L3096)

<a id="function-function-miniquake2-renderer-opengl-resolveopenglmd2skin-function-resolveopenglmd2skin-backend-modelasset-entity-src-miniquake2-renderer-opengl-ml-346649908"></a>
### resolveOpenGlMd2Skin

```ml
function resolveOpenGlMd2Skin(backend, modelAsset, entity)
```

Resolve open gl md 2 skin.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `backend` | `dynamic` | — | backend value consumed by this operation. |
| `modelAsset` | `dynamic` | — | modelAsset value consumed by this operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L1204)

<a id="function-function-miniquake2-renderer-opengl-restoreclassicregistration-function-restoreclassicregistration-binding-world-registrationassets-src-miniquake2-renderer-opengl-ml-252892095"></a>
### restoreClassicRegistration

```ml
function restoreClassicRegistration(binding, world, registrationAssets)
```

Rebind an intact CPU-side world and asset graph to a replacement OpenGL context. Resolution/fullscreen changes invalidate native texture names, but do not require reparsing the BSP, WAL, PCX, MD2, SP2 or WAV resources.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `binding` | `dynamic` | — | binding value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |
| `registrationAssets` | `dynamic` | — | registrationAssets value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L2726)

<a id="function-function-miniquake2-renderer-opengl-setbrightness-function-setbrightness-binding-brightness-src-miniquake2-renderer-opengl-ml-1912649712"></a>
### setBrightness

```ml
function setBrightness(binding, brightness)
```

Set the post-composition brightness/gamma value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `binding` | `dynamic` | — | binding value consumed by this operation. |
| `brightness` | `dynamic` | — | brightness value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L2696)

<a id="function-function-miniquake2-renderer-opengl-setcontextactive-function-setcontextactive-binding-active-src-miniquake2-renderer-opengl-ml-1379004165"></a>
### setContextActive

```ml
function setContextActive(binding, active)
```

Report whether set context active.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `binding` | `dynamic` | — | binding value consumed by this operation. |
| `active` | `dynamic` | — | active value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L2528)

<a id="function-function-miniquake2-renderer-opengl-sethandedness-function-sethandedness-binding-hand-src-miniquake2-renderer-opengl-ml-1728588486"></a>
### setHandedness

```ml
function setHandedness(binding, hand)
```

Set handedness.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `binding` | `dynamic` | — | binding value consumed by this operation. |
| `hand` | `dynamic` | — | hand value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L2548)

<a id="function-function-miniquake2-renderer-opengl-setopenglskyscratchvertex-inline-function-setopenglskyscratchvertex-buffer-index-x-y-z-src-miniquake2-renderer-opengl-ml-599047300"></a>
### setOpenGlSkyScratchVertex

```ml
inline function setOpenGlSkyScratchVertex(buffer, index, x, y, z)
```

Copy coordinates into one retained vertex object.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `index` | `dynamic` | — | Zero-based index of the affected item. |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `z` | `dynamic` | — | z value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L3088)

<a id="function-function-miniquake2-renderer-opengl-setshadows-function-setshadows-binding-enabled-src-miniquake2-renderer-opengl-ml-1835207808"></a>
### setShadows

```ml
function setShadows(binding, enabled)
```

Set shadows.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `binding` | `dynamic` | — | binding value consumed by this operation. |
| `enabled` | `dynamic` | — | enabled value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L2565)

<a id="function-function-miniquake2-renderer-opengl-setup2d-function-setup2d-src-miniquake2-renderer-opengl-ml-1075611364"></a>
### setup2d

```ml
function setup2d()
```

Return the setup 2 d value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L927)

<a id="function-function-miniquake2-renderer-opengl-setup3d-function-setup3d-frame-src-miniquake2-renderer-opengl-ml-598514735"></a>
### setup3d

```ml
function setup3d(frame)
```

Return the setup 3 d value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `frame` | `dynamic` | — | frame value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L628)

<a id="function-function-miniquake2-renderer-opengl-shadows-function-shadows-binding-src-miniquake2-renderer-opengl-ml-2120890009"></a>
### shadows

```ml
function shadows(binding)
```

Return the shadows value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `binding` | `dynamic` | — | binding value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L2575)

<a id="function-function-miniquake2-renderer-opengl-sortclassicbrushsubmissionprefix-function-sortclassicbrushsubmissionprefix-submissions-count-vieworigin-src-miniquake2-renderer-opengl-ml-1518196911"></a>
### sortClassicBrushSubmissionPrefix

```ml
function sortClassicBrushSubmissionPrefix(submissions, count, viewOrigin)
```

Sort classic brush submission prefix.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `submissions` | `dynamic` | — | submissions value consumed by this operation. |
| `count` | `dynamic` | — | Number of items or units to process. |
| `viewOrigin` | `dynamic` | — | viewOrigin value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L3399)

<a id="function-function-miniquake2-renderer-opengl-sortclassicbrushsubmissions-function-sortclassicbrushsubmissions-submissions-vieworigin-src-miniquake2-renderer-opengl-ml-1209396876"></a>
### sortClassicBrushSubmissions

```ml
function sortClassicBrushSubmissions(submissions, viewOrigin)
```

Sort classic brush submissions.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `submissions` | `dynamic` | — | submissions value consumed by this operation. |
| `viewOrigin` | `dynamic` | — | viewOrigin value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L3379)

<a id="function-function-miniquake2-renderer-opengl-sortclassictransparentdraws-function-sortclassictransparentdraws-draws-src-miniquake2-renderer-opengl-ml-2119517715"></a>
### sortClassicTransparentDraws

```ml
function sortClassicTransparentDraws(draws)
```

Sort classic transparent draws.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `draws` | `dynamic` | — | draws value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L3889)

<a id="function-function-miniquake2-renderer-opengl-sortclassictransparentdrawsinplace-function-sortclassictransparentdrawsinplace-draws-count-src-miniquake2-renderer-opengl-ml-1660593984"></a>
### sortClassicTransparentDrawsInPlace

```ml
function sortClassicTransparentDrawsInPlace(draws, count)
```

Sort classic transparent draws in place.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `draws` | `dynamic` | — | draws value consumed by this operation. |
| `count` | `dynamic` | — | Number of items or units to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L3907)

<a id="function-function-miniquake2-renderer-opengl-submitclassicworld-function-submitclassicworld-binding-world-frame-src-miniquake2-renderer-opengl-ml-822956092"></a>
### submitClassicWorld

```ml
function submitClassicWorld(binding, world, frame)
```

Product BSP handoff. Geometry debug remains independent via submitTriangleMesh. This path follows the classic order: lit opaque base, multiplicative lightmaps, turbulent water, sky portals, then sorted alpha.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `binding` | `dynamic` | — | binding value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |
| `frame` | `dynamic` | — | frame value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L4059)

<a id="function-function-miniquake2-renderer-opengl-submitmd2entity-function-submitmd2entity-binding-entity-src-miniquake2-renderer-opengl-ml-691984534"></a>
### submitMd2Entity

```ml
function submitMd2Entity(binding, entity)
```

Explicit handoff for tools. Product RefDef entities are submitted automatically by RenderFrame when entity.model is a current MD2 handle.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `binding` | `dynamic` | — | binding value consumed by this operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L4323)

<a id="function-function-miniquake2-renderer-opengl-submitopenglclassicdraw-function-submitopenglclassicdraw-draw-lightmap-time-src-miniquake2-renderer-opengl-ml-485660003"></a>
### submitOpenGlClassicDraw

```ml
function submitOpenGlClassicDraw(draw, lightmap, time)
```

Submit open gl classic draw.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `draw` | `dynamic` | — | draw value consumed by this operation. |
| `lightmap` | `dynamic` | — | lightmap value consumed by this operation. |
| `time` | `dynamic` | — | time value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L3018)

<a id="function-function-miniquake2-renderer-opengl-submitopenglclassicmultitexture-function-submitopenglclassicmultitexture-binding-draws-drawcount-time-src-miniquake2-renderer-opengl-ml-1032764978"></a>
### submitOpenGlClassicMultitexture

```ml
function submitOpenGlClassicMultitexture(binding, draws, drawCount, time)
```

Submit open gl classic multitexture.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `binding` | `dynamic` | — | binding value consumed by this operation. |
| `draws` | `dynamic` | — | draws value consumed by this operation. |
| `drawCount` | `dynamic` | — | Number of draw to process. |
| `time` | `dynamic` | — | time value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L2967)

<a id="function-function-miniquake2-renderer-opengl-submitopenglrefdefmd2entities-function-submitopenglrefdefmd2entities-backend-frame-src-miniquake2-renderer-opengl-ml-540516711"></a>
### submitOpenGlRefDefMd2Entities

```ml
function submitOpenGlRefDefMd2Entities(backend, frame)
```

Submit open gl ref def md 2 entities.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `backend` | `dynamic` | — | backend value consumed by this operation. |
| `frame` | `dynamic` | — | frame value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L1841)

<a id="function-function-miniquake2-renderer-opengl-submittrianglemesh-function-submittrianglemesh-binding-mesh-origin-angles-red-green-blue-alpha-src-miniquake2-renderer-opengl-ml-824117658"></a>
### submitTriangleMesh

```ml
function submitTriangleMesh(binding, mesh, origin, angles, red, green, blue, alpha)
```

Independent wireframe/geometry-debug path for BSP38 fan geometry and interpolated MD2 meshes produced by renderer.geometry.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `binding` | `dynamic` | — | binding value consumed by this operation. |
| `mesh` | `dynamic` | — | mesh value consumed by this operation. |
| `origin` | `dynamic` | — | origin value consumed by this operation. |
| `angles` | `dynamic` | — | angles value consumed by this operation. |
| `red` | `dynamic` | — | red value consumed by this operation. |
| `green` | `dynamic` | — | green value consumed by this operation. |
| `blue` | `dynamic` | — | blue value consumed by this operation. |
| `alpha` | `dynamic` | — | alpha value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L4344)

<a id="function-function-miniquake2-renderer-opengl-updateclassicworldlightmaps-function-updateclassicworldlightmaps-binding-world-draws-drawcount-frame-src-miniquake2-renderer-opengl-ml-1779673636"></a>
### updateClassicWorldLightmaps

```ml
function updateClassicWorldLightmaps(binding, world, draws, drawCount, frame)
```

Refresh visible world lightmap rectangles before their opaque base/lightmap pass. Dynamic lights are already in world space, unlike inline brush lights.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `binding` | `dynamic` | — | binding value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |
| `draws` | `dynamic` | — | draws value consumed by this operation. |
| `drawCount` | `dynamic` | — | Number of draw to process. |
| `frame` | `dynamic` | — | frame value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L3745)

<a id="function-function-miniquake2-renderer-opengl-updateopenglmd2lightstyleepoch-function-updateopenglmd2lightstyleepoch-backend-lightstyles-src-miniquake2-renderer-opengl-ml-1898080420"></a>
### updateOpenGlMd2LightStyleEpoch

```ml
function updateOpenGlMd2LightStyleEpoch(backend, lightStyles)
```

Advance the renderer-owned light-style epoch only when RGB content changes. The client mutates its fixed style table at 10 Hz, so array identity alone cannot invalidate cached static point samples.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `backend` | `dynamic` | — | backend value consumed by this operation. |
| `lightStyles` | `dynamic` | — | lightStyles value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L1388)

<a id="function-function-miniquake2-renderer-opengl-uploadclassicbrushlightmap-function-uploadclassicbrushlightmap-binding-brushlightmap-src-miniquake2-renderer-opengl-ml-1523102685"></a>
### uploadClassicBrushLightmap

```ml
function uploadClassicBrushLightmap(binding, brushLightmap)
```

Return the upload classic brush lightmap value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `binding` | `dynamic` | — | binding value consumed by this operation. |
| `brushLightmap` | `dynamic` | — | brushLightmap value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L3708)

<a id="function-function-miniquake2-renderer-opengl-uploadclassiclightmappixels-function-uploadclassiclightmappixels-binding-draw-rgbapixels-src-miniquake2-renderer-opengl-ml-1416761668"></a>
### uploadClassicLightmapPixels

```ml
function uploadClassicLightmapPixels(binding, draw, rgbaPixels)
```

Upload one dirty lightmap rectangle without requiring a per-frame wrapper.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `binding` | `dynamic` | — | binding value consumed by this operation. |
| `draw` | `dynamic` | — | draw value consumed by this operation. |
| `rgbaPixels` | `dynamic` | — | rgbaPixels value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L3718)

<a id="function-function-miniquake2-renderer-opengl-uploadclassictexture-function-uploadclassictexture-binding-texture-src-miniquake2-renderer-opengl-ml-487039962"></a>
### uploadClassicTexture

```ml
function uploadClassicTexture(binding, texture)
```

Return the upload classic texture value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `binding` | `dynamic` | — | binding value consumed by this operation. |
| `texture` | `dynamic` | — | texture value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L2787)

<a id="function-function-miniquake2-renderer-opengl-uploadopenglmipchain-function-uploadopenglmipchain-width-height-rgba-src-miniquake2-renderer-opengl-ml-955670011"></a>
### uploadOpenGlMipChain

```ml
function uploadOpenGlMipChain(width, height, rgba)
```

Upload a complete RGBA mip chain during registration. Keeping mip generation inside this renderer helper restores stock sampling without gameplay heap use.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `width` | `dynamic` | — | Width in the coordinate or storage units used by the caller. |
| `height` | `dynamic` | — | Height in the coordinate or storage units used by the caller. |
| `rgba` | `dynamic` | — | rgba value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L1038)

<a id="function-function-miniquake2-renderer-opengl-uploadpicture-function-uploadpicture-backend-asset-src-miniquake2-renderer-opengl-ml-746273232"></a>
### uploadPicture

```ml
function uploadPicture(backend, asset)
```

Return the upload picture value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `backend` | `dynamic` | — | backend value consumed by this operation. |
| `asset` | `dynamic` | — | asset value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L1082)

<a id="function-function-miniquake2-renderer-opengl-writeopenglbatchu32-inline-function-writeopenglbatchu32-buffer-offset-value-src-miniquake2-renderer-opengl-ml-955215745"></a>
### writeOpenGlBatchU32

```ml
inline function writeOpenGlBatchU32(buffer, offset, value)
```

Write open gl batch u 32.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `offset` | `dynamic` | — | Zero-based offset at which processing starts. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L2924)

<a id="function-function-miniquake2-renderer-opengl-writeopenglmultitexturerecord-inline-function-writeopenglmultitexturerecord-buffer-index-draw-basetextureid-lightmaptextureid-src-miniquake2-renderer-opengl-ml-1546400170"></a>
### writeOpenGlMultitextureRecord

```ml
inline function writeOpenGlMultitextureRecord(buffer, index, draw, baseTextureId, lightmapTextureId)
```

Write open gl multitexture record.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `index` | `dynamic` | — | Zero-based index of the affected item. |
| `draw` | `dynamic` | — | draw value consumed by this operation. |
| `baseTextureId` | `dynamic` | — | Identifier of base texture. |
| `lightmapTextureId` | `dynamic` | — | Identifier of lightmap texture. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L2951)

<a id="function-function-miniquake2-renderer-opengl-writeopenglparticlerecord-function-writeopenglparticlerecord-buffer-index-packed-alpha-origin-src-miniquake2-renderer-opengl-ml-1600618008"></a>
### writeOpenGlParticleRecord

```ml
function writeOpenGlParticleRecord(buffer, index, packed, alpha, origin)
```

Write open gl particle record.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `index` | `dynamic` | — | Zero-based index of the affected item. |
| `packed` | `dynamic` | — | packed value consumed by this operation. |
| `alpha` | `dynamic` | — | alpha value consumed by this operation. |
| `origin` | `dynamic` | — | origin value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L822)
