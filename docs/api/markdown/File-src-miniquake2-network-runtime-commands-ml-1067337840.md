# `src/miniquake2/network/runtime/commands.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 network runtime commands facilities for this project.

Package: [`miniquake2.network.runtime.commands`](Package-miniquake2-network-runtime-commands-875224615.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/network/address.ml` as `naddress` → [src/miniquake2/network/address.ml](File-src-miniquake2-network-address-ml-1672601357.md)
- `miniquake2/network/connectionless.ml` as `nconnectionless` → [src/miniquake2/network/connectionless.ml](File-src-miniquake2-network-connectionless-ml-440321234.md)
- `miniquake2/network/constants.ml` as `nc` → [src/miniquake2/network/constants.ml](File-src-miniquake2-network-constants-ml-102415622.md)
- `miniquake2/network/runtime/checksum.ml` as `rchecksum` → [src/miniquake2/network/runtime/checksum.ml](File-src-miniquake2-network-runtime-checksum-ml-1869380183.md)
- `miniquake2/network/runtime/messages.ml` as `rmessages` → [src/miniquake2/network/runtime/messages.ml](File-src-miniquake2-network-runtime-messages-ml-904838874.md)
- `miniquake2/network/runtime/types.ml` as `nrtypes` → [src/miniquake2/network/runtime/types.ml](File-src-miniquake2-network-runtime-types-ml-1235773127.md)
- `miniquake2/network/server.ml` as `nserver` → [src/miniquake2/network/server.ml](File-src-miniquake2-network-server-ml-562940856.md)
- `miniquake2/network/types.ml` as `nt` → [src/miniquake2/network/types.ml](File-src-miniquake2-network-types-ml-621495446.md)
- `miniquake2/protocol/checked.ml` as `pchecked` → [src/miniquake2/protocol/checked.ml](File-src-miniquake2-protocol-checked-ml-1828862158.md)
- `miniquake2/protocol/constants.ml` as `pc` → [src/miniquake2/protocol/constants.ml](File-src-miniquake2-protocol-constants-ml-642349806.md)
- `miniquake2/protocol/netchan.ml` as `pnetchan` → [src/miniquake2/protocol/netchan.ml](File-src-miniquake2-protocol-netchan-ml-626556964.md)
- `miniquake2/protocol/types.ml` as `pt` → [src/miniquake2/protocol/types.ml](File-src-miniquake2-protocol-types-ml-736261438.md)
- `miniquake2/protocol/usercmd.ml` as `pusercmd` → [src/miniquake2/protocol/usercmd.ml](File-src-miniquake2-protocol-usercmd-ml-1164193654.md)
- `miniquake2/qcommon/byteio.ml` as `qbio` → [src/miniquake2/qcommon/byteio.ml](File-src-miniquake2-qcommon-byteio-ml-159119335.md)
- `miniquake2/qcommon/cmd.ml` as `qcmd` → [src/miniquake2/qcommon/cmd.ml](File-src-miniquake2-qcommon-cmd-ml-1514462021.md)
- `miniquake2/qcommon/constants.ml` as `qc` → [src/miniquake2/qcommon/constants.ml](File-src-miniquake2-qcommon-constants-ml-1976195726.md)
- `miniquake2/qcommon/info.ml` as `qinfo` → [src/miniquake2/qcommon/info.ml](File-src-miniquake2-qcommon-info-ml-634538165.md)
- `miniquake2/qcommon/message.ml` as `qmsg` → [src/miniquake2/qcommon/message.ml](File-src-miniquake2-qcommon-message-ml-1426179364.md)
- `miniquake2/qcommon/sizebuf.ml` as `qsz` → [src/miniquake2/qcommon/sizebuf.ml](File-src-miniquake2-qcommon-sizebuf-ml-1769950759.md)
- `miniquake2/qcommon/text.ml` as `qtext` → [src/miniquake2/qcommon/text.ml](File-src-miniquake2-qcommon-text-ml-1570504148.md)
- `miniquake2/qcommon/types.ml` as `qt` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)
- `miniquake2/server/administration.ml` as `nsadmin` → [src/miniquake2/server/administration.ml](File-src-miniquake2-server-administration-ml-1444195484.md)

## Declarations

<a id="function-function-miniquake2-network-runtime-commands-applythink-function-applythink-runtime-slot-command-src-miniquake2-network-runtime-commands-ml-1133849452"></a>
### applyThink

```ml
function applyThink(runtime, slot, command)
```

Apply think.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `slot` | `dynamic` | — | slot value consumed by this operation. |
| `command` | `dynamic` | — | command value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/commands.ml#L500)

<a id="function-function-miniquake2-network-runtime-commands-baselinefragment-function-baselinefragment-baseline-src-miniquake2-network-runtime-commands-ml-914952490"></a>
### baselineFragment

```ml
function baselineFragment(baseline)
```

Return the baseline fragment value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseline` | `dynamic` | — | baseline value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/commands.ml#L200)

<a id="function-function-miniquake2-network-runtime-commands-begindownload-function-begindownload-runtime-slot-name-offset-src-miniquake2-network-runtime-commands-ml-1786518005"></a>
### beginDownload

```ml
function beginDownload(runtime, slot, name, offset)
```

Begin download.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `slot` | `dynamic` | — | slot value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |
| `offset` | `dynamic` | — | Zero-based offset at which processing starts. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/commands.ml#L382)

<a id="function-function-miniquake2-network-runtime-commands-configstringfragment-function-configstringfragment-index-value-src-miniquake2-network-runtime-commands-ml-900213260"></a>
### configStringFragment

```ml
function configStringFragment(index, value)
```

Return the config string fragment value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `index` | `dynamic` | — | Zero-based index of the affected item. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/commands.ml#L184)

<a id="function-function-miniquake2-network-runtime-commands-containstraversal-function-containstraversal-name-src-miniquake2-network-runtime-commands-ml-1723420688"></a>
### containsTraversal

```ml
function containsTraversal(name)
```

Report whether contains traversal.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/commands.ml#L116)

<a id="function-function-miniquake2-network-runtime-commands-deferreliablework-function-deferreliablework-runtime-slot-kind-first-second-src-miniquake2-network-runtime-commands-ml-2078542559"></a>
### deferReliableWork

```ml
function deferReliableWork(runtime, slot, kind, first, second)
```

Return the defer reliable work value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `slot` | `dynamic` | — | slot value consumed by this operation. |
| `kind` | `dynamic` | — | kind value consumed by this operation. |
| `first` | `dynamic` | — | first value consumed by this operation. |
| `second` | `dynamic` | — | second value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/commands.ml#L320)

<a id="constant-constant-miniquake2-network-runtime-commands-download-chunk-const-download-chunk-1024-src-miniquake2-network-runtime-commands-ml-264400407"></a>
### DOWNLOAD_CHUNK

```ml
const DOWNLOAD_CHUNK = 1024
```

Defines the download chunk constant used by the miniquake2 network runtime commands module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/commands.ml#L60)

<a id="function-function-miniquake2-network-runtime-commands-downloadfragment-function-downloadfragment-data-offset-count-percent-src-miniquake2-network-runtime-commands-ml-876026642"></a>
### downloadFragment

```ml
function downloadFragment(data, offset, count, percent)
```

Return the download fragment value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `offset` | `dynamic` | — | Zero-based offset at which processing starts. |
| `count` | `dynamic` | — | Number of items or units to process. |
| `percent` | `dynamic` | — | percent value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/commands.ml#L211)

<a id="function-function-miniquake2-network-runtime-commands-executeoperator-function-executeoperator-runtime-text-src-miniquake2-network-runtime-commands-ml-2034386398"></a>
### executeOperator

```ml
function executeOperator(runtime, text)
```

A deliberately bounded operator surface.  These are the stock commands needed to administer the Protocol-34 endpoint; it never delegates RCON text to the host shell or filesystem command parser.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `text` | `dynamic` | — | Text consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/commands.ml#L625)

<a id="function-function-miniquake2-network-runtime-commands-executestring-function-executestring-runtime-slot-text-src-miniquake2-network-runtime-commands-ml-1080911728"></a>
### executeString

```ml
function executeString(runtime, slot, text)
```

Execute string.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `slot` | `dynamic` | — | slot value consumed by this operation. |
| `text` | `dynamic` | — | Text consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/commands.ml#L439)

<a id="function-function-miniquake2-network-runtime-commands-finddownload-function-finddownload-runtime-name-src-miniquake2-network-runtime-commands-ml-2106611628"></a>
### findDownload

```ml
function findDownload(runtime, name)
```

Find download.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/commands.ml#L163)

<a id="function-function-miniquake2-network-runtime-commands-handleconnectionless-function-handleconnectionless-runtime-address-datagram-now-src-miniquake2-network-runtime-commands-ml-1744031006"></a>
### handleConnectionless

```ml
function handleConnectionless(runtime, address, datagram, now)
```

Handles connectionless for the miniquake2 network runtime commands workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `address` | `dynamic` | — | address value consumed by this operation. |
| `datagram` | `dynamic` | — | datagram value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/commands.ml#L731)

<a id="function-function-miniquake2-network-runtime-commands-handlercon-function-handlercon-runtime-address-request-src-miniquake2-network-runtime-commands-ml-1442671354"></a>
### handleRcon

```ml
function handleRcon(runtime, address, request)
```

Handle rcon.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `address` | `dynamic` | — | address value consumed by this operation. |
| `request` | `dynamic` | — | request value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/commands.ml#L704)

<a id="function-function-miniquake2-network-runtime-commands-hassubdirectory-function-hassubdirectory-name-src-miniquake2-network-runtime-commands-ml-35595704"></a>
### hasSubdirectory

```ml
function hasSubdirectory(name)
```

Report whether has subdirectory.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/commands.ml#L128)

<a id="function-function-miniquake2-network-runtime-commands-integerargument-function-integerargument-arguments-index-src-miniquake2-network-runtime-commands-ml-1813450315"></a>
### integerArgument

```ml
function integerArgument(arguments, index)
```

Return the integer argument value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `arguments` | `dynamic` | — | arguments value consumed by this operation. |
| `index` | `dynamic` | — | Zero-based index of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/commands.ml#L404)

<a id="function-function-miniquake2-network-runtime-commands-joinedarguments-function-joinedarguments-arguments-startindex-src-miniquake2-network-runtime-commands-ml-636283665"></a>
### joinedArguments

```ml
function joinedArguments(arguments, startIndex)
```

Return the joined arguments value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `arguments` | `dynamic` | — | arguments value consumed by this operation. |
| `startIndex` | `dynamic` | — | Zero-based index of start. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/commands.ml#L573)

<a id="constant-constant-miniquake2-network-runtime-commands-max-deferred-reliable-work-const-max-deferred-reliable-work-16-src-miniquake2-network-runtime-commands-ml-840836293"></a>
### MAX_DEFERRED_RELIABLE_WORK

```ml
const MAX_DEFERRED_RELIABLE_WORK = 16
```

Defines the max deferred reliable work constant used by the miniquake2 network runtime commands module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/commands.ml#L62)

<a id="constant-constant-miniquake2-network-runtime-commands-max-network-command-log-const-max-network-command-log-1024-src-miniquake2-network-runtime-commands-ml-786720865"></a>
### MAX_NETWORK_COMMAND_LOG

```ml
const MAX_NETWORK_COMMAND_LOG = 1024
```

Defines the max network command log constant used by the miniquake2 network runtime commands module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/commands.ml#L32)

<a id="constant-constant-miniquake2-network-runtime-commands-max-string-commands-const-max-string-commands-8-src-miniquake2-network-runtime-commands-ml-1190502982"></a>
### MAX_STRING_COMMANDS

```ml
const MAX_STRING_COMMANDS = 8
```

Defines the max string commands constant used by the miniquake2 network runtime commands module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/commands.ml#L58)

<a id="function-function-miniquake2-network-runtime-commands-networkcommandappendlog-function-networkcommandappendlog-runtime-slot-value-src-miniquake2-network-runtime-commands-ml-182109062"></a>
### networkCommandAppendLog

```ml
function networkCommandAppendLog(runtime, slot, value)
```

Append network command log.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `slot` | `dynamic` | — | slot value consumed by this operation. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/commands.ml#L38)

<a id="global-global-miniquake2-network-runtime-commands-networkruntimezerousercmd-networkruntimezerousercmd-src-miniquake2-network-runtime-commands-ml-293368371"></a>
### networkRuntimeZeroUserCmd

```ml
networkRuntimeZeroUserCmd
```

MSG_Write/ReadDeltaUsercmd never mutates its base command. Keep the stock


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/commands.ml#L71)

<a id="function-function-miniquake2-network-runtime-commands-operatorclientslot-function-operatorclientslot-runtime-selector-src-miniquake2-network-runtime-commands-ml-505069914"></a>
### operatorClientSlot

```ml
function operatorClientSlot(runtime, selector)
```

Resolve an operator client selector by numeric slot or case-insensitive player name. Numeric slots use Quake II's human-facing zero-based values.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `selector` | `dynamic` | — | selector value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/commands.ml#L595)

<a id="function-function-miniquake2-network-runtime-commands-operatordumpuser-function-operatordumpuser-runtime-slot-src-miniquake2-network-runtime-commands-ml-1548425215"></a>
### operatorDumpUser

```ml
function operatorDumpUser(runtime, slot)
```

Return the stock dumpuser-style information for one connected client.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `slot` | `dynamic` | — | slot value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/commands.ml#L615)

<a id="function-function-miniquake2-network-runtime-commands-operatorstatus-function-operatorstatus-runtime-src-miniquake2-network-runtime-commands-ml-229499731"></a>
### operatorStatus

```ml
function operatorStatus(runtime)
```

Return the operator status value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/commands.ml#L586)

<a id="function-function-miniquake2-network-runtime-commands-parseclientpayload-function-parseclientpayload-runtime-slot-payload-sequence-dropped-paused-src-miniquake2-network-runtime-commands-ml-1773124898"></a>
### parseClientPayload

```ml
function parseClientPayload(runtime, slot, payload, sequence, dropped, paused)
```

Parse client payload.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `slot` | `dynamic` | — | slot value consumed by this operation. |
| `payload` | `dynamic` | — | payload value consumed by this operation. |
| `sequence` | `dynamic` | — | sequence value consumed by this operation. |
| `dropped` | `dynamic` | — | dropped value consumed by this operation. |
| `paused` | `dynamic` | — | paused value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/commands.ml#L513)

<a id="function-function-miniquake2-network-runtime-commands-queuebaselines-function-queuebaselines-runtime-slot-requestedspawn-start-src-miniquake2-network-runtime-commands-ml-1310212484"></a>
### queueBaselines

```ml
function queueBaselines(runtime, slot, requestedSpawn, start)
```

Queue baselines.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `slot` | `dynamic` | — | slot value consumed by this operation. |
| `requestedSpawn` | `dynamic` | — | requestedSpawn value consumed by this operation. |
| `start` | `dynamic` | — | start value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/commands.ml#L266)

<a id="function-function-miniquake2-network-runtime-commands-queueconfigstrings-function-queueconfigstrings-runtime-slot-requestedspawn-start-src-miniquake2-network-runtime-commands-ml-1619038916"></a>
### queueConfigStrings

```ml
function queueConfigStrings(runtime, slot, requestedSpawn, start)
```

Queue config strings.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `slot` | `dynamic` | — | slot value consumed by this operation. |
| `requestedSpawn` | `dynamic` | — | requestedSpawn value consumed by this operation. |
| `start` | `dynamic` | — | start value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/commands.ml#L235)

<a id="function-function-miniquake2-network-runtime-commands-queuedownloadchunk-function-queuedownloadchunk-runtime-slot-src-miniquake2-network-runtime-commands-ml-1214956739"></a>
### queueDownloadChunk

```ml
function queueDownloadChunk(runtime, slot)
```

Queue download chunk.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `slot` | `dynamic` | — | slot value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/commands.ml#L295)

<a id="function-function-miniquake2-network-runtime-commands-queueserverdata-function-queueserverdata-runtime-slot-src-miniquake2-network-runtime-commands-ml-1321625251"></a>
### queueServerData

```ml
function queueServerData(runtime, slot)
```

Queue server data.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `slot` | `dynamic` | — | slot value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/commands.ml#L220)

<a id="function-function-miniquake2-network-runtime-commands-readclientstringcommand-function-readclientstringcommand-buffer-src-miniquake2-network-runtime-commands-ml-1647185885"></a>
### readClientStringCommand

```ml
function readClientStringCommand(buffer)
```

CL_Disconnect in the 3.19 client transmits strlen(final), deliberately omitting the strcpy terminator. Accept only that one exact terminal command; every other clc_stringcmd still requires regular NUL framing.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/commands.ml#L413)

<a id="function-function-miniquake2-network-runtime-commands-registerdownload-function-registerdownload-runtime-name-data-src-miniquake2-network-runtime-commands-ml-1480113780"></a>
### registerDownload

```ml
function registerDownload(runtime, name, data)
```

Register download.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |
| `data` | `dynamic` | — | Input data consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/commands.ml#L149)

<a id="constant-constant-miniquake2-network-runtime-commands-reliable-work-baselines-const-reliable-work-baselines-2-src-miniquake2-network-runtime-commands-ml-2053803756"></a>
### RELIABLE_WORK_BASELINES

```ml
const RELIABLE_WORK_BASELINES = 2
```

Defines the reliable work baselines constant used by the miniquake2 network runtime commands module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/commands.ml#L66)

<a id="constant-constant-miniquake2-network-runtime-commands-reliable-work-configstrings-const-reliable-work-configstrings-1-src-miniquake2-network-runtime-commands-ml-635438367"></a>
### RELIABLE_WORK_CONFIGSTRINGS

```ml
const RELIABLE_WORK_CONFIGSTRINGS = 1
```

Defines the reliable work configstrings constant used by the miniquake2 network runtime commands module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/commands.ml#L64)

<a id="constant-constant-miniquake2-network-runtime-commands-reliable-work-download-const-reliable-work-download-3-src-miniquake2-network-runtime-commands-ml-784484741"></a>
### RELIABLE_WORK_DOWNLOAD

```ml
const RELIABLE_WORK_DOWNLOAD = 3
```

Defines the reliable work download constant used by the miniquake2 network runtime commands module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/commands.ml#L68)

<a id="function-function-miniquake2-network-runtime-commands-replenishcommandmsec-function-replenishcommandmsec-runtime-src-miniquake2-network-runtime-commands-ml-452024643"></a>
### replenishCommandMsec

```ml
function replenishCommandMsec(runtime)
```

Return the replenish command msec value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/commands.ml#L368)

<a id="function-function-miniquake2-network-runtime-commands-retrydeferredreliable-function-retrydeferredreliable-runtime-slot-src-miniquake2-network-runtime-commands-ml-1592873961"></a>
### retryDeferredReliable

```ml
function retryDeferredReliable(runtime, slot)
```

Client string commands are themselves reliably acknowledged before their server response necessarily fits.  Retain a bounded typed retry record so backpressure cannot consume config/baseline/download requests.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `slot` | `dynamic` | — | slot value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/commands.ml#L338)

<a id="function-function-miniquake2-network-runtime-commands-safedownloadname-function-safedownloadname-name-src-miniquake2-network-runtime-commands-ml-1396622070"></a>
### safeDownloadName

```ml
function safeDownloadName(name)
```

Return the safe download name.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/commands.ml#L138)

<a id="function-function-miniquake2-network-runtime-commands-serverdatafragments-function-serverdatafragments-runtime-slot-src-miniquake2-network-runtime-commands-ml-886677083"></a>
### serverDataFragments

```ml
function serverDataFragments(runtime, slot)
```

Return the server data fragments value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `slot` | `dynamic` | — | slot value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/commands.ml#L173)

<a id="function-function-miniquake2-network-runtime-commands-stufftextfragment-function-stufftextfragment-text-src-miniquake2-network-runtime-commands-ml-2023676368"></a>
### stuffTextFragment

```ml
function stuffTextFragment(text)
```

Return the stuff text fragment value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `text` | `dynamic` | — | Text consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/commands.ml#L192)

<a id="function-function-miniquake2-network-runtime-commands-writemove-function-writemove-buffer-sequence-lastframe-oldest-oldcommand-newcommand-src-miniquake2-network-runtime-commands-ml-1918405801"></a>
### writeMove

```ml
function writeMove(buffer, sequence, lastFrame, oldest, oldCommand, newCommand)
```

Write move.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `sequence` | `dynamic` | — | sequence value consumed by this operation. |
| `lastFrame` | `dynamic` | — | lastFrame value consumed by this operation. |
| `oldest` | `dynamic` | — | oldest value consumed by this operation. |
| `oldCommand` | `dynamic` | — | oldCommand value consumed by this operation. |
| `newCommand` | `dynamic` | — | newCommand value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/commands.ml#L100)

<a id="function-function-miniquake2-network-runtime-commands-writestringcommand-function-writestringcommand-buffer-command-src-miniquake2-network-runtime-commands-ml-2109625056"></a>
### writeStringCommand

```ml
function writeStringCommand(buffer, command)
```

Write string command.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `command` | `dynamic` | — | command value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/commands.ml#L86)

<a id="function-function-miniquake2-network-runtime-commands-writeuserinfo-function-writeuserinfo-buffer-userinfo-src-miniquake2-network-runtime-commands-ml-1511039036"></a>
### writeUserInfo

```ml
function writeUserInfo(buffer, userInfo)
```

Write user info.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `userInfo` | `dynamic` | — | userInfo value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/commands.ml#L76)
