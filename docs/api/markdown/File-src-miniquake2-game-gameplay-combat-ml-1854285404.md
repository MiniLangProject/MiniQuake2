# `src/miniquake2/game/gameplay/combat.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 game gameplay combat facilities for this project.

Package: [`miniquake2.game.gameplay.combat`](Package-miniquake2-game-gameplay-combat-263020849.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/game/gameplay/constants.ml` as `gpconstants` → [src/miniquake2/game/gameplay/constants.ml](File-src-miniquake2-game-gameplay-constants-ml-1803115501.md)
- `miniquake2/game/gameplay/types.ml` as `gptypes` → [src/miniquake2/game/gameplay/types.ml](File-src-miniquake2-game-gameplay-types-ml-2088064005.md)
- `miniquake2/qcommon/byteio.ml` as `qbyteio` → [src/miniquake2/qcommon/byteio.ml](File-src-miniquake2-qcommon-byteio-ml-159119335.md)
- `std/math.ml` as `gpmath` → `../MiniLangCompilerML/std/math.ml` — external dependency

## Declarations

<a id="function-function-miniquake2-game-gameplay-combat-applyknockback-function-applyknockback-target-direction-knockback-selfdamage-src-miniquake2-game-gameplay-combat-ml-1897357977"></a>
### applyKnockback

```ml
function applyKnockback(target, direction, knockback, selfDamage)
```

Apply knockback.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `target` | `dynamic` | — | target value consumed by this operation. |
| `direction` | `dynamic` | — | direction value consumed by this operation. |
| `knockback` | `dynamic` | — | knockback value consumed by this operation. |
| `selfDamage` | `dynamic` | — | selfDamage value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/combat.ml#L59)

<a id="function-function-miniquake2-game-gameplay-combat-armorsave-function-armorsave-target-damage-damageflags-src-miniquake2-game-gameplay-combat-ml-1342035881"></a>
### armorSave

```ml
function armorSave(target, damage, damageFlags)
```

Save armor.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `target` | `dynamic` | — | target value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `damageFlags` | `dynamic` | — | damageFlags value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/combat.ml#L44)

<a id="function-function-miniquake2-game-gameplay-combat-distance-function-distance-first-second-src-miniquake2-game-gameplay-combat-ml-14541875"></a>
### distance

```ml
function distance(first, second)
```

Return the distance value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `dynamic` | — | first value consumed by this operation. |
| `second` | `dynamic` | — | second value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/combat.ml#L125)

<a id="function-function-miniquake2-game-gameplay-combat-normalized-function-normalized-value-src-miniquake2-game-gameplay-combat-ml-1135999416"></a>
### normalized

```ml
function normalized(value)
```

Performs the normalized operation for the miniquake2 game gameplay combat module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/combat.ml#L33)

<a id="function-function-miniquake2-game-gameplay-combat-t-damage-function-t-damage-target-request-src-miniquake2-game-gameplay-combat-ml-1161348851"></a>
### T_Damage

```ml
function T_Damage(target, request)
```

Return the t damage value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `target` | `dynamic` | — | target value consumed by this operation. |
| `request` | `dynamic` | — | request value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/combat.ml#L76)

<a id="function-function-miniquake2-game-gameplay-combat-t-radiusdamage-function-t-radiusdamage-targets-inflictororigin-attackernumber-basedamage-radius-ignorenumber-candamagecallback-meansofdeath-src-miniquake2-game-gameplay-combat-ml-746773577"></a>
### T_RadiusDamage

```ml
function T_RadiusDamage(targets, inflictorOrigin, attackerNumber, baseDamage, radius, ignoreNumber, canDamageCallback, meansOfDeath)
```

Visibility/CanDamage is intentionally supplied as a callback so this layer stays independent of a concrete collision world while retaining game logic.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `targets` | `dynamic` | — | targets value consumed by this operation. |
| `inflictorOrigin` | `dynamic` | — | inflictorOrigin value consumed by this operation. |
| `attackerNumber` | `dynamic` | — | attackerNumber value consumed by this operation. |
| `baseDamage` | `dynamic` | — | baseDamage value consumed by this operation. |
| `radius` | `dynamic` | — | radius value consumed by this operation. |
| `ignoreNumber` | `dynamic` | — | ignoreNumber value consumed by this operation. |
| `canDamageCallback` | `dynamic` | — | canDamageCallback value consumed by this operation. |
| `meansOfDeath` | `dynamic` | — | meansOfDeath value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/combat.ml#L142)

<a id="function-function-miniquake2-game-gameplay-combat-validatevector-function-validatevector-value-name-src-miniquake2-game-gameplay-combat-ml-273844615"></a>
### validateVector

```ml
function validateVector(value, name)
```

Validate vector.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/combat.ml#L21)
