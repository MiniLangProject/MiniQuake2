# `src/miniquake2/network/address.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 network address facilities for this project.

Package: [`miniquake2.network.address`](Package-miniquake2-network-address-1938995393.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/network/constants.ml` as `nc` → [src/miniquake2/network/constants.ml](File-src-miniquake2-network-constants-ml-102415622.md)
- `miniquake2/qcommon/types.ml` as `qt` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)

## Declarations

<a id="function-function-miniquake2-network-address-compare-function-compare-first-second-src-miniquake2-network-address-ml-183261298"></a>
### compare

```ml
function compare(first, second)
```

Compare state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `dynamic` | — | first value consumed by this operation. |
| `second` | `dynamic` | — | second value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/address.ml#L60)

<a id="function-function-miniquake2-network-address-comparebase-function-comparebase-first-second-src-miniquake2-network-address-ml-1993250248"></a>
### compareBase

```ml
function compareBase(first, second)
```

Compare base.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `dynamic` | — | first value consumed by this operation. |
| `second` | `dynamic` | — | second value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/address.ml#L49)

<a id="function-function-miniquake2-network-address-copy-function-copy-address-src-miniquake2-network-address-ml-301340746"></a>
### copy

```ml
function copy(address)
```

Performs the copy operation for the miniquake2 network address module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `address` | `dynamic` | — | address value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/address.ml#L29)

<a id="function-function-miniquake2-network-address-copybytesorarray-function-copybytesorarray-values-src-miniquake2-network-address-ml-1961039602"></a>
### copyBytesOrArray

```ml
function copyBytesOrArray(values)
```

Copy bytes or array.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `values` | `dynamic` | — | values value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/address.ml#L17)

<a id="function-function-miniquake2-network-address-islocal-function-islocal-address-src-miniquake2-network-address-ml-127847760"></a>
### isLocal

```ml
function isLocal(address)
```

Report whether is local.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `address` | `dynamic` | — | address value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/address.ml#L66)

<a id="function-function-miniquake2-network-address-sameelements-function-sameelements-first-second-src-miniquake2-network-address-ml-1360342060"></a>
### sameElements

```ml
function sameElements(first, second)
```

Return the same elements value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `dynamic` | — | first value consumed by this operation. |
| `second` | `dynamic` | — | second value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/address.ml#L36)

<a id="function-function-miniquake2-network-address-text-function-text-address-src-miniquake2-network-address-ml-1678197310"></a>
### text

```ml
function text(address)
```

Return the text value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `address` | `dynamic` | — | address value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/address.ml#L72)
