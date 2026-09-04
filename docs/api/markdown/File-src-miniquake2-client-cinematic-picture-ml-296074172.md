# `src/miniquake2/client/cinematic/picture.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 client cinematic picture facilities for this project.

Package: [`miniquake2.client.cinematic.picture`](Package-miniquake2-client-cinematic-picture-116755219.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/format/pcx.ml` as `cinpicturepcx` → [src/miniquake2/format/pcx.ml](File-src-miniquake2-format-pcx-ml-1818682253.md)

## Declarations

<a id="function-function-miniquake2-client-cinematic-picture-draw-function-draw-playback-screenwidth-screenheight-exports-src-miniquake2-client-cinematic-picture-ml-1230055766"></a>
### draw

```ml
function draw(playback, screenWidth, screenHeight, exports)
```

Draws draw through the miniquake2 client cinematic picture rendering path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `playback` | `dynamic` | — | playback value consumed by this operation. |
| `screenWidth` | `dynamic` | — | screenWidth value consumed by this operation. |
| `screenHeight` | `dynamic` | — | screenHeight value consumed by this operation. |
| `exports` | `dynamic` | — | exports value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/cinematic/picture.ml#L38)

- [miniquake2.client.cinematic.picture.PicturePlayback](Type-miniquake2-client-cinematic-picture-pictureplayback-1465252282.md) — struct
<a id="function-function-miniquake2-client-cinematic-picture-start-function-start-data-src-miniquake2-client-cinematic-picture-ml-1643894153"></a>
### start

```ml
function start(data)
```

Starts start for the miniquake2 client cinematic picture workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/cinematic/picture.ml#L24)

<a id="function-function-miniquake2-client-cinematic-picture-stop-function-stop-playback-src-miniquake2-client-cinematic-picture-ml-11130220"></a>
### stop

```ml
function stop(playback)
```

Stops stop for the miniquake2 client cinematic picture workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `playback` | `dynamic` | — | playback value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/cinematic/picture.ml#L60)
