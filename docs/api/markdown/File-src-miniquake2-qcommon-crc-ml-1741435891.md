# `src/miniquake2/qcommon/crc.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 qcommon crc facilities for this project.

Package: [`miniquake2.qcommon.crc`](Package-miniquake2-qcommon-crc-121789667.md)

Reachable from entry: **yes**

## Declarations

<a id="function-function-miniquake2-qcommon-crc-block-function-block-data-offset-count-src-miniquake2-qcommon-crc-ml-1757668454"></a>
### block

```ml
function block(data, offset, count)
```

Return the block value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `offset` | `dynamic` | — | Zero-based offset at which processing starts. |
| `count` | `dynamic` | — | Number of items or units to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/crc.ml#L82)

<a id="function-function-miniquake2-qcommon-crc-crc-block-function-crc-block-data-offset-count-src-miniquake2-qcommon-crc-ml-948585068"></a>
### CRC_Block

```ml
function CRC_Block(data, offset, count)
```

Return the crc block value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `offset` | `dynamic` | — | Zero-based offset at which processing starts. |
| `count` | `dynamic` | — | Number of items or units to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/crc.ml#L56)

<a id="function-function-miniquake2-qcommon-crc-crc-init-inline-function-crc-init-src-miniquake2-qcommon-crc-ml-1772930921"></a>
### CRC_Init

```ml
inline function CRC_Init()
```

Initialize crc.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/crc.ml#L20)

<a id="constant-constant-miniquake2-qcommon-crc-crc-init-value-const-crc-init-value-65535-src-miniquake2-qcommon-crc-ml-1987823805"></a>
### CRC_INIT_VALUE

```ml
const CRC_INIT_VALUE = 65535
```

Defines the crc init value constant used by the miniquake2 qcommon crc module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/crc.ml#L13)

<a id="constant-constant-miniquake2-qcommon-crc-crc-polynomial-const-crc-polynomial-4129-src-miniquake2-qcommon-crc-ml-622738181"></a>
### CRC_POLYNOMIAL

```ml
const CRC_POLYNOMIAL = 4129
```

Defines the crc polynomial constant used by the miniquake2 qcommon crc module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/crc.ml#L17)

<a id="function-function-miniquake2-qcommon-crc-crc-processbyte-function-crc-processbyte-crcvalue-data-src-miniquake2-qcommon-crc-ml-1950265877"></a>
### CRC_ProcessByte

```ml
function CRC_ProcessByte(crcValue, data)
```

crc.c uses a table; this bitwise transition is the same non-reflected CRC-CCITT operation and keeps the unsigned-short truncation explicit.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `crcValue` | `dynamic` | — | crcValue value consumed by this operation. |
| `data` | `dynamic` | — | Input data consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/crc.ml#L28)

<a id="function-function-miniquake2-qcommon-crc-crc-value-inline-function-crc-value-crcvalue-src-miniquake2-qcommon-crc-ml-641235656"></a>
### CRC_Value

```ml
inline function CRC_Value(crcValue)
```

Return the crc value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `crcValue` | `dynamic` | — | crcValue value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/crc.ml#L47)

<a id="constant-constant-miniquake2-qcommon-crc-crc-xor-value-const-crc-xor-value-0-src-miniquake2-qcommon-crc-ml-705861597"></a>
### CRC_XOR_VALUE

```ml
const CRC_XOR_VALUE = 0
```

Defines the crc xor value constant used by the miniquake2 qcommon crc module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/crc.ml#L15)

<a id="function-function-miniquake2-qcommon-crc-processbyte-function-processbyte-crcvalue-data-src-miniquake2-qcommon-crc-ml-1904149343"></a>
### processByte

```ml
function processByte(crcValue, data)
```

Process byte.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `crcValue` | `dynamic` | — | crcValue value consumed by this operation. |
| `data` | `dynamic` | — | Input data consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/crc.ml#L74)
