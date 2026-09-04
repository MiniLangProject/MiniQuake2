# `src/miniquake2/game/player/transition.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 game player transition facilities for this project.

Package: [`miniquake2.game.player.transition`](Package-miniquake2-game-player-transition-2052353461.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/game/gameplay/constants.ml` as `transitionconstants` → [src/miniquake2/game/gameplay/constants.ml](File-src-miniquake2-game-gameplay-constants-ml-1803115501.md)
- `miniquake2/game/gameplay/item_rules.ml` as `transitionitems` → [src/miniquake2/game/gameplay/item_rules.ml](File-src-miniquake2-game-gameplay-item-rules-ml-1747940557.md)

## Declarations

<a id="function-function-miniquake2-game-player-transition-capture-function-capture-playercontext-runtime-playerindex-src-miniquake2-game-player-transition-ml-2138535158"></a>
### capture

```ml
function capture(playerContext, runtime, playerIndex)
```

Capture state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `playerContext` | `dynamic` | — | playerContext value consumed by this operation. |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `playerIndex` | `dynamic` | — | Zero-based index of player. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/transition.ml#L103)

<a id="function-function-miniquake2-game-player-transition-checkeditem-function-checkeditem-registry-index-label-src-miniquake2-game-player-transition-ml-1382005086"></a>
### checkedItem

```ml
function checkedItem(registry, index, label)
```

Return the checked item value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `registry` | `dynamic` | — | registry value consumed by this operation. |
| `index` | `dynamic` | — | Zero-based index of the affected item. |
| `label` | `dynamic` | — | label value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/transition.ml#L90)

<a id="function-function-miniquake2-game-player-transition-copycounts-function-copycounts-counts-src-miniquake2-game-player-transition-ml-2104469143"></a>
### copyCounts

```ml
function copyCounts(counts)
```

Copy counts data.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `counts` | `dynamic` | — | counts value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/transition.ml#L69)

<a id="function-function-miniquake2-game-player-transition-itemindex-function-itemindex-item-src-miniquake2-game-player-transition-ml-1836070554"></a>
### itemIndex

```ml
function itemIndex(item)
```

Return the item index.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `item` | `dynamic` | — | item value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/transition.ml#L81)

<a id="constant-constant-miniquake2-game-player-transition-persistent-flag-mask-const-persistent-flag-mask-transitionconstants-fl-godmode-transitionconstants-fl-notarget-transitionconstants-fl-power-armor-src-miniquake2-game-player-transition-ml-476844079"></a>
### PERSISTENT_FLAG_MASK

```ml
const PERSISTENT_FLAG_MASK = transitionconstants.FL_GODMODE | transitionconstants.FL_NOTARGET | transitionconstants.FL_POWER_ARMOR
```

Defines the persistent flag mask constant used by the miniquake2 game player transition module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/transition.ml#L14)

- [miniquake2.game.player.transition.PlayerLevelHandover](Type-miniquake2-game-player-transition-playerlevelhandover-217518637.md) — struct
<a id="function-function-miniquake2-game-player-transition-restore-function-restore-playercontext-runtime-playerindex-handover-src-miniquake2-game-player-transition-ml-975661005"></a>
### restore

```ml
function restore(playerContext, runtime, playerIndex, handover)
```

Restore state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `playerContext` | `dynamic` | — | playerContext value consumed by this operation. |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `playerIndex` | `dynamic` | — | Zero-based index of player. |
| `handover` | `dynamic` | — | handover value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/transition.ml#L142)
