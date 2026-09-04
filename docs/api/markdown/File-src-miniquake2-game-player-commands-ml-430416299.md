# `src/miniquake2/game/player/commands.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 game player commands facilities for this project.

Package: [`miniquake2.game.player.commands`](Package-miniquake2-game-player-commands-1001289476.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/game/constants.ml` as `gpcgameconstants` → [src/miniquake2/game/constants.ml](File-src-miniquake2-game-constants-ml-1723282332.md)
- `miniquake2/game/gameplay/constants.ml` as `gpcconstants` → [src/miniquake2/game/gameplay/constants.ml](File-src-miniquake2-game-gameplay-constants-ml-1803115501.md)
- `miniquake2/game/gameplay/item_rules.ml` as `gpcitems` → [src/miniquake2/game/gameplay/item_rules.ml](File-src-miniquake2-game-gameplay-item-rules-ml-1747940557.md)
- `miniquake2/game/gameplay/powerups.ml` as `gpcpowerups` → [src/miniquake2/game/gameplay/powerups.ml](File-src-miniquake2-game-gameplay-powerups-ml-831759227.md)
- `miniquake2/game/gameplay/types.ml` as `gpctypes` → [src/miniquake2/game/gameplay/types.ml](File-src-miniquake2-game-gameplay-types-ml-2088064005.md)
- `miniquake2/game/player/constants.ml` as `gpcplayerconstants` → [src/miniquake2/game/player/constants.ml](File-src-miniquake2-game-player-constants-ml-946982646.md)
- `miniquake2/game/player/rules.ml` as `gpcplayerrules` → [src/miniquake2/game/player/rules.ml](File-src-miniquake2-game-player-rules-ml-492402760.md)

## Declarations

<a id="function-function-miniquake2-game-player-commands-cycleweapon-function-cycleweapon-player-registry-step-src-miniquake2-game-player-commands-ml-406323469"></a>
### cycleWeapon

```ml
function cycleWeapon(player, registry, step)
```

g_cmds.c intentionally traverses the item table in opposite directions for WeapPrev and WeapNext.  Keep that externally visible order, while stopping at the first owned weapon whose ammo policy accepts the selection.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `registry` | `dynamic` | — | registry value consumed by this operation. |
| `step` | `dynamic` | — | step value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/commands.ml#L330)

<a id="function-function-miniquake2-game-player-commands-dropdefinition-function-dropdefinition-player-context-item-worldentitynumber-src-miniquake2-game-player-commands-ml-498517514"></a>
### dropDefinition

```ml
function dropDefinition(player, context, item, worldEntityNumber)
```

Cmd_Drop_f/Cmd_InvDrop_f share this dispatch after their command-specific diagnostics.  Grenades are both IT_AMMO and IT_WEAPON, so ammo must win the arity decision exactly as its gitem_t drop pointer does in stock BaseQ2.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `item` | `dynamic` | — | item value consumed by this operation. |
| `worldEntityNumber` | `dynamic` | — | worldEntityNumber value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/commands.ml#L167)

<a id="function-function-miniquake2-game-player-commands-dropitem-function-dropitem-player-context-pickupname-worldentitynumber-src-miniquake2-game-player-commands-ml-593302822"></a>
### dropItem

```ml
function dropItem(player, context, pickupName, worldEntityNumber)
```

Drop item.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `pickupName` | `dynamic` | — | pickupName value consumed by this operation. |
| `worldEntityNumber` | `dynamic` | — | worldEntityNumber value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/commands.ml#L210)

<a id="function-function-miniquake2-game-player-commands-dropselecteditem-function-dropselecteditem-player-context-worldentitynumber-src-miniquake2-game-player-commands-ml-1192334235"></a>
### dropSelectedItem

```ml
function dropSelectedItem(player, context, worldEntityNumber)
```

Drop selected item.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `worldEntityNumber` | `dynamic` | — | worldEntityNumber value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/commands.ml#L220)

<a id="function-function-miniquake2-game-player-commands-killplayer-function-killplayer-player-context-src-miniquake2-game-player-commands-ml-556955281"></a>
### killPlayer

```ml
function killPlayer(player, context)
```

Kill player.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/commands.ml#L280)

<a id="function-function-miniquake2-game-player-commands-ownedweapon-function-ownedweapon-player-item-src-miniquake2-game-player-commands-ml-202208873"></a>
### ownedWeapon

```ml
function ownedWeapon(player, item)
```

Return the owned weapon value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `item` | `dynamic` | — | item value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/commands.ml#L21)

<a id="function-function-miniquake2-game-player-commands-putaway-function-putaway-player-src-miniquake2-game-player-commands-ml-1415793190"></a>
### putAway

```ml
function putAway(player)
```

Write away.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/commands.ml#L270)

<a id="function-function-miniquake2-game-player-commands-selectitem-function-selectitem-player-registry-step-itemflags-src-miniquake2-game-player-commands-ml-42927979"></a>
### selectItem

```ml
function selectItem(player, registry, step, itemFlags)
```

g_cmds.c SelectNextItem/SelectPrevItem/ValidateSelectedItem.  The managed inventory and persistent selected-item fields are kept together because the HUD consumes the former while save/respawn state retains the latter.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `registry` | `dynamic` | — | registry value consumed by this operation. |
| `step` | `dynamic` | — | step value consumed by this operation. |
| `itemFlags` | `dynamic` | — | itemFlags value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/commands.ml#L46)

<a id="function-function-miniquake2-game-player-commands-selectnextitem-function-selectnextitem-player-registry-itemflags-src-miniquake2-game-player-commands-ml-880256117"></a>
### selectNextItem

```ml
function selectNextItem(player, registry, itemFlags)
```

Select next item.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `registry` | `dynamic` | — | registry value consumed by this operation. |
| `itemFlags` | `dynamic` | — | itemFlags value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/commands.ml#L85)

<a id="function-function-miniquake2-game-player-commands-selectpreviousitem-function-selectpreviousitem-player-registry-itemflags-src-miniquake2-game-player-commands-ml-1055455965"></a>
### selectPreviousItem

```ml
function selectPreviousItem(player, registry, itemFlags)
```

Select previous item.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `registry` | `dynamic` | — | registry value consumed by this operation. |
| `itemFlags` | `dynamic` | — | itemFlags value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/commands.ml#L93)

<a id="function-function-miniquake2-game-player-commands-togglehelp-function-togglehelp-player-context-src-miniquake2-game-player-commands-ml-1633325601"></a>
### toggleHelp

```ml
function toggleHelp(player, context)
```

Toggle help.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/commands.ml#L252)

<a id="function-function-miniquake2-game-player-commands-toggleinventory-function-toggleinventory-player-src-miniquake2-game-player-commands-ml-293857708"></a>
### toggleInventory

```ml
function toggleInventory(player)
```

Toggle inventory.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/commands.ml#L231)

<a id="function-function-miniquake2-game-player-commands-togglescore-function-togglescore-player-context-src-miniquake2-game-player-commands-ml-131823105"></a>
### toggleScore

```ml
function toggleScore(player, context)
```

Toggle score.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/commands.ml#L241)

<a id="function-function-miniquake2-game-player-commands-useitem-function-useitem-player-context-pickupname-src-miniquake2-game-player-commands-ml-1562889030"></a>
### useItem

```ml
function useItem(player, context, pickupName)
```

Cmd_Use_f is not weapon-only. Power armor and carried powerups use the existing g_items.c adapters and synchronize their public PlayerData fields.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `pickupName` | `dynamic` | — | pickupName value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/commands.ml#L112)

<a id="function-function-miniquake2-game-player-commands-useselecteditem-function-useselecteditem-player-context-src-miniquake2-game-player-commands-ml-1562828055"></a>
### useSelectedItem

```ml
function useSelectedItem(player, context)
```

Use selected item.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/commands.ml#L152)

<a id="function-function-miniquake2-game-player-commands-useweapon-function-useweapon-player-registry-pickupname-src-miniquake2-game-player-commands-ml-302549486"></a>
### useWeapon

```ml
function useWeapon(player, registry, pickupName)
```

Use weapon.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `registry` | `dynamic` | — | registry value consumed by this operation. |
| `pickupName` | `dynamic` | — | pickupName value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/commands.ml#L32)

<a id="function-function-miniquake2-game-player-commands-validateselecteditem-function-validateselecteditem-player-registry-src-miniquake2-game-player-commands-ml-1460351411"></a>
### validateSelectedItem

```ml
function validateSelectedItem(player, registry)
```

Validate selected item.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `registry` | `dynamic` | — | registry value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/commands.ml#L100)

<a id="function-function-miniquake2-game-player-commands-wave-function-wave-player-choice-src-miniquake2-game-player-commands-ml-230415423"></a>
### wave

```ml
function wave(player, choice)
```

Return the wave value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `choice` | `dynamic` | — | choice value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/commands.ml#L294)

<a id="function-function-miniquake2-game-player-commands-weaponlast-function-weaponlast-player-registry-src-miniquake2-game-player-commands-ml-1908807247"></a>
### weaponLast

```ml
function weaponLast(player, registry)
```

Return the weapon last value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `registry` | `dynamic` | — | registry value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/commands.ml#L371)

<a id="function-function-miniquake2-game-player-commands-weaponnext-function-weaponnext-player-registry-src-miniquake2-game-player-commands-ml-59011291"></a>
### weaponNext

```ml
function weaponNext(player, registry)
```

Return the weapon next value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `registry` | `dynamic` | — | registry value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/commands.ml#L364)

<a id="function-function-miniquake2-game-player-commands-weaponprevious-function-weaponprevious-player-registry-src-miniquake2-game-player-commands-ml-1744625787"></a>
### weaponPrevious

```ml
function weaponPrevious(player, registry)
```

Return the weapon previous value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `registry` | `dynamic` | — | registry value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/commands.ml#L357)
