# `src/miniquake2/runtime/save_metadata.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 runtime save metadata facilities for this project.

Package: [`miniquake2.runtime.save_metadata`](Package-miniquake2-runtime-save-metadata-868275696.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/qcommon/byteio.ml` as `savemetadatabyteio` → [src/miniquake2/qcommon/byteio.ml](File-src-miniquake2-qcommon-byteio-ml-159119335.md)
- `miniquake2/qcommon/cmd.ml` as `savemetadatacmd` → [src/miniquake2/qcommon/cmd.ml](File-src-miniquake2-qcommon-cmd-ml-1514462021.md)
- `std/fs.ml` as `savemetadatafs` → `../MiniLangCompilerML/std/fs.ml` — external dependency
- `std/string.ml` as `savemetadatastring` → `../MiniLangCompilerML/std/string.ml` — external dependency

## Declarations

<a id="function-function-miniquake2-runtime-save-metadata-currenttimestamp-function-currenttimestamp-src-miniquake2-runtime-save-metadata-ml-590670384"></a>
### currentTimestamp

```ml
function currentTimestamp()
```

Return the current timestamp value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/save_metadata.ml#L55)

<a id="function-function-miniquake2-runtime-save-metadata-decode-function-decode-savemetadatadecodetext-src-miniquake2-runtime-save-metadata-ml-1088405071"></a>
### decode

```ml
function decode(saveMetadataDecodeText)
```

Decode state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `saveMetadataDecodeText` | `dynamic` | — | saveMetadataDecodeText value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/save_metadata.ml#L116)

<a id="function-function-miniquake2-runtime-save-metadata-encode-function-encode-savemetadataencodeinput-src-miniquake2-runtime-save-metadata-ml-1911733214"></a>
### encode

```ml
function encode(saveMetadataEncodeInput)
```

Encodes encode for the miniquake2 runtime save metadata workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `saveMetadataEncodeInput` | `dynamic` | — | saveMetadataEncodeInput value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/save_metadata.ml#L102)

<a id="function-function-miniquake2-runtime-save-metadata-fourdigits-function-fourdigits-savemetadatafourvalue-src-miniquake2-runtime-save-metadata-ml-192808939"></a>
### fourDigits

```ml
function fourDigits(saveMetadataFourValue)
```

Return the four digits value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `saveMetadataFourValue` | `dynamic` | — | saveMetadataFourValue value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/save_metadata.ml#L46)

<a id="extern_function-extern-function-miniquake2-runtime-save-metadata-getlocaltime-extern-function-getlocaltime-systemtime-as-bytes-from-kernel32-dll-returns-void-src-miniquake2-runtime-save-metadata-ml-1805584161"></a>
### GetLocalTime

```ml
extern function GetLocalTime(systemTime as bytes) from "kernel32.dll" returns void
```

Invokes the native GetLocalTime entry point used by the miniquake2 runtime save metadata module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `systemTime` | `bytes` | — | systemTime value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/save_metadata.ml#L20)

<a id="constant-constant-miniquake2-runtime-save-metadata-metadata-header-const-metadata-header-miniquake2slot-1-src-miniquake2-runtime-save-metadata-ml-462059308"></a>
### METADATA_HEADER

```ml
const METADATA_HEADER = "MiniQuake2Slot 1"
```

Defines the metadata header constant used by the miniquake2 runtime save metadata module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/save_metadata.ml#L16)

<a id="function-function-miniquake2-runtime-save-metadata-safetoken-function-safetoken-savemetadatasafevalue-src-miniquake2-runtime-save-metadata-ml-1999666578"></a>
### safeToken

```ml
function safeToken(saveMetadataSafeValue)
```

Return the safe token value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `saveMetadataSafeValue` | `dynamic` | — | saveMetadataSafeValue value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/save_metadata.ml#L73)

<a id="function-function-miniquake2-runtime-save-metadata-save-function-save-savemetadatasavepath-savemetadatasavevalue-src-miniquake2-runtime-save-metadata-ml-1981345940"></a>
### save

```ml
function save(saveMetadataSavePath, saveMetadataSaveValue)
```

Save state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `saveMetadataSavePath` | `dynamic` | — | Path associated with save metadata save. |
| `saveMetadataSaveValue` | `dynamic` | — | saveMetadataSaveValue value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/save_metadata.ml#L183)

- [miniquake2.runtime.save_metadata.SaveSlotMetadata](Type-miniquake2-runtime-save-metadata-saveslotmetadata-980186662.md) — struct
<a id="function-function-miniquake2-runtime-save-metadata-twodigits-function-twodigits-savemetadatatwovalue-src-miniquake2-runtime-save-metadata-ml-2037849389"></a>
### twoDigits

```ml
function twoDigits(saveMetadataTwoValue)
```

Return the two digits value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `saveMetadataTwoValue` | `dynamic` | — | saveMetadataTwoValue value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/save_metadata.ml#L36)

<a id="function-function-miniquake2-runtime-save-metadata-validate-function-validate-savemetadatavalidatevalue-src-miniquake2-runtime-save-metadata-ml-1518976145"></a>
### validate

```ml
function validate(saveMetadataValidateValue)
```

Validates validate for the miniquake2 runtime save metadata workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `saveMetadataValidateValue` | `dynamic` | — | saveMetadataValidateValue value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/save_metadata.ml#L87)
