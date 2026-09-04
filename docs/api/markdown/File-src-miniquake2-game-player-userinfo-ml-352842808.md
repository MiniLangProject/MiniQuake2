# `src/miniquake2/game/player/userinfo.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 game player userinfo facilities for this project.

Package: [`miniquake2.game.player.userinfo`](Package-miniquake2-game-player-userinfo-1311789657.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/game/gameplay/item_rules.ml` as `gprules` → [src/miniquake2/game/gameplay/item_rules.ml](File-src-miniquake2-game-gameplay-item-rules-ml-1747940557.md)
- `miniquake2/game/player/effects.ml` as `gplayerinfoeffects` → [src/miniquake2/game/player/effects.ml](File-src-miniquake2-game-player-effects-ml-25549151.md)
- `miniquake2/game/player/types.ml` as `gplayertypes` → [src/miniquake2/game/player/types.ml](File-src-miniquake2-game-player-types-ml-1013655302.md)
- `miniquake2/qcommon/byteio.ml` as `qbyteio` → [src/miniquake2/qcommon/byteio.ml](File-src-miniquake2-qcommon-byteio-ml-159119335.md)
- `miniquake2/qcommon/constants.ml` as `qconstants` → [src/miniquake2/qcommon/constants.ml](File-src-miniquake2-qcommon-constants-ml-1976195726.md)
- `miniquake2/qcommon/info.ml` as `qinfo` → [src/miniquake2/qcommon/info.ml](File-src-miniquake2-qcommon-info-ml-634538165.md)

## Declarations

<a id="function-function-miniquake2-game-player-userinfo-clientconnect-function-clientconnect-context-player-userinfo-src-miniquake2-game-player-userinfo-ml-1070883538"></a>
### ClientConnect

```ml
function ClientConnect(context, player, userInfo)
```

Performs the ClientConnect operation for the miniquake2 game player userinfo module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `userInfo` | `dynamic` | — | userInfo value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/userinfo.ml#L105)

<a id="function-function-miniquake2-game-player-userinfo-clientdisconnect-function-clientdisconnect-context-player-src-miniquake2-game-player-userinfo-ml-2082651635"></a>
### ClientDisconnect

```ml
function ClientDisconnect(context, player)
```

Return the client disconnect value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/userinfo.ml#L133)

<a id="function-function-miniquake2-game-player-userinfo-clientuserinfochanged-function-clientuserinfochanged-context-player-userinfo-src-miniquake2-game-player-userinfo-ml-1343516276"></a>
### ClientUserinfoChanged

```ml
function ClientUserinfoChanged(context, player, userInfo)
```

Return the client userinfo changed value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `userInfo` | `dynamic` | — | userInfo value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/userinfo.ml#L59)

<a id="function-function-miniquake2-game-player-userinfo-initclientpersistent-function-initclientpersistent-player-context-src-miniquake2-game-player-userinfo-ml-2128404413"></a>
### InitClientPersistent

```ml
function InitClientPersistent(player, context)
```

Initialize client persistent.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/userinfo.ml#L37)

<a id="function-function-miniquake2-game-player-userinfo-numeric-function-numeric-text-fallback-src-miniquake2-game-player-userinfo-ml-1582721444"></a>
### numeric

```ml
function numeric(text, fallback)
```

Performs the numeric operation for the miniquake2 game player userinfo module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `text` | `dynamic` | — | Text consumed by the operation. |
| `fallback` | `dynamic` | — | Value returned when no explicit result is available. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/userinfo.ml#L20)

<a id="function-function-miniquake2-game-player-userinfo-passwordmatches-function-passwordmatches-required-supplied-src-miniquake2-game-player-userinfo-ml-1459218008"></a>
### passwordMatches

```ml
function passwordMatches(required, supplied)
```

Return the password matches value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `required` | `dynamic` | — | required value consumed by this operation. |
| `supplied` | `dynamic` | — | supplied value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/userinfo.ml#L29)

<a id="function-function-miniquake2-game-player-userinfo-reject-function-reject-userinfo-message-src-miniquake2-game-player-userinfo-ml-1217026127"></a>
### reject

```ml
function reject(userInfo, message)
```

Reject state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `userInfo` | `dynamic` | — | userInfo value consumed by this operation. |
| `message` | `dynamic` | — | Human-readable message associated with the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/userinfo.ml#L95)

<a id="function-function-miniquake2-game-player-userinfo-spectatorcount-function-spectatorcount-context-ignoredplayer-src-miniquake2-game-player-userinfo-ml-1042219665"></a>
### spectatorCount

```ml
function spectatorCount(context, ignoredPlayer)
```

Return the spectator count.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `ignoredPlayer` | `dynamic` | — | ignoredPlayer value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/userinfo.ml#L84)
