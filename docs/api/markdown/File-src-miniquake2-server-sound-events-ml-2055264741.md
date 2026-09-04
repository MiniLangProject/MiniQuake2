# `src/miniquake2/server/sound_events.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 server sound events facilities for this project.

Package: [`miniquake2.server.sound_events`](Package-miniquake2-server-sound-events-731432123.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/protocol/constants.ml` as `ssepc` → [src/miniquake2/protocol/constants.ml](File-src-miniquake2-protocol-constants-ml-642349806.md)
- `miniquake2/qcommon/byteio.ml` as `ssebio` → [src/miniquake2/qcommon/byteio.ml](File-src-miniquake2-qcommon-byteio-ml-159119335.md)
- `miniquake2/qcommon/constants.ml` as `sseqc` → [src/miniquake2/qcommon/constants.ml](File-src-miniquake2-qcommon-constants-ml-1976195726.md)
- `miniquake2/qcommon/message.ml` as `sseqmsg` → [src/miniquake2/qcommon/message.ml](File-src-miniquake2-qcommon-message-ml-1426179364.md)
- `miniquake2/qcommon/sizebuf.ml` as `sseqsz` → [src/miniquake2/qcommon/sizebuf.ml](File-src-miniquake2-qcommon-sizebuf-ml-1769950759.md)
- `miniquake2/qcommon/types.ml` as `sseqtypes` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)
- `miniquake2/server/game_messages.ml` as `ssemessages` → [src/miniquake2/server/game_messages.ml](File-src-miniquake2-server-game-messages-ml-506318169.md)
- `miniquake2/server/types.ml` as `ssetypes` → [src/miniquake2/server/types.ml](File-src-miniquake2-server-types-ml-1630118723.md)

## Declarations

<a id="function-function-miniquake2-server-sound-events-clearpending-function-clearpending-runtime-src-miniquake2-server-sound-events-ml-1767823768"></a>
### clearPending

```ml
function clearPending(runtime)
```

Report whether clear pending.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/sound_events.ml#L133)

<a id="function-function-miniquake2-server-sound-events-copiedposition-function-copiedposition-position-src-miniquake2-server-sound-events-ml-939943615"></a>
### copiedPosition

```ml
function copiedPosition(position)
```

Return the copied position.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `position` | `dynamic` | — | position value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/sound_events.ml#L40)

<a id="function-function-miniquake2-server-sound-events-encode-function-encode-event-src-miniquake2-server-sound-events-ml-453840500"></a>
### encode

```ml
function encode(event)
```

Encodes encode for the miniquake2 server sound events workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `event` | `dynamic` | — | event value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/sound_events.ml#L193)

<a id="function-function-miniquake2-server-sound-events-encodeall-function-encodeall-events-src-miniquake2-server-sound-events-ml-157363279"></a>
### encodeAll

```ml
function encodeAll(events)
```

Encode all.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `events` | `dynamic` | — | events value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/sound_events.ml#L216)

<a id="function-function-miniquake2-server-sound-events-enqueue-function-enqueue-runtime-position-routingposition-entity-channelflags-soundindex-volume-attenuation-timeoffset-src-miniquake2-server-sound-events-ml-1247053876"></a>
### enqueue

```ml
function enqueue(runtime, position, routingPosition, entity, channelFlags, soundIndex, volume, attenuation, timeOffset)
```

Return the enqueue value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `position` | `dynamic` | — | position value consumed by this operation. |
| `routingPosition` | `dynamic` | — | routingPosition value consumed by this operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `channelFlags` | `dynamic` | — | channelFlags value consumed by this operation. |
| `soundIndex` | `dynamic` | — | Zero-based index of sound. |
| `volume` | `dynamic` | — | volume value consumed by this operation. |
| `attenuation` | `dynamic` | — | attenuation value consumed by this operation. |
| `timeOffset` | `dynamic` | — | timeOffset value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/sound_events.ml#L169)

<a id="function-function-miniquake2-server-sound-events-entityfields-function-entityfields-entity-src-miniquake2-server-sound-events-ml-901884123"></a>
### entityFields

```ml
function entityFields(entity)
```

Return the entity fields value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/sound_events.ml#L55)

<a id="constant-constant-miniquake2-server-sound-events-max-pending-sound-events-const-max-pending-sound-events-1024-src-miniquake2-server-sound-events-ml-16918868"></a>
### MAX_PENDING_SOUND_EVENTS

```ml
const MAX_PENDING_SOUND_EVENTS = 1024
```

Defines the max pending sound events constant used by the miniquake2 server sound events module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/sound_events.ml#L20)

<a id="constant-constant-miniquake2-server-sound-events-max-sound-fragment-bytes-const-max-sound-fragment-bytes-14-src-miniquake2-server-sound-events-ml-861915752"></a>
### MAX_SOUND_FRAGMENT_BYTES

```ml
const MAX_SOUND_FRAGMENT_BYTES = 14
```

Defines the max sound fragment bytes constant used by the miniquake2 server sound events module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/sound_events.ml#L22)

<a id="function-function-miniquake2-server-sound-events-numeric-function-numeric-value-src-miniquake2-server-sound-events-ml-792703745"></a>
### numeric

```ml
function numeric(value)
```

Performs the numeric operation for the miniquake2 server sound events module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/sound_events.ml#L26)

<a id="function-function-miniquake2-server-sound-events-packetize-function-packetize-fragments-maximumpayload-src-miniquake2-server-sound-events-ml-1408543403"></a>
### packetize

```ml
function packetize(fragments, maximumPayload)
```

Performs the packetize operation for the miniquake2 server sound events module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `fragments` | `dynamic` | — | fragments value consumed by this operation. |
| `maximumPayload` | `dynamic` | — | maximumPayload value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/sound_events.ml#L230)

<a id="function-function-miniquake2-server-sound-events-pendingsnapshot-function-pendingsnapshot-runtime-src-miniquake2-server-sound-events-ml-1129793406"></a>
### pendingSnapshot

```ml
function pendingSnapshot(runtime)
```

The live bridge owns one fixed-capacity array. Enqueue is O(1); a compact owned view is made only once at the server-frame dispatch boundary.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/sound_events.ml#L115)

<a id="function-function-miniquake2-server-sound-events-restorepending-function-restorepending-runtime-events-src-miniquake2-server-sound-events-ml-1122575135"></a>
### restorePending

```ml
function restorePending(runtime, events)
```

Report whether restore pending.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `events` | `dynamic` | — | events value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/sound_events.ml#L144)

<a id="function-function-miniquake2-server-sound-events-validateall-function-validateall-events-src-miniquake2-server-sound-events-ml-304060287"></a>
### validateAll

```ml
function validateAll(events)
```

Validate all.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `events` | `dynamic` | — | events value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/sound_events.ml#L95)

<a id="function-function-miniquake2-server-sound-events-validatefields-function-validatefields-hasentity-entitynumber-channel-channelflags-soundindex-volume-attenuation-timeoffset-position-src-miniquake2-server-sound-events-ml-111983454"></a>
### validateFields

```ml
function validateFields(hasEntity, entityNumber, channel, channelFlags, soundIndex, volume, attenuation, timeOffset, position)
```

Validate fields.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `hasEntity` | `dynamic` | — | hasEntity value consumed by this operation. |
| `entityNumber` | `dynamic` | — | entityNumber value consumed by this operation. |
| `channel` | `dynamic` | — | channel value consumed by this operation. |
| `channelFlags` | `dynamic` | — | channelFlags value consumed by this operation. |
| `soundIndex` | `dynamic` | — | Zero-based index of sound. |
| `volume` | `dynamic` | — | volume value consumed by this operation. |
| `attenuation` | `dynamic` | — | attenuation value consumed by this operation. |
| `timeOffset` | `dynamic` | — | timeOffset value consumed by this operation. |
| `position` | `dynamic` | — | position value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/sound_events.ml#L75)

<a id="function-function-miniquake2-server-sound-events-validunit-function-validunit-value-minimum-maximum-src-miniquake2-server-sound-events-ml-31133413"></a>
### validUnit

```ml
function validUnit(value, minimum, maximum)
```

Report whether valid unit.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `minimum` | `dynamic` | — | minimum value consumed by this operation. |
| `maximum` | `dynamic` | — | maximum value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/sound_events.ml#L34)
