# `src/miniquake2/client/effects/mixer_adapter.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 client effects mixer adapter facilities for this project.

Package: [`miniquake2.client.effects.mixer_adapter`](Package-miniquake2-client-effects-mixer-adapter-318156375.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/audio/mixer.ml` as `amixer` → [src/miniquake2/audio/mixer.ml](File-src-miniquake2-audio-mixer-ml-976475642.md)
- `miniquake2/client/effects/audio.ml` as `ceaudio` → [src/miniquake2/client/effects/audio.ml](File-src-miniquake2-client-effects-audio-ml-242663153.md)
- `miniquake2/qcommon/byteio.ml` as `qbio` → [src/miniquake2/qcommon/byteio.ml](File-src-miniquake2-qcommon-byteio-ml-159119335.md)
- `miniquake2/qcommon/constants.ml` as `qconstants` → [src/miniquake2/qcommon/constants.ml](File-src-miniquake2-qcommon-constants-ml-1976195726.md)
- `miniquake2/qcommon/types.ml` as `qtypes` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)

## Declarations

<a id="global-global-miniquake2-client-effects-mixer-adapter-activemixer-activemixer-src-miniquake2-client-effects-mixer-adapter-ml-888815347"></a>
### activeMixer

```ml
activeMixer
```

Stores module-wide active mixer state for the miniquake2 client effects mixer adapter module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/mixer_adapter.ml#L17)

<a id="global-global-miniquake2-client-effects-mixer-adapter-entitypositionresolver-entitypositionresolver-src-miniquake2-client-effects-mixer-adapter-ml-413299339"></a>
### entityPositionResolver

```ml
entityPositionResolver
```

Stores module-wide entity position resolver state for the miniquake2 client effects mixer adapter module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/mixer_adapter.ml#L25)

<a id="global-global-miniquake2-client-effects-mixer-adapter-entitysoundresolver-entitysoundresolver-src-miniquake2-client-effects-mixer-adapter-ml-1138758711"></a>
### entitySoundResolver

```ml
entitySoundResolver
```

Stores module-wide entity sound resolver state for the miniquake2 client effects mixer adapter module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/mixer_adapter.ml#L23)

<a id="global-global-miniquake2-client-effects-mixer-adapter-indexresolver-indexresolver-src-miniquake2-client-effects-mixer-adapter-ml-1926396907"></a>
### indexResolver

```ml
indexResolver
```

Stores module-wide index resolver state for the miniquake2 client effects mixer adapter module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/mixer_adapter.ml#L19)

<a id="function-function-miniquake2-client-effects-mixer-adapter-install-function-install-mixer-resolveindexcallback-resolvenamecallback-resolveentitysoundcallback-entitypositioncallback-origin-right-src-miniquake2-client-effects-mixer-adapter-ml-1803267829"></a>
### install

```ml
function install(mixer, resolveIndexCallback, resolveNameCallback, resolveEntitySoundCallback, entityPositionCallback, origin, right)
```

Install state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mixer` | `dynamic` | — | mixer value consumed by this operation. |
| `resolveIndexCallback` | `dynamic` | — | resolveIndexCallback value consumed by this operation. |
| `resolveNameCallback` | `dynamic` | — | resolveNameCallback value consumed by this operation. |
| `resolveEntitySoundCallback` | `dynamic` | — | resolveEntitySoundCallback value consumed by this operation. |
| `entityPositionCallback` | `dynamic` | — | entityPositionCallback value consumed by this operation. |
| `origin` | `dynamic` | — | origin value consumed by this operation. |
| `right` | `dynamic` | — | right value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/mixer_adapter.ml#L275)

<a id="global-global-miniquake2-client-effects-mixer-adapter-listenerentitynumber-listenerentitynumber-src-miniquake2-client-effects-mixer-adapter-ml-1287068435"></a>
### listenerEntityNumber

```ml
listenerEntityNumber
```

Stores module-wide listener entity number state for the miniquake2 client effects mixer adapter module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/mixer_adapter.ml#L31)

<a id="global-global-miniquake2-client-effects-mixer-adapter-listenerorigin-listenerorigin-src-miniquake2-client-effects-mixer-adapter-ml-495424763"></a>
### listenerOrigin

```ml
listenerOrigin
```

Stores module-wide listener origin state for the miniquake2 client effects mixer adapter module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/mixer_adapter.ml#L27)

<a id="global-global-miniquake2-client-effects-mixer-adapter-listenerright-listenerright-src-miniquake2-client-effects-mixer-adapter-ml-1123796059"></a>
### listenerRight

```ml
listenerRight
```

Stores module-wide listener right state for the miniquake2 client effects mixer adapter module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/mixer_adapter.ml#L29)

<a id="global-global-miniquake2-client-effects-mixer-adapter-loopsoundavailable-loopsoundavailable-src-miniquake2-client-effects-mixer-adapter-ml-1334189171"></a>
### loopSoundAvailable

```ml
loopSoundAvailable
```

Stores module-wide loop sound available state for the miniquake2 client effects mixer adapter module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/mixer_adapter.ml#L47)

<a id="global-global-miniquake2-client-effects-mixer-adapter-loopsoundepoch-loopsoundepoch-src-miniquake2-client-effects-mixer-adapter-ml-383045195"></a>
### loopSoundEpoch

```ml
loopSoundEpoch
```

Stores module-wide loop sound epoch state for the miniquake2 client effects mixer adapter module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/mixer_adapter.ml#L35)

<a id="global-global-miniquake2-client-effects-mixer-adapter-loopsoundindices-loopsoundindices-src-miniquake2-client-effects-mixer-adapter-ml-1004342283"></a>
### loopSoundIndices

```ml
loopSoundIndices
```

Stores module-wide loop sound indices state for the miniquake2 client effects mixer adapter module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/mixer_adapter.ml#L39)

<a id="global-global-miniquake2-client-effects-mixer-adapter-loopsoundleft-loopsoundleft-src-miniquake2-client-effects-mixer-adapter-ml-1254369003"></a>
### loopSoundLeft

```ml
loopSoundLeft
```

Stores module-wide loop sound left state for the miniquake2 client effects mixer adapter module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/mixer_adapter.ml#L41)

<a id="global-global-miniquake2-client-effects-mixer-adapter-loopsoundresolved-loopsoundresolved-src-miniquake2-client-effects-mixer-adapter-ml-420494883"></a>
### loopSoundResolved

```ml
loopSoundResolved
```

Stores module-wide loop sound resolved state for the miniquake2 client effects mixer adapter module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/mixer_adapter.ml#L45)

<a id="global-global-miniquake2-client-effects-mixer-adapter-loopsoundright-loopsoundright-src-miniquake2-client-effects-mixer-adapter-ml-668518233"></a>
### loopSoundRight

```ml
loopSoundRight
```

Stores module-wide loop sound right state for the miniquake2 client effects mixer adapter module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/mixer_adapter.ml#L43)

<a id="global-global-miniquake2-client-effects-mixer-adapter-loopsoundseen-loopsoundseen-src-miniquake2-client-effects-mixer-adapter-ml-719897643"></a>
### loopSoundSeen

```ml
loopSoundSeen
```

Stores module-wide loop sound seen state for the miniquake2 client effects mixer adapter module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/mixer_adapter.ml#L37)

<a id="global-global-miniquake2-client-effects-mixer-adapter-mixerspatialscratch-mixerspatialscratch-src-miniquake2-client-effects-mixer-adapter-ml-1684913891"></a>
### mixerSpatialScratch

```ml
mixerSpatialScratch
```

Stores module-wide mixer spatial scratch state for the miniquake2 client effects mixer adapter module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/mixer_adapter.ml#L33)

<a id="global-global-miniquake2-client-effects-mixer-adapter-nameresolver-nameresolver-src-miniquake2-client-effects-mixer-adapter-ml-435789973"></a>
### nameResolver

```ml
nameResolver
```

Stores module-wide name resolver state for the miniquake2 client effects mixer adapter module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/mixer_adapter.ml#L21)

<a id="function-function-miniquake2-client-effects-mixer-adapter-play-function-play-event-sound-src-miniquake2-client-effects-mixer-adapter-ml-157437234"></a>
### play

```ml
function play(event, sound)
```

Play state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `event` | `dynamic` | — | event value consumed by this operation. |
| `sound` | `dynamic` | — | sound value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/mixer_adapter.ml#L66)

<a id="function-function-miniquake2-client-effects-mixer-adapter-release-function-release-src-miniquake2-client-effects-mixer-adapter-ml-1869099047"></a>
### release

```ml
function release()
```

Release state.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/mixer_adapter.ml#L297)

<a id="function-function-miniquake2-client-effects-mixer-adapter-resolveindex-function-resolveindex-index-src-miniquake2-client-effects-mixer-adapter-ml-2007973487"></a>
### resolveIndex

```ml
function resolveIndex(index)
```

Resolve index.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `index` | `dynamic` | — | Zero-based index of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/mixer_adapter.ml#L51)

<a id="function-function-miniquake2-client-effects-mixer-adapter-resolvename-function-resolvename-name-src-miniquake2-client-effects-mixer-adapter-ml-1778059816"></a>
### resolveName

```ml
function resolveName(name)
```

Resolve name.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/mixer_adapter.ml#L58)

<a id="function-function-miniquake2-client-effects-mixer-adapter-respatializedynamic-function-respatializedynamic-mixer-entitypositioncallback-origin-right-localentitynumber-src-miniquake2-client-effects-mixer-adapter-ml-223458684"></a>
### respatializeDynamic

```ml
function respatializeDynamic(mixer, entityPositionCallback, origin, right, localEntityNumber)
```

Return the respatialize dynamic value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mixer` | `dynamic` | — | mixer value consumed by this operation. |
| `entityPositionCallback` | `dynamic` | — | entityPositionCallback value consumed by this operation. |
| `origin` | `dynamic` | — | origin value consumed by this operation. |
| `right` | `dynamic` | — | right value consumed by this operation. |
| `localEntityNumber` | `dynamic` | — | localEntityNumber value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/mixer_adapter.ml#L113)

<a id="function-function-miniquake2-client-effects-mixer-adapter-setlistenerentity-function-setlistenerentity-number-src-miniquake2-client-effects-mixer-adapter-ml-1522473230"></a>
### setListenerEntity

```ml
function setListenerEntity(number)
```

Set listener entity.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `number` | `dynamic` | — | number value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/mixer_adapter.ml#L177)

<a id="function-function-miniquake2-client-effects-mixer-adapter-syncentityloops-function-syncentityloops-mixer-snapshot-src-miniquake2-client-effects-mixer-adapter-ml-112013164"></a>
### syncEntityLoops

```ml
function syncEntityLoops(mixer, snapshot)
```

Backwards-compatible active-game entry point. Runtime owners that implement cl_paused should call syncEntityLoopsPaused with their pause state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mixer` | `dynamic` | — | mixer value consumed by this operation. |
| `snapshot` | `dynamic` | — | snapshot value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/mixer_adapter.ml#L263)

<a id="function-function-miniquake2-client-effects-mixer-adapter-syncentityloopspaused-function-syncentityloopspaused-mixer-snapshot-paused-src-miniquake2-client-effects-mixer-adapter-ml-1963461838"></a>
### syncEntityLoopsPaused

```ml
function syncEntityLoopsPaused(mixer, snapshot, paused)
```

Reproduce S_AddLoopSounds for EntityState.sound. Identical sound indexes are merged into one autosound channel and their spatial contributions are summed, exactly as the stock client does for doors, plats, ambients and projectile flight loops.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mixer` | `dynamic` | — | mixer value consumed by this operation. |
| `snapshot` | `dynamic` | — | snapshot value consumed by this operation. |
| `paused` | `dynamic` | — | paused value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/mixer_adapter.ml#L194)
