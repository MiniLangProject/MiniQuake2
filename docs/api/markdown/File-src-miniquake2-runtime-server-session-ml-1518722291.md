# `src/miniquake2/runtime/server_session.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 runtime server session facilities for this project.

Package: [`miniquake2.runtime.server_session`](Package-miniquake2-runtime-server-session-590674369.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/collision/model.ml` as `sscollision` → [src/miniquake2/collision/model.ml](File-src-miniquake2-collision-model-ml-265039588.md)
- `miniquake2/format/bsp.ml` as `ssbsp` → [src/miniquake2/format/bsp.ml](File-src-miniquake2-format-bsp-ml-2080213539.md)
- `miniquake2/game/base/spawn.ml` as `ssbasespawn` → [src/miniquake2/game/base/spawn.ml](File-src-miniquake2-game-base-spawn-ml-685876900.md)
- `miniquake2/game/constants.ml` as `ssgc` → [src/miniquake2/game/constants.ml](File-src-miniquake2-game-constants-ml-1723282332.md)
- `miniquake2/game/null_game.ml` as `ssgame` → [src/miniquake2/game/null_game.ml](File-src-miniquake2-game-null-game-ml-1916269379.md)
- `miniquake2/game/types.ml` as `ssgtypes` → [src/miniquake2/game/types.ml](File-src-miniquake2-game-types-ml-1384205920.md)
- `miniquake2/network/constants.ml` as `ssnc` → [src/miniquake2/network/constants.ml](File-src-miniquake2-network-constants-ml-102415622.md)
- `miniquake2/network/runtime/commands.ml` as `sscommands` → [src/miniquake2/network/runtime/commands.ml](File-src-miniquake2-network-runtime-commands-ml-1067337840.md)
- `miniquake2/network/runtime/game_adapter.ml` as `ssgameadapter` → [src/miniquake2/network/runtime/game_adapter.ml](File-src-miniquake2-network-runtime-game-adapter-ml-1407631424.md)
- `miniquake2/network/runtime/lifecycle.ml` as `sslifecycle` → [src/miniquake2/network/runtime/lifecycle.ml](File-src-miniquake2-network-runtime-lifecycle-ml-700259748.md)
- `miniquake2/network/runtime/messages.ml` as `ssmessages` → [src/miniquake2/network/runtime/messages.ml](File-src-miniquake2-network-runtime-messages-ml-904838874.md)
- `miniquake2/network/runtime/multicast_dispatch.ml` as `ssmulticastdispatch` → [src/miniquake2/network/runtime/multicast_dispatch.ml](File-src-miniquake2-network-runtime-multicast-dispatch-ml-1518547901.md)
- `miniquake2/network/runtime/pump.ml` as `sspump` → [src/miniquake2/network/runtime/pump.ml](File-src-miniquake2-network-runtime-pump-ml-890925024.md)
- `miniquake2/network/runtime/sound_dispatch.ml` as `ssounddispatch` → [src/miniquake2/network/runtime/sound_dispatch.ml](File-src-miniquake2-network-runtime-sound-dispatch-ml-1429978452.md)
- `miniquake2/network/runtime/types.ml` as `ssnrtypes` → [src/miniquake2/network/runtime/types.ml](File-src-miniquake2-network-runtime-types-ml-1235773127.md)
- `miniquake2/network/runtime/unicast_dispatch.ml` as `ssunicastdispatch` → [src/miniquake2/network/runtime/unicast_dispatch.ml](File-src-miniquake2-network-runtime-unicast-dispatch-ml-1646678058.md)
- `miniquake2/network/server.ml` as `ssserver` → [src/miniquake2/network/server.ml](File-src-miniquake2-network-server-ml-562940856.md)
- `miniquake2/network/snapshot.ml` as `sssnapshot` → [src/miniquake2/network/snapshot.ml](File-src-miniquake2-network-snapshot-ml-1023029537.md)
- `miniquake2/platform/system.ml` as `sssystem` → [src/miniquake2/platform/system.ml](File-src-miniquake2-platform-system-ml-74223645.md)
- `miniquake2/platform/udp.ml` as `ssudp` → [src/miniquake2/platform/udp.ml](File-src-miniquake2-platform-udp-ml-357648233.md)
- `miniquake2/protocol/constants.ml` as `sspc` → [src/miniquake2/protocol/constants.ml](File-src-miniquake2-protocol-constants-ml-642349806.md)
- `miniquake2/protocol/netchan.ml` as `ssnetchan` → [src/miniquake2/protocol/netchan.ml](File-src-miniquake2-protocol-netchan-ml-626556964.md)
- `miniquake2/protocol/types.ml` as `sspt` → [src/miniquake2/protocol/types.ml](File-src-miniquake2-protocol-types-ml-736261438.md)
- `miniquake2/qcommon/byteio.ml` as `ssqbyteio` → [src/miniquake2/qcommon/byteio.ml](File-src-miniquake2-qcommon-byteio-ml-159119335.md)
- `miniquake2/qcommon/checksum.ml` as `sschecksum` → [src/miniquake2/qcommon/checksum.ml](File-src-miniquake2-qcommon-checksum-ml-2099292824.md)
- `miniquake2/qcommon/constants.ml` as `ssqc` → [src/miniquake2/qcommon/constants.ml](File-src-miniquake2-qcommon-constants-ml-1976195726.md)
- `miniquake2/qcommon/filesystem.ml` as `ssfs` → [src/miniquake2/qcommon/filesystem.ml](File-src-miniquake2-qcommon-filesystem-ml-828451784.md)
- `miniquake2/qcommon/sizebuf.ml` as `ssqsz` → [src/miniquake2/qcommon/sizebuf.ml](File-src-miniquake2-qcommon-sizebuf-ml-1769950759.md)
- `miniquake2/qcommon/types.ml` as `ssqtypes` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)
- `miniquake2/server/administration.ml` as `ssadministration` → [src/miniquake2/server/administration.ml](File-src-miniquake2-server-administration-ml-1444195484.md)
- `miniquake2/server/game_bridge.ml` as `ssbridge` → [src/miniquake2/server/game_bridge.ml](File-src-miniquake2-server-game-bridge-ml-73559214.md)
- `miniquake2/server/game_messages.ml` as `ssgamemessages` → [src/miniquake2/server/game_messages.ml](File-src-miniquake2-server-game-messages-ml-506318169.md)
- `miniquake2/server/sound_events.ml` as `ssoundevents` → [src/miniquake2/server/sound_events.ml](File-src-miniquake2-server-sound-events-ml-2055264741.md)
- `std/array.ml` as `sssessionarray` → `../MiniLangCompilerML/std/array.ml` — external dependency

## Declarations

<a id="function-function-miniquake2-runtime-server-session-areabits-function-areabits-session-clientedict-src-miniquake2-runtime-server-session-ml-849719886"></a>
### areaBits

```ml
function areaBits(session, clientEdict)
```

Return the area bits value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `clientEdict` | `dynamic` | — | clientEdict value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/server_session.ml#L1215)

<a id="function-function-miniquake2-runtime-server-session-changemapcore-function-changemapcore-session-mapname-entitytext-collision-src-miniquake2-runtime-server-session-ml-797587983"></a>
### changeMapCore

```ml
function changeMapCore(session, mapName, entityText, collision)
```

Performs the changeMapCore operation for the miniquake2 runtime server session module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `entityText` | `dynamic` | — | entityText value consumed by this operation. |
| `collision` | `dynamic` | — | collision value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/server_session.ml#L1087)

<a id="function-function-miniquake2-runtime-server-session-changemapretail-function-changemapretail-session-basedirectory-mapname-src-miniquake2-runtime-server-session-ml-361132617"></a>
### changeMapRetail

```ml
function changeMapRetail(session, baseDirectory, mapName)
```

Performs the changeMapRetail operation for the miniquake2 runtime server session module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/server_session.ml#L1191)

<a id="function-function-miniquake2-runtime-server-session-clientvieworigin-function-clientvieworigin-viewer-src-miniquake2-runtime-server-session-ml-1772825234"></a>
### clientViewOrigin

```ml
function clientViewOrigin(viewer)
```

SV_BuildClientFrame starts its fat-PVS query at the rendered eye position, not at the player edict origin near the middle of the collision hull. BSP leaves can split vertically between those points (notably at base1's spawn), which otherwise makes muzzle-height projectiles invisible to their owner.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `viewer` | `dynamic` | — | viewer value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/server_session.ml#L278)

<a id="function-function-miniquake2-runtime-server-session-composeclientdatagram-function-composeclientdatagram-snapshotpayload-fragments-maximumpayload-src-miniquake2-runtime-server-session-ml-1991695859"></a>
### composeClientDatagram

```ml
function composeClientDatagram(snapshotPayload, fragments, maximumPayload)
```

Append the complete transient tail or drop the entire unreliable message. This mirrors SZ_AllowOverflow + SV_SendClientDatagram: an event is never sent without the snapshot entity state it references.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `snapshotPayload` | `dynamic` | — | snapshotPayload value consumed by this operation. |
| `fragments` | `dynamic` | — | fragments value consumed by this operation. |
| `maximumPayload` | `dynamic` | — | maximumPayload value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/server_session.ml#L1336)

<a id="function-function-miniquake2-runtime-server-session-createcore-function-createcore-mapname-entitytext-collision-bindaddress-port-maxclients-dedicated-src-miniquake2-runtime-server-session-ml-784889938"></a>
### createCore

```ml
function createCore(mapName, entityText, collision, bindAddress, port, maxClients, dedicated)
```

Creates core for the miniquake2 runtime server session module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `entityText` | `dynamic` | — | entityText value consumed by this operation. |
| `collision` | `dynamic` | — | collision value consumed by this operation. |
| `bindAddress` | `dynamic` | — | bindAddress value consumed by this operation. |
| `port` | `dynamic` | — | port value consumed by this operation. |
| `maxClients` | `dynamic` | — | maxClients value consumed by this operation. |
| `dedicated` | `dynamic` | — | dedicated value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/server_session.ml#L943)

<a id="function-function-miniquake2-runtime-server-session-createcoreat-function-createcoreat-mapname-entitytext-collision-spawnpoint-bindaddress-port-maxclients-dedicated-src-miniquake2-runtime-server-session-ml-439794181"></a>
### createCoreAt

```ml
function createCoreAt(mapName, entityText, collision, spawnPoint, bindAddress, port, maxClients, dedicated)
```

Create core at.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `entityText` | `dynamic` | — | entityText value consumed by this operation. |
| `collision` | `dynamic` | — | collision value consumed by this operation. |
| `spawnPoint` | `dynamic` | — | spawnPoint value consumed by this operation. |
| `bindAddress` | `dynamic` | — | bindAddress value consumed by this operation. |
| `port` | `dynamic` | — | port value consumed by this operation. |
| `maxClients` | `dynamic` | — | maxClients value consumed by this operation. |
| `dedicated` | `dynamic` | — | dedicated value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/server_session.ml#L914)

<a id="function-function-miniquake2-runtime-server-session-createcoreatskill-function-createcoreatskill-mapname-entitytext-collision-spawnpoint-bindaddress-port-maxclients-dedicated-skill-src-miniquake2-runtime-server-session-ml-24343746"></a>
### createCoreAtSkill

```ml
function createCoreAtSkill(mapName, entityText, collision, spawnPoint, bindAddress, port, maxClients, dedicated, skill)
```

Creates core at skill for the miniquake2 runtime server session module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `entityText` | `dynamic` | — | entityText value consumed by this operation. |
| `collision` | `dynamic` | — | collision value consumed by this operation. |
| `spawnPoint` | `dynamic` | — | spawnPoint value consumed by this operation. |
| `bindAddress` | `dynamic` | — | bindAddress value consumed by this operation. |
| `port` | `dynamic` | — | port value consumed by this operation. |
| `maxClients` | `dynamic` | — | maxClients value consumed by this operation. |
| `dedicated` | `dynamic` | — | dedicated value consumed by this operation. |
| `skill` | `dynamic` | — | skill value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/server_session.ml#L929)

<a id="function-function-miniquake2-runtime-server-session-createcoremode-function-createcoremode-mapname-entitytext-collision-bindaddress-port-maxclients-dedicated-deathmatch-cooperative-src-miniquake2-runtime-server-session-ml-862219842"></a>
### createCoreMode

```ml
function createCoreMode(mapName, entityText, collision, bindAddress, port, maxClients, dedicated, deathmatch, cooperative)
```

Create core mode.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `entityText` | `dynamic` | — | entityText value consumed by this operation. |
| `collision` | `dynamic` | — | collision value consumed by this operation. |
| `bindAddress` | `dynamic` | — | bindAddress value consumed by this operation. |
| `port` | `dynamic` | — | port value consumed by this operation. |
| `maxClients` | `dynamic` | — | maxClients value consumed by this operation. |
| `dedicated` | `dynamic` | — | dedicated value consumed by this operation. |
| `deathmatch` | `dynamic` | — | deathmatch value consumed by this operation. |
| `cooperative` | `dynamic` | — | cooperative value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/server_session.ml#L900)

<a id="function-function-miniquake2-runtime-server-session-createcoremodeat-function-createcoremodeat-mapname-entitytext-collision-spawnpoint-bindaddress-port-maxclients-dedicated-deathmatch-cooperative-src-miniquake2-runtime-server-session-ml-46391455"></a>
### createCoreModeAt

```ml
function createCoreModeAt(mapName, entityText, collision, spawnPoint, bindAddress, port, maxClients, dedicated, deathmatch, cooperative)
```

Create core mode at.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `entityText` | `dynamic` | — | entityText value consumed by this operation. |
| `collision` | `dynamic` | — | collision value consumed by this operation. |
| `spawnPoint` | `dynamic` | — | spawnPoint value consumed by this operation. |
| `bindAddress` | `dynamic` | — | bindAddress value consumed by this operation. |
| `port` | `dynamic` | — | port value consumed by this operation. |
| `maxClients` | `dynamic` | — | maxClients value consumed by this operation. |
| `dedicated` | `dynamic` | — | dedicated value consumed by this operation. |
| `deathmatch` | `dynamic` | — | deathmatch value consumed by this operation. |
| `cooperative` | `dynamic` | — | cooperative value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/server_session.ml#L884)

<a id="function-function-miniquake2-runtime-server-session-createcoremodeatskill-function-createcoremodeatskill-mapname-entitytext-collision-spawnpoint-bindaddress-port-maxclients-dedicated-deathmatch-cooperative-skill-src-miniquake2-runtime-server-session-ml-732392282"></a>
### createCoreModeAtSkill

```ml
function createCoreModeAtSkill(mapName, entityText, collision, spawnPoint, bindAddress, port, maxClients, dedicated, deathmatch, cooperative, skill)
```

Create core mode at skill.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `entityText` | `dynamic` | — | entityText value consumed by this operation. |
| `collision` | `dynamic` | — | collision value consumed by this operation. |
| `spawnPoint` | `dynamic` | — | spawnPoint value consumed by this operation. |
| `bindAddress` | `dynamic` | — | bindAddress value consumed by this operation. |
| `port` | `dynamic` | — | port value consumed by this operation. |
| `maxClients` | `dynamic` | — | maxClients value consumed by this operation. |
| `dedicated` | `dynamic` | — | dedicated value consumed by this operation. |
| `deathmatch` | `dynamic` | — | deathmatch value consumed by this operation. |
| `cooperative` | `dynamic` | — | cooperative value consumed by this operation. |
| `skill` | `dynamic` | — | skill value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/server_session.ml#L829)

<a id="function-function-miniquake2-runtime-server-session-createretail-function-createretail-basedirectory-mapname-bindaddress-port-maxclients-dedicated-src-miniquake2-runtime-server-session-ml-1354880168"></a>
### createRetail

```ml
function createRetail(baseDirectory, mapName, bindAddress, port, maxClients, dedicated)
```

Creates retail for the miniquake2 runtime server session module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `bindAddress` | `dynamic` | — | bindAddress value consumed by this operation. |
| `port` | `dynamic` | — | port value consumed by this operation. |
| `maxClients` | `dynamic` | — | maxClients value consumed by this operation. |
| `dedicated` | `dynamic` | — | dedicated value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/server_session.ml#L1051)

<a id="function-function-miniquake2-runtime-server-session-createretailat-function-createretailat-basedirectory-mapname-spawnpoint-bindaddress-port-maxclients-dedicated-src-miniquake2-runtime-server-session-ml-1486251683"></a>
### createRetailAt

```ml
function createRetailAt(baseDirectory, mapName, spawnPoint, bindAddress, port, maxClients, dedicated)
```

Create retail at.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `spawnPoint` | `dynamic` | — | spawnPoint value consumed by this operation. |
| `bindAddress` | `dynamic` | — | bindAddress value consumed by this operation. |
| `port` | `dynamic` | — | port value consumed by this operation. |
| `maxClients` | `dynamic` | — | maxClients value consumed by this operation. |
| `dedicated` | `dynamic` | — | dedicated value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/server_session.ml#L1024)

<a id="function-function-miniquake2-runtime-server-session-createretailatskill-function-createretailatskill-basedirectory-mapname-spawnpoint-bindaddress-port-maxclients-dedicated-skill-src-miniquake2-runtime-server-session-ml-1843676520"></a>
### createRetailAtSkill

```ml
function createRetailAtSkill(baseDirectory, mapName, spawnPoint, bindAddress, port, maxClients, dedicated, skill)
```

Creates retail at skill for the miniquake2 runtime server session module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `spawnPoint` | `dynamic` | — | spawnPoint value consumed by this operation. |
| `bindAddress` | `dynamic` | — | bindAddress value consumed by this operation. |
| `port` | `dynamic` | — | port value consumed by this operation. |
| `maxClients` | `dynamic` | — | maxClients value consumed by this operation. |
| `dedicated` | `dynamic` | — | dedicated value consumed by this operation. |
| `skill` | `dynamic` | — | skill value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/server_session.ml#L1038)

<a id="function-function-miniquake2-runtime-server-session-createretailmode-function-createretailmode-basedirectory-mapname-bindaddress-port-maxclients-dedicated-deathmatch-cooperative-src-miniquake2-runtime-server-session-ml-1300564872"></a>
### createRetailMode

```ml
function createRetailMode(baseDirectory, mapName, bindAddress, port, maxClients, dedicated, deathmatch, cooperative)
```

Create retail mode.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `bindAddress` | `dynamic` | — | bindAddress value consumed by this operation. |
| `port` | `dynamic` | — | port value consumed by this operation. |
| `maxClients` | `dynamic` | — | maxClients value consumed by this operation. |
| `dedicated` | `dynamic` | — | dedicated value consumed by this operation. |
| `deathmatch` | `dynamic` | — | deathmatch value consumed by this operation. |
| `cooperative` | `dynamic` | — | cooperative value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/server_session.ml#L1011)

<a id="function-function-miniquake2-runtime-server-session-createretailmodeat-function-createretailmodeat-basedirectory-mapname-spawnpoint-bindaddress-port-maxclients-dedicated-deathmatch-cooperative-src-miniquake2-runtime-server-session-ml-1867145349"></a>
### createRetailModeAt

```ml
function createRetailModeAt(baseDirectory, mapName, spawnPoint, bindAddress, port, maxClients, dedicated, deathmatch, cooperative)
```

Create retail mode at.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `spawnPoint` | `dynamic` | — | spawnPoint value consumed by this operation. |
| `bindAddress` | `dynamic` | — | bindAddress value consumed by this operation. |
| `port` | `dynamic` | — | port value consumed by this operation. |
| `maxClients` | `dynamic` | — | maxClients value consumed by this operation. |
| `dedicated` | `dynamic` | — | dedicated value consumed by this operation. |
| `deathmatch` | `dynamic` | — | deathmatch value consumed by this operation. |
| `cooperative` | `dynamic` | — | cooperative value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/server_session.ml#L957)

<a id="function-function-miniquake2-runtime-server-session-createretailmodeatskill-function-createretailmodeatskill-basedirectory-mapname-spawnpoint-bindaddress-port-maxclients-dedicated-deathmatch-cooperative-skill-src-miniquake2-runtime-server-session-ml-1260983544"></a>
### createRetailModeAtSkill

```ml
function createRetailModeAtSkill(baseDirectory, mapName, spawnPoint, bindAddress, port, maxClients, dedicated, deathmatch, cooperative, skill)
```

Create retail mode at skill.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `spawnPoint` | `dynamic` | — | spawnPoint value consumed by this operation. |
| `bindAddress` | `dynamic` | — | bindAddress value consumed by this operation. |
| `port` | `dynamic` | — | port value consumed by this operation. |
| `maxClients` | `dynamic` | — | maxClients value consumed by this operation. |
| `dedicated` | `dynamic` | — | dedicated value consumed by this operation. |
| `deathmatch` | `dynamic` | — | deathmatch value consumed by this operation. |
| `cooperative` | `dynamic` | — | cooperative value consumed by this operation. |
| `skill` | `dynamic` | — | skill value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/server_session.ml#L983)

<a id="function-function-miniquake2-runtime-server-session-emptyservermessageroutes-function-emptyservermessageroutes-maxclients-src-miniquake2-runtime-server-session-ml-1778470770"></a>
### emptyServerMessageRoutes

```ml
function emptyServerMessageRoutes(maxClients)
```

Return immutable empty recipient routes for a server width. Snapshot code only reads these prefixes, so all sessions with the same maxclients value can safely share the once-allocated routing shape.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `maxClients` | `dynamic` | — | maxClients value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/server_session.ml#L118)

<a id="function-function-miniquake2-runtime-server-session-entityvisible-function-entityvisible-session-viewer-edict-src-miniquake2-runtime-server-session-ml-722295055"></a>
### entityVisible

```ml
function entityVisible(session, viewer, edict)
```

Report whether entity visible.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `viewer` | `dynamic` | — | viewer value consumed by this operation. |
| `edict` | `dynamic` | — | edict value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/server_session.ml#L393)

<a id="function-function-miniquake2-runtime-server-session-entityvisiblefromleaf-function-entityvisiblefromleaf-session-viewer-viewleaf-edict-src-miniquake2-runtime-server-session-ml-592246600"></a>
### entityVisibleFromLeaf

```ml
function entityVisibleFromLeaf(session, viewer, viewLeaf, edict)
```

Report whether entity visible from leaf.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `viewer` | `dynamic` | — | viewer value consumed by this operation. |
| `viewLeaf` | `dynamic` | — | viewLeaf value consumed by this operation. |
| `edict` | `dynamic` | — | edict value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/server_session.ml#L385)

<a id="function-function-miniquake2-runtime-server-session-entityvisiblefrompreparedpvs-function-entityvisiblefrompreparedpvs-session-viewer-viewleaf-preparedpvs-edict-src-miniquake2-runtime-server-session-ml-1819300754"></a>
### entityVisibleFromPreparedPvs

```ml
function entityVisibleFromPreparedPvs(session, viewer, viewLeaf, preparedPvs, edict)
```

Report whether entity visible from prepared pvs.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `viewer` | `dynamic` | — | viewer value consumed by this operation. |
| `viewLeaf` | `dynamic` | — | viewLeaf value consumed by this operation. |
| `preparedPvs` | `dynamic` | — | preparedPvs value consumed by this operation. |
| `edict` | `dynamic` | — | edict value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/server_session.ml#L324)

<a id="function-function-miniquake2-runtime-server-session-fatpvsrow-function-fatpvsrow-collisionmodel-origin-src-miniquake2-runtime-server-session-ml-160949211"></a>
### fatPvsRow

```ml
function fatPvsRow(collisionModel, origin)
```

Return the fat pvs row value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `collisionModel` | `dynamic` | — | collisionModel value consumed by this operation. |
| `origin` | `dynamic` | — | origin value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/server_session.ml#L292)

<a id="function-function-miniquake2-runtime-server-session-framefragmentpayloads-function-framefragmentpayloads-fragments-src-miniquake2-runtime-server-session-ml-701168259"></a>
### frameFragmentPayloads

```ml
function frameFragmentPayloads(fragments)
```

Return only the encoded bytes from ordered frame fragments.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `fragments` | `dynamic` | — | fragments value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/server_session.ml#L1283)

<a id="function-function-miniquake2-runtime-server-session-framemessagefragments-function-framemessagefragments-unicasts-multicasts-sounds-reliable-src-miniquake2-runtime-server-session-ml-1685543129"></a>
### frameMessageFragments

```ml
function frameMessageFragments(unicasts, multicasts, sounds, reliable)
```

Merge one client's typed GameImport queues by their shared emission serial. Reliable and transient buffers remain separate, but neither buffer may reorder sound around multicast/unicast commands emitted before it.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `unicasts` | `dynamic` | — | unicasts value consumed by this operation. |
| `multicasts` | `dynamic` | — | multicasts value consumed by this operation. |
| `sounds` | `dynamic` | — | sounds value consumed by this operation. |
| `reliable` | `dynamic` | — | reliable value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/server_session.ml#L1229)

<a id="function-function-miniquake2-runtime-server-session-linkedboundsvisible-function-linkedboundsvisible-collisionmodel-nodenumber-mins-maxs-row-src-miniquake2-runtime-server-session-ml-712514868"></a>
### linkedBoundsVisible

```ml
function linkedBoundsVisible(collisionModel, nodeNumber, mins, maxs, row)
```

Report whether linked bounds visible.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `collisionModel` | `dynamic` | — | collisionModel value consumed by this operation. |
| `nodeNumber` | `dynamic` | — | nodeNumber value consumed by this operation. |
| `mins` | `dynamic` | — | mins value consumed by this operation. |
| `maxs` | `dynamic` | — | maxs value consumed by this operation. |
| `row` | `dynamic` | — | row value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/server_session.ml#L251)

<a id="function-function-miniquake2-runtime-server-session-mapchangecomponents-function-mapchangecomponents-specification-src-miniquake2-runtime-server-session-ml-105855151"></a>
### mapChangeComponents

```ml
function mapChangeComponents(specification)
```

Split a classic level specification into the BSP map and optional named spawn point.  A preceding cinematic/picture segment and the unit marker are server-side metadata; the persistent game session loads the final BSP.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `specification` | `dynamic` | — | specification value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/server_session.ml#L135)

- [miniquake2.runtime.server_session.MapChangeResult](Type-miniquake2-runtime-server-session-mapchangeresult-1708667464.md) — struct
<a id="function-function-miniquake2-runtime-server-session-multicastreliabilitysubset-function-multicastreliabilitysubset-events-reliable-src-miniquake2-runtime-server-session-ml-412588359"></a>
### multicastReliabilitySubset

```ml
function multicastReliabilitySubset(events, reliable)
```

Return only multicast events whose destination has the requested reliable class. Original Quake II writes reliable messages and transient datagrams to separate client buffers, so one blocked ACK must never retain later effects.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `events` | `dynamic` | — | events value consumed by this operation. |
| `reliable` | `dynamic` | — | reliable value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/server_session.ml#L683)

<a id="function-function-miniquake2-runtime-server-session-multicastvisibletoclient-function-multicastvisibletoclient-session-event-listener-src-miniquake2-runtime-server-session-ml-1736887220"></a>
### multicastVisibleToClient

```ml
function multicastVisibleToClient(session, event, listener)
```

Report whether multicast visible to client.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `event` | `dynamic` | — | event value consumed by this operation. |
| `listener` | `dynamic` | — | listener value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/server_session.ml#L597)

<a id="function-function-miniquake2-runtime-server-session-multicastvisibletoclientfromleaf-function-multicastvisibletoclientfromleaf-session-event-listenerleafnumber-src-miniquake2-runtime-server-session-ml-192726521"></a>
### multicastVisibleToClientFromLeaf

```ml
function multicastVisibleToClientFromLeaf(session, event, listenerLeafNumber)
```

Report whether multicast visible to client from leaf.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `event` | `dynamic` | — | event value consumed by this operation. |
| `listenerLeafNumber` | `dynamic` | — | listenerLeafNumber value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/server_session.ml#L568)

<a id="function-function-miniquake2-runtime-server-session-packetentities-function-packetentities-gameexport-src-miniquake2-runtime-server-session-ml-95360200"></a>
### packetEntities

```ml
function packetEntities(gameExport)
```

Return the packet entities value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `gameExport` | `dynamic` | — | gameExport value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/server_session.ml#L221)

<a id="function-function-miniquake2-runtime-server-session-packetentitiesforclient-function-packetentitiesforclient-session-viewer-src-miniquake2-runtime-server-session-ml-1663535066"></a>
### packetEntitiesForClient

```ml
function packetEntitiesForClient(session, viewer)
```

Return the packet entities for client value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `viewer` | `dynamic` | — | viewer value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/server_session.ml#L404)

<a id="function-function-miniquake2-runtime-server-session-protocolentity-function-protocolentity-state-src-miniquake2-runtime-server-session-ml-1179878375"></a>
### protocolEntity

```ml
function protocolEntity(state)
```

Return the protocol entity value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/server_session.ml#L184)

<a id="function-function-miniquake2-runtime-server-session-protocolplayer-function-protocolplayer-edict-src-miniquake2-runtime-server-session-ml-1850054317"></a>
### protocolPlayer

```ml
function protocolPlayer(edict)
```

Return the protocol player value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `edict` | `dynamic` | — | edict value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/server_session.ml#L203)

<a id="function-function-miniquake2-runtime-server-session-queuereliableframemessages-function-queuereliableframemessages-runtime-routedunicasts-routedmulticasts-routedsounds-src-miniquake2-runtime-server-session-ml-1035356732"></a>
### queueReliableFrameMessages

```ml
function queueReliableFrameMessages(runtime, routedUnicasts, routedMulticasts, routedSounds)
```

Preflight every recipient before mutating any reliable Netchan queue. A blocked client retains the shared reliable source queues for a later frame.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `routedUnicasts` | `dynamic` | — | routedUnicasts value consumed by this operation. |
| `routedMulticasts` | `dynamic` | — | routedMulticasts value consumed by this operation. |
| `routedSounds` | `dynamic` | — | routedSounds value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/server_session.ml#L1299)

<a id="function-function-miniquake2-runtime-server-session-resetbridgelevel-function-resetbridgelevel-bridge-mapname-spawncount-collision-src-miniquake2-runtime-server-session-ml-181988092"></a>
### resetBridgeLevel

```ml
function resetBridgeLevel(bridge, mapName, spawnCount, collision)
```

Reset bridge level.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `bridge` | `dynamic` | — | bridge value consumed by this operation. |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `spawnCount` | `dynamic` | — | Number of spawn to process. |
| `collision` | `dynamic` | — | collision value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/server_session.ml#L1060)

<a id="function-function-miniquake2-runtime-server-session-routemulticasts-function-routemulticasts-session-events-src-miniquake2-runtime-server-session-ml-1707272539"></a>
### routeMulticasts

```ml
function routeMulticasts(session, events)
```

Return the route multicasts value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `events` | `dynamic` | — | events value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/server_session.ml#L609)

<a id="function-function-miniquake2-runtime-server-session-routesounds-function-routesounds-session-events-src-miniquake2-runtime-server-session-ml-1481658617"></a>
### routeSounds

```ml
function routeSounds(session, events)
```

Return the route sounds value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `events` | `dynamic` | — | events value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/server_session.ml#L530)

<a id="function-function-miniquake2-runtime-server-session-routeunicasts-function-routeunicasts-session-events-src-miniquake2-runtime-server-session-ml-973184921"></a>
### routeUnicasts

```ml
function routeUnicasts(session, events)
```

Return the route unicasts value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `events` | `dynamic` | — | events value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/server_session.ml#L645)

<a id="function-function-miniquake2-runtime-server-session-run-function-run-session-framelimit-src-miniquake2-runtime-server-session-ml-1873832608"></a>
### run

```ml
function run(session, frameLimit)
```

Runs run for the miniquake2 runtime server session workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `frameLimit` | `dynamic` | — | frameLimit value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/server_session.ml#L1495)

<a id="function-function-miniquake2-runtime-server-session-sendsnapshots-function-sendsnapshots-session-now-transientroutes-src-miniquake2-runtime-server-session-ml-2125685696"></a>
### sendSnapshots

```ml
function sendSnapshots(session, now, transientRoutes)
```

Send one stock-shaped snapshot plus accumulated transient datagram per client.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |
| `transientRoutes` | `dynamic` | — | transientRoutes value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/server_session.ml#L1354)

- [miniquake2.runtime.server_session.ServerMessageFragment](Type-miniquake2-runtime-server-session-servermessagefragment-888330905.md) — struct
- [miniquake2.runtime.server_session.ServerSession](Type-miniquake2-runtime-server-session-serversession-1099335374.md) — struct
<a id="global-global-miniquake2-runtime-server-session-serversessionclientpacketentityscratch-serversessionclientpacketentityscratch-src-miniquake2-runtime-server-session-ml-1730899280"></a>
### serverSessionClientPacketEntityScratch

```ml
serverSessionClientPacketEntityScratch
```

Stores module-wide server session client packet entity scratch state for the miniquake2 runtime server session module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/server_session.ml#L110)

<a id="global-global-miniquake2-runtime-server-session-serversessionemptymessageroutecache-serversessionemptymessageroutecache-src-miniquake2-runtime-server-session-ml-1219070582"></a>
### serverSessionEmptyMessageRouteCache

```ml
serverSessionEmptyMessageRouteCache
```

Stores module-wide server session empty message route cache state for the miniquake2 runtime server session module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/server_session.ml#L112)

<a id="global-global-miniquake2-runtime-server-session-serversessionfatpvsleafscratch-serversessionfatpvsleafscratch-src-miniquake2-runtime-server-session-ml-1627459060"></a>
### serverSessionFatPvsLeafScratch

```ml
serverSessionFatPvsLeafScratch
```

SV_FatPVS uses a fixed 64-leaf work array. The server is single-threaded,


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/server_session.ml#L108)

<a id="function-function-miniquake2-runtime-server-session-setmapchecksum-function-setmapchecksum-session-mapbytes-src-miniquake2-runtime-server-session-ml-1029642027"></a>
### setMapChecksum

```ml
function setMapChecksum(session, mapBytes)
```

Protocol 34 download clients compare the BSP's original COM_BlockChecksum before publishing a downloaded map. Core constructors intentionally accept parsed state only, so retail/bootstrap callers attach the raw bytes here.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `mapBytes` | `dynamic` | — | mapBytes value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/server_session.ml#L805)

<a id="function-function-miniquake2-runtime-server-session-setpaused-function-setpaused-session-value-src-miniquake2-runtime-server-session-ml-145802301"></a>
### setPaused

```ml
function setPaused(session, value)
```

Listen-server pause is authoritative: client commands continue to be received and acknowledged, but neither ClientThink nor the Game API world frame advances. Multiplayer always remains live.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/server_session.ml#L1482)

<a id="function-function-miniquake2-runtime-server-session-shutdown-function-shutdown-session-src-miniquake2-runtime-server-session-ml-1904908686"></a>
### shutdown

```ml
function shutdown(session)
```

Performs the shutdown operation for the miniquake2 runtime server session module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/server_session.ml#L1510)

<a id="function-function-miniquake2-runtime-server-session-soundaudibletoclient-function-soundaudibletoclient-session-event-listener-src-miniquake2-runtime-server-session-ml-685212952"></a>
### soundAudibleToClient

```ml
function soundAudibleToClient(session, event, listener)
```

Return the sound audible to client value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `event` | `dynamic` | — | event value consumed by this operation. |
| `listener` | `dynamic` | — | listener value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/server_session.ml#L519)

<a id="function-function-miniquake2-runtime-server-session-soundaudibletoclientfromleaf-function-soundaudibletoclientfromleaf-session-event-listener-listenerleafnumber-src-miniquake2-runtime-server-session-ml-427106893"></a>
### soundAudibleToClientFromLeaf

```ml
function soundAudibleToClientFromLeaf(session, event, listener, listenerLeafNumber)
```

Return the sound audible to client from leaf.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `event` | `dynamic` | — | event value consumed by this operation. |
| `listener` | `dynamic` | — | listener value consumed by this operation. |
| `listenerLeafNumber` | `dynamic` | — | listenerLeafNumber value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/server_session.ml#L490)

<a id="function-function-miniquake2-runtime-server-session-soundeventorigin-function-soundeventorigin-session-event-src-miniquake2-runtime-server-session-ml-563789504"></a>
### soundEventOrigin

```ml
function soundEventOrigin(session, event)
```

Return the sound event origin.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `event` | `dynamic` | — | event value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/server_session.ml#L470)

<a id="function-function-miniquake2-runtime-server-session-soundreliabilitysubset-function-soundreliabilitysubset-events-reliable-src-miniquake2-runtime-server-session-ml-124586459"></a>
### soundReliabilitySubset

```ml
function soundReliabilitySubset(events, reliable)
```

Return only sound events with the requested CHAN_RELIABLE state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `events` | `dynamic` | — | events value consumed by this operation. |
| `reliable` | `dynamic` | — | reliable value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/server_session.ml#L723)

<a id="function-function-miniquake2-runtime-server-session-step-function-step-session-src-miniquake2-runtime-server-session-ml-1594348134"></a>
### step

```ml
function step(session)
```

Performs the step operation for the miniquake2 runtime server session module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/server_session.ml#L1394)

<a id="function-function-miniquake2-runtime-server-session-synchronizebaselines-function-synchronizebaselines-session-src-miniquake2-runtime-server-session-ml-1249437278"></a>
### synchronizeBaselines

```ml
function synchronizeBaselines(session)
```

Synchronize baselines.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/server_session.ml#L784)

<a id="function-function-miniquake2-runtime-server-session-synchronizeconfigstrings-function-synchronizeconfigstrings-session-src-miniquake2-runtime-server-session-ml-426695910"></a>
### synchronizeConfigStrings

```ml
function synchronizeConfigStrings(session)
```

Synchronize config strings.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/server_session.ml#L743)

<a id="function-function-miniquake2-runtime-server-session-synchronizeserverstate-function-synchronizeserverstate-session-src-miniquake2-runtime-server-session-ml-1029547542"></a>
### synchronizeServerState

```ml
function synchronizeServerState(session)
```

Synchronize server state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/server_session.ml#L794)

<a id="function-function-miniquake2-runtime-server-session-unicastreliabilitysubset-function-unicastreliabilitysubset-events-reliable-src-miniquake2-runtime-server-session-ml-24089663"></a>
### unicastReliabilitySubset

```ml
function unicastReliabilitySubset(events, reliable)
```

Return only unicast events with the requested reliability class.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `events` | `dynamic` | — | events value consumed by this operation. |
| `reliable` | `dynamic` | — | reliable value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/server_session.ml#L704)

<a id="function-function-miniquake2-runtime-server-session-vector-function-vector-value-src-miniquake2-runtime-server-session-ml-272376235"></a>
### vector

```ml
function vector(value)
```

Return the vector value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/server_session.ml#L177)
