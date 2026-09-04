# `src/miniquake2/game/world/turret.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 game world turret facilities for this project.

Package: [`miniquake2.game.world.turret`](Package-miniquake2-game-world-turret-960676477.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/game/ai/constants.ml` as `turretaiconstants` → [src/miniquake2/game/ai/constants.ml](File-src-miniquake2-game-ai-constants-ml-2069864859.md)
- `miniquake2/game/constants.ml` as `turretgameconstants` → [src/miniquake2/game/constants.ml](File-src-miniquake2-game-constants-ml-1723282332.md)
- `miniquake2/game/world/constants.ml` as `turretworldconstants` → [src/miniquake2/game/world/constants.ml](File-src-miniquake2-game-world-constants-ml-774918061.md)
- `miniquake2/game/world/core.ml` as `turretcore` → [src/miniquake2/game/world/core.ml](File-src-miniquake2-game-world-core-ml-1171136969.md)
- `miniquake2/game/world/turret_types.ml` as `turrettypes` → [src/miniquake2/game/world/turret_types.ml](File-src-miniquake2-game-world-turret-types-ml-68266644.md)
- `miniquake2/game/world/vector.ml` as `turretvector` → [src/miniquake2/game/world/vector.ml](File-src-miniquake2-game-world-vector-ml-1561306429.md)
- `miniquake2/qcommon/byteio.ml` as `turretbyteio` → [src/miniquake2/qcommon/byteio.ml](File-src-miniquake2-qcommon-byteio-ml-159119335.md)
- `miniquake2/qcommon/constants.ml` as `turretqconstants` → [src/miniquake2/qcommon/constants.ml](File-src-miniquake2-qcommon-constants-ml-1976195726.md)
- `miniquake2/qcommon/types.ml` as `turretqtypes` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)
- `std/math.ml` as `turretmath` → `../MiniLangCompilerML/std/math.ml` — external dependency

## Declarations

<a id="function-function-miniquake2-game-world-turret-bindturretteam-function-bindturretteam-baseentity-breach-world-src-miniquake2-game-world-turret-ml-315564830"></a>
### bindTurretTeam

```ml
function bindTurretTeam(baseEntity, breach, world)
```

Bind turret team.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseEntity` | `dynamic` | — | baseEntity value consumed by this operation. |
| `breach` | `dynamic` | — | breach value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/turret.ml#L140)

<a id="function-function-miniquake2-game-world-turret-restoreturretstate-function-restoreturretstate-entity-world-src-miniquake2-game-world-turret-ml-1645236374"></a>
### restoreTurretState

```ml
function restoreTurretState(entity, world)
```

Function identities are not serialized. Rebind the stock phase only after private-save reference numbers have been resolved, so an already linked driver resumes turret_driver_think instead of appending itself a second time.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/turret.ml#L575)

<a id="function-function-miniquake2-game-world-turret-sp-turret-base-function-sp-turret-base-entity-world-control-src-miniquake2-game-world-turret-ml-1902486521"></a>
### SP_turret_base

```ml
function SP_turret_base(entity, world, control)
```

Spawn turret base.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |
| `control` | `dynamic` | — | control value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/turret.ml#L548)

<a id="function-function-miniquake2-game-world-turret-sp-turret-breach-function-sp-turret-breach-entity-world-control-limits-src-miniquake2-game-world-turret-ml-769881385"></a>
### SP_turret_breach

```ml
function SP_turret_breach(entity, world, control, limits)
```

Spawn turret breach.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |
| `control` | `dynamic` | — | control value consumed by this operation. |
| `limits` | `dynamic` | — | limits value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/turret.ml#L557)

<a id="function-function-miniquake2-game-world-turret-sp-turret-driver-function-sp-turret-driver-entity-world-control-deathmatch-src-miniquake2-game-world-turret-ml-422444244"></a>
### SP_turret_driver

```ml
function SP_turret_driver(entity, world, control, deathmatch)
```

Spawn turret driver.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |
| `control` | `dynamic` | — | control value consumed by this operation. |
| `deathmatch` | `dynamic` | — | deathmatch value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/turret.ml#L566)

<a id="function-function-miniquake2-game-world-turret-spawnturretbase-function-spawnturretbase-entity-world-control-src-miniquake2-game-world-turret-ml-378768425"></a>
### spawnTurretBase

```ml
function spawnTurretBase(entity, world, control)
```

Spawn turret base.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |
| `control` | `dynamic` | — | control value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/turret.ml#L349)

<a id="function-function-miniquake2-game-world-turret-spawnturretbreach-function-spawnturretbreach-entity-world-control-limits-src-miniquake2-game-world-turret-ml-797941505"></a>
### spawnTurretBreach

```ml
function spawnTurretBreach(entity, world, control, limits)
```

Spawn turret breach.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |
| `control` | `dynamic` | — | control value consumed by this operation. |
| `limits` | `dynamic` | — | limits value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/turret.ml#L320)

<a id="function-function-miniquake2-game-world-turret-spawnturretdriver-function-spawnturretdriver-entity-world-control-deathmatch-src-miniquake2-game-world-turret-ml-676627718"></a>
### spawnTurretDriver

```ml
function spawnTurretDriver(entity, world, control, deathmatch)
```

Spawn turret driver.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |
| `control` | `dynamic` | — | control value consumed by this operation. |
| `deathmatch` | `dynamic` | — | deathmatch value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/turret.ml#L512)

<a id="function-function-miniquake2-game-world-turret-trybindturretteam-function-trybindturretteam-entity-world-src-miniquake2-game-world-turret-ml-243923972"></a>
### tryBindTurretTeam

```ml
function tryBindTurretTeam(entity, world)
```

Bind try turret team.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/turret.ml#L152)

<a id="constant-constant-miniquake2-game-world-turret-turret-fire-request-const-turret-fire-request-65536-src-miniquake2-game-world-turret-ml-183379059"></a>
### TURRET_FIRE_REQUEST

```ml
const TURRET_FIRE_REQUEST = 65536
```

Defines the turret fire request constant used by the miniquake2 game world turret module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/turret.ml#L22)

<a id="constant-constant-miniquake2-game-world-turret-turret-no-knockback-const-turret-no-knockback-2048-src-miniquake2-game-world-turret-ml-743321538"></a>
### TURRET_NO_KNOCKBACK

```ml
const TURRET_NO_KNOCKBACK = 2048
```

Defines the turret no knockback constant used by the miniquake2 game world turret module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/turret.ml#L24)

<a id="function-function-miniquake2-game-world-turret-turretanglevectors-function-turretanglevectors-angles-src-miniquake2-game-world-turret-ml-964262387"></a>
### turretAngleVectors

```ml
function turretAngleVectors(angles)
```

Return the turret angle vectors value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `angles` | `dynamic` | — | angles value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/turret.ml#L87)

<a id="function-function-miniquake2-game-world-turret-turretappendteammember-function-turretappendteammember-master-member-world-src-miniquake2-game-world-turret-ml-948260157"></a>
### turretAppendTeamMember

```ml
function turretAppendTeamMember(master, member, world)
```

Append turret team member.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `master` | `dynamic` | — | master value consumed by this operation. |
| `member` | `dynamic` | — | member value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/turret.ml#L114)

<a id="function-function-miniquake2-game-world-turret-turretattachcontrol-function-turretattachcontrol-entity-control-src-miniquake2-game-world-turret-ml-1194729497"></a>
### turretAttachControl

```ml
function turretAttachControl(entity, control)
```

Attach turret control.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `control` | `dynamic` | — | control value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/turret.ml#L38)

<a id="function-function-miniquake2-game-world-turret-turretblocked-function-turretblocked-entity-other-world-src-miniquake2-game-world-turret-ml-2012475532"></a>
### turretBlocked

```ml
function turretBlocked(entity, other, world)
```

Report whether turret blocked.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/turret.ml#L171)

<a id="function-function-miniquake2-game-world-turret-turretbreachfinishinit-function-turretbreachfinishinit-entity-world-src-miniquake2-game-world-turret-ml-1993556446"></a>
### turretBreachFinishInit

```ml
function turretBreachFinishInit(entity, world)
```

Finish turret breach init.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/turret.ml#L292)

<a id="function-function-miniquake2-game-world-turret-turretbreachfire-function-turretbreachfire-entity-world-src-miniquake2-game-world-turret-ml-1026700102"></a>
### turretBreachFire

```ml
function turretBreachFire(entity, world)
```

Fire turret breach.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/turret.ml#L187)

<a id="function-function-miniquake2-game-world-turret-turretbreachthink-function-turretbreachthink-entity-world-src-miniquake2-game-world-turret-ml-1747940056"></a>
### turretBreachThink

```ml
function turretBreachThink(entity, world)
```

Run turret breach.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/turret.ml#L241)

<a id="function-function-miniquake2-game-world-turret-turretclampdesiredangles-function-turretclampdesiredangles-entity-src-miniquake2-game-world-turret-ml-144336358"></a>
### turretClampDesiredAngles

```ml
function turretClampDesiredAngles(entity)
```

Clamp turret desired angles.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/turret.ml#L213)

<a id="function-function-miniquake2-game-world-turret-turretcontrol-function-turretcontrol-entity-src-miniquake2-game-world-turret-ml-2020974792"></a>
### turretControl

```ml
function turretControl(entity)
```

Return the turret control value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/turret.ml#L28)

<a id="function-function-miniquake2-game-world-turret-turretcurrentskill-inline-function-turretcurrentskill-control-src-miniquake2-game-world-turret-ml-1544148755"></a>
### turretCurrentSkill

```ml
inline function turretCurrentSkill(control)
```

Return the turret current skill value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `control` | `dynamic` | — | control value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/turret.ml#L49)

<a id="function-function-miniquake2-game-world-turret-turretdriverdie-function-turretdriverdie-entity-inflictor-attacker-damage-point-world-src-miniquake2-game-world-turret-ml-865827532"></a>
### turretDriverDie

```ml
function turretDriverDie(entity, inflictor, attacker, damage, point, world)
```

Handle turret driver.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `inflictor` | `dynamic` | — | inflictor value consumed by this operation. |
| `attacker` | `dynamic` | — | attacker value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `point` | `dynamic` | — | point value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/turret.ml#L390)

<a id="function-function-miniquake2-game-world-turret-turretdriverlink-function-turretdriverlink-entity-world-src-miniquake2-game-world-turret-ml-864364886"></a>
### turretDriverLink

```ml
function turretDriverLink(entity, world)
```

Link turret driver.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/turret.ml#L476)

<a id="function-function-miniquake2-game-world-turret-turretdriverthink-function-turretdriverthink-entity-world-src-miniquake2-game-world-turret-ml-392903158"></a>
### turretDriverThink

```ml
function turretDriverThink(entity, world)
```

Run turret driver.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/turret.ml#L423)

<a id="function-function-miniquake2-game-world-turret-turretdriveruse-function-turretdriveruse-entity-other-activator-world-src-miniquake2-game-world-turret-ml-72487233"></a>
### turretDriverUse

```ml
function turretDriverUse(entity, other, activator, world)
```

Use turret driver.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/turret.ml#L371)

<a id="function-function-miniquake2-game-world-turret-turretnormalizeangle-function-turretnormalizeangle-value-src-miniquake2-game-world-turret-ml-656044322"></a>
### turretNormalizeAngle

```ml
function turretNormalizeAngle(value)
```

Normalize turret angle.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/turret.ml#L59)

<a id="function-function-miniquake2-game-world-turret-turretshortestdelta-function-turretshortestdelta-value-src-miniquake2-game-world-turret-ml-1770816198"></a>
### turretShortestDelta

```ml
function turretShortestDelta(value)
```

Return the turret shortest delta value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/turret.ml#L71)

<a id="function-function-miniquake2-game-world-turret-turretsnaptoeighth-function-turretsnaptoeighth-value-src-miniquake2-game-world-turret-ml-2073096078"></a>
### turretSnapToEighth

```ml
function turretSnapToEighth(value)
```

Return the turret snap to eighth value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/turret.ml#L79)
