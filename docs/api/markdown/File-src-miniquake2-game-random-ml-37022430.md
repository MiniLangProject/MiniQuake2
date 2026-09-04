# `src/miniquake2/game/random.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 game random facilities for this project.

Package: [`miniquake2.game.random`](Package-miniquake2-game-random-874914198.md)

Reachable from entry: **yes**

## Declarations

<a id="function-function-miniquake2-game-random-create-function-create-seed-src-miniquake2-game-random-ml-1866514201"></a>
### create

```ml
function create(seed)
```

Creates create for the miniquake2 game random module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `seed` | `dynamic` | — | seed value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/random.ml#L18)

<a id="function-function-miniquake2-game-random-nextinteger-function-nextinteger-state-src-miniquake2-game-random-ml-2141534907"></a>
### nextInteger

```ml
function nextInteger(state)
```

Return the next integer value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/random.ml#L25)

- [miniquake2.game.random.RandomState](Type-miniquake2-game-random-randomstate-385099632.md) — struct
<a id="function-function-miniquake2-game-random-signed-function-signed-state-src-miniquake2-game-random-ml-897709193"></a>
### signed

```ml
function signed(state)
```

Return the signed value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/random.ml#L44)

<a id="function-function-miniquake2-game-random-unit-function-unit-state-src-miniquake2-game-random-ml-527257793"></a>
### unit

```ml
function unit(state)
```

Return the unit value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/random.ml#L38)
