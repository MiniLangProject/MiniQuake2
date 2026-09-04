# `src/miniquake2/runtime/campaign_playtest.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 runtime campaign playtest facilities for this project.

Package: [`miniquake2.runtime.campaign_playtest`](Package-miniquake2-runtime-campaign-playtest-1999491062.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/game/constants.ml` as `campaignplaytestgameconstants` → [src/miniquake2/game/constants.ml](File-src-miniquake2-game-constants-ml-1723282332.md)
- `miniquake2/game/null_game.ml` as `campaignplaytestgame` → [src/miniquake2/game/null_game.ml](File-src-miniquake2-game-null-game-ml-1916269379.md)
- `miniquake2/qcommon/types.ml` as `campaignplaytestqtypes` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)
- `miniquake2/runtime/play_session.ml` as `campaignplaytestsession` → [src/miniquake2/runtime/play_session.ml](File-src-miniquake2-runtime-play-session-ml-1798366100.md)

## Declarations

<a id="function-function-miniquake2-runtime-campaign-playtest-campaignplaytestinventorytotal-function-campaignplaytestinventorytotal-player-src-miniquake2-runtime-campaign-playtest-ml-1152875939"></a>
### campaignPlaytestInventoryTotal

```ml
function campaignPlaytestInventoryTotal(player)
```

Return the campaign playtest inventory total value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/campaign_playtest.ml#L43)

<a id="function-function-miniquake2-runtime-campaign-playtest-campaignplaytestsquared-function-campaignplaytestsquared-value-src-miniquake2-runtime-campaign-playtest-ml-582661561"></a>
### campaignPlaytestSquared

```ml
function campaignPlaytestSquared(value)
```

Return the campaign playtest squared value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/campaign_playtest.ml#L53)

<a id="function-function-miniquake2-runtime-campaign-playtest-drive-function-drive-session-commandsteps-src-miniquake2-runtime-campaign-playtest-ml-553441392"></a>
### drive

```ml
function drive(session, commandSteps)
```

Return the drive value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `commandSteps` | `dynamic` | — | commandSteps value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/campaign_playtest.ml#L60)

- [miniquake2.runtime.campaign_playtest.PhysicalPlaytestReport](Type-miniquake2-runtime-campaign-playtest-physicalplaytestreport-622119969.md) — struct
