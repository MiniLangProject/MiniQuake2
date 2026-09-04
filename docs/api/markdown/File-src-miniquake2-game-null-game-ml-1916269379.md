# `src/miniquake2/game/null_game.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 game null game facilities for this project.

Package: [`miniquake2.game.null_game`](Package-miniquake2-game-null-game-1897583959.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/game/base/spawn.ml` as `bspawn` → [src/miniquake2/game/base/spawn.ml](File-src-miniquake2-game-base-spawn-ml-685876900.md)
- `miniquake2/game/constants.ml` as `gc` → [src/miniquake2/game/constants.ml](File-src-miniquake2-game-constants-ml-1723282332.md)
- `miniquake2/game/gameplay/combat.ml` as `ngcombat` → [src/miniquake2/game/gameplay/combat.ml](File-src-miniquake2-game-gameplay-combat-ml-1854285404.md)
- `miniquake2/game/gameplay/constants.ml` as `nggpconstants` → [src/miniquake2/game/gameplay/constants.ml](File-src-miniquake2-game-gameplay-constants-ml-1803115501.md)
- `miniquake2/game/gameplay/item_rules.ml` as `nggpitems` → [src/miniquake2/game/gameplay/item_rules.ml](File-src-miniquake2-game-gameplay-item-rules-ml-1747940557.md)
- `miniquake2/game/gameplay/powerups.ml` as `ngpowerups` → [src/miniquake2/game/gameplay/powerups.ml](File-src-miniquake2-game-gameplay-powerups-ml-831759227.md)
- `miniquake2/game/gameplay/registry.ml` as `ngregistry` → [src/miniquake2/game/gameplay/registry.ml](File-src-miniquake2-game-gameplay-registry-ml-1541508425.md)
- `miniquake2/game/gameplay/types.ml` as `nggtypes` → [src/miniquake2/game/gameplay/types.ml](File-src-miniquake2-game-gameplay-types-ml-2088064005.md)
- `miniquake2/game/integration/baseq2.ml` as `ngbaseq2` → [src/miniquake2/game/integration/baseq2.ml](File-src-miniquake2-game-integration-baseq2-ml-2026578472.md)
- `miniquake2/game/persistence.ml` as `gpersist` → [src/miniquake2/game/persistence.ml](File-src-miniquake2-game-persistence-ml-545577318.md)
- `miniquake2/game/player/client.ml` as `ngplayerclient` → [src/miniquake2/game/player/client.ml](File-src-miniquake2-game-player-client-ml-1308550740.md)
- `miniquake2/game/player/commands.ml` as `ngplayercommands` → [src/miniquake2/game/player/commands.ml](File-src-miniquake2-game-player-commands-ml-430416299.md)
- `miniquake2/game/player/constants.ml` as `ngplayerconstants` → [src/miniquake2/game/player/constants.ml](File-src-miniquake2-game-player-constants-ml-946982646.md)
- `miniquake2/game/player/effects.ml` as `ngplayereffects` → [src/miniquake2/game/player/effects.ml](File-src-miniquake2-game-player-effects-ml-25549151.md)
- `miniquake2/game/player/frame.ml` as `ngplayerframe` → [src/miniquake2/game/player/frame.ml](File-src-miniquake2-game-player-frame-ml-2050622310.md)
- `miniquake2/game/player/spawn.ml` as `ngplayerspawn` → [src/miniquake2/game/player/spawn.ml](File-src-miniquake2-game-player-spawn-ml-3566732.md)
- `miniquake2/game/player/types.ml` as `ngplayertypes` → [src/miniquake2/game/player/types.ml](File-src-miniquake2-game-player-types-ml-1013655302.md)
- `miniquake2/game/player/userinfo.ml` as `ngplayerinfo` → [src/miniquake2/game/player/userinfo.ml](File-src-miniquake2-game-player-userinfo-ml-352842808.md)
- `miniquake2/game/player/view.ml` as `ngplayerview` → [src/miniquake2/game/player/view.ml](File-src-miniquake2-game-player-view-ml-886735230.md)
- `miniquake2/game/private_save.ml` as `ngprivatesave` → [src/miniquake2/game/private_save.ml](File-src-miniquake2-game-private-save-ml-997540208.md)
- `miniquake2/game/types.ml` as `gt` → [src/miniquake2/game/types.ml](File-src-miniquake2-game-types-ml-1384205920.md)
- `miniquake2/game/weapons/constants.ml` as `ngweaponconstants` → [src/miniquake2/game/weapons/constants.ml](File-src-miniquake2-game-weapons-constants-ml-539739454.md)
- `miniquake2/qcommon/byteio.ml` as `ngbyteio` → [src/miniquake2/qcommon/byteio.ml](File-src-miniquake2-qcommon-byteio-ml-159119335.md)
- `miniquake2/qcommon/constants.ml` as `qc` → [src/miniquake2/qcommon/constants.ml](File-src-miniquake2-qcommon-constants-ml-1976195726.md)
- `miniquake2/qcommon/info.ml` as `nginfo` → [src/miniquake2/qcommon/info.ml](File-src-miniquake2-qcommon-info-ml-634538165.md)
- `miniquake2/qcommon/text.ml` as `ngtext` → [src/miniquake2/qcommon/text.ml](File-src-miniquake2-qcommon-text-ml-1570504148.md)
- `miniquake2/qcommon/types.ml` as `ngqtypes` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)
- `miniquake2/server/administration.ml` as `ngserveradmin` → [src/miniquake2/server/administration.ml](File-src-miniquake2-server-administration-ml-1444195484.md)
- `miniquake2/server/game_bridge.ml` as `nggamebridge` → [src/miniquake2/server/game_bridge.ml](File-src-miniquake2-server-game-bridge-ml-73559214.md)
- `std/math.ml` as `ngmath` → `../MiniLangCompilerML/std/math.ml` — external dependency
- `std/string.ml` as `ngstring` → `../MiniLangCompilerML/std/string.ml` — external dependency

## Declarations

<a id="global-global-miniquake2-game-null-game-activebaseruntime-activebaseruntime-src-miniquake2-game-null-game-ml-846323924"></a>
### activeBaseRuntime

```ml
activeBaseRuntime
```

Stores module-wide active base runtime state for the miniquake2 game null game module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L94)

<a id="global-global-miniquake2-game-null-game-activeexport-activeexport-src-miniquake2-game-null-game-ml-1328969708"></a>
### activeExport

```ml
activeExport
```

Stores module-wide active export state for the miniquake2 game null game module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L70)

<a id="global-global-miniquake2-game-null-game-activeimports-activeimports-src-miniquake2-game-null-game-ml-892723532"></a>
### activeImports

```ml
activeImports
```

Stores module-wide active imports state for the miniquake2 game null game module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L64)

<a id="global-global-miniquake2-game-null-game-activemaxclients-activemaxclients-src-miniquake2-game-null-game-ml-2127076392"></a>
### activeMaxClients

```ml
activeMaxClients
```

Stores module-wide active max clients state for the miniquake2 game null game module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L98)

<a id="global-global-miniquake2-game-null-game-activeplayercontext-activeplayercontext-src-miniquake2-game-null-game-ml-136225216"></a>
### activePlayerContext

```ml
activePlayerContext
```

Stores module-wide active player context state for the miniquake2 game null game module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L96)

<a id="global-global-miniquake2-game-null-game-activepmovecontentmask-activepmovecontentmask-src-miniquake2-game-null-game-ml-2144017940"></a>
### activePmoveContentMask

```ml
activePmoveContentMask
```

Stores module-wide active pmove content mask state for the miniquake2 game null game module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L104)

<a id="global-global-miniquake2-game-null-game-activepmovepassentity-activepmovepassentity-src-miniquake2-game-null-game-ml-848400296"></a>
### activePmovePassEntity

```ml
activePmovePassEntity
```

Stores module-wide active pmove pass entity state for the miniquake2 game null game module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L102)

<a id="global-global-miniquake2-game-null-game-activeskill-activeskill-src-miniquake2-game-null-game-ml-433392868"></a>
### activeSkill

```ml
activeSkill
```

Stores module-wide active skill state for the miniquake2 game null game module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L100)

<a id="function-function-miniquake2-game-null-game-aiareasconnected-function-aiareasconnected-first-second-src-miniquake2-game-null-game-ml-1583400466"></a>
### aiAreasConnected

```ml
function aiAreasConnected(first, second)
```

Report whether ai areas connected.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `dynamic` | — | first value consumed by this operation. |
| `second` | `dynamic` | — | second value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L389)

<a id="function-function-miniquake2-game-null-game-aiinphs-function-aiinphs-first-second-src-miniquake2-game-null-game-ml-1658643446"></a>
### aiInPHS

```ml
function aiInPHS(first, second)
```

Return the ai in phs value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `dynamic` | — | first value consumed by this operation. |
| `second` | `dynamic` | — | second value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L381)

<a id="function-function-miniquake2-game-null-game-aitracevisible-function-aitracevisible-actor-other-src-miniquake2-game-null-game-ml-1279989103"></a>
### aiTraceVisible

```ml
function aiTraceVisible(actor, other)
```

Report whether ai trace visible.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L370)

<a id="function-function-miniquake2-game-null-game-apiinstalled-function-apiinstalled-src-miniquake2-game-null-game-ml-1024622550"></a>
### apiInstalled

```ml
function apiInstalled()
```

Return the api installed value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L1946)

<a id="function-function-miniquake2-game-null-game-baseedicts-function-baseedicts-src-miniquake2-game-null-game-ml-2137795642"></a>
### baseEdicts

```ml
function baseEdicts()
```

Return the base edicts value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L1922)

<a id="function-function-miniquake2-game-null-game-baseruntime-function-baseruntime-src-miniquake2-game-null-game-ml-1420215968"></a>
### baseRuntime

```ml
function baseRuntime()
```

Return the base runtime value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L1934)

<a id="function-function-miniquake2-game-null-game-baseworldareaportal-function-baseworldareaportal-style-isopen-src-miniquake2-game-null-game-ml-493613337"></a>
### baseWorldAreaPortal

```ml
function baseWorldAreaPortal(style, isOpen)
```

Return the base world area portal value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `style` | `dynamic` | — | style value consumed by this operation. |
| `isOpen` | `dynamic` | — | isOpen value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L174)

<a id="function-function-miniquake2-game-null-game-baseworldbeginintermission-function-baseworldbeginintermission-entity-mapname-src-miniquake2-game-null-game-ml-1665418256"></a>
### baseWorldBeginIntermission

```ml
function baseWorldBeginIntermission(entity, mapName)
```

Begin base world intermission.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L208)

<a id="function-function-miniquake2-game-null-game-baseworldcenter-function-baseworldcenter-entity-message-src-miniquake2-game-null-game-ml-42654210"></a>
### baseWorldCenter

```ml
function baseWorldCenter(entity, message)
```

Return the base world center value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `message` | `dynamic` | — | Human-readable message associated with the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L138)

<a id="function-function-miniquake2-game-null-game-baseworldchangelevel-function-baseworldchangelevel-entity-other-activator-mapname-src-miniquake2-game-null-game-ml-746216571"></a>
### baseWorldChangeLevel

```ml
function baseWorldChangeLevel(entity, other, activator, mapName)
```

Return the base world change level value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L277)

<a id="function-function-miniquake2-game-null-game-baseworldlink-function-baseworldlink-entity-src-miniquake2-game-null-game-ml-352032651"></a>
### baseWorldLink

```ml
function baseWorldLink(entity)
```

Link base world.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L318)

<a id="function-function-miniquake2-game-null-game-baseworldlog-function-baseworldlog-message-src-miniquake2-game-null-game-ml-694930327"></a>
### baseWorldLog

```ml
function baseWorldLog(message)
```

Return the base world log value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `message` | `dynamic` | — | Human-readable message associated with the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L130)

<a id="function-function-miniquake2-game-null-game-baseworldsound-function-baseworldsound-entity-soundname-src-miniquake2-game-null-game-ml-1317179941"></a>
### baseWorldSound

```ml
function baseWorldSound(entity, soundName)
```

Return the base world sound value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `soundName` | `dynamic` | — | soundName value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L148)

<a id="function-function-miniquake2-game-null-game-baseworldtargetexplosion-function-baseworldtargetexplosion-origin-src-miniquake2-game-null-game-ml-212493136"></a>
### baseWorldTargetExplosion

```ml
function baseWorldTargetExplosion(origin)
```

Return the base world target explosion value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `origin` | `dynamic` | — | origin value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L181)

<a id="function-function-miniquake2-game-null-game-baseworldtargetsplash-function-baseworldtargetsplash-origin-direction-count-sounds-src-miniquake2-game-null-game-ml-715974762"></a>
### baseWorldTargetSplash

```ml
function baseWorldTargetSplash(origin, direction, count, sounds)
```

Return the base world target splash value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `origin` | `dynamic` | — | origin value consumed by this operation. |
| `direction` | `dynamic` | — | direction value consumed by this operation. |
| `count` | `dynamic` | — | Number of items or units to process. |
| `sounds` | `dynamic` | — | sounds value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L194)

<a id="function-function-miniquake2-game-null-game-capturerunframeorigins-function-capturerunframeorigins-exporttable-src-miniquake2-game-null-game-ml-1904899102"></a>
### captureRunFrameOrigins

```ml
function captureRunFrameOrigins(exportTable)
```

Capture the stock `s.old_origin = s.origin` value-copy contract before any player, mover, monster or projectile mutates the exported state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `exportTable` | `dynamic` | — | exportTable value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L527)

<a id="function-function-miniquake2-game-null-game-chatfloodallowed-function-chatfloodallowed-slot-player-context-src-miniquake2-game-null-game-ml-697925896"></a>
### chatFloodAllowed

```ml
function chatFloodAllowed(slot, player, context)
```

Return the chat flood allowed value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `slot` | `dynamic` | — | slot value consumed by this operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L1298)

<a id="function-function-miniquake2-game-null-game-chatteamname-function-chatteamname-player-dmflags-src-miniquake2-game-null-game-ml-1857009253"></a>
### chatTeamName

```ml
function chatTeamName(player, dmFlags)
```

Return the chat team name.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `dmFlags` | `dynamic` | — | dmFlags value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L1269)

<a id="function-function-miniquake2-game-null-game-cheatsallowed-function-cheatsallowed-slot-context-src-miniquake2-game-null-game-ml-2030342991"></a>
### cheatsAllowed

```ml
function cheatsAllowed(slot, context)
```

Return the cheats allowed value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `slot` | `dynamic` | — | slot value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L1381)

<a id="function-function-miniquake2-game-null-game-checkedclientedict-function-checkedclientedict-entity-operation-src-miniquake2-game-null-game-ml-318444512"></a>
### checkedClientEdict

```ml
function checkedClientEdict(entity, operation)
```

Return the checked client edict value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `operation` | `dynamic` | — | operation value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L1006)

<a id="function-function-miniquake2-game-null-game-clientbegin-function-clientbegin-entity-src-miniquake2-game-null-game-ml-1842410157"></a>
### ClientBegin

```ml
function ClientBegin(entity)
```

Begin client.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L1038)

<a id="function-function-miniquake2-game-null-game-clientcommand-function-clientcommand-entity-src-miniquake2-game-null-game-ml-1429130421"></a>
### ClientCommand

```ml
function ClientCommand(entity)
```

Dispatch the complete stock baseq2 client-command surface. Intermission and cheat gates are checked here so individual command helpers cannot bypass them.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L1497)

<a id="global-global-miniquake2-game-null-game-clientcommandcount-clientcommandcount-src-miniquake2-game-null-game-ml-2020201162"></a>
### clientCommandCount

```ml
clientCommandCount
```

Stores module-wide client command count state for the miniquake2 game null game module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L86)

<a id="function-function-miniquake2-game-null-game-clientconnect-function-clientconnect-entity-userinfo-src-miniquake2-game-null-game-ml-490153336"></a>
### ClientConnect

```ml
function ClientConnect(entity, userInfo)
```

Performs the ClientConnect operation for the miniquake2 game null game module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `userInfo` | `dynamic` | — | userInfo value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L1020)

<a id="function-function-miniquake2-game-null-game-clientdisconnect-function-clientdisconnect-entity-src-miniquake2-game-null-game-ml-1930304273"></a>
### ClientDisconnect

```ml
function ClientDisconnect(entity)
```

Return the client disconnect value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L1075)

<a id="function-function-miniquake2-game-null-game-clientthink-function-clientthink-entity-command-src-miniquake2-game-null-game-ml-1349701494"></a>
### ClientThink

```ml
function ClientThink(entity, command)
```

Run client.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `command` | `dynamic` | — | command value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L1709)

<a id="function-function-miniquake2-game-null-game-clientuserinfochanged-function-clientuserinfochanged-entity-userinfo-src-miniquake2-game-null-game-ml-879432522"></a>
### ClientUserinfoChanged

```ml
function ClientUserinfoChanged(entity, userInfo)
```

Return the client userinfo changed value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `userInfo` | `dynamic` | — | userInfo value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L1061)

<a id="function-function-miniquake2-game-null-game-configuredgameskill-function-configuredgameskill-src-miniquake2-game-null-game-ml-630328220"></a>
### configuredGameSkill

```ml
function configuredGameSkill()
```

Return the configured game skill value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L1880)

<a id="function-function-miniquake2-game-null-game-configureintegratedruntime-function-configureintegratedruntime-runtime-playercontext-src-miniquake2-game-null-game-ml-2116610270"></a>
### configureIntegratedRuntime

```ml
function configureIntegratedRuntime(runtime, playerContext)
```

Configure integrated runtime.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `playerContext` | `dynamic` | — | playerContext value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L475)

<a id="function-function-miniquake2-game-null-game-configuremaxclients-function-configuremaxclients-count-src-miniquake2-game-null-game-ml-1741091355"></a>
### configureMaxClients

```ml
function configureMaxClients(count)
```

Configure max clients.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `count` | `dynamic` | — | Number of items or units to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L1857)

<a id="function-function-miniquake2-game-null-game-configureskill-function-configureskill-skill-src-miniquake2-game-null-game-ml-1438620273"></a>
### configureSkill

```ml
function configureSkill(skill)
```

Configure skill.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `skill` | `dynamic` | — | skill value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L1868)

<a id="global-global-miniquake2-game-null-game-currententitystring-currententitystring-src-miniquake2-game-null-game-ml-1861307920"></a>
### currentEntityString

```ml
currentEntityString
```

Stores module-wide current entity string state for the miniquake2 game null game module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L80)

<a id="global-global-miniquake2-game-null-game-currentmap-currentmap-src-miniquake2-game-null-game-ml-82182078"></a>
### currentMap

```ml
currentMap
```

Stores module-wide current map state for the miniquake2 game null game module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L76)

<a id="global-global-miniquake2-game-null-game-currentspawnpoint-currentspawnpoint-src-miniquake2-game-null-game-ml-1956894104"></a>
### currentSpawnPoint

```ml
currentSpawnPoint
```

Stores module-wide current spawn point state for the miniquake2 game null game module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L78)

<a id="constant-constant-miniquake2-game-null-game-deathmatch-statusbar-const-deathmatch-statusbar-yb-24-xv-0-hnum-xv-50-pic-0-if-2-xv-100-anum-xv-150-pic-2-endif-if-4-xv-200-rnum-xv-250-pic-4-endif-if-6-xv-296-pic-6-endif-yb-50-if-7-xv-0-pic-7-xv-26-yb-42-stat-string-8-yb-50-endif-if-9-xv-246-num-2-10-xv-296-pic-9-endif-if-11-xv-148-pic-11-endif-xr-50-yt-2-num-3-14-if-17-xv-0-yb-58-string2-spectator-mode-endif-if-16-xv-0-yb-68-string-chasing-xv-64-stat-string-16-endif-src-miniquake2-game-null-game-ml-1413338012"></a>
### DEATHMATCH_STATUSBAR

```ml
const DEATHMATCH_STATUSBAR = "yb -24 xv 0 hnum xv 50 pic 0 if 2 xv 100 anum xv 150 pic 2 endif if 4 xv 200 rnum xv 250 pic 4 endif if 6 xv 296 pic 6 endif yb -50 if 7 xv 0 pic 7 xv 26 yb -42 stat_string 8 yb -50 endif if 9 xv 246 num 2 10 xv 296 pic 9 endif if 11 xv 148 pic 11 endif xr -50 yt 2 num 3 14 if 17 xv 0 yb -58 string2 \"SPECTATOR MODE\" endif if 16 xv 0 yb -68 string \"Chasing\" xv 64 stat_string 16 endif"
```

Defines the deathmatch statusbar constant used by the miniquake2 game null game module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L49)

<a id="function-function-miniquake2-game-null-game-edictat-function-edictat-index-src-miniquake2-game-null-game-ml-1813836548"></a>
### edictAt

```ml
function edictAt(index)
```

Return the edict for the requested position.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `index` | `dynamic` | — | Zero-based index of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L1887)

<a id="function-function-miniquake2-game-null-game-edictindex-function-edictindex-entity-src-miniquake2-game-null-game-ml-1414931549"></a>
### edictIndex

```ml
function edictIndex(entity)
```

Return the edict index.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L1896)

<a id="function-function-miniquake2-game-null-game-edictoffset-function-edictoffset-index-src-miniquake2-game-null-game-ml-373583056"></a>
### edictOffset

```ml
function edictOffset(index)
```

Return the edict offset.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `index` | `dynamic` | — | Zero-based index of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L1908)

<a id="function-function-miniquake2-game-null-game-executeitemdrop-function-executeitemdrop-slot-player-context-item-src-miniquake2-game-null-game-ml-677440849"></a>
### executeItemDrop

```ml
function executeItemDrop(slot, player, context, item)
```

Execute item drop.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `slot` | `dynamic` | — | slot value consumed by this operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `item` | `dynamic` | — | item value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L1482)

<a id="function-function-miniquake2-game-null-game-findplayer-function-findplayer-index-src-miniquake2-game-null-game-ml-1556151824"></a>
### findPlayer

```ml
function findPlayer(index)
```

Find player.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `index` | `dynamic` | — | Zero-based index of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L566)

<a id="global-global-miniquake2-game-null-game-framenumber-framenumber-src-miniquake2-game-null-game-ml-1586573004"></a>
### frameNumber

```ml
frameNumber
```

Stores module-wide frame number state for the miniquake2 game null game module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L82)

<a id="function-function-miniquake2-game-null-game-getgameapi-function-getgameapi-imports-src-miniquake2-game-null-game-ml-1478054190"></a>
### GetGameApi

```ml
function GetGameApi(imports)
```

Return game api.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `imports` | `dynamic` | — | imports value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L1825)

<a id="function-function-miniquake2-game-null-game-giveitems-function-giveitems-player-context-arguments-src-miniquake2-game-null-game-ml-1316079252"></a>
### giveItems

```ml
function giveItems(player, context, arguments)
```

Return the give items value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `arguments` | `dynamic` | — | arguments value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L1395)

<a id="function-function-miniquake2-game-null-game-helplayout-function-helplayout-context-src-miniquake2-game-null-game-ml-1265187519"></a>
### helpLayout

```ml
function helpLayout(context)
```

Return the help layout value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L1173)

<a id="function-function-miniquake2-game-null-game-init-function-init-src-miniquake2-game-null-game-ml-513695654"></a>
### Init

```ml
function Init()
```

Performs the Init operation for the miniquake2 game null game module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L697)

<a id="global-global-miniquake2-game-null-game-initialized-initialized-src-miniquake2-game-null-game-ml-1633570040"></a>
### initialized

```ml
initialized
```

Stores module-wide initialized state for the miniquake2 game null game module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L72)

<a id="global-global-miniquake2-game-null-game-lastspawnresult-lastspawnresult-src-miniquake2-game-null-game-ml-1671236232"></a>
### lastSpawnResult

```ml
lastSpawnResult
```

Stores module-wide last spawn result state for the miniquake2 game null game module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L92)

<a id="global-global-miniquake2-game-null-game-lastuserinfo-lastuserinfo-src-miniquake2-game-null-game-ml-301031758"></a>
### lastUserInfo

```ml
lastUserInfo
```

Stores module-wide last user info state for the miniquake2 game null game module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L84)

<a id="function-function-miniquake2-game-null-game-lifecyclesnapshot-function-lifecyclesnapshot-src-miniquake2-game-null-game-ml-65367862"></a>
### lifecycleSnapshot

```ml
function lifecycleSnapshot()
```

Return the lifecycle snapshot value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L1916)

<a id="function-function-miniquake2-game-null-game-linkmanagededicts-function-linkmanagededicts-src-miniquake2-game-null-game-ml-2052336000"></a>
### linkManagedEdicts

```ml
function linkManagedEdicts()
```

Link managed edicts.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L503)

<a id="function-function-miniquake2-game-null-game-makeedicts-function-makeedicts-count-src-miniquake2-game-null-game-ml-1572132543"></a>
### makeEdicts

```ml
function makeEdicts(count)
```

Create edicts.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `count` | `dynamic` | — | Number of items or units to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L677)

<a id="global-global-miniquake2-game-null-game-maploaded-maploaded-src-miniquake2-game-null-game-ml-669347412"></a>
### mapLoaded

```ml
mapLoaded
```

Stores module-wide map loaded state for the miniquake2 game null game module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L74)

<a id="function-function-miniquake2-game-null-game-normalizedchatbody-function-normalizedchatbody-command-arguments-includecommand-src-miniquake2-game-null-game-ml-1923498452"></a>
### normalizedChatBody

```ml
function normalizedChatBody(command, arguments, includeCommand)
```

Return the normalized chat body value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `command` | `dynamic` | — | command value consumed by this operation. |
| `arguments` | `dynamic` | — | arguments value consumed by this operation. |
| `includeCommand` | `dynamic` | — | includeCommand value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L1335)

<a id="function-function-miniquake2-game-null-game-onsamechatteam-function-onsamechatteam-first-second-dmflags-src-miniquake2-game-null-game-ml-809691166"></a>
### onSameChatTeam

```ml
function onSameChatTeam(first, second, dmFlags)
```

Report whether on same chat team.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `dynamic` | — | first value consumed by this operation. |
| `second` | `dynamic` | — | second value consumed by this operation. |
| `dmFlags` | `dynamic` | — | dmFlags value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L1289)

<a id="function-function-miniquake2-game-null-game-playercontext-function-playercontext-src-miniquake2-game-null-game-ml-1744448694"></a>
### playerContext

```ml
function playerContext()
```

Return the player context value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L1940)

<a id="function-function-miniquake2-game-null-game-playercopybody-function-playercopybody-player-src-miniquake2-game-null-game-ml-1404290647"></a>
### playerCopyBody

```ml
function playerCopyBody(player)
```

Copy the dead client into BaseQ2's fixed eight-entry body queue.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L466)

<a id="function-function-miniquake2-game-null-game-playerdamage-function-playerdamage-context-player-amount-damageflags-meansofdeath-src-miniquake2-game-null-game-ml-1849748295"></a>
### playerDamage

```ml
function playerDamage(context, player, amount, damageFlags, meansOfDeath)
```

Return the player damage value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `amount` | `dynamic` | — | amount value consumed by this operation. |
| `damageFlags` | `dynamic` | — | damageFlags value consumed by this operation. |
| `meansOfDeath` | `dynamic` | — | meansOfDeath value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L426)

<a id="function-function-miniquake2-game-null-game-playerforedict-function-playerforedict-slot-operation-createifmissing-src-miniquake2-game-null-game-ml-1289222740"></a>
### playerForEdict

```ml
function playerForEdict(slot, operation, createIfMissing)
```

Return the player for edict value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `slot` | `dynamic` | — | slot value consumed by this operation. |
| `operation` | `dynamic` | — | operation value consumed by this operation. |
| `createIfMissing` | `dynamic` | — | createIfMissing value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L579)

<a id="function-function-miniquake2-game-null-game-playerlisttext-function-playerlisttext-context-src-miniquake2-game-null-game-ml-1971149511"></a>
### playerListText

```ml
function playerListText(context)
```

Return the player list text value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L1240)

<a id="function-function-miniquake2-game-null-game-playerpmovetrace-function-playerpmovetrace-start-mins-maxs-finish-src-miniquake2-game-null-game-ml-1019407029"></a>
### playerPmoveTrace

```ml
function playerPmoveTrace(start, mins, maxs, finish)
```

Trace player pmove.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `mins` | `dynamic` | — | mins value consumed by this operation. |
| `maxs` | `dynamic` | — | maxs value consumed by this operation. |
| `finish` | `dynamic` | — | finish value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L111)

<a id="function-function-miniquake2-game-null-game-playerstext-function-playerstext-context-src-miniquake2-game-null-game-ml-779766737"></a>
### playersText

```ml
function playersText(context)
```

Return the players text value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L1203)

<a id="function-function-miniquake2-game-null-game-playertouchentity-function-playertouchentity-entity-player-src-miniquake2-game-null-game-ml-1549255706"></a>
### playerTouchEntity

```ml
function playerTouchEntity(entity, player)
```

Handle player entity.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L414)

<a id="function-function-miniquake2-game-null-game-playertouchtriggers-function-playertouchtriggers-player-src-miniquake2-game-null-game-ml-630359917"></a>
### playerTouchTriggers

```ml
function playerTouchTriggers(player)
```

Handle player triggers.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L396)

<a id="function-function-miniquake2-game-null-game-publishrunframeorigins-function-publishrunframeorigins-exporttable-capturedcount-src-miniquake2-game-null-game-ml-605921561"></a>
### publishRunFrameOrigins

```ml
function publishRunFrameOrigins(exportTable, capturedCount)
```

Reapply captured origins after managed world synchronization. Internal world records may use their own historical positions, but Protocol EntityState must always expose the value captured at the start of this server frame.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `exportTable` | `dynamic` | — | exportTable value consumed by this operation. |
| `capturedCount` | `dynamic` | — | Number of captured to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L547)

<a id="function-function-miniquake2-game-null-game-readgame-function-readgame-filename-src-miniquake2-game-null-game-ml-1676810563"></a>
### ReadGame

```ml
function ReadGame(filename)
```

Read game.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `filename` | `dynamic` | — | filename value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L979)

<a id="function-function-miniquake2-game-null-game-readlevel-function-readlevel-filename-src-miniquake2-game-null-game-ml-1791622123"></a>
### ReadLevel

```ml
function ReadLevel(filename)
```

Read level.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `filename` | `dynamic` | — | filename value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L996)

<a id="function-function-miniquake2-game-null-game-requirefunction-function-requirefunction-value-name-src-miniquake2-game-null-game-ml-1642563896"></a>
### requireFunction

```ml
function requireFunction(value, name)
```

Require function.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L599)

<a id="function-function-miniquake2-game-null-game-requireinitialized-function-requireinitialized-operation-src-miniquake2-game-null-game-ml-275041029"></a>
### requireInitialized

```ml
function requireInitialized(operation)
```

Require initialized.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `operation` | `dynamic` | — | operation value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L668)

<a id="function-function-miniquake2-game-null-game-requireinstalled-function-requireinstalled-operation-src-miniquake2-game-null-game-ml-1203229589"></a>
### requireInstalled

```ml
function requireInstalled(operation)
```

Require installed.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `operation` | `dynamic` | — | operation value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L660)

<a id="function-function-miniquake2-game-null-game-restoremanagedimage-function-restoremanagedimage-image-src-miniquake2-game-null-game-ml-1525978569"></a>
### restoreManagedImage

```ml
function restoreManagedImage(image)
```

Restore managed image.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `image` | `dynamic` | — | image value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L921)

<a id="function-function-miniquake2-game-null-game-runframe-function-runframe-src-miniquake2-game-null-game-ml-869590806"></a>
### RunFrame

```ml
function RunFrame()
```

Run frame.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L1734)

<a id="global-global-miniquake2-game-null-game-runframeedictscratch-runframeedictscratch-src-miniquake2-game-null-game-ml-937441506"></a>
### runFrameEdictScratch

```ml
runFrameEdictScratch
```

G_RunFrame snapshots every edict origin before gameplay. Keep both the value


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L66)

<a id="global-global-miniquake2-game-null-game-runframeoriginscratch-runframeoriginscratch-src-miniquake2-game-null-game-ml-1014176488"></a>
### runFrameOriginScratch

```ml
runFrameOriginScratch
```

Stores module-wide run frame origin scratch state for the miniquake2 game null game module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L68)

<a id="function-function-miniquake2-game-null-game-runtimeedict-function-runtimeedict-number-src-miniquake2-game-null-game-ml-1002075327"></a>
### runtimeEdict

```ml
function runtimeEdict(number)
```

Return the runtime edict value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `number` | `dynamic` | — | number value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L122)

<a id="function-function-miniquake2-game-null-game-scoreboardlayout-function-scoreboardlayout-context-src-miniquake2-game-null-game-ml-1336068627"></a>
### scoreboardLayout

```ml
function scoreboardLayout(context)
```

p_hud.c DeathmatchScoreboardMessage, retaining its score order, 12-client display bound and Protocol-34 "client" layout command.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L1107)

<a id="function-function-miniquake2-game-null-game-sendchat-function-sendchat-slot-player-context-team-includecommand-command-src-miniquake2-game-null-game-ml-1597675531"></a>
### sendChat

```ml
function sendChat(slot, player, context, team, includeCommand, command)
```

Send chat.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `slot` | `dynamic` | — | slot value consumed by this operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `team` | `dynamic` | — | team value consumed by this operation. |
| `includeCommand` | `dynamic` | — | includeCommand value consumed by this operation. |
| `command` | `dynamic` | — | command value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L1355)

<a id="function-function-miniquake2-game-null-game-sendinventory-function-sendinventory-slot-player-src-miniquake2-game-null-game-ml-658580235"></a>
### sendInventory

```ml
function sendInventory(slot, player)
```

Send inventory.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `slot` | `dynamic` | — | slot value consumed by this operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L1089)

<a id="function-function-miniquake2-game-null-game-sendlayout-function-sendlayout-slot-layout-src-miniquake2-game-null-game-ml-1910916992"></a>
### sendLayout

```ml
function sendLayout(slot, layout)
```

Send layout.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `slot` | `dynamic` | — | slot value consumed by this operation. |
| `layout` | `dynamic` | — | layout value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L1157)

<a id="function-function-miniquake2-game-null-game-sendscoreboard-function-sendscoreboard-slot-context-src-miniquake2-game-null-game-ml-853079199"></a>
### sendScoreboard

```ml
function sendScoreboard(slot, context)
```

Send scoreboard.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `slot` | `dynamic` | — | slot value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L1167)

<a id="function-function-miniquake2-game-null-game-servercommand-function-servercommand-src-miniquake2-game-null-game-ml-700374710"></a>
### ServerCommand

```ml
function ServerCommand()
```

Return the server command value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L1803)

<a id="global-global-miniquake2-game-null-game-servercommandcount-servercommandcount-src-miniquake2-game-null-game-ml-1122616970"></a>
### serverCommandCount

```ml
serverCommandCount
```

Stores module-wide server command count state for the miniquake2 game null game module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L88)

<a id="function-function-miniquake2-game-null-game-shutdown-function-shutdown-src-miniquake2-game-null-game-ml-1620672478"></a>
### Shutdown

```ml
function Shutdown()
```

Performs the Shutdown operation for the miniquake2 game null game module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L732)

<a id="constant-constant-miniquake2-game-null-game-single-statusbar-const-single-statusbar-yb-24-xv-0-hnum-xv-50-pic-0-if-2-xv-100-anum-xv-150-pic-2-endif-if-4-xv-200-rnum-xv-250-pic-4-endif-if-6-xv-296-pic-6-endif-yb-50-if-7-xv-0-pic-7-xv-26-yb-42-stat-string-8-yb-50-endif-if-9-xv-262-num-2-10-xv-296-pic-9-endif-if-11-xv-148-pic-11-endif-src-miniquake2-game-null-game-ml-2073718763"></a>
### SINGLE_STATUSBAR

```ml
const SINGLE_STATUSBAR = "yb -24 xv 0 hnum xv 50 pic 0 if 2 xv 100 anum xv 150 pic 2 endif if 4 xv 200 rnum xv 250 pic 4 endif if 6 xv 296 pic 6 endif yb -50 if 7 xv 0 pic 7 xv 26 yb -42 stat_string 8 yb -50 endif if 9 xv 262 num 2 10 xv 296 pic 9 endif if 11 xv 148 pic 11 endif"
```

Original BaseQ2 layout programs. Keeping each program in one immutable


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L47)

<a id="global-global-miniquake2-game-null-game-spawnedbaseedicts-spawnedbaseedicts-src-miniquake2-game-null-game-ml-1108663384"></a>
### spawnedBaseEdicts

```ml
spawnedBaseEdicts
```

Stores module-wide spawned base edicts state for the miniquake2 game null game module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L90)

<a id="function-function-miniquake2-game-null-game-spawnentities-function-spawnentities-mapname-entitystring-spawnpoint-src-miniquake2-game-null-game-ml-1510627824"></a>
### SpawnEntities

```ml
function SpawnEntities(mapName, entityString, spawnPoint)
```

Spawn entities.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `entityString` | `dynamic` | — | entityString value consumed by this operation. |
| `spawnPoint` | `dynamic` | — | spawnPoint value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L758)

<a id="function-function-miniquake2-game-null-game-spawnresult-function-spawnresult-src-miniquake2-game-null-game-ml-713389354"></a>
### spawnResult

```ml
function spawnResult()
```

Spawn result.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L1928)

<a id="global-global-miniquake2-game-null-game-stocklightstyles-stocklightstyles-src-miniquake2-game-null-game-ml-1504943896"></a>
### stockLightStyles

```ml
stockLightStyles
```

Stores module-wide stock light styles state for the miniquake2 game null game module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L52)

<a id="function-function-miniquake2-game-null-game-validategameimport-function-validategameimport-imports-src-miniquake2-game-null-game-ml-189199294"></a>
### validateGameImport

```ml
function validateGameImport(imports)
```

Validate game import.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `imports` | `dynamic` | — | imports value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L608)

<a id="function-function-miniquake2-game-null-game-writegame-function-writegame-filename-autosave-src-miniquake2-game-null-game-ml-1994046087"></a>
### WriteGame

```ml
function WriteGame(filename, autosave)
```

Write game.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `filename` | `dynamic` | — | filename value consumed by this operation. |
| `autosave` | `dynamic` | — | autosave value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L912)

<a id="function-function-miniquake2-game-null-game-writelevel-function-writelevel-filename-src-miniquake2-game-null-game-ml-1856138955"></a>
### WriteLevel

```ml
function WriteLevel(filename)
```

Write level.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `filename` | `dynamic` | — | filename value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/null_game.ml#L988)
