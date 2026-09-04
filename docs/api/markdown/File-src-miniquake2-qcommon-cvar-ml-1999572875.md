# `src/miniquake2/qcommon/cvar.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 qcommon cvar facilities for this project.

Package: [`miniquake2.qcommon.cvar`](Package-miniquake2-qcommon-cvar-1369747893.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/qcommon/constants.ml` as `qc` → [src/miniquake2/qcommon/constants.ml](File-src-miniquake2-qcommon-constants-ml-1976195726.md)
- `miniquake2/qcommon/types.ml` as `qt` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)

## Declarations

<a id="function-function-miniquake2-qcommon-cvar-applylatched-function-applylatched-registry-src-miniquake2-qcommon-cvar-ml-1709697659"></a>
### applyLatched

```ml
function applyLatched(registry)
```

Apply latched.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `registry` | `dynamic` | — | registry value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/cvar.ml#L131)

<a id="function-function-miniquake2-qcommon-cvar-archivetext-function-archivetext-registry-src-miniquake2-qcommon-cvar-ml-1752152009"></a>
### archiveText

```ml
function archiveText(registry)
```

Serialize the CVAR_ARCHIVE subset in an executable Quake II config form.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `registry` | `dynamic` | — | registry value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/cvar.ml#L212)

<a id="function-function-miniquake2-qcommon-cvar-bitinfo-function-bitinfo-registry-flags-src-miniquake2-qcommon-cvar-ml-1932275966"></a>
### bitInfo

```ml
function bitInfo(registry, flags)
```

Return the bit info value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `registry` | `dynamic` | — | registry value consumed by this operation. |
| `flags` | `dynamic` | — | Bit flags controlling the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/cvar.ml#L165)

<a id="function-function-miniquake2-qcommon-cvar-command-function-command-registry-arguments-src-miniquake2-qcommon-cvar-ml-1999620721"></a>
### command

```ml
function command(registry, arguments)
```

Return the command value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `registry` | `dynamic` | — | registry value consumed by this operation. |
| `arguments` | `dynamic` | — | arguments value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/cvar.ml#L180)

<a id="function-function-miniquake2-qcommon-cvar-createregistry-function-createregistry-src-miniquake2-qcommon-cvar-ml-1245658140"></a>
### createRegistry

```ml
function createRegistry()
```

Create registry.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/cvar.ml#L22)

<a id="function-function-miniquake2-qcommon-cvar-find-function-find-registry-name-src-miniquake2-qcommon-cvar-ml-465550396"></a>
### find

```ml
function find(registry, name)
```

Finds find used by the miniquake2 qcommon cvar module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `registry` | `dynamic` | — | registry value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/cvar.ml#L29)

<a id="function-function-miniquake2-qcommon-cvar-forceset-function-forceset-registry-name-value-src-miniquake2-qcommon-cvar-ml-2029829535"></a>
### forceSet

```ml
function forceSet(registry, name, value)
```

Set force.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `registry` | `dynamic` | — | registry value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/cvar.ml#L105)

<a id="function-function-miniquake2-qcommon-cvar-fullset-function-fullset-registry-name-value-flags-src-miniquake2-qcommon-cvar-ml-1780773946"></a>
### fullSet

```ml
function fullSet(registry, name, value, flags)
```

Set full.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `registry` | `dynamic` | — | registry value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `flags` | `dynamic` | — | Bit flags controlling the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/cvar.ml#L114)

<a id="function-function-miniquake2-qcommon-cvar-get-function-get-registry-name-defaultvalue-flags-src-miniquake2-qcommon-cvar-ml-871504431"></a>
### get

```ml
function get(registry, name, defaultValue, flags)
```

Return state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `registry` | `dynamic` | — | registry value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |
| `defaultValue` | `dynamic` | — | defaultValue value consumed by this operation. |
| `flags` | `dynamic` | — | Bit flags controlling the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/cvar.ml#L53)

<a id="function-function-miniquake2-qcommon-cvar-infovaluevalid-function-infovaluevalid-value-src-miniquake2-qcommon-cvar-ml-876237399"></a>
### infoValueValid

```ml
function infoValueValid(value)
```

Report whether info value valid.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/cvar.ml#L38)

<a id="function-function-miniquake2-qcommon-cvar-listtext-function-listtext-registry-src-miniquake2-qcommon-cvar-ml-615573691"></a>
### listText

```ml
function listText(registry)
```

Return the stock cvarlist flags and values for a console frontend.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `registry` | `dynamic` | — | registry value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/cvar.ml#L224)

<a id="function-function-miniquake2-qcommon-cvar-numericvalue-function-numericvalue-text-src-miniquake2-qcommon-cvar-ml-933239743"></a>
### numericValue

```ml
function numericValue(text)
```

Performs the numericValue operation for the miniquake2 qcommon cvar module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `text` | `dynamic` | — | Text consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/cvar.ml#L15)

<a id="function-function-miniquake2-qcommon-cvar-set-function-set-registry-name-value-src-miniquake2-qcommon-cvar-ml-597405191"></a>
### set

```ml
function set(registry, name, value)
```

Set state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `registry` | `dynamic` | — | registry value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/cvar.ml#L97)

<a id="function-function-miniquake2-qcommon-cvar-set2-function-set2-registry-name-value-force-src-miniquake2-qcommon-cvar-ml-1085541908"></a>
### set2

```ml
function set2(registry, name, value, force)
```

Set 2.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `registry` | `dynamic` | — | registry value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `force` | `dynamic` | — | force value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/cvar.ml#L74)

<a id="function-function-miniquake2-qcommon-cvar-setcommand-function-setcommand-registry-arguments-src-miniquake2-qcommon-cvar-ml-766260695"></a>
### setCommand

```ml
function setCommand(registry, arguments)
```

Apply the stock `set <name> <value> [u|s]` console command. Returning text instead of printing keeps the qcommon service usable by client and server consoles without a platform dependency.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `registry` | `dynamic` | — | registry value consumed by this operation. |
| `arguments` | `dynamic` | — | arguments value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/cvar.ml#L194)

<a id="function-function-miniquake2-qcommon-cvar-variablestring-function-variablestring-registry-name-src-miniquake2-qcommon-cvar-ml-2137866684"></a>
### variableString

```ml
function variableString(registry, name)
```

Return the variable string value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `registry` | `dynamic` | — | registry value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/cvar.ml#L147)

<a id="function-function-miniquake2-qcommon-cvar-variablevalue-function-variablevalue-registry-name-src-miniquake2-qcommon-cvar-ml-1046841330"></a>
### variableValue

```ml
function variableValue(registry, name)
```

Return the variable value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `registry` | `dynamic` | — | registry value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/cvar.ml#L156)
