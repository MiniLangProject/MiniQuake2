# `src/miniquake2/network/runtime/game_adapter.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 network runtime game adapter facilities for this project.

Package: [`miniquake2.network.runtime.game_adapter`](Package-miniquake2-network-runtime-game-adapter-326145507.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/game/constants.ml` as `gc` → [src/miniquake2/game/constants.ml](File-src-miniquake2-game-constants-ml-1723282332.md)
- `miniquake2/network/runtime/types.ml` as `nrtypes` → [src/miniquake2/network/runtime/types.ml](File-src-miniquake2-network-runtime-types-ml-1235773127.md)
- `miniquake2/qcommon/cmd.ml` as `rqcmd` → [src/miniquake2/qcommon/cmd.ml](File-src-miniquake2-qcommon-cmd-ml-1514462021.md)

## Declarations

<a id="global-global-miniquake2-network-runtime-game-adapter-activecommandsystem-activecommandsystem-src-miniquake2-network-runtime-game-adapter-ml-1329642443"></a>
### activeCommandSystem

```ml
activeCommandSystem
```

Stores module-wide active command system state for the miniquake2 network runtime game adapter module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/game_adapter.ml#L17)

<a id="global-global-miniquake2-network-runtime-game-adapter-activegameexport-activegameexport-src-miniquake2-network-runtime-game-adapter-ml-569018779"></a>
### activeGameExport

```ml
activeGameExport
```

Stores module-wide active game export state for the miniquake2 network runtime game adapter module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/game_adapter.ml#L15)

<a id="function-function-miniquake2-network-runtime-game-adapter-allowconnect-function-allowconnect-slot-userinfo-src-miniquake2-network-runtime-game-adapter-ml-1400267738"></a>
### allowConnect

```ml
function allowConnect(slot, userInfo)
```

Connect allow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `slot` | `dynamic` | — | slot value consumed by this operation. |
| `userInfo` | `dynamic` | — | userInfo value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/game_adapter.ml#L22)

<a id="function-function-miniquake2-network-runtime-game-adapter-create-function-create-clientconnect-clientuserinfochanged-clientthink-clientcommand-clientbegin-src-miniquake2-network-runtime-game-adapter-ml-618181993"></a>
### create

```ml
function create(clientConnect, clientUserinfoChanged, clientThink, clientCommand, clientBegin)
```

Creates create for the miniquake2 network runtime game adapter module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `clientConnect` | `dynamic` | — | clientConnect value consumed by this operation. |
| `clientUserinfoChanged` | `dynamic` | — | clientUserinfoChanged value consumed by this operation. |
| `clientThink` | `dynamic` | — | clientThink value consumed by this operation. |
| `clientCommand` | `dynamic` | — | clientCommand value consumed by this operation. |
| `clientBegin` | `dynamic` | — | clientBegin value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/game_adapter.ml#L72)

<a id="function-function-miniquake2-network-runtime-game-adapter-createwithdisconnect-function-createwithdisconnect-clientconnect-clientuserinfochanged-clientthink-clientcommand-clientbegin-clientdisconnect-src-miniquake2-network-runtime-game-adapter-ml-7895588"></a>
### createWithDisconnect

```ml
function createWithDisconnect(clientConnect, clientUserinfoChanged, clientThink, clientCommand, clientBegin, clientDisconnect)
```

Create with disconnect.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `clientConnect` | `dynamic` | — | clientConnect value consumed by this operation. |
| `clientUserinfoChanged` | `dynamic` | — | clientUserinfoChanged value consumed by this operation. |
| `clientThink` | `dynamic` | — | clientThink value consumed by this operation. |
| `clientCommand` | `dynamic` | — | clientCommand value consumed by this operation. |
| `clientBegin` | `dynamic` | — | clientBegin value consumed by this operation. |
| `clientDisconnect` | `dynamic` | — | clientDisconnect value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/game_adapter.ml#L88)

<a id="function-function-miniquake2-network-runtime-game-adapter-exportclientbegin-function-exportclientbegin-slot-src-miniquake2-network-runtime-game-adapter-ml-354937473"></a>
### exportClientBegin

```ml
function exportClientBegin(slot)
```

Export client begin.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `slot` | `dynamic` | — | slot value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/game_adapter.ml#L159)

<a id="function-function-miniquake2-network-runtime-game-adapter-exportclientcommand-function-exportclientcommand-slot-commandtext-src-miniquake2-network-runtime-game-adapter-ml-1377371353"></a>
### exportClientCommand

```ml
function exportClientCommand(slot, commandText)
```

Export client command.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `slot` | `dynamic` | — | slot value consumed by this operation. |
| `commandText` | `dynamic` | — | commandText value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/game_adapter.ml#L143)

<a id="function-function-miniquake2-network-runtime-game-adapter-exportclientconnect-function-exportclientconnect-slot-userinfo-src-miniquake2-network-runtime-game-adapter-ml-784945124"></a>
### exportClientConnect

```ml
function exportClientConnect(slot, userInfo)
```

Export client connect.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `slot` | `dynamic` | — | slot value consumed by this operation. |
| `userInfo` | `dynamic` | — | userInfo value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/game_adapter.ml#L119)

<a id="function-function-miniquake2-network-runtime-game-adapter-exportclientdisconnect-function-exportclientdisconnect-slot-src-miniquake2-network-runtime-game-adapter-ml-1810778245"></a>
### exportClientDisconnect

```ml
function exportClientDisconnect(slot)
```

Export client disconnect.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `slot` | `dynamic` | — | slot value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/game_adapter.ml#L166)

<a id="function-function-miniquake2-network-runtime-game-adapter-exportclientping-function-exportclientping-slot-ping-src-miniquake2-network-runtime-game-adapter-ml-904560281"></a>
### exportClientPing

```ml
function exportClientPing(slot, ping)
```

Export client ping.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `slot` | `dynamic` | — | slot value consumed by this operation. |
| `ping` | `dynamic` | — | ping value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/game_adapter.ml#L174)

<a id="function-function-miniquake2-network-runtime-game-adapter-exportclientthink-function-exportclientthink-slot-command-src-miniquake2-network-runtime-game-adapter-ml-760575380"></a>
### exportClientThink

```ml
function exportClientThink(slot, command)
```

Export client think.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `slot` | `dynamic` | — | slot value consumed by this operation. |
| `command` | `dynamic` | — | command value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/game_adapter.ml#L135)

<a id="function-function-miniquake2-network-runtime-game-adapter-exportclientuserinfochanged-function-exportclientuserinfochanged-slot-userinfo-src-miniquake2-network-runtime-game-adapter-ml-1480928714"></a>
### exportClientUserinfoChanged

```ml
function exportClientUserinfoChanged(slot, userInfo)
```

Export client userinfo changed.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `slot` | `dynamic` | — | slot value consumed by this operation. |
| `userInfo` | `dynamic` | — | userInfo value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/game_adapter.ml#L127)

<a id="function-function-miniquake2-network-runtime-game-adapter-gameentity-function-gameentity-slot-operation-src-miniquake2-network-runtime-game-adapter-ml-1129064014"></a>
### gameEntity

```ml
function gameEntity(slot, operation)
```

Return the game entity value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `slot` | `dynamic` | — | slot value consumed by this operation. |
| `operation` | `dynamic` | — | operation value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/game_adapter.ml#L105)

<a id="function-function-miniquake2-network-runtime-game-adapter-ignorebegin-function-ignorebegin-slot-src-miniquake2-network-runtime-game-adapter-ml-99785059"></a>
### ignoreBegin

```ml
function ignoreBegin(slot)
```

Ignore begin.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `slot` | `dynamic` | — | slot value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/game_adapter.ml#L49)

<a id="function-function-miniquake2-network-runtime-game-adapter-ignorecommand-function-ignorecommand-slot-commandtext-src-miniquake2-network-runtime-game-adapter-ml-1032237547"></a>
### ignoreCommand

```ml
function ignoreCommand(slot, commandText)
```

Ignore command.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `slot` | `dynamic` | — | slot value consumed by this operation. |
| `commandText` | `dynamic` | — | commandText value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/game_adapter.ml#L43)

<a id="function-function-miniquake2-network-runtime-game-adapter-ignoredisconnect-function-ignoredisconnect-slot-src-miniquake2-network-runtime-game-adapter-ml-1895644697"></a>
### ignoreDisconnect

```ml
function ignoreDisconnect(slot)
```

Ignore disconnect.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `slot` | `dynamic` | — | slot value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/game_adapter.ml#L55)

<a id="function-function-miniquake2-network-runtime-game-adapter-ignoreping-function-ignoreping-slot-ping-src-miniquake2-network-runtime-game-adapter-ml-128565813"></a>
### ignorePing

```ml
function ignorePing(slot, ping)
```

Ignore ping.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `slot` | `dynamic` | — | slot value consumed by this operation. |
| `ping` | `dynamic` | — | ping value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/game_adapter.ml#L62)

<a id="function-function-miniquake2-network-runtime-game-adapter-ignorethink-function-ignorethink-slot-command-src-miniquake2-network-runtime-game-adapter-ml-1649830374"></a>
### ignoreThink

```ml
function ignoreThink(slot, command)
```

Ignore think.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `slot` | `dynamic` | — | slot value consumed by this operation. |
| `command` | `dynamic` | — | command value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/game_adapter.ml#L36)

<a id="function-function-miniquake2-network-runtime-game-adapter-ignoreuserinfo-function-ignoreuserinfo-slot-userinfo-src-miniquake2-network-runtime-game-adapter-ml-589104678"></a>
### ignoreUserinfo

```ml
function ignoreUserinfo(slot, userInfo)
```

Ignore userinfo.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `slot` | `dynamic` | — | slot value consumed by this operation. |
| `userInfo` | `dynamic` | — | userInfo value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/game_adapter.ml#L29)

<a id="function-function-miniquake2-network-runtime-game-adapter-installgameexport-function-installgameexport-gameexport-src-miniquake2-network-runtime-game-adapter-ml-918354651"></a>
### installGameExport

```ml
function installGameExport(gameExport)
```

Install game export.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `gameExport` | `dynamic` | — | gameExport value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/game_adapter.ml#L183)

<a id="function-function-miniquake2-network-runtime-game-adapter-installgameexportwithcommands-function-installgameexportwithcommands-gameexport-commandsystem-src-miniquake2-network-runtime-game-adapter-ml-83897705"></a>
### installGameExportWithCommands

```ml
function installGameExportWithCommands(gameExport, commandSystem)
```

Install game export with commands.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `gameExport` | `dynamic` | — | gameExport value consumed by this operation. |
| `commandSystem` | `dynamic` | — | commandSystem value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/game_adapter.ml#L204)

<a id="function-function-miniquake2-network-runtime-game-adapter-permissive-function-permissive-src-miniquake2-network-runtime-game-adapter-ml-280259137"></a>
### permissive

```ml
function permissive()
```

Return the permissive value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/game_adapter.ml#L98)
