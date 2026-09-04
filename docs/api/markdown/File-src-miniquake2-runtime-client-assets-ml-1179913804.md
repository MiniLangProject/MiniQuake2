# `src/miniquake2/runtime/client_assets.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 runtime client assets facilities for this project.

Package: [`miniquake2.runtime.client_assets`](Package-miniquake2-runtime-client-assets-840949570.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/client/assets/registry.ml` as `caregistry` → [src/miniquake2/client/assets/registry.ml](File-src-miniquake2-client-assets-registry-ml-757705703.md)
- `miniquake2/client/effects/mixer_adapter.ml` as `cameffects` → [src/miniquake2/client/effects/mixer_adapter.ml](File-src-miniquake2-client-effects-mixer-adapter-ml-1059587480.md)

## Declarations

<a id="function-function-miniquake2-runtime-client-assets-attachmixer-function-attachmixer-state-effectstate-mixer-entitypositionresolver-listenerorigin-listenerright-src-miniquake2-runtime-client-assets-ml-5840372"></a>
### attachMixer

```ml
function attachMixer(state, effectState, mixer, entityPositionResolver, listenerOrigin, listenerRight)
```

Attach mixer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `effectState` | `dynamic` | — | effectState value consumed by this operation. |
| `mixer` | `dynamic` | — | mixer value consumed by this operation. |
| `entityPositionResolver` | `dynamic` | — | entityPositionResolver value consumed by this operation. |
| `listenerOrigin` | `dynamic` | — | listenerOrigin value consumed by this operation. |
| `listenerRight` | `dynamic` | — | listenerRight value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_assets.ml#L92)

<a id="function-function-miniquake2-runtime-client-assets-bindings-function-bindings-state-src-miniquake2-runtime-client-assets-ml-1513674515"></a>
### bindings

```ml
function bindings(state)
```

Return the bindings value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_assets.ml#L75)

<a id="function-function-miniquake2-runtime-client-assets-create-function-create-modelloader-skinloader-soundloader-missingcallback-src-miniquake2-runtime-client-assets-ml-1868440857"></a>
### create

```ml
function create(modelLoader, skinLoader, soundLoader, missingCallback)
```

Creates create for the miniquake2 runtime client assets module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `modelLoader` | `dynamic` | — | modelLoader value consumed by this operation. |
| `skinLoader` | `dynamic` | — | skinLoader value consumed by this operation. |
| `soundLoader` | `dynamic` | — | soundLoader value consumed by this operation. |
| `missingCallback` | `dynamic` | — | missingCallback value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_assets.ml#L18)

<a id="function-function-miniquake2-runtime-client-assets-createforrenderer-function-createforrenderer-rendererexports-soundloader-missingcallback-src-miniquake2-runtime-client-assets-ml-424973315"></a>
### createForRenderer

```ml
function createForRenderer(rendererExports, soundLoader, missingCallback)
```

Create for renderer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `rendererExports` | `dynamic` | — | rendererExports value consumed by this operation. |
| `soundLoader` | `dynamic` | — | soundLoader value consumed by this operation. |
| `missingCallback` | `dynamic` | — | missingCallback value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_assets.ml#L35)

<a id="function-function-miniquake2-runtime-client-assets-createlenient-function-createlenient-modelloader-skinloader-soundloader-src-miniquake2-runtime-client-assets-ml-785411046"></a>
### createLenient

```ml
function createLenient(modelLoader, skinLoader, soundLoader)
```

Create lenient.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `modelLoader` | `dynamic` | — | modelLoader value consumed by this operation. |
| `skinLoader` | `dynamic` | — | skinLoader value consumed by this operation. |
| `soundLoader` | `dynamic` | — | soundLoader value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_assets.ml#L27)

<a id="function-function-miniquake2-runtime-client-assets-missingassets-function-missingassets-state-src-miniquake2-runtime-client-assets-ml-542168365"></a>
### missingAssets

```ml
function missingAssets(state)
```

Report whether missing assets.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_assets.ml#L123)

<a id="function-function-miniquake2-runtime-client-assets-refreshclientinfos-function-refreshclientinfos-state-configstrings-src-miniquake2-runtime-client-assets-ml-815110525"></a>
### refreshClientInfos

```ml
function refreshClientInfos(state, configStrings)
```

Refresh client infos.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `configStrings` | `dynamic` | — | configStrings value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_assets.ml#L62)

<a id="function-function-miniquake2-runtime-client-assets-refreshconfigstrings-function-refreshconfigstrings-state-configstrings-src-miniquake2-runtime-client-assets-ml-1352711989"></a>
### refreshConfigStrings

```ml
function refreshConfigStrings(state, configStrings)
```

Refresh config strings.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `configStrings` | `dynamic` | — | configStrings value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_assets.ml#L69)

<a id="function-function-miniquake2-runtime-client-assets-registerconfigstrings-function-registerconfigstrings-state-configstrings-mapname-src-miniquake2-runtime-client-assets-ml-732295666"></a>
### registerConfigStrings

```ml
function registerConfigStrings(state, configStrings, mapName)
```

Register config strings.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `configStrings` | `dynamic` | — | configStrings value consumed by this operation. |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_assets.ml#L48)

<a id="function-function-miniquake2-runtime-client-assets-releasebindings-function-releasebindings-src-miniquake2-runtime-client-assets-ml-847302562"></a>
### releaseBindings

```ml
function releaseBindings()
```

Release bindings.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_assets.ml#L80)

<a id="function-function-miniquake2-runtime-client-assets-reset-function-reset-state-mapname-src-miniquake2-runtime-client-assets-ml-546874572"></a>
### reset

```ml
function reset(state, mapName)
```

Performs the reset operation for the miniquake2 runtime client assets module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_assets.ml#L55)

<a id="function-function-miniquake2-runtime-client-assets-setmixerlistenerentity-function-setmixerlistenerentity-number-src-miniquake2-runtime-client-assets-ml-1735537363"></a>
### setMixerListenerEntity

```ml
function setMixerListenerEntity(number)
```

Set mixer listener entity.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `number` | `dynamic` | — | number value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_assets.ml#L117)

<a id="function-function-miniquake2-runtime-client-assets-syncentityloops-function-syncentityloops-mixer-snapshot-src-miniquake2-runtime-client-assets-ml-353052053"></a>
### syncEntityLoops

```ml
function syncEntityLoops(mixer, snapshot)
```

Synchronize entity loops.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mixer` | `dynamic` | — | mixer value consumed by this operation. |
| `snapshot` | `dynamic` | — | snapshot value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_assets.ml#L103)

<a id="function-function-miniquake2-runtime-client-assets-syncentityloopspaused-function-syncentityloopspaused-mixer-snapshot-paused-src-miniquake2-runtime-client-assets-ml-1818768383"></a>
### syncEntityLoopsPaused

```ml
function syncEntityLoopsPaused(mixer, snapshot, paused)
```

Synchronize or suppress EntityState autosounds for the current pause state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mixer` | `dynamic` | — | mixer value consumed by this operation. |
| `snapshot` | `dynamic` | — | snapshot value consumed by this operation. |
| `paused` | `dynamic` | — | paused value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_assets.ml#L111)
