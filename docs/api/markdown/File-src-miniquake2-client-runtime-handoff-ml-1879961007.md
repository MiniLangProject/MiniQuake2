# `src/miniquake2/client/runtime/handoff.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 client runtime handoff facilities for this project.

Package: [`miniquake2.client.runtime.handoff`](Package-miniquake2-client-runtime-handoff-2027895010.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/client/effects/types.ml` as `cetypes` → [src/miniquake2/client/effects/types.ml](File-src-miniquake2-client-effects-types-ml-621918960.md)
- `miniquake2/client/runtime/types.ml` as `crtypes` → [src/miniquake2/client/runtime/types.ml](File-src-miniquake2-client-runtime-types-ml-466848886.md)
- `miniquake2/protocol/types.ml` as `pt` → [src/miniquake2/protocol/types.ml](File-src-miniquake2-protocol-types-ml-736261438.md)
- `miniquake2/qcommon/types.ml` as `qt` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)

## Declarations

<a id="function-function-miniquake2-client-runtime-handoff-appendbounded-function-appendbounded-values-value-src-miniquake2-client-runtime-handoff-ml-1428412850"></a>
### appendBounded

```ml
function appendBounded(values, value)
```

Append bounded.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `values` | `dynamic` | — | values value consumed by this operation. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/runtime/handoff.ml#L232)

<a id="function-function-miniquake2-client-runtime-handoff-appendevents-function-appendevents-first-second-src-miniquake2-client-runtime-handoff-ml-1811265989"></a>
### appendEvents

```ml
function appendEvents(first, second)
```

Append two small transient event collections. Persistent render state is read directly from the latest immutable client snapshot; only one-shot UI and audio events need ordered aggregation when several packets arrive in a single product pump.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `dynamic` | — | first value consumed by this operation. |
| `second` | `dynamic` | — | second value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/runtime/handoff.ml#L253)

<a id="function-function-miniquake2-client-runtime-handoff-commit-function-commit-runtime-now-src-miniquake2-client-runtime-handoff-ml-561328227"></a>
### commit

```ml
function commit(runtime, now)
```

Commit state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/runtime/handoff.ml#L273)

<a id="function-function-miniquake2-client-runtime-handoff-copybeams-function-copybeams-values-src-miniquake2-client-runtime-handoff-ml-228174795"></a>
### copyBeams

```ml
function copyBeams(values)
```

Copy beams data.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `values` | `dynamic` | — | values value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/runtime/handoff.ml#L91)

<a id="function-function-miniquake2-client-runtime-handoff-copycenters-function-copycenters-values-src-miniquake2-client-runtime-handoff-ml-479999867"></a>
### copyCenters

```ml
function copyCenters(values)
```

Copy centers data.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `values` | `dynamic` | — | values value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/runtime/handoff.ml#L190)

<a id="function-function-miniquake2-client-runtime-handoff-copyexplosions-function-copyexplosions-values-src-miniquake2-client-runtime-handoff-ml-317368345"></a>
### copyExplosions

```ml
function copyExplosions(values)
```

Copy explosions data.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `values` | `dynamic` | — | values value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/runtime/handoff.ml#L125)

<a id="function-function-miniquake2-client-runtime-handoff-copyinventories-function-copyinventories-values-src-miniquake2-client-runtime-handoff-ml-1369598779"></a>
### copyInventories

```ml
function copyInventories(values)
```

Copy inventories data.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `values` | `dynamic` | — | values value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/runtime/handoff.ml#L216)

<a id="function-function-miniquake2-client-runtime-handoff-copylasers-function-copylasers-values-src-miniquake2-client-runtime-handoff-ml-1732304657"></a>
### copyLasers

```ml
function copyLasers(values)
```

Copy lasers data.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `values` | `dynamic` | — | values value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/runtime/handoff.ml#L109)

<a id="function-function-miniquake2-client-runtime-handoff-copylayouts-function-copylayouts-values-src-miniquake2-client-runtime-handoff-ml-1985315685"></a>
### copyLayouts

```ml
function copyLayouts(values)
```

Copy layouts data.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `values` | `dynamic` | — | values value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/runtime/handoff.ml#L203)

<a id="function-function-miniquake2-client-runtime-handoff-copylights-function-copylights-values-src-miniquake2-client-runtime-handoff-ml-1169697921"></a>
### copyLights

```ml
function copyLights(values)
```

Copy lights data.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `values` | `dynamic` | — | values value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/runtime/handoff.ml#L57)

<a id="function-function-miniquake2-client-runtime-handoff-copyparticles-function-copyparticles-values-count-src-miniquake2-client-runtime-handoff-ml-7785806"></a>
### copyParticles

```ml
function copyParticles(values, count)
```

Copy particles data.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `values` | `dynamic` | — | values value consumed by this operation. |
| `count` | `dynamic` | — | Number of items or units to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/runtime/handoff.ml#L74)

<a id="function-function-miniquake2-client-runtime-handoff-copyprints-function-copyprints-values-src-miniquake2-client-runtime-handoff-ml-728885385"></a>
### copyPrints

```ml
function copyPrints(values)
```

Copy prints data.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `values` | `dynamic` | — | values value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/runtime/handoff.ml#L177)

<a id="function-function-miniquake2-client-runtime-handoff-copysnapshot-function-copysnapshot-value-src-miniquake2-client-runtime-handoff-ml-1201710894"></a>
### copySnapshot

```ml
function copySnapshot(value)
```

Copy snapshot data.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/runtime/handoff.ml#L39)

<a id="function-function-miniquake2-client-runtime-handoff-copysounds-function-copysounds-values-src-miniquake2-client-runtime-handoff-ml-862062593"></a>
### copySounds

```ml
function copySounds(values)
```

Copy sounds data.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `values` | `dynamic` | — | values value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/runtime/handoff.ml#L161)

<a id="function-function-miniquake2-client-runtime-handoff-copysustains-function-copysustains-values-src-miniquake2-client-runtime-handoff-ml-364170825"></a>
### copySustains

```ml
function copySustains(values)
```

Copy sustains data.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `values` | `dynamic` | — | values value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/runtime/handoff.ml#L144)

<a id="function-function-miniquake2-client-runtime-handoff-copyvalues-function-copyvalues-values-src-miniquake2-client-runtime-handoff-ml-2134493025"></a>
### copyValues

```ml
function copyValues(values)
```

Copy values data.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `values` | `dynamic` | — | values value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/runtime/handoff.ml#L27)

<a id="function-function-miniquake2-client-runtime-handoff-copyvec-function-copyvec-value-src-miniquake2-client-runtime-handoff-ml-2025858564"></a>
### copyVec

```ml
function copyVec(value)
```

Copy vec data.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/runtime/handoff.ml#L20)

<a id="constant-constant-miniquake2-client-runtime-handoff-max-frame-handoffs-const-max-frame-handoffs-8-src-miniquake2-client-runtime-handoff-ml-1295663024"></a>
### MAX_FRAME_HANDOFFS

```ml
const MAX_FRAME_HANDOFFS = 8
```

Defines the max frame handoffs constant used by the miniquake2 client runtime handoff module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/runtime/handoff.ml#L16)

<a id="function-function-miniquake2-client-runtime-handoff-pending-function-pending-runtime-src-miniquake2-client-runtime-handoff-ml-465014781"></a>
### pending

```ml
function pending(runtime)
```

Report whether pending.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/runtime/handoff.ml#L367)

<a id="function-function-miniquake2-client-runtime-handoff-take-function-take-runtime-src-miniquake2-client-runtime-handoff-ml-2100060711"></a>
### take

```ml
function take(runtime)
```

Consume state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/runtime/handoff.ml#L330)

<a id="function-function-miniquake2-client-runtime-handoff-takelatest-function-takelatest-runtime-src-miniquake2-client-runtime-handoff-ml-1700578275"></a>
### takeLatest

```ml
function takeLatest(runtime)
```

Consume latest.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/runtime/handoff.ml#L345)
