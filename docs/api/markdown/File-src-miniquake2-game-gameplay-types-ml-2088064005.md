# `src/miniquake2/game/gameplay/types.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 game gameplay types facilities for this project.

Package: [`miniquake2.game.gameplay.types`](Package-miniquake2-game-gameplay-types-599708522.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/game/gameplay/constants.ml` as `gpconstants` → [src/miniquake2/game/gameplay/constants.ml](File-src-miniquake2-game-gameplay-constants-ml-1803115501.md)
- `miniquake2/game/types.ml` as `gtypes` → [src/miniquake2/game/types.ml](File-src-miniquake2-game-types-ml-1384205920.md)
- `miniquake2/qcommon/types.ml` as `gpqtypes` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)

## Declarations

- [miniquake2.game.gameplay.types.Combatant](Type-miniquake2-game-gameplay-types-combatant-1346476901.md) — struct
<a id="function-function-miniquake2-game-gameplay-types-createcombatant-function-createcombatant-number-health-src-miniquake2-game-gameplay-types-ml-811180162"></a>
### createCombatant

```ml
function createCombatant(number, health)
```

Create combatant.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `number` | `dynamic` | — | number value consumed by this operation. |
| `health` | `dynamic` | — | health value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/types.ml#L427)

<a id="function-function-miniquake2-game-gameplay-types-createinventory-function-createinventory-itemslots-src-miniquake2-game-gameplay-types-ml-383410809"></a>
### createInventory

```ml
function createInventory(itemSlots)
```

Create inventory.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `itemSlots` | `dynamic` | — | itemSlots value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/types.ml#L356)

<a id="function-function-miniquake2-game-gameplay-types-createitementity-function-createitementity-number-item-src-miniquake2-game-gameplay-types-ml-364821583"></a>
### createItemEntity

```ml
function createItemEntity(number, item)
```

Create item entity.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `number` | `dynamic` | — | number value consumed by this operation. |
| `item` | `dynamic` | — | item value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/types.ml#L387)

<a id="function-function-miniquake2-game-gameplay-types-createplayer-function-createplayer-number-itemslots-src-miniquake2-game-gameplay-types-ml-382531192"></a>
### createPlayer

```ml
function createPlayer(number, itemSlots)
```

Create player.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `number` | `dynamic` | — | number value consumed by this operation. |
| `itemSlots` | `dynamic` | — | itemSlots value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/types.ml#L372)

<a id="function-function-miniquake2-game-gameplay-types-damagerequest-function-damagerequest-direction-point-damage-knockback-flags-meansofdeath-src-miniquake2-game-gameplay-types-ml-915981618"></a>
### damageRequest

```ml
function damageRequest(direction, point, damage, knockback, flags, meansOfDeath)
```

Return the damage request value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `direction` | `dynamic` | — | direction value consumed by this operation. |
| `point` | `dynamic` | — | point value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `knockback` | `dynamic` | — | knockback value consumed by this operation. |
| `flags` | `dynamic` | — | Bit flags controlling the operation. |
| `meansOfDeath` | `dynamic` | — | meansOfDeath value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/types.ml#L445)

- [miniquake2.game.gameplay.types.DamageRequest](Type-miniquake2-game-gameplay-types-damagerequest-1847866794.md) — struct
- [miniquake2.game.gameplay.types.DamageResult](Type-miniquake2-game-gameplay-types-damageresult-1001258972.md) — struct
- [miniquake2.game.gameplay.types.GameplayPlayer](Type-miniquake2-game-gameplay-types-gameplayplayer-1858077037.md) — struct
- [miniquake2.game.gameplay.types.Inventory](Type-miniquake2-game-gameplay-types-inventory-1891315256.md) — struct
<a id="function-function-miniquake2-game-gameplay-types-itemaction-function-itemaction-success-reason-amount-src-miniquake2-game-gameplay-types-ml-217529252"></a>
### itemAction

```ml
function itemAction(success, reason, amount)
```

Return the item action value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `success` | `dynamic` | — | success value consumed by this operation. |
| `reason` | `dynamic` | — | reason value consumed by this operation. |
| `amount` | `dynamic` | — | amount value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/types.ml#L420)

- [miniquake2.game.gameplay.types.ItemAction](Type-miniquake2-game-gameplay-types-itemaction-1391014993.md) — struct
- [miniquake2.game.gameplay.types.ItemDefinition](Type-miniquake2-game-gameplay-types-itemdefinition-1550671806.md) — struct
- [miniquake2.game.gameplay.types.ItemEntity](Type-miniquake2-game-gameplay-types-itementity-1233791708.md) — struct
- [miniquake2.game.gameplay.types.ItemRegistry](Type-miniquake2-game-gameplay-types-itemregistry-346558692.md) — struct
<a id="function-function-miniquake2-game-gameplay-types-itemruledata-function-itemruledata-kind-armorbase-armormax-normalprotection-energyprotection-healthcount-healthstyle-duration-src-miniquake2-game-gameplay-types-ml-926319017"></a>
### itemRuleData

```ml
function itemRuleData(kind, armorBase, armorMax, normalProtection, energyProtection, healthCount, healthStyle, duration)
```

Return the item rule data value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `kind` | `dynamic` | — | kind value consumed by this operation. |
| `armorBase` | `dynamic` | — | armorBase value consumed by this operation. |
| `armorMax` | `dynamic` | — | armorMax value consumed by this operation. |
| `normalProtection` | `dynamic` | — | normalProtection value consumed by this operation. |
| `energyProtection` | `dynamic` | — | energyProtection value consumed by this operation. |
| `healthCount` | `dynamic` | — | Number of health to process. |
| `healthStyle` | `dynamic` | — | healthStyle value consumed by this operation. |
| `duration` | `dynamic` | — | duration value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/types.ml#L412)

- [miniquake2.game.gameplay.types.ItemRuleData](Type-miniquake2-game-gameplay-types-itemruledata-1383302013.md) — struct
<a id="function-function-miniquake2-game-gameplay-types-pickupcontext-function-pickupcontext-deathmatch-cooperative-dmflags-time-src-miniquake2-game-gameplay-types-ml-1128235896"></a>
### pickupContext

```ml
function pickupContext(deathmatch, cooperative, dmFlags, time)
```

Pick up context.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `deathmatch` | `dynamic` | — | deathmatch value consumed by this operation. |
| `cooperative` | `dynamic` | — | cooperative value consumed by this operation. |
| `dmFlags` | `dynamic` | — | dmFlags value consumed by this operation. |
| `time` | `dynamic` | — | time value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/types.ml#L399)

- [miniquake2.game.gameplay.types.PickupContext](Type-miniquake2-game-gameplay-types-pickupcontext-2112555667.md) — struct
- [miniquake2.game.gameplay.types.PowerArmorResult](Type-miniquake2-game-gameplay-types-powerarmorresult-1552754557.md) — struct
- [miniquake2.game.gameplay.types.PrecacheResult](Type-miniquake2-game-gameplay-types-precacheresult-2036816980.md) — struct
- [miniquake2.game.gameplay.types.WeaponFrames](Type-miniquake2-game-gameplay-types-weaponframes-29149738.md) — struct
- [miniquake2.game.gameplay.types.WeaponStep](Type-miniquake2-game-gameplay-types-weaponstep-1528917010.md) — struct
