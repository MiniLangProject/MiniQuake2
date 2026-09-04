# `src/miniquake2/platform/gamma.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 platform gamma facilities for this project.

Package: [`miniquake2.platform.gamma`](Package-miniquake2-platform-gamma-1386037083.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/native.ml` as `videogammanative` → [src/miniquake2/native.ml](File-src-miniquake2-native-ml-139597585.md)
- `miniquake2/qcommon/byteio.ml` as `videogammabyteio` → [src/miniquake2/qcommon/byteio.ml](File-src-miniquake2-qcommon-byteio-ml-159119335.md)
- `std/math.ml` as `videogammamath` → `../MiniLangCompilerML/std/math.ml` — external dependency

## Declarations

<a id="function-function-miniquake2-platform-gamma-apply-function-apply-state-gamma-active-src-miniquake2-platform-gamma-ml-1496399198"></a>
### apply

```ml
function apply(state, gamma, active)
```

Apply state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `gamma` | `dynamic` | — | gamma value consumed by this operation. |
| `active` | `dynamic` | — | active value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/platform/gamma.ml#L67)

<a id="function-function-miniquake2-platform-gamma-buildramp-function-buildramp-gamma-src-miniquake2-platform-gamma-ml-590182181"></a>
### buildRamp

```ml
function buildRamp(gamma)
```

Build ramp.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `gamma` | `dynamic` | — | gamma value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/platform/gamma.ml#L28)

<a id="function-function-miniquake2-platform-gamma-create-function-create-src-miniquake2-platform-gamma-ml-44112918"></a>
### create

```ml
function create()
```

GetDeviceGammaRamp may be unavailable under Remote Desktop, HDR compositing or a restrictive driver. Keep that a supported fallback state rather than a product-start failure, matching the original renderer's software table path.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/platform/gamma.ml#L56)

- [miniquake2.platform.gamma.GammaState](Type-miniquake2-platform-gamma-gammastate-2072148937.md) — struct
<a id="function-function-miniquake2-platform-gamma-restore-function-restore-state-src-miniquake2-platform-gamma-ml-1646150401"></a>
### restore

```ml
function restore(state)
```

Restore state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/platform/gamma.ml#L86)

<a id="function-function-miniquake2-platform-gamma-update-function-update-state-gamma-active-src-miniquake2-platform-gamma-ml-1169643706"></a>
### update

```ml
function update(state, gamma, active)
```

Update state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `gamma` | `dynamic` | — | gamma value consumed by this operation. |
| `active` | `dynamic` | — | active value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/platform/gamma.ml#L100)
