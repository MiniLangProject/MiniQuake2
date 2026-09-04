# `src/miniquake2/network/runtime/transport.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 network runtime transport facilities for this project.

Package: [`miniquake2.network.runtime.transport`](Package-miniquake2-network-runtime-transport-176558022.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/network/constants.ml` as `nc` → [src/miniquake2/network/constants.ml](File-src-miniquake2-network-constants-ml-102415622.md)
- `miniquake2/qcommon/types.ml` as `qt` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)

## Declarations

<a id="function-function-miniquake2-network-runtime-transport-fromudp-function-fromudp-address-port-src-miniquake2-network-runtime-transport-ml-1386058252"></a>
### fromUdp

```ml
function fromUdp(address, port)
```

Return the from udp.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `address` | `dynamic` | — | address value consumed by this operation. |
| `port` | `dynamic` | — | port value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/transport.ml#L34)

<a id="function-function-miniquake2-network-runtime-transport-host-function-host-address-src-miniquake2-network-runtime-transport-ml-1953685619"></a>
### host

```ml
function host(address)
```

Return the host value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `address` | `dynamic` | — | address value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/transport.ml#L53)

<a id="function-function-miniquake2-network-runtime-transport-parseoctet-function-parseoctet-source-start-endindex-src-miniquake2-network-runtime-transport-ml-28417999"></a>
### parseOctet

```ml
function parseOctet(source, start, endIndex)
```

Parse octet.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `source` | `dynamic` | — | source value consumed by this operation. |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `endIndex` | `dynamic` | — | Zero-based index of end. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/transport.ml#L17)
