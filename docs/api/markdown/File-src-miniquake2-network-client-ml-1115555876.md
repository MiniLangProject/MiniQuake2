# `src/miniquake2/network/client.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 network client facilities for this project.

Package: [`miniquake2.network.client`](Package-miniquake2-network-client-1966563204.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/network/address.ml` as `naddress` → [src/miniquake2/network/address.ml](File-src-miniquake2-network-address-ml-1672601357.md)
- `miniquake2/network/connectionless.ml` as `nconnectionless` → [src/miniquake2/network/connectionless.ml](File-src-miniquake2-network-connectionless-ml-440321234.md)
- `miniquake2/network/constants.ml` as `nc` → [src/miniquake2/network/constants.ml](File-src-miniquake2-network-constants-ml-102415622.md)
- `miniquake2/network/snapshot.ml` as `nsnapshot` → [src/miniquake2/network/snapshot.ml](File-src-miniquake2-network-snapshot-ml-1023029537.md)
- `miniquake2/network/types.ml` as `nt` → [src/miniquake2/network/types.ml](File-src-miniquake2-network-types-ml-621495446.md)
- `miniquake2/protocol/constants.ml` as `pc` → [src/miniquake2/protocol/constants.ml](File-src-miniquake2-protocol-constants-ml-642349806.md)
- `miniquake2/protocol/netchan.ml` as `pnetchan` → [src/miniquake2/protocol/netchan.ml](File-src-miniquake2-protocol-netchan-ml-626556964.md)
- `miniquake2/qcommon/info.ml` as `qinfo` → [src/miniquake2/qcommon/info.ml](File-src-miniquake2-qcommon-info-ml-634538165.md)

## Declarations

<a id="function-function-miniquake2-network-client-acceptframe-function-acceptframe-client-frame-src-miniquake2-network-client-ml-293403052"></a>
### acceptFrame

```ml
function acceptFrame(client, frame)
```

Accept frame.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `client` | `dynamic` | — | client value consumed by this operation. |
| `frame` | `dynamic` | — | frame value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/client.ml#L217)

<a id="function-function-miniquake2-network-client-beginconnect-function-beginconnect-client-servername-serveraddress-userinfo-now-src-miniquake2-network-client-ml-288580963"></a>
### beginConnect

```ml
function beginConnect(client, serverName, serverAddress, userInfo, now)
```

Begin connect.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `client` | `dynamic` | — | client value consumed by this operation. |
| `serverName` | `dynamic` | — | serverName value consumed by this operation. |
| `serverAddress` | `dynamic` | — | serverAddress value consumed by this operation. |
| `userInfo` | `dynamic` | — | userInfo value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/client.ml#L38)

<a id="function-function-miniquake2-network-client-checkforresend-function-checkforresend-client-now-src-miniquake2-network-client-ml-562225959"></a>
### checkForResend

```ml
function checkForResend(client, now)
```

Validate for resend.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `client` | `dynamic` | — | client value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/client.ml#L96)

<a id="function-function-miniquake2-network-client-checktimeout-function-checktimeout-client-now-src-miniquake2-network-client-ml-2047948539"></a>
### checkTimeout

```ml
function checkTimeout(client, now)
```

Validate timeout.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `client` | `dynamic` | — | client value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/client.ml#L202)

<a id="function-function-miniquake2-network-client-connectlocal-function-connectlocal-client-loopbackaddress-now-src-miniquake2-network-client-ml-1827663872"></a>
### connectLocal

```ml
function connectLocal(client, loopbackAddress, now)
```

Listen-server loopback skips the challenge round trip in Quake II 3.19.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `client` | `dynamic` | — | client value consumed by this operation. |
| `loopbackAddress` | `dynamic` | — | loopbackAddress value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/client.ml#L108)

<a id="function-function-miniquake2-network-client-create-function-create-qport-timeoutmsec-src-miniquake2-network-client-ml-256379889"></a>
### create

```ml
function create(qport, timeoutMsec)
```

Creates create for the miniquake2 network client module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `qport` | `dynamic` | — | qport value consumed by this operation. |
| `timeoutMsec` | `dynamic` | — | timeoutMsec value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/client.ml#L25)

<a id="function-function-miniquake2-network-client-disconnect-function-disconnect-client-now-src-miniquake2-network-client-ml-617806503"></a>
### disconnect

```ml
function disconnect(client, now)
```

Return the disconnect value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `client` | `dynamic` | — | client value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/client.ml#L248)

<a id="function-function-miniquake2-network-client-disconnectcommand-function-disconnectcommand-src-miniquake2-network-client-ml-58533800"></a>
### disconnectCommand

```ml
function disconnectCommand()
```

Return the disconnect command value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/client.ml#L129)

<a id="function-function-miniquake2-network-client-handleconnectionless-function-handleconnectionless-client-sender-datagram-now-src-miniquake2-network-client-ml-1979303141"></a>
### handleConnectionless

```ml
function handleConnectionless(client, sender, datagram, now)
```

Handles connectionless for the miniquake2 network client workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `client` | `dynamic` | — | client value consumed by this operation. |
| `sender` | `dynamic` | — | sender value consumed by this operation. |
| `datagram` | `dynamic` | — | datagram value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/client.ml#L139)

<a id="function-function-miniquake2-network-client-newcommand-function-newcommand-src-miniquake2-network-client-ml-933626262"></a>
### newCommand

```ml
function newCommand()
```

Return the new command value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/client.ml#L124)

<a id="function-function-miniquake2-network-client-parseframe-function-parseframe-client-buffer-baselines-src-miniquake2-network-client-ml-165744961"></a>
### parseFrame

```ml
function parseFrame(client, buffer, baselines)
```

Parse frame.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `client` | `dynamic` | — | client value consumed by this operation. |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `baselines` | `dynamic` | — | baselines value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/client.ml#L229)

<a id="function-function-miniquake2-network-client-parseframeprotocol-function-parseframeprotocol-client-buffer-baselines-protocol-src-miniquake2-network-client-ml-877695765"></a>
### parseFrameProtocol

```ml
function parseFrameProtocol(client, buffer, baselines, protocol)
```

Parse frame protocol.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `client` | `dynamic` | — | client value consumed by this operation. |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `baselines` | `dynamic` | — | baselines value consumed by this operation. |
| `protocol` | `dynamic` | — | protocol value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/client.ml#L238)

<a id="function-function-miniquake2-network-client-rconaction-function-rconaction-client-alternateaddress-password-command-src-miniquake2-network-client-ml-1935661539"></a>
### rconAction

```ml
function rconAction(client, alternateAddress, password, command)
```

Build the client's out-of-band remote-console request. Connected clients target their current server; a disconnected console may supply rcon_address.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `client` | `dynamic` | — | client value consumed by this operation. |
| `alternateAddress` | `dynamic` | — | alternateAddress value consumed by this operation. |
| `password` | `dynamic` | — | password value consumed by this operation. |
| `command` | `dynamic` | — | command value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/client.ml#L73)

<a id="function-function-miniquake2-network-client-receivesequenced-function-receivesequenced-client-sender-datagram-now-src-miniquake2-network-client-ml-1562901881"></a>
### receiveSequenced

```ml
function receiveSequenced(client, sender, datagram, now)
```

Receive sequenced.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `client` | `dynamic` | — | client value consumed by this operation. |
| `sender` | `dynamic` | — | sender value consumed by this operation. |
| `datagram` | `dynamic` | — | datagram value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/client.ml#L189)

<a id="function-function-miniquake2-network-client-reconnect-function-reconnect-client-now-src-miniquake2-network-client-ml-1222506081"></a>
### reconnect

```ml
function reconnect(client, now)
```

Return the reconnect value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `client` | `dynamic` | — | client value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/client.ml#L59)

<a id="function-function-miniquake2-network-client-sendermatches-function-sendermatches-client-sender-src-miniquake2-network-client-ml-699239144"></a>
### senderMatches

```ml
function senderMatches(client, sender)
```

Return the sender matches value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `client` | `dynamic` | — | client value consumed by this operation. |
| `sender` | `dynamic` | — | sender value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/client.ml#L118)
