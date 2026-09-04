# `src/miniquake2/game/integration/pusher.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 game integration pusher facilities for this project.

Package: [`miniquake2.game.integration.pusher`](Package-miniquake2-game-integration-pusher-1550671590.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/game/weapons/vector.ml` as `pushvector` → [src/miniquake2/game/weapons/vector.ml](File-src-miniquake2-game-weapons-vector-ml-1084549988.md)
- `miniquake2/game/world/constants.ml` as `pushworldconstants` → [src/miniquake2/game/world/constants.ml](File-src-miniquake2-game-world-constants-ml-774918061.md)
- `miniquake2/game/world/core.ml` as `pushworldcore` → [src/miniquake2/game/world/core.ml](File-src-miniquake2-game-world-core-ml-1171136969.md)
- `miniquake2/game/world/types.ml` as `pushworldtypes` → [src/miniquake2/game/world/types.ml](File-src-miniquake2-game-world-types-ml-1207695045.md)
- `miniquake2/qcommon/byteio.ml` as `pushqbyteio` → [src/miniquake2/qcommon/byteio.ml](File-src-miniquake2-qcommon-byteio-ml-159119335.md)
- `miniquake2/qcommon/constants.ml` as `pushqconstants` → [src/miniquake2/qcommon/constants.ml](File-src-miniquake2-qcommon-constants-ml-1976195726.md)
- `miniquake2/qcommon/types.ml` as `pushqtypes` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)

## Declarations

<a id="function-function-miniquake2-game-integration-pusher-addplayerdeltayaw-function-addplayerdeltayaw-body-amount-src-miniquake2-game-integration-pusher-ml-701759357"></a>
### addPlayerDeltaYaw

```ml
function addPlayerDeltaYaw(body, amount)
```

Add player delta yaw.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `body` | `dynamic` | — | body value consumed by this operation. |
| `amount` | `dynamic` | — | amount value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/pusher.ml#L621)

<a id="function-function-miniquake2-game-integration-pusher-advanceteam-function-advanceteam-capturestate-masternumber-duration-src-miniquake2-game-integration-pusher-ml-1471129801"></a>
### advanceTeam

```ml
function advanceTeam(captureState, masterNumber, duration)
```

Integrate one pusher team for the frame before its atomic SV_Push pass.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `captureState` | `dynamic` | — | captureState value consumed by this operation. |
| `masterNumber` | `dynamic` | — | masterNumber value consumed by this operation. |
| `duration` | `dynamic` | — | duration value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/pusher.ml#L962)

<a id="function-function-miniquake2-game-integration-pusher-assembleteams-function-assembleteams-world-src-miniquake2-game-integration-pusher-ml-1034769799"></a>
### assembleTeams

```ml
function assembleTeams(world)
```

Assemble teams.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/pusher.ml#L115)

<a id="function-function-miniquake2-game-integration-pusher-bodyboundsat-function-bodyboundsat-body-origin-angles-src-miniquake2-game-integration-pusher-ml-1464334729"></a>
### bodyBoundsAt

```ml
function bodyBoundsAt(body, origin, angles)
```

Return the body bounds for the requested position.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `body` | `dynamic` | — | body value consumed by this operation. |
| `origin` | `dynamic` | — | origin value consumed by this operation. |
| `angles` | `dynamic` | — | angles value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/pusher.ml#L509)

<a id="function-function-miniquake2-game-integration-pusher-bodycanbepushed-function-bodycanbepushed-body-src-miniquake2-game-integration-pusher-ml-699392159"></a>
### bodyCanBePushed

```ml
function bodyCanBePushed(body)
```

Report whether body can be pushed.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `body` | `dynamic` | — | body value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/pusher.ml#L522)

<a id="function-function-miniquake2-game-integration-pusher-bodygroundnumber-function-bodygroundnumber-groundentity-src-miniquake2-game-integration-pusher-ml-1523577491"></a>
### bodyGroundNumber

```ml
function bodyGroundNumber(groundEntity)
```

Return the body ground number.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `groundEntity` | `dynamic` | — | groundEntity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/pusher.ml#L143)

<a id="function-function-miniquake2-game-integration-pusher-bodyintersectsfinalpusher-function-bodyintersectsfinalpusher-runtime-body-src-miniquake2-game-integration-pusher-ml-644279617"></a>
### bodyIntersectsFinalPusher

```ml
function bodyIntersectsFinalPusher(runtime, body)
```

Return the body intersects final pusher value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `body` | `dynamic` | — | body value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/pusher.ml#L603)

<a id="function-function-miniquake2-game-integration-pusher-bodymoved-function-bodymoved-body-src-miniquake2-game-integration-pusher-ml-2123039989"></a>
### bodyMoved

```ml
function bodyMoved(body)
```

Report whether body moved.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `body` | `dynamic` | — | body value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/pusher.ml#L552)

<a id="function-function-miniquake2-game-integration-pusher-bodypassentity-function-bodypassentity-runtime-body-src-miniquake2-game-integration-pusher-ml-822992795"></a>
### bodyPassEntity

```ml
function bodyPassEntity(runtime, body)
```

Return the body pass entity value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `body` | `dynamic` | — | body value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/pusher.ml#L578)

<a id="function-function-miniquake2-game-integration-pusher-bodypositionblocked-function-bodypositionblocked-runtime-body-position-src-miniquake2-game-integration-pusher-ml-375488436"></a>
### bodyPositionBlocked

```ml
function bodyPositionBlocked(runtime, body, position)
```

Report whether body position blocked.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `body` | `dynamic` | — | body value consumed by this operation. |
| `position` | `dynamic` | — | position value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/pusher.ml#L589)

- [miniquake2.game.integration.pusher.BodySnapshot](Type-miniquake2-game-integration-pusher-bodysnapshot-121863056.md) — struct
<a id="function-function-miniquake2-game-integration-pusher-bodysnapshotinto-function-bodysnapshotinto-snapshot-kind-value-edict-number-origin-angles-mins-maxs-solid-groundnumber-clipmask-deltayaw-src-miniquake2-game-integration-pusher-ml-1844937538"></a>
### bodySnapshotInto

```ml
function bodySnapshotInto(snapshot, kind, value, edict, number, origin, angles, mins, maxs, solid, groundNumber, clipMask, deltaYaw)
```

Populate the body snapshot destination.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `snapshot` | `dynamic` | — | snapshot value consumed by this operation. |
| `kind` | `dynamic` | — | kind value consumed by this operation. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `edict` | `dynamic` | — | edict value consumed by this operation. |
| `number` | `dynamic` | — | number value consumed by this operation. |
| `origin` | `dynamic` | — | origin value consumed by this operation. |
| `angles` | `dynamic` | — | angles value consumed by this operation. |
| `mins` | `dynamic` | — | mins value consumed by this operation. |
| `maxs` | `dynamic` | — | maxs value consumed by this operation. |
| `solid` | `dynamic` | — | Identifier of sol. |
| `groundNumber` | `dynamic` | — | groundNumber value consumed by this operation. |
| `clipMask` | `dynamic` | — | clipMask value consumed by this operation. |
| `deltaYaw` | `dynamic` | — | deltaYaw value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/pusher.ml#L175)

<a id="function-function-miniquake2-game-integration-pusher-capture-function-capture-runtime-src-miniquake2-game-integration-pusher-ml-1285063611"></a>
### capture

```ml
function capture(runtime)
```

Capture state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/pusher.ml#L292)

<a id="function-function-miniquake2-game-integration-pusher-carryorigin-function-carryorigin-body-pushersnapshot-src-miniquake2-game-integration-pusher-ml-446940532"></a>
### carryOrigin

```ml
function carryOrigin(body, pusherSnapshot)
```

Return the carry origin.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `body` | `dynamic` | — | body value consumed by this operation. |
| `pusherSnapshot` | `dynamic` | — | pusherSnapshot value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/pusher.ml#L655)

<a id="function-function-miniquake2-game-integration-pusher-cleargroundunlessriding-function-cleargroundunlessriding-body-pushersnapshot-src-miniquake2-game-integration-pusher-ml-1839498252"></a>
### clearGroundUnlessRiding

```ml
function clearGroundUnlessRiding(body, pusherSnapshot)
```

Clear ground unless riding.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `body` | `dynamic` | — | body value consumed by this operation. |
| `pusherSnapshot` | `dynamic` | — | pusherSnapshot value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/pusher.ml#L642)

<a id="function-function-miniquake2-game-integration-pusher-currentangles-function-currentangles-body-src-miniquake2-game-integration-pusher-ml-152502773"></a>
### currentAngles

```ml
function currentAngles(body)
```

Return the current angles.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `body` | `dynamic` | — | body value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/pusher.ml#L498)

<a id="function-function-miniquake2-game-integration-pusher-currentorigin-function-currentorigin-body-src-miniquake2-game-integration-pusher-ml-781118673"></a>
### currentOrigin

```ml
function currentOrigin(body)
```

Return the current origin.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `body` | `dynamic` | — | body value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/pusher.ml#L489)

<a id="function-function-miniquake2-game-integration-pusher-deferduethinks-function-deferduethinks-capturestate-targettime-src-miniquake2-game-integration-pusher-ml-497289138"></a>
### deferDueThinks

```ml
function deferDueThinks(captureState, targetTime)
```

Defer due mover thinks until the enclosing SV_Push transaction succeeds.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `captureState` | `dynamic` | — | captureState value consumed by this operation. |
| `targetTime` | `dynamic` | — | targetTime value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/pusher.ml#L398)

<a id="function-function-miniquake2-game-integration-pusher-finishteamthinks-function-finishteamthinks-runtime-team-blocked-src-miniquake2-game-integration-pusher-ml-597229038"></a>
### finishTeamThinks

```ml
function finishTeamThinks(runtime, team, blocked)
```

Finish a pusher team's deferred thinks with g_phys.c ordering.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `team` | `dynamic` | — | team value consumed by this operation. |
| `blocked` | `dynamic` | — | blocked value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/pusher.ml#L774)

<a id="function-function-miniquake2-game-integration-pusher-ispusher-function-ispusher-entity-src-miniquake2-game-integration-pusher-ml-1286023806"></a>
### isPusher

```ml
function isPusher(entity)
```

Report whether is pusher.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/pusher.ml#L92)

<a id="function-function-miniquake2-game-integration-pusher-itembodyinto-function-itembodyinto-snapshot-item-src-miniquake2-game-integration-pusher-ml-1380269742"></a>
### itemBodyInto

```ml
function itemBodyInto(snapshot, item)
```

Populate a dropped/static MOVETYPE_TOSS item body destination.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `snapshot` | `dynamic` | — | snapshot value consumed by this operation. |
| `item` | `dynamic` | — | item value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/pusher.ml#L253)

<a id="function-function-miniquake2-game-integration-pusher-linkbody-function-linkbody-runtime-body-src-miniquake2-game-integration-pusher-ml-1409178455"></a>
### linkBody

```ml
function linkBody(runtime, body)
```

Link body.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `body` | `dynamic` | — | body value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/pusher.ml#L563)

<a id="function-function-miniquake2-game-integration-pusher-monsterbodyinto-function-monsterbodyinto-snapshot-actor-src-miniquake2-game-integration-pusher-ml-1884522164"></a>
### monsterBodyInto

```ml
function monsterBodyInto(snapshot, actor)
```

Populate the monster body destination.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `snapshot` | `dynamic` | — | snapshot value consumed by this operation. |
| `actor` | `dynamic` | — | actor value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/pusher.ml#L225)

<a id="function-function-miniquake2-game-integration-pusher-moved-function-moved-snapshot-src-miniquake2-game-integration-pusher-ml-782221817"></a>
### moved

```ml
function moved(snapshot)
```

Report whether moved.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `snapshot` | `dynamic` | — | snapshot value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/pusher.ml#L418)

<a id="function-function-miniquake2-game-integration-pusher-playerbodyinto-function-playerbodyinto-snapshot-player-src-miniquake2-game-integration-pusher-ml-1398395948"></a>
### playerBodyInto

```ml
function playerBodyInto(snapshot, player)
```

Populate the player body destination.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `snapshot` | `dynamic` | — | snapshot value consumed by this operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/pusher.ml#L203)

<a id="function-function-miniquake2-game-integration-pusher-playerdeltayaw-function-playerdeltayaw-edict-src-miniquake2-game-integration-pusher-ml-1742173146"></a>
### playerDeltaYaw

```ml
function playerDeltaYaw(edict)
```

Return the player delta yaw.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `edict` | `dynamic` | — | edict value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/pusher.ml#L154)

<a id="function-function-miniquake2-game-integration-pusher-projectilebodyinto-function-projectilebodyinto-snapshot-runtime-projectile-src-miniquake2-game-integration-pusher-ml-862074318"></a>
### projectileBodyInto

```ml
function projectileBodyInto(snapshot, runtime, projectile)
```

Populate a MOVETYPE_FLYMISSILE/BOUNCE projectile body destination.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `snapshot` | `dynamic` | — | snapshot value consumed by this operation. |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `projectile` | `dynamic` | — | projectile value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/pusher.ml#L238)

<a id="function-function-miniquake2-game-integration-pusher-proxyfor-function-proxyfor-body-src-miniquake2-game-integration-pusher-ml-1501814259"></a>
### proxyFor

```ml
function proxyFor(body)
```

Return the proxy for the requested input.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `body` | `dynamic` | — | body value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/pusher.ml#L716)

<a id="function-function-miniquake2-game-integration-pusher-publishpushermove-function-publishpushermove-runtime-snapshot-src-miniquake2-game-integration-pusher-ml-2049529261"></a>
### publishPusherMove

```ml
function publishPusherMove(runtime, snapshot)
```

Publish pusher move.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `snapshot` | `dynamic` | — | snapshot value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/pusher.ml#L435)

<a id="function-function-miniquake2-game-integration-pusher-pushbody-function-pushbody-runtime-body-pushersnapshot-src-miniquake2-game-integration-pusher-ml-1513552134"></a>
### pushBody

```ml
function pushBody(runtime, body, pusherSnapshot)
```

BaseQ2 SV_Push first moves a contacted bbox with a MOVETYPE_PUSH brush and reports a block only when the carried position is obstructed. Treating the first overlap as a block leaves the player embedded at the reversal point; the door then toggles direction and applies crush damage every server frame.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `body` | `dynamic` | — | body value consumed by this operation. |
| `pusherSnapshot` | `dynamic` | — | pusherSnapshot value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/pusher.ml#L685)

<a id="function-function-miniquake2-game-integration-pusher-pushcopy-function-pushcopy-value-src-miniquake2-game-integration-pusher-ml-1746629108"></a>
### pushCopy

```ml
function pushCopy(value)
```

Copy push data.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/pusher.ml#L74)

<a id="function-function-miniquake2-game-integration-pusher-pushcopyinto-inline-function-pushcopyinto-output-value-src-miniquake2-game-integration-pusher-ml-2053295780"></a>
### pushCopyInto

```ml
inline function pushCopyInto(output, value)
```

Populate the push copy destination.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `output` | `dynamic` | — | Output collection or buffer populated by the operation. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/pusher.ml#L82)

<a id="function-function-miniquake2-game-integration-pusher-pushercancontactbodies-function-pushercancontactbodies-entity-src-miniquake2-game-integration-pusher-ml-1996234742"></a>
### pusherCanContactBodies

```ml
function pusherCanContactBodies(entity)
```

Report whether this mover has a linked brush volume that can contact bodies.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/pusher.ml#L100)

- [miniquake2.game.integration.pusher.PusherCapture](Type-miniquake2-game-integration-pusher-pushercapture-1613843491.md) — struct
<a id="function-function-miniquake2-game-integration-pusher-pushermasternumber-function-pushermasternumber-entity-src-miniquake2-game-integration-pusher-ml-673008174"></a>
### pusherMasterNumber

```ml
function pusherMasterNumber(entity)
```

Return the pusher master number.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/pusher.ml#L108)

- [miniquake2.game.integration.pusher.PusherSnapshot](Type-miniquake2-game-integration-pusher-pushersnapshot-1388948491.md) — struct
<a id="function-function-miniquake2-game-integration-pusher-pushersnapshotinto-function-pushersnapshotinto-snapshot-entity-src-miniquake2-game-integration-pusher-ml-1713572074"></a>
### pusherSnapshotInto

```ml
function pusherSnapshotInto(snapshot, entity)
```

Populate the pusher snapshot destination.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `snapshot` | `dynamic` | — | snapshot value consumed by this operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/pusher.ml#L265)

<a id="function-function-miniquake2-game-integration-pusher-resolve-function-resolve-runtime-capturestate-src-miniquake2-game-integration-pusher-ml-1933929206"></a>
### resolve

```ml
function resolve(runtime, captureState)
```

Resolve state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `captureState` | `dynamic` | — | captureState value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/pusher.ml#L982)

<a id="function-function-miniquake2-game-integration-pusher-resolveteam-function-resolveteam-runtime-capturestate-masternumber-src-miniquake2-game-integration-pusher-ml-1475593057"></a>
### resolveTeam

```ml
function resolveTeam(runtime, captureState, masterNumber)
```

Resolve team.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `captureState` | `dynamic` | — | captureState value consumed by this operation. |
| `masterNumber` | `dynamic` | — | masterNumber value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/pusher.ml#L852)

<a id="function-function-miniquake2-game-integration-pusher-restoreplayerdeltayaw-function-restoreplayerdeltayaw-body-src-miniquake2-game-integration-pusher-ml-593993295"></a>
### restorePlayerDeltaYaw

```ml
function restorePlayerDeltaYaw(body)
```

Restore player delta yaw.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `body` | `dynamic` | — | body value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/pusher.ml#L631)

<a id="function-function-miniquake2-game-integration-pusher-rotatedbounds-function-rotatedbounds-origin-angles-mins-maxs-src-miniquake2-game-integration-pusher-ml-1914723855"></a>
### rotatedBounds

```ml
function rotatedBounds(origin, angles, mins, maxs)
```

Return the rotated bounds.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `origin` | `dynamic` | — | origin value consumed by this operation. |
| `angles` | `dynamic` | — | angles value consumed by this operation. |
| `mins` | `dynamic` | — | mins value consumed by this operation. |
| `maxs` | `dynamic` | — | maxs value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/pusher.ml#L452)

<a id="function-function-miniquake2-game-integration-pusher-setbody-function-setbody-body-origin-angles-src-miniquake2-game-integration-pusher-ml-1729935329"></a>
### setBody

```ml
function setBody(body, origin, angles)
```

Set body.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `body` | `dynamic` | — | body value consumed by this operation. |
| `origin` | `dynamic` | — | origin value consumed by this operation. |
| `angles` | `dynamic` | — | angles value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/pusher.ml#L540)

<a id="function-function-miniquake2-game-integration-pusher-snappedpushermove-inline-function-snappedpushermove-value-src-miniquake2-game-integration-pusher-ml-1419265885"></a>
### snappedPusherMove

```ml
inline function snappedPusherMove(value)
```

Move snapped pusher.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/pusher.ml#L426)

<a id="function-function-miniquake2-game-integration-pusher-standingon-function-standingon-body-pushersnapshot-src-miniquake2-game-integration-pusher-ml-1193499810"></a>
### standingOn

```ml
function standingOn(body, pusherSnapshot)
```

Report whether standing on.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `body` | `dynamic` | — | body value consumed by this operation. |
| `pusherSnapshot` | `dynamic` | — | pusherSnapshot value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/pusher.ml#L532)

<a id="function-function-miniquake2-game-integration-pusher-strictoverlap-function-strictoverlap-first-second-src-miniquake2-game-integration-pusher-ml-1639467413"></a>
### strictOverlap

```ml
function strictOverlap(first, second)
```

Return the strict overlap value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `dynamic` | — | first value consumed by this operation. |
| `second` | `dynamic` | — | second value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/pusher.ml#L516)

<a id="function-function-miniquake2-game-integration-pusher-teamhas-function-teamhas-team-number-src-miniquake2-game-integration-pusher-ml-477437053"></a>
### teamHas

```ml
function teamHas(team, number)
```

Report whether team has.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `team` | `dynamic` | — | team value consumed by this operation. |
| `number` | `dynamic` | — | number value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/pusher.ml#L707)

<a id="function-function-miniquake2-game-integration-pusher-touchcommittedbodies-function-touchcommittedbodies-runtime-bodies-movedbodies-src-miniquake2-game-integration-pusher-ml-1309921970"></a>
### touchCommittedBodies

```ml
function touchCommittedBodies(runtime, bodies, movedBodies)
```

Run trigger passes only after the complete pusher team commits. g_phys.c defers G_TouchTriggers until SV_Push succeeds, so a rolled-back rider must never activate a trigger at its temporary carried position.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `bodies` | `dynamic` | — | bodies value consumed by this operation. |
| `movedBodies` | `dynamic` | — | movedBodies value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/pusher.ml#L802)

<a id="function-function-miniquake2-game-integration-pusher-touchpushedentries-function-touchpushedentries-runtime-entries-src-miniquake2-game-integration-pusher-ml-1498630919"></a>
### touchPushedEntries

```ml
function touchPushedEntries(runtime, entries)
```

Dispatch one stock SV_Push trigger pass. The shared pushed stack is walked in reverse after every successful team part; later team failure rolls back transforms but deliberately cannot roll back trigger side effects.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `entries` | `dynamic` | — | entries value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/pusher.ml#L828)

<a id="function-function-miniquake2-game-integration-pusher-translatedfallback-function-translatedfallback-destination-pushersnapshot-src-miniquake2-game-integration-pusher-ml-1083109402"></a>
### translatedFallback

```ml
function translatedFallback(destination, pusherSnapshot)
```

Return the translated fallback value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `destination` | `dynamic` | — | destination value consumed by this operation. |
| `pusherSnapshot` | `dynamic` | — | pusherSnapshot value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/pusher.ml#L611)

<a id="function-function-miniquake2-game-integration-pusher-worldbodycanbepushed-function-worldbodycanbepushed-entity-src-miniquake2-game-integration-pusher-ml-1036547518"></a>
### worldBodyCanBePushed

```ml
function worldBodyCanBePushed(entity)
```

g_phys.c excludes MOVETYPE_NONE/PUSH/STOP/NOCLIP entities before testing a pusher overlap. Managed world bodies that can actually be displaced use one of these three locomotion modes; static bbox/BSP helpers must never jam a door merely because their authored bounds intersect its swept volume.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/pusher.ml#L284)

<a id="function-function-miniquake2-game-integration-pusher-worldbodyinto-function-worldbodyinto-snapshot-entity-src-miniquake2-game-integration-pusher-ml-2028389038"></a>
### worldBodyInto

```ml
function worldBodyInto(snapshot, entity)
```

Populate the world body destination.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `snapshot` | `dynamic` | — | snapshot value consumed by this operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/pusher.ml#L194)
