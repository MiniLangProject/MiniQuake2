# `src/miniquake2/server/game_messages.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 server game messages facilities for this project.

Package: [`miniquake2.server.game_messages`](Package-miniquake2-server-game-messages-342961865.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/game/constants.ml` as `sgmgc` → [src/miniquake2/game/constants.ml](File-src-miniquake2-game-constants-ml-1723282332.md)
- `miniquake2/protocol/constants.ml` as `sgmpc` → [src/miniquake2/protocol/constants.ml](File-src-miniquake2-protocol-constants-ml-642349806.md)
- `miniquake2/qcommon/types.ml` as `sgmqtypes` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)
- `miniquake2/server/types.ml` as `sgmtypes` → [src/miniquake2/server/types.ml](File-src-miniquake2-server-types-ml-1630118723.md)

## Declarations

<a id="function-function-miniquake2-server-game-messages-basedestination-function-basedestination-destination-src-miniquake2-server-game-messages-ml-51581226"></a>
### baseDestination

```ml
function baseDestination(destination)
```

Return the base destination value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `destination` | `dynamic` | — | destination value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_messages.ml#L69)

<a id="function-function-miniquake2-server-game-messages-claimemissionserial-function-claimemissionserial-runtime-src-miniquake2-server-game-messages-ml-325557542"></a>
### claimEmissionSerial

```ml
function claimEmissionSerial(runtime)
```

Claim one ordering token shared by every GameImport message class. Stock Quake II appends multicast, unicast and sound commands to client buffers at the instant they are emitted; independent per-type counters lose that order when the managed bridge drains its typed queues at the frame boundary.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_messages.ml#L31)

<a id="function-function-miniquake2-server-game-messages-clearmulticasts-function-clearmulticasts-runtime-src-miniquake2-server-game-messages-ml-1463243532"></a>
### clearMulticasts

```ml
function clearMulticasts(runtime)
```

Clear multicast queue state while retaining its fixed storage.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_messages.ml#L120)

<a id="function-function-miniquake2-server-game-messages-clearunicasts-function-clearunicasts-runtime-src-miniquake2-server-game-messages-ml-341164654"></a>
### clearUnicasts

```ml
function clearUnicasts(runtime)
```

Clear unicast queue state while retaining its fixed storage.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_messages.ml#L254)

<a id="function-function-miniquake2-server-game-messages-copiedorigin-function-copiedorigin-origin-src-miniquake2-server-game-messages-ml-1642986340"></a>
### copiedOrigin

```ml
function copiedOrigin(origin)
```

Return the copied origin.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `origin` | `dynamic` | — | origin value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_messages.ml#L50)

<a id="function-function-miniquake2-server-game-messages-copypayload-function-copypayload-payload-src-miniquake2-server-game-messages-ml-143153908"></a>
### copyPayload

```ml
function copyPayload(payload)
```

Copy payload data.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `payload` | `dynamic` | — | payload value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_messages.ml#L280)

<a id="function-function-miniquake2-server-game-messages-enableoptimizedqueues-function-enableoptimizedqueues-runtime-src-miniquake2-server-game-messages-ml-1314734344"></a>
### enableOptimizedQueues

```ml
function enableOptimizedQueues(runtime)
```

Disable compatibility array views for the live server. Tests and component callers can retain the compact public arrays, while the product uses the fixed queues below and materializes one frame snapshot only when routing.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_messages.ml#L99)

<a id="function-function-miniquake2-server-game-messages-enqueue-function-enqueue-runtime-origin-destination-payload-src-miniquake2-server-game-messages-ml-157466284"></a>
### enqueue

```ml
function enqueue(runtime, origin, destination, payload)
```

Return the enqueue value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `origin` | `dynamic` | — | origin value consumed by this operation. |
| `destination` | `dynamic` | — | destination value consumed by this operation. |
| `payload` | `dynamic` | — | payload value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_messages.ml#L165)

<a id="function-function-miniquake2-server-game-messages-enqueueunicast-function-enqueueunicast-runtime-entity-reliable-payload-src-miniquake2-server-game-messages-ml-2045257727"></a>
### enqueueUnicast

```ml
function enqueueUnicast(runtime, entity, reliable, payload)
```

Return the enqueue unicast value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `reliable` | `dynamic` | — | reliable value consumed by this operation. |
| `payload` | `dynamic` | — | payload value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_messages.ml#L295)

<a id="constant-constant-miniquake2-server-game-messages-max-multicast-fragment-bytes-const-max-multicast-fragment-bytes-1392-src-miniquake2-server-game-messages-ml-1703055752"></a>
### MAX_MULTICAST_FRAGMENT_BYTES

```ml
const MAX_MULTICAST_FRAGMENT_BYTES = 1392
```

Defines the max multicast fragment bytes constant used by the miniquake2 server game messages module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_messages.ml#L20)

<a id="constant-constant-miniquake2-server-game-messages-max-pending-multicast-bytes-const-max-pending-multicast-bytes-88576-src-miniquake2-server-game-messages-ml-1764302051"></a>
### MAX_PENDING_MULTICAST_BYTES

```ml
const MAX_PENDING_MULTICAST_BYTES = 88576
```

Defines the max pending multicast bytes constant used by the miniquake2 server game messages module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_messages.ml#L18)

<a id="constant-constant-miniquake2-server-game-messages-max-pending-multicast-events-const-max-pending-multicast-events-256-src-miniquake2-server-game-messages-ml-698644526"></a>
### MAX_PENDING_MULTICAST_EVENTS

```ml
const MAX_PENDING_MULTICAST_EVENTS = 256
```

Defines the max pending multicast events constant used by the miniquake2 server game messages module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_messages.ml#L16)

<a id="constant-constant-miniquake2-server-game-messages-max-pending-unicast-bytes-const-max-pending-unicast-bytes-88576-src-miniquake2-server-game-messages-ml-741164763"></a>
### MAX_PENDING_UNICAST_BYTES

```ml
const MAX_PENDING_UNICAST_BYTES = 88576
```

Defines the max pending unicast bytes constant used by the miniquake2 server game messages module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_messages.ml#L24)

<a id="constant-constant-miniquake2-server-game-messages-max-pending-unicast-events-const-max-pending-unicast-events-256-src-miniquake2-server-game-messages-ml-1134624020"></a>
### MAX_PENDING_UNICAST_EVENTS

```ml
const MAX_PENDING_UNICAST_EVENTS = 256
```

Defines the max pending unicast events constant used by the miniquake2 server game messages module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_messages.ml#L22)

<a id="function-function-miniquake2-server-game-messages-numeric-function-numeric-value-src-miniquake2-server-game-messages-ml-1210578587"></a>
### numeric

```ml
function numeric(value)
```

Performs the numeric operation for the miniquake2 server game messages module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_messages.ml#L44)

<a id="function-function-miniquake2-server-game-messages-pendingmulticastsnapshot-function-pendingmulticastsnapshot-runtime-src-miniquake2-server-game-messages-ml-1013162648"></a>
### pendingMulticastSnapshot

```ml
function pendingMulticastSnapshot(runtime)
```

Copy the active multicast prefix for one routing transaction.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_messages.ml#L108)

<a id="function-function-miniquake2-server-game-messages-pendingunicastsnapshot-function-pendingunicastsnapshot-runtime-src-miniquake2-server-game-messages-ml-17221388"></a>
### pendingUnicastSnapshot

```ml
function pendingUnicastSnapshot(runtime)
```

Copy the active unicast prefix for one routing transaction.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_messages.ml#L242)

<a id="function-function-miniquake2-server-game-messages-queuedbytes-function-queuedbytes-events-src-miniquake2-server-game-messages-ml-1394414279"></a>
### queuedBytes

```ml
function queuedBytes(events)
```

Report whether queued bytes.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `events` | `dynamic` | — | events value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_messages.ml#L84)

<a id="function-function-miniquake2-server-game-messages-queuedunicastbytes-function-queuedunicastbytes-events-src-miniquake2-server-game-messages-ml-368232711"></a>
### queuedUnicastBytes

```ml
function queuedUnicastBytes(events)
```

Report whether queued unicast bytes.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `events` | `dynamic` | — | events value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_messages.ml#L229)

<a id="function-function-miniquake2-server-game-messages-reliabledestination-function-reliabledestination-destination-src-miniquake2-server-game-messages-ml-1301342668"></a>
### reliableDestination

```ml
function reliableDestination(destination)
```

Return the reliable destination value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `destination` | `dynamic` | — | destination value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_messages.ml#L62)

<a id="function-function-miniquake2-server-game-messages-restoremulticasts-function-restoremulticasts-runtime-events-src-miniquake2-server-game-messages-ml-1343573215"></a>
### restoreMulticasts

```ml
function restoreMulticasts(runtime, events)
```

Restore multicast events after a failed atomic reliable routing attempt.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `events` | `dynamic` | — | events value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_messages.ml#L132)

<a id="function-function-miniquake2-server-game-messages-restoreunicasts-function-restoreunicasts-runtime-events-src-miniquake2-server-game-messages-ml-2105638961"></a>
### restoreUnicasts

```ml
function restoreUnicasts(runtime, events)
```

Restore unicast events after a failed atomic reliable routing attempt.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `events` | `dynamic` | — | events value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_messages.ml#L265)

<a id="function-function-miniquake2-server-game-messages-unicastentitynumber-function-unicastentitynumber-runtime-entity-src-miniquake2-server-game-messages-ml-1211037173"></a>
### unicastEntityNumber

```ml
function unicastEntityNumber(runtime, entity)
```

Return the unicast entity number.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_messages.ml#L218)

<a id="function-function-miniquake2-server-game-messages-validateall-function-validateall-events-src-miniquake2-server-game-messages-ml-1626710365"></a>
### validateAll

```ml
function validateAll(events)
```

Validate all.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `events` | `dynamic` | — | events value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_messages.ml#L199)

<a id="function-function-miniquake2-server-game-messages-validateevent-function-validateevent-event-src-miniquake2-server-game-messages-ml-1273638216"></a>
### validateEvent

```ml
function validateEvent(event)
```

Validate event.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `event` | `dynamic` | — | event value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_messages.ml#L147)

<a id="function-function-miniquake2-server-game-messages-validateunicastall-function-validateunicastall-events-src-miniquake2-server-game-messages-ml-1757236063"></a>
### validateUnicastAll

```ml
function validateUnicastAll(events)
```

Validate unicast all.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `events` | `dynamic` | — | events value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_messages.ml#L331)

<a id="function-function-miniquake2-server-game-messages-validateunicastevent-function-validateunicastevent-event-src-miniquake2-server-game-messages-ml-1342462852"></a>
### validateUnicastEvent

```ml
function validateUnicastEvent(event)
```

Validate unicast event.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `event` | `dynamic` | — | event value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_messages.ml#L319)
