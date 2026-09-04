# `src/miniquake2/qcommon/message.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 qcommon message facilities for this project.

Package: [`miniquake2.qcommon.message`](Package-miniquake2-qcommon-message-1332286846.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/qcommon/byteio.ml` as `bio` → [src/miniquake2/qcommon/byteio.ml](File-src-miniquake2-qcommon-byteio-ml-159119335.md)
- `miniquake2/qcommon/sizebuf.ml` as `sz` → [src/miniquake2/qcommon/sizebuf.ml](File-src-miniquake2-qcommon-sizebuf-ml-1769950759.md)
- `miniquake2/qcommon/types.ml` as `qt` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)

## Declarations

<a id="function-function-miniquake2-qcommon-message-beginreading-function-beginreading-buffer-src-miniquake2-qcommon-message-ml-547539386"></a>
### beginReading

```ml
function beginReading(buffer)
```

Begin reading.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/message.ml#L132)

<a id="function-function-miniquake2-qcommon-message-msg-beginreading-function-msg-beginreading-buffer-src-miniquake2-qcommon-message-ml-649956386"></a>
### MSG_BeginReading

```ml
function MSG_BeginReading(buffer)
```

Begin msg reading.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/message.ml#L342)

<a id="function-function-miniquake2-qcommon-message-msg-readangle-function-msg-readangle-buffer-src-miniquake2-qcommon-message-ml-1728452028"></a>
### MSG_ReadAngle

```ml
function MSG_ReadAngle(buffer)
```

Read msg angle.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/message.ml#L402)

<a id="function-function-miniquake2-qcommon-message-msg-readangle16-function-msg-readangle16-buffer-src-miniquake2-qcommon-message-ml-445593406"></a>
### MSG_ReadAngle16

```ml
function MSG_ReadAngle16(buffer)
```

Read msg angle 16.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/message.ml#L408)

<a id="function-function-miniquake2-qcommon-message-msg-readbyte-function-msg-readbyte-buffer-src-miniquake2-qcommon-message-ml-304844966"></a>
### MSG_ReadByte

```ml
function MSG_ReadByte(buffer)
```

Read msg byte.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/message.ml#L354)

<a id="function-function-miniquake2-qcommon-message-msg-readchar-function-msg-readchar-buffer-src-miniquake2-qcommon-message-ml-1603160702"></a>
### MSG_ReadChar

```ml
function MSG_ReadChar(buffer)
```

Read msg char.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/message.ml#L348)

<a id="function-function-miniquake2-qcommon-message-msg-readcoord-function-msg-readcoord-buffer-src-miniquake2-qcommon-message-ml-922880212"></a>
### MSG_ReadCoord

```ml
function MSG_ReadCoord(buffer)
```

Read msg coord.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/message.ml#L390)

<a id="function-function-miniquake2-qcommon-message-msg-readdata-function-msg-readdata-buffer-count-src-miniquake2-qcommon-message-ml-1324526107"></a>
### MSG_ReadData

```ml
function MSG_ReadData(buffer, count)
```

Read msg data.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `count` | `dynamic` | — | Number of items or units to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/message.ml#L415)

<a id="function-function-miniquake2-qcommon-message-msg-readfloat-function-msg-readfloat-buffer-src-miniquake2-qcommon-message-ml-597051598"></a>
### MSG_ReadFloat

```ml
function MSG_ReadFloat(buffer)
```

Read msg float.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/message.ml#L372)

<a id="function-function-miniquake2-qcommon-message-msg-readlong-function-msg-readlong-buffer-src-miniquake2-qcommon-message-ml-148873814"></a>
### MSG_ReadLong

```ml
function MSG_ReadLong(buffer)
```

Read msg long.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/message.ml#L366)

<a id="function-function-miniquake2-qcommon-message-msg-readpos-function-msg-readpos-buffer-src-miniquake2-qcommon-message-ml-110417718"></a>
### MSG_ReadPos

```ml
function MSG_ReadPos(buffer)
```

Read msg pos.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/message.ml#L396)

<a id="function-function-miniquake2-qcommon-message-msg-readshort-function-msg-readshort-buffer-src-miniquake2-qcommon-message-ml-106493458"></a>
### MSG_ReadShort

```ml
function MSG_ReadShort(buffer)
```

Read msg short.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/message.ml#L360)

<a id="function-function-miniquake2-qcommon-message-msg-readstring-function-msg-readstring-buffer-src-miniquake2-qcommon-message-ml-2091106814"></a>
### MSG_ReadString

```ml
function MSG_ReadString(buffer)
```

Read msg string.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/message.ml#L378)

<a id="function-function-miniquake2-qcommon-message-msg-readstringline-function-msg-readstringline-buffer-src-miniquake2-qcommon-message-ml-1890605006"></a>
### MSG_ReadStringLine

```ml
function MSG_ReadStringLine(buffer)
```

Read msg string line.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/message.ml#L384)

<a id="function-function-miniquake2-qcommon-message-msg-writeangle-function-msg-writeangle-buffer-value-src-miniquake2-qcommon-message-ml-372392073"></a>
### MSG_WriteAngle

```ml
function MSG_WriteAngle(buffer, value)
```

Write msg angle.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/message.ml#L329)

<a id="function-function-miniquake2-qcommon-message-msg-writeangle16-function-msg-writeangle16-buffer-value-src-miniquake2-qcommon-message-ml-2021761209"></a>
### MSG_WriteAngle16

```ml
function MSG_WriteAngle16(buffer, value)
```

Write msg angle 16.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/message.ml#L336)

<a id="function-function-miniquake2-qcommon-message-msg-writebyte-function-msg-writebyte-buffer-value-src-miniquake2-qcommon-message-ml-173897335"></a>
### MSG_WriteByte

```ml
function MSG_WriteByte(buffer, value)
```

Write msg byte.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/message.ml#L280)

<a id="function-function-miniquake2-qcommon-message-msg-writechar-function-msg-writechar-buffer-value-src-miniquake2-qcommon-message-ml-2031543187"></a>
### MSG_WriteChar

```ml
function MSG_WriteChar(buffer, value)
```

Write msg char.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/message.ml#L273)

<a id="function-function-miniquake2-qcommon-message-msg-writecoord-function-msg-writecoord-buffer-value-src-miniquake2-qcommon-message-ml-254277745"></a>
### MSG_WriteCoord

```ml
function MSG_WriteCoord(buffer, value)
```

Write msg coord.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/message.ml#L315)

<a id="function-function-miniquake2-qcommon-message-msg-writefloat-function-msg-writefloat-buffer-value-src-miniquake2-qcommon-message-ml-1684945297"></a>
### MSG_WriteFloat

```ml
function MSG_WriteFloat(buffer, value)
```

Write msg float.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/message.ml#L301)

<a id="function-function-miniquake2-qcommon-message-msg-writelong-function-msg-writelong-buffer-value-src-miniquake2-qcommon-message-ml-1657442679"></a>
### MSG_WriteLong

```ml
function MSG_WriteLong(buffer, value)
```

Write msg long.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/message.ml#L294)

<a id="function-function-miniquake2-qcommon-message-msg-writepos-function-msg-writepos-buffer-position-src-miniquake2-qcommon-message-ml-963107531"></a>
### MSG_WritePos

```ml
function MSG_WritePos(buffer, position)
```

Write msg pos.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `position` | `dynamic` | — | position value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/message.ml#L322)

<a id="function-function-miniquake2-qcommon-message-msg-writeshort-function-msg-writeshort-buffer-value-src-miniquake2-qcommon-message-ml-820867225"></a>
### MSG_WriteShort

```ml
function MSG_WriteShort(buffer, value)
```

Write msg short.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/message.ml#L287)

<a id="function-function-miniquake2-qcommon-message-msg-writestring-function-msg-writestring-buffer-text-src-miniquake2-qcommon-message-ml-204673943"></a>
### MSG_WriteString

```ml
function MSG_WriteString(buffer, text)
```

Write msg string.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `text` | `dynamic` | — | Text consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/message.ml#L308)

<a id="function-function-miniquake2-qcommon-message-readangle-function-readangle-buffer-src-miniquake2-qcommon-message-ml-1390802404"></a>
### readAngle

```ml
function readAngle(buffer)
```

Read angle.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/message.ml#L240)

<a id="function-function-miniquake2-qcommon-message-readangle16-function-readangle16-buffer-src-miniquake2-qcommon-message-ml-1676058382"></a>
### readAngle16

```ml
function readAngle16(buffer)
```

Read angle 16.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/message.ml#L246)

<a id="function-function-miniquake2-qcommon-message-readbyte-function-readbyte-buffer-src-miniquake2-qcommon-message-ml-345478214"></a>
### readByte

```ml
function readByte(buffer)
```

Read byte.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/message.ml#L148)

<a id="function-function-miniquake2-qcommon-message-readchar-function-readchar-buffer-src-miniquake2-qcommon-message-ml-585796350"></a>
### readChar

```ml
function readChar(buffer)
```

Read char.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/message.ml#L139)

<a id="function-function-miniquake2-qcommon-message-readcoord-function-readcoord-buffer-src-miniquake2-qcommon-message-ml-1107310536"></a>
### readCoord

```ml
function readCoord(buffer)
```

Read coord.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/message.ml#L228)

<a id="function-function-miniquake2-qcommon-message-readdata-function-readdata-buffer-count-src-miniquake2-qcommon-message-ml-1008553507"></a>
### readData

```ml
function readData(buffer, count)
```

Read data.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `count` | `dynamic` | — | Number of items or units to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/message.ml#L253)

<a id="function-function-miniquake2-qcommon-message-readfloat-function-readfloat-buffer-src-miniquake2-qcommon-message-ml-1823739342"></a>
### readFloat

```ml
function readFloat(buffer)
```

Read float.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/message.ml#L175)

<a id="function-function-miniquake2-qcommon-message-readlong-function-readlong-buffer-src-miniquake2-qcommon-message-ml-1094773774"></a>
### readLong

```ml
function readLong(buffer)
```

Read long.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/message.ml#L166)

<a id="function-function-miniquake2-qcommon-message-readpos-function-readpos-buffer-src-miniquake2-qcommon-message-ml-1317883606"></a>
### readPos

```ml
function readPos(buffer)
```

Read pos.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/message.ml#L234)

<a id="function-function-miniquake2-qcommon-message-readshort-function-readshort-buffer-src-miniquake2-qcommon-message-ml-1234256078"></a>
### readShort

```ml
function readShort(buffer)
```

Read short.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/message.ml#L157)

<a id="function-function-miniquake2-qcommon-message-readstring-function-readstring-buffer-src-miniquake2-qcommon-message-ml-279275358"></a>
### readString

```ml
function readString(buffer)
```

Read string.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/message.ml#L200)

<a id="function-function-miniquake2-qcommon-message-readstringbytes-function-readstringbytes-buffer-src-miniquake2-qcommon-message-ml-1148714370"></a>
### readStringBytes

```ml
function readStringBytes(buffer)
```

Read string bytes.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/message.ml#L184)

<a id="function-function-miniquake2-qcommon-message-readstringline-function-readstringline-buffer-src-miniquake2-qcommon-message-ml-801891118"></a>
### readStringLine

```ml
function readStringLine(buffer)
```

Read string line.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/message.ml#L222)

<a id="function-function-miniquake2-qcommon-message-readstringlinebytes-function-readstringlinebytes-buffer-src-miniquake2-qcommon-message-ml-968208894"></a>
### readStringLineBytes

```ml
function readStringLineBytes(buffer)
```

Read string line bytes.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/message.ml#L206)

<a id="function-function-miniquake2-qcommon-message-remaining-function-remaining-buffer-src-miniquake2-qcommon-message-ml-1611154462"></a>
### remaining

```ml
function remaining(buffer)
```

Return the remaining value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/message.ml#L266)

<a id="function-function-miniquake2-qcommon-message-requireinteger-function-requireinteger-value-operation-src-miniquake2-qcommon-message-ml-1929509330"></a>
### requireInteger

```ml
function requireInteger(value, operation)
```

Require integer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `operation` | `dynamic` | — | operation value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/message.ml#L19)

<a id="function-function-miniquake2-qcommon-message-writeangle-function-writeangle-buffer-value-src-miniquake2-qcommon-message-ml-28162385"></a>
### writeAngle

```ml
function writeAngle(buffer, value)
```

Write angle.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/message.ml#L117)

<a id="function-function-miniquake2-qcommon-message-writeangle16-function-writeangle16-buffer-value-src-miniquake2-qcommon-message-ml-1017122425"></a>
### writeAngle16

```ml
function writeAngle16(buffer, value)
```

Write angle 16.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/message.ml#L125)

<a id="function-function-miniquake2-qcommon-message-writebyte-function-writebyte-buffer-value-src-miniquake2-qcommon-message-ml-795690555"></a>
### writeByte

```ml
function writeByte(buffer, value)
```

Write byte.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/message.ml#L37)

<a id="function-function-miniquake2-qcommon-message-writechar-function-writechar-buffer-value-src-miniquake2-qcommon-message-ml-1152369975"></a>
### writeChar

```ml
function writeChar(buffer, value)
```

Write char.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/message.ml#L27)

<a id="function-function-miniquake2-qcommon-message-writecoord-function-writecoord-buffer-value-src-miniquake2-qcommon-message-ml-359005013"></a>
### writeCoord

```ml
function writeCoord(buffer, value)
```

Write coord.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/message.ml#L100)

<a id="function-function-miniquake2-qcommon-message-writefloat-function-writefloat-buffer-value-src-miniquake2-qcommon-message-ml-712544745"></a>
### writeFloat

```ml
function writeFloat(buffer, value)
```

Write float.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/message.ml#L67)

<a id="function-function-miniquake2-qcommon-message-writelong-function-writelong-buffer-value-src-miniquake2-qcommon-message-ml-1372060235"></a>
### writeLong

```ml
function writeLong(buffer, value)
```

Write long.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/message.ml#L57)

<a id="function-function-miniquake2-qcommon-message-writepos-function-writepos-buffer-position-src-miniquake2-qcommon-message-ml-1141900939"></a>
### writePos

```ml
function writePos(buffer, position)
```

Write pos.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `position` | `dynamic` | — | position value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/message.ml#L107)

<a id="function-function-miniquake2-qcommon-message-writeshort-function-writeshort-buffer-value-src-miniquake2-qcommon-message-ml-1819374893"></a>
### writeShort

```ml
function writeShort(buffer, value)
```

Write short.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/message.ml#L47)

<a id="function-function-miniquake2-qcommon-message-writestring-function-writestring-buffer-text-src-miniquake2-qcommon-message-ml-1133143139"></a>
### writeString

```ml
function writeString(buffer, text)
```

Write string.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `text` | `dynamic` | — | Text consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/message.ml#L92)

<a id="function-function-miniquake2-qcommon-message-writestringbytes-function-writestringbytes-buffer-source-src-miniquake2-qcommon-message-ml-1320101553"></a>
### writeStringBytes

```ml
function writeStringBytes(buffer, source)
```

Write string bytes.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `source` | `dynamic` | — | source value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/message.ml#L77)
