# `src/miniquake2/game/ai/trail.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 game ai trail facilities for this project.

Package: [`miniquake2.game.ai.trail`](Package-miniquake2-game-ai-trail-72268565.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/game/ai/types.ml` as `aitrailtypes` → [src/miniquake2/game/ai/types.ml](File-src-miniquake2-game-ai-types-ml-2113011711.md)
- `std/math.ml` as `aitrailmath` → `../MiniLangCompilerML/std/math.ml` — external dependency

## Declarations

<a id="function-function-miniquake2-game-ai-trail-add-function-add-trail-spot-time-src-miniquake2-game-ai-trail-ml-388429190"></a>
### Add

```ml
function Add(trail, spot, time)
```

Adds add to the state managed by the miniquake2 game ai trail module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `trail` | `dynamic` | — | trail value consumed by this operation. |
| `spot` | `dynamic` | — | spot value consumed by this operation. |
| `time` | `dynamic` | — | time value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/trail.ml#L66)

<a id="function-function-miniquake2-game-ai-trail-create-function-create-active-src-miniquake2-game-ai-trail-ml-234285823"></a>
### create

```ml
function create(active)
```

Creates create for the miniquake2 game ai trail module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `active` | `dynamic` | — | active value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/trail.ml#L31)

<a id="function-function-miniquake2-game-ai-trail-lastspot-function-lastspot-trail-src-miniquake2-game-ai-trail-ml-177606255"></a>
### LastSpot

```ml
function LastSpot(trail)
```

Return the last spot value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `trail` | `dynamic` | — | trail value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/trail.ml#L136)

<a id="function-function-miniquake2-game-ai-trail-new-function-new-trail-spot-time-src-miniquake2-game-ai-trail-ml-1322455084"></a>
### New

```ml
function New(trail, spot, time)
```

Return the new value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `trail` | `dynamic` | — | trail value consumed by this operation. |
| `spot` | `dynamic` | — | spot value consumed by this operation. |
| `time` | `dynamic` | — | time value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/trail.ml#L88)

<a id="function-function-miniquake2-game-ai-trail-pickfirst-function-pickfirst-trail-actor-visible-src-miniquake2-game-ai-trail-ml-555304774"></a>
### PickFirst

```ml
function PickFirst(trail, actor, visible)
```

Choose first.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `trail` | `dynamic` | — | trail value consumed by this operation. |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `visible` | `dynamic` | — | visible value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/trail.ml#L98)

<a id="function-function-miniquake2-game-ai-trail-picknext-function-picknext-trail-actor-src-miniquake2-game-ai-trail-ml-1253148010"></a>
### PickNext

```ml
function PickNext(trail, actor)
```

Choose next.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `trail` | `dynamic` | — | trail value consumed by this operation. |
| `actor` | `dynamic` | — | actor value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/trail.ml#L120)

- [miniquake2.game.ai.trail.PlayerTrail](Type-miniquake2-game-ai-trail-playertrail-1758101072.md) — struct
<a id="function-function-miniquake2-game-ai-trail-reset-function-reset-trail-active-src-miniquake2-game-ai-trail-ml-18534883"></a>
### Reset

```ml
function Reset(trail, active)
```

Performs the Reset operation for the miniquake2 game ai trail module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `trail` | `dynamic` | — | trail value consumed by this operation. |
| `active` | `dynamic` | — | active value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/trail.ml#L49)

<a id="constant-constant-miniquake2-game-ai-trail-trail-length-const-trail-length-8-src-miniquake2-game-ai-trail-ml-1180867424"></a>
### TRAIL_LENGTH

```ml
const TRAIL_LENGTH = 8
```

Defines the trail length constant used by the miniquake2 game ai trail module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/trail.ml#L17)
