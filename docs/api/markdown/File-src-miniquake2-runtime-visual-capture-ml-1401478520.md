# `src/miniquake2/runtime/visual_capture.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 runtime visual capture facilities for this project.

Package: [`miniquake2.runtime.visual_capture`](Package-miniquake2-runtime-visual-capture-1484195232.md)

Reachable from entry: **no**

## Imports

- `miniquake2/format/bsp.ml` as `retailcapturebsp` → [src/miniquake2/format/bsp.ml](File-src-miniquake2-format-bsp-ml-2080213539.md)
- `miniquake2/game/base/entity_parser.ml` as `retailcaptureentities` → [src/miniquake2/game/base/entity_parser.ml](File-src-miniquake2-game-base-entity-parser-ml-1253234792.md)
- `miniquake2/physics/vector.ml` as `retailcapturevector` → [src/miniquake2/physics/vector.ml](File-src-miniquake2-physics-vector-ml-1287862571.md)
- `miniquake2/platform/window.ml` as `retailcapturewindow` → [src/miniquake2/platform/window.ml](File-src-miniquake2-platform-window-ml-103958158.md)
- `miniquake2/qcommon/filesystem.ml` as `retailcapturefs` → [src/miniquake2/qcommon/filesystem.ml](File-src-miniquake2-qcommon-filesystem-ml-828451784.md)
- `miniquake2/qcommon/text.ml` as `retailcapturetext` → [src/miniquake2/qcommon/text.ml](File-src-miniquake2-qcommon-text-ml-1570504148.md)
- `miniquake2/qcommon/types.ml` as `retailcaptureqtypes` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)
- `miniquake2/renderer/assets.ml` as `retailcaptureassets` → [src/miniquake2/renderer/assets.ml](File-src-miniquake2-renderer-assets-ml-650889185.md)
- `miniquake2/renderer/capture.ml` as `retailcaptureimage` → [src/miniquake2/renderer/capture.ml](File-src-miniquake2-renderer-capture-ml-993518394.md)
- `miniquake2/renderer/constants.ml` as `retailcapturerc` → [src/miniquake2/renderer/constants.ml](File-src-miniquake2-renderer-constants-ml-1893707491.md)
- `miniquake2/renderer/opengl.ml` as `retailcapturegl` → [src/miniquake2/renderer/opengl.ml](File-src-miniquake2-renderer-opengl-ml-1095768987.md)
- `miniquake2/renderer/types.ml` as `retailcapturert` → [src/miniquake2/renderer/types.ml](File-src-miniquake2-renderer-types-ml-975707623.md)
- `std/array.ml` as `retailcapturearray` → `../MiniLangCompilerML/std/array.ml` — external dependency

## Declarations

<a id="function-function-miniquake2-runtime-visual-capture-captureretailscene-function-captureretailscene-basedirectory-mapname-outputpath-width-height-renderedframes-modelname-includeinlinebrushmodels-cameraorigin-cameraangles-shadowsenabled-src-miniquake2-runtime-visual-capture-ml-644080578"></a>
### captureRetailScene

```ml
function captureRetailScene(baseDirectory, mapName, outputPath, width, height, renderedFrames, modelName, includeInlineBrushModels, cameraOrigin, cameraAngles, shadowsEnabled)
```

cameraOrigin/cameraAngles may be void to select the first info_player_start. Capture occurs before EndFrame's swap, after the final deterministic time.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `outputPath` | `dynamic` | — | Path associated with output. |
| `width` | `dynamic` | — | Width in the coordinate or storage units used by the caller. |
| `height` | `dynamic` | — | Height in the coordinate or storage units used by the caller. |
| `renderedFrames` | `dynamic` | — | renderedFrames value consumed by this operation. |
| `modelName` | `dynamic` | — | modelName value consumed by this operation. |
| `includeInlineBrushModels` | `dynamic` | — | includeInlineBrushModels value consumed by this operation. |
| `cameraOrigin` | `dynamic` | — | cameraOrigin value consumed by this operation. |
| `cameraAngles` | `dynamic` | — | cameraAngles value consumed by this operation. |
| `shadowsEnabled` | `dynamic` | — | shadowsEnabled value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/visual_capture.ml#L219)

