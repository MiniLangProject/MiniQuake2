# `src/miniquake2/renderer/classic/sprites.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 renderer classic sprites facilities for this project.

Package: [`miniquake2.renderer.classic.sprites`](Package-miniquake2-renderer-classic-sprites-1670189254.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/renderer/classic/types.ml` as `rclassictypes` → [src/miniquake2/renderer/classic/types.ml](File-src-miniquake2-renderer-classic-types-ml-1346078158.md)
- `miniquake2/renderer/classic/vector.ml` as `rclassicvector` → [src/miniquake2/renderer/classic/vector.ml](File-src-miniquake2-renderer-classic-vector-ml-1705483236.md)
- `miniquake2/renderer/constants.ml` as `rc` → [src/miniquake2/renderer/constants.ml](File-src-miniquake2-renderer-constants-ml-1893707491.md)

## Declarations

<a id="function-function-miniquake2-renderer-classic-sprites-frameindex-function-frameindex-model-requestedframe-src-miniquake2-renderer-classic-sprites-ml-301792439"></a>
### frameIndex

```ml
function frameIndex(model, requestedFrame)
```

Return the frame index.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `model` | `dynamic` | — | model value consumed by this operation. |
| `requestedFrame` | `dynamic` | — | requestedFrame value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/sprites.ml#L25)

<a id="function-function-miniquake2-renderer-classic-sprites-prepare-function-prepare-model-entity-cameraup-cameraright-src-miniquake2-renderer-classic-sprites-ml-482873234"></a>
### prepare

```ml
function prepare(model, entity, cameraUp, cameraRight)
```

Prepare state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `model` | `dynamic` | — | model value consumed by this operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `cameraUp` | `dynamic` | — | cameraUp value consumed by this operation. |
| `cameraRight` | `dynamic` | — | cameraRight value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/sprites.ml#L37)

<a id="function-function-miniquake2-renderer-classic-sprites-spritevertex-function-spritevertex-position-s-t-src-miniquake2-renderer-classic-sprites-ml-331215019"></a>
### spriteVertex

```ml
function spriteVertex(position, s, t)
```

Return the sprite vertex value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `position` | `dynamic` | — | position value consumed by this operation. |
| `s` | `dynamic` | — | s value consumed by this operation. |
| `t` | `dynamic` | — | t value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/sprites.ml#L18)
