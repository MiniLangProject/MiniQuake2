# `src/miniquake2/network/types.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 network types facilities for this project.

Package: [`miniquake2.network.types`](Package-miniquake2-network-types-596979528.md)

Reachable from entry: **yes**

## Declarations

<a id="function-function-miniquake2-network-types-action-function-action-kind-address-data-slot-text-src-miniquake2-network-types-ml-1880969871"></a>
### action

```ml
function action(kind, address, data, slot, text)
```

Performs the action operation for the miniquake2 network types module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `kind` | `dynamic` | — | kind value consumed by this operation. |
| `address` | `dynamic` | — | address value consumed by this operation. |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `slot` | `dynamic` | — | slot value consumed by this operation. |
| `text` | `dynamic` | — | Text consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/types.ml#L196)

- [miniquake2.network.types.Challenge](Type-miniquake2-network-types-challenge-945830403.md) — struct
- [miniquake2.network.types.ClientState](Type-miniquake2-network-types-clientstate-107057682.md) — struct
- [miniquake2.network.types.ConnectionlessRequest](Type-miniquake2-network-types-connectionlessrequest-1941496784.md) — struct
- [miniquake2.network.types.Frame](Type-miniquake2-network-types-frame-762058275.md) — struct
- [miniquake2.network.types.HandleResult](Type-miniquake2-network-types-handleresult-1850803221.md) — struct
- [miniquake2.network.types.NetworkAction](Type-miniquake2-network-types-networkaction-1771525002.md) — struct
<a id="function-function-miniquake2-network-types-result-function-result-accepted-slot-actions-message-payload-src-miniquake2-network-types-ml-275911889"></a>
### result

```ml
function result(accepted, slot, actions, message, payload)
```

Performs the result operation for the miniquake2 network types module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `accepted` | `dynamic` | — | accepted value consumed by this operation. |
| `slot` | `dynamic` | — | slot value consumed by this operation. |
| `actions` | `dynamic` | — | actions value consumed by this operation. |
| `message` | `dynamic` | — | Human-readable message associated with the operation. |
| `payload` | `dynamic` | — | payload value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/types.ml#L206)

- [miniquake2.network.types.ServerClient](Type-miniquake2-network-types-serverclient-636064478.md) — struct
- [miniquake2.network.types.ServerState](Type-miniquake2-network-types-serverstate-1876415158.md) — struct
