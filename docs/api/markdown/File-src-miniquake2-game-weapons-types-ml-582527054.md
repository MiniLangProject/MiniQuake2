# `src/miniquake2/game/weapons/types.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 game weapons types facilities for this project.

Package: [`miniquake2.game.weapons.types`](Package-miniquake2-game-weapons-types-1318666221.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/game/gameplay/types.ml` as `gptypes` → [src/miniquake2/game/gameplay/types.ml](File-src-miniquake2-game-gameplay-types-ml-2088064005.md)
- `miniquake2/game/weapons/constants.ml` as `wbconstants` → [src/miniquake2/game/weapons/constants.ml](File-src-miniquake2-game-weapons-constants-ml-539739454.md)
- `miniquake2/qcommon/types.ml` as `qt` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)

## Declarations

<a id="function-function-miniquake2-game-weapons-types-createhandgrenadestate-function-createhandgrenadestate-owner-ammo-src-miniquake2-game-weapons-types-ml-1140830630"></a>
### createHandGrenadeState

```ml
function createHandGrenadeState(owner, ammo)
```

Create hand grenade state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `owner` | `dynamic` | — | owner value consumed by this operation. |
| `ammo` | `dynamic` | — | ammo value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/types.ml#L226)

<a id="function-function-miniquake2-game-weapons-types-createprojectile-function-createprojectile-number-classname-src-miniquake2-game-weapons-types-ml-1782620547"></a>
### createProjectile

```ml
function createProjectile(number, className)
```

Create projectile.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `number` | `dynamic` | — | number value consumed by this operation. |
| `className` | `dynamic` | — | className value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/types.ml#L212)

<a id="function-function-miniquake2-game-weapons-types-createtarget-function-createtarget-number-health-src-miniquake2-game-weapons-types-ml-1693255038"></a>
### createTarget

```ml
function createTarget(number, health)
```

Create target.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `number` | `dynamic` | — | number value consumed by this operation. |
| `health` | `dynamic` | — | health value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/types.ml#L201)

- [miniquake2.game.weapons.types.HandGrenadeState](Type-miniquake2-game-weapons-types-handgrenadestate-554343527.md) — struct
- [miniquake2.game.weapons.types.Projectile](Type-miniquake2-game-weapons-types-projectile-572563414.md) — struct
- [miniquake2.game.weapons.types.WeaponCallbacks](Type-miniquake2-game-weapons-types-weaponcallbacks-404556255.md) — struct
- [miniquake2.game.weapons.types.WeaponContext](Type-miniquake2-game-weapons-types-weaponcontext-281990124.md) — struct
- [miniquake2.game.weapons.types.WeaponEffect](Type-miniquake2-game-weapons-types-weaponeffect-172314468.md) — struct
- [miniquake2.game.weapons.types.WeaponTarget](Type-miniquake2-game-weapons-types-weapontarget-306410264.md) — struct
