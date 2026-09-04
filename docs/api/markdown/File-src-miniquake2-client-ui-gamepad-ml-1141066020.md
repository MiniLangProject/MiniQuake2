# `src/miniquake2/client/ui/gamepad.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 client ui gamepad facilities for this project.

Package: [`miniquake2.client.ui.gamepad`](Package-miniquake2-client-ui-gamepad-1604399705.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/native.ml` as `gamepadnative` → [src/miniquake2/native.ml](File-src-miniquake2-native-ml-139597585.md)

## Declarations

<a id="function-function-miniquake2-client-ui-gamepad-create-function-create-enabled-src-miniquake2-client-ui-gamepad-ml-1198625916"></a>
### create

```ml
function create(enabled)
```

Creates create for the miniquake2 client ui gamepad module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `enabled` | `dynamic` | — | enabled value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/gamepad.ml#L58)

- [miniquake2.client.ui.gamepad.GamepadSample](Type-miniquake2-client-ui-gamepad-gamepadsample-709370.md) — struct
- [miniquake2.client.ui.gamepad.GamepadState](Type-miniquake2-client-ui-gamepad-gamepadstate-1960497789.md) — struct
<a id="function-function-miniquake2-client-ui-gamepad-normalizeaxis-inline-function-normalizeaxis-raw-deadzone-src-miniquake2-client-ui-gamepad-ml-1851665862"></a>
### normalizeAxis

```ml
inline function normalizeAxis(raw, deadZone)
```

Normalize axis.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `raw` | `dynamic` | — | raw value consumed by this operation. |
| `deadZone` | `dynamic` | — | deadZone value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/gamepad.ml#L77)

<a id="function-function-miniquake2-client-ui-gamepad-poll-function-poll-state-src-miniquake2-client-ui-gamepad-ml-1528470952"></a>
### poll

```ml
function poll(state)
```

Performs the poll operation for the miniquake2 client ui gamepad module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/gamepad.ml#L120)

<a id="function-function-miniquake2-client-ui-gamepad-sampleraw-function-sampleraw-state-axes-buttons-pov-src-miniquake2-client-ui-gamepad-ml-1526802457"></a>
### sampleRaw

```ml
function sampleRaw(state, axes, buttons, pov)
```

Sample raw.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `axes` | `dynamic` | — | axes value consumed by this operation. |
| `buttons` | `dynamic` | — | buttons value consumed by this operation. |
| `pov` | `dynamic` | — | pov value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/gamepad.ml#L94)
