# `src/miniquake2/network/runtime/multicast_dispatch.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 network runtime multicast dispatch facilities for this project.

Package: [`miniquake2.network.runtime.multicast_dispatch`](Package-miniquake2-network-runtime-multicast-dispatch-1906211584.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/network/constants.ml` as `nrtmulticastnc` → [src/miniquake2/network/constants.ml](File-src-miniquake2-network-constants-ml-102415622.md)
- `miniquake2/network/runtime/pump.ml` as `nrtmulticastpump` → [src/miniquake2/network/runtime/pump.ml](File-src-miniquake2-network-runtime-pump-ml-890925024.md)
- `miniquake2/protocol/constants.ml` as `nrtmulticastpc` → [src/miniquake2/protocol/constants.ml](File-src-miniquake2-protocol-constants-ml-642349806.md)
- `miniquake2/protocol/netchan.ml` as `nrtmulticastnetchan` → [src/miniquake2/protocol/netchan.ml](File-src-miniquake2-protocol-netchan-ml-626556964.md)
- `miniquake2/qcommon/sizebuf.ml` as `nrtmulticastsizebuf` → [src/miniquake2/qcommon/sizebuf.ml](File-src-miniquake2-qcommon-sizebuf-ml-1769950759.md)
- `miniquake2/server/game_messages.ml` as `nrtmulticastmessages` → [src/miniquake2/server/game_messages.ml](File-src-miniquake2-server-game-messages-ml-506318169.md)
- `std/array.ml` as `nrtmulticastarray` → `../MiniLangCompilerML/std/array.ml` — external dependency

## Declarations

<a id="function-function-miniquake2-network-runtime-multicast-dispatch-buildplan-function-buildplan-runtime-slot-events-src-miniquake2-network-runtime-multicast-dispatch-ml-1798752688"></a>
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


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/multicast_dispatch.ml#L83)

<a id="function-function-miniquake2-network-runtime-multicast-dispatch-dispatchrouted-function-dispatchrouted-runtime-socket-events-routedevents-now-src-miniquake2-network-runtime-multicast-dispatch-ml-719706233"></a>
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


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/multicast_dispatch.ml#L141)

- [miniquake2.network.runtime.multicast_dispatch.MulticastClientPlan](Type-miniquake2-network-runtime-multicast-dispatch-multicastclientplan-1828354796.md) — struct
- [miniquake2.network.runtime.multicast_dispatch.MulticastDispatchResult](Type-miniquake2-network-runtime-multicast-dispatch-multicastdispatchresult-1485850223.md) — struct
<a id="function-function-miniquake2-network-runtime-multicast-dispatch-packetize-function-packetize-events-first-last-maximumpayload-src-miniquake2-network-runtime-multicast-dispatch-ml-1686249638"></a>
### packetize

```ml
function packetize(events, first, last, maximumPayload)
```

Performs the packetize operation for the miniquake2 network runtime multicast dispatch module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `events` | `dynamic` | — | events value consumed by this operation. |
| `first` | `dynamic` | — | first value consumed by this operation. |
| `last` | `dynamic` | — | last value consumed by this operation. |
| `maximumPayload` | `dynamic` | — | maximumPayload value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/multicast_dispatch.ml#L54)

<a id="function-function-miniquake2-network-runtime-multicast-dispatch-payloadcapacity-function-payloadcapacity-client-src-miniquake2-network-runtime-multicast-dispatch-ml-619818940"></a>
### payloadCapacity

```ml
function payloadCapacity(client)
```

Performs the payloadCapacity operation for the miniquake2 network runtime multicast dispatch module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `client` | `dynamic` | — | client value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/multicast_dispatch.ml#L40)
