# `src/miniquake2/client/cinematic/audio.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 client cinematic audio facilities for this project.

Package: [`miniquake2.client.cinematic.audio`](Package-miniquake2-client-cinematic-audio-1550040439.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/audio/mixer.ml` as `amixer` → [src/miniquake2/audio/mixer.ml](File-src-miniquake2-audio-mixer-ml-976475642.md)
- `miniquake2/audio/wav.ml` as `awav` → [src/miniquake2/audio/wav.ml](File-src-miniquake2-audio-wav-ml-415505115.md)
- `miniquake2/client/cinematic/types.ml` as `cintypes` → [src/miniquake2/client/cinematic/types.ml](File-src-miniquake2-client-cinematic-types-ml-2027052669.md)
- `miniquake2/qcommon/byteio.ml` as `qbio` → [src/miniquake2/qcommon/byteio.ml](File-src-miniquake2-qcommon-byteio-ml-159119335.md)

## Declarations

<a id="function-function-miniquake2-client-cinematic-audio-appendbytes-function-appendbytes-first-second-src-miniquake2-client-cinematic-audio-ml-848836331"></a>
### appendBytes

```ml
function appendBytes(first, second)
```

Append bytes.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `dynamic` | — | first value consumed by this operation. |
| `second` | `dynamic` | — | second value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/cinematic/audio.ml#L41)

<a id="function-function-miniquake2-client-cinematic-audio-callbacks-function-callbacks-submit-src-miniquake2-client-cinematic-audio-ml-112467925"></a>
### callbacks

```ml
function callbacks(submit)
```

Performs the callbacks operation for the miniquake2 client cinematic audio module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `submit` | `dynamic` | — | submit value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/cinematic/audio.ml#L28)

<a id="function-function-miniquake2-client-cinematic-audio-createmixeradapter-function-createmixeradapter-mixer-src-miniquake2-client-cinematic-audio-ml-1896288498"></a>
### createMixerAdapter

```ml
function createMixerAdapter(mixer)
```

Create mixer adapter.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mixer` | `dynamic` | — | mixer value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/cinematic/audio.ml#L50)

<a id="function-function-miniquake2-client-cinematic-audio-ignorechunk-function-ignorechunk-chunk-src-miniquake2-client-cinematic-audio-ml-290469880"></a>
### ignoreChunk

```ml
function ignoreChunk(chunk)
```

Ignore chunk.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `chunk` | `dynamic` | — | chunk value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/cinematic/audio.ml#L17)

<a id="function-function-miniquake2-client-cinematic-audio-ignorelifecycle-function-ignorelifecycle-src-miniquake2-client-cinematic-audio-ml-1254964969"></a>
### ignoreLifecycle

```ml
function ignoreLifecycle()
```

Ignore lifecycle.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/cinematic/audio.ml#L22)

<a id="function-function-miniquake2-client-cinematic-audio-mixerhandoff-function-mixerhandoff-mixer-src-miniquake2-client-cinematic-audio-ml-515059518"></a>
### mixerHandoff

```ml
function mixerHandoff(mixer)
```

Return the mixer handoff value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mixer` | `dynamic` | — | mixer value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/cinematic/audio.ml#L100)

<a id="nested_function-nested-function-miniquake2-client-cinematic-audio-mixerhandoff-local-pausestream-function-pausestream-src-miniquake2-client-cinematic-audio-ml-689099507"></a>
### pauseStream

```ml
function pauseStream()
```

Performs the pauseStream operation for the miniquake2 client cinematic audio module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/cinematic/audio.ml#L108)

<a id="nested_function-nested-function-miniquake2-client-cinematic-audio-mixerhandoff-local-resumestream-function-resumestream-src-miniquake2-client-cinematic-audio-ml-1536297027"></a>
### resumeStream

```ml
function resumeStream()
```

Performs the resumeStream operation for the miniquake2 client cinematic audio module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/cinematic/audio.ml#L114)

<a id="nested_function-nested-function-miniquake2-client-cinematic-audio-mixerhandoff-local-stopstream-function-stopstream-src-miniquake2-client-cinematic-audio-ml-807695867"></a>
### stopStream

```ml
function stopStream()
```

Stops stream for the miniquake2 client cinematic audio workflow.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/cinematic/audio.ml#L120)

<a id="nested_function-nested-function-miniquake2-client-cinematic-audio-mixerhandoff-local-submit-function-submit-chunk-src-miniquake2-client-cinematic-audio-ml-1025763292"></a>
### submit

```ml
function submit(chunk)
```

Performs the submit operation for the miniquake2 client cinematic audio module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `chunk` | `dynamic` | — | chunk value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/cinematic/audio.ml#L104)

<a id="function-function-miniquake2-client-cinematic-audio-silent-function-silent-src-miniquake2-client-cinematic-audio-ml-1835555753"></a>
### silent

```ml
function silent()
```

Report whether silent.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/cinematic/audio.ml#L34)

<a id="function-function-miniquake2-client-cinematic-audio-stopmixeradapter-function-stopmixeradapter-adapter-src-miniquake2-client-cinematic-audio-ml-7439860"></a>
### stopMixerAdapter

```ml
function stopMixerAdapter(adapter)
```

Stop mixer adapter.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `adapter` | `dynamic` | — | adapter value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/cinematic/audio.ml#L130)

<a id="function-function-miniquake2-client-cinematic-audio-submittomixer-function-submittomixer-adapter-chunk-src-miniquake2-client-cinematic-audio-ml-849002805"></a>
### submitToMixer

```ml
function submitToMixer(adapter, chunk)
```

Submit to mixer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `adapter` | `dynamic` | — | adapter value consumed by this operation. |
| `chunk` | `dynamic` | — | chunk value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/cinematic/audio.ml#L58)
