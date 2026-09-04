# `src/miniquake2/client/state.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 client state facilities for this project.

Package: [`miniquake2.client.state`](Package-miniquake2-client-state-1743789479.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/client/effects/constants.ml` as `cseconstants` → [src/miniquake2/client/effects/constants.ml](File-src-miniquake2-client-effects-constants-ml-55259948.md)
- `miniquake2/native.ml` as `cstatenative` → [src/miniquake2/native.ml](File-src-miniquake2-native-ml-139597585.md)
- `miniquake2/protocol/types.ml` as `pt` → [src/miniquake2/protocol/types.ml](File-src-miniquake2-protocol-types-ml-736261438.md)
- `miniquake2/qcommon/constants.ml` as `qc` → [src/miniquake2/qcommon/constants.ml](File-src-miniquake2-qcommon-constants-ml-1976195726.md)
- `miniquake2/qcommon/text.ml` as `cstatetext` → [src/miniquake2/qcommon/text.ml](File-src-miniquake2-qcommon-text-ml-1570504148.md)
- `miniquake2/qcommon/types.ml` as `cqt` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)
- `miniquake2/renderer/constants.ml` as `crc` → [src/miniquake2/renderer/constants.ml](File-src-miniquake2-renderer-constants-ml-1893707491.md)
- `miniquake2/renderer/types.ml` as `crt` → [src/miniquake2/renderer/types.ml](File-src-miniquake2-renderer-types-ml-975707623.md)
- `std/math.ml` as `cstatemath` → `../MiniLangCompilerML/std/math.ml` — external dependency

## Declarations

<a id="function-function-miniquake2-client-state-acceptprediction-function-acceptprediction-client-fixedorigin-angles-src-miniquake2-client-state-ml-76252929"></a>
### acceptPrediction

```ml
function acceptPrediction(client, fixedOrigin, angles)
```

Accept prediction.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `client` | `dynamic` | — | client value consumed by this operation. |
| `fixedOrigin` | `dynamic` | — | fixedOrigin value consumed by this operation. |
| `angles` | `dynamic` | — | angles value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/state.ml#L705)

<a id="function-function-miniquake2-client-state-acceptsnapshot-function-acceptsnapshot-client-frame-src-miniquake2-client-state-ml-109096104"></a>
### acceptSnapshot

```ml
function acceptSnapshot(client, frame)
```

Accept snapshot.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `client` | `dynamic` | — | client value consumed by this operation. |
| `frame` | `dynamic` | — | frame value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/state.ml#L132)

<a id="function-function-miniquake2-client-state-animatedframe-inline-function-animatedframe-state-effects-rendertime-src-miniquake2-client-state-ml-752167385"></a>
### animatedFrame

```ml
inline function animatedFrame(state, effects, renderTime)
```

Return the animated frame value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `effects` | `dynamic` | — | effects value consumed by this operation. |
| `renderTime` | `dynamic` | — | renderTime value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/state.ml#L368)

<a id="function-function-miniquake2-client-state-appendcolorshell-function-appendcolorshell-output-outputindex-state-oldstate-fraction-rendertime-assetresolvers-lerpreset-src-miniquake2-client-state-ml-146042661"></a>
### appendColorShell

```ml
function appendColorShell(output, outputIndex, state, oldState, fraction, renderTime, assetResolvers, lerpReset)
```

Append color shell.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `output` | `dynamic` | — | Output collection or buffer populated by the operation. |
| `outputIndex` | `dynamic` | — | Zero-based index of output. |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `oldState` | `dynamic` | — | oldState value consumed by this operation. |
| `fraction` | `dynamic` | — | fraction value consumed by this operation. |
| `renderTime` | `dynamic` | — | renderTime value consumed by this operation. |
| `assetResolvers` | `dynamic` | — | assetResolvers value consumed by this operation. |
| `lerpReset` | `dynamic` | — | lerpReset value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/state.ml#L503)

<a id="function-function-miniquake2-client-state-appendmodelentity-function-appendmodelentity-output-outputindex-state-oldstate-modelindex-part-fraction-rendertime-assetresolvers-randomresolver-lerpreset-src-miniquake2-client-state-ml-516621100"></a>
### appendModelEntity

```ml
function appendModelEntity(output, outputIndex, state, oldState, modelIndex, part, fraction, renderTime, assetResolvers, randomResolver, lerpReset)
```

Append model entity.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `output` | `dynamic` | — | Output collection or buffer populated by the operation. |
| `outputIndex` | `dynamic` | — | Zero-based index of output. |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `oldState` | `dynamic` | — | oldState value consumed by this operation. |
| `modelIndex` | `dynamic` | — | Zero-based index of model. |
| `part` | `dynamic` | — | part value consumed by this operation. |
| `fraction` | `dynamic` | — | fraction value consumed by this operation. |
| `renderTime` | `dynamic` | — | renderTime value consumed by this operation. |
| `assetResolvers` | `dynamic` | — | assetResolvers value consumed by this operation. |
| `randomResolver` | `dynamic` | — | randomResolver value consumed by this operation. |
| `lerpReset` | `dynamic` | — | lerpReset value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/state.ml#L424)

<a id="function-function-miniquake2-client-state-appendpowerscreen-function-appendpowerscreen-output-outputindex-state-oldstate-fraction-rendertime-assetresolvers-lerpreset-src-miniquake2-client-state-ml-1211988347"></a>
### appendPowerScreen

```ml
function appendPowerScreen(output, outputIndex, state, oldState, fraction, renderTime, assetResolvers, lerpReset)
```

Append power screen.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `output` | `dynamic` | — | Output collection or buffer populated by the operation. |
| `outputIndex` | `dynamic` | — | Zero-based index of output. |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `oldState` | `dynamic` | — | oldState value consumed by this operation. |
| `fraction` | `dynamic` | — | fraction value consumed by this operation. |
| `renderTime` | `dynamic` | — | renderTime value consumed by this operation. |
| `assetResolvers` | `dynamic` | — | assetResolvers value consumed by this operation. |
| `lerpReset` | `dynamic` | — | lerpReset value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/state.ml#L549)

<a id="function-function-miniquake2-client-state-appendviewweapon-function-appendviewweapon-output-outputindex-client-fraction-assetresolvers-vieworigin-viewangles-src-miniquake2-client-state-ml-173929956"></a>
### appendViewWeapon

```ml
function appendViewWeapon(output, outputIndex, client, fraction, assetResolvers, viewOrigin, viewAngles)
```

Append view weapon.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `output` | `dynamic` | — | Output collection or buffer populated by the operation. |
| `outputIndex` | `dynamic` | — | Zero-based index of output. |
| `client` | `dynamic` | — | client value consumed by this operation. |
| `fraction` | `dynamic` | — | fraction value consumed by this operation. |
| `assetResolvers` | `dynamic` | — | assetResolvers value consumed by this operation. |
| `viewOrigin` | `dynamic` | — | viewOrigin value consumed by this operation. |
| `viewAngles` | `dynamic` | — | viewAngles value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/state.ml#L575)

<a id="function-function-miniquake2-client-state-buildentities-function-buildentities-client-fraction-assetresolvers-localentitynumber-randomresolver-vieworigin-viewangles-src-miniquake2-client-state-ml-682847866"></a>
### buildEntities

```ml
function buildEntities(client, fraction, assetResolvers, localEntityNumber, randomResolver, viewOrigin, viewAngles)
```

Build entities.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `client` | `dynamic` | — | client value consumed by this operation. |
| `fraction` | `dynamic` | — | fraction value consumed by this operation. |
| `assetResolvers` | `dynamic` | — | assetResolvers value consumed by this operation. |
| `localEntityNumber` | `dynamic` | — | localEntityNumber value consumed by this operation. |
| `randomResolver` | `dynamic` | — | randomResolver value consumed by this operation. |
| `viewOrigin` | `dynamic` | — | viewOrigin value consumed by this operation. |
| `viewAngles` | `dynamic` | — | viewAngles value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/state.ml#L607)

<a id="function-function-miniquake2-client-state-buildpredictedrefdef-function-buildpredictedrefdef-client-fraction-width-height-assetresolvers-localentitynumber-randomresolver-src-miniquake2-client-state-ml-1488432235"></a>
### buildPredictedRefDef

```ml
function buildPredictedRefDef(client, fraction, width, height, assetResolvers, localEntityNumber, randomResolver)
```

Build predicted ref def.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `client` | `dynamic` | — | client value consumed by this operation. |
| `fraction` | `dynamic` | — | fraction value consumed by this operation. |
| `width` | `dynamic` | — | Width in the coordinate or storage units used by the caller. |
| `height` | `dynamic` | — | Height in the coordinate or storage units used by the caller. |
| `assetResolvers` | `dynamic` | — | assetResolvers value consumed by this operation. |
| `localEntityNumber` | `dynamic` | — | localEntityNumber value consumed by this operation. |
| `randomResolver` | `dynamic` | — | randomResolver value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/state.ml#L907)

<a id="function-function-miniquake2-client-state-buildpredictedrefdefwithoffset-function-buildpredictedrefdefwithoffset-client-fraction-width-height-assetresolvers-localentitynumber-randomresolver-predictionoffset-src-miniquake2-client-state-ml-1360552153"></a>
### buildPredictedRefDefWithOffset

```ml
function buildPredictedRefDefWithOffset(client, fraction, width, height, assetResolvers, localEntityNumber, randomResolver, predictionOffset)
```

Build a predicted refdef while matching a locally ridden pusher's visual interpolation. The offset is deliberately explicit so ordinary movement prediction, demos and renderer captures cannot accidentally inherit it.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `client` | `dynamic` | — | client value consumed by this operation. |
| `fraction` | `dynamic` | — | fraction value consumed by this operation. |
| `width` | `dynamic` | — | Width in the coordinate or storage units used by the caller. |
| `height` | `dynamic` | — | Height in the coordinate or storage units used by the caller. |
| `assetResolvers` | `dynamic` | — | assetResolvers value consumed by this operation. |
| `localEntityNumber` | `dynamic` | — | localEntityNumber value consumed by this operation. |
| `randomResolver` | `dynamic` | — | randomResolver value consumed by this operation. |
| `predictionOffset` | `dynamic` | — | predictionOffset value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/state.ml#L924)

<a id="function-function-miniquake2-client-state-buildrefdef-function-buildrefdef-client-fraction-width-height-assetresolvers-localentitynumber-randomresolver-src-miniquake2-client-state-ml-1941528055"></a>
### buildRefDef

```ml
function buildRefDef(client, fraction, width, height, assetResolvers, localEntityNumber, randomResolver)
```

Demos and deterministic renderer captures intentionally retain pure server interpolation.  The live product uses the explicit predicted entry point.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `client` | `dynamic` | — | client value consumed by this operation. |
| `fraction` | `dynamic` | — | fraction value consumed by this operation. |
| `width` | `dynamic` | — | Width in the coordinate or storage units used by the caller. |
| `height` | `dynamic` | — | Height in the coordinate or storage units used by the caller. |
| `assetResolvers` | `dynamic` | — | assetResolvers value consumed by this operation. |
| `localEntityNumber` | `dynamic` | — | localEntityNumber value consumed by this operation. |
| `randomResolver` | `dynamic` | — | randomResolver value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/state.ml#L893)

<a id="function-function-miniquake2-client-state-buildrefdefinternal-function-buildrefdefinternal-client-fraction-width-height-assetresolvers-localentitynumber-randomresolver-useprediction-predictionoffset-src-miniquake2-client-state-ml-856992689"></a>
### buildRefDefInternal

```ml
function buildRefDefInternal(client, fraction, width, height, assetResolvers, localEntityNumber, randomResolver, usePrediction, predictionOffset)
```

Build ref def internal.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `client` | `dynamic` | — | client value consumed by this operation. |
| `fraction` | `dynamic` | — | fraction value consumed by this operation. |
| `width` | `dynamic` | — | Width in the coordinate or storage units used by the caller. |
| `height` | `dynamic` | — | Height in the coordinate or storage units used by the caller. |
| `assetResolvers` | `dynamic` | — | assetResolvers value consumed by this operation. |
| `localEntityNumber` | `dynamic` | — | localEntityNumber value consumed by this operation. |
| `randomResolver` | `dynamic` | — | randomResolver value consumed by this operation. |
| `usePrediction` | `dynamic` | — | usePrediction value consumed by this operation. |
| `predictionOffset` | `dynamic` | — | predictionOffset value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/state.ml#L811)

<a id="function-function-miniquake2-client-state-clampfraction-inline-function-clampfraction-value-src-miniquake2-client-state-ml-1743740752"></a>
### clampFraction

```ml
inline function clampFraction(value)
```

Clamp fraction.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/state.ml#L198)

<a id="function-function-miniquake2-client-state-clearprediction-function-clearprediction-client-src-miniquake2-client-state-ml-713759553"></a>
### clearPrediction

```ml
function clearPrediction(client)
```

Clear prediction.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `client` | `dynamic` | — | client value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/state.ml#L789)

- [miniquake2.client.state.ClientRuntime](Type-miniquake2-client-state-clientruntime-430248448.md) — struct
<a id="function-function-miniquake2-client-state-create-function-create-src-miniquake2-client-state-ml-27386254"></a>
### create

```ml
function create()
```

Creates create for the miniquake2 client state module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/state.ml#L71)

<a id="function-function-miniquake2-client-state-currententity-inline-function-currententity-client-number-src-miniquake2-client-state-ml-483408735"></a>
### currentEntity

```ml
inline function currentEntity(client, number)
```

Return the current entity value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `client` | `dynamic` | — | client value consumed by this operation. |
| `number` | `dynamic` | — | number value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/state.ml#L165)

<a id="function-function-miniquake2-client-state-disguisefamily-inline-function-disguisefamily-skin-src-miniquake2-client-state-ml-1335021360"></a>
### disguiseFamily

```ml
inline function disguiseFamily(skin)
```

Return the disguise family value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `skin` | `dynamic` | — | skin value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/state.ml#L402)

<a id="function-function-miniquake2-client-state-effectiveeffects-inline-function-effectiveeffects-state-src-miniquake2-client-state-ml-2138075428"></a>
### effectiveEffects

```ml
inline function effectiveEffects(state)
```

Return the effective effects value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/state.ml#L318)

<a id="function-function-miniquake2-client-state-effectiverenderfx-inline-function-effectiverenderfx-state-src-miniquake2-client-state-ml-1372468920"></a>
### effectiveRenderFx

```ml
inline function effectiveRenderFx(state)
```

Render effective fx.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/state.ml#L337)

<a id="function-function-miniquake2-client-state-entityrenderangles-inline-function-entityrenderangles-oldstate-state-fraction-reset-src-miniquake2-client-state-ml-42324705"></a>
### entityRenderAngles

```ml
inline function entityRenderAngles(oldState, state, fraction, reset)
```

Render entity angles.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `oldState` | `dynamic` | — | oldState value consumed by this operation. |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `fraction` | `dynamic` | — | fraction value consumed by this operation. |
| `reset` | `dynamic` | — | reset value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/state.ml#L311)

<a id="function-function-miniquake2-client-state-entityrenderorigin-inline-function-entityrenderorigin-oldstate-state-fraction-reset-src-miniquake2-client-state-ml-1653280985"></a>
### entityRenderOrigin

```ml
inline function entityRenderOrigin(oldState, state, fraction, reset)
```

Render entity origin.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `oldState` | `dynamic` | — | oldState value consumed by this operation. |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `fraction` | `dynamic` | — | fraction value consumed by this operation. |
| `reset` | `dynamic` | — | reset value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/state.ml#L296)

<a id="function-function-miniquake2-client-state-entityrequireslerpreset-inline-function-entityrequireslerpreset-oldstate-state-src-miniquake2-client-state-ml-1868825318"></a>
### entityRequiresLerpReset

```ml
inline function entityRequiresLerpReset(oldState, state)
```

CL_DeltaEntity deliberately breaks interpolation when an entity changes model, moves more than 512 units between server frames, or reports either teleport event.  Particle trails already observe this rule; the render handoff must use the same predecessor or models visibly sweep through the world after teleports and model replacements.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `oldState` | `dynamic` | — | oldState value consumed by this operation. |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/state.ml#L275)

<a id="function-function-miniquake2-client-state-findentity-function-findentity-entities-number-src-miniquake2-client-state-ml-1963908516"></a>
### findEntity

```ml
function findEntity(entities, number)
```

Find entity.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entities` | `dynamic` | — | entities value consumed by this operation. |
| `number` | `dynamic` | — | number value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/state.ml#L186)

<a id="function-function-miniquake2-client-state-interpolatedangles-function-interpolatedangles-oldstate-currentstate-fraction-src-miniquake2-client-state-ml-888491580"></a>
### interpolatedAngles

```ml
function interpolatedAngles(oldState, currentState, fraction)
```

Return the interpolated angles.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `oldState` | `dynamic` | — | oldState value consumed by this operation. |
| `currentState` | `dynamic` | — | currentState value consumed by this operation. |
| `fraction` | `dynamic` | — | fraction value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/state.ml#L259)

<a id="function-function-miniquake2-client-state-interpolatedorigin-function-interpolatedorigin-oldstate-currentstate-fraction-src-miniquake2-client-state-ml-400274852"></a>
### interpolatedOrigin

```ml
function interpolatedOrigin(oldState, currentState, fraction)
```

Return the interpolated origin.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `oldState` | `dynamic` | — | oldState value consumed by this operation. |
| `currentState` | `dynamic` | — | currentState value consumed by this operation. |
| `fraction` | `dynamic` | — | fraction value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/state.ml#L244)

<a id="function-function-miniquake2-client-state-interpolationplayer-function-interpolationplayer-client-src-miniquake2-client-state-ml-1793648439"></a>
### interpolationPlayer

```ml
function interpolationPlayer(client)
```

Return the interpolation player value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `client` | `dynamic` | — | client value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/state.ml#L226)

<a id="function-function-miniquake2-client-state-lastknownentity-inline-function-lastknownentity-client-number-src-miniquake2-client-state-ml-274180387"></a>
### lastKnownEntity

```ml
inline function lastKnownEntity(client, number)
```

Return the last entity state published during this map epoch. Effects such as muzzle flashes may arrive in a packet whose snapshot omits an otherwise unchanged source entity, matching cl_entities[number].current in stock.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `client` | `dynamic` | — | client value consumed by this operation. |
| `number` | `dynamic` | — | number value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/state.ml#L178)

<a id="function-function-miniquake2-client-state-lerp-inline-function-lerp-first-second-fraction-src-miniquake2-client-state-ml-1443943033"></a>
### lerp

```ml
inline function lerp(first, second, fraction)
```

Return the lerp value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `dynamic` | — | first value consumed by this operation. |
| `second` | `dynamic` | — | second value consumed by this operation. |
| `fraction` | `dynamic` | — | fraction value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/state.ml#L208)

<a id="function-function-miniquake2-client-state-lerpangle-inline-function-lerpangle-first-second-fraction-src-miniquake2-client-state-ml-1609304205"></a>
### lerpAngle

```ml
inline function lerpAngle(first, second, fraction)
```

Quake II angles wrap at 360 degrees. A scalar interpolation would spin the long way around when a snapshot crosses north (for example 359 -> 1).

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `dynamic` | — | first value consumed by this operation. |
| `second` | `dynamic` | — | second value consumed by this operation. |
| `fraction` | `dynamic` | — | fraction value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/state.ml#L217)

<a id="function-function-miniquake2-client-state-notepredictionstep-function-notepredictionstep-client-previousfixedorigin-currentfixedorigin-flags-framemsec-src-miniquake2-client-state-ml-533913617"></a>
### notePredictionStep

```ml
function notePredictionStep(client, previousFixedOrigin, currentFixedOrigin, flags, frameMsec)
```

CL_PredictMovement recognizes one ordinary stair riser in fixed-point Pmove coordinates (8..20 world units) and records a half-frame-adjusted start time. CL_CalcViewValues then removes that vertical discontinuity over the next 100 ms instead of snapping the camera upward.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `client` | `dynamic` | — | client value consumed by this operation. |
| `previousFixedOrigin` | `dynamic` | — | previousFixedOrigin value consumed by this operation. |
| `currentFixedOrigin` | `dynamic` | — | currentFixedOrigin value consumed by this operation. |
| `flags` | `dynamic` | — | Bit flags controlling the operation. |
| `frameMsec` | `dynamic` | — | frameMsec value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/state.ml#L760)

<a id="function-function-miniquake2-client-state-renderangles-function-renderangles-oldstate-state-effects-fraction-rendertime-lerpreset-src-miniquake2-client-state-ml-2065558492"></a>
### renderAngles

```ml
function renderAngles(oldState, state, effects, fraction, renderTime, lerpReset)
```

Render angles.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `oldState` | `dynamic` | — | oldState value consumed by this operation. |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `effects` | `dynamic` | — | effects value consumed by this operation. |
| `fraction` | `dynamic` | — | fraction value consumed by this operation. |
| `renderTime` | `dynamic` | — | renderTime value consumed by this operation. |
| `lerpReset` | `dynamic` | — | lerpReset value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/state.ml#L386)

<a id="function-function-miniquake2-client-state-runlightstyles-function-runlightstyles-client-rendertime-src-miniquake2-client-state-ml-1429375188"></a>
### runLightStyles

```ml
function runLightStyles(client, renderTime)
```

Run light styles.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `client` | `dynamic` | — | client value consumed by this operation. |
| `renderTime` | `dynamic` | — | renderTime value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/state.ml#L100)

<a id="function-function-miniquake2-client-state-setconnectionstate-function-setconnectionstate-client-state-src-miniquake2-client-state-ml-270969880"></a>
### setConnectionState

```ml
function setConnectionState(client, state)
```

Set connection state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `client` | `dynamic` | — | client value consumed by this operation. |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/state.ml#L122)

<a id="function-function-miniquake2-client-state-setlightstyle-function-setlightstyle-client-index-pattern-src-miniquake2-client-state-ml-65164477"></a>
### setLightStyle

```ml
function setLightStyle(client, index, pattern)
```

CL_SetLightstyle decodes CS_LIGHTS strings lazily at their 10 Hz playback rate. Keeping the compact source string avoids a second 256 x MAX_QPATH float table and is cheaper than rebuilding every style on every render.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `client` | `dynamic` | — | client value consumed by this operation. |
| `index` | `dynamic` | — | Zero-based index of the affected item. |
| `pattern` | `dynamic` | — | pattern value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/state.ml#L85)

<a id="function-function-miniquake2-client-state-setpredictionrealtime-function-setpredictionrealtime-client-now-src-miniquake2-client-state-ml-559059469"></a>
### setPredictionRealTime

```ml
function setPredictionRealTime(client, now)
```

Set prediction real time.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `client` | `dynamic` | — | client value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/state.ml#L723)

<a id="function-function-miniquake2-client-state-setpredictionstepsuppressed-function-setpredictionstepsuppressed-client-value-src-miniquake2-client-state-ml-696001926"></a>
### setPredictionStepSuppressed

```ml
function setPredictionStepSuppressed(client, value)
```

Tell the stair smoother whether local prediction is currently carried by a moving brush. A lift's regular vertical displacement falls inside the ordinary 8..20-unit stair range, but smoothing it as a stair every server frame makes the camera repeatedly ease downward and visibly hop upward. The application derives this flag from Player.groundEntity before it replays prediction; the underlying movement state remains authoritative.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `client` | `dynamic` | — | client value consumed by this operation. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/state.ml#L739)

<a id="function-function-miniquake2-client-state-statemodelcount-inline-function-statemodelcount-state-src-miniquake2-client-state-ml-562686012"></a>
### stateModelCount

```ml
inline function stateModelCount(state)
```

Return the state model count.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/state.ml#L348)

<a id="function-function-miniquake2-client-state-updatepredictionerror-function-updatepredictionerror-client-predictedfixedorigin-src-miniquake2-client-state-ml-1590594357"></a>
### updatePredictionError

```ml
function updatePredictionError(client, predictedFixedOrigin)
```

Update prediction error.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `client` | `dynamic` | — | client value consumed by this operation. |
| `predictedFixedOrigin` | `dynamic` | — | predictedFixedOrigin value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/state.ml#L687)
