# `src/miniquake2/qcommon/sizebuf.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 qcommon sizebuf facilities for this project.

Package: [`miniquake2.qcommon.sizebuf`](Package-miniquake2-qcommon-sizebuf-927183511.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/qcommon/byteio.ml` as `bio` → [src/miniquake2/qcommon/byteio.ml](File-src-miniquake2-qcommon-byteio-ml-159119335.md)
- `miniquake2/qcommon/types.ml` as `qt` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)

## Declarations

<a id="function-function-miniquake2-qcommon-sizebuf-alloc-function-alloc-maxsize-src-miniquake2-qcommon-sizebuf-ml-194502557"></a>
### alloc

```ml
function alloc(maxSize)
```

Return the alloc value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `maxSize` | `dynamic` | — | maxSize value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/sizebuf.ml#L28)

<a id="function-function-miniquake2-qcommon-sizebuf-allocoverflowing-function-allocoverflowing-maxsize-src-miniquake2-qcommon-sizebuf-ml-673518083"></a>
### allocOverflowing

```ml
function allocOverflowing(maxSize)
```

Return the alloc overflowing value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `maxSize` | `dynamic` | — | maxSize value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/sizebuf.ml#L35)

<a id="function-function-miniquake2-qcommon-sizebuf-clear-function-clear-buffer-src-miniquake2-qcommon-sizebuf-ml-738986804"></a>
### clear

```ml
function clear(buffer)
```

Clear state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/sizebuf.ml#L43)

<a id="function-function-miniquake2-qcommon-sizebuf-dataslice-function-dataslice-buffer-src-miniquake2-qcommon-sizebuf-ml-240712634"></a>
### dataSlice

```ml
function dataSlice(buffer)
```

Slice data.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/sizebuf.ml#L128)

<a id="function-function-miniquake2-qcommon-sizebuf-getspace-function-getspace-buffer-count-src-miniquake2-qcommon-sizebuf-ml-168585469"></a>
### getSpace

```ml
function getSpace(buffer, count)
```

Return space.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `count` | `dynamic` | — | Number of items or units to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/sizebuf.ml#L52)

<a id="function-function-miniquake2-qcommon-sizebuf-init-function-init-data-length-src-miniquake2-qcommon-sizebuf-ml-1126350096"></a>
### init

```ml
function init(data, length)
```

Performs the init operation for the miniquake2 qcommon sizebuf module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `length` | `dynamic` | — | length value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/sizebuf.ml#L18)

<a id="function-function-miniquake2-qcommon-sizebuf-printbytes-function-printbytes-buffer-source-src-miniquake2-qcommon-sizebuf-ml-512946817"></a>
### printBytes

```ml
function printBytes(buffer, source)
```

Print bytes.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `source` | `dynamic` | — | source value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/sizebuf.ml#L89)

<a id="function-function-miniquake2-qcommon-sizebuf-printtext-function-printtext-buffer-text-src-miniquake2-qcommon-sizebuf-ml-274872535"></a>
### printText

```ml
function printText(buffer, text)
```

Print text.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `text` | `dynamic` | — | Text consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/sizebuf.ml#L121)

<a id="function-function-miniquake2-qcommon-sizebuf-sz-clear-function-sz-clear-buffer-src-miniquake2-qcommon-sizebuf-ml-537626454"></a>
### SZ_Clear

```ml
function SZ_Clear(buffer)
```

Clear sz.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/sizebuf.ml#L141)

<a id="function-function-miniquake2-qcommon-sizebuf-sz-getspace-function-sz-getspace-buffer-count-src-miniquake2-qcommon-sizebuf-ml-265177709"></a>
### SZ_GetSpace

```ml
function SZ_GetSpace(buffer, count)
```

Return sz space.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `count` | `dynamic` | — | Number of items or units to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/sizebuf.ml#L148)

<a id="function-function-miniquake2-qcommon-sizebuf-sz-init-function-sz-init-data-length-src-miniquake2-qcommon-sizebuf-ml-540521120"></a>
### SZ_Init

```ml
function SZ_Init(data, length)
```

Initialize sz.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `length` | `dynamic` | — | length value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/sizebuf.ml#L135)

<a id="function-function-miniquake2-qcommon-sizebuf-sz-print-function-sz-print-buffer-text-src-miniquake2-qcommon-sizebuf-ml-1128289823"></a>
### SZ_Print

```ml
function SZ_Print(buffer, text)
```

Print sz.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `text` | `dynamic` | — | Text consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/sizebuf.ml#L164)

<a id="function-function-miniquake2-qcommon-sizebuf-sz-write-function-sz-write-buffer-source-sourceoffset-count-src-miniquake2-qcommon-sizebuf-ml-794533446"></a>
### SZ_Write

```ml
function SZ_Write(buffer, source, sourceOffset, count)
```

Write sz.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `source` | `dynamic` | — | source value consumed by this operation. |
| `sourceOffset` | `dynamic` | — | sourceOffset value consumed by this operation. |
| `count` | `dynamic` | — | Number of items or units to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/sizebuf.ml#L157)

<a id="function-function-miniquake2-qcommon-sizebuf-write-function-write-buffer-source-sourceoffset-count-src-miniquake2-qcommon-sizebuf-ml-887112044"></a>
### write

```ml
function write(buffer, source, sourceOffset, count)
```

Write state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `source` | `dynamic` | — | source value consumed by this operation. |
| `sourceOffset` | `dynamic` | — | sourceOffset value consumed by this operation. |
| `count` | `dynamic` | — | Number of items or units to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/sizebuf.ml#L71)

<a id="function-function-miniquake2-qcommon-sizebuf-writebytes-function-writebytes-buffer-source-src-miniquake2-qcommon-sizebuf-ml-823937577"></a>
### writeBytes

```ml
function writeBytes(buffer, source)
```

Write bytes.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `source` | `dynamic` | — | source value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/sizebuf.ml#L81)
