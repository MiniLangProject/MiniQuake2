# `src/miniquake2/protocol/types.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 protocol types facilities for this project.

Package: [`miniquake2.protocol.types`](Package-miniquake2-protocol-types-1945547172.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/qcommon/types.ml` as `qt` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)

## Declarations

<a id="function-function-miniquake2-protocol-types-copyentitystate-function-copyentitystate-state-src-miniquake2-protocol-types-ml-1648898519"></a>
### copyEntityState

```ml
function copyEntityState(state)
```

Copy entity state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/types.ml#L199)

<a id="function-function-miniquake2-protocol-types-copynumbers-function-copynumbers-values-expected-operation-src-miniquake2-protocol-types-ml-1012790317"></a>
### copyNumbers

```ml
function copyNumbers(values, expected, operation)
```

Copy numbers data.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `values` | `dynamic` | — | values value consumed by this operation. |
| `expected` | `dynamic` | — | expected value consumed by this operation. |
| `operation` | `dynamic` | — | operation value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/types.ml#L175)

<a id="function-function-miniquake2-protocol-types-copyplayerstate-function-copyplayerstate-state-src-miniquake2-protocol-types-ml-1765191907"></a>
### copyPlayerState

```ml
function copyPlayerState(state)
```

Copy player state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/types.ml#L247)

<a id="function-function-miniquake2-protocol-types-copypmovestate-function-copypmovestate-state-src-miniquake2-protocol-types-ml-1047425013"></a>
### copyPmoveState

```ml
function copyPmoveState(state)
```

Copy pmove state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/types.ml#L221)

<a id="function-function-miniquake2-protocol-types-copyusercmd-function-copyusercmd-command-src-miniquake2-protocol-types-ml-1307102197"></a>
### copyUserCmd

```ml
function copyUserCmd(command)
```

Copy user cmd.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `command` | `dynamic` | — | command value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/types.ml#L263)

- [miniquake2.protocol.types.EntityDeltaHeader](Type-miniquake2-protocol-types-entitydeltaheader-132253196.md) — struct
- [miniquake2.protocol.types.EntityState](Type-miniquake2-protocol-types-entitystate-1471558878.md) — struct
- [miniquake2.protocol.types.NetChannel](Type-miniquake2-protocol-types-netchannel-169912328.md) — struct
- [miniquake2.protocol.types.Packet](Type-miniquake2-protocol-types-packet-1912626774.md) — struct
- [miniquake2.protocol.types.PacketHeader](Type-miniquake2-protocol-types-packetheader-1660804759.md) — struct
- [miniquake2.protocol.types.PlayerState](Type-miniquake2-protocol-types-playerstate-2083543656.md) — struct
- [miniquake2.protocol.types.ProcessedPacket](Type-miniquake2-protocol-types-processedpacket-131893898.md) — struct
<a id="function-function-miniquake2-protocol-types-zeroentitystate-function-zeroentitystate-src-miniquake2-protocol-types-ml-993255184"></a>
### zeroEntityState

```ml
function zeroEntityState()
```

Return the zero entity state.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/types.ml#L189)

<a id="function-function-miniquake2-protocol-types-zeroplayerstate-function-zeroplayerstate-src-miniquake2-protocol-types-ml-1918497956"></a>
### zeroPlayerState

```ml
function zeroPlayerState()
```

Return the zero player state.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/types.ml#L231)

<a id="function-function-miniquake2-protocol-types-zeropmovestate-function-zeropmovestate-src-miniquake2-protocol-types-ml-1777724668"></a>
### zeroPmoveState

```ml
function zeroPmoveState()
```

Return the zero pmove state.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/types.ml#L211)
