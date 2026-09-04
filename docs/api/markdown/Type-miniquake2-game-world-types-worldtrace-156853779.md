# `miniquake2.game.world.types.WorldTrace`

[Home](README.md) · [Source file](File-src-miniquake2-game-world-types-ml-1207695045.md)

<a id="struct-struct-miniquake2-game-world-types-worldtrace-struct-worldtrace-src-miniquake2-game-world-types-ml-2133807598"></a>
## WorldTrace

```ml
struct WorldTrace
```

Narrow trace result owned by the world layer.  Keeping the engine trace behind this adapter lets target_laser retain the stock penetration rules in deterministic unit tests without coupling g_target state machines to an engine Edict or collision implementation.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/types.ml#L55)

## Members

<a id="field-field-miniquake2-game-world-types-worldtrace-endposition-endposition-src-miniquake2-game-world-types-ml-1683569237"></a>
### endPosition

```ml
endPosition
```

Stores the end position value associated with world trace.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/types.ml#L59)

<a id="field-field-miniquake2-game-world-types-worldtrace-entity-entity-src-miniquake2-game-world-types-ml-1105595291"></a>
### entity

```ml
entity
```

Stores the entity value associated with world trace.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/types.ml#L63)

<a id="field-field-miniquake2-game-world-types-worldtrace-hit-hit-src-miniquake2-game-world-types-ml-1966208637"></a>
### hit

```ml
hit
```

Stores the hit value associated with world trace.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/types.ml#L57)

<a id="field-field-miniquake2-game-world-types-worldtrace-planenormal-planenormal-src-miniquake2-game-world-types-ml-910459513"></a>
### planeNormal

```ml
planeNormal
```

Stores the plane normal value associated with world trace.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/types.ml#L61)
