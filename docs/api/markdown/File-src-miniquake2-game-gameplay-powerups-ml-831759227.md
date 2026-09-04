# `src/miniquake2/game/gameplay/powerups.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 game gameplay powerups facilities for this project.

Package: [`miniquake2.game.gameplay.powerups`](Package-miniquake2-game-gameplay-powerups-1186216264.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/game/gameplay/constants.ml` as `gpconstants` → [src/miniquake2/game/gameplay/constants.ml](File-src-miniquake2-game-gameplay-constants-ml-1803115501.md)
- `miniquake2/game/gameplay/item_rules.ml` as `gprules` → [src/miniquake2/game/gameplay/item_rules.ml](File-src-miniquake2-game-gameplay-item-rules-ml-1747940557.md)
- `miniquake2/game/gameplay/types.ml` as `gptypes` → [src/miniquake2/game/gameplay/types.ml](File-src-miniquake2-game-gameplay-types-ml-2088064005.md)
- `miniquake2/qcommon/byteio.ml` as `qbyteio` → [src/miniquake2/qcommon/byteio.ml](File-src-miniquake2-qcommon-byteio-ml-159119335.md)

## Declarations

<a id="function-function-miniquake2-game-gameplay-powerups-armorbyindex-function-armorbyindex-registry-index-src-miniquake2-game-gameplay-powerups-ml-1935288572"></a>
### armorByIndex

```ml
function armorByIndex(registry, index)
```

Return the armor by index.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `registry` | `dynamic` | — | registry value consumed by this operation. |
| `index` | `dynamic` | — | Zero-based index of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/powerups.ml#L49)

<a id="function-function-miniquake2-game-gameplay-powerups-armorindex-function-armorindex-player-registry-src-miniquake2-game-gameplay-powerups-ml-813560731"></a>
### ArmorIndex

```ml
function ArmorIndex(player, registry)
```

Return the armor index.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `registry` | `dynamic` | — | registry value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/powerups.ml#L36)

<a id="function-function-miniquake2-game-gameplay-powerups-armoritem-function-armoritem-registry-tag-src-miniquake2-game-gameplay-powerups-ml-1342610344"></a>
### armorItem

```ml
function armorItem(registry, tag)
```

Return the armor item value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `registry` | `dynamic` | — | registry value consumed by this operation. |
| `tag` | `dynamic` | — | tag value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/powerups.ml#L26)

<a id="function-function-miniquake2-game-gameplay-powerups-checkpowerarmor-function-checkpowerarmor-player-registry-damage-damageflags-infront-src-miniquake2-game-gameplay-powerups-ml-1461882992"></a>
### CheckPowerArmor

```ml
function CheckPowerArmor(player, registry, damage, damageFlags, inFront)
```

Cell consumption half of g_combat.c::CheckPowerArmor. The screen-facing test is supplied by the caller because this package does not own view axes.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `registry` | `dynamic` | — | registry value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `damageFlags` | `dynamic` | — | damageFlags value consumed by this operation. |
| `inFront` | `dynamic` | — | inFront value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/powerups.ml#L126)

<a id="function-function-miniquake2-game-gameplay-powerups-consumepowerup-function-consumepowerup-player-item-src-miniquake2-game-gameplay-powerups-ml-311235743"></a>
### consumePowerup

```ml
function consumePowerup(player, item)
```

Consume powerup.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `item` | `dynamic` | — | item value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/powerups.ml#L216)

<a id="function-function-miniquake2-game-gameplay-powerups-drop-general-function-drop-general-player-item-registry-worldentitynumber-src-miniquake2-game-gameplay-powerups-ml-386734332"></a>
### Drop_General

```ml
function Drop_General(player, item, registry, worldEntityNumber)
```

Drop general.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `item` | `dynamic` | — | item value consumed by this operation. |
| `registry` | `dynamic` | — | registry value consumed by this operation. |
| `worldEntityNumber` | `dynamic` | — | worldEntityNumber value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/powerups.ml#L189)

<a id="function-function-miniquake2-game-gameplay-powerups-drop-powerarmor-function-drop-powerarmor-player-item-registry-worldentitynumber-src-miniquake2-game-gameplay-powerups-ml-1953922660"></a>
### Drop_PowerArmor

```ml
function Drop_PowerArmor(player, item, registry, worldEntityNumber)
```

Drop power armor.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `item` | `dynamic` | — | item value consumed by this operation. |
| `registry` | `dynamic` | — | registry value consumed by this operation. |
| `worldEntityNumber` | `dynamic` | — | worldEntityNumber value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/powerups.ml#L205)

<a id="function-function-miniquake2-game-gameplay-powerups-extendframe-function-extendframe-existing-current-duration-src-miniquake2-game-gameplay-powerups-ml-162589225"></a>
### extendFrame

```ml
function extendFrame(existing, current, duration)
```

Return the extend frame value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `existing` | `dynamic` | — | existing value consumed by this operation. |
| `current` | `dynamic` | — | current value consumed by this operation. |
| `duration` | `dynamic` | — | duration value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/powerups.ml#L227)

<a id="function-function-miniquake2-game-gameplay-powerups-grantammo-function-grantammo-player-registry-name-src-miniquake2-game-gameplay-powerups-ml-345896168"></a>
### grantAmmo

```ml
function grantAmmo(player, registry, name)
```

Return the grant ammo value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `registry` | `dynamic` | — | registry value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/powerups.ml#L343)

<a id="function-function-miniquake2-game-gameplay-powerups-megahealththink-function-megahealththink-itementity-context-src-miniquake2-game-gameplay-powerups-ml-97082566"></a>
### MegaHealthThink

```ml
function MegaHealthThink(itemEntity, context)
```

Run mega health.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `itemEntity` | `dynamic` | — | itemEntity value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/powerups.ml#L444)

<a id="function-function-miniquake2-game-gameplay-powerups-metadata-function-metadata-item-expectedkind-src-miniquake2-game-gameplay-powerups-ml-49217104"></a>
### metadata

```ml
function metadata(item, expectedKind)
```

Return the metadata value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `item` | `dynamic` | — | item value consumed by this operation. |
| `expectedKind` | `dynamic` | — | expectedKind value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/powerups.ml#L18)

<a id="function-function-miniquake2-game-gameplay-powerups-pickup-adrenaline-function-pickup-adrenaline-itementity-player-context-registry-src-miniquake2-game-gameplay-powerups-ml-1658152010"></a>
### Pickup_Adrenaline

```ml
function Pickup_Adrenaline(itemEntity, player, context, registry)
```

Pick up adrenaline.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `itemEntity` | `dynamic` | — | itemEntity value consumed by this operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `registry` | `dynamic` | — | registry value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/powerups.ml#L319)

<a id="function-function-miniquake2-game-gameplay-powerups-pickup-ancienthead-function-pickup-ancienthead-itementity-player-context-registry-src-miniquake2-game-gameplay-powerups-ml-1927474446"></a>
### Pickup_AncientHead

```ml
function Pickup_AncientHead(itemEntity, player, context, registry)
```

Pick up ancient head.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `itemEntity` | `dynamic` | — | itemEntity value consumed by this operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `registry` | `dynamic` | — | registry value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/powerups.ml#L332)

<a id="function-function-miniquake2-game-gameplay-powerups-pickup-armor-function-pickup-armor-itementity-player-context-registry-src-miniquake2-game-gameplay-powerups-ml-336810806"></a>
### Pickup_Armor

```ml
function Pickup_Armor(itemEntity, player, context, registry)
```

Pick up armor.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `itemEntity` | `dynamic` | — | itemEntity value consumed by this operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `registry` | `dynamic` | — | registry value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/powerups.ml#L60)

<a id="function-function-miniquake2-game-gameplay-powerups-pickup-bandolier-function-pickup-bandolier-itementity-player-context-registry-src-miniquake2-game-gameplay-powerups-ml-1227707734"></a>
### Pickup_Bandolier

```ml
function Pickup_Bandolier(itemEntity, player, context, registry)
```

Pick up bandolier.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `itemEntity` | `dynamic` | — | itemEntity value consumed by this operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `registry` | `dynamic` | — | registry value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/powerups.ml#L354)

<a id="function-function-miniquake2-game-gameplay-powerups-pickup-health-function-pickup-health-itementity-player-context-registry-src-miniquake2-game-gameplay-powerups-ml-567679364"></a>
### Pickup_Health

```ml
function Pickup_Health(itemEntity, player, context, registry)
```

Pick up health.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `itemEntity` | `dynamic` | — | itemEntity value consumed by this operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `registry` | `dynamic` | — | registry value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/powerups.ml#L416)

<a id="function-function-miniquake2-game-gameplay-powerups-pickup-key-function-pickup-key-itementity-player-context-registry-src-miniquake2-game-gameplay-powerups-ml-1153078510"></a>
### Pickup_Key

```ml
function Pickup_Key(itemEntity, player, context, registry)
```

Pick up key.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `itemEntity` | `dynamic` | — | itemEntity value consumed by this operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `registry` | `dynamic` | — | registry value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/powerups.ml#L394)

<a id="function-function-miniquake2-game-gameplay-powerups-pickup-pack-function-pickup-pack-itementity-player-context-registry-src-miniquake2-game-gameplay-powerups-ml-1776807198"></a>
### Pickup_Pack

```ml
function Pickup_Pack(itemEntity, player, context, registry)
```

Pick up pack.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `itemEntity` | `dynamic` | — | itemEntity value consumed by this operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `registry` | `dynamic` | — | registry value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/powerups.ml#L371)

<a id="function-function-miniquake2-game-gameplay-powerups-pickup-powerarmor-function-pickup-powerarmor-itementity-player-context-registry-src-miniquake2-game-gameplay-powerups-ml-556535724"></a>
### Pickup_PowerArmor

```ml
function Pickup_PowerArmor(itemEntity, player, context, registry)
```

Pick up power armor.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `itemEntity` | `dynamic` | — | itemEntity value consumed by this operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `registry` | `dynamic` | — | registry value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/powerups.ml#L171)

<a id="function-function-miniquake2-game-gameplay-powerups-pickup-powerup-function-pickup-powerup-itementity-player-context-registry-src-miniquake2-game-gameplay-powerups-ml-1555181242"></a>
### Pickup_Powerup

```ml
function Pickup_Powerup(itemEntity, player, context, registry)
```

Pick up powerup.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `itemEntity` | `dynamic` | — | itemEntity value consumed by this operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `registry` | `dynamic` | — | registry value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/powerups.ml#L294)

<a id="function-function-miniquake2-game-gameplay-powerups-pickupforplayerdata-function-pickupforplayerdata-itementity-playerdata-playercontext-src-miniquake2-game-gameplay-powerups-ml-2138845150"></a>
### PickupForPlayerData

```ml
function PickupForPlayerData(itemEntity, playerData, playerContext)
```

Pick up for player data.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `itemEntity` | `dynamic` | — | itemEntity value consumed by this operation. |
| `playerData` | `dynamic` | — | playerData value consumed by this operation. |
| `playerContext` | `dynamic` | — | playerContext value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/powerups.ml#L585)

<a id="function-function-miniquake2-game-gameplay-powerups-pickupforplayerdataatskill-function-pickupforplayerdataatskill-itementity-playerdata-playercontext-skill-src-miniquake2-game-gameplay-powerups-ml-1037726773"></a>
### PickupForPlayerDataAtSkill

```ml
function PickupForPlayerDataAtSkill(itemEntity, playerData, playerContext, skill)
```

Pick up for player data at skill.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `itemEntity` | `dynamic` | — | itemEntity value consumed by this operation. |
| `playerData` | `dynamic` | — | playerData value consumed by this operation. |
| `playerContext` | `dynamic` | — | playerContext value consumed by this operation. |
| `skill` | `dynamic` | — | skill value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/powerups.ml#L522)

<a id="function-function-miniquake2-game-gameplay-powerups-powerarmortype-function-powerarmortype-player-registry-src-miniquake2-game-gameplay-powerups-ml-1714641723"></a>
### PowerArmorType

```ml
function PowerArmorType(player, registry)
```

Return the power armor type value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `registry` | `dynamic` | — | registry value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/powerups.ml#L110)

<a id="function-function-miniquake2-game-gameplay-powerups-syncarmorfromcombatant-function-syncarmorfromcombatant-player-combatant-src-miniquake2-game-gameplay-powerups-ml-1654932075"></a>
### SyncArmorFromCombatant

```ml
function SyncArmorFromCombatant(player, combatant)
```

Synchronize armor from combatant.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `combatant` | `dynamic` | — | combatant value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/powerups.ml#L512)

<a id="function-function-miniquake2-game-gameplay-powerups-syncarmortocombatant-function-syncarmortocombatant-player-combatant-registry-src-miniquake2-game-gameplay-powerups-ml-1102894228"></a>
### SyncArmorToCombatant

```ml
function SyncArmorToCombatant(player, combatant, registry)
```

Synchronize armor to combatant.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `combatant` | `dynamic` | — | combatant value consumed by this operation. |
| `registry` | `dynamic` | — | registry value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/powerups.ml#L497)

<a id="function-function-miniquake2-game-gameplay-powerups-syncfromplayerdata-function-syncfromplayerdata-gameplayplayer-playerdata-src-miniquake2-game-gameplay-powerups-ml-487785141"></a>
### SyncFromPlayerData

```ml
function SyncFromPlayerData(gameplayPlayer, playerData)
```

Synchronize from player data.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `gameplayPlayer` | `dynamic` | — | gameplayPlayer value consumed by this operation. |
| `playerData` | `dynamic` | — | playerData value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/powerups.ml#L464)

<a id="function-function-miniquake2-game-gameplay-powerups-synctoplayerdata-function-synctoplayerdata-gameplayplayer-playerdata-src-miniquake2-game-gameplay-powerups-ml-464186705"></a>
### SyncToPlayerData

```ml
function SyncToPlayerData(gameplayPlayer, playerData)
```

Synchronize to player data.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `gameplayPlayer` | `dynamic` | — | gameplayPlayer value consumed by this operation. |
| `playerData` | `dynamic` | — | playerData value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/powerups.ml#L479)

<a id="function-function-miniquake2-game-gameplay-powerups-use-breather-function-use-breather-player-item-context-registry-src-miniquake2-game-gameplay-powerups-ml-563081879"></a>
### Use_Breather

```ml
function Use_Breather(player, item, context, registry)
```

Use breather.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `item` | `dynamic` | — | item value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `registry` | `dynamic` | — | registry value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/powerups.ml#L261)

<a id="function-function-miniquake2-game-gameplay-powerups-use-envirosuit-function-use-envirosuit-player-item-context-registry-src-miniquake2-game-gameplay-powerups-ml-1753021283"></a>
### Use_Envirosuit

```ml
function Use_Envirosuit(player, item, context, registry)
```

Use envirosuit.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `item` | `dynamic` | — | item value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `registry` | `dynamic` | — | registry value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/powerups.ml#L272)

<a id="function-function-miniquake2-game-gameplay-powerups-use-invulnerability-function-use-invulnerability-player-item-context-registry-src-miniquake2-game-gameplay-powerups-ml-1143380341"></a>
### Use_Invulnerability

```ml
function Use_Invulnerability(player, item, context, registry)
```

Use invulnerability.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `item` | `dynamic` | — | item value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `registry` | `dynamic` | — | registry value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/powerups.ml#L250)

<a id="function-function-miniquake2-game-gameplay-powerups-use-powerarmor-function-use-powerarmor-player-item-context-registry-src-miniquake2-game-gameplay-powerups-ml-1639983607"></a>
### Use_PowerArmor

```ml
function Use_PowerArmor(player, item, context, registry)
```

Use power armor.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `item` | `dynamic` | — | item value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `registry` | `dynamic` | — | registry value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/powerups.ml#L155)

<a id="function-function-miniquake2-game-gameplay-powerups-use-quad-function-use-quad-player-item-context-registry-src-miniquake2-game-gameplay-powerups-ml-1556722519"></a>
### Use_Quad

```ml
function Use_Quad(player, item, context, registry)
```

Use quad.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `item` | `dynamic` | — | item value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `registry` | `dynamic` | — | registry value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/powerups.ml#L237)

<a id="function-function-miniquake2-game-gameplay-powerups-use-silencer-function-use-silencer-player-item-context-registry-src-miniquake2-game-gameplay-powerups-ml-842393655"></a>
### Use_Silencer

```ml
function Use_Silencer(player, item, context, registry)
```

Use silencer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `item` | `dynamic` | — | item value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `registry` | `dynamic` | — | registry value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/powerups.ml#L283)
