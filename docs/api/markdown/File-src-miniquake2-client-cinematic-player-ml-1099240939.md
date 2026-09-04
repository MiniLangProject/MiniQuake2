# `src/miniquake2/client/cinematic/player.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 client cinematic player facilities for this project.

Package: [`miniquake2.client.cinematic.player`](Package-miniquake2-client-cinematic-player-412170698.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/client/cinematic/audio.ml` as `cinaudio` → [src/miniquake2/client/cinematic/audio.ml](File-src-miniquake2-client-cinematic-audio-ml-1884837356.md)
- `miniquake2/client/cinematic/types.ml` as `cintypes` → [src/miniquake2/client/cinematic/types.ml](File-src-miniquake2-client-cinematic-types-ml-2027052669.md)
- `miniquake2/format/cinematic.ml` as `cinformat` → [src/miniquake2/format/cinematic.ml](File-src-miniquake2-format-cinematic-ml-1332230191.md)

## Declarations

<a id="function-function-miniquake2-client-cinematic-player-audiochunk-function-audiochunk-header-data-src-miniquake2-client-cinematic-player-ml-538218804"></a>
### audioChunk

```ml
function audioChunk(header, data)
```

Return the audio chunk value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `header` | `dynamic` | — | header value consumed by this operation. |
| `data` | `dynamic` | — | Input data consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/cinematic/player.ml#L17)

<a id="function-function-miniquake2-client-cinematic-player-draw-function-draw-playback-screenwidth-screenheight-exports-src-miniquake2-client-cinematic-player-ml-1475961998"></a>
### draw

```ml
function draw(playback, screenWidth, screenHeight, exports)
```

Draws draw through the miniquake2 client cinematic player rendering path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `playback` | `dynamic` | — | playback value consumed by this operation. |
| `screenWidth` | `dynamic` | — | screenWidth value consumed by this operation. |
| `screenHeight` | `dynamic` | — | screenHeight value consumed by this operation. |
| `exports` | `dynamic` | — | exports value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/cinematic/player.ml#L160)

<a id="function-function-miniquake2-client-cinematic-player-emitaudio-function-emitaudio-playback-data-src-miniquake2-client-cinematic-player-ml-1628520258"></a>
### emitAudio

```ml
function emitAudio(playback, data)
```

Emit audio.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `playback` | `dynamic` | — | playback value consumed by this operation. |
| `data` | `dynamic` | — | Input data consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/cinematic/player.ml#L27)

<a id="function-function-miniquake2-client-cinematic-player-isfinished-function-isfinished-playback-src-miniquake2-client-cinematic-player-ml-1058611480"></a>
### isFinished

```ml
function isFinished(playback)
```

Report whether is finished.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `playback` | `dynamic` | — | playback value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/cinematic/player.ml#L179)

<a id="function-function-miniquake2-client-cinematic-player-pause-function-pause-playback-now-src-miniquake2-client-cinematic-player-ml-1855528866"></a>
### pause

```ml
function pause(playback, now)
```

Pause state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `playback` | `dynamic` | — | playback value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/cinematic/player.ml#L79)

<a id="function-function-miniquake2-client-cinematic-player-readnext-function-readnext-playback-framenumber-src-miniquake2-client-cinematic-player-ml-1306238882"></a>
### readNext

```ml
function readNext(playback, frameNumber)
```

Read next.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `playback` | `dynamic` | — | playback value consumed by this operation. |
| `frameNumber` | `dynamic` | — | frameNumber value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/cinematic/player.ml#L37)

<a id="function-function-miniquake2-client-cinematic-player-restartloop-function-restartloop-playback-now-src-miniquake2-client-cinematic-player-ml-439488336"></a>
### restartLoop

```ml
function restartLoop(playback, now)
```

Restart loop.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `playback` | `dynamic` | — | playback value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/cinematic/player.ml#L114)

<a id="function-function-miniquake2-client-cinematic-player-resume-function-resume-playback-now-src-miniquake2-client-cinematic-player-ml-74195438"></a>
### resume

```ml
function resume(playback, now)
```

Resume state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `playback` | `dynamic` | — | playback value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/cinematic/player.ml#L91)

<a id="function-function-miniquake2-client-cinematic-player-start-function-start-data-now-looping-audiocallbacks-src-miniquake2-client-cinematic-player-ml-1977078135"></a>
### start

```ml
function start(data, now, looping, audioCallbacks)
```

Starts start for the miniquake2 client cinematic player workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |
| `looping` | `dynamic` | — | looping value consumed by this operation. |
| `audioCallbacks` | `dynamic` | — | audioCallbacks value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/cinematic/player.ml#L61)

<a id="function-function-miniquake2-client-cinematic-player-stop-function-stop-playback-src-miniquake2-client-cinematic-player-ml-144803204"></a>
### stop

```ml
function stop(playback)
```

Stops stop for the miniquake2 client cinematic player workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `playback` | `dynamic` | — | playback value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/cinematic/player.ml#L104)

<a id="function-function-miniquake2-client-cinematic-player-update-function-update-playback-now-src-miniquake2-client-cinematic-player-ml-227789734"></a>
### update

```ml
function update(playback, now)
```

Update state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `playback` | `dynamic` | — | playback value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/cinematic/player.ml#L128)
