# `src/miniquake2/audio/wav.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 audio wav facilities for this project.

Package: [`miniquake2.audio.wav`](Package-miniquake2-audio-wav-1283693855.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/qcommon/byteio.ml` as `awbio` → [src/miniquake2/qcommon/byteio.ml](File-src-miniquake2-qcommon-byteio-ml-159119335.md)

## Declarations

<a id="function-function-miniquake2-audio-wav-chunkname-function-chunkname-data-offset-src-miniquake2-audio-wav-ml-1443790861"></a>
### chunkName

```ml
function chunkName(data, offset)
```

Return the chunk name.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `offset` | `dynamic` | — | Zero-based offset at which processing starts. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/audio/wav.ml#L33)

<a id="function-function-miniquake2-audio-wav-parse-function-parse-data-name-src-miniquake2-audio-wav-ml-279972047"></a>
### parse

```ml
function parse(data, name)
```

Parses parse for the miniquake2 audio wav workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/audio/wav.ml#L42)

- [miniquake2.audio.wav.WavSound](Type-miniquake2-audio-wav-wavsound-1701383618.md) — struct
