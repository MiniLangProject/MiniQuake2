# `src/miniquake2/runtime/crash_report.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 runtime crash report facilities for this project.

Package: [`miniquake2.runtime.crash_report`](Package-miniquake2-runtime-crash-report-335669227.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/native.ml` as `crashnative` → [src/miniquake2/native.ml](File-src-miniquake2-native-ml-139597585.md)
- `miniquake2/runtime/save_metadata.ml` as `crashmetadata` → [src/miniquake2/runtime/save_metadata.ml](File-src-miniquake2-runtime-save-metadata-ml-601566230.md)
- `std/fs.ml` as `crashfs` → `../MiniLangCompilerML/std/fs.ml` — external dependency

## Declarations

<a id="constant-constant-miniquake2-runtime-crash-report-cf-unicodetext-const-cf-unicodetext-13-src-miniquake2-runtime-crash-report-ml-1470186459"></a>
### CF_UNICODETEXT

```ml
const CF_UNICODETEXT = 13
```

Defines the cf unicodetext constant used by the miniquake2 runtime crash report module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/crash_report.ml#L17)

<a id="extern_function-extern-function-miniquake2-runtime-crash-report-closeclipboard-extern-function-closeclipboard-from-user32-dll-symbol-closeclipboard-returns-bool-src-miniquake2-runtime-crash-report-ml-1506326404"></a>
### CloseClipboard

```ml
extern function CloseClipboard() from "user32.dll" symbol "CloseClipboard" returns bool
```

Invokes the native CloseClipboard entry point used by the miniquake2 runtime crash report module.


**Returns:** Native bool result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/crash_report.ml#L55)

<a id="function-function-miniquake2-runtime-crash-report-copytoclipboard-function-copytoclipboard-report-src-miniquake2-runtime-crash-report-ml-1925145654"></a>
### copyToClipboard

```ml
function copyToClipboard(report)
```

Publish the complete report to the Windows clipboard before showing it.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `report` | `dynamic` | — | report value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/crash_report.ml#L131)

<a id="constant-constant-miniquake2-runtime-crash-report-cp-utf8-const-cp-utf8-65001-src-miniquake2-runtime-crash-report-ml-1524705347"></a>
### CP_UTF8

```ml
const CP_UTF8 = 65001
```

Defines the cp utf8 constant used by the miniquake2 runtime crash report module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/crash_report.ml#L23)

<a id="constant-constant-miniquake2-runtime-crash-report-crash-report-path-const-crash-report-path-miniquake2-crash-log-src-miniquake2-runtime-crash-report-ml-2078296701"></a>
### CRASH_REPORT_PATH

```ml
const CRASH_REPORT_PATH = "miniquake2-crash.log"
```

Defines the crash report path constant used by the miniquake2 runtime crash report module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/crash_report.ml#L15)

<a id="extern_function-extern-function-miniquake2-runtime-crash-report-emptyclipboard-extern-function-emptyclipboard-from-user32-dll-symbol-emptyclipboard-returns-bool-src-miniquake2-runtime-crash-report-ml-1226576595"></a>
### EmptyClipboard

```ml
extern function EmptyClipboard() from "user32.dll" symbol "EmptyClipboard" returns bool
```

Invokes the native EmptyClipboard entry point used by the miniquake2 runtime crash report module.


**Returns:** Native bool result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/crash_report.ml#L47)

<a id="function-function-miniquake2-runtime-crash-report-format-function-format-caught-version-timestamp-src-miniquake2-runtime-crash-report-ml-362120340"></a>
### format

```ml
function format(caught, version, timestamp)
```

Format one caught MiniLang error without losing its original source origin.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `caught` | `dynamic` | — | caught value consumed by this operation. |
| `version` | `dynamic` | — | version value consumed by this operation. |
| `timestamp` | `dynamic` | — | timestamp value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/crash_report.ml#L95)

<a id="extern_function-extern-function-miniquake2-runtime-crash-report-globalalloc-extern-function-globalalloc-flags-as-u32-size-as-u64-from-kernel32-dll-symbol-globalalloc-returns-ptr-src-miniquake2-runtime-crash-report-ml-897281001"></a>
### GlobalAlloc

```ml
extern function GlobalAlloc(flags as u32, size as u64) from "kernel32.dll" symbol "GlobalAlloc" returns ptr
```

Invokes the native GlobalAlloc entry point used by the miniquake2 runtime crash report module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `flags` | `u32` | — | Bit flags controlling the operation. |
| `size` | `u64` | — | Size in the units required by the operation. |


**Returns:** Native ptr result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/crash_report.ml#L60)

<a id="extern_function-extern-function-miniquake2-runtime-crash-report-globalfree-extern-function-globalfree-memory-as-ptr-from-kernel32-dll-symbol-globalfree-returns-ptr-src-miniquake2-runtime-crash-report-ml-1138987166"></a>
### GlobalFree

```ml
extern function GlobalFree(memory as ptr) from "kernel32.dll" symbol "GlobalFree" returns ptr
```

Invokes the native GlobalFree entry point used by the miniquake2 runtime crash report module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `memory` | `ptr` | — | memory value consumed by this operation. |


**Returns:** Native ptr result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/crash_report.ml#L72)

<a id="extern_function-extern-function-miniquake2-runtime-crash-report-globallock-extern-function-globallock-memory-as-ptr-from-kernel32-dll-symbol-globallock-returns-ptr-src-miniquake2-runtime-crash-report-ml-2119774461"></a>
### GlobalLock

```ml
extern function GlobalLock(memory as ptr) from "kernel32.dll" symbol "GlobalLock" returns ptr
```

Invokes the native GlobalLock entry point used by the miniquake2 runtime crash report module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `memory` | `ptr` | — | memory value consumed by this operation. |


**Returns:** Native ptr result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/crash_report.ml#L64)

<a id="extern_function-extern-function-miniquake2-runtime-crash-report-globalunlock-extern-function-globalunlock-memory-as-ptr-from-kernel32-dll-symbol-globalunlock-returns-bool-src-miniquake2-runtime-crash-report-ml-106602546"></a>
### GlobalUnlock

```ml
extern function GlobalUnlock(memory as ptr) from "kernel32.dll" symbol "GlobalUnlock" returns bool
```

Invokes the native GlobalUnlock entry point used by the miniquake2 runtime crash report module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `memory` | `ptr` | — | memory value consumed by this operation. |


**Returns:** Native bool result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/crash_report.ml#L68)

<a id="constant-constant-miniquake2-runtime-crash-report-gmem-moveable-const-gmem-moveable-2-src-miniquake2-runtime-crash-report-ml-507239313"></a>
### GMEM_MOVEABLE

```ml
const GMEM_MOVEABLE = 2
```

Defines the gmem moveable constant used by the miniquake2 runtime crash report module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/crash_report.ml#L19)

<a id="constant-constant-miniquake2-runtime-crash-report-gmem-zeroinit-const-gmem-zeroinit-64-src-miniquake2-runtime-crash-report-ml-1710881823"></a>
### GMEM_ZEROINIT

```ml
const GMEM_ZEROINIT = 64
```

Defines the gmem zeroinit constant used by the miniquake2 runtime crash report module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/crash_report.ml#L21)

<a id="function-function-miniquake2-runtime-crash-report-handle-function-handle-caught-version-src-miniquake2-runtime-crash-report-ml-477027550"></a>
### handle

```ml
function handle(caught, version)
```

Persist, copy and display one otherwise-unhandled product error.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `caught` | `dynamic` | — | caught value consumed by this operation. |
| `version` | `dynamic` | — | version value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/crash_report.ml#L172)

<a id="constant-constant-miniquake2-runtime-crash-report-mb-iconerror-const-mb-iconerror-16-src-miniquake2-runtime-crash-report-ml-40855612"></a>
### MB_ICONERROR

```ml
const MB_ICONERROR = 16
```

Defines the mb iconerror constant used by the miniquake2 runtime crash report module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/crash_report.ml#L27)

<a id="constant-constant-miniquake2-runtime-crash-report-mb-ok-const-mb-ok-0-src-miniquake2-runtime-crash-report-ml-33965431"></a>
### MB_OK

```ml
const MB_OK = 0
```

Defines the mb ok constant used by the miniquake2 runtime crash report module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/crash_report.ml#L25)

<a id="constant-constant-miniquake2-runtime-crash-report-mb-setforeground-const-mb-setforeground-65536-src-miniquake2-runtime-crash-report-ml-1627588036"></a>
### MB_SETFOREGROUND

```ml
const MB_SETFOREGROUND = 65536
```

Defines the mb setforeground constant used by the miniquake2 runtime crash report module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/crash_report.ml#L29)

<a id="constant-constant-miniquake2-runtime-crash-report-mb-topmost-const-mb-topmost-262144-src-miniquake2-runtime-crash-report-ml-966435184"></a>
### MB_TOPMOST

```ml
const MB_TOPMOST = 262144
```

Defines the mb topmost constant used by the miniquake2 runtime crash report module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/crash_report.ml#L31)

<a id="extern_function-extern-function-miniquake2-runtime-crash-report-messageboxw-extern-function-messageboxw-owner-as-ptr-text-as-wstr-caption-as-wstr-style-as-u32-from-user32-dll-symbol-messageboxw-returns-i32-src-miniquake2-runtime-crash-report-ml-1994409010"></a>
### MessageBoxW

```ml
extern function MessageBoxW(owner as ptr, text as wstr, caption as wstr, style as u32) from "user32.dll" symbol "MessageBoxW" returns i32
```

Invokes the native MessageBoxW entry point used by the miniquake2 runtime crash report module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `owner` | `ptr` | — | owner value consumed by this operation. |
| `text` | `wstr` | — | Text consumed by the operation. |
| `caption` | `wstr` | — | caption value consumed by this operation. |
| `style` | `u32` | — | style value consumed by this operation. |


**Returns:** Native i32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/crash_report.ml#L39)

<a id="extern_function-extern-function-miniquake2-runtime-crash-report-multibytetowidechar-extern-function-multibytetowidechar-codepage-as-u32-flags-as-u32-source-as-bytes-sourcecount-as-i32-output-as-bytes-outputcount-as-i32-from-kernel32-dll-symbol-multibytetowidechar-returns-i32-src-miniquake2-runtime-crash-report-ml-1218900092"></a>
### MultiByteToWideChar

```ml
extern function MultiByteToWideChar(codePage as u32, flags as u32, source as bytes, sourceCount as i32, output as bytes, outputCount as i32) from "kernel32.dll" symbol "MultiByteToWideChar" returns i32
```

Invokes the native MultiByteToWideChar entry point used by the miniquake2 runtime crash report module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `codePage` | `u32` | — | codePage value consumed by this operation. |
| `flags` | `u32` | — | Bit flags controlling the operation. |
| `source` | `bytes` | — | source value consumed by this operation. |
| `sourceCount` | `i32` | — | Number of source to process. |
| `output` | `bytes` | — | Output collection or buffer populated by the operation. |
| `outputCount` | `i32` | — | Number of output to process. |


**Returns:** Native i32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/crash_report.ml#L81)

<a id="extern_function-extern-function-miniquake2-runtime-crash-report-openclipboard-extern-function-openclipboard-owner-as-ptr-from-user32-dll-symbol-openclipboard-returns-bool-src-miniquake2-runtime-crash-report-ml-453101061"></a>
### OpenClipboard

```ml
extern function OpenClipboard(owner as ptr) from "user32.dll" symbol "OpenClipboard" returns bool
```

Invokes the native OpenClipboard entry point used by the miniquake2 runtime crash report module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `owner` | `ptr` | — | owner value consumed by this operation. |


**Returns:** Native bool result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/crash_report.ml#L44)

<a id="function-function-miniquake2-runtime-crash-report-preparedesktop-function-preparedesktop-src-miniquake2-runtime-crash-report-ml-775078232"></a>
### prepareDesktop

```ml
function prepareDesktop()
```

Leave exclusive display mode and release mouse capture before a modal error.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/crash_report.ml#L162)

<a id="extern_function-extern-function-miniquake2-runtime-crash-report-rtlmovememorytoptr-extern-function-rtlmovememorytoptr-destination-as-ptr-source-as-bytes-length-as-u64-from-kernel32-dll-symbol-rtlmovememory-returns-void-src-miniquake2-runtime-crash-report-ml-510198329"></a>
### RtlMoveMemoryToPtr

```ml
extern function RtlMoveMemoryToPtr(destination as ptr, source as bytes, length as u64) from "kernel32.dll" symbol "RtlMoveMemory" returns void
```

Invokes the native RtlMoveMemoryToPtr entry point used by the miniquake2 runtime crash report module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `destination` | `ptr` | — | destination value consumed by this operation. |
| `source` | `bytes` | — | source value consumed by this operation. |
| `length` | `u64` | — | length value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/crash_report.ml#L88)

<a id="extern_function-extern-function-miniquake2-runtime-crash-report-setclipboarddata-extern-function-setclipboarddata-format-as-u32-memory-as-ptr-from-user32-dll-symbol-setclipboarddata-returns-ptr-src-miniquake2-runtime-crash-report-ml-896544396"></a>
### SetClipboardData

```ml
extern function SetClipboardData(format as u32, memory as ptr) from "user32.dll" symbol "SetClipboardData" returns ptr
```

Invokes the native SetClipboardData entry point used by the miniquake2 runtime crash report module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `format` | `u32` | — | format value consumed by this operation. |
| `memory` | `ptr` | — | memory value consumed by this operation. |


**Returns:** Native ptr result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/crash_report.ml#L52)

<a id="function-function-miniquake2-runtime-crash-report-utf16bytes-function-utf16bytes-text-src-miniquake2-runtime-crash-report-ml-528827583"></a>
### utf16Bytes

```ml
function utf16Bytes(text)
```

Convert managed UTF-8 text to the NUL-terminated UTF-16 clipboard format.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `text` | `dynamic` | — | Text consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/crash_report.ml#L118)
