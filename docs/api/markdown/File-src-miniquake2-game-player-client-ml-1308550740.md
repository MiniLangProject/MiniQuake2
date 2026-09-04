# `src/miniquake2/game/player/client.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 game player client facilities for this project.

Package: [`miniquake2.game.player.client`](Package-miniquake2-game-player-client-1821995213.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/game/gameplay/weapons.ml` as `gplayerweapons` → [src/miniquake2/game/gameplay/weapons.ml](File-src-miniquake2-game-gameplay-weapons-ml-233473665.md)
- `miniquake2/game/player/constants.ml` as `gplayerconstants` → [src/miniquake2/game/player/constants.ml](File-src-miniquake2-game-player-constants-ml-946982646.md)
- `miniquake2/game/player/effects.ml` as `gplayereffects` → [src/miniquake2/game/player/effects.ml](File-src-miniquake2-game-player-effects-ml-25549151.md)
- `miniquake2/game/player/spawn.ml` as `gplayerspawn` → [src/miniquake2/game/player/spawn.ml](File-src-miniquake2-game-player-spawn-ml-3566732.md)
- `miniquake2/game/player/types.ml` as `gplayertypes` → [src/miniquake2/game/player/types.ml](File-src-miniquake2-game-player-types-ml-1013655302.md)
- `miniquake2/game/player/userinfo.ml` as `gplayeruserinfo` → [src/miniquake2/game/player/userinfo.ml](File-src-miniquake2-game-player-userinfo-ml-352842808.md)
- `miniquake2/game/types.ml` as `gtypes` → [src/miniquake2/game/types.ml](File-src-miniquake2-game-types-ml-1384205920.md)
- `miniquake2/physics/vector.ml` as `gplayervector` → [src/miniquake2/physics/vector.ml](File-src-miniquake2-physics-vector-ml-1287862571.md)
- `miniquake2/qcommon/byteio.ml` as `qbyteio` → [src/miniquake2/qcommon/byteio.ml](File-src-miniquake2-qcommon-byteio-ml-159119335.md)
- `miniquake2/qcommon/constants.ml` as `qconstants` → [src/miniquake2/qcommon/constants.ml](File-src-miniquake2-qcommon-constants-ml-1976195726.md)
- `miniquake2/qcommon/info.ml` as `qinfo` → [src/miniquake2/qcommon/info.ml](File-src-miniquake2-qcommon-info-ml-634538165.md)
- `miniquake2/qcommon/types.ml` as `qtypes` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)
- `std/math.ml` as `gplayermath` → `../MiniLangCompilerML/std/math.ml` — external dependency

## Declarations

<a id="function-function-miniquake2-game-player-client-angletoshort-function-angletoshort-angle-src-miniquake2-game-player-client-ml-313660386"></a>
### angleToShort

```ml
function angleToShort(angle)
```

Return the angle to short value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `angle` | `dynamic` | — | angle value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/client.ml#L54)

<a id="function-function-miniquake2-game-player-client-chasenext-function-chasenext-context-player-src-miniquake2-game-player-client-ml-555127285"></a>
### ChaseNext

```ml
function ChaseNext(context, player)
```

Select the next chase target in client-edict order, wrapping at maxclients.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/client.ml#L324)

<a id="function-function-miniquake2-game-player-client-chaseprev-function-chaseprev-context-player-src-miniquake2-game-player-client-ml-1250463625"></a>
### ChasePrev

```ml
function ChasePrev(context, player)
```

Select the previous chase target in client-edict order, wrapping at one.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/client.ml#L350)

<a id="function-function-miniquake2-game-player-client-chasetargeteligible-function-chasetargeteligible-candidate-src-miniquake2-game-player-client-ml-1957420048"></a>
### chaseTargetEligible

```ml
function chaseTargetEligible(candidate)
```

Report whether a player is a live, non-spectator chase target.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `candidate` | `dynamic` | — | candidate value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/client.ml#L316)

<a id="function-function-miniquake2-game-player-client-clientbegin-function-clientbegin-context-player-src-miniquake2-game-player-client-ml-1581847059"></a>
### ClientBegin

```ml
function ClientBegin(context, player)
```

Begin client.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/client.ml#L200)

<a id="function-function-miniquake2-game-player-client-clientbeginserverframe-function-clientbeginserverframe-context-player-src-miniquake2-game-player-client-ml-1777077915"></a>
### ClientBeginServerFrame

```ml
function ClientBeginServerFrame(context, player)
```

Begin client server frame.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/client.ml#L597)

<a id="function-function-miniquake2-game-player-client-clientthink-function-clientthink-context-player-command-src-miniquake2-game-player-client-ml-1776133390"></a>
### ClientThink

```ml
function ClientThink(context, player, command)
```

Run client.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `command` | `dynamic` | — | command value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/client.ml#L468)

<a id="function-function-miniquake2-game-player-client-copyinventorycounts-function-copyinventorycounts-counts-src-miniquake2-game-player-client-ml-1555350297"></a>
### copyInventoryCounts

```ml
function copyInventoryCounts(counts)
```

Copy inventory counts.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `counts` | `dynamic` | — | counts value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/client.ml#L70)

<a id="function-function-miniquake2-game-player-client-copypmovestate-function-copypmovestate-state-src-miniquake2-game-player-client-ml-2133553720"></a>
### copyPmoveState

```ml
function copyPmoveState(state)
```

Copy pmove state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/client.ml#L26)

<a id="function-function-miniquake2-game-player-client-getchasetarget-function-getchasetarget-context-player-src-miniquake2-game-player-client-ml-813169915"></a>
### GetChaseTarget

```ml
function GetChaseTarget(context, player)
```

Acquire the first live non-spectator and initialize the camera immediately.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/client.ml#L449)

<a id="function-function-miniquake2-game-player-client-moveclienttointermission-function-moveclienttointermission-context-player-spot-src-miniquake2-game-player-client-ml-1108210515"></a>
### MoveClientToIntermission

```ml
function MoveClientToIntermission(context, player, spot)
```

p_hud.c::MoveClientToIntermission. The caller owns map-change timing and point selection; this routine only applies the stock client-visible state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `spot` | `dynamic` | — | spot value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/client.ml#L242)

<a id="function-function-miniquake2-game-player-client-pmovestateequal-function-pmovestateequal-first-second-src-miniquake2-game-player-client-ml-1803882095"></a>
### pmoveStateEqual

```ml
function pmoveStateEqual(first, second)
```

Report whether two pmove states are byte-contract equivalent.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `dynamic` | — | first value consumed by this operation. |
| `second` | `dynamic` | — | second value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/client.ml#L37)

<a id="function-function-miniquake2-game-player-client-putclientinserver-function-putclientinserver-context-player-src-miniquake2-game-player-client-ml-1241746815"></a>
### PutClientInServer

```ml
function PutClientInServer(context, player)
```

Write client in server.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/client.ml#L104)

<a id="function-function-miniquake2-game-player-client-respawn-function-respawn-context-player-src-miniquake2-game-player-client-ml-1113310891"></a>
### respawn

```ml
function respawn(context, player)
```

Return the respawn value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/client.ml#L222)

<a id="function-function-miniquake2-game-player-client-shorttoangle-function-shorttoangle-value-src-miniquake2-game-player-client-ml-1969539552"></a>
### shortToAngle

```ml
function shortToAngle(value)
```

Performs the shortToAngle operation for the miniquake2 game player client module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/client.ml#L62)

<a id="function-function-miniquake2-game-player-client-spectator-respawn-function-spectator-respawn-context-player-src-miniquake2-game-player-client-ml-1260885071"></a>
### spectator_respawn

```ml
function spectator_respawn(context, player)
```

Return the spectator respawn value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/client.ml#L278)

<a id="function-function-miniquake2-game-player-client-thinkweapon-function-thinkweapon-context-player-src-miniquake2-game-player-client-ml-1383480635"></a>
### ThinkWeapon

```ml
function ThinkWeapon(context, player)
```

Run weapon.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/client.ml#L83)

<a id="function-function-miniquake2-game-player-client-updatechasecam-function-updatechasecam-context-player-src-miniquake2-game-player-client-ml-731929347"></a>
### UpdateChaseCam

```ml
function UpdateChaseCam(context, player)
```

Update one spectator camera from its current target, matching g_chase.c.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/client.ml#L376)
