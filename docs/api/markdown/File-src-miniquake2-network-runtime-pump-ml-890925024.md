# `src/miniquake2/network/runtime/pump.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 network runtime pump facilities for this project.

Package: [`miniquake2.network.runtime.pump`](Package-miniquake2-network-runtime-pump-1644298647.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/client/runtime/dispatcher.ml` as `crdispatcher` → [src/miniquake2/client/runtime/dispatcher.ml](File-src-miniquake2-client-runtime-dispatcher-ml-506346494.md)
- `miniquake2/client/runtime/handoff.ml` as `crhandoff` → [src/miniquake2/client/runtime/handoff.ml](File-src-miniquake2-client-runtime-handoff-ml-1879961007.md)
- `miniquake2/network/client.ml` as `nclient` → [src/miniquake2/network/client.ml](File-src-miniquake2-network-client-ml-1115555876.md)
- `miniquake2/network/constants.ml` as `nc` → [src/miniquake2/network/constants.ml](File-src-miniquake2-network-constants-ml-102415622.md)
- `miniquake2/network/runtime/commands.ml` as `rcommands` → [src/miniquake2/network/runtime/commands.ml](File-src-miniquake2-network-runtime-commands-ml-1067337840.md)
- `miniquake2/network/runtime/messages.ml` as `rmessages` → [src/miniquake2/network/runtime/messages.ml](File-src-miniquake2-network-runtime-messages-ml-904838874.md)
- `miniquake2/network/runtime/transport.ml` as `rtransport` → [src/miniquake2/network/runtime/transport.ml](File-src-miniquake2-network-runtime-transport-ml-1946942007.md)
- `miniquake2/network/runtime/types.ml` as `nrtypes` → [src/miniquake2/network/runtime/types.ml](File-src-miniquake2-network-runtime-types-ml-1235773127.md)
- `miniquake2/network/server.ml` as `nserver` → [src/miniquake2/network/server.ml](File-src-miniquake2-network-server-ml-562940856.md)
- `miniquake2/platform/udp.ml` as `pudp` → [src/miniquake2/platform/udp.ml](File-src-miniquake2-platform-udp-ml-357648233.md)
- `miniquake2/protocol/constants.ml` as `pc` → [src/miniquake2/protocol/constants.ml](File-src-miniquake2-protocol-constants-ml-642349806.md)
- `miniquake2/protocol/netchan.ml` as `pnetchan` → [src/miniquake2/protocol/netchan.ml](File-src-miniquake2-protocol-netchan-ml-626556964.md)
- `miniquake2/protocol/packet.ml` as `ppacket` → [src/miniquake2/protocol/packet.ml](File-src-miniquake2-protocol-packet-ml-1389758677.md)
- `miniquake2/qcommon/byteio.ml` as `qbio` → [src/miniquake2/qcommon/byteio.ml](File-src-miniquake2-qcommon-byteio-ml-159119335.md)
- `miniquake2/qcommon/sizebuf.ml` as `qsz` → [src/miniquake2/qcommon/sizebuf.ml](File-src-miniquake2-qcommon-sizebuf-ml-1769950759.md)
- `miniquake2/server/administration.ml` as `rpumpadmin` → [src/miniquake2/server/administration.ml](File-src-miniquake2-server-administration-ml-1444195484.md)

## Declarations

<a id="function-function-miniquake2-network-runtime-pump-calculatepings-function-calculatepings-runtime-src-miniquake2-network-runtime-pump-ml-1981845999"></a>
### calculatePings

```ml
function calculatePings(runtime)
```

SV_CalcPings averages the positive samples in frame_latency and publishes the result both on client_t and the corresponding game client.  Keeping the Game API write behind a callback avoids coupling the transport runtime to a concrete game implementation.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/pump.ml#L250)

<a id="function-function-miniquake2-network-runtime-pump-dispatchintegratedpayload-function-dispatchintegratedpayload-integrated-payload-sequence-now-src-miniquake2-network-runtime-pump-ml-651194447"></a>
### dispatchIntegratedPayload

```ml
function dispatchIntegratedPayload(integrated, payload, sequence, now)
```

Product client path: identical transport/Netchan handling, with accepted payloads committed through the transactional effects/snapshot/demo dispatcher instead of the legacy protocol-only parser.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `integrated` | `dynamic` | — | integrated value consumed by this operation. |
| `payload` | `dynamic` | — | payload value consumed by this operation. |
| `sequence` | `dynamic` | — | sequence value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/pump.ml#L126)

<a id="function-function-miniquake2-network-runtime-pump-expiretimedoutclients-function-expiretimedoutclients-runtime-now-src-miniquake2-network-runtime-pump-ml-1062018573"></a>
### expireTimedOutClients

```ml
function expireTimedOutClients(runtime, now)
```

SV_CheckTimeouts routes spawned clients through SV_DropClient before the slot is reclaimed.  SV_DropClient calls the game DLL's ClientDisconnect, which removes the player entity and other game-owned state.  Keep that callback boundary in the managed runtime; connected clients have not entered the game yet and therefore deliberately do not receive it.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/pump.ml#L225)

<a id="function-function-miniquake2-network-runtime-pump-flushclient-function-flushclient-runtime-socket-now-unreliable-stats-src-miniquake2-network-runtime-pump-ml-1342096152"></a>
### flushClient

```ml
function flushClient(runtime, socket, now, unreliable, stats)
```

Flush client.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `socket` | `dynamic` | — | socket value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |
| `unreliable` | `dynamic` | — | unreliable value consumed by this operation. |
| `stats` | `dynamic` | — | stats value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/pump.ml#L55)

<a id="function-function-miniquake2-network-runtime-pump-flushclientforpump-function-flushclientforpump-runtime-socket-now-stats-src-miniquake2-network-runtime-pump-ml-845481089"></a>
### flushClientForPump

```ml
function flushClientForPump(runtime, socket, now, stats)
```

CL_SendCmd throttles a connected (not yet active) client with no reliable work to one keepalive per second. The lower-level flushClient deliberately remains an unconditional Netchan transmit primitive for callers/tests.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `socket` | `dynamic` | — | socket value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |
| `stats` | `dynamic` | — | stats value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/pump.ml#L74)

<a id="function-function-miniquake2-network-runtime-pump-flushserverclient-function-flushserverclient-runtime-socket-slot-now-stats-src-miniquake2-network-runtime-pump-ml-503846737"></a>
### flushServerClient

```ml
function flushServerClient(runtime, socket, slot, now, stats)
```

Flush server client.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `socket` | `dynamic` | — | socket value consumed by this operation. |
| `slot` | `dynamic` | — | slot value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |
| `stats` | `dynamic` | — | stats value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/pump.ml#L187)

<a id="function-function-miniquake2-network-runtime-pump-pumpclient-function-pumpclient-runtime-socket-now-maximumpackets-src-miniquake2-network-runtime-pump-ml-479464905"></a>
### pumpClient

```ml
function pumpClient(runtime, socket, now, maximumPackets)
```

Pump client.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `socket` | `dynamic` | — | socket value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |
| `maximumPackets` | `dynamic` | — | maximumPackets value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/pump.ml#L87)

<a id="function-function-miniquake2-network-runtime-pump-pumpheartbeats-function-pumpheartbeats-serverruntime-serversocket-masters-now-src-miniquake2-network-runtime-pump-ml-477078813"></a>
### pumpHeartbeats

```ml
function pumpHeartbeats(serverRuntime, serverSocket, masters, now)
```

Master addresses are already-resolved managed endpoints. DNS discovery is a platform/bootstrap concern and deliberately stays outside this UDP pump.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `serverRuntime` | `dynamic` | — | serverRuntime value consumed by this operation. |
| `serverSocket` | `dynamic` | — | serverSocket value consumed by this operation. |
| `masters` | `dynamic` | — | masters value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/pump.ml#L363)

<a id="function-function-miniquake2-network-runtime-pump-pumpintegratedclient-function-pumpintegratedclient-integrated-socket-now-maximumpackets-src-miniquake2-network-runtime-pump-ml-195636580"></a>
### pumpIntegratedClient

```ml
function pumpIntegratedClient(integrated, socket, now, maximumPackets)
```

Pump integrated client.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `integrated` | `dynamic` | — | integrated value consumed by this operation. |
| `socket` | `dynamic` | — | socket value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |
| `maximumPackets` | `dynamic` | — | maximumPackets value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/pump.ml#L140)

<a id="function-function-miniquake2-network-runtime-pump-pumppair-function-pumppair-clientruntime-serverruntime-clientsocket-serversocket-now-maximumpackets-src-miniquake2-network-runtime-pump-ml-1630879490"></a>
### pumpPair

```ml
function pumpPair(clientRuntime, serverRuntime, clientSocket, serverSocket, now, maximumPackets)
```

Pump pair.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `clientRuntime` | `dynamic` | — | clientRuntime value consumed by this operation. |
| `serverRuntime` | `dynamic` | — | serverRuntime value consumed by this operation. |
| `clientSocket` | `dynamic` | — | clientSocket value consumed by this operation. |
| `serverSocket` | `dynamic` | — | serverSocket value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |
| `maximumPackets` | `dynamic` | — | maximumPackets value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/pump.ml#L348)

<a id="function-function-miniquake2-network-runtime-pump-pumpserver-function-pumpserver-runtime-socket-now-maximumpackets-src-miniquake2-network-runtime-pump-ml-325757265"></a>
### pumpServer

```ml
function pumpServer(runtime, socket, now, maximumPackets)
```

Pump server.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `socket` | `dynamic` | — | socket value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |
| `maximumPackets` | `dynamic` | — | maximumPackets value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/pump.ml#L337)

<a id="function-function-miniquake2-network-runtime-pump-pumpserverpaused-function-pumpserverpaused-runtime-socket-now-maximumpackets-paused-src-miniquake2-network-runtime-pump-ml-1763244363"></a>
### pumpServerPaused

```ml
function pumpServerPaused(runtime, socket, now, maximumPackets, paused)
```

Pump server paused.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `socket` | `dynamic` | — | socket value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |
| `maximumPackets` | `dynamic` | — | maximumPackets value consumed by this operation. |
| `paused` | `dynamic` | — | paused value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/pump.ml#L281)

<a id="function-function-miniquake2-network-runtime-pump-sendactions-function-sendactions-socket-actions-stats-src-miniquake2-network-runtime-pump-ml-585670772"></a>
### sendActions

```ml
function sendActions(socket, actions, stats)
```

Send actions.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `socket` | `dynamic` | — | socket value consumed by this operation. |
| `actions` | `dynamic` | — | actions value consumed by this operation. |
| `stats` | `dynamic` | — | stats value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/pump.ml#L42)

<a id="function-function-miniquake2-network-runtime-pump-senddatagram-function-senddatagram-socket-address-data-stats-src-miniquake2-network-runtime-pump-ml-408998479"></a>
### sendDatagram

```ml
function sendDatagram(socket, address, data, stats)
```

Send datagram.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `socket` | `dynamic` | — | socket value consumed by this operation. |
| `address` | `dynamic` | — | address value consumed by this operation. |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `stats` | `dynamic` | — | stats value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/pump.ml#L32)

<a id="function-function-miniquake2-network-runtime-pump-sendserverpayload-function-sendserverpayload-runtime-socket-slot-now-payload-src-miniquake2-network-runtime-pump-ml-300335766"></a>
### sendServerPayload

```ml
function sendServerPayload(runtime, socket, slot, now, payload)
```

Send one unreliable server payload while preserving any staged reliable bytes in the same Netchan packet. Runtime/session uses this for snapshots; the regular pump retains responsibility for pure ACK/reliable flushes.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `socket` | `dynamic` | — | socket value consumed by this operation. |
| `slot` | `dynamic` | — | slot value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |
| `payload` | `dynamic` | — | payload value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/pump.ml#L206)

<a id="function-function-miniquake2-network-runtime-pump-shutdownserver-function-shutdownserver-serverruntime-serversocket-src-miniquake2-network-runtime-pump-ml-353758376"></a>
### shutdownServer

```ml
function shutdownServer(serverRuntime, serverSocket)
```

Shut down server.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `serverRuntime` | `dynamic` | — | serverRuntime value consumed by this operation. |
| `serverSocket` | `dynamic` | — | serverSocket value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/pump.ml#L372)
