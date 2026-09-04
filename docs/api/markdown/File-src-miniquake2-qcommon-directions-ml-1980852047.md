# `src/miniquake2/qcommon/directions.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 qcommon directions facilities for this project.

Package: [`miniquake2.qcommon.directions`](Package-miniquake2-qcommon-directions-1775968721.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/qcommon/message.ml` as `qmsg` → [src/miniquake2/qcommon/message.ml](File-src-miniquake2-qcommon-message-ml-1426179364.md)
- `miniquake2/qcommon/types.ml` as `qt` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)

## Declarations

<a id="function-function-miniquake2-qcommon-directions-decodedirection-function-decodedirection-index-src-miniquake2-qcommon-directions-ml-494228648"></a>
### decodeDirection

```ml
function decodeDirection(index)
```

Decode direction.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `index` | `dynamic` | — | Zero-based index of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/directions.ml#L199)

<a id="function-function-miniquake2-qcommon-directions-encodedirection-function-encodedirection-direction-src-miniquake2-qcommon-directions-ml-72826013"></a>
### encodeDirection

```ml
function encodeDirection(direction)
```

Encode direction.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `direction` | `dynamic` | — | direction value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/directions.ml#L181)

<a id="function-function-miniquake2-qcommon-directions-msg-readdir-function-msg-readdir-buffer-src-miniquake2-qcommon-directions-ml-316382000"></a>
### MSG_ReadDir

```ml
function MSG_ReadDir(buffer)
```

Read msg dir.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/directions.ml#L230)

<a id="function-function-miniquake2-qcommon-directions-msg-writedir-function-msg-writedir-buffer-direction-src-miniquake2-qcommon-directions-ml-105569025"></a>
### MSG_WriteDir

```ml
function MSG_WriteDir(buffer, direction)
```

Write msg dir.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `direction` | `dynamic` | — | direction value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/directions.ml#L224)

<a id="global-global-miniquake2-qcommon-directions-normals-normals-src-miniquake2-qcommon-directions-ml-272499898"></a>
### normals

```ml
normals
```

Stores module-wide normals state for the miniquake2 qcommon directions module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/directions.ml#L14)

<a id="function-function-miniquake2-qcommon-directions-readdirection-function-readdirection-buffer-src-miniquake2-qcommon-directions-ml-1500659204"></a>
### readDirection

```ml
function readDirection(buffer)
```

Read direction.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/directions.ml#L215)

<a id="function-function-miniquake2-qcommon-directions-writedirection-function-writedirection-buffer-direction-src-miniquake2-qcommon-directions-ml-1921316273"></a>
### writeDirection

```ml
function writeDirection(buffer, direction)
```

Write direction.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `direction` | `dynamic` | — | direction value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/directions.ml#L208)
