# `src/miniquake2/network/runtime/messages.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 network runtime messages facilities for this project.

Package: [`miniquake2.network.runtime.messages`](Package-miniquake2-network-runtime-messages-410539409.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/network/client.ml` as `nclient` → [src/miniquake2/network/client.ml](File-src-miniquake2-network-client-ml-1115555876.md)
- `miniquake2/network/constants.ml` as `nc` → [src/miniquake2/network/constants.ml](File-src-miniquake2-network-constants-ml-102415622.md)
- `miniquake2/network/runtime/types.ml` as `nrtypes` → [src/miniquake2/network/runtime/types.ml](File-src-miniquake2-network-runtime-types-ml-1235773127.md)
- `miniquake2/protocol/checked.ml` as `pchecked` → [src/miniquake2/protocol/checked.ml](File-src-miniquake2-protocol-checked-ml-1828862158.md)
- `miniquake2/protocol/constants.ml` as `pc` → [src/miniquake2/protocol/constants.ml](File-src-miniquake2-protocol-constants-ml-642349806.md)
- `miniquake2/protocol/entity_delta.ml` as `pentity` → [src/miniquake2/protocol/entity_delta.ml](File-src-miniquake2-protocol-entity-delta-ml-602212639.md)
- `miniquake2/protocol/types.ml` as `pt` → [src/miniquake2/protocol/types.ml](File-src-miniquake2-protocol-types-ml-736261438.md)
- `miniquake2/qcommon/byteio.ml` as `qbio` → [src/miniquake2/qcommon/byteio.ml](File-src-miniquake2-qcommon-byteio-ml-159119335.md)
- `miniquake2/qcommon/constants.ml` as `qc` → [src/miniquake2/qcommon/constants.ml](File-src-miniquake2-qcommon-constants-ml-1976195726.md)
- `miniquake2/qcommon/message.ml` as `qmsg` → [src/miniquake2/qcommon/message.ml](File-src-miniquake2-qcommon-message-ml-1426179364.md)
- `miniquake2/qcommon/sizebuf.ml` as `qsz` → [src/miniquake2/qcommon/sizebuf.ml](File-src-miniquake2-qcommon-sizebuf-ml-1769950759.md)

## Declarations

<a id="function-function-miniquake2-network-runtime-messages-appendbytes-function-appendbytes-first-second-src-miniquake2-network-runtime-messages-ml-1205789943"></a>
### appendBytes

```ml
function appendBytes(first, second)
```

Append bytes.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `dynamic` | — | first value consumed by this operation. |
| `second` | `dynamic` | — | second value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/messages.ml#L53)

<a id="function-function-miniquake2-network-runtime-messages-parsepayload-function-parsepayload-runtime-payload-src-miniquake2-network-runtime-messages-ml-1723471107"></a>
### parsePayload

```ml
function parsePayload(runtime, payload)
```

Parse payload.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `payload` | `dynamic` | — | payload value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/messages.ml#L179)

<a id="function-function-miniquake2-network-runtime-messages-parseserverdata-function-parseserverdata-runtime-buffer-src-miniquake2-network-runtime-messages-ml-755075093"></a>
### parseServerData

```ml
function parseServerData(runtime, buffer)
```

Parse server data.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/messages.ml#L172)

<a id="function-function-miniquake2-network-runtime-messages-parseserverdataversion-function-parseserverdataversion-runtime-buffer-allowlegacydemo-src-miniquake2-network-runtime-messages-ml-465793510"></a>
### parseServerDataVersion

```ml
function parseServerDataVersion(runtime, buffer, allowLegacyDemo)
```

Parse server data version.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `allowLegacyDemo` | `dynamic` | — | allowLegacyDemo value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/messages.ml#L138)

<a id="function-function-miniquake2-network-runtime-messages-readingbuffer-function-readingbuffer-data-src-miniquake2-network-runtime-messages-ml-1945431121"></a>
### readingBuffer

```ml
function readingBuffer(data)
```

Return the reading buffer value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/messages.ml#L24)

<a id="function-function-miniquake2-network-runtime-messages-readstring-function-readstring-buffer-operation-maximum-src-miniquake2-network-runtime-messages-ml-452856526"></a>
### readString

```ml
function readString(buffer, operation, maximum)
```

Read string.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `operation` | `dynamic` | — | operation value consumed by this operation. |
| `maximum` | `dynamic` | — | maximum value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/messages.ml#L36)

<a id="function-function-miniquake2-network-runtime-messages-writeconfigstring-function-writeconfigstring-buffer-index-value-src-miniquake2-network-runtime-messages-ml-1627354750"></a>
### writeConfigString

```ml
function writeConfigString(buffer, index, value)
```

Write config string.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `index` | `dynamic` | — | Zero-based index of the affected item. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/messages.ml#L89)

<a id="function-function-miniquake2-network-runtime-messages-writedownload-function-writedownload-buffer-data-offset-count-percent-src-miniquake2-network-runtime-messages-ml-1883736010"></a>
### writeDownload

```ml
function writeDownload(buffer, data, offset, count, percent)
```

Write download.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `offset` | `dynamic` | — | Zero-based offset at which processing starts. |
| `count` | `dynamic` | — | Number of items or units to process. |
| `percent` | `dynamic` | — | percent value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/messages.ml#L124)

<a id="function-function-miniquake2-network-runtime-messages-writeserverdata-function-writeserverdata-buffer-spawncount-attractloop-gamedir-playernumber-levelname-src-miniquake2-network-runtime-messages-ml-1899537142"></a>
### writeServerData

```ml
function writeServerData(buffer, spawnCount, attractLoop, gameDir, playerNumber, levelName)
```

Write server data.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `spawnCount` | `dynamic` | — | Number of spawn to process. |
| `attractLoop` | `dynamic` | — | attractLoop value consumed by this operation. |
| `gameDir` | `dynamic` | — | gameDir value consumed by this operation. |
| `playerNumber` | `dynamic` | — | playerNumber value consumed by this operation. |
| `levelName` | `dynamic` | — | levelName value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/messages.ml#L67)

<a id="function-function-miniquake2-network-runtime-messages-writespawnbaseline-function-writespawnbaseline-buffer-state-src-miniquake2-network-runtime-messages-ml-1101540068"></a>
### writeSpawnBaseline

```ml
function writeSpawnBaseline(buffer, state)
```

Write spawn baseline.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/messages.ml#L101)

<a id="function-function-miniquake2-network-runtime-messages-writestufftext-function-writestufftext-buffer-text-src-miniquake2-network-runtime-messages-ml-1929006900"></a>
### writeStuffText

```ml
function writeStuffText(buffer, text)
```

Write stuff text.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `text` | `dynamic` | — | Text consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/messages.ml#L111)
