# `src/miniquake2/protocol/netchan.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 protocol netchan facilities for this project.

Package: [`miniquake2.protocol.netchan`](Package-miniquake2-protocol-netchan-1020785858.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/protocol/constants.ml` as `pc` → [src/miniquake2/protocol/constants.ml](File-src-miniquake2-protocol-constants-ml-642349806.md)
- `miniquake2/protocol/packet.ml` as `ppacket` → [src/miniquake2/protocol/packet.ml](File-src-miniquake2-protocol-packet-ml-1389758677.md)
- `miniquake2/protocol/types.ml` as `pt` → [src/miniquake2/protocol/types.ml](File-src-miniquake2-protocol-types-ml-736261438.md)
- `miniquake2/qcommon/sizebuf.ml` as `qsz` → [src/miniquake2/qcommon/sizebuf.ml](File-src-miniquake2-qcommon-sizebuf-ml-1769950759.md)

## Declarations

<a id="function-function-miniquake2-protocol-netchan-canqueuereliablefragments-function-canqueuereliablefragments-channel-fragments-src-miniquake2-protocol-netchan-ml-965630860"></a>
### canQueueReliableFragments

```ml
function canQueueReliableFragments(channel, fragments)
```

Report whether can queue reliable fragments.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `channel` | `dynamic` | — | channel value consumed by this operation. |
| `fragments` | `dynamic` | — | fragments value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/netchan.ml#L171)

<a id="function-function-miniquake2-protocol-netchan-canreliable-function-canreliable-channel-src-miniquake2-protocol-netchan-ml-945263519"></a>
### canReliable

```ml
function canReliable(channel)
```

Report whether can reliable.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `channel` | `dynamic` | — | channel value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/netchan.ml#L56)

<a id="function-function-miniquake2-protocol-netchan-needreliable-function-needreliable-channel-src-miniquake2-protocol-netchan-ml-1272732391"></a>
### needReliable

```ml
function needReliable(channel)
```

Return the need reliable value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `channel` | `dynamic` | — | channel value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/netchan.ml#L92)

<a id="function-function-miniquake2-protocol-netchan-netchan-canreliable-function-netchan-canreliable-channel-src-miniquake2-protocol-netchan-ml-1600208879"></a>
### Netchan_CanReliable

```ml
function Netchan_CanReliable(channel)
```

Report whether netchan can reliable.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `channel` | `dynamic` | — | channel value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/netchan.ml#L323)

<a id="function-function-miniquake2-protocol-netchan-netchan-needreliable-function-netchan-needreliable-channel-src-miniquake2-protocol-netchan-ml-1031563175"></a>
### Netchan_NeedReliable

```ml
function Netchan_NeedReliable(channel)
```

Return the netchan need reliable value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `channel` | `dynamic` | — | channel value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/netchan.ml#L329)

<a id="function-function-miniquake2-protocol-netchan-netchan-outofband-function-netchan-outofband-data-src-miniquake2-protocol-netchan-ml-1261495044"></a>
### Netchan_OutOfBand

```ml
function Netchan_OutOfBand(data)
```

Return the netchan out of band value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/netchan.ml#L353)

<a id="function-function-miniquake2-protocol-netchan-netchan-outofbandprint-function-netchan-outofbandprint-text-src-miniquake2-protocol-netchan-ml-1303967195"></a>
### Netchan_OutOfBandPrint

```ml
function Netchan_OutOfBandPrint(text)
```

Print netchan out of band.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `text` | `dynamic` | — | Text consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/netchan.ml#L359)

<a id="function-function-miniquake2-protocol-netchan-netchan-process-function-netchan-process-channel-datagram-now-src-miniquake2-protocol-netchan-ml-1479615990"></a>
### Netchan_Process

```ml
function Netchan_Process(channel, datagram, now)
```

Process netchan.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `channel` | `dynamic` | — | channel value consumed by this operation. |
| `datagram` | `dynamic` | — | datagram value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/netchan.ml#L347)

<a id="function-function-miniquake2-protocol-netchan-netchan-setup-function-netchan-setup-sock-remoteaddress-qport-now-src-miniquake2-protocol-netchan-ml-707003996"></a>
### Netchan_Setup

```ml
function Netchan_Setup(sock, remoteAddress, qport, now)
```

Return the netchan setup value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sock` | `dynamic` | — | sock value consumed by this operation. |
| `remoteAddress` | `dynamic` | — | remoteAddress value consumed by this operation. |
| `qport` | `dynamic` | — | qport value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/netchan.ml#L317)

<a id="function-function-miniquake2-protocol-netchan-netchan-transmit-function-netchan-transmit-channel-length-data-now-src-miniquake2-protocol-netchan-ml-1576459049"></a>
### Netchan_Transmit

```ml
function Netchan_Transmit(channel, length, data, now)
```

Return the netchan transmit value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `channel` | `dynamic` | — | channel value consumed by this operation. |
| `length` | `dynamic` | — | length value consumed by this operation. |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/netchan.ml#L338)

<a id="function-function-miniquake2-protocol-netchan-nextsequence-function-nextsequence-sequence-src-miniquake2-protocol-netchan-ml-315666613"></a>
### nextSequence

```ml
function nextSequence(sequence)
```

Return the next sequence value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sequence` | `dynamic` | — | sequence value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/netchan.ml#L20)

<a id="function-function-miniquake2-protocol-netchan-outofband-function-outofband-payload-src-miniquake2-protocol-netchan-ml-565695598"></a>
### outOfBand

```ml
function outOfBand(payload)
```

Return the out of band value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `payload` | `dynamic` | — | payload value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/netchan.ml#L302)

<a id="function-function-miniquake2-protocol-netchan-outofbandprint-function-outofbandprint-text-src-miniquake2-protocol-netchan-ml-1030235427"></a>
### outOfBandPrint

```ml
function outOfBandPrint(text)
```

Print out of band.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `text` | `dynamic` | — | Text consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/netchan.ml#L308)

<a id="function-function-miniquake2-protocol-netchan-pendingreliablebytes-function-pendingreliablebytes-channel-src-miniquake2-protocol-netchan-ml-483766767"></a>
### pendingReliableBytes

```ml
function pendingReliableBytes(channel)
```

Report whether pending reliable bytes.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `channel` | `dynamic` | — | channel value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/netchan.ml#L85)

<a id="function-function-miniquake2-protocol-netchan-process-function-process-channel-datagram-now-src-miniquake2-protocol-netchan-ml-228794182"></a>
### process

```ml
function process(channel, datagram, now)
```

Process state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `channel` | `dynamic` | — | channel value consumed by this operation. |
| `datagram` | `dynamic` | — | datagram value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/netchan.ml#L267)

<a id="function-function-miniquake2-protocol-netchan-promotereliable-function-promotereliable-channel-src-miniquake2-protocol-netchan-ml-1778939063"></a>
### promoteReliable

```ml
function promoteReliable(channel)
```

Return the promote reliable value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `channel` | `dynamic` | — | channel value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/netchan.ml#L192)

<a id="function-function-miniquake2-protocol-netchan-queuereliable-function-queuereliable-channel-payload-src-miniquake2-protocol-netchan-ml-1201610793"></a>
### queueReliable

```ml
function queueReliable(channel, payload)
```

Queue reliable.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `channel` | `dynamic` | — | channel value consumed by this operation. |
| `payload` | `dynamic` | — | payload value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/netchan.ml#L106)

<a id="function-function-miniquake2-protocol-netchan-queuereliablefragments-function-queuereliablefragments-channel-fragments-src-miniquake2-protocol-netchan-ml-1621863472"></a>
### queueReliableFragments

```ml
function queueReliableFragments(channel, fragments)
```

Queue complete application payload fragments without splitting the bytes of an svc/clc command.  The operation is failure-atomic: capacity is checked on detached queue/buffer state, then committed in one small mutation boundary. A false result is bounded backpressure; malformed state/input is an error.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `channel` | `dynamic` | — | channel value consumed by this operation. |
| `fragments` | `dynamic` | — | fragments value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/netchan.ml#L126)

<a id="function-function-miniquake2-protocol-netchan-sequenceatleast-function-sequenceatleast-candidate-current-src-miniquake2-protocol-netchan-ml-1589647768"></a>
### sequenceAtLeast

```ml
function sequenceAtLeast(candidate, current)
```

Return the sequence at least value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `candidate` | `dynamic` | — | candidate value consumed by this operation. |
| `current` | `dynamic` | — | current value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/netchan.ml#L36)

<a id="function-function-miniquake2-protocol-netchan-sequencenewer-function-sequencenewer-candidate-current-src-miniquake2-protocol-netchan-ml-663078726"></a>
### sequenceNewer

```ml
function sequenceNewer(candidate, current)
```

Modular comparison keeps the reference ordering until the 31-bit counter wraps, then preserves the same stale/duplicate protection across the wrap.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `candidate` | `dynamic` | — | candidate value consumed by this operation. |
| `current` | `dynamic` | — | current value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/netchan.ml#L28)

<a id="function-function-miniquake2-protocol-netchan-setup-function-setup-sock-remoteaddress-qport-now-src-miniquake2-protocol-netchan-ml-1413988988"></a>
### setup

```ml
function setup(sock, remoteAddress, qport, now)
```

Return the setup value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sock` | `dynamic` | — | sock value consumed by this operation. |
| `remoteAddress` | `dynamic` | — | remoteAddress value consumed by this operation. |
| `qport` | `dynamic` | — | qport value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/netchan.ml#L45)

<a id="function-function-miniquake2-protocol-netchan-transmit-function-transmit-channel-unreliable-now-src-miniquake2-protocol-netchan-ml-1205001566"></a>
### transmit

```ml
function transmit(channel, unreliable, now)
```

Return the transmit value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `channel` | `dynamic` | — | channel value consumed by this operation. |
| `unreliable` | `dynamic` | — | unreliable value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/netchan.ml#L221)

<a id="function-function-miniquake2-protocol-netchan-validatereliablequeue-function-validatereliablequeue-channel-src-miniquake2-protocol-netchan-ml-1945309261"></a>
### validateReliableQueue

```ml
function validateReliableQueue(channel)
```

Validate reliable queue.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `channel` | `dynamic` | — | channel value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/protocol/netchan.ml#L62)
