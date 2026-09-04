# `src/miniquake2/renderer/classic/lightmaps.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 renderer classic lightmaps facilities for this project.

Package: [`miniquake2.renderer.classic.lightmaps`](Package-miniquake2-renderer-classic-lightmaps-777925779.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/format/constants.ml` as `fc` → [src/miniquake2/format/constants.ml](File-src-miniquake2-format-constants-ml-1556940367.md)
- `miniquake2/qcommon/byteio.ml` as `qbyteio` → [src/miniquake2/qcommon/byteio.ml](File-src-miniquake2-qcommon-byteio-ml-159119335.md)
- `miniquake2/renderer/classic/constants.ml` as `rclassicconstants` → [src/miniquake2/renderer/classic/constants.ml](File-src-miniquake2-renderer-classic-constants-ml-1818163902.md)
- `miniquake2/renderer/classic/surfaces.ml` as `rclassicsurfaces` → [src/miniquake2/renderer/classic/surfaces.ml](File-src-miniquake2-renderer-classic-surfaces-ml-1888445105.md)
- `miniquake2/renderer/classic/vector.ml` as `rclassicvector` → [src/miniquake2/renderer/classic/vector.ml](File-src-miniquake2-renderer-classic-vector-ml-1705483236.md)
- `std/math.ml` as `smath` → `../MiniLangCompilerML/std/math.ml` — external dependency

## Declarations

<a id="function-function-miniquake2-renderer-classic-lightmaps-adddynamiclights-function-adddynamiclights-surface-dlights-blocklights-src-miniquake2-renderer-classic-lightmaps-ml-628885203"></a>
### addDynamicLights

```ml
function addDynamicLights(surface, dLights, blockLights)
```

Add dynamic lights.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `surface` | `dynamic` | — | surface value consumed by this operation. |
| `dLights` | `dynamic` | — | dLights value consumed by this operation. |
| `blockLights` | `dynamic` | — | blockLights value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/lightmaps.ml#L115)

<a id="function-function-miniquake2-renderer-classic-lightmaps-adddynamiclightsprefix-function-adddynamiclightsprefix-surface-dlights-dlightcount-blocklights-src-miniquake2-renderer-classic-lightmaps-ml-1484185960"></a>
### addDynamicLightsPrefix

```ml
function addDynamicLightsPrefix(surface, dLights, dLightCount, blockLights)
```

Add a counted dynamic-light prefix.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `surface` | `dynamic` | — | surface value consumed by this operation. |
| `dLights` | `dynamic` | — | dLights value consumed by this operation. |
| `dLightCount` | `dynamic` | — | Number of d light to process. |
| `blockLights` | `dynamic` | — | blockLights value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/lightmaps.ml#L70)

<a id="function-function-miniquake2-renderer-classic-lightmaps-buildlightmap-function-buildlightmap-surface-lightstyles-dlights-modulate-src-miniquake2-renderer-classic-lightmaps-ml-954142412"></a>
### buildLightmap

```ml
function buildLightmap(surface, lightStyles, dLights, modulate)
```

Build lightmap.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `surface` | `dynamic` | — | surface value consumed by this operation. |
| `lightStyles` | `dynamic` | — | lightStyles value consumed by this operation. |
| `dLights` | `dynamic` | — | dLights value consumed by this operation. |
| `modulate` | `dynamic` | — | modulate value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/lightmaps.ml#L202)

<a id="function-function-miniquake2-renderer-classic-lightmaps-buildlightmapprefix-function-buildlightmapprefix-surface-lightstyles-dlights-dlightcount-modulate-src-miniquake2-renderer-classic-lightmaps-ml-1648610741"></a>
### buildLightmapPrefix

```ml
function buildLightmapPrefix(surface, lightStyles, dLights, dLightCount, modulate)
```

Build a lightmap from a counted dynamic-light prefix.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `surface` | `dynamic` | — | surface value consumed by this operation. |
| `lightStyles` | `dynamic` | — | lightStyles value consumed by this operation. |
| `dLights` | `dynamic` | — | dLights value consumed by this operation. |
| `dLightCount` | `dynamic` | — | Number of d light to process. |
| `modulate` | `dynamic` | — | modulate value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/lightmaps.ml#L159)

<a id="function-function-miniquake2-renderer-classic-lightmaps-islitsurface-function-islitsurface-surface-src-miniquake2-renderer-classic-lightmaps-ml-2055716920"></a>
### isLitSurface

```ml
function isLitSurface(surface)
```

Report whether is lit surface.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `surface` | `dynamic` | — | surface value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/lightmaps.ml#L35)

<a id="function-function-miniquake2-renderer-classic-lightmaps-lightstyleschanged-inline-function-lightstyleschanged-surface-lightstyles-src-miniquake2-renderer-classic-lightmaps-ml-819199943"></a>
### lightStylesChanged

```ml
inline function lightStylesChanged(surface, lightStyles)
```

Report whether any style used by a surface changed since its last upload. The cached white value is the same dirty criterion used by ref_gl.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `surface` | `dynamic` | — | surface value consumed by this operation. |
| `lightStyles` | `dynamic` | — | lightStyles value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/lightmaps.ml#L226)

<a id="function-function-miniquake2-renderer-classic-lightmaps-markdynamiclights-function-markdynamiclights-surface-dlights-src-miniquake2-renderer-classic-lightmaps-ml-1879509127"></a>
### markDynamicLights

```ml
function markDynamicLights(surface, dLights)
```

Mark dynamic lights.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `surface` | `dynamic` | — | surface value consumed by this operation. |
| `dLights` | `dynamic` | — | dLights value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/lightmaps.ml#L61)

<a id="function-function-miniquake2-renderer-classic-lightmaps-markdynamiclightsprefix-function-markdynamiclightsprefix-surface-dlights-dlightcount-src-miniquake2-renderer-classic-lightmaps-ml-1474522386"></a>
### markDynamicLightsPrefix

```ml
function markDynamicLightsPrefix(surface, dLights, dLightCount)
```

Mark a counted dynamic-light prefix. Product brush movers retain capacity storage and therefore must not scan stale slots past the active count.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `surface` | `dynamic` | — | surface value consumed by this operation. |
| `dLights` | `dynamic` | — | dLights value consumed by this operation. |
| `dLightCount` | `dynamic` | — | Number of d light to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/lightmaps.ml#L44)

<a id="function-function-miniquake2-renderer-classic-lightmaps-prepare-function-prepare-surface-lightstyles-dlights-modulate-src-miniquake2-renderer-classic-lightmaps-ml-1481711846"></a>
### prepare

```ml
function prepare(surface, lightStyles, dLights, modulate)
```

Prepare state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `surface` | `dynamic` | — | surface value consumed by this operation. |
| `lightStyles` | `dynamic` | — | lightStyles value consumed by this operation. |
| `dLights` | `dynamic` | — | dLights value consumed by this operation. |
| `modulate` | `dynamic` | — | modulate value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/lightmaps.ml#L244)

<a id="function-function-miniquake2-renderer-classic-lightmaps-setcachestate-function-setcachestate-surface-lightstyles-src-miniquake2-renderer-classic-lightmaps-ml-2117641092"></a>
### setCacheState

```ml
function setCacheState(surface, lightStyles)
```

Set cache state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `surface` | `dynamic` | — | surface value consumed by this operation. |
| `lightStyles` | `dynamic` | — | lightStyles value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/lightmaps.ml#L210)

<a id="function-function-miniquake2-renderer-classic-lightmaps-storergba-function-storergba-blocklights-samplecount-src-miniquake2-renderer-classic-lightmaps-ml-826772338"></a>
### storeRgba

```ml
function storeRgba(blockLights, sampleCount)
```

Return the store rgba value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `blockLights` | `dynamic` | — | blockLights value consumed by this operation. |
| `sampleCount` | `dynamic` | — | Number of sample to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/lightmaps.ml#L122)

<a id="function-function-miniquake2-renderer-classic-lightmaps-stylergb-function-stylergb-lightstyles-styleindex-src-miniquake2-renderer-classic-lightmaps-ml-141909294"></a>
### styleRgb

```ml
function styleRgb(lightStyles, styleIndex)
```

Return the style rgb value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `lightStyles` | `dynamic` | — | lightStyles value consumed by this operation. |
| `styleIndex` | `dynamic` | — | Zero-based index of style. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/lightmaps.ml#L20)

<a id="function-function-miniquake2-renderer-classic-lightmaps-stylewhite-function-stylewhite-lightstyles-styleindex-src-miniquake2-renderer-classic-lightmaps-ml-1585281618"></a>
### styleWhite

```ml
function styleWhite(lightStyles, styleIndex)
```

Return the style white value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `lightStyles` | `dynamic` | — | lightStyles value consumed by this operation. |
| `styleIndex` | `dynamic` | — | Zero-based index of style. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/lightmaps.ml#L28)
