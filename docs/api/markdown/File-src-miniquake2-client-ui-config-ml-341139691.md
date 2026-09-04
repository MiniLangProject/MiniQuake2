# `src/miniquake2/client/ui/config.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 client ui config facilities for this project.

Package: [`miniquake2.client.ui.config`](Package-miniquake2-client-ui-config-1677809400.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/audio/mixer.ml` as `uiconfigmixer` → [src/miniquake2/audio/mixer.ml](File-src-miniquake2-audio-mixer-ml-976475642.md)
- `miniquake2/client/ui/constants.ml` as `uiconfigconstants` → [src/miniquake2/client/ui/constants.ml](File-src-miniquake2-client-ui-constants-ml-1004124106.md)
- `miniquake2/client/ui/keys.ml` as `uiconfigkeys` → [src/miniquake2/client/ui/keys.ml](File-src-miniquake2-client-ui-keys-ml-2076131853.md)
- `miniquake2/qcommon/byteio.ml` as `uiconfigbyteio` → [src/miniquake2/qcommon/byteio.ml](File-src-miniquake2-qcommon-byteio-ml-159119335.md)
- `miniquake2/qcommon/cmd.ml` as `uiconfigcmd` → [src/miniquake2/qcommon/cmd.ml](File-src-miniquake2-qcommon-cmd-ml-1514462021.md)
- `std/fs.ml` as `uiconfigfs` → `../MiniLangCompilerML/std/fs.ml` — external dependency
- `std/string.ml` as `uiconfigstring` → `../MiniLangCompilerML/std/string.ml` — external dependency

## Declarations

<a id="function-function-miniquake2-client-ui-config-applyproductconfig-function-applyproductconfig-config-input-commandstate-mixer-screen-src-miniquake2-client-ui-config-ml-1673822820"></a>
### applyProductConfig

```ml
function applyProductConfig(config, input, commandState, mixer, screen)
```

Apply product config.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `config` | `dynamic` | — | Configuration used by the operation. |
| `input` | `dynamic` | — | input value consumed by this operation. |
| `commandState` | `dynamic` | — | commandState value consumed by this operation. |
| `mixer` | `dynamic` | — | mixer value consumed by this operation. |
| `screen` | `dynamic` | — | screen value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/config.ml#L326)

<a id="function-function-miniquake2-client-ui-config-captureproductconfig-function-captureproductconfig-input-commandstate-mixer-screen-src-miniquake2-client-ui-config-ml-49513714"></a>
### captureProductConfig

```ml
function captureProductConfig(input, commandState, mixer, screen)
```

Capture product config.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `input` | `dynamic` | — | input value consumed by this operation. |
| `commandState` | `dynamic` | — | commandState value consumed by this operation. |
| `mixer` | `dynamic` | — | mixer value consumed by this operation. |
| `screen` | `dynamic` | — | screen value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/config.ml#L117)

<a id="constant-constant-miniquake2-client-ui-config-config-header-const-config-header-miniquake2config-3-src-miniquake2-client-ui-config-ml-1792019581"></a>
### CONFIG_HEADER

```ml
const CONFIG_HEADER = "MiniQuake2Config 3"
```

Defines the config header constant used by the miniquake2 client ui config module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/config.ml#L19)

<a id="constant-constant-miniquake2-client-ui-config-config-legacy-header-const-config-legacy-header-miniquake2config-1-src-miniquake2-client-ui-config-ml-735008145"></a>
### CONFIG_LEGACY_HEADER

```ml
const CONFIG_LEGACY_HEADER = "MiniQuake2Config 1"
```

Defines the config legacy header constant used by the miniquake2 client ui config module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/config.ml#L23)

<a id="constant-constant-miniquake2-client-ui-config-config-max-bindings-const-config-max-bindings-256-src-miniquake2-client-ui-config-ml-933809855"></a>
### CONFIG_MAX_BINDINGS

```ml
const CONFIG_MAX_BINDINGS = 256
```

Defines the config max bindings constant used by the miniquake2 client ui config module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/config.ml#L29)

<a id="constant-constant-miniquake2-client-ui-config-config-max-bytes-const-config-max-bytes-65536-src-miniquake2-client-ui-config-ml-1461035095"></a>
### CONFIG_MAX_BYTES

```ml
const CONFIG_MAX_BYTES = 65536
```

Defines the config max bytes constant used by the miniquake2 client ui config module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/config.ml#L25)

<a id="constant-constant-miniquake2-client-ui-config-config-max-lines-const-config-max-lines-512-src-miniquake2-client-ui-config-ml-873794148"></a>
### CONFIG_MAX_LINES

```ml
const CONFIG_MAX_LINES = 512
```

Defines the config max lines constant used by the miniquake2 client ui config module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/config.ml#L27)

<a id="constant-constant-miniquake2-client-ui-config-config-v2-header-const-config-v2-header-miniquake2config-2-src-miniquake2-client-ui-config-ml-975664370"></a>
### CONFIG_V2_HEADER

```ml
const CONFIG_V2_HEADER = "MiniQuake2Config 2"
```

Defines the config v2 header constant used by the miniquake2 client ui config module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/config.ml#L21)

<a id="function-function-miniquake2-client-ui-config-decodeproductconfig-function-decodeproductconfig-text-src-miniquake2-client-ui-config-ml-1041683924"></a>
### decodeProductConfig

```ml
function decodeProductConfig(text)
```

Decode product config.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `text` | `dynamic` | — | Text consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/config.ml#L202)

<a id="function-function-miniquake2-client-ui-config-encodeproductconfig-function-encodeproductconfig-config-src-miniquake2-client-ui-config-ml-2093990785"></a>
### encodeProductConfig

```ml
function encodeProductConfig(config)
```

Encode product config.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `config` | `dynamic` | — | Configuration used by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/config.ml#L146)

<a id="function-function-miniquake2-client-ui-config-loadproductconfig-function-loadproductconfig-path-src-miniquake2-client-ui-config-ml-951491048"></a>
### loadProductConfig

```ml
function loadProductConfig(path)
```

Load product config.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Path of the file or directory used by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/config.ml#L390)

- [miniquake2.client.ui.config.ProductConfig](Type-miniquake2-client-ui-config-productconfig-434436611.md) — struct
<a id="function-function-miniquake2-client-ui-config-productconfigencodednumber-function-productconfigencodednumber-value-src-miniquake2-client-ui-config-ml-233761212"></a>
### productConfigEncodedNumber

```ml
function productConfigEncodedNumber(value)
```

MiniLang renders an integral float as `3.`. The command tokenizer's numeric grammar deliberately rejects that spelling, so archive integral values as integers and retain the ordinary representation only for fractional values.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/config.ml#L138)

<a id="function-function-miniquake2-client-ui-config-productconfignumber-function-productconfignumber-token-name-src-miniquake2-client-ui-config-ml-1471423467"></a>
### productConfigNumber

```ml
function productConfigNumber(token, name)
```

Return the product config number.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `token` | `dynamic` | — | token value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/config.ml#L189)

<a id="function-function-miniquake2-client-ui-config-productconfigsafecommand-function-productconfigsafecommand-command-src-miniquake2-client-ui-config-ml-660094312"></a>
### productConfigSafeCommand

```ml
function productConfigSafeCommand(command)
```

Return the product config safe command value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `command` | `dynamic` | — | command value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/config.ml#L65)

<a id="function-function-miniquake2-client-ui-config-productconfigvalidate-function-productconfigvalidate-config-src-miniquake2-client-ui-config-ml-1854706245"></a>
### productConfigValidate

```ml
function productConfigValidate(config)
```

Validate product config.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `config` | `dynamic` | — | Configuration used by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/config.ml#L77)

<a id="function-function-miniquake2-client-ui-config-saveproductconfig-function-saveproductconfig-path-config-src-miniquake2-client-ui-config-ml-304212432"></a>
### saveProductConfig

```ml
function saveProductConfig(path, config)
```

Save product config.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Path of the file or directory used by the operation. |
| `config` | `dynamic` | — | Configuration used by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/config.ml#L368)

<a id="function-function-miniquake2-client-ui-config-selectproductconfig-function-selectproductconfig-path-handover-src-miniquake2-client-ui-config-ml-281725851"></a>
### selectProductConfig

```ml
function selectProductConfig(path, handover)
```

A live map-to-map snapshot is authoritative over disk. This mirrors the original client's process-lifetime Cvar/key tables while retaining the file as startup and crash-recovery storage.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Path of the file or directory used by the operation. |
| `handover` | `dynamic` | — | handover value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/config.ml#L360)
