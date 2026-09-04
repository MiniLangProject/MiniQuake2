# `src/miniquake2/game/world/turret_types.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 game world turret types facilities for this project.

Package: [`miniquake2.game.world.turret_types`](Package-miniquake2-game-world-turret-types-1329946719.md)

Reachable from entry: **yes**

## Declarations

<a id="function-function-miniquake2-game-world-turret-types-createturretcontrol-function-createturretcontrol-callbacks-skill-src-miniquake2-game-world-turret-types-ml-2076281198"></a>
### createTurretControl

```ml
function createTurretControl(callbacks, skill)
```

Create turret control.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `callbacks` | `dynamic` | — | callbacks value consumed by this operation. |
| `skill` | `dynamic` | — | skill value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/turret_types.ml#L151)

<a id="function-function-miniquake2-game-world-turret-types-createturretlimits-function-createturretlimits-minpitch-maxpitch-minyaw-maxyaw-src-miniquake2-game-world-turret-types-ml-1019867423"></a>
### createTurretLimits

```ml
function createTurretLimits(minPitch, maxPitch, minYaw, maxYaw)
```

Create turret limits.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `minPitch` | `dynamic` | — | minPitch value consumed by this operation. |
| `maxPitch` | `dynamic` | — | maxPitch value consumed by this operation. |
| `minYaw` | `dynamic` | — | minYaw value consumed by this operation. |
| `maxYaw` | `dynamic` | — | maxYaw value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/turret_types.ml#L169)

<a id="function-function-miniquake2-game-world-turret-types-defaultturretcallbacks-function-defaultturretcallbacks-src-miniquake2-game-world-turret-types-ml-915578955"></a>
### defaultTurretCallbacks

```ml
function defaultTurretCallbacks()
```

Return the default turret callbacks value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/turret_types.ml#L140)

<a id="function-function-miniquake2-game-world-turret-types-defaultturretlimits-function-defaultturretlimits-src-miniquake2-game-world-turret-types-ml-2091567753"></a>
### defaultTurretLimits

```ml
function defaultTurretLimits()
```

Return the default turret limits value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/turret_types.ml#L160)

<a id="function-function-miniquake2-game-world-turret-types-turretalwaysvisible-function-turretalwaysvisible-driver-enemy-world-src-miniquake2-game-world-turret-types-ml-104119383"></a>
### turretAlwaysVisible

```ml
function turretAlwaysVisible(driver, enemy, world)
```

Report whether turret always visible.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `driver` | `dynamic` | — | driver value consumed by this operation. |
| `enemy` | `dynamic` | — | enemy value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/turret_types.ml#L65)

- [miniquake2.game.world.turret_types.TurretCallbacks](Type-miniquake2-game-world-turret-types-turretcallbacks-2111726807.md) — struct
- [miniquake2.game.world.turret_types.TurretControl](Type-miniquake2-game-world-turret-types-turretcontrol-1708557334.md) — struct
<a id="function-function-miniquake2-game-world-turret-types-turretentitysound-function-turretentitysound-origin-entity-soundname-world-src-miniquake2-game-world-turret-types-ml-335693704"></a>
### turretEntitySound

```ml
function turretEntitySound(origin, entity, soundName, world)
```

Return the turret entity sound value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `origin` | `dynamic` | — | origin value consumed by this operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `soundName` | `dynamic` | — | soundName value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/turret_types.ml#L96)

- [miniquake2.game.world.turret_types.TurretLimits](Type-miniquake2-game-world-turret-types-turretlimits-1311904909.md) — struct
<a id="function-function-miniquake2-game-world-turret-types-turretnodriverdie-function-turretnodriverdie-driver-inflictor-attacker-damage-point-world-src-miniquake2-game-world-turret-types-ml-1039942779"></a>
### turretNoDriverDie

```ml
function turretNoDriverDie(driver, inflictor, attacker, damage, point, world)
```

Report whether turret no driver die.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `driver` | `dynamic` | — | driver value consumed by this operation. |
| `inflictor` | `dynamic` | — | inflictor value consumed by this operation. |
| `attacker` | `dynamic` | — | attacker value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `point` | `dynamic` | — | point value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/turret_types.ml#L135)

<a id="function-function-miniquake2-game-world-turret-types-turretnodriverspawn-function-turretnodriverspawn-driver-world-src-miniquake2-game-world-turret-types-ml-1001521387"></a>
### turretNoDriverSpawn

```ml
function turretNoDriverSpawn(driver, world)
```

Report whether turret no driver spawn.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `driver` | `dynamic` | — | driver value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/turret_types.ml#L115)

<a id="function-function-miniquake2-game-world-turret-types-turretnodriveruse-function-turretnodriveruse-driver-other-activator-world-src-miniquake2-game-world-turret-types-ml-1833842818"></a>
### turretNoDriverUse

```ml
function turretNoDriverUse(driver, other, activator, world)
```

Report whether turret no driver use.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `driver` | `dynamic` | — | driver value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/turret_types.ml#L124)

<a id="function-function-miniquake2-game-world-turret-types-turretnorocket-function-turretnorocket-attacker-start-direction-damage-speed-splashradius-world-src-miniquake2-game-world-turret-types-ml-1703575000"></a>
### turretNoRocket

```ml
function turretNoRocket(attacker, start, direction, damage, speed, splashRadius, world)
```

Report whether turret no rocket.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `attacker` | `dynamic` | — | attacker value consumed by this operation. |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `direction` | `dynamic` | — | direction value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `speed` | `dynamic` | — | speed value consumed by this operation. |
| `splashRadius` | `dynamic` | — | splashRadius value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/turret_types.ml#L87)

<a id="function-function-miniquake2-game-world-turret-types-turretnoskill-function-turretnoskill-src-miniquake2-game-world-turret-types-ml-1719035403"></a>
### turretNoSkill

```ml
function turretNoSkill()
```

Report whether turret no skill.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/turret_types.ml#L75)

<a id="function-function-miniquake2-game-world-turret-types-turretnotarget-function-turretnotarget-driver-world-src-miniquake2-game-world-turret-types-ml-566531479"></a>
### turretNoTarget

```ml
function turretNoTarget(driver, world)
```

Report whether turret no target.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `driver` | `dynamic` | — | driver value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/turret_types.ml#L57)

<a id="function-function-miniquake2-game-world-turret-types-turretworldcrush-function-turretworldcrush-target-inflictor-attacker-amount-knockback-means-world-src-miniquake2-game-world-turret-types-ml-1902442454"></a>
### turretWorldCrush

```ml
function turretWorldCrush(target, inflictor, attacker, amount, knockback, means, world)
```

Return the turret world crush value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `target` | `dynamic` | — | target value consumed by this operation. |
| `inflictor` | `dynamic` | — | inflictor value consumed by this operation. |
| `attacker` | `dynamic` | — | attacker value consumed by this operation. |
| `amount` | `dynamic` | — | amount value consumed by this operation. |
| `knockback` | `dynamic` | — | knockback value consumed by this operation. |
| `means` | `dynamic` | — | means value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/turret_types.ml#L108)

<a id="function-function-miniquake2-game-world-turret-types-turretzerorandom-function-turretzerorandom-src-miniquake2-game-world-turret-types-ml-370747719"></a>
### turretZeroRandom

```ml
function turretZeroRandom()
```

Return the turret zero random value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/turret_types.ml#L70)
