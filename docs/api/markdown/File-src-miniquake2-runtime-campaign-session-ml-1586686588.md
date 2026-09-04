# `src/miniquake2/runtime/campaign_session.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 runtime campaign session facilities for this project.

Package: [`miniquake2.runtime.campaign_session`](Package-miniquake2-runtime-campaign-session-1971990560.md)

Reachable from entry: **no**

## Imports

- `miniquake2/game/integration/campaign_progression.ml` as `campaignobjectives` → [src/miniquake2/game/integration/campaign_progression.ml](File-src-miniquake2-game-integration-campaign-progression-ml-462910148.md)
- `miniquake2/game/null_game.ml` as `campaignsessiongame` → [src/miniquake2/game/null_game.ml](File-src-miniquake2-game-null-game-ml-1916269379.md)
- `miniquake2/runtime/play_session.ml` as `campaignplay` → [src/miniquake2/runtime/play_session.ml](File-src-miniquake2-runtime-play-session-ml-1798366100.md)

## Declarations

<a id="function-function-miniquake2-runtime-campaign-session-advancecore-function-advancecore-session-targetmap-entitytext-collision-maximumsteps-src-miniquake2-runtime-campaign-session-ml-1365846010"></a>
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


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/campaign_session.ml#L92)

<a id="function-function-miniquake2-runtime-campaign-session-advanceretail-function-advanceretail-session-basedirectory-targetmap-maximumsteps-src-miniquake2-runtime-campaign-session-ml-393770388"></a>
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


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/campaign_session.ml#L107)

- [miniquake2.runtime.campaign_session.CampaignAdvanceResult](Type-miniquake2-runtime-campaign-session-campaignadvanceresult-677297043.md) — struct
<a id="function-function-miniquake2-runtime-campaign-session-campaigncommitcore-function-campaigncommitcore-session-targetmap-entitytext-collision-maximumsteps-src-miniquake2-runtime-campaign-session-ml-707770988"></a>
### campaignCommitCore

```ml
function campaignCommitCore(session, targetMap, entityText, collision, maximumSteps)
```

Commit campaign core.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `targetMap` | `dynamic` | — | targetMap value consumed by this operation. |
| `entityText` | `dynamic` | — | entityText value consumed by this operation. |
| `collision` | `dynamic` | — | collision value consumed by this operation. |
| `maximumSteps` | `dynamic` | — | maximumSteps value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/campaign_session.ml#L36)

<a id="function-function-miniquake2-runtime-campaign-session-campaigncommitretail-function-campaigncommitretail-session-basedirectory-targetmap-maximumsteps-src-miniquake2-runtime-campaign-session-ml-446678506"></a>
### campaignCommitRetail

```ml
function campaignCommitRetail(session, baseDirectory, targetMap, maximumSteps)
```

Commit campaign retail.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `targetMap` | `dynamic` | — | targetMap value consumed by this operation. |
| `maximumSteps` | `dynamic` | — | maximumSteps value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/campaign_session.ml#L53)

<a id="function-function-miniquake2-runtime-campaign-session-campaignprepareadvance-function-campaignprepareadvance-session-targetmap-src-miniquake2-runtime-campaign-session-ml-23051195"></a>
### campaignPrepareAdvance

```ml
function campaignPrepareAdvance(session, targetMap)
```

Prepare campaign advance.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `targetMap` | `dynamic` | — | targetMap value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/campaign_session.ml#L68)

<a id="function-function-miniquake2-runtime-campaign-session-complete-function-complete-session-terminaltarget-src-miniquake2-runtime-campaign-session-ml-513061111"></a>
### complete

```ml
function complete(session, terminalTarget)
```

Return the complete value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `terminalTarget` | `dynamic` | — | terminalTarget value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/campaign_session.ml#L121)
