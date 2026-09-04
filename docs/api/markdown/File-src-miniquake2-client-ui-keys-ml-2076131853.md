# `src/miniquake2/client/ui/keys.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 client ui keys facilities for this project.

Package: [`miniquake2.client.ui.keys`](Package-miniquake2-client-ui-keys-1847298162.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/client/ui/constants.ml` as `cuic` → [src/miniquake2/client/ui/constants.ml](File-src-miniquake2-client-ui-constants-ml-1004124106.md)
- `miniquake2/client/ui/types.ml` as `cuitypes` → [src/miniquake2/client/ui/types.ml](File-src-miniquake2-client-ui-types-ml-24306002.md)
- `miniquake2/platform/window.ml` as `pwindow` → [src/miniquake2/platform/window.ml](File-src-miniquake2-platform-window-ml-103958158.md)

## Declarations

<a id="function-function-miniquake2-client-ui-keys-actionnames-function-actionnames-src-miniquake2-client-ui-keys-ml-1517703613"></a>
### actionNames

```ml
function actionNames()
```

Return the action names value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/keys.ml#L15)

<a id="function-function-miniquake2-client-ui-keys-beginbindingcapture-function-beginbindingcapture-state-command-src-miniquake2-client-ui-keys-ml-1758306623"></a>
### beginBindingCapture

```ml
function beginBindingCapture(state, command)
```

Begin binding capture.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `command` | `dynamic` | — | command value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/keys.ml#L140)

<a id="function-function-miniquake2-client-ui-keys-bind-function-bind-state-key-command-src-miniquake2-client-ui-keys-ml-1774635912"></a>
### bind

```ml
function bind(state, key, command)
```

Bind state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `key` | `dynamic` | — | key value consumed by this operation. |
| `command` | `dynamic` | — | command value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/keys.ml#L91)

<a id="function-function-miniquake2-client-ui-keys-binddefaultgame-function-binddefaultgame-state-src-miniquake2-client-ui-keys-ml-406619564"></a>
### bindDefaultGame

```ml
function bindDefaultGame(state)
```

Product defaults retain the classic Quake II weapon keys and add the mouse wheel convention expected by modern players.  Keeping these in the input package makes the real product bindings independently regression-testable.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/keys.ml#L42)

<a id="function-function-miniquake2-client-ui-keys-bindingfor-function-bindingfor-state-key-src-miniquake2-client-ui-keys-ml-309638093"></a>
### bindingFor

```ml
function bindingFor(state, key)
```

Return the binding for the requested input.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `key` | `dynamic` | — | key value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/keys.ml#L116)

<a id="function-function-miniquake2-client-ui-keys-cancelbindingcapture-function-cancelbindingcapture-state-src-miniquake2-client-ui-keys-ml-2123141240"></a>
### cancelBindingCapture

```ml
function cancelBindingCapture(state)
```

Cancel binding capture.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/keys.ml#L151)

<a id="function-function-miniquake2-client-ui-keys-capturebindingevent-function-capturebindingevent-state-key-src-miniquake2-client-ui-keys-ml-2101029475"></a>
### captureBindingEvent

```ml
function captureBindingEvent(state, key)
```

Capture binding event.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `key` | `dynamic` | — | key value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/keys.ml#L174)

<a id="function-function-miniquake2-client-ui-keys-commandaction-function-commandaction-command-src-miniquake2-client-ui-keys-ml-2005661398"></a>
### commandAction

```ml
function commandAction(command)
```

Return the command action value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `command` | `dynamic` | — | command value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/keys.ml#L233)

<a id="function-function-miniquake2-client-ui-keys-createinputstate-function-createinputstate-src-miniquake2-client-ui-keys-ml-1739892181"></a>
### createInputState

```ml
function createInputState()
```

Create input state.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/keys.ml#L28)

<a id="function-function-miniquake2-client-ui-keys-defaultconfig-function-defaultconfig-src-miniquake2-client-ui-keys-ml-734309199"></a>
### defaultConfig

```ml
function defaultConfig()
```

Return the default config value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/keys.ml#L22)

<a id="function-function-miniquake2-client-ui-keys-draincommands-inline-function-draincommands-state-src-miniquake2-client-ui-keys-ml-903500127"></a>
### drainCommands

```ml
inline function drainCommands(state)
```

Performs the drainCommands operation for the miniquake2 client ui keys module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/keys.ml#L368)

<a id="function-function-miniquake2-client-ui-keys-eventkey-function-eventkey-event-src-miniquake2-client-ui-keys-ml-1670020373"></a>
### eventKey

```ml
function eventKey(event)
```

Return the event key value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `event` | `dynamic` | — | event value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/keys.ml#L277)

<a id="function-function-miniquake2-client-ui-keys-findaction-function-findaction-state-name-src-miniquake2-client-ui-keys-ml-166839983"></a>
### findAction

```ml
function findAction(state, name)
```

Find action.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/keys.ml#L196)

<a id="function-function-miniquake2-client-ui-keys-findbinding-function-findbinding-state-key-src-miniquake2-client-ui-keys-ml-2064131717"></a>
### findBinding

```ml
function findBinding(state, key)
```

Find binding.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `key` | `dynamic` | — | key value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/keys.ml#L80)

<a id="function-function-miniquake2-client-ui-keys-handleevent-function-handleevent-state-event-time-src-miniquake2-client-ui-keys-ml-586852623"></a>
### handleEvent

```ml
function handleEvent(state, event, time)
```

Handle event.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `event` | `dynamic` | — | event value consumed by this operation. |
| `time` | `dynamic` | — | time value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/keys.ml#L338)

<a id="function-function-miniquake2-client-ui-keys-keyname-function-keyname-key-src-miniquake2-client-ui-keys-ml-454302134"></a>
### keyName

```ml
function keyName(key)
```

Return the compact key label used by the controls and inventory overlays.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `key` | `dynamic` | — | key value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/keys.ml#L124)

<a id="function-function-miniquake2-client-ui-keys-queuebinding-function-queuebinding-state-key-down-time-src-miniquake2-client-ui-keys-ml-1603372292"></a>
### queueBinding

```ml
function queueBinding(state, key, down, time)
```

Queue binding.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `key` | `dynamic` | — | key value consumed by this operation. |
| `down` | `dynamic` | — | down value consumed by this operation. |
| `time` | `dynamic` | — | time value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/keys.ml#L320)

<a id="function-function-miniquake2-client-ui-keys-queuediscretecommand-inline-function-queuediscretecommand-state-command-src-miniquake2-client-ui-keys-ml-1322233610"></a>
### queueDiscreteCommand

```ml
inline function queueDiscreteCommand(state, command)
```

Queue discrete command.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `command` | `dynamic` | — | command value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/keys.ml#L296)

<a id="function-function-miniquake2-client-ui-keys-scankey-function-scankey-scan-src-miniquake2-client-ui-keys-ml-1204836412"></a>
### scanKey

```ml
function scanKey(scan)
```

Scan key.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `scan` | `dynamic` | — | scan value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/keys.ml#L241)

<a id="function-function-miniquake2-client-ui-keys-setaction-function-setaction-state-name-down-src-miniquake2-client-ui-keys-ml-1923412835"></a>
### setAction

```ml
function setAction(state, name, down)
```

Set action.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `name` | `dynamic` | — | Name of the affected item. |
| `down` | `dynamic` | — | down value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/keys.ml#L207)

<a id="function-function-miniquake2-client-ui-keys-setactionattime-function-setactionattime-state-name-down-time-src-miniquake2-client-ui-keys-ml-1553343794"></a>
### setActionAtTime

```ml
function setActionAtTime(state, name, down, time)
```

Set action at an input timestamp for Quake II's time-weighted KeyState.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `name` | `dynamic` | — | Name of the affected item. |
| `down` | `dynamic` | — | down value consumed by this operation. |
| `time` | `dynamic` | — | time value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/keys.ml#L218)

<a id="function-function-miniquake2-client-ui-keys-setdestination-function-setdestination-state-destination-src-miniquake2-client-ui-keys-ml-1392142814"></a>
### setDestination

```ml
function setDestination(state, destination)
```

Set destination.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `destination` | `dynamic` | — | destination value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/keys.ml#L71)

<a id="function-function-miniquake2-client-ui-keys-unbind-function-unbind-state-key-src-miniquake2-client-ui-keys-ml-162946341"></a>
### unbind

```ml
function unbind(state, key)
```

Unbind state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `key` | `dynamic` | — | key value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/keys.ml#L104)

<a id="function-function-miniquake2-client-ui-keys-unbindcommand-function-unbindcommand-state-command-src-miniquake2-client-ui-keys-ml-260474397"></a>
### unbindCommand

```ml
function unbindCommand(state, command)
```

Unbind command.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `command` | `dynamic` | — | command value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/keys.ml#L160)
