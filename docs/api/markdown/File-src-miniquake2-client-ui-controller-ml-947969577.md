# `src/miniquake2/client/ui/controller.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 client ui controller facilities for this project.

Package: [`miniquake2.client.ui.controller`](Package-miniquake2-client-ui-controller-2138455374.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/client/ui/console.ml` as `cuiconsole` → [src/miniquake2/client/ui/console.ml](File-src-miniquake2-client-ui-console-ml-367794066.md)
- `miniquake2/client/ui/constants.ml` as `cuic` → [src/miniquake2/client/ui/constants.ml](File-src-miniquake2-client-ui-constants-ml-1004124106.md)
- `miniquake2/client/ui/gamepad.ml` as `cuigamepad` → [src/miniquake2/client/ui/gamepad.ml](File-src-miniquake2-client-ui-gamepad-ml-1141066020.md)
- `miniquake2/client/ui/input.ml` as `cuiinput` → [src/miniquake2/client/ui/input.ml](File-src-miniquake2-client-ui-input-ml-1778495101.md)
- `miniquake2/client/ui/keys.ml` as `cuikeys` → [src/miniquake2/client/ui/keys.ml](File-src-miniquake2-client-ui-keys-ml-2076131853.md)
- `miniquake2/client/ui/menu.ml` as `cuimenu` → [src/miniquake2/client/ui/menu.ml](File-src-miniquake2-client-ui-menu-ml-1156054796.md)
- `miniquake2/native.ml` as `native` → [src/miniquake2/native.ml](File-src-miniquake2-native-ml-139597585.md)
- `miniquake2/platform/window.ml` as `pwindow` → [src/miniquake2/platform/window.ml](File-src-miniquake2-platform-window-ml-103958158.md)

## Declarations

<a id="function-function-miniquake2-client-ui-controller-beginmessage-function-beginmessage-input-team-src-miniquake2-client-ui-controller-ml-257814196"></a>
### beginMessage

```ml
function beginMessage(input, team)
```

Begin message.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `input` | `dynamic` | — | input value consumed by this operation. |
| `team` | `dynamic` | — | team value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/controller.ml#L99)

<a id="function-function-miniquake2-client-ui-controller-configuregamepad-function-configuregamepad-enabled-src-miniquake2-client-ui-controller-ml-1528084680"></a>
### configureGamepad

```ml
function configureGamepad(enabled)
```

Configure gamepad.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `enabled` | `dynamic` | — | enabled value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/controller.ml#L24)

<a id="global-global-miniquake2-client-ui-controller-controllergamepadstate-controllergamepadstate-src-miniquake2-client-ui-controller-ml-1464136253"></a>
### controllerGamepadState

```ml
controllerGamepadState
```

Stores module-wide controller gamepad state state for the miniquake2 client ui controller module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/controller.ml#L20)

<a id="function-function-miniquake2-client-ui-controller-editmessage-function-editmessage-input-key-src-miniquake2-client-ui-controller-ml-1125559540"></a>
### editMessage

```ml
function editMessage(input, key)
```

Return the edit message value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `input` | `dynamic` | — | input value consumed by this operation. |
| `key` | `dynamic` | — | key value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/controller.ml#L122)

<a id="function-function-miniquake2-client-ui-controller-finishmessage-function-finishmessage-input-src-miniquake2-client-ui-controller-ml-1700576929"></a>
### finishMessage

```ml
function finishMessage(input)
```

Finish message.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `input` | `dynamic` | — | input value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/controller.ml#L108)

<a id="function-function-miniquake2-client-ui-controller-gamepadkeyevent-function-gamepadkeyevent-key-src-miniquake2-client-ui-controller-ml-617802934"></a>
### gamepadKeyEvent

```ml
function gamepadKeyEvent(key)
```

Return the gamepad key event value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `key` | `dynamic` | — | key value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/controller.ml#L43)

<a id="function-function-miniquake2-client-ui-controller-gamepadstate-function-gamepadstate-src-miniquake2-client-ui-controller-ml-99124113"></a>
### gamepadState

```ml
function gamepadState()
```

Return the gamepad state.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/controller.ml#L35)

<a id="function-function-miniquake2-client-ui-controller-handleevent-function-handleevent-input-screen-event-time-src-miniquake2-client-ui-controller-ml-403199624"></a>
### handleEvent

```ml
function handleEvent(input, screen, event, time)
```

Handle event.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `input` | `dynamic` | — | input value consumed by this operation. |
| `screen` | `dynamic` | — | screen value consumed by this operation. |
| `event` | `dynamic` | — | event value consumed by this operation. |
| `time` | `dynamic` | — | time value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/controller.ml#L148)

<a id="function-function-miniquake2-client-ui-controller-openmenu-function-openmenu-input-screen-src-miniquake2-client-ui-controller-ml-1900296213"></a>
### openMenu

```ml
function openMenu(input, screen)
```

Open menu.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `input` | `dynamic` | — | input value consumed by this operation. |
| `screen` | `dynamic` | — | screen value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/controller.ml#L137)

<a id="function-function-miniquake2-client-ui-controller-poll-function-poll-input-screen-time-src-miniquake2-client-ui-controller-ml-1632417712"></a>
### poll

```ml
function poll(input, screen, time)
```

Performs the poll operation for the miniquake2 client ui controller module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `input` | `dynamic` | — | input value consumed by this operation. |
| `screen` | `dynamic` | — | screen value consumed by this operation. |
| `time` | `dynamic` | — | time value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/controller.ml#L194)

<a id="function-function-miniquake2-client-ui-controller-pollgamepad-function-pollgamepad-input-screen-time-src-miniquake2-client-ui-controller-ml-1667440520"></a>
### pollGamepad

```ml
function pollGamepad(input, screen, time)
```

Poll gamepad.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `input` | `dynamic` | — | input value consumed by this operation. |
| `screen` | `dynamic` | — | screen value consumed by this operation. |
| `time` | `dynamic` | — | time value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/controller.ml#L51)
