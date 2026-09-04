# `src/miniquake2/runtime/preview_camera.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 runtime preview camera facilities for this project.

Package: [`miniquake2.runtime.preview_camera`](Package-miniquake2-runtime-preview-camera-311984471.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/physics/vector.ml` as `pcvector` → [src/miniquake2/physics/vector.ml](File-src-miniquake2-physics-vector-ml-1287862571.md)
- `miniquake2/qcommon/types.ml` as `pctypes` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)

## Declarations

<a id="function-function-miniquake2-runtime-preview-camera-applyusercmd-function-applyusercmd-camera-command-viewangles-framemsec-src-miniquake2-runtime-preview-camera-ml-1111963238"></a>
### applyUserCmd

```ml
function applyUserCmd(camera, command, viewAngles, frameMsec)
```

Apply user cmd.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `camera` | `dynamic` | — | camera value consumed by this operation. |
| `command` | `dynamic` | — | command value consumed by this operation. |
| `viewAngles` | `dynamic` | — | viewAngles value consumed by this operation. |
| `frameMsec` | `dynamic` | — | frameMsec value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/preview_camera.ml#L36)

<a id="function-function-miniquake2-runtime-preview-camera-create-function-create-origin-angles-src-miniquake2-runtime-preview-camera-ml-688813822"></a>
### create

```ml
function create(origin, angles)
```

Creates create for the miniquake2 runtime preview camera module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `origin` | `dynamic` | — | origin value consumed by this operation. |
| `angles` | `dynamic` | — | angles value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/preview_camera.ml#L24)

- [miniquake2.runtime.preview_camera.PreviewCamera](Type-miniquake2-runtime-preview-camera-previewcamera-2121129382.md) — struct
