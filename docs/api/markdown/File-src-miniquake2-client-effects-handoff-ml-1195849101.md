# `src/miniquake2/client/effects/handoff.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 client effects handoff facilities for this project.

Package: [`miniquake2.client.effects.handoff`](Package-miniquake2-client-effects-handoff-375944752.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/client/effects/constants.ml` as `ceconstants` → [src/miniquake2/client/effects/constants.ml](File-src-miniquake2-client-effects-constants-ml-55259948.md)
- `miniquake2/client/effects/state.ml` as `cestate` → [src/miniquake2/client/effects/state.ml](File-src-miniquake2-client-effects-state-ml-140719308.md)
- `miniquake2/qcommon/byteio.ml` as `qbio` → [src/miniquake2/qcommon/byteio.ml](File-src-miniquake2-qcommon-byteio-ml-159119335.md)
- `miniquake2/qcommon/types.ml` as `qt` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)
- `miniquake2/renderer/constants.ml` as `rc` → [src/miniquake2/renderer/constants.ml](File-src-miniquake2-renderer-constants-ml-1893707491.md)
- `miniquake2/renderer/types.ml` as `rt` → [src/miniquake2/renderer/types.ml](File-src-miniquake2-renderer-types-ml-975707623.md)
- `std/math.ml` as `cemath` → `../MiniLangCompilerML/std/math.ml` — external dependency

## Declarations

<a id="function-function-miniquake2-client-effects-handoff-appendbeamentities-function-appendbeamentities-output-count-maximum-beam-now-modelresolver-refdef-src-miniquake2-client-effects-handoff-ml-1803706145"></a>
### appendBeamEntities

```ml
function appendBeamEntities(output, count, maximum, beam, now, modelResolver, refDef)
```

Append beam entities.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `output` | `dynamic` | — | Output collection or buffer populated by the operation. |
| `count` | `dynamic` | — | Number of items or units to process. |
| `maximum` | `dynamic` | — | maximum value consumed by this operation. |
| `beam` | `dynamic` | — | beam value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |
| `modelResolver` | `dynamic` | — | modelResolver value consumed by this operation. |
| `refDef` | `dynamic` | — | refDef value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/handoff.ml#L185)

<a id="function-function-miniquake2-client-effects-handoff-appendlimited-function-appendlimited-values-additions-maximum-src-miniquake2-client-effects-handoff-ml-676854664"></a>
### appendLimited

```ml
function appendLimited(values, additions, maximum)
```

Append limited.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `values` | `dynamic` | — | values value consumed by this operation. |
| `additions` | `dynamic` | — | additions value consumed by this operation. |
| `maximum` | `dynamic` | — | maximum value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/handoff.ml#L22)

<a id="function-function-miniquake2-client-effects-handoff-apply-function-apply-state-refdef-now-modelresolver-src-miniquake2-client-effects-handoff-ml-1530174533"></a>
### apply

```ml
function apply(state, refDef, now, modelResolver)
```

Apply state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `refDef` | `dynamic` | — | refDef value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |
| `modelResolver` | `dynamic` | — | modelResolver value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/handoff.ml#L381)

<a id="function-function-miniquake2-client-effects-handoff-applyprepared-function-applyprepared-state-refdef-now-modelresolver-src-miniquake2-client-effects-handoff-ml-575762187"></a>
### applyPrepared

```ml
function applyPrepared(state, refDef, now, modelResolver)
```

Product rendering calls entity.emit first, which already advances the shared effect state. Keep that prepared path separate so one frame never scans and compacts every effect collection twice at the same timestamp.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `refDef` | `dynamic` | — | refDef value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |
| `modelResolver` | `dynamic` | — | modelResolver value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/handoff.ml#L314)

<a id="function-function-miniquake2-client-effects-handoff-beamorigin-function-beamorigin-beam-refdef-src-miniquake2-client-effects-handoff-ml-1280951508"></a>
### beamOrigin

```ml
function beamOrigin(beam, refDef)
```

Return the beam origin.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `beam` | `dynamic` | — | beam value consumed by this operation. |
| `refDef` | `dynamic` | — | refDef value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/handoff.ml#L150)

<a id="function-function-miniquake2-client-effects-handoff-explosionalpha-function-explosionalpha-explosion-now-src-miniquake2-client-effects-handoff-ml-393489458"></a>
### explosionAlpha

```ml
function explosionAlpha(explosion, now)
```

Return the explosion alpha value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `explosion` | `dynamic` | — | explosion value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/handoff.ml#L266)

<a id="function-function-miniquake2-client-effects-handoff-explosionentity-function-explosionentity-explosion-now-modelresolver-src-miniquake2-client-effects-handoff-ml-1969917223"></a>
### explosionEntity

```ml
function explosionEntity(explosion, now, modelResolver)
```

Return the explosion entity value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `explosion` | `dynamic` | — | explosion value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |
| `modelResolver` | `dynamic` | — | modelResolver value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/handoff.ml#L284)

<a id="function-function-miniquake2-client-effects-handoff-explosionframe-function-explosionframe-explosion-now-src-miniquake2-client-effects-handoff-ml-1918585802"></a>
### explosionFrame

```ml
function explosionFrame(explosion, now)
```

Return the explosion frame value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `explosion` | `dynamic` | — | explosion value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/handoff.ml#L259)

<a id="function-function-miniquake2-client-effects-handoff-laserentity-function-laserentity-laser-src-miniquake2-client-effects-handoff-ml-17160984"></a>
### laserEntity

```ml
function laserEntity(laser)
```

Return the laser entity value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `laser` | `dynamic` | — | laser value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/handoff.ml#L250)

<a id="function-function-miniquake2-client-effects-handoff-particleorigin-function-particleorigin-particle-now-src-miniquake2-client-effects-handoff-ml-1693753745"></a>
### particleOrigin

```ml
function particleOrigin(particle, now)
```

Return the particle origin.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `particle` | `dynamic` | — | particle value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/handoff.ml#L61)

<a id="function-function-miniquake2-client-effects-handoff-rendererdlights-function-rendererdlights-state-src-miniquake2-client-effects-handoff-ml-1361129974"></a>
### rendererDLights

```ml
function rendererDLights(state)
```

Return the renderer d lights value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/handoff.ml#L120)

<a id="function-function-miniquake2-client-effects-handoff-rendererparticles-function-rendererparticles-state-now-src-miniquake2-client-effects-handoff-ml-1057026948"></a>
### rendererParticles

```ml
function rendererParticles(state, now)
```

Return the renderer particles value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/handoff.ml#L73)

<a id="function-function-miniquake2-client-effects-handoff-trim-function-trim-values-count-src-miniquake2-client-effects-handoff-ml-536311530"></a>
### trim

```ml
function trim(values, count)
```

Trim state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `values` | `dynamic` | — | values value consumed by this operation. |
| `count` | `dynamic` | — | Number of items or units to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/handoff.ml#L46)
