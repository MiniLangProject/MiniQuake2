# `src/miniquake2/protocol/player_delta.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 protocol player delta facilities for this project.

Package: [`miniquake2.protocol.player_delta`](Package-miniquake2-protocol-player-delta-164423643.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/protocol/checked.ml` as `pchecked` → [src/miniquake2/protocol/checked.ml](File-src-miniquake2-protocol-checked-ml-1828862158.md)
- `miniquake2/protocol/constants.ml` as `pc` → [src/miniquake2/protocol/constants.ml](File-src-miniquake2-protocol-constants-ml-642349806.md)
- `miniquake2/protocol/types.ml` as `pt` → [src/miniquake2/protocol/types.ml](File-src-miniquake2-protocol-types-ml-736261438.md)
- `miniquake2/qcommon/byteio.ml` as `qbio` → [src/miniquake2/qcommon/byteio.ml](File-src-miniquake2-qcommon-byteio-ml-159119335.md)
- `miniquake2/qcommon/message.ml` as `qmsg` → [src/miniquake2/qcommon/message.ml](File-src-miniquake2-qcommon-message-ml-1426179364.md)

## Declarations

<a id="function-function-miniquake2-protocol-player-delta-computeflags-function-computeflags-base-target-src-miniquake2-protocol-player-delta-ml-928682506"></a>
### computeFlags

```ml
function computeFlags(base, target)
```

Compute flags.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `base` | `dynamic` | — | base value consumed by this operation. |
| `target` | `dynamic` | — | target value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/player_delta.ml#L52)

<a id="function-function-miniquake2-protocol-player-delta-readbody-function-readbody-buffer-base-src-miniquake2-protocol-player-delta-ml-1334711167"></a>
### readBody

```ml
function readBody(buffer, base)
```

Read body.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `base` | `dynamic` | — | base value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/player_delta.ml#L143)

<a id="function-function-miniquake2-protocol-player-delta-readmessage-function-readmessage-buffer-base-src-miniquake2-protocol-player-delta-ml-230009609"></a>
### readMessage

```ml
function readMessage(buffer, base)
```

Read message.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `base` | `dynamic` | — | base value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/player_delta.ml#L195)

<a id="function-function-miniquake2-protocol-player-delta-validatestate-function-validatestate-state-operation-src-miniquake2-protocol-player-delta-ml-14134618"></a>
### validateState

```ml
function validateState(state, operation)
```

Validates state for the miniquake2 protocol player delta workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `operation` | `dynamic` | — | operation value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/player_delta.ml#L21)

<a id="function-function-miniquake2-protocol-player-delta-vec3changed-function-vec3changed-a-b-src-miniquake2-protocol-player-delta-ml-1864957329"></a>
### vec3Changed

```ml
function vec3Changed(a, b)
```

Return the vec 3 changed value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | a value consumed by this operation. |
| `b` | `dynamic` | — | b value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/player_delta.ml#L38)

<a id="function-function-miniquake2-protocol-player-delta-vec4changed-function-vec4changed-a-b-src-miniquake2-protocol-player-delta-ml-256945907"></a>
### vec4Changed

```ml
function vec4Changed(a, b)
```

Return the vec 4 changed value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | a value consumed by this operation. |
| `b` | `dynamic` | — | b value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/player_delta.ml#L45)

<a id="function-function-miniquake2-protocol-player-delta-writebody-function-writebody-buffer-base-target-src-miniquake2-protocol-player-delta-ml-446625946"></a>
### writeBody

```ml
function writeBody(buffer, base, target)
```

Write body.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `base` | `dynamic` | — | base value consumed by this operation. |
| `target` | `dynamic` | — | target value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/player_delta.ml#L77)

<a id="function-function-miniquake2-protocol-player-delta-writemessage-function-writemessage-buffer-base-target-src-miniquake2-protocol-player-delta-ml-943424568"></a>
### writeMessage

```ml
function writeMessage(buffer, base, target)
```

Write message.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `base` | `dynamic` | — | base value consumed by this operation. |
| `target` | `dynamic` | — | target value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/player_delta.ml#L135)
