# `src/miniquake2/client/ui/input.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 client ui input facilities for this project.

Package: [`miniquake2.client.ui.input`](Package-miniquake2-client-ui-input-842890738.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/client/ui/constants.ml` as `cuic` → [src/miniquake2/client/ui/constants.ml](File-src-miniquake2-client-ui-constants-ml-1004124106.md)
- `miniquake2/client/ui/keys.ml` as `cuikeys` → [src/miniquake2/client/ui/keys.ml](File-src-miniquake2-client-ui-keys-ml-2076131853.md)
- `miniquake2/qcommon/types.ml` as `qt` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)
- `std/math.ml` as `smath` → `../MiniLangCompilerML/std/math.ml` — external dependency

## Declarations

<a id="function-function-miniquake2-client-ui-input-action-function-action-state-name-src-miniquake2-client-ui-input-ml-1183412227"></a>
### action

```ml
function action(state, name)
```

Performs the action operation for the miniquake2 client ui input module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/input.ml#L18)

<a id="function-function-miniquake2-client-ui-input-actionfraction-function-actionfraction-state-name-framemsec-consume-src-miniquake2-client-ui-input-ml-452078832"></a>
### actionFraction

```ml
function actionFraction(state, name, frameMsec, consume)
```

Return the fraction of this command interval for which an action was held. Key-up events contribute their exact timestamped duration; a still-held key contributes from its last down time through the command endpoint.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `name` | `dynamic` | — | Name of the affected item. |
| `frameMsec` | `dynamic` | — | frameMsec value consumed by this operation. |
| `consume` | `dynamic` | — | consume value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/input.ml#L31)

<a id="function-function-miniquake2-client-ui-input-addmousedelta-function-addmousedelta-state-dx-dy-src-miniquake2-client-ui-input-ml-111910111"></a>
### addMouseDelta

```ml
function addMouseDelta(state, dx, dy)
```

Add mouse delta.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `dx` | `dynamic` | — | dx value consumed by this operation. |
| `dy` | `dynamic` | — | dy value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/input.ml#L57)

<a id="function-function-miniquake2-client-ui-input-angleshort-function-angleshort-value-src-miniquake2-client-ui-input-ml-1722283354"></a>
### angleShort

```ml
function angleShort(value)
```

Return the angle short value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/input.ml#L89)

<a id="function-function-miniquake2-client-ui-input-buildsampledusercmd-function-buildsampledusercmd-state-framemsec-consumetransient-src-miniquake2-client-ui-input-ml-1611161509"></a>
### buildSampledUserCmd

```ml
function buildSampledUserCmd(state, frameMsec, consumeTransient)
```

Construct a command after sampleView has already consumed this render frame's look input.  consumeTransient=false is the side-effect-free preview used by client prediction between network ticks.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `frameMsec` | `dynamic` | — | frameMsec value consumed by this operation. |
| `consumeTransient` | `dynamic` | — | consumeTransient value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/input.ml#L145)

<a id="function-function-miniquake2-client-ui-input-clampcommandmsec-inline-function-clampcommandmsec-framemsec-src-miniquake2-client-ui-input-ml-424684241"></a>
### clampCommandMsec

```ml
inline function clampCommandMsec(frameMsec)
```

Clamp command msec.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `frameMsec` | `dynamic` | — | frameMsec value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/input.ml#L81)

<a id="function-function-miniquake2-client-ui-input-clamppitch-function-clamppitch-state-src-miniquake2-client-ui-input-ml-106023886"></a>
### clampPitch

```ml
function clampPitch(state)
```

Clamp pitch.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/input.ml#L74)

<a id="function-function-miniquake2-client-ui-input-createsampledusercmd-function-createsampledusercmd-state-framemsec-src-miniquake2-client-ui-input-ml-1660262119"></a>
### createSampledUserCmd

```ml
function createSampledUserCmd(state, frameMsec)
```

Create sampled user cmd.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `frameMsec` | `dynamic` | — | frameMsec value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/input.ml#L216)

<a id="function-function-miniquake2-client-ui-input-createusercmd-function-createusercmd-state-framemsec-src-miniquake2-client-ui-input-ml-1475267121"></a>
### createUserCmd

```ml
function createUserCmd(state, frameMsec)
```

Create user cmd.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `frameMsec` | `dynamic` | — | frameMsec value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/input.ml#L230)

<a id="function-function-miniquake2-client-ui-input-previewusercmd-function-previewusercmd-state-framemsec-src-miniquake2-client-ui-input-ml-1912021787"></a>
### previewUserCmd

```ml
function previewUserCmd(state, frameMsec)
```

Return the preview user cmd value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `frameMsec` | `dynamic` | — | frameMsec value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/input.ml#L223)

<a id="function-function-miniquake2-client-ui-input-sampleview-function-sampleview-state-framemsec-src-miniquake2-client-ui-input-ml-1682176119"></a>
### sampleView

```ml
function sampleView(state, frameMsec)
```

Apply view changes independently from the network command cadence.  The product samples this once per rendered frame, matching Quake II's CL_AdjustAngles/IN_Move split and removing the former 100 ms mouse-look lag. Mouse axes routed to strafe/klook deliberately remain accumulated until the next UserCmd because those axes are movement rather than view input.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `frameMsec` | `dynamic` | — | frameMsec value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/input.ml#L105)

<a id="function-function-miniquake2-client-ui-input-setimpulse-function-setimpulse-state-value-src-miniquake2-client-ui-input-ml-317601695"></a>
### setImpulse

```ml
function setImpulse(state, value)
```

Set impulse.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/input.ml#L66)
