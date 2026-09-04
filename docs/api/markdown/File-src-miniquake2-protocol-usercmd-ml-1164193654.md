# `src/miniquake2/protocol/usercmd.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 protocol usercmd facilities for this project.

Package: [`miniquake2.protocol.usercmd`](Package-miniquake2-protocol-usercmd-2216676.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/protocol/checked.ml` as `pchecked` → [src/miniquake2/protocol/checked.ml](File-src-miniquake2-protocol-checked-ml-1828862158.md)
- `miniquake2/protocol/constants.ml` as `pc` → [src/miniquake2/protocol/constants.ml](File-src-miniquake2-protocol-constants-ml-642349806.md)
- `miniquake2/protocol/types.ml` as `pt` → [src/miniquake2/protocol/types.ml](File-src-miniquake2-protocol-types-ml-736261438.md)
- `miniquake2/qcommon/message.ml` as `qmsg` → [src/miniquake2/qcommon/message.ml](File-src-miniquake2-qcommon-message-ml-1426179364.md)

## Declarations

<a id="function-function-miniquake2-protocol-usercmd-msg-readdeltausercmd-function-msg-readdeltausercmd-buffer-base-src-miniquake2-protocol-usercmd-ml-175780107"></a>
### MSG_ReadDeltaUsercmd

```ml
function MSG_ReadDeltaUsercmd(buffer, base)
```

Read msg delta usercmd.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `base` | `dynamic` | — | base value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/usercmd.ml#L77)

<a id="function-function-miniquake2-protocol-usercmd-msg-writedeltausercmd-function-msg-writedeltausercmd-buffer-base-command-src-miniquake2-protocol-usercmd-ml-1020221572"></a>
### MSG_WriteDeltaUsercmd

```ml
function MSG_WriteDeltaUsercmd(buffer, base, command)
```

Write msg delta usercmd.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `base` | `dynamic` | — | base value consumed by this operation. |
| `command` | `dynamic` | — | command value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/usercmd.ml#L70)

<a id="function-function-miniquake2-protocol-usercmd-readdelta-function-readdelta-buffer-base-src-miniquake2-protocol-usercmd-ml-883648899"></a>
### readDelta

```ml
function readDelta(buffer, base)
```

Read delta.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `base` | `dynamic` | — | base value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/usercmd.ml#L50)

<a id="function-function-miniquake2-protocol-usercmd-writedelta-function-writedelta-buffer-base-command-src-miniquake2-protocol-usercmd-ml-815636196"></a>
### writeDelta

```ml
function writeDelta(buffer, base, command)
```

Write delta.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `base` | `dynamic` | — | base value consumed by this operation. |
| `command` | `dynamic` | — | command value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/usercmd.ml#L21)
