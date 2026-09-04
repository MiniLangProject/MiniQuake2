# `src/miniquake2/protocol/checked.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 protocol checked facilities for this project.

Package: [`miniquake2.protocol.checked`](Package-miniquake2-protocol-checked-1524660384.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/qcommon/message.ml` as `qmsg` → [src/miniquake2/qcommon/message.ml](File-src-miniquake2-qcommon-message-ml-1426179364.md)

## Declarations

<a id="function-function-miniquake2-protocol-checked-readangle-function-readangle-buffer-operation-src-miniquake2-protocol-checked-ml-498775317"></a>
### readAngle

```ml
function readAngle(buffer, operation)
```

Read angle.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `operation` | `dynamic` | — | operation value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/checked.ml#L89)

<a id="function-function-miniquake2-protocol-checked-readangle16-function-readangle16-buffer-operation-src-miniquake2-protocol-checked-ml-492494835"></a>
### readAngle16

```ml
function readAngle16(buffer, operation)
```

Read angle 16.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `operation` | `dynamic` | — | operation value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/checked.ml#L96)

<a id="function-function-miniquake2-protocol-checked-readbyte-function-readbyte-buffer-operation-src-miniquake2-protocol-checked-ml-220422219"></a>
### readByte

```ml
function readByte(buffer, operation)
```

Read byte.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `operation` | `dynamic` | — | operation value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/checked.ml#L36)

<a id="function-function-miniquake2-protocol-checked-readbytes-function-readbytes-buffer-count-operation-src-miniquake2-protocol-checked-ml-332481696"></a>
### readBytes

```ml
function readBytes(buffer, count, operation)
```

Read bytes.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `count` | `dynamic` | — | Number of items or units to process. |
| `operation` | `dynamic` | — | operation value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/checked.ml#L104)

<a id="function-function-miniquake2-protocol-checked-readchar-function-readchar-buffer-operation-src-miniquake2-protocol-checked-ml-1024680083"></a>
### readChar

```ml
function readChar(buffer, operation)
```

Read char.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `operation` | `dynamic` | — | operation value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/checked.ml#L44)

<a id="function-function-miniquake2-protocol-checked-readcoord-function-readcoord-buffer-operation-src-miniquake2-protocol-checked-ml-649118753"></a>
### readCoord

```ml
function readCoord(buffer, operation)
```

Read coord.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `operation` | `dynamic` | — | operation value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/checked.ml#L82)

<a id="function-function-miniquake2-protocol-checked-readlong-function-readlong-buffer-operation-src-miniquake2-protocol-checked-ml-1120072483"></a>
### readLong

```ml
function readLong(buffer, operation)
```

Read long.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `operation` | `dynamic` | — | operation value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/checked.ml#L67)

<a id="function-function-miniquake2-protocol-checked-readshort-function-readshort-buffer-operation-src-miniquake2-protocol-checked-ml-1261292739"></a>
### readShort

```ml
function readShort(buffer, operation)
```

Read short.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `operation` | `dynamic` | — | operation value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/checked.ml#L52)

<a id="function-function-miniquake2-protocol-checked-readulong-function-readulong-buffer-operation-src-miniquake2-protocol-checked-ml-1302055517"></a>
### readULong

```ml
function readULong(buffer, operation)
```

Read u long.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `operation` | `dynamic` | — | operation value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/checked.ml#L75)

<a id="function-function-miniquake2-protocol-checked-readushort-function-readushort-buffer-operation-src-miniquake2-protocol-checked-ml-714142447"></a>
### readUShort

```ml
function readUShort(buffer, operation)
```

Read u short.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `operation` | `dynamic` | — | operation value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/checked.ml#L60)

<a id="function-function-miniquake2-protocol-checked-require-function-require-buffer-count-operation-src-miniquake2-protocol-checked-ml-400511944"></a>
### require

```ml
function require(buffer, count, operation)
```

Require state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `count` | `dynamic` | — | Number of items or units to process. |
| `operation` | `dynamic` | — | operation value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/checked.ml#L19)
