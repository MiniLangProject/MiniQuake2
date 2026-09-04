# `src/miniquake2/client/downloads.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 client downloads facilities for this project.

Package: [`miniquake2.client.downloads`](Package-miniquake2-client-downloads-1183649555.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/format/bsp.ml` as `cdlbsp` → [src/miniquake2/format/bsp.ml](File-src-miniquake2-format-bsp-ml-2080213539.md)
- `miniquake2/format/md2.ml` as `cdlmd2` → [src/miniquake2/format/md2.ml](File-src-miniquake2-format-md2-ml-1028614507.md)
- `miniquake2/qcommon/byteio.ml` as `cdlbio` → [src/miniquake2/qcommon/byteio.ml](File-src-miniquake2-qcommon-byteio-ml-159119335.md)
- `miniquake2/qcommon/checksum.ml` as `cdlchecksum` → [src/miniquake2/qcommon/checksum.ml](File-src-miniquake2-qcommon-checksum-ml-2099292824.md)
- `miniquake2/qcommon/constants.ml` as `cdlqc` → [src/miniquake2/qcommon/constants.ml](File-src-miniquake2-qcommon-constants-ml-1976195726.md)
- `miniquake2/qcommon/filesystem.ml` as `cdlqfs` → [src/miniquake2/qcommon/filesystem.ml](File-src-miniquake2-qcommon-filesystem-ml-828451784.md)
- `std/fs.ml` as `cdlfs` → `../MiniLangCompilerML/std/fs.ml` — external dependency

## Declarations

<a id="function-function-miniquake2-client-downloads-acceptchunk-function-acceptchunk-manager-data-percent-missing-src-miniquake2-client-downloads-ml-245540318"></a>
### acceptChunk

```ml
function acceptChunk(manager, data, percent, missing)
```

Accept chunk.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `manager` | `dynamic` | — | manager value consumed by this operation. |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `percent` | `dynamic` | — | percent value consumed by this operation. |
| `missing` | `dynamic` | — | missing value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/downloads.ml#L663)

<a id="function-function-miniquake2-client-downloads-addrequest-function-addrequest-manager-kind-requestedname-src-miniquake2-client-downloads-ml-621536450"></a>
### addRequest

```ml
function addRequest(manager, kind, requestedName)
```

Add request.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `manager` | `dynamic` | — | manager value consumed by this operation. |
| `kind` | `dynamic` | — | kind value consumed by this operation. |
| `requestedName` | `dynamic` | — | requestedName value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/downloads.ml#L279)

<a id="function-function-miniquake2-client-downloads-advance-function-advance-manager-src-miniquake2-client-downloads-ml-926167751"></a>
### advance

```ml
function advance(manager)
```

Performs the advance operation for the miniquake2 client downloads module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `manager` | `dynamic` | — | manager value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/downloads.ml#L563)

<a id="function-function-miniquake2-client-downloads-appendchunk-function-appendchunk-path-data-src-miniquake2-client-downloads-ml-35283479"></a>
### appendChunk

```ml
function appendChunk(path, data)
```

Append chunk.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Path of the file or directory used by the operation. |
| `data` | `dynamic` | — | Input data consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/downloads.ml#L408)

<a id="function-function-miniquake2-client-downloads-beginprecache-function-beginprecache-manager-configstrings-spawncount-src-miniquake2-client-downloads-ml-1429838561"></a>
### beginPrecache

```ml
function beginPrecache(manager, configStrings, spawnCount)
```

Begin precache.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `manager` | `dynamic` | — | manager value consumed by this operation. |
| `configStrings` | `dynamic` | — | configStrings value consumed by this operation. |
| `spawnCount` | `dynamic` | — | Number of spawn to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/downloads.ml#L604)

<a id="function-function-miniquake2-client-downloads-buildprecacheplan-function-buildprecacheplan-manager-configstrings-src-miniquake2-client-downloads-ml-764064555"></a>
### buildPrecachePlan

```ml
function buildPrecachePlan(manager, configStrings)
```

Build precache plan.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `manager` | `dynamic` | — | manager value consumed by this operation. |
| `configStrings` | `dynamic` | — | configStrings value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/downloads.ml#L463)

<a id="function-function-miniquake2-client-downloads-cancel-function-cancel-manager-src-miniquake2-client-downloads-ml-189895403"></a>
### cancel

```ml
function cancel(manager)
```

Cancel state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `manager` | `dynamic` | — | manager value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/downloads.ml#L256)

<a id="function-function-miniquake2-client-downloads-classicpolicy-function-classicpolicy-allow-maps-models-players-sounds-src-miniquake2-client-downloads-ml-1056820956"></a>
### classicPolicy

```ml
function classicPolicy(allow, maps, models, players, sounds)
```

Original menu/cvars expose no separate image switch: pics follow the global allow_download value. Keep this adapter as the single product/UI mapping.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `allow` | `dynamic` | — | allow value consumed by this operation. |
| `maps` | `dynamic` | — | maps value consumed by this operation. |
| `models` | `dynamic` | — | models value consumed by this operation. |
| `players` | `dynamic` | — | players value consumed by this operation. |
| `sounds` | `dynamic` | — | sounds value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/downloads.ml#L175)

<a id="extern_function-extern-function-miniquake2-client-downloads-closehandle-extern-function-closehandle-handle-as-ptr-from-kernel32-dll-returns-bool-src-miniquake2-client-downloads-ml-1369750910"></a>
### CloseHandle

```ml
extern function CloseHandle(handle as ptr) from "kernel32.dll" returns bool
```

Invokes the native CloseHandle entry point used by the miniquake2 client downloads module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `handle` | `ptr` | — | Native or runtime handle used by the operation. |


**Returns:** Native bool result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/downloads.ml#L85)

<a id="function-function-miniquake2-client-downloads-create-function-create-basedirectory-gamedirectory-policy-fileexists-readfile-registerasset-src-miniquake2-client-downloads-ml-1303738246"></a>
### create

```ml
function create(baseDirectory, gameDirectory, policy, fileExists, readFile, registerAsset)
```

Creates create for the miniquake2 client downloads module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `gameDirectory` | `dynamic` | — | gameDirectory value consumed by this operation. |
| `policy` | `dynamic` | — | policy value consumed by this operation. |
| `fileExists` | `dynamic` | — | fileExists value consumed by this operation. |
| `readFile` | `dynamic` | — | readFile value consumed by this operation. |
| `registerAsset` | `dynamic` | — | registerAsset value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/downloads.ml#L209)

<a id="extern_function-extern-function-miniquake2-client-downloads-createdirectoryw-extern-function-createdirectoryw-path-as-wstr-security-as-ptr-from-kernel32-dll-returns-bool-src-miniquake2-client-downloads-ml-1708306777"></a>
### CreateDirectoryW

```ml
extern function CreateDirectoryW(path as wstr, security as ptr) from "kernel32.dll" returns bool
```

Invokes the native CreateDirectoryW entry point used by the miniquake2 client downloads module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `wstr` | — | Path of the file or directory used by the operation. |
| `security` | `ptr` | — | security value consumed by this operation. |


**Returns:** Native bool result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/downloads.ml#L49)

<a id="extern_function-extern-function-miniquake2-client-downloads-createfilew-extern-function-createfilew-path-as-wstr-access-as-int-share-as-int-security-as-ptr-creation-as-int-flags-as-int-template-as-ptr-from-kernel32-dll-returns-ptr-src-miniquake2-client-downloads-ml-1834670872"></a>
### CreateFileW

```ml
extern function CreateFileW(path as wstr, access as int, share as int, security as ptr, creation as int, flags as int, template as ptr) from "kernel32.dll" returns ptr
```

Invokes the native CreateFileW entry point used by the miniquake2 client downloads module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `wstr` | — | Path of the file or directory used by the operation. |
| `access` | `int` | — | access value consumed by this operation. |
| `share` | `int` | — | share value consumed by this operation. |
| `security` | `ptr` | — | security value consumed by this operation. |
| `creation` | `int` | — | creation value consumed by this operation. |
| `flags` | `int` | — | Bit flags controlling the operation. |
| `template` | `ptr` | — | template value consumed by this operation. |


**Returns:** Native ptr result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/downloads.ml#L59)

<a id="function-function-miniquake2-client-downloads-defaultpolicy-function-defaultpolicy-src-miniquake2-client-downloads-ml-1097748500"></a>
### defaultPolicy

```ml
function defaultPolicy()
```

Return the default policy value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/downloads.ml#L164)

<a id="function-function-miniquake2-client-downloads-discoverdependencies-function-discoverdependencies-manager-request-src-miniquake2-client-downloads-ml-1695867058"></a>
### discoverDependencies

```ml
function discoverDependencies(manager, request)
```

Discover dependencies.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `manager` | `dynamic` | — | manager value consumed by this operation. |
| `request` | `dynamic` | — | request value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/downloads.ml#L532)

- [miniquake2.client.downloads.DownloadManager](Type-miniquake2-client-downloads-downloadmanager-2226882.md) — struct
- [miniquake2.client.downloads.DownloadPolicy](Type-miniquake2-client-downloads-downloadpolicy-884283157.md) — struct
- [miniquake2.client.downloads.DownloadRequest](Type-miniquake2-client-downloads-downloadrequest-1965190892.md) — struct
<a id="function-function-miniquake2-client-downloads-ensureparentdirectory-function-ensureparentdirectory-path-src-miniquake2-client-downloads-ml-1192386427"></a>
### ensureParentDirectory

```ml
function ensureParentDirectory(path)
```

Ensure parent directory.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Path of the file or directory used by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/downloads.ml#L385)

<a id="constant-constant-miniquake2-client-downloads-file-attribute-normal-const-file-attribute-normal-128-src-miniquake2-client-downloads-ml-971242878"></a>
### FILE_ATTRIBUTE_NORMAL

```ml
const FILE_ATTRIBUTE_NORMAL = 128
```

Defines the file attribute normal constant used by the miniquake2 client downloads module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/downloads.ml#L37)

<a id="constant-constant-miniquake2-client-downloads-file-end-const-file-end-2-src-miniquake2-client-downloads-ml-367286565"></a>
### FILE_END

```ml
const FILE_END = 2
```

Defines the file end constant used by the miniquake2 client downloads module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/downloads.ml#L39)

<a id="constant-constant-miniquake2-client-downloads-file-share-read-const-file-share-read-1-src-miniquake2-client-downloads-ml-2001499280"></a>
### FILE_SHARE_READ

```ml
const FILE_SHARE_READ = 1
```

Defines the file share read constant used by the miniquake2 client downloads module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/downloads.ml#L33)

<a id="function-function-miniquake2-client-downloads-finishcurrent-function-finishcurrent-manager-src-miniquake2-client-downloads-ml-2006734171"></a>
### finishCurrent

```ml
function finishCurrent(manager)
```

Finish current.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `manager` | `dynamic` | — | manager value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/downloads.ml#L628)

<a id="extern_function-extern-function-miniquake2-client-downloads-flushfilebuffers-extern-function-flushfilebuffers-handle-as-ptr-from-kernel32-dll-returns-bool-src-miniquake2-client-downloads-ml-962651136"></a>
### FlushFileBuffers

```ml
extern function FlushFileBuffers(handle as ptr) from "kernel32.dll" returns bool
```

Invokes the native FlushFileBuffers entry point used by the miniquake2 client downloads module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `handle` | `ptr` | — | Native or runtime handle used by the operation. |


**Returns:** Native bool result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/downloads.ml#L81)

<a id="constant-constant-miniquake2-client-downloads-generic-write-const-generic-write-1073741824-src-miniquake2-client-downloads-ml-654889386"></a>
### GENERIC_WRITE

```ml
const GENERIC_WRITE = 1073741824
```

Defines the generic write constant used by the miniquake2 client downloads module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/downloads.ml#L31)

<a id="function-function-miniquake2-client-downloads-ignoreregister-function-ignoreregister-kind-name-src-miniquake2-client-downloads-ml-1245444519"></a>
### ignoreRegister

```ml
function ignoreRegister(kind, name)
```

Ignore register.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `kind` | `dynamic` | — | kind value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/downloads.ml#L182)

<a id="constant-constant-miniquake2-client-downloads-invalid-handle-value-const-invalid-handle-value-1-src-miniquake2-client-downloads-ml-890922087"></a>
### INVALID_HANDLE_VALUE

```ml
const INVALID_HANDLE_VALUE = -1
```

Defines the invalid handle value constant used by the miniquake2 client downloads module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/downloads.ml#L41)

<a id="constant-constant-miniquake2-client-downloads-invalid-set-file-pointer-const-invalid-set-file-pointer-4294967295-src-miniquake2-client-downloads-ml-210573078"></a>
### INVALID_SET_FILE_POINTER

```ml
const INVALID_SET_FILE_POINTER = 4294967295
```

Defines the invalid set file pointer constant used by the miniquake2 client downloads module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/downloads.ml#L43)

<a id="constant-constant-miniquake2-client-downloads-max-download-commands-const-max-download-commands-16-src-miniquake2-client-downloads-ml-596576602"></a>
### MAX_DOWNLOAD_COMMANDS

```ml
const MAX_DOWNLOAD_COMMANDS = 16
```

Defines the max download commands constant used by the miniquake2 client downloads module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/downloads.ml#L25)

<a id="constant-constant-miniquake2-client-downloads-max-download-file-bytes-const-max-download-file-bytes-2147483647-src-miniquake2-client-downloads-ml-1046316447"></a>
### MAX_DOWNLOAD_FILE_BYTES

```ml
const MAX_DOWNLOAD_FILE_BYTES = 2147483647
```

Defines the max download file bytes constant used by the miniquake2 client downloads module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/downloads.ml#L29)

<a id="constant-constant-miniquake2-client-downloads-max-download-missing-const-max-download-missing-1024-src-miniquake2-client-downloads-ml-1106851396"></a>
### MAX_DOWNLOAD_MISSING

```ml
const MAX_DOWNLOAD_MISSING = 1024
```

Defines the max download missing constant used by the miniquake2 client downloads module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/downloads.ml#L27)

<a id="constant-constant-miniquake2-client-downloads-max-download-requests-const-max-download-requests-4096-src-miniquake2-client-downloads-ml-26371362"></a>
### MAX_DOWNLOAD_REQUESTS

```ml
const MAX_DOWNLOAD_REQUESTS = 4096
```

Defines the max download requests constant used by the miniquake2 client downloads module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/downloads.ml#L23)

<a id="function-function-miniquake2-client-downloads-missingfiles-function-missingfiles-manager-src-miniquake2-client-downloads-ml-796887399"></a>
### missingFiles

```ml
function missingFiles(manager)
```

Report whether missing files.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `manager` | `dynamic` | — | manager value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/downloads.ml#L336)

<a id="function-function-miniquake2-client-downloads-notemissing-function-notemissing-manager-name-src-miniquake2-client-downloads-ml-1082215948"></a>
### noteMissing

```ml
function noteMissing(manager, name)
```

Report whether note missing.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `manager` | `dynamic` | — | manager value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/downloads.ml#L326)

<a id="constant-constant-miniquake2-client-downloads-open-always-const-open-always-4-src-miniquake2-client-downloads-ml-994286665"></a>
### OPEN_ALWAYS

```ml
const OPEN_ALWAYS = 4
```

Defines the open always constant used by the miniquake2 client downloads module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/downloads.ml#L35)

<a id="function-function-miniquake2-client-downloads-persistenceroot-function-persistenceroot-manager-name-src-miniquake2-client-downloads-ml-1244991898"></a>
### persistenceRoot

```ml
function persistenceRoot(manager, name)
```

Return the persistence root value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `manager` | `dynamic` | — | manager value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/downloads.ml#L349)

<a id="function-function-miniquake2-client-downloads-persistentpath-function-persistentpath-manager-name-src-miniquake2-client-downloads-ml-1232920692"></a>
### persistentPath

```ml
function persistentPath(manager, name)
```

Return the persistent path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `manager` | `dynamic` | — | manager value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/downloads.ml#L360)

<a id="function-function-miniquake2-client-downloads-playeridentity-function-playeridentity-value-src-miniquake2-client-downloads-ml-308910149"></a>
### playerIdentity

```ml
function playerIdentity(value)
```

Return the player identity value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/downloads.ml#L439)

<a id="function-function-miniquake2-client-downloads-policyallows-function-policyallows-policy-kind-src-miniquake2-client-downloads-ml-926896462"></a>
### policyAllows

```ml
function policyAllows(policy, kind)
```

Report whether policy allows.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `policy` | `dynamic` | — | policy value consumed by this operation. |
| `kind` | `dynamic` | — | kind value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/downloads.ml#L265)

<a id="function-function-miniquake2-client-downloads-queuecommand-function-queuecommand-manager-command-src-miniquake2-client-downloads-ml-1888243326"></a>
### queueCommand

```ml
function queueCommand(manager, command)
```

Queue command.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `manager` | `dynamic` | — | manager value consumed by this operation. |
| `command` | `dynamic` | — | command value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/downloads.ml#L301)

<a id="function-function-miniquake2-client-downloads-requestfile-function-requestfile-manager-kind-name-spawncount-src-miniquake2-client-downloads-ml-1753394470"></a>
### requestFile

```ml
function requestFile(manager, kind, name, spawnCount)
```

Return the request file value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `manager` | `dynamic` | — | manager value consumed by this operation. |
| `kind` | `dynamic` | — | kind value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |
| `spawnCount` | `dynamic` | — | Number of spawn to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/downloads.ml#L619)

<a id="function-function-miniquake2-client-downloads-reset-function-reset-manager-src-miniquake2-client-downloads-ml-16030697"></a>
### reset

```ml
function reset(manager)
```

Performs the reset operation for the miniquake2 client downloads module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `manager` | `dynamic` | — | manager value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/downloads.ml#L242)

<a id="extern_function-extern-function-miniquake2-client-downloads-setfilepointer-extern-function-setfilepointer-handle-as-ptr-distance-as-int-high-as-ptr-method-as-int-from-kernel32-dll-returns-u32-src-miniquake2-client-downloads-ml-1398713386"></a>
### SetFilePointer

```ml
extern function SetFilePointer(handle as ptr, distance as int, high as ptr, method as int) from "kernel32.dll" returns u32
```

Invokes the native SetFilePointer entry point used by the miniquake2 client downloads module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `handle` | `ptr` | — | Native or runtime handle used by the operation. |
| `distance` | `int` | — | distance value consumed by this operation. |
| `high` | `ptr` | — | high value consumed by this operation. |
| `method` | `int` | — | method value consumed by this operation. |


**Returns:** Native u32 result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/downloads.ml#L67)

<a id="function-function-miniquake2-client-downloads-setgamedirectory-function-setgamedirectory-manager-gamedirectory-src-miniquake2-client-downloads-ml-1478877026"></a>
### setGameDirectory

```ml
function setGameDirectory(manager, gameDirectory)
```

Set game directory.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `manager` | `dynamic` | — | manager value consumed by this operation. |
| `gameDirectory` | `dynamic` | — | gameDirectory value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/downloads.ml#L230)

<a id="function-function-miniquake2-client-downloads-takecommands-function-takecommands-manager-src-miniquake2-client-downloads-ml-2049087683"></a>
### takeCommands

```ml
function takeCommands(manager)
```

Consume commands.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `manager` | `dynamic` | — | manager value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/downloads.ml#L312)

<a id="function-function-miniquake2-client-downloads-temporarypath-function-temporarypath-finalpath-src-miniquake2-client-downloads-ml-932039891"></a>
### temporaryPath

```ml
function temporaryPath(finalPath)
```

COM_StripExtension(downloadname) + ".tmp". Matching the retail temporary name preserves resume compatibility with interrupted original-client downloads while the final rename still occurs inside the same directory.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `finalPath` | `dynamic` | — | Path associated with final. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/downloads.ml#L368)

<a id="function-function-miniquake2-client-downloads-textslice-function-textslice-value-start-count-src-miniquake2-client-downloads-ml-2126270168"></a>
### textSlice

```ml
function textSlice(value, start, count)
```

Performs the textSlice operation for the miniquake2 client downloads module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `count` | `dynamic` | — | Number of items or units to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/downloads.ml#L432)

<a id="function-function-miniquake2-client-downloads-validategamedirectory-function-validategamedirectory-name-src-miniquake2-client-downloads-ml-1671046783"></a>
### validateGameDirectory

```ml
function validateGameDirectory(name)
```

Validate game directory.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/downloads.ml#L188)

<a id="extern_function-extern-function-miniquake2-client-downloads-writefile-extern-function-writefile-handle-as-ptr-data-as-bytes-count-as-int-written-as-bytes-overlapped-as-ptr-from-kernel32-dll-returns-bool-src-miniquake2-client-downloads-ml-1965858693"></a>
### WriteFile

```ml
extern function WriteFile(handle as ptr, data as bytes, count as int, written as bytes, overlapped as ptr) from "kernel32.dll" returns bool
```

Invokes the native WriteFile entry point used by the miniquake2 client downloads module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `handle` | `ptr` | — | Native or runtime handle used by the operation. |
| `data` | `bytes` | — | Input data consumed by the operation. |
| `count` | `int` | — | Number of items or units to process. |
| `written` | `bytes` | — | written value consumed by this operation. |
| `overlapped` | `ptr` | — | overlapped value consumed by this operation. |


**Returns:** Native bool result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/downloads.ml#L76)
