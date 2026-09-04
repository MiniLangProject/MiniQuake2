# `src/miniquake2/qcommon/filesystem.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 qcommon filesystem facilities for this project.

Package: [`miniquake2.qcommon.filesystem`](Package-miniquake2-qcommon-filesystem-356493680.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/qcommon/byteio.ml` as `bio` → [src/miniquake2/qcommon/byteio.ml](File-src-miniquake2-qcommon-byteio-ml-159119335.md)
- `miniquake2/qcommon/text.ml` as `text` → [src/miniquake2/qcommon/text.ml](File-src-miniquake2-qcommon-text-ml-1570504148.md)
- `miniquake2/qcommon/types.ml` as `qt` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)
- `std/fs.ml` as `fs` → `../MiniLangCompilerML/std/fs.ml` — external dependency

## Declarations

<a id="function-function-miniquake2-qcommon-filesystem-adddirectory-function-adddirectory-system-directory-src-miniquake2-qcommon-filesystem-ml-1256148090"></a>
### addDirectory

```ml
function addDirectory(system, directory)
```

Add directory.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `system` | `dynamic` | — | system value consumed by this operation. |
| `directory` | `dynamic` | — | directory value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/filesystem.ml#L229)

<a id="function-function-miniquake2-qcommon-filesystem-addgamedirectory-function-addgamedirectory-system-directory-src-miniquake2-qcommon-filesystem-ml-957938090"></a>
### addGameDirectory

```ml
function addGameDirectory(system, directory)
```

Add game directory.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `system` | `dynamic` | — | system value consumed by this operation. |
| `directory` | `dynamic` | — | directory value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/filesystem.ml#L246)

<a id="function-function-miniquake2-qcommon-filesystem-addpack-function-addpack-system-filename-src-miniquake2-qcommon-filesystem-ml-1975210570"></a>
### addPack

```ml
function addPack(system, filename)
```

Add pack.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `system` | `dynamic` | — | system value consumed by this operation. |
| `filename` | `dynamic` | — | filename value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/filesystem.ml#L237)

<a id="constant-constant-miniquake2-qcommon-filesystem-base-directory-name-const-base-directory-name-baseq2-src-miniquake2-qcommon-filesystem-ml-130478317"></a>
### BASE_DIRECTORY_NAME

```ml
const BASE_DIRECTORY_NAME = "baseq2"
```

Defines the base directory name constant used by the miniquake2 qcommon filesystem module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/filesystem.ml#L20)

<a id="function-function-miniquake2-qcommon-filesystem-canonicalvirtualname-function-canonicalvirtualname-name-src-miniquake2-qcommon-filesystem-ml-857976813"></a>
### canonicalVirtualName

```ml
function canonicalVirtualName(name)
```

Resolve dot segments inside the virtual root. Historical retail PAKs contain names such as models/monsters/tank/../ctank/skin.pcx; they are safe once canonicalized, while attempts to walk above the virtual root remain errors.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/filesystem.ml#L89)

<a id="extern_function-extern-function-miniquake2-qcommon-filesystem-closehandle-extern-function-closehandle-handle-as-ptr-from-kernel32-dll-returns-bool-src-miniquake2-qcommon-filesystem-ml-406630960"></a>
### CloseHandle

```ml
extern function CloseHandle(handle as ptr) from "kernel32.dll" returns bool
```

Invokes the native CloseHandle entry point used by the miniquake2 qcommon filesystem module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `handle` | `ptr` | — | Native or runtime handle used by the operation. |


**Returns:** Native bool result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/filesystem.ml#L52)

<a id="function-function-miniquake2-qcommon-filesystem-create-function-create-basedirectory-gamedirectory-src-miniquake2-qcommon-filesystem-ml-586205907"></a>
### create

```ml
function create(baseDirectory, gameDirectory)
```

Creates create for the miniquake2 qcommon filesystem module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `gameDirectory` | `dynamic` | — | gameDirectory value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/filesystem.ml#L222)

<a id="extern_function-extern-function-miniquake2-qcommon-filesystem-createfilew-extern-function-createfilew-path-as-wstr-access-as-int-share-as-int-security-as-ptr-creation-as-int-flags-as-int-template-as-ptr-from-kernel32-dll-returns-ptr-src-miniquake2-qcommon-filesystem-ml-261987902"></a>
### CreateFileW

```ml
extern function CreateFileW(path as wstr, access as int, share as int, security as ptr, creation as int, flags as int, template as ptr) from "kernel32.dll" returns ptr
```

Invokes the native CreateFileW entry point used by the miniquake2 qcommon filesystem module.

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

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/filesystem.ml#L31)

<a id="function-function-miniquake2-qcommon-filesystem-fileexists-function-fileexists-system-name-src-miniquake2-qcommon-filesystem-ml-1327343512"></a>
### fileExists

```ml
function fileExists(system, name)
```

Return the file exists value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `system` | `dynamic` | — | system value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/filesystem.ml#L289)

<a id="function-function-miniquake2-qcommon-filesystem-findpackfile-function-findpackfile-pack-name-src-miniquake2-qcommon-filesystem-ml-193608704"></a>
### findPackFile

```ml
function findPackFile(pack, name)
```

Find pack file.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pack` | `dynamic` | — | pack value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/filesystem.ml#L203)

<a id="extern_function-extern-function-miniquake2-qcommon-filesystem-getfilesizeex-extern-function-getfilesizeex-handle-as-ptr-size-as-bytes-from-kernel32-dll-returns-bool-src-miniquake2-qcommon-filesystem-ml-503219562"></a>
### GetFileSizeEx

```ml
extern function GetFileSizeEx(handle as ptr, size as bytes) from "kernel32.dll" returns bool
```

Invokes the native GetFileSizeEx entry point used by the miniquake2 qcommon filesystem module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `handle` | `ptr` | — | Native or runtime handle used by the operation. |
| `size` | `bytes` | — | Size in the units required by the operation. |


**Returns:** Native bool result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/filesystem.ml#L38)

<a id="function-function-miniquake2-qcommon-filesystem-initialize-function-initialize-basedirectory-gamedirectory-src-miniquake2-qcommon-filesystem-ml-872343471"></a>
### initialize

```ml
function initialize(baseDirectory, gameDirectory)
```

Performs the initialize operation for the miniquake2 qcommon filesystem module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `gameDirectory` | `dynamic` | — | gameDirectory value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/filesystem.ml#L261)

<a id="function-function-miniquake2-qcommon-filesystem-loadpack-function-loadpack-filename-src-miniquake2-qcommon-filesystem-ml-1068202595"></a>
### loadPack

```ml
function loadPack(filename)
```

Load pack.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `filename` | `dynamic` | — | filename value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/filesystem.ml#L167)

<a id="constant-constant-miniquake2-qcommon-filesystem-max-files-in-pack-const-max-files-in-pack-4096-src-miniquake2-qcommon-filesystem-ml-1028613242"></a>
### MAX_FILES_IN_PACK

```ml
const MAX_FILES_IN_PACK = 4096
```

Defines the max files in pack constant used by the miniquake2 qcommon filesystem module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/filesystem.ml#L16)

<a id="function-function-miniquake2-qcommon-filesystem-musictrackname-function-musictrackname-track-src-miniquake2-qcommon-filesystem-ml-109750593"></a>
### musicTrackName

```ml
function musicTrackName(track)
```

Return the music track name.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `track` | `dynamic` | — | track value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/filesystem.ml#L296)

<a id="function-function-miniquake2-qcommon-filesystem-musictrackpath-function-musictrackpath-system-track-src-miniquake2-qcommon-filesystem-ml-1746821662"></a>
### musicTrackPath

```ml
function musicTrackPath(system, track)
```

Prefer loose files so the native Vorbis bridge owns compressed retail data without retaining a multi-megabyte MiniLang byte array for the whole level. The 2023 Steam release stores the original soundtrack below rerelease/baseq2/music while classic source ports commonly use baseq2/music. PAK-contained replacements remain available through readFile.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `system` | `dynamic` | — | system value consumed by this operation. |
| `track` | `dynamic` | — | track value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/filesystem.ml#L312)

<a id="function-function-miniquake2-qcommon-filesystem-normalizevirtualname-function-normalizevirtualname-name-src-miniquake2-qcommon-filesystem-ml-1886787113"></a>
### normalizeVirtualName

```ml
function normalizeVirtualName(name)
```

Normalize virtual name.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/filesystem.ml#L75)

<a id="constant-constant-miniquake2-qcommon-filesystem-pack-lookup-size-const-pack-lookup-size-8192-src-miniquake2-qcommon-filesystem-ml-238988937"></a>
### PACK_LOOKUP_SIZE

```ml
const PACK_LOOKUP_SIZE = 8192
```

Defines the pack lookup size constant used by the miniquake2 qcommon filesystem module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/filesystem.ml#L18)

<a id="function-function-miniquake2-qcommon-filesystem-packlookupslot-inline-function-packlookupslot-name-src-miniquake2-qcommon-filesystem-ml-1255647904"></a>
### packLookupSlot

```ml
inline function packLookupSlot(name)
```

Return the deterministic open-addressing slot for a canonical PAK name.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/filesystem.ml#L56)

<a id="function-function-miniquake2-qcommon-filesystem-parsepack-function-parsepack-data-filename-src-miniquake2-qcommon-filesystem-ml-420357611"></a>
### parsePack

```ml
function parsePack(data, filename)
```

Parse pack.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `filename` | `dynamic` | — | filename value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/filesystem.ml#L134)

<a id="extern_function-extern-function-miniquake2-qcommon-filesystem-readfile-extern-function-readfile-handle-as-ptr-buffer-as-bytes-count-as-int-bytesread-as-bytes-overlapped-as-ptr-from-kernel32-dll-returns-bool-src-miniquake2-qcommon-filesystem-ml-699235249"></a>
### ReadFile

```ml
extern function ReadFile(handle as ptr, buffer as bytes, count as int, bytesRead as bytes, overlapped as ptr) from "kernel32.dll" returns bool
```

Invokes the native ReadFile entry point used by the miniquake2 qcommon filesystem module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `handle` | `ptr` | — | Native or runtime handle used by the operation. |
| `buffer` | `bytes` | — | Buffer that receives or supplies the operation data. |
| `count` | `int` | — | Number of items or units to process. |
| `bytesRead` | `bytes` | — | bytesRead value consumed by this operation. |
| `overlapped` | `ptr` | — | overlapped value consumed by this operation. |


**Returns:** Native bool result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/filesystem.ml#L47)

<a id="function-function-miniquake2-qcommon-filesystem-readfile-function-readfile-system-name-src-miniquake2-qcommon-filesystem-ml-2066577560"></a>
### readFile

```ml
function readFile(system, name)
```

Read file.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `system` | `dynamic` | — | system value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/filesystem.ml#L271)

<a id="function-function-miniquake2-qcommon-filesystem-readmusictrack-function-readmusictrack-system-track-src-miniquake2-qcommon-filesystem-ml-1191586006"></a>
### readMusicTrack

```ml
function readMusicTrack(system, track)
```

Read music track.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `system` | `dynamic` | — | system value consumed by this operation. |
| `track` | `dynamic` | — | track value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/filesystem.ml#L328)

<a id="function-function-miniquake2-qcommon-filesystem-virtualnamevalid-function-virtualnamevalid-name-src-miniquake2-qcommon-filesystem-ml-789927693"></a>
### virtualNameValid

```ml
function virtualNameValid(name)
```

Report whether virtual name valid.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/filesystem.ml#L69)
