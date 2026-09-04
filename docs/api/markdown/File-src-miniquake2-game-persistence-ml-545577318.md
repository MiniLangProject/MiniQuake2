# `src/miniquake2/game/persistence.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 game persistence facilities for this project.

Package: [`miniquake2.game.persistence`](Package-miniquake2-game-persistence-965157636.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/game/types.ml` as `gt` → [src/miniquake2/game/types.ml](File-src-miniquake2-game-types-ml-1384205920.md)
- `miniquake2/protocol/checked.ml` as `pchecked` → [src/miniquake2/protocol/checked.ml](File-src-miniquake2-protocol-checked-ml-1828862158.md)
- `miniquake2/qcommon/message.ml` as `qmsg` → [src/miniquake2/qcommon/message.ml](File-src-miniquake2-qcommon-message-ml-1426179364.md)
- `miniquake2/qcommon/sizebuf.ml` as `qsz` → [src/miniquake2/qcommon/sizebuf.ml](File-src-miniquake2-qcommon-sizebuf-ml-1769950759.md)
- `std/fs.ml` as `savefs` → `../MiniLangCompilerML/std/fs.ml` — external dependency

## Declarations

<a id="function-function-miniquake2-game-persistence-decode-function-decode-data-maxedicts-src-miniquake2-game-persistence-ml-1763356546"></a>
### decode

```ml
function decode(data, maxEdicts)
```

Decode state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `maxEdicts` | `dynamic` | — | maxEdicts value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/persistence.ml#L334)

<a id="function-function-miniquake2-game-persistence-decodesaveimage-function-decodesaveimage-data-maxedicts-src-miniquake2-game-persistence-ml-1098521502"></a>
### decodeSaveImage

```ml
function decodeSaveImage(data, maxEdicts)
```

Decode save image.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `maxEdicts` | `dynamic` | — | maxEdicts value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/persistence.ml#L257)

<a id="function-function-miniquake2-game-persistence-encode-function-encode-exporttable-kind-mapname-framenumber-src-miniquake2-game-persistence-ml-7517511"></a>
### encode

```ml
function encode(exportTable, kind, mapName, frameNumber)
```

Encodes encode for the miniquake2 game persistence workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `exportTable` | `dynamic` | — | exportTable value consumed by this operation. |
| `kind` | `dynamic` | — | kind value consumed by this operation. |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `frameNumber` | `dynamic` | — | frameNumber value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/persistence.ml#L240)

<a id="function-function-miniquake2-game-persistence-encodesaveimagewithprivate-function-encodesaveimagewithprivate-exporttable-kind-mapname-framenumber-privatedata-src-miniquake2-game-persistence-ml-1673794230"></a>
### encodeSaveImageWithPrivate

```ml
function encodeSaveImageWithPrivate(exportTable, kind, mapName, frameNumber, privateData)
```

Encode save image with private.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `exportTable` | `dynamic` | — | exportTable value consumed by this operation. |
| `kind` | `dynamic` | — | kind value consumed by this operation. |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `frameNumber` | `dynamic` | — | frameNumber value consumed by this operation. |
| `privateData` | `dynamic` | — | privateData value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/persistence.ml#L199)

<a id="function-function-miniquake2-game-persistence-encodewithprivate-function-encodewithprivate-exporttable-kind-mapname-framenumber-privatedata-src-miniquake2-game-persistence-ml-873830644"></a>
### encodeWithPrivate

```ml
function encodeWithPrivate(exportTable, kind, mapName, frameNumber, privateData)
```

Encode with private.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `exportTable` | `dynamic` | — | exportTable value consumed by this operation. |
| `kind` | `dynamic` | — | kind value consumed by this operation. |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `frameNumber` | `dynamic` | — | frameNumber value consumed by this operation. |
| `privateData` | `dynamic` | — | privateData value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/persistence.ml#L250)

<a id="function-function-miniquake2-game-persistence-readentitystate-function-readentitystate-buffer-expectednumber-src-miniquake2-game-persistence-ml-1601467967"></a>
### readEntityState

```ml
function readEntityState(buffer, expectedNumber)
```

Read entity state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `expectedNumber` | `dynamic` | — | expectedNumber value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/persistence.ml#L175)

<a id="function-function-miniquake2-game-persistence-readfile-function-readfile-filename-maxedicts-src-miniquake2-game-persistence-ml-246996897"></a>
### readFile

```ml
function readFile(filename, maxEdicts)
```

Read file.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `filename` | `dynamic` | — | filename value consumed by this operation. |
| `maxEdicts` | `dynamic` | — | maxEdicts value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/persistence.ml#L364)

<a id="function-function-miniquake2-game-persistence-readfloat-function-readfloat-buffer-operation-src-miniquake2-game-persistence-ml-513171071"></a>
### readFloat

```ml
function readFloat(buffer, operation)
```

Read float.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `operation` | `dynamic` | — | operation value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/persistence.ml#L69)

<a id="function-function-miniquake2-game-persistence-readplayerstate-function-readplayerstate-buffer-src-miniquake2-game-persistence-ml-192035518"></a>
### readPlayerState

```ml
function readPlayerState(buffer)
```

Read player state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/persistence.ml#L139)

<a id="function-function-miniquake2-game-persistence-readpmovestate-function-readpmovestate-buffer-src-miniquake2-game-persistence-ml-574559758"></a>
### readPmoveState

```ml
function readPmoveState(buffer)
```

Read pmove state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/persistence.ml#L100)

<a id="function-function-miniquake2-game-persistence-readvec3-function-readvec3-buffer-operation-src-miniquake2-game-persistence-ml-1124267687"></a>
### readVec3

```ml
function readVec3(buffer, operation)
```

Read vec 3.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `operation` | `dynamic` | — | operation value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/persistence.ml#L77)

<a id="constant-constant-miniquake2-game-persistence-save-magic-const-save-magic-mq2save1-src-miniquake2-game-persistence-ml-1098080585"></a>
### SAVE_MAGIC

```ml
const SAVE_MAGIC = "MQ2SAVE1"
```

Defines the save magic constant used by the miniquake2 game persistence module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/persistence.ml#L21)

<a id="constant-constant-miniquake2-game-persistence-save-version-const-save-version-2-src-miniquake2-game-persistence-ml-588219633"></a>
### SAVE_VERSION

```ml
const SAVE_VERSION = 2
```

Defines the save version constant used by the miniquake2 game persistence module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/persistence.ml#L23)

<a id="function-function-miniquake2-game-persistence-saveformat-function-saveformat-data-src-miniquake2-game-persistence-ml-92952912"></a>
### saveFormat

```ml
function saveFormat(data)
```

Save format.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/persistence.ml#L27)

- [miniquake2.game.persistence.SaveImage](Type-miniquake2-game-persistence-saveimage-1789727552.md) — struct
<a id="function-function-miniquake2-game-persistence-writeentitystate-function-writeentitystate-buffer-state-src-miniquake2-game-persistence-ml-896383611"></a>
### writeEntityState

```ml
function writeEntityState(buffer, state)
```

Write entity state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/persistence.ml#L162)

<a id="function-function-miniquake2-game-persistence-writefile-function-writefile-exporttable-kind-mapname-framenumber-filename-src-miniquake2-game-persistence-ml-1737852808"></a>
### writeFile

```ml
function writeFile(exportTable, kind, mapName, frameNumber, filename)
```

Write file.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `exportTable` | `dynamic` | — | exportTable value consumed by this operation. |
| `kind` | `dynamic` | — | kind value consumed by this operation. |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `frameNumber` | `dynamic` | — | frameNumber value consumed by this operation. |
| `filename` | `dynamic` | — | filename value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/persistence.ml#L344)

<a id="function-function-miniquake2-game-persistence-writefilewithprivate-function-writefilewithprivate-exporttable-kind-mapname-framenumber-privatedata-filename-src-miniquake2-game-persistence-ml-1339982323"></a>
### writeFileWithPrivate

```ml
function writeFileWithPrivate(exportTable, kind, mapName, frameNumber, privateData, filename)
```

Write file with private.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `exportTable` | `dynamic` | — | exportTable value consumed by this operation. |
| `kind` | `dynamic` | — | kind value consumed by this operation. |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `frameNumber` | `dynamic` | — | frameNumber value consumed by this operation. |
| `privateData` | `dynamic` | — | privateData value consumed by this operation. |
| `filename` | `dynamic` | — | filename value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/persistence.ml#L356)

<a id="function-function-miniquake2-game-persistence-writeplayerstate-function-writeplayerstate-buffer-state-src-miniquake2-game-persistence-ml-925651195"></a>
### writePlayerState

```ml
function writePlayerState(buffer, state)
```

Write player state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/persistence.ml#L119)

<a id="function-function-miniquake2-game-persistence-writepmovestate-function-writepmovestate-buffer-state-src-miniquake2-game-persistence-ml-1799765049"></a>
### writePmoveState

```ml
function writePmoveState(buffer, state)
```

Write pmove state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/persistence.ml#L84)

<a id="function-function-miniquake2-game-persistence-writevec3-function-writevec3-buffer-value-src-miniquake2-game-persistence-ml-846288527"></a>
### writeVec3

```ml
function writeVec3(buffer, value)
```

Write vec 3.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/persistence.ml#L60)
