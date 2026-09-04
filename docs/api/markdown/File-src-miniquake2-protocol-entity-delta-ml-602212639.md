# `src/miniquake2/protocol/entity_delta.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 protocol entity delta facilities for this project.

Package: [`miniquake2.protocol.entity_delta`](Package-miniquake2-protocol-entity-delta-81718985.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/protocol/checked.ml` as `pchecked` → [src/miniquake2/protocol/checked.ml](File-src-miniquake2-protocol-checked-ml-1828862158.md)
- `miniquake2/protocol/constants.ml` as `pc` → [src/miniquake2/protocol/constants.ml](File-src-miniquake2-protocol-constants-ml-642349806.md)
- `miniquake2/protocol/types.ml` as `pt` → [src/miniquake2/protocol/types.ml](File-src-miniquake2-protocol-types-ml-736261438.md)
- `miniquake2/qcommon/message.ml` as `qmsg` → [src/miniquake2/qcommon/message.ml](File-src-miniquake2-qcommon-message-ml-1426179364.md)

## Declarations

<a id="function-function-miniquake2-protocol-entity-delta-addcontinuationbits-function-addcontinuationbits-bits-src-miniquake2-protocol-entity-delta-ml-2145998770"></a>
### addContinuationBits

```ml
function addContinuationBits(bits)
```

Add continuation bits.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `bits` | `dynamic` | — | bits value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/entity_delta.ml#L99)

<a id="function-function-miniquake2-protocol-entity-delta-computebits-function-computebits-base-target-newentity-src-miniquake2-protocol-entity-delta-ml-1825655781"></a>
### computeBits

```ml
function computeBits(base, target, newEntity)
```

Derive the exact Protocol-34 U_* mask before any bytes are emitted. Width extension flags are added by writeHeader, so callers can also use this mask to decide whether an unchanged entity may be omitted.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `base` | `dynamic` | — | base value consumed by this operation. |
| `target` | `dynamic` | — | target value consumed by this operation. |
| `newEntity` | `dynamic` | — | newEntity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/entity_delta.ml#L33)

<a id="function-function-miniquake2-protocol-entity-delta-msg-writedeltaentity-function-msg-writedeltaentity-base-target-buffer-force-newentity-src-miniquake2-protocol-entity-delta-ml-1098058940"></a>
### MSG_WriteDeltaEntity

```ml
function MSG_WriteDeltaEntity(base, target, buffer, force, newEntity)
```

Write msg delta entity.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `base` | `dynamic` | — | base value consumed by this operation. |
| `target` | `dynamic` | — | target value consumed by this operation. |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `force` | `dynamic` | — | force value consumed by this operation. |
| `newEntity` | `dynamic` | — | newEntity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/entity_delta.ml#L307)

<a id="function-function-miniquake2-protocol-entity-delta-readdelta-function-readdelta-buffer-base-header-src-miniquake2-protocol-entity-delta-ml-596335152"></a>
### readDelta

```ml
function readDelta(buffer, base, header)
```

Reconstruct a complete state from its baseline without retaining references to mutable baseline vectors. Checked reads keep malformed packets atomic.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `base` | `dynamic` | — | base value consumed by this operation. |
| `header` | `dynamic` | — | header value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/entity_delta.ml#L239)

<a id="function-function-miniquake2-protocol-entity-delta-readheader-function-readheader-buffer-src-miniquake2-protocol-entity-delta-ml-1475174672"></a>
### readHeader

```ml
function readHeader(buffer)
```

Read header.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/entity_delta.ml#L209)

<a id="function-function-miniquake2-protocol-entity-delta-validatestate-function-validatestate-state-operation-src-miniquake2-protocol-entity-delta-ml-2093421242"></a>
### validateState

```ml
function validateState(state, operation)
```

Validates state for the miniquake2 protocol entity delta workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `operation` | `dynamic` | — | operation value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/entity_delta.ml#L20)

<a id="function-function-miniquake2-protocol-entity-delta-writedelta-function-writedelta-buffer-base-target-force-newentity-src-miniquake2-protocol-entity-delta-ml-309576980"></a>
### writeDelta

```ml
function writeDelta(buffer, base, target, force, newEntity)
```

Emit fields in the original MSG_WriteDeltaEntity order; several flags share bytes, making this ordering part of the wire and demo compatibility contract.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `base` | `dynamic` | — | base value consumed by this operation. |
| `target` | `dynamic` | — | target value consumed by this operation. |
| `force` | `dynamic` | — | force value consumed by this operation. |
| `newEntity` | `dynamic` | — | newEntity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/entity_delta.ml#L136)

<a id="function-function-miniquake2-protocol-entity-delta-writeendmarker-function-writeendmarker-buffer-src-miniquake2-protocol-entity-delta-ml-505279744"></a>
### writeEndMarker

```ml
function writeEndMarker(buffer)
```

Write end marker.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/entity_delta.ml#L202)

<a id="function-function-miniquake2-protocol-entity-delta-writeheader-function-writeheader-buffer-number-rawbits-src-miniquake2-protocol-entity-delta-ml-1634298081"></a>
### writeHeader

```ml
function writeHeader(buffer, number, rawBits)
```

Write header.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `number` | `dynamic` | — | number value consumed by this operation. |
| `rawBits` | `dynamic` | — | rawBits value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/entity_delta.ml#L112)

<a id="function-function-miniquake2-protocol-entity-delta-writeremoval-function-writeremoval-buffer-number-src-miniquake2-protocol-entity-delta-ml-365174635"></a>
### writeRemoval

```ml
function writeRemoval(buffer, number)
```

Write removal.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `number` | `dynamic` | — | number value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/entity_delta.ml#L193)
