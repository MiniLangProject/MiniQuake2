# `src/miniquake2/runtime/multiplayer_campaign_session.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 runtime multiplayer campaign session facilities for this project.

Package: [`miniquake2.runtime.multiplayer_campaign_session`](Package-miniquake2-runtime-multiplayer-campaign-session-2065966813.md)

Reachable from entry: **no**

## Imports

- `miniquake2/game/integration/campaign_progression.ml` as `mpcampaignobjectives` → [src/miniquake2/game/integration/campaign_progression.ml](File-src-miniquake2-game-integration-campaign-progression-ml-462910148.md)
- `miniquake2/game/null_game.ml` as `mpcampaigngame` → [src/miniquake2/game/null_game.ml](File-src-miniquake2-game-null-game-ml-1916269379.md)
- `miniquake2/runtime/multiplayer_session.ml` as `mpcampaignsession` → [src/miniquake2/runtime/multiplayer_session.ml](File-src-miniquake2-runtime-multiplayer-session-ml-510496210.md)

## Declarations

<a id="function-function-miniquake2-runtime-multiplayer-campaign-session-advancecore-function-advancecore-session-targetmap-entitytext-collision-maximumsteps-src-miniquake2-runtime-multiplayer-campaign-session-ml-1665918390"></a>
### advanceCore

```ml
function advanceCore(session, targetMap, entityText, collision, maximumSteps)
```

Advance core.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `targetMap` | `dynamic` | — | targetMap value consumed by this operation. |
| `entityText` | `dynamic` | — | entityText value consumed by this operation. |
| `collision` | `dynamic` | — | collision value consumed by this operation. |
| `maximumSteps` | `dynamic` | — | maximumSteps value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/multiplayer_campaign_session.ml#L65)

<a id="function-function-miniquake2-runtime-multiplayer-campaign-session-advanceretail-function-advanceretail-session-basedirectory-targetmap-maximumsteps-src-miniquake2-runtime-multiplayer-campaign-session-ml-144902456"></a>
### advanceRetail

```ml
function advanceRetail(session, baseDirectory, targetMap, maximumSteps)
```

Advance retail.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `targetMap` | `dynamic` | — | targetMap value consumed by this operation. |
| `maximumSteps` | `dynamic` | — | maximumSteps value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/multiplayer_campaign_session.ml#L86)

<a id="function-function-miniquake2-runtime-multiplayer-campaign-session-complete-function-complete-session-terminaltarget-src-miniquake2-runtime-multiplayer-campaign-session-ml-1668022503"></a>
### complete

```ml
function complete(session, terminalTarget)
```

Return the complete value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `terminalTarget` | `dynamic` | — | terminalTarget value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/multiplayer_campaign_session.ml#L107)

- [miniquake2.runtime.multiplayer_campaign_session.MultiplayerCampaignAdvanceResult](Type-miniquake2-runtime-multiplayer-campaign-session-multiplayercampaignadvanceresult-320997960.md) — struct
<a id="function-function-miniquake2-runtime-multiplayer-campaign-session-prepareadvance-function-prepareadvance-session-targetmap-src-miniquake2-runtime-multiplayer-campaign-session-ml-687368461"></a>
### prepareAdvance

```ml
function prepareAdvance(session, targetMap)
```

Prepare advance.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `targetMap` | `dynamic` | — | targetMap value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/multiplayer_campaign_session.ml#L33)
