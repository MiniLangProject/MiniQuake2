# `src/miniquake2/game/gameplay/weapons.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 game gameplay weapons facilities for this project.

Package: [`miniquake2.game.gameplay.weapons`](Package-miniquake2-game-gameplay-weapons-1771256102.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/game/constants.ml` as `gconstants` → [src/miniquake2/game/constants.ml](File-src-miniquake2-game-constants-ml-1723282332.md)
- `miniquake2/game/gameplay/constants.ml` as `gpconstants` → [src/miniquake2/game/gameplay/constants.ml](File-src-miniquake2-game-gameplay-constants-ml-1803115501.md)
- `miniquake2/game/gameplay/types.ml` as `gptypes` → [src/miniquake2/game/gameplay/types.ml](File-src-miniquake2-game-gameplay-types-ml-2088064005.md)
- `miniquake2/qcommon/text.ml` as `qtext` → [src/miniquake2/qcommon/text.ml](File-src-miniquake2-qcommon-text-ml-1570504148.md)

## Declarations

<a id="function-function-miniquake2-game-gameplay-weapons-ammoavailable-function-ammoavailable-player-item-registry-src-miniquake2-game-gameplay-weapons-ml-27162016"></a>
### ammoAvailable

```ml
function ammoAvailable(player, item, registry)
```

Report whether ammo available.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `item` | `dynamic` | — | item value consumed by this operation. |
| `registry` | `dynamic` | — | registry value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/weapons.ml#L39)

<a id="function-function-miniquake2-game-gameplay-weapons-changeweapon-function-changeweapon-player-registry-src-miniquake2-game-gameplay-weapons-ml-2082676155"></a>
### ChangeWeapon

```ml
function ChangeWeapon(player, registry)
```

Return the change weapon value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `registry` | `dynamic` | — | registry value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/weapons.ml#L57)

<a id="function-function-miniquake2-game-gameplay-weapons-findbypickupname-function-findbypickupname-registry-pickupname-src-miniquake2-game-gameplay-weapons-ml-373028881"></a>
### findByPickupName

```ml
function findByPickupName(registry, pickupName)
```

Finds by pickup name used by the miniquake2 game gameplay weapons module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `registry` | `dynamic` | — | registry value consumed by this operation. |
| `pickupName` | `dynamic` | — | pickupName value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/weapons.ml#L18)

<a id="function-function-miniquake2-game-gameplay-weapons-firebfg-function-firebfg-player-registry-src-miniquake2-game-gameplay-weapons-ml-1116926665"></a>
### FireBfg

```ml
function FireBfg(player, registry)
```

Performs the FireBfg operation for the miniquake2 game gameplay weapons module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `registry` | `dynamic` | — | registry value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/weapons.ml#L241)

<a id="function-function-miniquake2-game-gameplay-weapons-firecurrentweapon-function-firecurrentweapon-player-registry-src-miniquake2-game-gameplay-weapons-ml-1306667797"></a>
### FireCurrentWeapon

```ml
function FireCurrentWeapon(player, registry)
```

Basic fire callback used until weapon-specific projectile/hitscan code lands. It preserves the important contract: weapon callbacks own fire-frame advance.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `registry` | `dynamic` | — | registry value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/weapons.ml#L123)

<a id="function-function-miniquake2-game-gameplay-weapons-hasframe-function-hasframe-frames-value-src-miniquake2-game-gameplay-weapons-ml-662861000"></a>
### hasFrame

```ml
function hasFrame(frames, value)
```

Report whether has frame.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `frames` | `dynamic` | — | frames value consumed by this operation. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/weapons.ml#L112)

<a id="function-function-miniquake2-game-gameplay-weapons-mirrorgunframe-function-mirrorgunframe-player-src-miniquake2-game-gameplay-weapons-ml-1898776302"></a>
### mirrorGunFrame

```ml
function mirrorGunFrame(player)
```

Return the mirror gun frame value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/weapons.ml#L49)

<a id="function-function-miniquake2-game-gameplay-weapons-noammoweaponchange-function-noammoweaponchange-player-registry-src-miniquake2-game-gameplay-weapons-ml-640323955"></a>
### NoAmmoWeaponChange

```ml
function NoAmmoWeaponChange(player, registry)
```

Report whether no ammo weapon change.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `registry` | `dynamic` | — | registry value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/weapons.ml#L88)

<a id="function-function-miniquake2-game-gameplay-weapons-owned-function-owned-player-item-src-miniquake2-game-gameplay-weapons-ml-23805961"></a>
### owned

```ml
function owned(player, item)
```

Return the owned value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `item` | `dynamic` | — | item value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/weapons.ml#L31)

<a id="function-function-miniquake2-game-gameplay-weapons-think-bfg-function-think-bfg-player-item-registry-pauseroll-src-miniquake2-game-gameplay-weapons-ml-292585623"></a>
### Think_Bfg

```ml
function Think_Bfg(player, item, registry, pauseRoll)
```

Run bfg.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `item` | `dynamic` | — | item value consumed by this operation. |
| `registry` | `dynamic` | — | registry value consumed by this operation. |
| `pauseRoll` | `dynamic` | — | pauseRoll value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/weapons.ml#L256)

<a id="function-function-miniquake2-game-gameplay-weapons-think-currentweapon-function-think-currentweapon-player-item-registry-pauseroll-src-miniquake2-game-gameplay-weapons-ml-1216997287"></a>
### Think_CurrentWeapon

```ml
function Think_CurrentWeapon(player, item, registry, pauseRoll)
```

Run current weapon.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `item` | `dynamic` | — | item value consumed by this operation. |
| `registry` | `dynamic` | — | registry value consumed by this operation. |
| `pauseRoll` | `dynamic` | — | pauseRoll value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/weapons.ml#L232)

<a id="function-function-miniquake2-game-gameplay-weapons-weapon-generic-function-weapon-generic-player-frames-registry-firecallback-pauseroll-src-miniquake2-game-gameplay-weapons-ml-1313418629"></a>
### Weapon_Generic

```ml
function Weapon_Generic(player, frames, registry, fireCallback, pauseRoll)
```

Return the weapon generic value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `frames` | `dynamic` | — | frames value consumed by this operation. |
| `registry` | `dynamic` | — | registry value consumed by this operation. |
| `fireCallback` | `dynamic` | — | fireCallback value consumed by this operation. |
| `pauseRoll` | `dynamic` | — | pauseRoll value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/weapons.ml#L142)
