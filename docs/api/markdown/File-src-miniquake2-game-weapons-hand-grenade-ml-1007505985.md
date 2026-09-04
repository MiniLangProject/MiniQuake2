# `src/miniquake2/game/weapons/hand_grenade.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 game weapons hand grenade facilities for this project.

Package: [`miniquake2.game.weapons.hand_grenade`](Package-miniquake2-game-weapons-hand-grenade-1679557588.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/game/weapons/constants.ml` as `wbconstants` → [src/miniquake2/game/weapons/constants.ml](File-src-miniquake2-game-weapons-constants-ml-539739454.md)
- `miniquake2/game/weapons/projectiles.ml` as `wbprojectiles` → [src/miniquake2/game/weapons/projectiles.ml](File-src-miniquake2-game-weapons-projectiles-ml-2146249801.md)
- `miniquake2/qcommon/byteio.ml` as `qbyteio` → [src/miniquake2/qcommon/byteio.ml](File-src-miniquake2-qcommon-byteio-ml-159119335.md)

## Declarations

<a id="function-function-miniquake2-game-weapons-hand-grenade-step-function-step-context-state-start-direction-damage-radius-src-miniquake2-game-weapons-hand-grenade-ml-2027633421"></a>
### step

```ml
function step(context, state, start, direction, damage, radius)
```

Performs the step operation for the miniquake2 game weapons hand grenade module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `direction` | `dynamic` | — | direction value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `radius` | `dynamic` | — | radius value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/hand_grenade.ml#L40)

<a id="function-function-miniquake2-game-weapons-hand-grenade-weapon-grenade-function-weapon-grenade-context-state-start-direction-damage-radius-src-miniquake2-game-weapons-hand-grenade-ml-777500473"></a>
### Weapon_Grenade

```ml
function Weapon_Grenade(context, state, start, direction, damage, radius)
```

Return the weapon grenade value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `direction` | `dynamic` | — | direction value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `radius` | `dynamic` | — | radius value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/hand_grenade.ml#L114)

<a id="function-function-miniquake2-game-weapons-hand-grenade-weapon-grenade-fire-function-weapon-grenade-fire-context-state-start-direction-damage-radius-held-src-miniquake2-game-weapons-hand-grenade-ml-725047848"></a>
### weapon_grenade_fire

```ml
function weapon_grenade_fire(context, state, start, direction, damage, radius, held)
```

Fire weapon grenade.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `direction` | `dynamic` | — | direction value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `radius` | `dynamic` | — | radius value consumed by this operation. |
| `held` | `dynamic` | — | held value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/hand_grenade.ml#L104)

<a id="function-function-miniquake2-game-weapons-hand-grenade-weapongrenadefire-function-weapongrenadefire-context-state-start-direction-damage-radius-held-src-miniquake2-game-weapons-hand-grenade-ml-595027624"></a>
### weaponGrenadeFire

```ml
function weaponGrenadeFire(context, state, start, direction, damage, radius, held)
```

Fire weapon grenade.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `direction` | `dynamic` | — | direction value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `radius` | `dynamic` | — | radius value consumed by this operation. |
| `held` | `dynamic` | — | held value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/hand_grenade.ml#L22)
