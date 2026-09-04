# `src/miniquake2/network/runtime/lifecycle.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 network runtime lifecycle facilities for this project.

Package: [`miniquake2.network.runtime.lifecycle`](Package-miniquake2-network-runtime-lifecycle-1763599115.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/network/constants.ml` as `nrlifecyclenc` → [src/miniquake2/network/constants.ml](File-src-miniquake2-network-constants-ml-102415622.md)
- `miniquake2/network/runtime/messages.ml` as `nrlifecyclemessages` → [src/miniquake2/network/runtime/messages.ml](File-src-miniquake2-network-runtime-messages-ml-904838874.md)
- `miniquake2/network/runtime/types.ml` as `nrlifecyclertypes` → [src/miniquake2/network/runtime/types.ml](File-src-miniquake2-network-runtime-types-ml-1235773127.md)
- `miniquake2/qcommon/constants.ml` as `nrlifecycleqc` → [src/miniquake2/qcommon/constants.ml](File-src-miniquake2-qcommon-constants-ml-1976195726.md)
- `miniquake2/qcommon/info.ml` as `nrlifecycleinfo` → [src/miniquake2/qcommon/info.ml](File-src-miniquake2-qcommon-info-ml-634538165.md)
- `miniquake2/qcommon/sizebuf.ml` as `nrlifecycleqsz` → [src/miniquake2/qcommon/sizebuf.ml](File-src-miniquake2-qcommon-sizebuf-ml-1769950759.md)

## Declarations

<a id="function-function-miniquake2-network-runtime-lifecycle-commitserverlevel-function-commitserverlevel-runtime-plan-src-miniquake2-network-runtime-lifecycle-ml-1145059824"></a>
### commitServerLevel

```ml
function commitServerLevel(runtime, plan)
```

Commit server level.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `plan` | `dynamic` | — | plan value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/lifecycle.ml#L90)

<a id="function-function-miniquake2-network-runtime-lifecycle-prepareserverlevel-function-prepareserverlevel-runtime-levelname-src-miniquake2-network-runtime-lifecycle-ml-765561996"></a>
### prepareServerLevel

```ml
function prepareServerLevel(runtime, levelName)
```

Prepare server level.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `levelName` | `dynamic` | — | levelName value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/lifecycle.ml#L48)

<a id="function-function-miniquake2-network-runtime-lifecycle-resetclientlevel-function-resetclientlevel-runtime-src-miniquake2-network-runtime-lifecycle-ml-847161349"></a>
### resetClientLevel

```ml
function resetClientLevel(runtime)
```

Reset client level.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/lifecycle.ml#L135)

- [miniquake2.network.runtime.lifecycle.ServerLevelPlan](Type-miniquake2-network-runtime-lifecycle-serverlevelplan-2106897585.md) — struct
<a id="function-function-miniquake2-network-runtime-lifecycle-transitionpayload-function-transitionpayload-src-miniquake2-network-runtime-lifecycle-ml-856686125"></a>
### transitionPayload

```ml
function transitionPayload()
```

Return the transition payload value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/lifecycle.ml#L38)
