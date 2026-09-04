# `src/miniquake2/network/snapshot.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 network snapshot facilities for this project.

Package: [`miniquake2.network.snapshot`](Package-miniquake2-network-snapshot-992379251.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/network/constants.ml` as `nc` → [src/miniquake2/network/constants.ml](File-src-miniquake2-network-constants-ml-102415622.md)
- `miniquake2/network/types.ml` as `nt` → [src/miniquake2/network/types.ml](File-src-miniquake2-network-types-ml-621495446.md)
- `miniquake2/protocol/checked.ml` as `pchecked` → [src/miniquake2/protocol/checked.ml](File-src-miniquake2-protocol-checked-ml-1828862158.md)
- `miniquake2/protocol/entity_delta.ml` as `pentity` → [src/miniquake2/protocol/entity_delta.ml](File-src-miniquake2-protocol-entity-delta-ml-602212639.md)
- `miniquake2/protocol/player_delta.ml` as `pplayer` → [src/miniquake2/protocol/player_delta.ml](File-src-miniquake2-protocol-player-delta-ml-1460497029.md)
- `miniquake2/protocol/types.ml` as `pt` → [src/miniquake2/protocol/types.ml](File-src-miniquake2-protocol-types-ml-736261438.md)
- `miniquake2/qcommon/message.ml` as `qmsg` → [src/miniquake2/qcommon/message.ml](File-src-miniquake2-qcommon-message-ml-1426179364.md)
- `miniquake2/qcommon/sizebuf.ml` as `qsz` → [src/miniquake2/qcommon/sizebuf.ml](File-src-miniquake2-qcommon-sizebuf-ml-1769950759.md)
- `std/array.ml` as `nsnapshotarray` → `../MiniLangCompilerML/std/array.ml` — external dependency

## Declarations

<a id="function-function-miniquake2-network-snapshot-baselinefor-function-baselinefor-baselines-number-src-miniquake2-network-snapshot-ml-654729307"></a>
### baselineFor

```ml
function baselineFor(baselines, number)
```

Return the baseline for the requested input.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baselines` | `dynamic` | — | baselines value consumed by this operation. |
| `number` | `dynamic` | — | number value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/snapshot.ml#L38)

<a id="function-function-miniquake2-network-snapshot-choosedelta-function-choosedelta-serverframe-lastframe-history-src-miniquake2-network-snapshot-ml-1285222531"></a>
### chooseDelta

```ml
function chooseDelta(serverFrame, lastFrame, history)
```

Choose delta.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `serverFrame` | `dynamic` | — | serverFrame value consumed by this operation. |
| `lastFrame` | `dynamic` | — | lastFrame value consumed by this operation. |
| `history` | `dynamic` | — | history value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/snapshot.ml#L172)

<a id="function-function-miniquake2-network-snapshot-createframe-function-createframe-serverframe-areabits-playerstate-entities-src-miniquake2-network-snapshot-ml-681933344"></a>
### createFrame

```ml
function createFrame(serverFrame, areaBits, playerState, entities)
```

Create frame.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `serverFrame` | `dynamic` | — | serverFrame value consumed by this operation. |
| `areaBits` | `dynamic` | — | areaBits value consumed by this operation. |
| `playerState` | `dynamic` | — | playerState value consumed by this operation. |
| `entities` | `dynamic` | — | entities value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/snapshot.ml#L160)

<a id="function-function-miniquake2-network-snapshot-inheritentity-function-inheritentity-buffer-base-src-miniquake2-network-snapshot-ml-283119823"></a>
### inheritEntity

```ml
function inheritEntity(buffer, base)
```

Return the inherit entity value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `base` | `dynamic` | — | base value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/snapshot.ml#L81)

<a id="function-function-miniquake2-network-snapshot-readframe-function-readframe-buffer-history-baselines-src-miniquake2-network-snapshot-ml-2090323732"></a>
### readFrame

```ml
function readFrame(buffer, history, baselines)
```

Reads frame for the miniquake2 network snapshot workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `history` | `dynamic` | — | history value consumed by this operation. |
| `baselines` | `dynamic` | — | baselines value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/snapshot.ml#L253)

<a id="function-function-miniquake2-network-snapshot-readframeprotocol-function-readframeprotocol-buffer-history-baselines-protocol-src-miniquake2-network-snapshot-ml-1472906204"></a>
### readFrameProtocol

```ml
function readFrameProtocol(buffer, history, baselines, protocol)
```

Read frame protocol.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `history` | `dynamic` | — | history value consumed by this operation. |
| `baselines` | `dynamic` | — | baselines value consumed by this operation. |
| `protocol` | `dynamic` | — | protocol value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/snapshot.ml#L217)

<a id="function-function-miniquake2-network-snapshot-readpacketentities-function-readpacketentities-buffer-oldentities-baselines-src-miniquake2-network-snapshot-ml-1047353640"></a>
### readPacketEntities

```ml
function readPacketEntities(buffer, oldEntities, baselines)
```

Read packet entities.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `oldEntities` | `dynamic` | — | oldEntities value consumed by this operation. |
| `baselines` | `dynamic` | — | baselines value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/snapshot.ml#L149)

<a id="function-function-miniquake2-network-snapshot-readpacketentitiesbody-function-readpacketentitiesbody-buffer-oldentities-baselines-src-miniquake2-network-snapshot-ml-158389796"></a>
### readPacketEntitiesBody

```ml
function readPacketEntitiesBody(buffer, oldEntities, baselines)
```

Read packet entities body.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `oldEntities` | `dynamic` | — | oldEntities value consumed by this operation. |
| `baselines` | `dynamic` | — | baselines value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/snapshot.ml#L90)

<a id="function-function-miniquake2-network-snapshot-validateentities-function-validateentities-entities-operation-src-miniquake2-network-snapshot-ml-1452444242"></a>
### validateEntities

```ml
function validateEntities(entities, operation)
```

Validate entities.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entities` | `dynamic` | — | entities value consumed by this operation. |
| `operation` | `dynamic` | — | operation value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/snapshot.ml#L25)

<a id="function-function-miniquake2-network-snapshot-writeframeforclient-function-writeframeforclient-buffer-current-lastframe-history-baselines-maxclients-suppresscount-src-miniquake2-network-snapshot-ml-971241526"></a>
### writeFrameForClient

```ml
function writeFrameForClient(buffer, current, lastFrame, history, baselines, maxClients, suppressCount)
```

Write frame for client.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `current` | `dynamic` | — | current value consumed by this operation. |
| `lastFrame` | `dynamic` | — | lastFrame value consumed by this operation. |
| `history` | `dynamic` | — | history value consumed by this operation. |
| `baselines` | `dynamic` | — | baselines value consumed by this operation. |
| `maxClients` | `dynamic` | — | maxClients value consumed by this operation. |
| `suppressCount` | `dynamic` | — | Number of suppress to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/snapshot.ml#L188)

<a id="function-function-miniquake2-network-snapshot-writepacketentities-function-writepacketentities-buffer-oldentities-newentities-baselines-maxclients-src-miniquake2-network-snapshot-ml-128345331"></a>
### writePacketEntities

```ml
function writePacketEntities(buffer, oldEntities, newEntities, baselines, maxClients)
```

Write packet entities.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `oldEntities` | `dynamic` | — | oldEntities value consumed by this operation. |
| `newEntities` | `dynamic` | — | newEntities value consumed by this operation. |
| `baselines` | `dynamic` | — | baselines value consumed by this operation. |
| `maxClients` | `dynamic` | — | maxClients value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/snapshot.ml#L50)
