# `src/miniquake2/network/runtime/unicast_dispatch.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 network runtime unicast dispatch facilities for this project.

Package: [`miniquake2.network.runtime.unicast_dispatch`](Package-miniquake2-network-runtime-unicast-dispatch-493436481.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/network/constants.ml` as `nrtunicastnc` → [src/miniquake2/network/constants.ml](File-src-miniquake2-network-constants-ml-102415622.md)
- `miniquake2/network/runtime/pump.ml` as `nrtunicastpump` → [src/miniquake2/network/runtime/pump.ml](File-src-miniquake2-network-runtime-pump-ml-890925024.md)
- `miniquake2/protocol/constants.ml` as `nrtunicastpc` → [src/miniquake2/protocol/constants.ml](File-src-miniquake2-protocol-constants-ml-642349806.md)
- `miniquake2/protocol/netchan.ml` as `nrtunicastnetchan` → [src/miniquake2/protocol/netchan.ml](File-src-miniquake2-protocol-netchan-ml-626556964.md)
- `miniquake2/qcommon/sizebuf.ml` as `nrtunicastsizebuf` → [src/miniquake2/qcommon/sizebuf.ml](File-src-miniquake2-qcommon-sizebuf-ml-1769950759.md)
- `miniquake2/server/game_messages.ml` as `nrtunicastmessages` → [src/miniquake2/server/game_messages.ml](File-src-miniquake2-server-game-messages-ml-506318169.md)
- `std/array.ml` as `nrtunicastarray` → `../MiniLangCompilerML/std/array.ml` — external dependency

## Declarations

<a id="function-function-miniquake2-network-runtime-unicast-dispatch-buildplan-function-buildplan-runtime-slot-events-src-miniquake2-network-runtime-unicast-dispatch-ml-1969771212"></a>
### buildPlan

```ml
function buildPlan(runtime, slot, events)
```

Build plan.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `slot` | `dynamic` | — | slot value consumed by this operation. |
| `events` | `dynamic` | — | events value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/unicast_dispatch.ml#L81)

<a id="function-function-miniquake2-network-runtime-unicast-dispatch-dispatchrouted-function-dispatchrouted-runtime-socket-events-routedevents-now-src-miniquake2-network-runtime-unicast-dispatch-ml-1454947467"></a>
### dispatchRouted

```ml
function dispatchRouted(runtime, socket, events, routedEvents, now)
```

Dispatch routed.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `socket` | `dynamic` | — | socket value consumed by this operation. |
| `events` | `dynamic` | — | events value consumed by this operation. |
| `routedEvents` | `dynamic` | — | routedEvents value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/unicast_dispatch.ml#L138)

<a id="function-function-miniquake2-network-runtime-unicast-dispatch-packetize-function-packetize-events-last-maximumpayload-src-miniquake2-network-runtime-unicast-dispatch-ml-1801995592"></a>
### packetize

```ml
function packetize(events, last, maximumPayload)
```

Performs the packetize operation for the miniquake2 network runtime unicast dispatch module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `events` | `dynamic` | — | events value consumed by this operation. |
| `last` | `dynamic` | — | last value consumed by this operation. |
| `maximumPayload` | `dynamic` | — | maximumPayload value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/unicast_dispatch.ml#L53)

<a id="function-function-miniquake2-network-runtime-unicast-dispatch-payloadcapacity-function-payloadcapacity-client-src-miniquake2-network-runtime-unicast-dispatch-ml-2092596546"></a>
### payloadCapacity

```ml
function payloadCapacity(client)
```

Performs the payloadCapacity operation for the miniquake2 network runtime unicast dispatch module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `client` | `dynamic` | — | client value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/unicast_dispatch.ml#L40)

- [miniquake2.network.runtime.unicast_dispatch.UnicastClientPlan](Type-miniquake2-network-runtime-unicast-dispatch-unicastclientplan-205113070.md) — struct
- [miniquake2.network.runtime.unicast_dispatch.UnicastDispatchResult](Type-miniquake2-network-runtime-unicast-dispatch-unicastdispatchresult-56647045.md) — struct
