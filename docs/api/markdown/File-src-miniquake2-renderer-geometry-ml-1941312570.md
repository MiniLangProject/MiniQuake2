# `src/miniquake2/renderer/geometry.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 renderer geometry facilities for this project.

Package: [`miniquake2.renderer.geometry`](Package-miniquake2-renderer-geometry-1454274870.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/format/types.ml` as `ft` → [src/miniquake2/format/types.ml](File-src-miniquake2-format-types-ml-129451131.md)
- `miniquake2/qcommon/directions.ml` as `rgeometrydirections` → [src/miniquake2/qcommon/directions.ml](File-src-miniquake2-qcommon-directions-ml-1980852047.md)
- `std/math.ml` as `rgeometrymath` → `../MiniLangCompilerML/std/math.ml` — external dependency

## Declarations

<a id="function-function-miniquake2-renderer-geometry-bspmodelmesh-function-bspmodelmesh-map-modelindex-src-miniquake2-renderer-geometry-ml-1210250977"></a>
### bspModelMesh

```ml
function bspModelMesh(map, modelIndex)
```

Return the bsp model mesh value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `map` | `dynamic` | — | map value consumed by this operation. |
| `modelIndex` | `dynamic` | — | Zero-based index of model. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/geometry.ml#L78)

<a id="function-function-miniquake2-renderer-geometry-facevertex-function-facevertex-map-face-edgeoffset-src-miniquake2-renderer-geometry-ml-947513177"></a>
### faceVertex

```ml
function faceVertex(map, face, edgeOffset)
```

Return the face vertex value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `map` | `dynamic` | — | map value consumed by this operation. |
| `face` | `dynamic` | — | face value consumed by this operation. |
| `edgeOffset` | `dynamic` | — | edgeOffset value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/geometry.ml#L57)

<a id="function-function-miniquake2-renderer-geometry-interpolate-function-interpolate-first-second-backlerp-src-miniquake2-renderer-geometry-ml-461206608"></a>
### interpolate

```ml
function interpolate(first, second, backLerp)
```

Interpolate state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `dynamic` | — | first value consumed by this operation. |
| `second` | `dynamic` | — | second value consumed by this operation. |
| `backLerp` | `dynamic` | — | backLerp value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/geometry.ml#L136)

<a id="function-function-miniquake2-renderer-geometry-md2framebounds-function-md2framebounds-model-frameindex-oldframeindex-backlerp-src-miniquake2-renderer-geometry-ml-421362712"></a>
### md2FrameBounds

```ml
function md2FrameBounds(model, frameIndex, oldFrameIndex, backLerp)
```

Return the md 2 frame bounds.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `model` | `dynamic` | — | model value consumed by this operation. |
| `frameIndex` | `dynamic` | — | Zero-based index of frame. |
| `oldFrameIndex` | `dynamic` | — | Zero-based index of old frame. |
| `backLerp` | `dynamic` | — | backLerp value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/geometry.ml#L150)

<a id="function-function-miniquake2-renderer-geometry-md2framemesh-function-md2framemesh-model-frameindex-oldframeindex-backlerp-src-miniquake2-renderer-geometry-ml-686366936"></a>
### md2FrameMesh

```ml
function md2FrameMesh(model, frameIndex, oldFrameIndex, backLerp)
```

Return the md 2 frame mesh value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `model` | `dynamic` | — | model value consumed by this operation. |
| `frameIndex` | `dynamic` | — | Zero-based index of frame. |
| `oldFrameIndex` | `dynamic` | — | Zero-based index of old frame. |
| `backLerp` | `dynamic` | — | backLerp value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/geometry.ml#L188)

<a id="function-function-miniquake2-renderer-geometry-md2framescalars-function-md2framescalars-model-frameindex-oldframeindex-backlerp-src-miniquake2-renderer-geometry-ml-2043081558"></a>
### md2FrameScalars

```ml
function md2FrameScalars(model, frameIndex, oldFrameIndex, backLerp)
```

Return the md 2 frame scalars value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `model` | `dynamic` | — | model value consumed by this operation. |
| `frameIndex` | `dynamic` | — | Zero-based index of frame. |
| `oldFrameIndex` | `dynamic` | — | Zero-based index of old frame. |
| `backLerp` | `dynamic` | — | backLerp value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/geometry.ml#L295)

<a id="function-function-miniquake2-renderer-geometry-md2framescalarswithnormaloffset-function-md2framescalarswithnormaloffset-model-frameindex-oldframeindex-backlerp-normaloffset-src-miniquake2-renderer-geometry-ml-796876682"></a>
### md2FrameScalarsWithNormalOffset

```ml
function md2FrameScalarsWithNormalOffset(model, frameIndex, oldFrameIndex, backLerp, normalOffset)
```

Render-only MD2 expansion. The inspection API above intentionally retains MeshVertex structs; the live renderer needs only interleaved ST/XYZ scalars. Building those scalars directly avoids a full temporary object graph and a second traversal for every visible alias model on every frame.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `model` | `dynamic` | — | model value consumed by this operation. |
| `frameIndex` | `dynamic` | — | Zero-based index of frame. |
| `oldFrameIndex` | `dynamic` | — | Zero-based index of old frame. |
| `backLerp` | `dynamic` | — | backLerp value consumed by this operation. |
| `normalOffset` | `dynamic` | — | normalOffset value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/geometry.ml#L229)

<a id="function-function-miniquake2-renderer-geometry-md2position-function-md2position-frame-vertexindex-src-miniquake2-renderer-geometry-ml-706388445"></a>
### md2Position

```ml
function md2Position(frame, vertexIndex)
```

Return the md 2 position.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `frame` | `dynamic` | — | frame value consumed by this operation. |
| `vertexIndex` | `dynamic` | — | Zero-based index of vertex. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/geometry.ml#L122)

<a id="function-function-miniquake2-renderer-geometry-md2powershellframescalars-function-md2powershellframescalars-model-frameindex-oldframeindex-backlerp-src-miniquake2-renderer-geometry-ml-911482920"></a>
### md2PowerShellFrameScalars

```ml
function md2PowerShellFrameScalars(model, frameIndex, oldFrameIndex, backLerp)
```

Return the md 2 power shell frame scalars value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `model` | `dynamic` | — | model value consumed by this operation. |
| `frameIndex` | `dynamic` | — | Zero-based index of frame. |
| `oldFrameIndex` | `dynamic` | — | Zero-based index of old frame. |
| `backLerp` | `dynamic` | — | backLerp value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/geometry.ml#L305)

- [miniquake2.renderer.geometry.MeshBounds](Type-miniquake2-renderer-geometry-meshbounds-1022053248.md) — struct
<a id="function-function-miniquake2-renderer-geometry-meshvertex-function-meshvertex-position-s-t-src-miniquake2-renderer-geometry-ml-1853520246"></a>
### meshVertex

```ml
function meshVertex(position, s, t)
```

Return the mesh vertex value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `position` | `dynamic` | — | position value consumed by this operation. |
| `s` | `dynamic` | — | s value consumed by this operation. |
| `t` | `dynamic` | — | t value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/geometry.ml#L48)

- [miniquake2.renderer.geometry.MeshVertex](Type-miniquake2-renderer-geometry-meshvertex-1797727823.md) — struct
- [miniquake2.renderer.geometry.TriangleMesh](Type-miniquake2-renderer-geometry-trianglemesh-1940166257.md) — struct
