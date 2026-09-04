# `src/miniquake2/qcommon/info.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 qcommon info facilities for this project.

Package: [`miniquake2.qcommon.info`](Package-miniquake2-qcommon-info-398529579.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/qcommon/constants.ml` as `qc` → [src/miniquake2/qcommon/constants.ml](File-src-miniquake2-qcommon-constants-ml-1976195726.md)

## Declarations

<a id="function-function-miniquake2-qcommon-info-componentvalid-function-componentvalid-value-src-miniquake2-qcommon-info-ml-19581503"></a>
### componentValid

```ml
function componentValid(value)
```

Report whether component valid.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/info.ml#L14)

<a id="function-function-miniquake2-qcommon-info-pairs-function-pairs-info-src-miniquake2-qcommon-info-ml-381553594"></a>
### pairs

```ml
function pairs(info)
```

Return the pairs value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `info` | `dynamic` | — | info value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/info.ml#L27)

<a id="function-function-miniquake2-qcommon-info-removekey-function-removekey-info-requestedkey-src-miniquake2-qcommon-info-ml-753836953"></a>
### removeKey

```ml
function removeKey(info, requestedKey)
```

Remove key.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `info` | `dynamic` | — | info value consumed by this operation. |
| `requestedKey` | `dynamic` | — | requestedKey value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/info.ml#L74)

<a id="function-function-miniquake2-qcommon-info-setvalueforkey-function-setvalueforkey-info-key-value-src-miniquake2-qcommon-info-ml-115266360"></a>
### setValueForKey

```ml
function setValueForKey(info, key, value)
```

Set value for key.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `info` | `dynamic` | — | info value consumed by this operation. |
| `key` | `dynamic` | — | key value consumed by this operation. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/info.ml#L88)

<a id="function-function-miniquake2-qcommon-info-validate-function-validate-info-src-miniquake2-qcommon-info-ml-93266544"></a>
### validate

```ml
function validate(info)
```

Validates validate for the miniquake2 qcommon info workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `info` | `dynamic` | — | info value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/info.ml#L54)

<a id="function-function-miniquake2-qcommon-info-valueforkey-function-valueforkey-info-requestedkey-src-miniquake2-qcommon-info-ml-1165308509"></a>
### valueForKey

```ml
function valueForKey(info, requestedKey)
```

Return the value for key value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `info` | `dynamic` | — | info value consumed by this operation. |
| `requestedKey` | `dynamic` | — | requestedKey value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/info.ml#L63)
