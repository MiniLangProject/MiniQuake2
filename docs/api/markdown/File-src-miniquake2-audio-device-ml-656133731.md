# `src/miniquake2/audio/device.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 audio device facilities for this project.

Package: [`miniquake2.audio.device`](Package-miniquake2-audio-device-986626173.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/native.ml` as `native` → [src/miniquake2/native.ml](File-src-miniquake2-native-ml-139597585.md)

## Declarations

<a id="function-function-miniquake2-audio-device-capacity-function-capacity-device-src-miniquake2-audio-device-ml-500182254"></a>
### capacity

```ml
function capacity(device)
```

Return the capacity value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `device` | `dynamic` | — | device value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/audio/device.ml#L75)

<a id="function-function-miniquake2-audio-device-close-function-close-device-src-miniquake2-audio-device-ml-1499439466"></a>
### close

```ml
function close(device)
```

Close state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `device` | `dynamic` | — | device value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/audio/device.ml#L89)

<a id="function-function-miniquake2-audio-device-completed-function-completed-device-src-miniquake2-audio-device-ml-1395847104"></a>
### completed

```ml
function completed(device)
```

Report whether completed.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `device` | `dynamic` | — | device value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/audio/device.ml#L61)

- [miniquake2.audio.device.Device](Type-miniquake2-audio-device-device-1907038759.md) — struct
<a id="function-function-miniquake2-audio-device-open-function-open-samplerate-channels-bitspersample-src-miniquake2-audio-device-ml-1035269299"></a>
### open

```ml
function open(sampleRate, channels, bitsPerSample)
```

Opens open for the miniquake2 audio device module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sampleRate` | `dynamic` | — | sampleRate value consumed by this operation. |
| `channels` | `dynamic` | — | channels value consumed by this operation. |
| `bitsPerSample` | `dynamic` | — | bitsPerSample value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/audio/device.ml#L28)

<a id="function-function-miniquake2-audio-device-queued-function-queued-device-src-miniquake2-audio-device-ml-445382822"></a>
### queued

```ml
function queued(device)
```

Report whether queued.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `device` | `dynamic` | — | device value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/audio/device.ml#L47)

<a id="function-function-miniquake2-audio-device-reset-function-reset-device-src-miniquake2-audio-device-ml-1065793024"></a>
### reset

```ml
function reset(device)
```

Performs the reset operation for the miniquake2 audio device module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `device` | `dynamic` | — | device value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/audio/device.ml#L82)

<a id="function-function-miniquake2-audio-device-submit-function-submit-device-samples-src-miniquake2-audio-device-ml-2092209851"></a>
### submit

```ml
function submit(device, samples)
```

Submit state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `device` | `dynamic` | — | device value consumed by this operation. |
| `samples` | `dynamic` | — | samples value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/audio/device.ml#L39)

<a id="function-function-miniquake2-audio-device-submitted-function-submitted-device-src-miniquake2-audio-device-ml-627584012"></a>
### submitted

```ml
function submitted(device)
```

Report whether submitted.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `device` | `dynamic` | — | device value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/audio/device.ml#L54)

<a id="function-function-miniquake2-audio-device-underruns-function-underruns-device-src-miniquake2-audio-device-ml-1817755010"></a>
### underruns

```ml
function underruns(device)
```

Return the underruns value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `device` | `dynamic` | — | device value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/audio/device.ml#L68)
