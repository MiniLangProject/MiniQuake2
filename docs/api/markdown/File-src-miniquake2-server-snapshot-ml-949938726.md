# `src/miniquake2/server/snapshot.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 server snapshot facilities for this project.

Package: [`miniquake2.server.snapshot`](Package-miniquake2-server-snapshot-549359802.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/protocol/checked.ml` as `pchecked` → [src/miniquake2/protocol/checked.ml](File-src-miniquake2-protocol-checked-ml-1828862158.md)
- `miniquake2/protocol/entity_delta.ml` as `pedelta` → [src/miniquake2/protocol/entity_delta.ml](File-src-miniquake2-protocol-entity-delta-ml-602212639.md)
- `miniquake2/protocol/player_delta.ml` as `ppdelta` → [src/miniquake2/protocol/player_delta.ml](File-src-miniquake2-protocol-player-delta-ml-1460497029.md)
- `miniquake2/protocol/types.ml` as `pt` → [src/miniquake2/protocol/types.ml](File-src-miniquake2-protocol-types-ml-736261438.md)
- `miniquake2/qcommon/constants.ml` as `qc` → [src/miniquake2/qcommon/constants.ml](File-src-miniquake2-qcommon-constants-ml-1976195726.md)
- `miniquake2/qcommon/message.ml` as `qmsg` → [src/miniquake2/qcommon/message.ml](File-src-miniquake2-qcommon-message-ml-1426179364.md)
- `miniquake2/qcommon/sizebuf.ml` as `qsz` → [src/miniquake2/qcommon/sizebuf.ml](File-src-miniquake2-qcommon-sizebuf-ml-1769950759.md)

## Declarations

<a id="function-function-miniquake2-server-snapshot-addframe-function-addframe-history-number-areabits-playerstate-entities-src-miniquake2-server-snapshot-ml-926869425"></a>
### addFrame

```ml
function addFrame(history, number, areaBits, playerState, entities)
```

Add frame.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `history` | `dynamic` | — | history value consumed by this operation. |
| `number` | `dynamic` | — | number value consumed by this operation. |
| `areaBits` | `dynamic` | — | areaBits value consumed by this operation. |
| `playerState` | `dynamic` | — | playerState value consumed by this operation. |
| `entities` | `dynamic` | — | entities value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/snapshot.ml#L106)

<a id="function-function-miniquake2-server-snapshot-applypacketentities-function-applypacketentities-buffer-previousentities-baselines-src-miniquake2-server-snapshot-ml-1403421116"></a>
### applyPacketEntities

```ml
function applyPacketEntities(buffer, previousEntities, baselines)
```

Apply packet entities.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `previousEntities` | `dynamic` | — | previousEntities value consumed by this operation. |
| `baselines` | `dynamic` | — | baselines value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/snapshot.ml#L203)

<a id="function-function-miniquake2-server-snapshot-choosedeltaframe-function-choosedeltaframe-history-current-requestednumber-src-miniquake2-server-snapshot-ml-173521060"></a>
### chooseDeltaFrame

```ml
function chooseDeltaFrame(history, current, requestedNumber)
```

Choose delta frame.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `history` | `dynamic` | — | history value consumed by this operation. |
| `current` | `dynamic` | — | current value consumed by this operation. |
| `requestedNumber` | `dynamic` | — | requestedNumber value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/snapshot.ml#L132)

<a id="function-function-miniquake2-server-snapshot-copyentities-function-copyentities-entities-src-miniquake2-server-snapshot-ml-819123355"></a>
### copyEntities

```ml
function copyEntities(entities)
```

Copy entities data.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entities` | `dynamic` | — | entities value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/snapshot.ml#L49)

<a id="function-function-miniquake2-server-snapshot-createhistory-function-createhistory-maxclients-src-miniquake2-server-snapshot-ml-1465094064"></a>
### createHistory

```ml
function createHistory(maxClients)
```

Create history.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `maxClients` | `dynamic` | — | maxClients value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/snapshot.ml#L79)

<a id="function-function-miniquake2-server-snapshot-emitpacketentities-function-emitpacketentities-buffer-previousentities-currententities-baselines-maxclients-src-miniquake2-server-snapshot-ml-921929562"></a>
### emitPacketEntities

```ml
function emitPacketEntities(buffer, previousEntities, currentEntities, baselines, maxClients)
```

Emit packet entities.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `previousEntities` | `dynamic` | — | previousEntities value consumed by this operation. |
| `currentEntities` | `dynamic` | — | currentEntities value consumed by this operation. |
| `baselines` | `dynamic` | — | baselines value consumed by this operation. |
| `maxClients` | `dynamic` | — | maxClients value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/snapshot.ml#L144)

<a id="function-function-miniquake2-server-snapshot-findframe-function-findframe-history-number-src-miniquake2-server-snapshot-ml-1988267945"></a>
### findFrame

```ml
function findFrame(history, number)
```

Find frame.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `history` | `dynamic` | — | history value consumed by this operation. |
| `number` | `dynamic` | — | number value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/snapshot.ml#L121)

<a id="function-function-miniquake2-server-snapshot-readframe-function-readframe-buffer-oldframe-baselines-src-miniquake2-server-snapshot-ml-1415276944"></a>
### readFrame

```ml
function readFrame(buffer, oldFrame, baselines)
```

Reads frame for the miniquake2 server snapshot workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `oldFrame` | `dynamic` | — | oldFrame value consumed by this operation. |
| `baselines` | `dynamic` | — | baselines value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/snapshot.ml#L257)

<a id="function-function-miniquake2-server-snapshot-setbaseline-function-setbaseline-history-state-src-miniquake2-server-snapshot-ml-1341889071"></a>
### setBaseline

```ml
function setBaseline(history, state)
```

Set baseline.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `history` | `dynamic` | — | history value consumed by this operation. |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/snapshot.ml#L95)

- [miniquake2.server.snapshot.SnapshotFrame](Type-miniquake2-server-snapshot-snapshotframe-844517701.md) — struct
- [miniquake2.server.snapshot.SnapshotHistory](Type-miniquake2-server-snapshot-snapshothistory-1546208416.md) — struct
<a id="function-function-miniquake2-server-snapshot-validateentities-function-validateentities-entities-operation-src-miniquake2-server-snapshot-ml-1862902570"></a>
### validateEntities

```ml
function validateEntities(entities, operation)
```

Validate entities.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entities` | `dynamic` | — | entities value consumed by this operation. |
| `operation` | `dynamic` | — | operation value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/snapshot.ml#L62)

<a id="function-function-miniquake2-server-snapshot-writeframe-function-writeframe-history-current-requesteddeltanumber-suppresscount-buffer-src-miniquake2-server-snapshot-ml-1388341248"></a>
### writeFrame

```ml
function writeFrame(history, current, requestedDeltaNumber, suppressCount, buffer)
```

Write frame.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `history` | `dynamic` | — | history value consumed by this operation. |
| `current` | `dynamic` | — | current value consumed by this operation. |
| `requestedDeltaNumber` | `dynamic` | — | requestedDeltaNumber value consumed by this operation. |
| `suppressCount` | `dynamic` | — | Number of suppress to process. |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/snapshot.ml#L176)
