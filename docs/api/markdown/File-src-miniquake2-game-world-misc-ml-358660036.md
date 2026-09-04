# `src/miniquake2/game/world/misc.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 game world misc facilities for this project.

Package: [`miniquake2.game.world.misc`](Package-miniquake2-game-world-misc-1439372055.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/game/constants.ml` as `wmgameconstants` → [src/miniquake2/game/constants.ml](File-src-miniquake2-game-constants-ml-1723282332.md)
- `miniquake2/game/world/constants.ml` as `wmconstants` → [src/miniquake2/game/world/constants.ml](File-src-miniquake2-game-world-constants-ml-774918061.md)
- `miniquake2/game/world/core.ml` as `wmcore` → [src/miniquake2/game/world/core.ml](File-src-miniquake2-game-world-core-ml-1171136969.md)
- `miniquake2/game/world/movers.ml` as `wmmovers` → [src/miniquake2/game/world/movers.ml](File-src-miniquake2-game-world-movers-ml-1599163262.md)
- `miniquake2/game/world/vector.ml` as `wmvector` → [src/miniquake2/game/world/vector.ml](File-src-miniquake2-game-world-vector-ml-1561306429.md)
- `miniquake2/qcommon/byteio.ml` as `worldclockbyteio` → [src/miniquake2/qcommon/byteio.ml](File-src-miniquake2-qcommon-byteio-ml-159119335.md)
- `miniquake2/qcommon/constants.ml` as `wmqconstants` → [src/miniquake2/qcommon/constants.ml](File-src-miniquake2-qcommon-constants-ml-1976195726.md)
- `miniquake2/qcommon/types.ml` as `wmqtypes` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)

## Declarations

<a id="function-function-miniquake2-game-world-misc-areaportaluse-function-areaportaluse-entity-other-activator-world-src-miniquake2-game-world-misc-ml-1567475995"></a>
### areaPortalUse

```ml
function areaPortalUse(entity, other, activator, world)
```

func_areaportal from g_misc.c. Doors also drive linked areaportals through mover code, but a directly targeted portal must own the stock toggle use.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L26)

<a id="function-function-miniquake2-game-world-misc-bannerthink-function-bannerthink-entity-world-src-miniquake2-game-world-misc-ml-1534947406"></a>
### bannerThink

```ml
function bannerThink(entity, world)
```

Run banner.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L489)

<a id="function-function-miniquake2-game-world-misc-barreldelay-function-barreldelay-entity-inflictor-attacker-damage-point-world-src-miniquake2-game-world-misc-ml-741502218"></a>
### barrelDelay

```ml
function barrelDelay(entity, inflictor, attacker, damage, point, world)
```

Return the barrel delay value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `inflictor` | `dynamic` | — | inflictor value consumed by this operation. |
| `attacker` | `dynamic` | — | attacker value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `point` | `dynamic` | — | point value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L442)

<a id="function-function-miniquake2-game-world-misc-barreldroptofloor-function-barreldroptofloor-entity-world-src-miniquake2-game-world-misc-ml-599951366"></a>
### barrelDropToFloor

```ml
function barrelDropToFloor(entity, world)
```

Drop barrel to floor.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L382)

<a id="function-function-miniquake2-game-world-misc-barrelexplode-function-barrelexplode-entity-world-src-miniquake2-game-world-misc-ml-1231458156"></a>
### barrelExplode

```ml
function barrelExplode(entity, world)
```

Return the barrel explode value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L390)

<a id="function-function-miniquake2-game-world-misc-barreltouch-function-barreltouch-entity-other-world-src-miniquake2-game-world-misc-ml-987029190"></a>
### barrelTouch

```ml
function barrelTouch(entity, other, world)
```

Handle barrel.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L454)

<a id="function-function-miniquake2-game-world-misc-blackholethink-function-blackholethink-entity-world-src-miniquake2-game-world-misc-ml-502694618"></a>
### blackHoleThink

```ml
function blackHoleThink(entity, world)
```

Run black hole.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L763)

<a id="function-function-miniquake2-game-world-misc-blackholeuse-function-blackholeuse-entity-other-activator-world-src-miniquake2-game-world-misc-ml-881377811"></a>
### blackHoleUse

```ml
function blackHoleUse(entity, other, activator, world)
```

Remaining stock g_misc.c set pieces. Model registration is injected through setModel; animation and movement remain world-owned deterministic state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L756)

<a id="function-function-miniquake2-game-world-misc-deadsoldierdie-function-deadsoldierdie-entity-inflictor-attacker-damage-point-world-src-miniquake2-game-world-misc-ml-1747610028"></a>
### deadSoldierDie

```ml
function deadSoldierDie(entity, inflictor, attacker, damage, point, world)
```

Handle dead soldier.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `inflictor` | `dynamic` | — | inflictor value consumed by this operation. |
| `attacker` | `dynamic` | — | attacker value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `point` | `dynamic` | — | point value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L517)

<a id="function-function-miniquake2-game-world-misc-debrisdie-function-debrisdie-entity-inflictor-attacker-damage-point-world-src-miniquake2-game-world-misc-ml-1720294374"></a>
### debrisDie

```ml
function debrisDie(entity, inflictor, attacker, damage, point, world)
```

ThrowDebris uses a quiet damage callback: shooting a chunk removes it but must not create a blood/gib effect.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `inflictor` | `dynamic` | — | inflictor value consumed by this operation. |
| `attacker` | `dynamic` | — | attacker value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `point` | `dynamic` | — | point value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L611)

<a id="function-function-miniquake2-game-world-misc-easterchick2think-function-easterchick2think-entity-world-src-miniquake2-game-world-misc-ml-261438862"></a>
### easterChick2Think

```ml
function easterChick2Think(entity, world)
```

Run easter chick 2.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L848)

<a id="function-function-miniquake2-game-world-misc-easterchickthink-function-easterchickthink-entity-world-src-miniquake2-game-world-misc-ml-1927692870"></a>
### easterChickThink

```ml
function easterChickThink(entity, world)
```

Run easter chick.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L820)

<a id="function-function-miniquake2-game-world-misc-eastertankthink-function-eastertankthink-entity-world-src-miniquake2-game-world-misc-ml-1429421286"></a>
### easterTankThink

```ml
function easterTankThink(entity, world)
```

Run easter tank.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L792)

<a id="function-function-miniquake2-game-world-misc-findworldviper-function-findworldviper-world-src-miniquake2-game-world-misc-ml-1370092317"></a>
### findWorldViper

```ml
function findWorldViper(world)
```

Find world viper.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L964)

<a id="function-function-miniquake2-game-world-misc-funcobjectrelease-function-funcobjectrelease-entity-world-src-miniquake2-game-world-misc-ml-545275418"></a>
### funcObjectRelease

```ml
function funcObjectRelease(entity, world)
```

Release func object.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L221)

<a id="function-function-miniquake2-game-world-misc-funcobjecttouch-function-funcobjecttouch-entity-other-world-src-miniquake2-game-world-misc-ml-1914487352"></a>
### funcObjectTouch

```ml
function funcObjectTouch(entity, other, world)
```

Handle func object.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L211)

<a id="function-function-miniquake2-game-world-misc-funcobjectuse-function-funcobjectuse-entity-other-activator-world-src-miniquake2-game-world-misc-ml-2059776123"></a>
### funcObjectUse

```ml
function funcObjectUse(entity, other, activator, world)
```

Use func object.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L232)

<a id="function-function-miniquake2-game-world-misc-gibdie-function-gibdie-entity-inflictor-attacker-damage-point-world-src-miniquake2-game-world-misc-ml-942411464"></a>
### gibDie

```ml
function gibDie(entity, inflictor, attacker, damage, point, world)
```

Handle gib.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `inflictor` | `dynamic` | — | inflictor value consumed by this operation. |
| `attacker` | `dynamic` | — | attacker value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `point` | `dynamic` | — | point value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L598)

<a id="function-function-miniquake2-game-world-misc-gibfree-function-gibfree-entity-world-src-miniquake2-game-world-misc-ml-1362327846"></a>
### gibFree

```ml
function gibFree(entity, world)
```

Release gib.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L587)

<a id="function-function-miniquake2-game-world-misc-lightuse-function-lightuse-entity-other-activator-world-src-miniquake2-game-world-misc-ml-351423335"></a>
### lightUse

```ml
function lightUse(entity, other, activator, world)
```

Use light.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L716)

<a id="function-function-miniquake2-game-world-misc-pathcornertouch-function-pathcornertouch-entity-other-world-src-miniquake2-game-world-misc-ml-414528926"></a>
### pathCornerTouch

```ml
function pathCornerTouch(entity, other, world)
```

path_corner from g_misc.c.  AI-private walk/stand state stays behind the existing actorTransition callback used by target_actor.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L47)

<a id="function-function-miniquake2-game-world-misc-pointcombattouch-function-pointcombattouch-entity-other-world-src-miniquake2-game-world-misc-ml-1407743704"></a>
### pointCombatTouch

```ml
function pointCombatTouch(entity, other, world)
```

point_combat from g_misc.c. AI_COMBAT_POINT and stand-ground mutations live behind combatPointTransition; this world layer owns route consumption, target lookup and G_UseTargets activator selection.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L103)

<a id="function-function-miniquake2-game-world-misc-resetworldclock-function-resetworldclock-entity-src-miniquake2-game-world-misc-ml-457742616"></a>
### resetWorldClock

```ml
function resetWorldClock(entity)
```

Reset world clock.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L1146)

<a id="function-function-miniquake2-game-world-misc-rotatingblocked-function-rotatingblocked-entity-other-world-src-miniquake2-game-world-misc-ml-599927408"></a>
### rotatingBlocked

```ml
function rotatingBlocked(entity, other, world)
```

Report whether rotating blocked.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L279)

<a id="function-function-miniquake2-game-world-misc-rotatingtouch-function-rotatingtouch-entity-other-world-src-miniquake2-game-world-misc-ml-1227895554"></a>
### rotatingTouch

```ml
function rotatingTouch(entity, other, world)
```

Handle rotating.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L288)

<a id="function-function-miniquake2-game-world-misc-rotatinguse-function-rotatinguse-entity-other-activator-world-src-miniquake2-game-world-misc-ml-1908630221"></a>
### rotatingUse

```ml
function rotatingUse(entity, other, activator, world)
```

Use rotating.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L298)

<a id="function-function-miniquake2-game-world-misc-satellitedishthink-function-satellitedishthink-entity-world-src-miniquake2-game-world-misc-ml-824016538"></a>
### satelliteDishThink

```ml
function satelliteDishThink(entity, world)
```

Run satellite dish.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L876)

<a id="function-function-miniquake2-game-world-misc-satellitedishuse-function-satellitedishuse-entity-other-activator-world-src-miniquake2-game-world-misc-ml-709956467"></a>
### satelliteDishUse

```ml
function satelliteDishUse(entity, other, activator, world)
```

Use satellite dish.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L890)

<a id="function-function-miniquake2-game-world-misc-shrinkfuncobjectbounds-function-shrinkfuncobjectbounds-entity-src-miniquake2-game-world-misc-ml-532590570"></a>
### shrinkFuncObjectBounds

```ml
function shrinkFuncObjectBounds(entity)
```

Return the shrink func object bounds.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L244)

<a id="function-function-miniquake2-game-world-misc-sp-func-clock-function-sp-func-clock-entity-world-src-miniquake2-game-world-misc-ml-1159364644"></a>
### SP_func_clock

```ml
function SP_func_clock(entity, world)
```

Spawn func clock.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L1287)

<a id="function-function-miniquake2-game-world-misc-sp-info-notnull-function-sp-info-notnull-entity-world-src-miniquake2-game-world-misc-ml-864907428"></a>
### SP_info_notnull

```ml
function SP_info_notnull(entity, world)
```

Spawn info notnull.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L1300)

<a id="function-function-miniquake2-game-world-misc-sp-light-mine2-function-sp-light-mine2-entity-world-src-miniquake2-game-world-misc-ml-1794784562"></a>
### SP_light_mine2

```ml
function SP_light_mine2(entity, world)
```

Spawn light mine 2.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L1336)

<a id="function-function-miniquake2-game-world-misc-sp-misc-blackhole-function-sp-misc-blackhole-entity-world-src-miniquake2-game-world-misc-ml-340217666"></a>
### SP_misc_blackhole

```ml
function SP_misc_blackhole(entity, world)
```

Spawn misc blackhole.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L1306)

<a id="function-function-miniquake2-game-world-misc-sp-misc-easterchick-function-sp-misc-easterchick-entity-world-src-miniquake2-game-world-misc-ml-1088968328"></a>
### SP_misc_easterchick

```ml
function SP_misc_easterchick(entity, world)
```

Spawn misc easterchick.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L1318)

<a id="function-function-miniquake2-game-world-misc-sp-misc-easterchick2-function-sp-misc-easterchick2-entity-world-src-miniquake2-game-world-misc-ml-1791830622"></a>
### SP_misc_easterchick2

```ml
function SP_misc_easterchick2(entity, world)
```

Spawn misc easterchick 2.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L1324)

<a id="function-function-miniquake2-game-world-misc-sp-misc-eastertank-function-sp-misc-eastertank-entity-world-src-miniquake2-game-world-misc-ml-616450102"></a>
### SP_misc_eastertank

```ml
function SP_misc_eastertank(entity, world)
```

Spawn misc eastertank.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L1312)

<a id="function-function-miniquake2-game-world-misc-sp-misc-satellite-dish-function-sp-misc-satellite-dish-entity-world-src-miniquake2-game-world-misc-ml-292403294"></a>
### SP_misc_satellite_dish

```ml
function SP_misc_satellite_dish(entity, world)
```

Spawn misc satellite dish.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L1330)

<a id="function-function-miniquake2-game-world-misc-sp-misc-viper-function-sp-misc-viper-entity-world-src-miniquake2-game-world-misc-ml-1195666492"></a>
### SP_misc_viper

```ml
function SP_misc_viper(entity, world)
```

Spawn misc viper.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L1342)

<a id="function-function-miniquake2-game-world-misc-sp-misc-viper-bomb-function-sp-misc-viper-bomb-entity-world-src-miniquake2-game-world-misc-ml-901518246"></a>
### SP_misc_viper_bomb

```ml
function SP_misc_viper_bomb(entity, world)
```

Spawn misc viper bomb.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L1348)

<a id="function-function-miniquake2-game-world-misc-sp-point-combat-function-sp-point-combat-entity-world-src-miniquake2-game-world-misc-ml-938035776"></a>
### SP_point_combat

```ml
function SP_point_combat(entity, world)
```

Spawn point combat.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L1294)

<a id="function-function-miniquake2-game-world-misc-sp-target-character-function-sp-target-character-entity-world-src-miniquake2-game-world-misc-ml-51815300"></a>
### SP_target_character

```ml
function SP_target_character(entity, world)
```

Spawn target character.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L1273)

<a id="function-function-miniquake2-game-world-misc-sp-target-string-function-sp-target-string-entity-world-src-miniquake2-game-world-misc-ml-573710586"></a>
### SP_target_string

```ml
function SP_target_string(entity, world)
```

Spawn target string.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L1280)

<a id="function-function-miniquake2-game-world-misc-spawnareaportal-function-spawnareaportal-entity-world-src-miniquake2-game-world-misc-ml-97340374"></a>
### spawnAreaPortal

```ml
function spawnAreaPortal(entity, world)
```

Spawn area portal.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L35)

<a id="function-function-miniquake2-game-world-misc-spawnbanner-function-spawnbanner-entity-world-src-miniquake2-game-world-misc-ml-225495792"></a>
### spawnBanner

```ml
function spawnBanner(entity, world)
```

Spawn banner.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L499)

<a id="function-function-miniquake2-game-world-misc-spawnbigviper-function-spawnbigviper-entity-world-src-miniquake2-game-world-misc-ml-1837118792"></a>
### spawnBigViper

```ml
function spawnBigViper(entity, world)
```

Spawn big viper.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L700)

<a id="function-function-miniquake2-game-world-misc-spawnblackhole-function-spawnblackhole-entity-world-src-miniquake2-game-world-misc-ml-1754892742"></a>
### spawnBlackHole

```ml
function spawnBlackHole(entity, world)
```

Spawn black hole.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L774)

<a id="function-function-miniquake2-game-world-misc-spawndeadsoldier-function-spawndeadsoldier-entity-world-src-miniquake2-game-world-misc-ml-436836278"></a>
### spawnDeadSoldier

```ml
function spawnDeadSoldier(entity, world)
```

Spawn dead soldier.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L527)

<a id="function-function-miniquake2-game-world-misc-spawneasterchick-function-spawneasterchick-entity-world-src-miniquake2-game-world-misc-ml-571522258"></a>
### spawnEasterChick

```ml
function spawnEasterChick(entity, world)
```

Spawn easter chick.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L831)

<a id="function-function-miniquake2-game-world-misc-spawneasterchick2-function-spawneasterchick2-entity-world-src-miniquake2-game-world-misc-ml-1134573532"></a>
### spawnEasterChick2

```ml
function spawnEasterChick2(entity, world)
```

Spawn easter chick 2.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L859)

<a id="function-function-miniquake2-game-world-misc-spawneastertank-function-spawneastertank-entity-world-src-miniquake2-game-world-misc-ml-1100153472"></a>
### spawnEasterTank

```ml
function spawnEasterTank(entity, world)
```

Spawn easter tank.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L803)

<a id="function-function-miniquake2-game-world-misc-spawnexplobox-function-spawnexplobox-entity-world-src-miniquake2-game-world-misc-ml-1587121030"></a>
### spawnExplobox

```ml
function spawnExplobox(entity, world)
```

Spawn explobox.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L467)

<a id="function-function-miniquake2-game-world-misc-spawngibarm-function-spawngibarm-entity-world-src-miniquake2-game-world-misc-ml-145381884"></a>
### spawnGibArm

```ml
function spawnGibArm(entity, world)
```

Spawn gib arm.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L647)

<a id="function-function-miniquake2-game-world-misc-spawngibhead-function-spawngibhead-entity-world-src-miniquake2-game-world-misc-ml-1507552198"></a>
### spawnGibHead

```ml
function spawnGibHead(entity, world)
```

Spawn gib head.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L640)

<a id="function-function-miniquake2-game-world-misc-spawngibleg-function-spawngibleg-entity-world-src-miniquake2-game-world-misc-ml-458659636"></a>
### spawnGibLeg

```ml
function spawnGibLeg(entity, world)
```

Spawn gib leg.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L654)

<a id="function-function-miniquake2-game-world-misc-spawngibpart-function-spawngibpart-entity-modelname-world-src-miniquake2-game-world-misc-ml-1198036804"></a>
### spawnGibPart

```ml
function spawnGibPart(entity, modelName, world)
```

Spawn gib part.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `modelName` | `dynamic` | — | modelName value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L619)

<a id="function-function-miniquake2-game-world-misc-spawninfonotnull-function-spawninfonotnull-entity-world-src-miniquake2-game-world-misc-ml-423706510"></a>
### spawnInfoNotNull

```ml
function spawnInfoNotNull(entity, world)
```

Spawn info not null.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L743)

<a id="function-function-miniquake2-game-world-misc-spawnlight-function-spawnlight-entity-world-src-miniquake2-game-world-misc-ml-1829658266"></a>
### spawnLight

```ml
function spawnLight(entity, world)
```

Spawn light.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L727)

<a id="function-function-miniquake2-game-world-misc-spawnlightmine1-function-spawnlightmine1-entity-world-src-miniquake2-game-world-misc-ml-1417247588"></a>
### spawnLightMine1

```ml
function spawnLightMine1(entity, world)
```

Spawn light mine 1.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L688)

<a id="function-function-miniquake2-game-world-misc-spawnlightmine2-function-spawnlightmine2-entity-world-src-miniquake2-game-world-misc-ml-2044297782"></a>
### spawnLightMine2

```ml
function spawnLightMine2(entity, world)
```

Spawn light mine 2.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L915)

<a id="function-function-miniquake2-game-world-misc-spawnnull-function-spawnnull-entity-world-src-miniquake2-game-world-misc-ml-1671523878"></a>
### spawnNull

```ml
function spawnNull(entity, world)
```

Spawn null.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L736)

<a id="function-function-miniquake2-game-world-misc-spawnobject-function-spawnobject-entity-world-src-miniquake2-game-world-misc-ml-1212386246"></a>
### spawnObject

```ml
function spawnObject(entity, world)
```

Spawn object.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L254)

<a id="function-function-miniquake2-game-world-misc-spawnpathcorner-function-spawnpathcorner-entity-world-src-miniquake2-game-world-misc-ml-840075708"></a>
### spawnPathCorner

```ml
function spawnPathCorner(entity, world)
```

Spawn path corner.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L81)

<a id="function-function-miniquake2-game-world-misc-spawnpointcombat-function-spawnpointcombat-entity-world-deathmatch-src-miniquake2-game-world-misc-ml-1068116863"></a>
### spawnPointCombat

```ml
function spawnPointCombat(entity, world, deathmatch)
```

Spawn point combat.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |
| `deathmatch` | `dynamic` | — | deathmatch value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L152)

<a id="function-function-miniquake2-game-world-misc-spawnrotating-function-spawnrotating-entity-world-src-miniquake2-game-world-misc-ml-894668600"></a>
### spawnRotating

```ml
function spawnRotating(entity, world)
```

Spawn rotating.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L314)

<a id="function-function-miniquake2-game-world-misc-spawnsatellitedish-function-spawnsatellitedish-entity-world-src-miniquake2-game-world-misc-ml-4018334"></a>
### spawnSatelliteDish

```ml
function spawnSatelliteDish(entity, world)
```

Spawn satellite dish.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L900)

<a id="function-function-miniquake2-game-world-misc-spawnstroggship-function-spawnstroggship-entity-world-src-miniquake2-game-world-misc-ml-810754304"></a>
### spawnStroggShip

```ml
function spawnStroggShip(entity, world)
```

Spawn strogg ship.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L561)

<a id="function-function-miniquake2-game-world-misc-spawntargetcharacter-function-spawntargetcharacter-entity-world-src-miniquake2-game-world-misc-ml-1514499194"></a>
### spawnTargetCharacter

```ml
function spawnTargetCharacter(entity, world)
```

target_character / target_string from g_misc.c.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L1051)

<a id="function-function-miniquake2-game-world-misc-spawntargetstring-function-spawntargetstring-entity-world-src-miniquake2-game-world-misc-ml-2021551736"></a>
### spawnTargetString

```ml
function spawnTargetString(entity, world)
```

Spawn target string.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L1105)

<a id="function-function-miniquake2-game-world-misc-spawnteleporter-function-spawnteleporter-entity-world-src-miniquake2-game-world-misc-ml-2080828036"></a>
### spawnTeleporter

```ml
function spawnTeleporter(entity, world)
```

Spawn teleporter.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L357)

<a id="function-function-miniquake2-game-world-misc-spawnteleporterdestination-function-spawnteleporterdestination-entity-world-src-miniquake2-game-world-misc-ml-1409483778"></a>
### spawnTeleporterDestination

```ml
function spawnTeleporterDestination(entity, world)
```

Spawn teleporter destination.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L372)

<a id="function-function-miniquake2-game-world-misc-spawnviewthing-function-spawnviewthing-entity-world-src-miniquake2-game-world-misc-ml-1892226630"></a>
### spawnViewThing

```ml
function spawnViewThing(entity, world)
```

Spawn view thing.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L671)

<a id="function-function-miniquake2-game-world-misc-spawnviper-function-spawnviper-entity-world-src-miniquake2-game-world-misc-ml-951493150"></a>
### spawnViper

```ml
function spawnViper(entity, world)
```

Spawn viper.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L938)

<a id="function-function-miniquake2-game-world-misc-spawnviperbomb-function-spawnviperbomb-entity-world-src-miniquake2-game-world-misc-ml-1925018926"></a>
### spawnViperBomb

```ml
function spawnViperBomb(entity, world)
```

Spawn viper bomb.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L1031)

<a id="function-function-miniquake2-game-world-misc-spawnwall-function-spawnwall-entity-world-src-miniquake2-game-world-misc-ml-15354084"></a>
### spawnWall

```ml
function spawnWall(entity, world)
```

Spawn wall.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L185)

<a id="function-function-miniquake2-game-world-misc-spawnworldclock-function-spawnworldclock-entity-world-src-miniquake2-game-world-misc-ml-171542768"></a>
### spawnWorldClock

```ml
function spawnWorldClock(entity, world)
```

Spawn world clock.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L1244)

<a id="function-function-miniquake2-game-world-misc-stroggshipuse-function-stroggshipuse-entity-other-activator-world-src-miniquake2-game-world-misc-ml-1302125045"></a>
### stroggShipUse

```ml
function stroggShipUse(entity, other, activator, world)
```

Use strogg ship.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L552)

<a id="function-function-miniquake2-game-world-misc-targetstringframe-function-targetstringframe-character-src-miniquake2-game-world-misc-ml-770784510"></a>
### targetStringFrame

```ml
function targetStringFrame(character)
```

Return the target string frame value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `character` | `dynamic` | — | character value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L1066)

<a id="function-function-miniquake2-game-world-misc-teleportertouch-function-teleportertouch-entity-other-world-src-miniquake2-game-world-misc-ml-1788512258"></a>
### teleporterTouch

```ml
function teleporterTouch(entity, other, world)
```

Handle teleporter.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L338)

<a id="function-function-miniquake2-game-world-misc-usetargetstring-function-usetargetstring-entity-other-activator-world-src-miniquake2-game-world-misc-ml-1403505957"></a>
### useTargetString

```ml
function useTargetString(entity, other, activator, world)
```

Use target string.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L1078)

<a id="function-function-miniquake2-game-world-misc-useworldclock-function-useworldclock-entity-other-activator-world-src-miniquake2-game-world-misc-ml-224399677"></a>
### useWorldClock

```ml
function useWorldClock(entity, other, activator, world)
```

Use world clock.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L1234)

<a id="function-function-miniquake2-game-world-misc-viewthingthink-function-viewthingthink-entity-world-src-miniquake2-game-world-misc-ml-781562086"></a>
### viewThingThink

```ml
function viewThingThink(entity, world)
```

Run view thing.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L661)

<a id="function-function-miniquake2-game-world-misc-viperbombprethink-function-viperbombprethink-entity-world-src-miniquake2-game-world-misc-ml-1933330748"></a>
### viperBombPreThink

```ml
function viperBombPreThink(entity, world)
```

Run viper bomb pre.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L974)

<a id="function-function-miniquake2-game-world-misc-viperbombtouch-function-viperbombtouch-entity-other-world-src-miniquake2-game-world-misc-ml-1737909804"></a>
### viperBombTouch

```ml
function viperBombTouch(entity, other, world)
```

Handle viper bomb.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L992)

<a id="function-function-miniquake2-game-world-misc-viperbombuse-function-viperbombuse-entity-other-activator-world-src-miniquake2-game-world-misc-ml-1336961131"></a>
### viperBombUse

```ml
function viperBombUse(entity, other, activator, world)
```

Use viper bomb.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L1006)

<a id="function-function-miniquake2-game-world-misc-viperuse-function-viperuse-entity-other-activator-world-src-miniquake2-game-world-misc-ml-478644987"></a>
### viperUse

```ml
function viperUse(entity, other, activator, world)
```

Use viper.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L929)

<a id="function-function-miniquake2-game-world-misc-walluse-function-walluse-entity-other-activator-world-src-miniquake2-game-world-misc-ml-1033964885"></a>
### wallUse

```ml
function wallUse(entity, other, activator, world)
```

Use wall.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L168)

<a id="function-function-miniquake2-game-world-misc-worldclockdisplay-function-worldclockdisplay-entity-world-src-miniquake2-game-world-misc-ml-1463879318"></a>
### worldClockDisplay

```ml
function worldClockDisplay(entity, world)
```

Return the world clock display value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L1161)

<a id="function-function-miniquake2-game-world-misc-worldclockformatvalue-function-worldclockformatvalue-value-style-src-miniquake2-game-world-misc-ml-1649537341"></a>
### worldClockFormatValue

```ml
function worldClockFormatValue(value, style)
```

Format world clock value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `style` | `dynamic` | — | style value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L1130)

<a id="function-function-miniquake2-game-world-misc-worldclockthink-function-worldclockthink-entity-world-src-miniquake2-game-world-misc-ml-538628650"></a>
### worldClockThink

```ml
function worldClockThink(entity, world)
```

Run world clock.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L1181)

<a id="function-function-miniquake2-game-world-misc-worldclocktwodigits-function-worldclocktwodigits-value-src-miniquake2-game-world-misc-ml-610841006"></a>
### worldClockTwoDigits

```ml
function worldClockTwoDigits(value)
```

Return the world clock two digits value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L1122)

<a id="function-function-miniquake2-game-world-misc-worldclocktwowide-function-worldclocktwowide-value-src-miniquake2-game-world-misc-ml-1987657180"></a>
### worldClockTwoWide

```ml
function worldClockTwoWide(value)
```

func_clock. The original localtime dependency is injected as clockSeconds; timer-up/down paths remain entirely scheduler-driven and deterministic.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/misc.ml#L1115)
