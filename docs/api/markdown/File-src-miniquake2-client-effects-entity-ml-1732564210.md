# `src/miniquake2/client/effects/entity.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 client effects entity facilities for this project.

Package: [`miniquake2.client.effects.entity`](Package-miniquake2-client-effects-entity-329349581.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/client/effects/constants.ml` as `constants` → [src/miniquake2/client/effects/constants.ml](File-src-miniquake2-client-effects-constants-ml-55259948.md)
- `miniquake2/client/effects/state.ml` as `statefx` → [src/miniquake2/client/effects/state.ml](File-src-miniquake2-client-effects-state-ml-140719308.md)
- `miniquake2/client/effects/types.ml` as `types` → [src/miniquake2/client/effects/types.ml](File-src-miniquake2-client-effects-types-ml-621918960.md)
- `miniquake2/qcommon/types.ml` as `qt` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)
- `miniquake2/renderer/constants.ml` as `rc` → [src/miniquake2/renderer/constants.ml](File-src-miniquake2-renderer-constants-ml-1893707491.md)
- `miniquake2/renderer/types.ml` as `rt` → [src/miniquake2/renderer/types.ml](File-src-miniquake2-renderer-types-ml-975707623.md)
- `std/math.ml` as `eemath` → `../MiniLangCompilerML/std/math.ml` — external dependency

## Declarations

<a id="function-function-miniquake2-client-effects-entity-appendlight-function-appendlight-output-count-origin-intensity-red-green-blue-src-miniquake2-client-effects-entity-ml-473529216"></a>
### appendLight

```ml
function appendLight(output, count, origin, intensity, red, green, blue)
```

Append light.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `output` | `dynamic` | — | Output collection or buffer populated by the operation. |
| `count` | `dynamic` | — | Number of items or units to process. |
| `origin` | `dynamic` | — | origin value consumed by this operation. |
| `intensity` | `dynamic` | — | intensity value consumed by this operation. |
| `red` | `dynamic` | — | red value consumed by this operation. |
| `green` | `dynamic` | — | green value consumed by this operation. |
| `blue` | `dynamic` | — | blue value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/entity.ml#L66)

<a id="function-function-miniquake2-client-effects-entity-arrayorigin-inline-function-arrayorigin-value-src-miniquake2-client-effects-entity-ml-6544257"></a>
### arrayOrigin

```ml
inline function arrayOrigin(value)
```

Return the array origin.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/entity.ml#L20)

<a id="function-function-miniquake2-client-effects-entity-compactlights-function-compactlights-values-count-src-miniquake2-client-effects-entity-ml-1118358658"></a>
### compactLights

```ml
function compactLights(values, count)
```

Return the compact lights value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `values` | `dynamic` | — | values value consumed by this operation. |
| `count` | `dynamic` | — | Number of items or units to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/entity.ml#L83)

<a id="function-function-miniquake2-client-effects-entity-emit-function-emit-state-currentsnapshot-previoussnapshot-fraction-now-localentitynumber-refdef-src-miniquake2-client-effects-entity-ml-1464279191"></a>
### emit

```ml
function emit(state, currentSnapshot, previousSnapshot, fraction, now, localEntityNumber, refDef)
```

Performs the emit operation for the miniquake2 client effects entity module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `currentSnapshot` | `dynamic` | — | currentSnapshot value consumed by this operation. |
| `previousSnapshot` | `dynamic` | — | previousSnapshot value consumed by this operation. |
| `fraction` | `dynamic` | — | fraction value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |
| `localEntityNumber` | `dynamic` | — | localEntityNumber value consumed by this operation. |
| `refDef` | `dynamic` | — | refDef value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/entity.ml#L245)

<a id="function-function-miniquake2-client-effects-entity-emitautomatic-function-emitautomatic-state-trail-entity-startposition-endposition-now-lights-lightcount-src-miniquake2-client-effects-entity-ml-575696728"></a>
### emitAutomatic

```ml
function emitAutomatic(state, trail, entity, startPosition, endPosition, now, lights, lightCount)
```

Emit automatic.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `trail` | `dynamic` | — | trail value consumed by this operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `startPosition` | `dynamic` | — | startPosition value consumed by this operation. |
| `endPosition` | `dynamic` | — | endPosition value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |
| `lights` | `dynamic` | — | lights value consumed by this operation. |
| `lightCount` | `dynamic` | — | Number of light to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/entity.ml#L142)

<a id="function-function-miniquake2-client-effects-entity-emitlocallight-function-emitlocallight-lights-lightcount-effects-origin-now-src-miniquake2-client-effects-entity-ml-2050592413"></a>
### emitLocalLight

```ml
function emitLocalLight(lights, lightCount, effects, origin, now)
```

Emit local light.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `lights` | `dynamic` | — | lights value consumed by this operation. |
| `lightCount` | `dynamic` | — | Number of light to process. |
| `effects` | `dynamic` | — | effects value consumed by this operation. |
| `origin` | `dynamic` | — | origin value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/entity.ml#L101)

<a id="function-function-miniquake2-client-effects-entity-emitspinninglight-function-emitspinninglight-lights-lightcount-entity-origin-now-src-miniquake2-client-effects-entity-ml-493741024"></a>
### emitSpinningLight

```ml
function emitSpinningLight(lights, lightCount, entity, origin, now)
```

Emit spinning light.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `lights` | `dynamic` | — | lights value consumed by this operation. |
| `lightCount` | `dynamic` | — | Number of light to process. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `origin` | `dynamic` | — | origin value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/entity.ml#L123)

<a id="function-function-miniquake2-client-effects-entity-interpolatedorigin-inline-function-interpolatedorigin-previous-current-fraction-reset-src-miniquake2-client-effects-entity-ml-1268255355"></a>
### interpolatedOrigin

```ml
inline function interpolatedOrigin(previous, current, fraction, reset)
```

Return the interpolated origin.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `previous` | `dynamic` | — | previous value consumed by this operation. |
| `current` | `dynamic` | — | current value consumed by this operation. |
| `fraction` | `dynamic` | — | fraction value consumed by this operation. |
| `reset` | `dynamic` | — | reset value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/entity.ml#L29)

<a id="function-function-miniquake2-client-effects-entity-requiresreset-inline-function-requiresreset-previous-current-src-miniquake2-client-effects-entity-ml-798759924"></a>
### requiresReset

```ml
inline function requiresReset(previous, current)
```

Reset requires.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `previous` | `dynamic` | — | previous value consumed by this operation. |
| `current` | `dynamic` | — | current value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/entity.ml#L43)
