# `src/miniquake2/protocol/packet.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 protocol packet facilities for this project.

Package: [`miniquake2.protocol.packet`](Package-miniquake2-protocol-packet-298243827.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/protocol/constants.ml` as `pc` → [src/miniquake2/protocol/constants.ml](File-src-miniquake2-protocol-constants-ml-642349806.md)
- `miniquake2/protocol/types.ml` as `pt` → [src/miniquake2/protocol/types.ml](File-src-miniquake2-protocol-types-ml-736261438.md)
- `miniquake2/qcommon/byteio.ml` as `qbio` → [src/miniquake2/qcommon/byteio.ml](File-src-miniquake2-qcommon-byteio-ml-159119335.md)

## Declarations

<a id="function-function-miniquake2-protocol-packet-decodeconnectionless-function-decodeconnectionless-data-src-miniquake2-protocol-packet-ml-1354398130"></a>
### decodeConnectionless

```ml
function decodeConnectionless(data)
```

Decode connectionless.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/packet.ml#L116)

<a id="function-function-miniquake2-protocol-packet-decodeconnectionlesstext-function-decodeconnectionlesstext-data-src-miniquake2-protocol-packet-ml-445778546"></a>
### decodeConnectionlessText

```ml
function decodeConnectionlessText(data)
```

Decode connectionless text.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/packet.ml#L125)

<a id="function-function-miniquake2-protocol-packet-decodeheader-function-decodeheader-data-hasqport-src-miniquake2-protocol-packet-ml-662209782"></a>
### decodeHeader

```ml
function decodeHeader(data, hasQport)
```

Decode header.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `hasQport` | `dynamic` | — | hasQport value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/packet.ml#L48)

<a id="function-function-miniquake2-protocol-packet-decodepacket-function-decodepacket-data-hasqport-src-miniquake2-protocol-packet-ml-430007158"></a>
### decodePacket

```ml
function decodePacket(data, hasQport)
```

Decode packet.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `hasQport` | `dynamic` | — | hasQport value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/packet.ml#L70)

<a id="function-function-miniquake2-protocol-packet-encodeconnectionless-function-encodeconnectionless-payload-src-miniquake2-protocol-packet-ml-30281786"></a>
### encodeConnectionless

```ml
function encodeConnectionless(payload)
```

Encode connectionless.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `payload` | `dynamic` | — | payload value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/packet.ml#L98)

<a id="function-function-miniquake2-protocol-packet-encodeconnectionlesstext-function-encodeconnectionlesstext-text-src-miniquake2-protocol-packet-ml-798071071"></a>
### encodeConnectionlessText

```ml
function encodeConnectionlessText(text)
```

Encode connectionless text.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `text` | `dynamic` | — | Text consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/packet.ml#L109)

<a id="function-function-miniquake2-protocol-packet-encodeheader-function-encodeheader-header-includeqport-src-miniquake2-protocol-packet-ml-149351129"></a>
### encodeHeader

```ml
function encodeHeader(header, includeQport)
```

Encode header.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `header` | `dynamic` | — | header value consumed by this operation. |
| `includeQport` | `dynamic` | — | includeQport value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/packet.ml#L25)

<a id="function-function-miniquake2-protocol-packet-isconnectionless-function-isconnectionless-data-src-miniquake2-protocol-packet-ml-1257197030"></a>
### isConnectionless

```ml
function isConnectionless(data)
```

Report whether is connectionless.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/packet.ml#L92)

<a id="function-function-miniquake2-protocol-packet-join-function-join-headerbytes-first-second-src-miniquake2-protocol-packet-ml-1735732576"></a>
### join

```ml
function join(headerBytes, first, second)
```

Join state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `headerBytes` | `dynamic` | — | headerBytes value consumed by this operation. |
| `first` | `dynamic` | — | first value consumed by this operation. |
| `second` | `dynamic` | — | second value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/packet.ml#L79)

<a id="function-function-miniquake2-protocol-packet-validsequence-function-validsequence-value-src-miniquake2-protocol-packet-ml-819978721"></a>
### validSequence

```ml
function validSequence(value)
```

Report whether valid sequence.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/packet.ml#L18)
