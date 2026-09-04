# `src/miniquake2/network/server.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 network server facilities for this project.

Package: [`miniquake2.network.server`](Package-miniquake2-network-server-624235696.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/network/address.ml` as `naddress` → [src/miniquake2/network/address.ml](File-src-miniquake2-network-address-ml-1672601357.md)
- `miniquake2/network/connectionless.ml` as `nconnectionless` → [src/miniquake2/network/connectionless.ml](File-src-miniquake2-network-connectionless-ml-440321234.md)
- `miniquake2/network/constants.ml` as `nc` → [src/miniquake2/network/constants.ml](File-src-miniquake2-network-constants-ml-102415622.md)
- `miniquake2/network/snapshot.ml` as `nsnapshot` → [src/miniquake2/network/snapshot.ml](File-src-miniquake2-network-snapshot-ml-1023029537.md)
- `miniquake2/network/types.ml` as `nt` → [src/miniquake2/network/types.ml](File-src-miniquake2-network-types-ml-621495446.md)
- `miniquake2/protocol/constants.ml` as `pc` → [src/miniquake2/protocol/constants.ml](File-src-miniquake2-protocol-constants-ml-642349806.md)
- `miniquake2/protocol/netchan.ml` as `pnetchan` → [src/miniquake2/protocol/netchan.ml](File-src-miniquake2-protocol-netchan-ml-626556964.md)
- `miniquake2/protocol/packet.ml` as `ppacket` → [src/miniquake2/protocol/packet.ml](File-src-miniquake2-protocol-packet-ml-1389758677.md)
- `miniquake2/qcommon/info.ml` as `qinfo` → [src/miniquake2/qcommon/info.ml](File-src-miniquake2-qcommon-info-ml-634538165.md)

## Declarations

<a id="function-function-miniquake2-network-server-acknowledgeframe-function-acknowledgeframe-server-slot-framenumber-src-miniquake2-network-server-ml-1176034935"></a>
### acknowledgeFrame

```ml
function acknowledgeFrame(server, slot, frameNumber)
```

Return the acknowledge frame value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `server` | `dynamic` | — | server value consumed by this operation. |
| `slot` | `dynamic` | — | slot value consumed by this operation. |
| `frameNumber` | `dynamic` | — | frameNumber value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/server.ml#L372)

<a id="function-function-miniquake2-network-server-applyuserinfo-function-applyuserinfo-client-userinfo-src-miniquake2-network-server-ml-118457732"></a>
### applyUserInfo

```ml
function applyUserInfo(client, userInfo)
```

Apply user info.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `client` | `dynamic` | — | client value consumed by this operation. |
| `userInfo` | `dynamic` | — | userInfo value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/server.ml#L173)

<a id="function-function-miniquake2-network-server-challengefor-function-challengefor-server-address-now-src-miniquake2-network-server-ml-1422850057"></a>
### challengeFor

```ml
function challengeFor(server, address, now)
```

Return the challenge for the requested input.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `server` | `dynamic` | — | server value consumed by this operation. |
| `address` | `dynamic` | — | address value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/server.ml#L102)

<a id="function-function-miniquake2-network-server-challengevalid-function-challengevalid-server-address-value-src-miniquake2-network-server-ml-103941156"></a>
### challengeValid

```ml
function challengeValid(server, address, value)
```

Report whether challenge valid.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `server` | `dynamic` | — | server value consumed by this operation. |
| `address` | `dynamic` | — | address value consumed by this operation. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/server.ml#L123)

<a id="function-function-miniquake2-network-server-checktimeouts-function-checktimeouts-server-now-src-miniquake2-network-server-ml-1270785759"></a>
### checkTimeouts

```ml
function checkTimeouts(server, now)
```

Validate timeouts.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `server` | `dynamic` | — | server value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/server.ml#L337)

<a id="function-function-miniquake2-network-server-clientrate-function-clientrate-userinfo-src-miniquake2-network-server-ml-1975588269"></a>
### clientRate

```ml
function clientRate(userInfo)
```

SV_UserinfoChanged clamps the client-requested one-second snapshot budget. Missing or non-numeric values retain the stock 5000 byte default.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `userInfo` | `dynamic` | — | userInfo value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/server.ml#L159)

<a id="function-function-miniquake2-network-server-connectedcount-function-connectedcount-server-src-miniquake2-network-server-ml-1818612693"></a>
### connectedCount

```ml
function connectedCount(server)
```

Report whether connected count.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `server` | `dynamic` | — | server value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/server.ml#L72)

<a id="function-function-miniquake2-network-server-create-function-create-maxclients-hostname-mapname-serverinfo-dedicated-publicserver-src-miniquake2-network-server-ml-487568616"></a>
### create

```ml
function create(maxClients, hostname, mapName, serverInfo, dedicated, publicServer)
```

Creates create for the miniquake2 network server module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `maxClients` | `dynamic` | — | maxClients value consumed by this operation. |
| `hostname` | `dynamic` | — | hostname value consumed by this operation. |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `serverInfo` | `dynamic` | — | serverInfo value consumed by this operation. |
| `dedicated` | `dynamic` | — | dedicated value consumed by this operation. |
| `publicServer` | `dynamic` | — | publicServer value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/server.ml#L39)

<a id="function-function-miniquake2-network-server-dropclient-function-dropclient-server-slot-now-zombie-src-miniquake2-network-server-ml-956433361"></a>
### dropClient

```ml
function dropClient(server, slot, now, zombie)
```

Drop client.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `server` | `dynamic` | — | server value consumed by this operation. |
| `slot` | `dynamic` | — | slot value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |
| `zombie` | `dynamic` | — | zombie value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/server.ml#L325)

<a id="function-function-miniquake2-network-server-emptyclient-function-emptyclient-slot-src-miniquake2-network-server-ml-1363358430"></a>
### emptyClient

```ml
function emptyClient(slot)
```

Report whether empty client.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `slot` | `dynamic` | — | slot value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/server.ml#L25)

<a id="function-function-miniquake2-network-server-handleconnect-function-handleconnect-server-address-request-now-src-miniquake2-network-server-ml-1939995428"></a>
### handleConnect

```ml
function handleConnect(server, address, request, now)
```

Handle connect.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `server` | `dynamic` | — | server value consumed by this operation. |
| `address` | `dynamic` | — | address value consumed by this operation. |
| `request` | `dynamic` | — | request value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/server.ml#L195)

<a id="function-function-miniquake2-network-server-handleconnectionless-function-handleconnectionless-server-address-datagram-now-src-miniquake2-network-server-ml-336305720"></a>
### handleConnectionless

```ml
function handleConnectionless(server, address, datagram, now)
```

Handles connectionless for the miniquake2 network server workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `server` | `dynamic` | — | server value consumed by this operation. |
| `address` | `dynamic` | — | address value consumed by this operation. |
| `datagram` | `dynamic` | — | datagram value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/server.ml#L268)

<a id="function-function-miniquake2-network-server-haschallenge-function-haschallenge-server-address-src-miniquake2-network-server-ml-930801323"></a>
### hasChallenge

```ml
function hasChallenge(server, address)
```

Report whether has challenge.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `server` | `dynamic` | — | server value consumed by this operation. |
| `address` | `dynamic` | — | address value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/server.ml#L134)

<a id="function-function-miniquake2-network-server-heartbeatactions-function-heartbeatactions-server-masters-now-src-miniquake2-network-server-ml-1281410908"></a>
### heartbeatActions

```ml
function heartbeatActions(server, masters, now)
```

Return the heartbeat actions value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `server` | `dynamic` | — | server value consumed by this operation. |
| `masters` | `dynamic` | — | masters value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/server.ml#L450)

<a id="function-function-miniquake2-network-server-infostring-function-infostring-server-version-src-miniquake2-network-server-ml-2083719419"></a>
### infoString

```ml
function infoString(server, version)
```

Return the info string value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `server` | `dynamic` | — | server value consumed by this operation. |
| `version` | `dynamic` | — | version value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/server.ml#L83)

<a id="function-function-miniquake2-network-server-markspawned-function-markspawned-server-slot-src-miniquake2-network-server-ml-745383371"></a>
### markSpawned

```ml
function markSpawned(server, slot)
```

Mark spawned.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `server` | `dynamic` | — | server value consumed by this operation. |
| `slot` | `dynamic` | — | slot value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/server.ml#L361)

<a id="function-function-miniquake2-network-server-masterpingactions-function-masterpingactions-masters-src-miniquake2-network-server-ml-1420793407"></a>
### masterPingActions

```ml
function masterPingActions(masters)
```

Return the master ping actions value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `masters` | `dynamic` | — | masters value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/server.ml#L468)

<a id="function-function-miniquake2-network-server-nextchallenge-function-nextchallenge-server-src-miniquake2-network-server-ml-186131405"></a>
### nextChallenge

```ml
function nextChallenge(server)
```

Return the next challenge value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `server` | `dynamic` | — | server value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/server.ml#L93)

<a id="function-function-miniquake2-network-server-ratedrop-function-ratedrop-server-slot-framenumber-src-miniquake2-network-server-ml-529687731"></a>
### rateDrop

```ml
function rateDrop(server, slot, frameNumber)
```

sv_send.c: SV_RateDrop sums the previous ten 10 Hz datagram sizes. Remote clients over their advertised rate skip this frame and expose the number of skipped frames in the next svc_frame. Loopback is deliberately unlimited.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `server` | `dynamic` | — | server value consumed by this operation. |
| `slot` | `dynamic` | — | slot value consumed by this operation. |
| `frameNumber` | `dynamic` | — | frameNumber value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/server.ml#L412)

<a id="function-function-miniquake2-network-server-receivesequenced-function-receivesequenced-server-address-datagram-now-src-miniquake2-network-server-ml-1524909980"></a>
### receiveSequenced

```ml
function receiveSequenced(server, address, datagram, now)
```

Receive sequenced.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `server` | `dynamic` | — | server value consumed by this operation. |
| `address` | `dynamic` | — | address value consumed by this operation. |
| `datagram` | `dynamic` | — | datagram value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/server.ml#L298)

<a id="function-function-miniquake2-network-server-recordclientmessage-function-recordclientmessage-server-slot-framenumber-messagesize-src-miniquake2-network-server-ml-855124413"></a>
### recordClientMessage

```ml
function recordClientMessage(server, slot, frameNumber, messageSize)
```

Record client message.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `server` | `dynamic` | — | server value consumed by this operation. |
| `slot` | `dynamic` | — | slot value consumed by this operation. |
| `frameNumber` | `dynamic` | — | frameNumber value consumed by this operation. |
| `messageSize` | `dynamic` | — | messageSize value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/server.ml#L436)

<a id="function-function-miniquake2-network-server-reply-function-reply-kind-address-data-slot-text-src-miniquake2-network-server-ml-1908535987"></a>
### reply

```ml
function reply(kind, address, data, slot, text)
```

Return the reply value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `kind` | `dynamic` | — | kind value consumed by this operation. |
| `address` | `dynamic` | — | address value consumed by this operation. |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `slot` | `dynamic` | — | slot value consumed by this operation. |
| `text` | `dynamic` | — | Text consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/server.ml#L186)

<a id="function-function-miniquake2-network-server-sanitizedname-function-sanitizedname-userinfo-src-miniquake2-network-server-ml-489952329"></a>
### sanitizedName

```ml
function sanitizedName(userInfo)
```

Return the sanitized name.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `userInfo` | `dynamic` | — | userInfo value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/server.ml#L144)

<a id="function-function-miniquake2-network-server-shutdownactions-function-shutdownactions-server-masters-src-miniquake2-network-server-ml-1178736722"></a>
### shutdownActions

```ml
function shutdownActions(server, masters)
```

Shut down actions.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `server` | `dynamic` | — | server value consumed by this operation. |
| `masters` | `dynamic` | — | masters value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/server.ml#L484)

<a id="function-function-miniquake2-network-server-statusstring-function-statusstring-server-src-miniquake2-network-server-ml-46696201"></a>
### statusString

```ml
function statusString(server)
```

Return the status string value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `server` | `dynamic` | — | server value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/server.ml#L55)

<a id="function-function-miniquake2-network-server-writeclientframe-function-writeclientframe-server-slot-current-baselines-buffer-src-miniquake2-network-server-ml-443882740"></a>
### writeClientFrame

```ml
function writeClientFrame(server, slot, current, baselines, buffer)
```

Write client frame.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `server` | `dynamic` | — | server value consumed by this operation. |
| `slot` | `dynamic` | — | slot value consumed by this operation. |
| `current` | `dynamic` | — | current value consumed by this operation. |
| `baselines` | `dynamic` | — | baselines value consumed by this operation. |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/server.ml#L395)
