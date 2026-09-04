# `src/miniquake2/platform/udp.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 platform udp facilities for this project.

Package: [`miniquake2.platform.udp`](Package-miniquake2-platform-udp-163327737.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/native.ml` as `native` → [src/miniquake2/native.ml](File-src-miniquake2-native-ml-139597585.md)

## Declarations

<a id="function-function-miniquake2-platform-udp-close-function-close-socket-src-miniquake2-platform-udp-ml-510890699"></a>
### close

```ml
function close(socket)
```

Close state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `socket` | `dynamic` | — | socket value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/platform/udp.ml#L46)

- [miniquake2.platform.udp.Datagram](Type-miniquake2-platform-udp-datagram-1480963790.md) — struct
<a id="function-function-miniquake2-platform-udp-enablebroadcast-function-enablebroadcast-socket-src-miniquake2-platform-udp-ml-1856722631"></a>
### enableBroadcast

```ml
function enableBroadcast(socket)
```

Return the enable broadcast value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `socket` | `dynamic` | — | socket value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/platform/udp.ml#L53)

<a id="function-function-miniquake2-platform-udp-open-function-open-address-port-src-miniquake2-platform-udp-ml-1589666075"></a>
### open

```ml
function open(address, port)
```

Opens open for the miniquake2 platform udp module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `address` | `dynamic` | — | address value consumed by this operation. |
| `port` | `dynamic` | — | port value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/platform/udp.ml#L37)

<a id="function-function-miniquake2-platform-udp-pending-function-pending-socket-src-miniquake2-platform-udp-ml-1449128381"></a>
### pending

```ml
function pending(socket)
```

Report whether pending.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `socket` | `dynamic` | — | socket value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/platform/udp.ml#L109)

<a id="function-function-miniquake2-platform-udp-receive-function-receive-socket-capacity-src-miniquake2-platform-udp-ml-890489093"></a>
### receive

```ml
function receive(socket, capacity)
```

Receive state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `socket` | `dynamic` | — | socket value consumed by this operation. |
| `capacity` | `dynamic` | — | capacity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/platform/udp.ml#L90)

<a id="function-function-miniquake2-platform-udp-resolvename-function-resolvename-name-src-miniquake2-platform-udp-ml-538195723"></a>
### resolveName

```ml
function resolveName(name)
```

Resolve name.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/platform/udp.ml#L63)

<a id="function-function-miniquake2-platform-udp-send-function-send-socket-address-port-data-src-miniquake2-platform-udp-ml-214076104"></a>
### send

```ml
function send(socket, address, port, data)
```

Send state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `socket` | `dynamic` | — | socket value consumed by this operation. |
| `address` | `dynamic` | — | address value consumed by this operation. |
| `port` | `dynamic` | — | port value consumed by this operation. |
| `data` | `dynamic` | — | Input data consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/platform/udp.ml#L79)

- [miniquake2.platform.udp.Socket](Type-miniquake2-platform-udp-socket-1097451964.md) — struct
