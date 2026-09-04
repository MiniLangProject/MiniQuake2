# `src/miniquake2/renderer/capture.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 renderer capture facilities for this project.

Package: [`miniquake2.renderer.capture`](Package-miniquake2-renderer-capture-1430170160.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/native.ml` as `rendercapturenative` → [src/miniquake2/native.ml](File-src-miniquake2-native-ml-139597585.md)
- `std/fs.ml` as `rendercapturefs` → `../MiniLangCompilerML/std/fs.ml` — external dependency

## Declarations

<a id="function-function-miniquake2-renderer-capture-canonicalizeopenglrgba-function-canonicalizeopenglrgba-width-height-pixels-src-miniquake2-renderer-capture-ml-50303886"></a>
### canonicalizeOpenGlRgba

```ml
function canonicalizeOpenGlRgba(width, height, pixels)
```

Convert GL's bottom-left RGBA rows to the one canonical top-left layout.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `width` | `dynamic` | — | Width in the coordinate or storage units used by the caller. |
| `height` | `dynamic` | — | Height in the coordinate or storage units used by the caller. |
| `pixels` | `dynamic` | — | pixels value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/capture.ml#L84)

- [miniquake2.renderer.capture.CaptureImage](Type-miniquake2-renderer-capture-captureimage-1680351941.md) — struct
<a id="function-function-miniquake2-renderer-capture-compare-function-compare-expectedimage-actualimage-channeltolerance-includealpha-src-miniquake2-renderer-capture-ml-642178988"></a>
### compare

```ml
function compare(expectedImage, actualImage, channelTolerance, includeAlpha)
```

Exact counts plus an explicit per-channel tolerance form a driver-robust, machine-consumable metric without hiding large localized errors in one mean.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `expectedImage` | `dynamic` | — | expectedImage value consumed by this operation. |
| `actualImage` | `dynamic` | — | actualImage value consumed by this operation. |
| `channelTolerance` | `dynamic` | — | channelTolerance value consumed by this operation. |
| `includeAlpha` | `dynamic` | — | includeAlpha value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/capture.ml#L178)

<a id="function-function-miniquake2-renderer-capture-encodetga-function-encodetga-captureimage-src-miniquake2-renderer-capture-ml-1218725071"></a>
### encodeTga

```ml
function encodeTga(captureImage)
```

Uncompressed true-colour TGA, top-left origin, 8 alpha bits. This stays compatible with original ref_gl screenshots while preserving alpha exactly.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `captureImage` | `dynamic` | — | captureImage value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/capture.ml#L122)

<a id="function-function-miniquake2-renderer-capture-image-function-image-width-height-rgba-src-miniquake2-renderer-capture-ml-2143365247"></a>
### image

```ml
function image(width, height, rgba)
```

Return the image value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `width` | `dynamic` | — | Width in the coordinate or storage units used by the caller. |
| `height` | `dynamic` | — | Height in the coordinate or storage units used by the caller. |
| `rgba` | `dynamic` | — | rgba value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/capture.ml#L72)

- [miniquake2.renderer.capture.PixelDiff](Type-miniquake2-renderer-capture-pixeldiff-1649703165.md) — struct
<a id="function-function-miniquake2-renderer-capture-readopenglframe-function-readopenglframe-width-height-src-miniquake2-renderer-capture-ml-1664160331"></a>
### readOpenGlFrame

```ml
function readOpenGlFrame(width, height)
```

Read the current back buffer before EndFrame swaps it. Dithering is disabled so repeated captures on one GL implementation do not depend on pixel phase.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `width` | `dynamic` | — | Width in the coordinate or storage units used by the caller. |
| `height` | `dynamic` | — | Height in the coordinate or storage units used by the caller. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/capture.ml#L109)

<a id="constant-constant-miniquake2-renderer-capture-rendercapture-gl-dither-const-rendercapture-gl-dither-3024-src-miniquake2-renderer-capture-ml-1276858638"></a>
### RENDERCAPTURE_GL_DITHER

```ml
const RENDERCAPTURE_GL_DITHER = 3024
```

Defines the rendercapture gl dither constant used by the miniquake2 renderer capture module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/capture.ml#L17)

<a id="constant-constant-miniquake2-renderer-capture-rendercapture-gl-rgba-const-rendercapture-gl-rgba-6408-src-miniquake2-renderer-capture-ml-1360863431"></a>
### RENDERCAPTURE_GL_RGBA

```ml
const RENDERCAPTURE_GL_RGBA = 6408
```

Defines the rendercapture gl rgba constant used by the miniquake2 renderer capture module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/capture.ml#L19)

<a id="constant-constant-miniquake2-renderer-capture-rendercapture-gl-unsigned-byte-const-rendercapture-gl-unsigned-byte-5121-src-miniquake2-renderer-capture-ml-315937844"></a>
### RENDERCAPTURE_GL_UNSIGNED_BYTE

```ml
const RENDERCAPTURE_GL_UNSIGNED_BYTE = 5121
```

Defines the rendercapture gl unsigned byte constant used by the miniquake2 renderer capture module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/capture.ml#L21)

<a id="function-function-miniquake2-renderer-capture-rgbachecksum-function-rgbachecksum-captureimage-src-miniquake2-renderer-capture-ml-472813295"></a>
### rgbaChecksum

```ml
function rgbaChecksum(captureImage)
```

Return the rgba checksum value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `captureImage` | `dynamic` | — | captureImage value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/capture.ml#L158)

<a id="function-function-miniquake2-renderer-capture-validatecapturedimensions-function-validatecapturedimensions-width-height-src-miniquake2-renderer-capture-ml-1831473053"></a>
### validateCaptureDimensions

```ml
function validateCaptureDimensions(width, height)
```

Validate capture dimensions.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `width` | `dynamic` | — | Width in the coordinate or storage units used by the caller. |
| `height` | `dynamic` | — | Height in the coordinate or storage units used by the caller. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/capture.ml#L58)

<a id="function-function-miniquake2-renderer-capture-writetga-function-writetga-path-captureimage-src-miniquake2-renderer-capture-ml-128313040"></a>
### writeTga

```ml
function writeTga(path, captureImage)
```

Write tga.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Path of the file or directory used by the operation. |
| `captureImage` | `dynamic` | — | captureImage value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/capture.ml#L151)
