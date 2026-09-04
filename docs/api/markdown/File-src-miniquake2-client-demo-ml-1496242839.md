# `src/miniquake2/client/demo.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 client demo facilities for this project.

Package: [`miniquake2.client.demo`](Package-miniquake2-client-demo-710521829.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/qcommon/byteio.ml` as `demobio` → [src/miniquake2/qcommon/byteio.ml](File-src-miniquake2-qcommon-byteio-ml-159119335.md)
- `miniquake2/qcommon/constants.ml` as `qc` → [src/miniquake2/qcommon/constants.ml](File-src-miniquake2-qcommon-constants-ml-1976195726.md)

## Declarations

<a id="function-function-miniquake2-client-demo-append-function-append-demo-packet-src-miniquake2-client-demo-ml-1203235715"></a>
### append

```ml
function append(demo, packet)
```

Append state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `demo` | `dynamic` | — | demo value consumed by this operation. |
| `packet` | `dynamic` | — | packet value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/demo.ml#L107)

<a id="function-function-miniquake2-client-demo-appendlive-function-appendlive-demo-packet-framecount-deltanumber-src-miniquake2-client-demo-ml-723506182"></a>
### appendLive

```ml
function appendLive(demo, packet, frameCount, deltaNumber)
```

CL_Record_f writes setup state immediately, then waits for a non-delta snapshot so the first recorded gameplay frame never references history from before recording began. Pure config/sound messages remain safe meanwhile.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `demo` | `dynamic` | — | demo value consumed by this operation. |
| `packet` | `dynamic` | — | packet value consumed by this operation. |
| `frameCount` | `dynamic` | — | Number of frame to process. |
| `deltaNumber` | `dynamic` | — | deltaNumber value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/demo.ml#L91)

<a id="function-function-miniquake2-client-demo-appendstreaming-function-appendstreaming-demo-packet-src-miniquake2-client-demo-ml-1081057555"></a>
### appendStreaming

```ml
function appendStreaming(demo, packet)
```

Append streaming.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `demo` | `dynamic` | — | demo value consumed by this operation. |
| `packet` | `dynamic` | — | packet value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/demo.ml#L64)

<a id="function-function-miniquake2-client-demo-beginliverecording-function-beginliverecording-demo-src-miniquake2-client-demo-ml-824819247"></a>
### beginLiveRecording

```ml
function beginLiveRecording(demo)
```

Begin live recording.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `demo` | `dynamic` | — | demo value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/demo.ml#L54)

<a id="function-function-miniquake2-client-demo-create-function-create-src-miniquake2-client-demo-ml-850469290"></a>
### create

```ml
function create()
```

Creates create for the miniquake2 client demo module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/demo.ml#L48)

<a id="function-function-miniquake2-client-demo-decodedemo-function-decodedemo-data-src-miniquake2-client-demo-ml-1435520354"></a>
### decodeDemo

```ml
function decodeDemo(data)
```

Decode demo.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/demo.ml#L143)

- [miniquake2.client.demo.Demo](Type-miniquake2-client-demo-demo-517623442.md) — struct
- [miniquake2.client.demo.DemoPacketNode](Type-miniquake2-client-demo-demopacketnode-1721115398.md) — struct
- [miniquake2.client.demo.DemoPlayer](Type-miniquake2-client-demo-demoplayer-1611401131.md) — struct
<a id="function-function-miniquake2-client-demo-encodedemo-function-encodedemo-demo-src-miniquake2-client-demo-ml-853121319"></a>
### encodeDemo

```ml
function encodeDemo(demo)
```

Encode demo.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `demo` | `dynamic` | — | demo value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/demo.ml#L114)

<a id="function-function-miniquake2-client-demo-materialize-function-materialize-demo-src-miniquake2-client-demo-ml-461058853"></a>
### materialize

```ml
function materialize(demo)
```

Materialize state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `demo` | `dynamic` | — | demo value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/demo.ml#L163)

<a id="function-function-miniquake2-client-demo-nextpacket-function-nextpacket-player-src-miniquake2-client-demo-ml-1951454493"></a>
### nextPacket

```ml
function nextPacket(player)
```

Return the next packet value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/demo.ml#L194)

<a id="function-function-miniquake2-client-demo-packetcount-function-packetcount-demo-src-miniquake2-client-demo-ml-1403256441"></a>
### packetCount

```ml
function packetCount(demo)
```

Return the packet count.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `demo` | `dynamic` | — | demo value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/demo.ml#L79)

<a id="function-function-miniquake2-client-demo-player-function-player-demo-src-miniquake2-client-demo-ml-2120213287"></a>
### player

```ml
function player(demo)
```

Return the player value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `demo` | `dynamic` | — | demo value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/demo.ml#L187)
