# `src/miniquake2/game/ai/combat_profiles.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 game ai combat profiles facilities for this project.

Package: [`miniquake2.game.ai.combat_profiles`](Package-miniquake2-game-ai-combat-profiles-1313827234.md)

Reachable from entry: **yes**

## Declarations

<a id="function-function-miniquake2-game-ai-combat-profiles-combatprofile-function-combatprofile-classname-attackkind-damage-knockback-speed-splashradius-maximumrange-cooldown-count-muzzleflash-src-miniquake2-game-ai-combat-profiles-ml-156130328"></a>
### combatProfile

```ml
function combatProfile(className, attackKind, damage, knockback, speed, splashRadius, maximumRange, cooldown, count, muzzleFlash)
```

Return the combat profile value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `className` | `dynamic` | — | className value consumed by this operation. |
| `attackKind` | `dynamic` | — | attackKind value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `knockback` | `dynamic` | — | knockback value consumed by this operation. |
| `speed` | `dynamic` | — | speed value consumed by this operation. |
| `splashRadius` | `dynamic` | — | splashRadius value consumed by this operation. |
| `maximumRange` | `dynamic` | — | maximumRange value consumed by this operation. |
| `cooldown` | `dynamic` | — | cooldown value consumed by this operation. |
| `count` | `dynamic` | — | Number of items or units to process. |
| `muzzleFlash` | `dynamic` | — | muzzleFlash value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/combat_profiles.ml#L45)

<a id="function-function-miniquake2-game-ai-combat-profiles-findprofile-function-findprofile-profiles-classname-src-miniquake2-game-ai-combat-profiles-ml-8190274"></a>
### findProfile

```ml
function findProfile(profiles, className)
```

Find profile.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `profiles` | `dynamic` | — | profiles value consumed by this operation. |
| `className` | `dynamic` | — | className value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/combat_profiles.ml#L81)

- [miniquake2.game.ai.combat_profiles.MonsterCombatProfile](Type-miniquake2-game-ai-combat-profiles-monstercombatprofile-1244980811.md) — struct
<a id="function-function-miniquake2-game-ai-combat-profiles-stockprofile-function-stockprofile-classname-src-miniquake2-game-ai-combat-profiles-ml-329681924"></a>
### stockProfile

```ml
function stockProfile(className)
```

Return the stock profile value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `className` | `dynamic` | — | className value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/combat_profiles.ml#L90)

<a id="function-function-miniquake2-game-ai-combat-profiles-stockprofiles-function-stockprofiles-src-miniquake2-game-ai-combat-profiles-ml-29026245"></a>
### stockProfiles

```ml
function stockProfiles()
```

Return the stock profiles value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/combat_profiles.ml#L51)

<a id="function-function-miniquake2-game-ai-combat-profiles-validateprofiles-function-validateprofiles-profiles-src-miniquake2-game-ai-combat-profiles-ml-1261079935"></a>
### validateProfiles

```ml
function validateProfiles(profiles)
```

Validate profiles.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `profiles` | `dynamic` | — | profiles value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/combat_profiles.ml#L103)
