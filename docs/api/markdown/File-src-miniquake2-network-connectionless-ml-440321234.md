# `src/miniquake2/network/connectionless.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 network connectionless facilities for this project.

Package: [`miniquake2.network.connectionless`](Package-miniquake2-network-connectionless-782532118.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/network/types.ml` as `nt` → [src/miniquake2/network/types.ml](File-src-miniquake2-network-types-ml-621495446.md)
- `miniquake2/protocol/constants.ml` as `pc` → [src/miniquake2/protocol/constants.ml](File-src-miniquake2-protocol-constants-ml-642349806.md)
- `miniquake2/protocol/packet.ml` as `ppacket` → [src/miniquake2/protocol/packet.ml](File-src-miniquake2-protocol-packet-ml-1389758677.md)
- `miniquake2/qcommon/cmd.ml` as `qcmd` → [src/miniquake2/qcommon/cmd.ml](File-src-miniquake2-qcommon-cmd-ml-1514462021.md)

## Declarations

<a id="function-function-miniquake2-network-connectionless-acknowledgement-function-acknowledgement-src-miniquake2-network-connectionless-ml-972825034"></a>
### acknowledgement

```ml
function acknowledgement()
```

Return the acknowledgement value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/connectionless.ml#L114)

<a id="function-function-miniquake2-network-connectionless-challenge-function-challenge-value-src-miniquake2-network-connectionless-ml-555099501"></a>
### challenge

```ml
function challenge(value)
```

Return the challenge value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/connectionless.ml#L120)

<a id="function-function-miniquake2-network-connectionless-clientconnect-function-clientconnect-src-miniquake2-network-connectionless-ml-340431956"></a>
### clientConnect

```ml
function clientConnect()
```

Performs the clientConnect operation for the miniquake2 network connectionless module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/connectionless.ml#L125)

<a id="function-function-miniquake2-network-connectionless-connect-function-connect-qport-challenge-userinfo-src-miniquake2-network-connectionless-ml-320526540"></a>
### connect

```ml
function connect(qport, challenge, userInfo)
```

Connect state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `qport` | `dynamic` | — | qport value consumed by this operation. |
| `challenge` | `dynamic` | — | challenge value consumed by this operation. |
| `userInfo` | `dynamic` | — | userInfo value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/connectionless.ml#L91)

<a id="function-function-miniquake2-network-connectionless-frametext-function-frametext-text-src-miniquake2-network-connectionless-ml-903799049"></a>
### frameText

```ml
function frameText(text)
```

Return the frame text value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `text` | `dynamic` | — | Text consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/connectionless.ml#L78)

<a id="function-function-miniquake2-network-connectionless-getchallenge-function-getchallenge-src-miniquake2-network-connectionless-ml-1603032938"></a>
### getChallenge

```ml
function getChallenge()
```

Return challenge.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/connectionless.ml#L83)

<a id="function-function-miniquake2-network-connectionless-heartbeat-function-heartbeat-statustext-src-miniquake2-network-connectionless-ml-180856655"></a>
### heartbeat

```ml
function heartbeat(statusText)
```

Return the heartbeat value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `statusText` | `dynamic` | — | statusText value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/connectionless.ml#L143)

<a id="function-function-miniquake2-network-connectionless-info-function-info-src-miniquake2-network-connectionless-ml-93556782"></a>
### info

```ml
function info()
```

Return the info value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/connectionless.ml#L109)

<a id="function-function-miniquake2-network-connectionless-inforeply-function-inforeply-text-src-miniquake2-network-connectionless-ml-2070541977"></a>
### infoReply

```ml
function infoReply(text)
```

Return the info reply value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `text` | `dynamic` | — | Text consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/connectionless.ml#L137)

<a id="function-function-miniquake2-network-connectionless-padleft-function-padleft-value-width-src-miniquake2-network-connectionless-ml-1197543749"></a>
### padLeft

```ml
function padLeft(value, width)
```

Pad left.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `width` | `dynamic` | — | Width in the coordinate or storage units used by the caller. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/connectionless.ml#L164)

<a id="function-function-miniquake2-network-connectionless-parsedecimal-function-parsedecimal-value-src-miniquake2-network-connectionless-ml-1449476775"></a>
### parseDecimal

```ml
function parseDecimal(value)
```

Parse decimal.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/connectionless.ml#L19)

<a id="function-function-miniquake2-network-connectionless-parsepacket-function-parsepacket-datagram-src-miniquake2-network-connectionless-ml-1761077723"></a>
### parsePacket

```ml
function parsePacket(datagram)
```

Parse packet.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `datagram` | `dynamic` | — | datagram value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/connectionless.ml#L68)

<a id="function-function-miniquake2-network-connectionless-ping-function-ping-src-miniquake2-network-connectionless-ml-85074114"></a>
### ping

```ml
function ping()
```

Return the ping value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/connectionless.ml#L99)

<a id="function-function-miniquake2-network-connectionless-printreply-function-printreply-text-src-miniquake2-network-connectionless-ml-1286382817"></a>
### printReply

```ml
function printReply(text)
```

Print reply.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `text` | `dynamic` | — | Text consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/connectionless.ml#L131)

<a id="function-function-miniquake2-network-connectionless-shutdown-function-shutdown-src-miniquake2-network-connectionless-ml-642744182"></a>
### shutdown

```ml
function shutdown()
```

Performs the shutdown operation for the miniquake2 network connectionless module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/connectionless.ml#L148)

<a id="function-function-miniquake2-network-connectionless-splitpayload-function-splitpayload-payload-src-miniquake2-network-connectionless-ml-694328632"></a>
### splitPayload

```ml
function splitPayload(payload)
```

Split payload.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `payload` | `dynamic` | — | payload value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/connectionless.ml#L46)

<a id="function-function-miniquake2-network-connectionless-status-function-status-src-miniquake2-network-connectionless-ml-1007349350"></a>
### status

```ml
function status()
```

Return the status value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/connectionless.ml#L104)

<a id="function-function-miniquake2-network-connectionless-truncatetext-function-truncatetext-value-maximumbytes-src-miniquake2-network-connectionless-ml-742571690"></a>
### truncateText

```ml
function truncateText(value, maximumBytes)
```

Return the truncate text value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `maximumBytes` | `dynamic` | — | maximumBytes value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/connectionless.ml#L155)
