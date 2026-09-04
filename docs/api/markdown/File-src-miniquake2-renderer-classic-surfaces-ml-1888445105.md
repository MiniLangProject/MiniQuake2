# `src/miniquake2/renderer/classic/surfaces.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 renderer classic surfaces facilities for this project.

Package: [`miniquake2.renderer.classic.surfaces`](Package-miniquake2-renderer-classic-surfaces-1543910912.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/format/types.ml` as `ft` → [src/miniquake2/format/types.ml](File-src-miniquake2-format-types-ml-129451131.md)
- `miniquake2/qcommon/byteio.ml` as `qbyteio` → [src/miniquake2/qcommon/byteio.ml](File-src-miniquake2-qcommon-byteio-ml-159119335.md)
- `miniquake2/renderer/classic/constants.ml` as `rclassicconstants` → [src/miniquake2/renderer/classic/constants.ml](File-src-miniquake2-renderer-classic-constants-ml-1818163902.md)
- `miniquake2/renderer/classic/materials.ml` as `rclassicmaterials` → [src/miniquake2/renderer/classic/materials.ml](File-src-miniquake2-renderer-classic-materials-ml-232284255.md)
- `miniquake2/renderer/classic/types.ml` as `rclassictypes` → [src/miniquake2/renderer/classic/types.ml](File-src-miniquake2-renderer-classic-types-ml-1346078158.md)
- `std/math.ml` as `smath` → `../MiniLangCompilerML/std/math.ml` — external dependency

## Declarations

<a id="function-function-miniquake2-renderer-classic-surfaces-buildsurface-function-buildsurface-map-faceindex-images-entityframe-src-miniquake2-renderer-classic-surfaces-ml-1012742292"></a>
### buildSurface

```ml
function buildSurface(map, faceIndex, images, entityFrame)
```

Build surface.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `map` | `dynamic` | — | map value consumed by this operation. |
| `faceIndex` | `dynamic` | — | Zero-based index of face. |
| `images` | `dynamic` | — | images value consumed by this operation. |
| `entityFrame` | `dynamic` | — | entityFrame value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/surfaces.ml#L92)

<a id="function-function-miniquake2-renderer-classic-surfaces-buildsurfaces-function-buildsurfaces-map-images-entityframe-src-miniquake2-renderer-classic-surfaces-ml-2072282147"></a>
### buildSurfaces

```ml
function buildSurfaces(map, images, entityFrame)
```

Build surfaces.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `map` | `dynamic` | — | map value consumed by this operation. |
| `images` | `dynamic` | — | images value consumed by this operation. |
| `entityFrame` | `dynamic` | — | entityFrame value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/surfaces.ml#L142)

<a id="function-function-miniquake2-renderer-classic-surfaces-facevertexposition-function-facevertexposition-map-face-edgeoffset-src-miniquake2-renderer-classic-surfaces-ml-1597792704"></a>
### faceVertexPosition

```ml
function faceVertexPosition(map, face, edgeOffset)
```

Return the face vertex position.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `map` | `dynamic` | — | map value consumed by this operation. |
| `face` | `dynamic` | — | face value consumed by this operation. |
| `edgeOffset` | `dynamic` | — | edgeOffset value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/surfaces.ml#L28)

<a id="function-function-miniquake2-renderer-classic-surfaces-lightmapcount-function-lightmapcount-styles-src-miniquake2-renderer-classic-surfaces-ml-932654835"></a>
### lightMapCount

```ml
function lightMapCount(styles)
```

Map light count.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `styles` | `dynamic` | — | styles value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/surfaces.ml#L79)

<a id="function-function-miniquake2-renderer-classic-surfaces-projected-function-projected-position-vector-src-miniquake2-renderer-classic-surfaces-ml-927164919"></a>
### projected

```ml
function projected(position, vector)
```

Return the projected value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `position` | `dynamic` | — | position value consumed by this operation. |
| `vector` | `dynamic` | — | vector value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/surfaces.ml#L20)

<a id="function-function-miniquake2-renderer-classic-surfaces-surfaceextents-function-surfaceextents-map-face-texinfo-src-miniquake2-renderer-classic-surfaces-ml-719639071"></a>
### surfaceExtents

```ml
function surfaceExtents(map, face, texInfo)
```

Return the surface extents value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `map` | `dynamic` | — | map value consumed by this operation. |
| `face` | `dynamic` | — | face value consumed by this operation. |
| `texInfo` | `dynamic` | — | texInfo value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/surfaces.ml#L46)
