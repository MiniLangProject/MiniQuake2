# `src/miniquake2/game/world/core.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 game world core facilities for this project.

Package: [`miniquake2.game.world.core`](Package-miniquake2-game-world-core-2069423224.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/game/world/constants.ml` as `gwconstants` → [src/miniquake2/game/world/constants.ml](File-src-miniquake2-game-world-constants-ml-774918061.md)
- `miniquake2/game/world/types.ml` as `gwtypes` → [src/miniquake2/game/world/types.ml](File-src-miniquake2-game-world-types-ml-1207695045.md)
- `miniquake2/game/world/vector.ml` as `gwvector` → [src/miniquake2/game/world/vector.ml](File-src-miniquake2-game-world-vector-ml-1561306429.md)
- `miniquake2/qcommon/text.ml` as `qtext` → [src/miniquake2/qcommon/text.ml](File-src-miniquake2-qcommon-text-ml-1570504148.md)
- `miniquake2/qcommon/types.ml` as `gwcoreqtypes` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)

## Declarations

<a id="function-function-miniquake2-game-world-core-addentity-function-addentity-world-entity-src-miniquake2-game-world-core-ml-1189654930"></a>
### addEntity

```ml
function addEntity(world, entity)
```

Add entity.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `world` | `dynamic` | — | world value consumed by this operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/core.ml#L269)

<a id="function-function-miniquake2-game-world-core-advance-function-advance-world-targettime-src-miniquake2-game-world-core-ml-1421109323"></a>
### advance

```ml
function advance(world, targetTime)
```

Performs the advance operation for the miniquake2 game world core module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `world` | `dynamic` | — | world value consumed by this operation. |
| `targetTime` | `dynamic` | — | targetTime value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/core.ml#L515)

<a id="function-function-miniquake2-game-world-core-blockedentity-function-blockedentity-world-entity-other-src-miniquake2-game-world-core-ml-68410560"></a>
### blockedEntity

```ml
function blockedEntity(world, entity, other)
```

Report whether blocked entity.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `world` | `dynamic` | — | world value consumed by this operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/core.ml#L389)

<a id="function-function-miniquake2-game-world-core-createworld-function-createworld-callbacks-src-miniquake2-game-world-core-ml-973959135"></a>
### createWorld

```ml
function createWorld(callbacks)
```

Create world.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `callbacks` | `dynamic` | — | callbacks value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/core.ml#L238)

<a id="function-function-miniquake2-game-world-core-defaultcallbacks-function-defaultcallbacks-src-miniquake2-game-world-core-ml-1439469095"></a>
### defaultCallbacks

```ml
function defaultCallbacks()
```

Return the default callbacks value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/core.ml#L222)

<a id="function-function-miniquake2-game-world-core-emit-function-emit-world-kind-entity-detail-src-miniquake2-game-world-core-ml-636553391"></a>
### emit

```ml
function emit(world, kind, entity, detail)
```

Performs the emit operation for the miniquake2 game world core module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `world` | `dynamic` | — | world value consumed by this operation. |
| `kind` | `dynamic` | — | kind value consumed by this operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `detail` | `dynamic` | — | detail value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/core.ml#L251)

<a id="function-function-miniquake2-game-world-core-findbynumber-function-findbynumber-world-number-src-miniquake2-game-world-core-ml-875625640"></a>
### findByNumber

```ml
function findByNumber(world, number)
```

Find by number.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `world` | `dynamic` | — | world value consumed by this operation. |
| `number` | `dynamic` | — | number value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/core.ml#L320)

<a id="function-function-miniquake2-game-world-core-freeentity-function-freeentity-world-entity-src-miniquake2-game-world-core-ml-1857246538"></a>
### freeEntity

```ml
function freeEntity(world, entity)
```

Release entity.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `world` | `dynamic` | — | world value consumed by this operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/core.ml#L293)

<a id="function-function-miniquake2-game-world-core-freethink-function-freethink-entity-world-src-miniquake2-game-world-core-ml-1536443488"></a>
### freeThink

```ml
function freeThink(entity, world)
```

Release think.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/core.ml#L313)

<a id="function-function-miniquake2-game-world-core-g-usetargets-function-g-usetargets-entity-activator-world-src-miniquake2-game-world-core-ml-967553201"></a>
### G_UseTargets

```ml
function G_UseTargets(entity, activator, world)
```

Source-traceable entry points retained for later baseq2 registry wiring.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/core.ml#L579)

<a id="function-function-miniquake2-game-world-core-integrate-inline-function-integrate-world-duration-src-miniquake2-game-world-core-ml-603899986"></a>
### integrate

```ml
inline function integrate(world, duration)
```

Return the integrate value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `world` | `dynamic` | — | world value consumed by this operation. |
| `duration` | `dynamic` | — | duration value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/core.ml#L488)

<a id="function-function-miniquake2-game-world-core-killentity-function-killentity-world-entity-inflictor-attacker-damage-point-src-miniquake2-game-world-core-ml-339053976"></a>
### killEntity

```ml
function killEntity(world, entity, inflictor, attacker, damage, point)
```

Kill entity.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `world` | `dynamic` | — | world value consumed by this operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `inflictor` | `dynamic` | — | inflictor value consumed by this operation. |
| `attacker` | `dynamic` | — | attacker value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `point` | `dynamic` | — | point value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/core.ml#L402)

<a id="function-function-miniquake2-game-world-core-log-function-log-world-message-src-miniquake2-game-world-core-ml-1137828074"></a>
### log

```ml
function log(world, message)
```

Return the log value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `world` | `dynamic` | — | world value consumed by this operation. |
| `message` | `dynamic` | — | Human-readable message associated with the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/core.ml#L261)

<a id="function-function-miniquake2-game-world-core-matchingtargets-function-matchingtargets-world-targetname-src-miniquake2-game-world-core-ml-1141565503"></a>
### matchingTargets

```ml
function matchingTargets(world, targetName)
```

Return the matching targets value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `world` | `dynamic` | — | world value consumed by this operation. |
| `targetName` | `dynamic` | — | targetName value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/core.ml#L330)

<a id="constant-constant-miniquake2-game-world-core-max-world-event-history-const-max-world-event-history-1024-src-miniquake2-game-world-core-ml-990378043"></a>
### MAX_WORLD_EVENT_HISTORY

```ml
const MAX_WORLD_EVENT_HISTORY = 1024
```

Defines the max world event history constant used by the miniquake2 game world core module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/core.ml#L17)

<a id="function-function-miniquake2-game-world-core-noopactormessage-function-noopactormessage-actor-message-src-miniquake2-game-world-core-ml-1651294215"></a>
### noopActorMessage

```ml
function noopActorMessage(actor, message)
```

Return the noop actor message value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `message` | `dynamic` | — | Human-readable message associated with the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/core.ml#L138)

<a id="function-function-miniquake2-game-world-core-noopactortransition-function-noopactortransition-actor-waypoint-action-actiontarget-nexttarget-wait-flags-src-miniquake2-game-world-core-ml-203139292"></a>
### noopActorTransition

```ml
function noopActorTransition(actor, waypoint, action, actionTarget, nextTarget, wait, flags)
```

Return the noop actor transition value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `waypoint` | `dynamic` | — | waypoint value consumed by this operation. |
| `action` | `dynamic` | — | action value consumed by this operation. |
| `actionTarget` | `dynamic` | — | actionTarget value consumed by this operation. |
| `nextTarget` | `dynamic` | — | nextTarget value consumed by this operation. |
| `wait` | `dynamic` | — | wait value consumed by this operation. |
| `flags` | `dynamic` | — | Bit flags controlling the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/core.ml#L149)

<a id="function-function-miniquake2-game-world-core-noopareaportal-function-noopareaportal-style-isopen-src-miniquake2-game-world-core-ml-930785168"></a>
### noopAreaPortal

```ml
function noopAreaPortal(style, isOpen)
```

Return the noop area portal value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `style` | `dynamic` | — | style value consumed by this operation. |
| `isOpen` | `dynamic` | — | isOpen value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/core.ml#L54)

<a id="function-function-miniquake2-game-world-core-noopcenterprint-function-noopcenterprint-entity-message-src-miniquake2-game-world-core-ml-2094614401"></a>
### noopCenterPrint

```ml
function noopCenterPrint(entity, message)
```

Print noop center.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `message` | `dynamic` | — | Human-readable message associated with the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/core.ml#L42)

<a id="function-function-miniquake2-game-world-core-noopchangelevel-function-noopchangelevel-entity-other-activator-mapname-src-miniquake2-game-world-core-ml-869932534"></a>
### noopChangeLevel

```ml
function noopChangeLevel(entity, other, activator, mapName)
```

Return the noop change level value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/core.ml#L88)

<a id="function-function-miniquake2-game-world-core-noopcombatpointtransition-function-noopcombatpointtransition-actor-point-nexttarget-hold-clearcombatpoint-src-miniquake2-game-world-core-ml-1551516438"></a>
### noopCombatPointTransition

```ml
function noopCombatPointTransition(actor, point, nextTarget, hold, clearCombatPoint)
```

Return the noop combat point transition value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `point` | `dynamic` | — | point value consumed by this operation. |
| `nextTarget` | `dynamic` | — | nextTarget value consumed by this operation. |
| `hold` | `dynamic` | — | hold value consumed by this operation. |
| `clearCombatPoint` | `dynamic` | — | clearCombatPoint value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/core.ml#L158)

<a id="function-function-miniquake2-game-world-core-noopconsumekeyitem-function-noopconsumekeyitem-activator-itemclassname-src-miniquake2-game-world-core-ml-2132049886"></a>
### noopConsumeKeyItem

```ml
function noopConsumeKeyItem(activator, itemClassName)
```

Consume noop key item.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `itemClassName` | `dynamic` | — | itemClassName value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/core.ml#L132)

<a id="function-function-miniquake2-game-world-core-noopdamage-function-noopdamage-target-inflictor-attacker-amount-means-src-miniquake2-game-world-core-ml-652699963"></a>
### noopDamage

```ml
function noopDamage(target, inflictor, attacker, amount, means)
```

Return the noop damage value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `target` | `dynamic` | — | target value consumed by this operation. |
| `inflictor` | `dynamic` | — | inflictor value consumed by this operation. |
| `attacker` | `dynamic` | — | attacker value consumed by this operation. |
| `amount` | `dynamic` | — | amount value consumed by this operation. |
| `means` | `dynamic` | — | means value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/core.ml#L63)

<a id="function-function-miniquake2-game-world-core-noopearthquake-function-noopearthquake-entity-speed-playsound-src-miniquake2-game-world-core-ml-534014122"></a>
### noopEarthquake

```ml
function noopEarthquake(entity, speed, playSound)
```

Return the noop earthquake value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `speed` | `dynamic` | — | speed value consumed by this operation. |
| `playSound` | `dynamic` | — | playSound value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/core.ml#L196)

<a id="function-function-miniquake2-game-world-core-noopeffect-function-noopeffect-kind-origin-style-count-src-miniquake2-game-world-core-ml-431031691"></a>
### noopEffect

```ml
function noopEffect(kind, origin, style, count)
```

Return the noop effect value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `kind` | `dynamic` | — | kind value consumed by this operation. |
| `origin` | `dynamic` | — | origin value consumed by this operation. |
| `style` | `dynamic` | — | style value consumed by this operation. |
| `count` | `dynamic` | — | Number of items or units to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/core.ml#L80)

<a id="function-function-miniquake2-game-world-core-noopfireblaster-function-noopfireblaster-entity-direction-damage-speed-src-miniquake2-game-world-core-ml-1629560057"></a>
### noopFireBlaster

```ml
function noopFireBlaster(entity, direction, damage, speed)
```

Fire noop blaster.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `direction` | `dynamic` | — | direction value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `speed` | `dynamic` | — | speed value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/core.ml#L204)

<a id="function-function-miniquake2-game-world-core-noophaskeyitem-function-noophaskeyitem-activator-itemclassname-src-miniquake2-game-world-core-ml-2138504118"></a>
### noopHasKeyItem

```ml
function noopHasKeyItem(activator, itemClassName)
```

Report whether noop has key item.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `itemClassName` | `dynamic` | — | itemClassName value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/core.ml#L126)

<a id="function-function-miniquake2-game-world-core-noopkillbox-function-noopkillbox-entity-src-miniquake2-game-world-core-ml-999709528"></a>
### noopKillBox

```ml
function noopKillBox(entity)
```

Kill noop box.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/core.ml#L106)

<a id="function-function-miniquake2-game-world-core-nooplasersparks-function-nooplasersparks-origin-normal-count-color-src-miniquake2-game-world-core-ml-2021858216"></a>
### noopLaserSparks

```ml
function noopLaserSparks(origin, normal, count, color)
```

Return the noop laser sparks value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `origin` | `dynamic` | — | origin value consumed by this operation. |
| `normal` | `dynamic` | — | normal value consumed by this operation. |
| `count` | `dynamic` | — | Number of items or units to process. |
| `color` | `dynamic` | — | color value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/core.ml#L189)

<a id="function-function-miniquake2-game-world-core-nooplightstyle-function-nooplightstyle-style-pattern-src-miniquake2-game-world-core-ml-504959684"></a>
### noopLightStyle

```ml
function noopLightStyle(style, pattern)
```

Return the noop light style value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `style` | `dynamic` | — | style value consumed by this operation. |
| `pattern` | `dynamic` | — | pattern value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/core.ml#L174)

<a id="function-function-miniquake2-game-world-core-nooplinkentity-function-nooplinkentity-entity-src-miniquake2-game-world-core-ml-1443240070"></a>
### noopLinkEntity

```ml
function noopLinkEntity(entity)
```

Link noop entity.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/core.ml#L101)

<a id="function-function-miniquake2-game-world-core-nooplog-function-nooplog-message-src-miniquake2-game-world-core-ml-572882074"></a>
### noopLog

```ml
function noopLog(message)
```

Return the noop log value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `message` | `dynamic` | — | Human-readable message associated with the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/core.ml#L36)

<a id="function-function-miniquake2-game-world-core-noopradiusdamage-function-noopradiusdamage-inflictor-attacker-amount-radius-means-src-miniquake2-game-world-core-ml-1612927990"></a>
### noopRadiusDamage

```ml
function noopRadiusDamage(inflictor, attacker, amount, radius, means)
```

Return the noop radius damage value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `inflictor` | `dynamic` | — | inflictor value consumed by this operation. |
| `attacker` | `dynamic` | — | attacker value consumed by this operation. |
| `amount` | `dynamic` | — | amount value consumed by this operation. |
| `radius` | `dynamic` | — | radius value consumed by this operation. |
| `means` | `dynamic` | — | means value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/core.ml#L72)

<a id="function-function-miniquake2-game-world-core-noopresolvekeyitem-function-noopresolvekeyitem-itemclassname-src-miniquake2-game-world-core-ml-393131025"></a>
### noopResolveKeyItem

```ml
function noopResolveKeyItem(itemClassName)
```

Resolve noop key item.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `itemClassName` | `dynamic` | — | itemClassName value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/core.ml#L120)

<a id="function-function-miniquake2-game-world-core-noopsetmodel-function-noopsetmodel-entity-modelname-src-miniquake2-game-world-core-ml-1886665026"></a>
### noopSetModel

```ml
function noopSetModel(entity, modelName)
```

Set noop model.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `modelName` | `dynamic` | — | modelName value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/core.ml#L168)

<a id="function-function-miniquake2-game-world-core-noopsound-function-noopsound-entity-soundname-src-miniquake2-game-world-core-ml-1466186598"></a>
### noopSound

```ml
function noopSound(entity, soundName)
```

Return the noop sound value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `soundName` | `dynamic` | — | soundName value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/core.ml#L48)

<a id="function-function-miniquake2-game-world-core-noopspawnexternal-function-noopspawnexternal-classname-origin-angles-velocity-src-miniquake2-game-world-core-ml-496719181"></a>
### noopSpawnExternal

```ml
function noopSpawnExternal(className, origin, angles, velocity)
```

Spawn noop external.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `className` | `dynamic` | — | className value consumed by this operation. |
| `origin` | `dynamic` | — | origin value consumed by this operation. |
| `angles` | `dynamic` | — | angles value consumed by this operation. |
| `velocity` | `dynamic` | — | velocity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/core.ml#L96)

<a id="function-function-miniquake2-game-world-core-nooptargetexplosion-function-nooptargetexplosion-origin-src-miniquake2-game-world-core-ml-340662001"></a>
### noopTargetExplosion

```ml
function noopTargetExplosion(origin)
```

Return the noop target explosion value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `origin` | `dynamic` | — | origin value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/core.ml#L209)

<a id="function-function-miniquake2-game-world-core-nooptargetsplash-function-nooptargetsplash-origin-direction-count-sounds-src-miniquake2-game-world-core-ml-103889649"></a>
### noopTargetSplash

```ml
function noopTargetSplash(origin, direction, count, sounds)
```

Return the noop target splash value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `origin` | `dynamic` | — | origin value consumed by this operation. |
| `direction` | `dynamic` | — | direction value consumed by this operation. |
| `count` | `dynamic` | — | Number of items or units to process. |
| `sounds` | `dynamic` | — | sounds value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/core.ml#L217)

<a id="function-function-miniquake2-game-world-core-nooptraceline-function-nooptraceline-start-finish-ignore-src-miniquake2-game-world-core-ml-1142262310"></a>
### noopTraceLine

```ml
function noopTraceLine(start, finish, ignore)
```

Trace noop line.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `finish` | `dynamic` | — | finish value consumed by this operation. |
| `ignore` | `dynamic` | — | ignore value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/core.ml#L181)

<a id="function-function-miniquake2-game-world-core-picktarget-function-picktarget-world-targetname-src-miniquake2-game-world-core-ml-1624922809"></a>
### pickTarget

```ml
function pickTarget(world, targetName)
```

Choose target.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `world` | `dynamic` | — | world value consumed by this operation. |
| `targetName` | `dynamic` | — | targetName value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/core.ml#L347)

<a id="function-function-miniquake2-game-world-core-runframe-function-runframe-world-src-miniquake2-game-world-core-ml-1860883887"></a>
### runFrame

```ml
function runFrame(world)
```

Run frame.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/core.ml#L571)

<a id="function-function-miniquake2-game-world-core-spawnentity-function-spawnentity-world-classname-src-miniquake2-game-world-core-ml-814261038"></a>
### spawnEntity

```ml
function spawnEntity(world, className)
```

Spawn entity.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `world` | `dynamic` | — | world value consumed by this operation. |
| `className` | `dynamic` | — | className value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/core.ml#L283)

<a id="function-function-miniquake2-game-world-core-think-delay-function-think-delay-entity-world-src-miniquake2-game-world-core-ml-464606292"></a>
### Think_Delay

```ml
function Think_Delay(entity, world)
```

Run delay.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/core.ml#L586)

<a id="function-function-miniquake2-game-world-core-thinkdelayed-function-thinkdelayed-entity-world-src-miniquake2-game-world-core-ml-347391640"></a>
### thinkDelayed

```ml
function thinkDelayed(entity, world)
```

Run delayed.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/core.ml#L411)

<a id="function-function-miniquake2-game-world-core-touchentity-function-touchentity-world-entity-other-src-miniquake2-game-world-core-ml-748900738"></a>
### touchEntity

```ml
function touchEntity(world, entity, other)
```

Handle entity.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `world` | `dynamic` | — | world value consumed by this operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/core.ml#L378)

<a id="function-function-miniquake2-game-world-core-useentity-function-useentity-world-entity-other-activator-src-miniquake2-game-world-core-ml-982434157"></a>
### useEntity

```ml
function useEntity(world, entity, other, activator)
```

Use entity.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `world` | `dynamic` | — | world value consumed by this operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/core.ml#L367)

<a id="function-function-miniquake2-game-world-core-usetargets-function-usetargets-world-entity-activator-src-miniquake2-game-world-core-ml-1924843957"></a>
### useTargets

```ml
function useTargets(world, entity, activator)
```

Use targets.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `world` | `dynamic` | — | world value consumed by this operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/core.ml#L421)

<a id="function-function-miniquake2-game-world-core-worldcoreappendevent-function-worldcoreappendevent-values-value-src-miniquake2-game-world-core-ml-1662941682"></a>
### worldCoreAppendEvent

```ml
function worldCoreAppendEvent(values, value)
```

Append world core event.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `values` | `dynamic` | — | values value consumed by this operation. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/core.ml#L22)

<a id="function-function-miniquake2-game-world-core-zeroclockseconds-function-zeroclockseconds-src-miniquake2-game-world-core-ml-328623319"></a>
### zeroClockSeconds

```ml
function zeroClockSeconds()
```

Return the zero clock seconds value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/core.ml#L162)

<a id="function-function-miniquake2-game-world-core-zerorandomindex-function-zerorandomindex-count-src-miniquake2-game-world-core-ml-522407184"></a>
### zeroRandomIndex

```ml
function zeroRandomIndex(count)
```

Return the zero random index.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `count` | `dynamic` | — | Number of items or units to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/core.ml#L115)

<a id="function-function-miniquake2-game-world-core-zerorandomsigned-function-zerorandomsigned-src-miniquake2-game-world-core-ml-2143834031"></a>
### zeroRandomSigned

```ml
function zeroRandomSigned()
```

Return the zero random signed value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/core.ml#L110)
