# `src/miniquake2/runtime/soak.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 runtime soak facilities for this project.

Package: [`miniquake2.runtime.soak`](Package-miniquake2-runtime-soak-596164171.md)

Reachable from entry: **no**

## Imports

- `miniquake2/network/constants.ml` as `soaknc` → [src/miniquake2/network/constants.ml](File-src-miniquake2-network-constants-ml-102415622.md)
- `miniquake2/platform/system.ml` as `soaksystem` → [src/miniquake2/platform/system.ml](File-src-miniquake2-platform-system-ml-74223645.md)
- `miniquake2/qcommon/types.ml` as `soakqt` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)
- `miniquake2/runtime/media_sequence.ml` as `soakmedia` → [src/miniquake2/runtime/media_sequence.ml](File-src-miniquake2-runtime-media-sequence-ml-1280544663.md)
- `miniquake2/runtime/play_session.ml` as `soakplay` → [src/miniquake2/runtime/play_session.ml](File-src-miniquake2-runtime-play-session-ml-1798366100.md)

## Declarations

<a id="function-function-miniquake2-runtime-soak-commandforframe-function-commandforframe-frame-src-miniquake2-runtime-soak-ml-1367195569"></a>
### commandForFrame

```ml
function commandForFrame(frame)
```

Return the command for frame value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `frame` | `dynamic` | — | frame value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/soak.ml#L52)

<a id="function-function-miniquake2-runtime-soak-runcore-function-runcore-mapname-entitytext-collision-framelimit-src-miniquake2-runtime-soak-ml-1001348887"></a>
### runCore

```ml
function runCore(mapName, entityText, collision, frameLimit)
```

Run core.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `entityText` | `dynamic` | — | entityText value consumed by this operation. |
| `collision` | `dynamic` | — | collision value consumed by this operation. |
| `frameLimit` | `dynamic` | — | frameLimit value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/soak.ml#L145)

<a id="function-function-miniquake2-runtime-soak-runowned-function-runowned-session-framelimit-handlesbefore-src-miniquake2-runtime-soak-ml-1915832192"></a>
### runOwned

```ml
function runOwned(session, frameLimit, handlesBefore)
```

Run owned.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `frameLimit` | `dynamic` | — | frameLimit value consumed by this operation. |
| `handlesBefore` | `dynamic` | — | handlesBefore value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/soak.ml#L69)

<a id="function-function-miniquake2-runtime-soak-runretail-function-runretail-basedirectory-mapname-framelimit-src-miniquake2-runtime-soak-ml-56186345"></a>
### runRetail

```ml
function runRetail(baseDirectory, mapName, frameLimit)
```

Run retail.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `frameLimit` | `dynamic` | — | frameLimit value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/soak.ml#L156)

- [miniquake2.runtime.soak.SessionSoakResult](Type-miniquake2-runtime-soak-sessionsoakresult-658993982.md) — struct
