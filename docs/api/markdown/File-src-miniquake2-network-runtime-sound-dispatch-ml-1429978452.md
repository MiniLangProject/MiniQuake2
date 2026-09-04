# `src/miniquake2/network/runtime/sound_dispatch.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 network runtime sound dispatch facilities for this project.

Package: [`miniquake2.network.runtime.sound_dispatch`](Package-miniquake2-network-runtime-sound-dispatch-1161888587.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/game/constants.ml` as `nrtsoundgc` → [src/miniquake2/game/constants.ml](File-src-miniquake2-game-constants-ml-1723282332.md)
- `miniquake2/network/constants.ml` as `nrtsoundnc` → [src/miniquake2/network/constants.ml](File-src-miniquake2-network-constants-ml-102415622.md)
- `miniquake2/network/runtime/pump.ml` as `nrtsoundpump` → [src/miniquake2/network/runtime/pump.ml](File-src-miniquake2-network-runtime-pump-ml-890925024.md)
- `miniquake2/protocol/constants.ml` as `nrtsoundpc` → [src/miniquake2/protocol/constants.ml](File-src-miniquake2-protocol-constants-ml-642349806.md)
- `miniquake2/protocol/netchan.ml` as `nrtsoundnetchan` → [src/miniquake2/protocol/netchan.ml](File-src-miniquake2-protocol-netchan-ml-626556964.md)
- `miniquake2/server/sound_events.ml` as `nrtsoundevents` → [src/miniquake2/server/sound_events.ml](File-src-miniquake2-server-sound-events-ml-2055264741.md)
- `std/array.ml` as `nrtsoundarray` → `../MiniLangCompilerML/std/array.ml` — external dependency

## Declarations

<a id="function-function-miniquake2-network-runtime-sound-dispatch-buildplan-function-buildplan-runtime-slot-events-src-miniquake2-network-runtime-sound-dispatch-ml-1704952240"></a>
### buildPlan

```ml
function buildPlan(runtime, slot, events)
```

Build every datagram/staging mutation before touching a Netchan. Stock SV_StartSound routes each fragment independently: CHAN_RELIABLE enters the Netchan message, while ordinary weapon and movement sounds remain transient client datagrams even when they occur later in the same server frame.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `slot` | `dynamic` | — | slot value consumed by this operation. |
| `events` | `dynamic` | — | events value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/sound_dispatch.ml#L56)

<a id="function-function-miniquake2-network-runtime-sound-dispatch-dispatch-function-dispatch-runtime-socket-events-now-src-miniquake2-network-runtime-sound-dispatch-ml-785685125"></a>
### dispatch

```ml
function dispatch(runtime, socket, events, now)
```

Compatibility broadcast entry point retained for callers which do not own collision/PHS state.  ServerSession uses dispatchRouted instead.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `socket` | `dynamic` | — | socket value consumed by this operation. |
| `events` | `dynamic` | — | events value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/sound_dispatch.ml#L180)

<a id="function-function-miniquake2-network-runtime-sound-dispatch-dispatchrouted-function-dispatchrouted-runtime-socket-events-routedevents-now-src-miniquake2-network-runtime-sound-dispatch-ml-614918075"></a>
### dispatchRouted

```ml
function dispatchRouted(runtime, socket, events, routedEvents, now)
```

routedEvents has one ordered event list per server slot.  The original events list is separately supplied so zero-recipient sounds are still validated and consumed as one atomic bridge queue.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `socket` | `dynamic` | — | socket value consumed by this operation. |
| `events` | `dynamic` | — | events value consumed by this operation. |
| `routedEvents` | `dynamic` | — | routedEvents value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/sound_dispatch.ml#L120)

<a id="function-function-miniquake2-network-runtime-sound-dispatch-payloadcapacity-function-payloadcapacity-client-src-miniquake2-network-runtime-sound-dispatch-ml-1451743230"></a>
### payloadCapacity

```ml
function payloadCapacity(client)
```

Performs the payloadCapacity operation for the miniquake2 network runtime sound dispatch module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `client` | `dynamic` | — | client value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/sound_dispatch.ml#L40)

- [miniquake2.network.runtime.sound_dispatch.SoundClientPlan](Type-miniquake2-network-runtime-sound-dispatch-soundclientplan-576519490.md) — struct
- [miniquake2.network.runtime.sound_dispatch.SoundDispatchResult](Type-miniquake2-network-runtime-sound-dispatch-sounddispatchresult-1596955817.md) — struct
