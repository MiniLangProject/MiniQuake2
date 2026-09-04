# `src/miniquake2/client/demo_recording.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 client demo recording facilities for this project.

Package: [`miniquake2.client.demo_recording`](Package-miniquake2-client-demo-recording-985688701.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/client/demo.ml` as `demorecorddemo` → [src/miniquake2/client/demo.ml](File-src-miniquake2-client-demo-ml-1496242839.md)
- `miniquake2/client/runtime/dispatcher.ml` as `demorecorddispatcher` → [src/miniquake2/client/runtime/dispatcher.ml](File-src-miniquake2-client-runtime-dispatcher-ml-506346494.md)
- `miniquake2/network/constants.ml` as `demorecordnetworkconstants` → [src/miniquake2/network/constants.ml](File-src-miniquake2-network-constants-ml-102415622.md)
- `miniquake2/network/runtime/messages.ml` as `demorecordmessages` → [src/miniquake2/network/runtime/messages.ml](File-src-miniquake2-network-runtime-messages-ml-904838874.md)
- `miniquake2/qcommon/constants.ml` as `demorecordqc` → [src/miniquake2/qcommon/constants.ml](File-src-miniquake2-qcommon-constants-ml-1976195726.md)
- `miniquake2/qcommon/sizebuf.ml` as `demorecordsizebuf` → [src/miniquake2/qcommon/sizebuf.ml](File-src-miniquake2-qcommon-sizebuf-ml-1769950759.md)
- `std/fs.ml` as `demorecordfs` → `../MiniLangCompilerML/std/fs.ml` — external dependency

## Declarations

<a id="function-function-miniquake2-client-demo-recording-appendbuffer-function-appendbuffer-demo-buffer-src-miniquake2-client-demo-recording-ml-956008929"></a>
### appendBuffer

```ml
function appendBuffer(demo, buffer)
```

Append buffer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `demo` | `dynamic` | — | demo value consumed by this operation. |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/demo_recording.ml#L79)

<a id="function-function-miniquake2-client-demo-recording-appendstartup-function-appendstartup-recording-src-miniquake2-client-demo-recording-ml-283024887"></a>
### appendStartup

```ml
function appendStartup(recording)
```

Append startup.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `recording` | `dynamic` | — | recording value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/demo_recording.ml#L87)

<a id="function-function-miniquake2-client-demo-recording-create-function-create-runtime-directory-src-miniquake2-client-demo-recording-ml-474487679"></a>
### create

```ml
function create(runtime, directory)
```

Creates create for the miniquake2 client demo recording module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `directory` | `dynamic` | — | directory value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/demo_recording.ml#L43)

<a id="extern_function-extern-function-miniquake2-client-demo-recording-createdirectoryw-extern-function-createdirectoryw-path-as-wstr-security-as-ptr-from-kernel32-dll-returns-bool-src-miniquake2-client-demo-recording-ml-970151001"></a>
### CreateDirectoryW

```ml
extern function CreateDirectoryW(path as wstr, security as ptr) from "kernel32.dll" returns bool
```

Invokes the native CreateDirectoryW entry point used by the miniquake2 client demo recording module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `wstr` | — | Path of the file or directory used by the operation. |
| `security` | `ptr` | — | security value consumed by this operation. |


**Returns:** Native bool result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/demo_recording.ml#L22)

- [miniquake2.client.demo_recording.DemoRecording](Type-miniquake2-client-demo-recording-demorecording-1137411065.md) — struct
<a id="function-function-miniquake2-client-demo-recording-ensuredirectory-function-ensuredirectory-path-src-miniquake2-client-demo-recording-ml-1134814385"></a>
### ensureDirectory

```ml
function ensureDirectory(path)
```

Ensure directory.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Path of the file or directory used by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/demo_recording.ml#L67)

<a id="function-function-miniquake2-client-demo-recording-safename-function-safename-name-src-miniquake2-client-demo-recording-ml-1580709371"></a>
### safeName

```ml
function safeName(name)
```

Return the safe name.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/demo_recording.ml#L52)

<a id="function-function-miniquake2-client-demo-recording-shutdown-function-shutdown-recording-src-miniquake2-client-demo-recording-ml-869473217"></a>
### shutdown

```ml
function shutdown(recording)
```

Performs the shutdown operation for the miniquake2 client demo recording module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `recording` | `dynamic` | — | recording value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/demo_recording.ml#L168)

<a id="function-function-miniquake2-client-demo-recording-start-function-start-recording-name-src-miniquake2-client-demo-recording-ml-1957137568"></a>
### start

```ml
function start(recording, name)
```

Starts start for the miniquake2 client demo recording workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `recording` | `dynamic` | — | recording value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/demo_recording.ml#L127)

<a id="function-function-miniquake2-client-demo-recording-stop-function-stop-recording-src-miniquake2-client-demo-recording-ml-1191743229"></a>
### stop

```ml
function stop(recording)
```

Stops stop for the miniquake2 client demo recording workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `recording` | `dynamic` | — | recording value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/demo_recording.ml#L147)
