# `src/miniquake2/game/integration/campaign_progression.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 game integration campaign progression facilities for this project.

Package: [`miniquake2.game.integration.campaign_progression`](Package-miniquake2-game-integration-campaign-progression-664816403.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/game/integration/baseq2.ml` as `campaignbaseq2` → [src/miniquake2/game/integration/baseq2.ml](File-src-miniquake2-game-integration-baseq2-ml-2026578472.md)
- `miniquake2/game/world/core.ml` as `campaignworld` → [src/miniquake2/game/world/core.ml](File-src-miniquake2-game-world-core-ml-1171136969.md)

## Declarations

<a id="function-function-miniquake2-game-integration-campaign-progression-campaignactivateworld-function-campaignactivateworld-runtime-playercontext-player-entity-src-miniquake2-game-integration-campaign-progression-ml-1133054427"></a>
### campaignActivateWorld

```ml
function campaignActivateWorld(runtime, playerContext, player, entity)
```

Activate campaign world.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `playerContext` | `dynamic` | — | playerContext value consumed by this operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/campaign_progression.ml#L97)

<a id="function-function-miniquake2-game-integration-campaign-progression-campaigndrivetarget-function-campaigndrivetarget-runtime-playercontext-player-targetname-visited-depth-src-miniquake2-game-integration-campaign-progression-ml-522012321"></a>
### campaignDriveTarget

```ml
function campaignDriveTarget(runtime, playerContext, player, targetName, visited, depth)
```

Return the campaign drive target value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `playerContext` | `dynamic` | — | playerContext value consumed by this operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `targetName` | `dynamic` | — | targetName value consumed by this operation. |
| `visited` | `dynamic` | — | visited value consumed by this operation. |
| `depth` | `dynamic` | — | depth value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/campaign_progression.ml#L157)

<a id="function-function-miniquake2-game-integration-campaign-progression-campaignkillmonster-function-campaignkillmonster-runtime-actor-src-miniquake2-game-integration-campaign-progression-ml-488465456"></a>
### campaignKillMonster

```ml
function campaignKillMonster(runtime, actor)
```

Kill campaign monster.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `actor` | `dynamic` | — | actor value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/campaign_progression.ml#L138)

<a id="function-function-miniquake2-game-integration-campaign-progression-campaignpickupkey-function-campaignpickupkey-runtime-playercontext-player-itemclassname-src-miniquake2-game-integration-campaign-progression-ml-1454351632"></a>
### campaignPickupKey

```ml
function campaignPickupKey(runtime, playerContext, player, itemClassName)
```

Pick up campaign key.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `playerContext` | `dynamic` | — | playerContext value consumed by this operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `itemClassName` | `dynamic` | — | itemClassName value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/campaign_progression.ml#L84)

<a id="function-function-miniquake2-game-integration-campaign-progression-campaignplayer-function-campaignplayer-playercontext-src-miniquake2-game-integration-campaign-progression-ml-310462869"></a>
### campaignPlayer

```ml
function campaignPlayer(playerContext)
```

Return the campaign player value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `playerContext` | `dynamic` | — | playerContext value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/campaign_progression.ml#L69)

- [miniquake2.game.integration.campaign_progression.CampaignProgressResult](Type-miniquake2-game-integration-campaign-progression-campaignprogressresult-234629355.md) — struct
<a id="function-function-miniquake2-game-integration-campaign-progression-campaignvisited-function-campaignvisited-visited-number-src-miniquake2-game-integration-campaign-progression-ml-1868656900"></a>
### campaignVisited

```ml
function campaignVisited(visited, number)
```

Return the campaign visited value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `visited` | `dynamic` | — | visited value consumed by this operation. |
| `number` | `dynamic` | — | number value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/campaign_progression.ml#L60)

<a id="function-function-miniquake2-game-integration-campaign-progression-drivetomap-function-drivetomap-runtime-playercontext-requestedmap-src-miniquake2-game-integration-campaign-progression-ml-2124396593"></a>
### driveToMap

```ml
function driveToMap(runtime, playerContext, requestedMap)
```

Map drive to.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `playerContext` | `dynamic` | — | playerContext value consumed by this operation. |
| `requestedMap` | `dynamic` | — | requestedMap value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/campaign_progression.ml#L216)

<a id="function-function-miniquake2-game-integration-campaign-progression-normalizedmapname-function-normalizedmapname-mapspec-src-miniquake2-game-integration-campaign-progression-ml-443783214"></a>
### normalizedMapName

```ml
function normalizedMapName(mapSpec)
```

Map normalized name.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mapSpec` | `dynamic` | — | mapSpec value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/campaign_progression.ml#L33)
