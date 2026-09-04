# `src/miniquake2/client/effects/audio.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 client effects audio facilities for this project.

Package: [`miniquake2.client.effects.audio`](Package-miniquake2-client-effects-audio-179313784.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/client/effects/types.ml` as `cetypes` → [src/miniquake2/client/effects/types.ml](File-src-miniquake2-client-effects-types-ml-621918960.md)

## Declarations

<a id="function-function-miniquake2-client-effects-audio-callbacks-function-callbacks-resolveindex-resolvename-play-src-miniquake2-client-effects-audio-ml-778493042"></a>
### callbacks

```ml
function callbacks(resolveIndex, resolveName, play)
```

Performs the callbacks operation for the miniquake2 client effects audio module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `resolveIndex` | `dynamic` | — | Zero-based index of resolve. |
| `resolveName` | `dynamic` | — | resolveName value consumed by this operation. |
| `play` | `dynamic` | — | play value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/audio.ml#L35)

<a id="function-function-miniquake2-client-effects-audio-emit-function-emit-state-event-src-miniquake2-client-effects-audio-ml-79378508"></a>
### emit

```ml
function emit(state, event)
```

Performs the emit operation for the miniquake2 client effects audio module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `event` | `dynamic` | — | event value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/audio.ml#L50)

<a id="function-function-miniquake2-client-effects-audio-identityindex-function-identityindex-index-src-miniquake2-client-effects-audio-ml-492683675"></a>
### identityIndex

```ml
function identityIndex(index)
```

Return the identity index.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `index` | `dynamic` | — | Zero-based index of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/audio.ml#L14)

<a id="function-function-miniquake2-client-effects-audio-identityname-function-identityname-name-src-miniquake2-client-effects-audio-ml-2040081640"></a>
### identityName

```ml
function identityName(name)
```

Return the identity name.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/audio.ml#L20)

<a id="function-function-miniquake2-client-effects-audio-ignoreplay-function-ignoreplay-event-resolvedsound-src-miniquake2-client-effects-audio-ml-839298324"></a>
### ignorePlay

```ml
function ignorePlay(event, resolvedSound)
```

Ignore play.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `event` | `dynamic` | — | event value consumed by this operation. |
| `resolvedSound` | `dynamic` | — | resolvedSound value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/audio.ml#L27)

<a id="function-function-miniquake2-client-effects-audio-silent-function-silent-src-miniquake2-client-effects-audio-ml-1818153083"></a>
### silent

```ml
function silent()
```

Report whether silent.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/audio.ml#L43)
