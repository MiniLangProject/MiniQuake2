# `src/miniquake2/runtime/demo_session.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 runtime demo session facilities for this project.

Package: [`miniquake2.runtime.demo_session`](Package-miniquake2-runtime-demo-session-1189421589.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/client/demo.ml` as `demortdemo` → [src/miniquake2/client/demo.ml](File-src-miniquake2-client-demo-ml-1496242839.md)
- `miniquake2/client/effects/state.ml` as `demorteffects` → [src/miniquake2/client/effects/state.ml](File-src-miniquake2-client-effects-state-ml-140719308.md)
- `miniquake2/client/runtime/dispatcher.ml` as `demortdispatcher` → [src/miniquake2/client/runtime/dispatcher.ml](File-src-miniquake2-client-runtime-dispatcher-ml-506346494.md)
- `miniquake2/client/runtime/handoff.ml` as `demorthandoff` → [src/miniquake2/client/runtime/handoff.ml](File-src-miniquake2-client-runtime-handoff-ml-1879961007.md)
- `miniquake2/client/state.ml` as `demortstate` → [src/miniquake2/client/state.ml](File-src-miniquake2-client-state-ml-1458406995.md)
- `miniquake2/network/client.ml` as `demortclient` → [src/miniquake2/network/client.ml](File-src-miniquake2-network-client-ml-1115555876.md)
- `miniquake2/network/constants.ml` as `demortnc` → [src/miniquake2/network/constants.ml](File-src-miniquake2-network-constants-ml-102415622.md)
- `miniquake2/network/runtime/types.ml` as `demortnetworktypes` → [src/miniquake2/network/runtime/types.ml](File-src-miniquake2-network-runtime-types-ml-1235773127.md)
- `miniquake2/qcommon/constants.ml` as `demortqc` → [src/miniquake2/qcommon/constants.ml](File-src-miniquake2-qcommon-constants-ml-1976195726.md)

## Declarations

<a id="function-function-miniquake2-runtime-demo-session-create-function-create-data-randomseed-src-miniquake2-runtime-demo-session-ml-1316764134"></a>
### create

```ml
function create(data, randomSeed)
```

Creates create for the miniquake2 runtime demo session module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `randomSeed` | `dynamic` | — | randomSeed value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/demo_session.ml#L49)

- [miniquake2.runtime.demo_session.DemoSession](Type-miniquake2-runtime-demo-session-demosession-332003206.md) — struct
- [miniquake2.runtime.demo_session.DemoStep](Type-miniquake2-runtime-demo-session-demostep-112938112.md) — struct
<a id="function-function-miniquake2-runtime-demo-session-levelname-function-levelname-session-src-miniquake2-runtime-demo-session-ml-320027104"></a>
### levelName

```ml
function levelName(session)
```

Return the level name.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/demo_session.ml#L112)

<a id="function-function-miniquake2-runtime-demo-session-mapmodelpath-function-mapmodelpath-session-src-miniquake2-runtime-demo-session-ml-1414672618"></a>
### mapModelPath

```ml
function mapModelPath(session)
```

Map model path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/demo_session.ml#L99)

<a id="function-function-miniquake2-runtime-demo-session-release-function-release-session-src-miniquake2-runtime-demo-session-ml-1924133992"></a>
### release

```ml
function release(session)
```

Release state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/demo_session.ml#L121)

<a id="function-function-miniquake2-runtime-demo-session-step-function-step-session-now-src-miniquake2-runtime-demo-session-ml-761604952"></a>
### step

```ml
function step(session, now)
```

DM2 records contain setup/config packets between rendered snapshots. Consume exactly as many packets as necessary to publish one new atomic frame.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/demo_session.ml#L69)