<a id="function-function-miniquake2-runtime-visual-capture-retailcapturedefaultcamera-function-retailcapturedefaultcamera-materialized-src-miniquake2-runtime-visual-capture-ml-1582050041"></a>
### retailCaptureDefaultCamera

```ml
function retailCaptureDefaultCamera(materialized)
```

Capture retail default camera.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `materialized` | `dynamic` | — | materialized value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/visual_capture.ml#L132)

<a id="function-function-miniquake2-runtime-visual-capture-retailcaptureendswith-function-retailcaptureendswith-value-suffix-src-miniquake2-runtime-visual-capture-ml-1624738288"></a>
### retailCaptureEndsWith

```ml
function retailCaptureEndsWith(value, suffix)
```

Capture retail ends with.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `suffix` | `dynamic` | — | suffix value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/visual_capture.ml#L99)

- [miniquake2.runtime.visual_capture.RetailCaptureFileImports](Type-miniquake2-runtime-visual-capture-retailcapturefileimports-1513081415.md) — struct
<a id="global-global-miniquake2-runtime-visual-capture-retailcapturefilesystemslot-retailcapturefilesystemslot-src-miniquake2-runtime-visual-capture-ml-348053662"></a>
### retailCaptureFileSystemSlot

```ml
retailCaptureFileSystemSlot
```

Stores module-wide retail capture file system slot state for the miniquake2 runtime visual capture module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/visual_capture.ml#L85)

- [miniquake2.runtime.visual_capture.RetailCaptureFileSystemSlot](Type-miniquake2-runtime-visual-capture-retailcapturefilesystemslot-989199898.md) — struct
<a id="function-function-miniquake2-runtime-visual-capture-retailcaptureinlineentities-function-retailcaptureinlineentities-renderer-materialized-fileimports-output-count-src-miniquake2-runtime-visual-capture-ml-790721384"></a>
### retailCaptureInlineEntities

```ml
function retailCaptureInlineEntities(renderer, materialized, fileImports, output, count)
```

Capture retail inline entities.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `renderer` | `dynamic` | — | renderer value consumed by this operation. |
| `materialized` | `dynamic` | — | materialized value consumed by this operation. |
| `fileImports` | `dynamic` | — | fileImports value consumed by this operation. |
| `output` | `dynamic` | — | Output collection or buffer populated by the operation. |
| `count` | `dynamic` | — | Number of items or units to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/visual_capture.ml#L156)

<a id="function-function-miniquake2-runtime-visual-capture-retailcaptureisinlinemodel-function-retailcaptureisinlinemodel-name-src-miniquake2-runtime-visual-capture-ml-1467183113"></a>
### retailCaptureIsInlineModel

```ml
function retailCaptureIsInlineModel(name)
```

Report whether retail capture is inline model.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/visual_capture.ml#L124)

<a id="function-function-miniquake2-runtime-visual-capture-retailcaptureloadfile-function-retailcaptureloadfile-path-src-miniquake2-runtime-visual-capture-ml-492840035"></a>
### retailCaptureLoadFile

```ml
function retailCaptureLoadFile(path)
```

Capture retail load file.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Path of the file or directory used by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/visual_capture.ml#L89)

<a id="function-function-miniquake2-runtime-visual-capture-retailcapturemappath-function-retailcapturemappath-name-src-miniquake2-runtime-visual-capture-ml-2103494609"></a>
### retailCaptureMapPath

```ml
function retailCaptureMapPath(name)
```

Capture retail map path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/visual_capture.ml#L113)

<a id="function-function-miniquake2-runtime-visual-capture-retailcapturemd2entity-function-retailcapturemd2entity-renderer-modelname-vieworigin-viewangles-src-miniquake2-runtime-visual-capture-ml-406924863"></a>
### retailCaptureMd2Entity

```ml
function retailCaptureMd2Entity(renderer, modelName, viewOrigin, viewAngles)
```

Capture retail md 2 entity.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `renderer` | `dynamic` | — | renderer value consumed by this operation. |
| `modelName` | `dynamic` | — | modelName value consumed by this operation. |
| `viewOrigin` | `dynamic` | — | viewOrigin value consumed by this operation. |
| `viewAngles` | `dynamic` | — | viewAngles value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/visual_capture.ml#L184)

- [miniquake2.runtime.visual_capture.RetailCaptureResult](Type-miniquake2-runtime-visual-capture-retailcaptureresult-932092408.md) — struct
