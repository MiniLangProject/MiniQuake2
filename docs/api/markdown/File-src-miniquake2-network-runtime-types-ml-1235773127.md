# `src/miniquake2/network/runtime/types.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 network runtime types facilities for this project.

Package: [`miniquake2.network.runtime.types`](Package-miniquake2-network-runtime-types-834784014.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/protocol/constants.ml` as `pc` → [src/miniquake2/protocol/constants.ml](File-src-miniquake2-protocol-constants-ml-642349806.md)
- `miniquake2/protocol/types.ml` as `pt` → [src/miniquake2/protocol/types.ml](File-src-miniquake2-protocol-types-ml-736261438.md)
- `miniquake2/qcommon/constants.ml` as `qc` → [src/miniquake2/qcommon/constants.ml](File-src-miniquake2-qcommon-constants-ml-1976195726.md)
- `miniquake2/qcommon/types.ml` as `qt` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)
- `miniquake2/server/administration.ml` as `nradmin` → [src/miniquake2/server/administration.ml](File-src-miniquake2-server-administration-ml-1444195484.md)

## Declarations

- [miniquake2.network.runtime.types.ClientRuntime](Type-miniquake2-network-runtime-types-clientruntime-583434561.md) — struct
<a id="function-function-miniquake2-network-runtime-types-createclient-function-createclient-client-src-miniquake2-network-runtime-types-ml-1348891218"></a>
### createClient

```ml
function createClient(client)
```

Create client.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `client` | `dynamic` | — | client value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/types.ml#L195)

<a id="function-function-miniquake2-network-runtime-types-createserver-function-createserver-server-spawncount-gamedir-levelname-callbacks-src-miniquake2-network-runtime-types-ml-874539248"></a>
### createServer

```ml
function createServer(server, spawnCount, gameDir, levelName, callbacks)
```

Create server.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `server` | `dynamic` | — | server value consumed by this operation. |
| `spawnCount` | `dynamic` | — | Number of spawn to process. |
| `gameDir` | `dynamic` | — | gameDir value consumed by this operation. |
| `levelName` | `dynamic` | — | levelName value consumed by this operation. |
| `callbacks` | `dynamic` | — | callbacks value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/types.ml#L207)

- [miniquake2.network.runtime.types.DeferredReliableWork](Type-miniquake2-network-runtime-types-deferredreliablework-1330011276.md) — struct
- [miniquake2.network.runtime.types.DownloadFile](Type-miniquake2-network-runtime-types-downloadfile-381120582.md) — struct
- [miniquake2.network.runtime.types.DownloadTransfer](Type-miniquake2-network-runtime-types-downloadtransfer-389229683.md) — struct
- [miniquake2.network.runtime.types.GameCallbacks](Type-miniquake2-network-runtime-types-gamecallbacks-1395464946.md) — struct
<a id="function-function-miniquake2-network-runtime-types-makebaselines-function-makebaselines-src-miniquake2-network-runtime-types-ml-1945985875"></a>
### makeBaselines

```ml
function makeBaselines()
```

Create baselines.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/types.ml#L145)

<a id="function-function-miniquake2-network-runtime-types-makecommands-function-makecommands-count-src-miniquake2-network-runtime-types-ml-1108339722"></a>
### makeCommands

```ml
function makeCommands(count)
```

Create commands.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `count` | `dynamic` | — | Number of items or units to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/types.ml#L159)

<a id="function-function-miniquake2-network-runtime-types-makedeferredreliable-function-makedeferredreliable-count-src-miniquake2-network-runtime-types-ml-2135148046"></a>
### makeDeferredReliable

```ml
function makeDeferredReliable(count)
```

Create deferred reliable.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `count` | `dynamic` | — | Number of items or units to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/types.ml#L183)

<a id="function-function-miniquake2-network-runtime-types-maketransfers-function-maketransfers-count-src-miniquake2-network-runtime-types-ml-1636576178"></a>
### makeTransfers

```ml
function makeTransfers(count)
```

Create transfers.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `count` | `dynamic` | — | Number of items or units to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/types.ml#L171)

- [miniquake2.network.runtime.types.PumpStats](Type-miniquake2-network-runtime-types-pumpstats-203597057.md) — struct
- [miniquake2.network.runtime.types.ServerRuntime](Type-miniquake2-network-runtime-types-serverruntime-1777085453.md) — struct
<a id="function-function-miniquake2-network-runtime-types-stats-function-stats-src-miniquake2-network-runtime-types-ml-127003905"></a>
### stats

```ml
function stats()
```

Return the stats value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/types.ml#L221)
