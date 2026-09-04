# `src/miniquake2/game/weapons/projectiles.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 game weapons projectiles facilities for this project.

Package: [`miniquake2.game.weapons.projectiles`](Package-miniquake2-game-weapons-projectiles-84554240.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/game/gameplay/constants.ml` as `gpconstants` → [src/miniquake2/game/gameplay/constants.ml](File-src-miniquake2-game-gameplay-constants-ml-1803115501.md)
- `miniquake2/game/weapons/constants.ml` as `wbconstants` → [src/miniquake2/game/weapons/constants.ml](File-src-miniquake2-game-weapons-constants-ml-539739454.md)
- `miniquake2/game/weapons/core.ml` as `wbcore` → [src/miniquake2/game/weapons/core.ml](File-src-miniquake2-game-weapons-core-ml-1168965024.md)
- `miniquake2/game/weapons/vector.ml` as `wbvector` → [src/miniquake2/game/weapons/vector.ml](File-src-miniquake2-game-weapons-vector-ml-1084549988.md)
- `miniquake2/qcommon/byteio.ml` as `qbyteio` → [src/miniquake2/qcommon/byteio.ml](File-src-miniquake2-qcommon-byteio-ml-159119335.md)
- `miniquake2/qcommon/constants.ml` as `qc` → [src/miniquake2/qcommon/constants.ml](File-src-miniquake2-qcommon-constants-ml-1976195726.md)
- `miniquake2/qcommon/types.ml` as `qt` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)
- `std/math.ml` as `smath` → `../MiniLangCompilerML/std/math.ml` — external dependency

## Declarations

<a id="function-function-miniquake2-game-weapons-projectiles-advanceprojectile-function-advanceprojectile-context-projectile-src-miniquake2-game-weapons-projectiles-ml-768612189"></a>
### advanceProjectile

```ml
function advanceProjectile(context, projectile)
```

SV_Physics_Toss subset shared by launcher and hand grenades. Missiles do not receive gravity; MOVETYPE_BOUNCE receives the stock 800 ups gravity and 1.5 overbounce before its next server snapshot.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `projectile` | `dynamic` | — | projectile value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/projectiles.ml#L143)

<a id="function-function-miniquake2-game-weapons-projectiles-bfgexplode-function-bfgexplode-projectile-context-src-miniquake2-game-weapons-projectiles-ml-58447637"></a>
### bfgExplode

```ml
function bfgExplode(projectile, context)
```

Return the bfg explode value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `projectile` | `dynamic` | — | projectile value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/projectiles.ml#L428)

<a id="function-function-miniquake2-game-weapons-projectiles-bfgthink-function-bfgthink-projectile-context-src-miniquake2-game-weapons-projectiles-ml-1394014237"></a>
### bfgThink

```ml
function bfgThink(projectile, context)
```

Run bfg.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `projectile` | `dynamic` | — | projectile value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/projectiles.ml#L389)

<a id="function-function-miniquake2-game-weapons-projectiles-bfgtouch-function-bfgtouch-projectile-other-trace-context-src-miniquake2-game-weapons-projectiles-ml-1142862400"></a>
### bfgTouch

```ml
function bfgTouch(projectile, other, trace, context)
```

Handle bfg.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `projectile` | `dynamic` | — | projectile value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `trace` | `dynamic` | — | trace value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/projectiles.ml#L458)

<a id="function-function-miniquake2-game-weapons-projectiles-blastertouch-function-blastertouch-projectile-other-trace-context-src-miniquake2-game-weapons-projectiles-ml-2047110040"></a>
### blasterTouch

```ml
function blasterTouch(projectile, other, trace, context)
```

Handle blaster.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `projectile` | `dynamic` | — | projectile value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `trace` | `dynamic` | — | trace value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/projectiles.ml#L34)

<a id="function-function-miniquake2-game-weapons-projectiles-clipbouncevelocity-function-clipbouncevelocity-projectile-normal-src-miniquake2-game-weapons-projectiles-ml-48230015"></a>
### clipBounceVelocity

```ml
function clipBounceVelocity(projectile, normal)
```

Clip bounce velocity.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `projectile` | `dynamic` | — | projectile value consumed by this operation. |
| `normal` | `dynamic` | — | normal value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/projectiles.ml#L127)

<a id="function-function-miniquake2-game-weapons-projectiles-configuregrenade-function-configuregrenade-context-owner-start-direction-damage-speed-timer-damageradius-hand-held-src-miniquake2-game-weapons-projectiles-ml-2004987356"></a>
### configureGrenade

```ml
function configureGrenade(context, owner, start, direction, damage, speed, timer, damageRadius, hand, held)
```

Configure grenade.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `owner` | `dynamic` | — | owner value consumed by this operation. |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `direction` | `dynamic` | — | direction value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `speed` | `dynamic` | — | speed value consumed by this operation. |
| `timer` | `dynamic` | — | timer value consumed by this operation. |
| `damageRadius` | `dynamic` | — | damageRadius value consumed by this operation. |
| `hand` | `dynamic` | — | hand value consumed by this operation. |
| `held` | `dynamic` | — | held value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/projectiles.ml#L268)

<a id="function-function-miniquake2-game-weapons-projectiles-fire-bfg-function-fire-bfg-context-owner-start-direction-damage-speed-damageradius-src-miniquake2-game-weapons-projectiles-ml-293333481"></a>
### fire_bfg

```ml
function fire_bfg(context, owner, start, direction, damage, speed, damageRadius)
```

Performs the fire_bfg operation for the miniquake2 game weapons projectiles module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `owner` | `dynamic` | — | owner value consumed by this operation. |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `direction` | `dynamic` | — | direction value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `speed` | `dynamic` | — | speed value consumed by this operation. |
| `damageRadius` | `dynamic` | — | damageRadius value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/projectiles.ml#L571)

<a id="function-function-miniquake2-game-weapons-projectiles-fire-blaster-function-fire-blaster-context-owner-start-direction-damage-speed-effect-hyper-src-miniquake2-game-weapons-projectiles-ml-2131132813"></a>
### fire_blaster

```ml
function fire_blaster(context, owner, start, direction, damage, speed, effect, hyper)
```

Fire blaster.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `owner` | `dynamic` | — | owner value consumed by this operation. |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `direction` | `dynamic` | — | direction value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `speed` | `dynamic` | — | speed value consumed by this operation. |
| `effect` | `dynamic` | — | effect value consumed by this operation. |
| `hyper` | `dynamic` | — | hyper value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/projectiles.ml#L523)

<a id="function-function-miniquake2-game-weapons-projectiles-fire-grenade-function-fire-grenade-context-owner-start-direction-damage-speed-timer-damageradius-src-miniquake2-game-weapons-projectiles-ml-1233306962"></a>
### fire_grenade

```ml
function fire_grenade(context, owner, start, direction, damage, speed, timer, damageRadius)
```

Fire grenade.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `owner` | `dynamic` | — | owner value consumed by this operation. |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `direction` | `dynamic` | — | direction value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `speed` | `dynamic` | — | speed value consumed by this operation. |
| `timer` | `dynamic` | — | timer value consumed by this operation. |
| `damageRadius` | `dynamic` | — | damageRadius value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/projectiles.ml#L535)

<a id="function-function-miniquake2-game-weapons-projectiles-fire-grenade2-function-fire-grenade2-context-owner-start-direction-damage-speed-timer-damageradius-held-src-miniquake2-game-weapons-projectiles-ml-1332827543"></a>
### fire_grenade2

```ml
function fire_grenade2(context, owner, start, direction, damage, speed, timer, damageRadius, held)
```

Fire grenade 2.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `owner` | `dynamic` | — | owner value consumed by this operation. |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `direction` | `dynamic` | — | direction value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `speed` | `dynamic` | — | speed value consumed by this operation. |
| `timer` | `dynamic` | — | timer value consumed by this operation. |
| `damageRadius` | `dynamic` | — | damageRadius value consumed by this operation. |
| `held` | `dynamic` | — | held value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/projectiles.ml#L548)

<a id="function-function-miniquake2-game-weapons-projectiles-fire-rocket-function-fire-rocket-context-owner-start-direction-damage-speed-damageradius-radiusdamage-src-miniquake2-game-weapons-projectiles-ml-1188758152"></a>
### fire_rocket

```ml
function fire_rocket(context, owner, start, direction, damage, speed, damageRadius, radiusDamage)
```

Fire rocket.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `owner` | `dynamic` | — | owner value consumed by this operation. |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `direction` | `dynamic` | — | direction value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `speed` | `dynamic` | — | speed value consumed by this operation. |
| `damageRadius` | `dynamic` | — | damageRadius value consumed by this operation. |
| `radiusDamage` | `dynamic` | — | radiusDamage value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/projectiles.ml#L560)

<a id="function-function-miniquake2-game-weapons-projectiles-firebfg-function-firebfg-context-owner-start-direction-damage-speed-damageradius-src-miniquake2-game-weapons-projectiles-ml-376583391"></a>
### fireBfg

```ml
function fireBfg(context, owner, start, direction, damage, speed, damageRadius)
```

Performs the fireBfg operation for the miniquake2 game weapons projectiles module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `owner` | `dynamic` | — | owner value consumed by this operation. |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `direction` | `dynamic` | — | direction value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `speed` | `dynamic` | — | speed value consumed by this operation. |
| `damageRadius` | `dynamic` | — | damageRadius value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/projectiles.ml#L491)

<a id="function-function-miniquake2-game-weapons-projectiles-fireblaster-function-fireblaster-context-owner-start-direction-damage-speed-effect-hyper-src-miniquake2-game-weapons-projectiles-ml-799869275"></a>
### fireBlaster

```ml
function fireBlaster(context, owner, start, direction, damage, speed, effect, hyper)
```

Fire blaster.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `owner` | `dynamic` | — | owner value consumed by this operation. |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `direction` | `dynamic` | — | direction value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `speed` | `dynamic` | — | speed value consumed by this operation. |
| `effect` | `dynamic` | — | effect value consumed by this operation. |
| `hyper` | `dynamic` | — | hyper value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/projectiles.ml#L104)

<a id="function-function-miniquake2-game-weapons-projectiles-fireblasterinternal-function-fireblasterinternal-context-owner-start-direction-damage-speed-effect-hyper-targetblaster-src-miniquake2-game-weapons-projectiles-ml-200275295"></a>
### fireBlasterInternal

```ml
function fireBlasterInternal(context, owner, start, direction, damage, speed, effect, hyper, targetBlaster)
```

Fire blaster internal.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `owner` | `dynamic` | — | owner value consumed by this operation. |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `direction` | `dynamic` | — | direction value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `speed` | `dynamic` | — | speed value consumed by this operation. |
| `effect` | `dynamic` | — | effect value consumed by this operation. |
| `hyper` | `dynamic` | — | hyper value consumed by this operation. |
| `targetBlaster` | `dynamic` | — | targetBlaster value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/projectiles.ml#L63)

<a id="function-function-miniquake2-game-weapons-projectiles-firegrenade-function-firegrenade-context-owner-start-direction-damage-speed-timer-damageradius-src-miniquake2-game-weapons-projectiles-ml-436613794"></a>
### fireGrenade

```ml
function fireGrenade(context, owner, start, direction, damage, speed, timer, damageRadius)
```

Fire grenade.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `owner` | `dynamic` | — | owner value consumed by this operation. |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `direction` | `dynamic` | — | direction value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `speed` | `dynamic` | — | speed value consumed by this operation. |
| `timer` | `dynamic` | — | timer value consumed by this operation. |
| `damageRadius` | `dynamic` | — | damageRadius value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/projectiles.ml#L313)

<a id="function-function-miniquake2-game-weapons-projectiles-firegrenade2-function-firegrenade2-context-owner-start-direction-damage-speed-timer-damageradius-held-src-miniquake2-game-weapons-projectiles-ml-1287780877"></a>
### fireGrenade2

```ml
function fireGrenade2(context, owner, start, direction, damage, speed, timer, damageRadius, held)
```

Fire grenade 2.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `owner` | `dynamic` | — | owner value consumed by this operation. |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `direction` | `dynamic` | — | direction value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `speed` | `dynamic` | — | speed value consumed by this operation. |
| `timer` | `dynamic` | — | timer value consumed by this operation. |
| `damageRadius` | `dynamic` | — | damageRadius value consumed by this operation. |
| `held` | `dynamic` | — | held value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/projectiles.ml#L327)

<a id="function-function-miniquake2-game-weapons-projectiles-firerocket-function-firerocket-context-owner-start-direction-damage-speed-damageradius-radiusdamage-src-miniquake2-game-weapons-projectiles-ml-1408257070"></a>
### fireRocket

```ml
function fireRocket(context, owner, start, direction, damage, speed, damageRadius, radiusDamage)
```

Fire rocket.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `owner` | `dynamic` | — | owner value consumed by this operation. |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `direction` | `dynamic` | — | direction value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `speed` | `dynamic` | — | speed value consumed by this operation. |
| `damageRadius` | `dynamic` | — | damageRadius value consumed by this operation. |
| `radiusDamage` | `dynamic` | — | radiusDamage value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/projectiles.ml#L360)

<a id="function-function-miniquake2-game-weapons-projectiles-firetargetblaster-function-firetargetblaster-context-owner-start-direction-damage-speed-src-miniquake2-game-weapons-projectiles-ml-1123562858"></a>
### fireTargetBlaster

```ml
function fireTargetBlaster(context, owner, start, direction, damage, speed)
```

Fire target blaster.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `owner` | `dynamic` | — | owner value consumed by this operation. |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `direction` | `dynamic` | — | direction value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `speed` | `dynamic` | — | speed value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/projectiles.ml#L116)

<a id="function-function-miniquake2-game-weapons-projectiles-grenadeexplode-function-grenadeexplode-projectile-context-src-miniquake2-game-weapons-projectiles-ml-717815205"></a>
### grenadeExplode

```ml
function grenadeExplode(projectile, context)
```

Return the grenade explode value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `projectile` | `dynamic` | — | projectile value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/projectiles.ml#L197)

<a id="function-function-miniquake2-game-weapons-projectiles-grenadetouch-function-grenadetouch-projectile-other-trace-context-src-miniquake2-game-weapons-projectiles-ml-1147898044"></a>
### grenadeTouch

```ml
function grenadeTouch(projectile, other, trace, context)
```

Handle grenade.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `projectile` | `dynamic` | — | projectile value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `trace` | `dynamic` | — | trace value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/projectiles.ml#L230)

<a id="function-function-miniquake2-game-weapons-projectiles-grenadevelocity-function-grenadevelocity-context-direction-speed-src-miniquake2-game-weapons-projectiles-ml-460876746"></a>
### grenadeVelocity

```ml
function grenadeVelocity(context, direction, speed)
```

Return the grenade velocity value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `direction` | `dynamic` | — | direction value consumed by this operation. |
| `speed` | `dynamic` | — | speed value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/projectiles.ml#L249)

<a id="function-function-miniquake2-game-weapons-projectiles-ownerimpactnoise-function-ownerimpactnoise-projectile-context-src-miniquake2-game-weapons-projectiles-ml-819197093"></a>
### ownerImpactNoise

```ml
function ownerImpactNoise(projectile, context)
```

Return the owner impact noise value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `projectile` | `dynamic` | — | projectile value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/projectiles.ml#L22)

<a id="function-function-miniquake2-game-weapons-projectiles-rockettouch-function-rockettouch-projectile-other-trace-context-src-miniquake2-game-weapons-projectiles-ml-743717082"></a>
### rocketTouch

```ml
function rocketTouch(projectile, other, trace, context)
```

Handle rocket.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `projectile` | `dynamic` | — | projectile value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `trace` | `dynamic` | — | trace value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/projectiles.ml#L336)
